{ lib, pkgs, ... }:
let
  caddyRootCertificate = "/var/lib/caddy-localhost-proxies/pki/authorities/local/root.crt";

  caddyConfig = pkgs.writeText "Caddyfile-localhost-proxies" ''
    {
    	storage file_system /var/lib/caddy-localhost-proxies
    }

    full-text-rss.localhost {
    	tls internal
    	reverse_proxy 127.0.0.1:9907
    }

    wallabag.localhost {
    	tls internal
    	reverse_proxy 127.0.0.1:9908
    }

    syncthing.localhost {
    	tls internal
    	reverse_proxy 127.0.0.1:8384
    }

    freshrss.localhost {
    	tls internal
    	reverse_proxy freshrss.local
    }
  '';
in
{
  environment.systemPackages = [ pkgs.caddy ];

  system.activationScripts.postActivation.text = lib.mkAfter ''
    caddy_root_cert=${caddyRootCertificate}
    system_keychain=/Library/Keychains/System.keychain

    if [ -r "$caddy_root_cert" ]; then
      echo "Trusting Caddy localhost root CA in the System keychain..."
      /usr/bin/security add-trusted-cert \
        -d \
        -r trustRoot \
        -p ssl \
        -k "$system_keychain" \
        "$caddy_root_cert"
    else
      echo "Caddy localhost root CA does not exist yet; visit a Caddy localhost site, then rerun darwin-rebuild switch."
    fi
  '';

  launchd.daemons.caddy-localhost-proxies = {
    environment = {
      HOME = "/var/lib/caddy-localhost-proxies";
      XDG_CONFIG_HOME = "/var/lib/caddy-localhost-proxies/config";
      XDG_DATA_HOME = "/var/lib/caddy-localhost-proxies/data";
    };

    script = ''
      mkdir -p /var/log/caddy-localhost-proxies /var/lib/caddy-localhost-proxies
      chmod 755 /var/log/caddy-localhost-proxies /var/lib/caddy-localhost-proxies
      touch /var/log/caddy-localhost-proxies/stdout.log /var/log/caddy-localhost-proxies/stderr.log
      chmod 644 /var/log/caddy-localhost-proxies/stdout.log /var/log/caddy-localhost-proxies/stderr.log
      exec ${pkgs.caddy}/bin/caddy run --config ${caddyConfig} --adapter caddyfile
    '';

    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/caddy-localhost-proxies/stdout.log";
      StandardErrorPath = "/var/log/caddy-localhost-proxies/stderr.log";
    };
  };
}
