self: super: {
  neotest-jdtls = super.vimUtils.buildVimPlugin {
    name = "neotest-jdtls";

    src = super.fetchFromGitHub {
      owner = "atm1020";
      repo = "neotest-jdtls";
      rev = "d4dbb4e27f56444def3dc7771ef4fedd3ddbe17c";
      sha256 = "sha256-FMRRfcJFFVHxWG5PdycaKo2dJjgzh1m6klIqI/39WU0=";
      # sha256 = super.lib.fakeSha256;
    };

    patches = [
      (super.writeText "neotest-jdtls-lsp-patch.patch" ''
        diff --git a/lua/neotest-jdtls/utils/jdtls.lua b/lua/neotest-jdtls/utils/jdtls.lua
        index 5a2db61..09199ff 100644
        --- a/lua/neotest-jdtls/utils/jdtls.lua
        +++ b/lua/neotest-jdtls/utils/jdtls.lua
        @@ -33,8 +33,14 @@ end
         
         function JDTLS.root_dir()
         	-- TODO check why the nio.ls.get_clients is dosent has config property
        -	local client = vim.lsp.get_clients({ name = 'jdtls' })[1]
        -	return client.config.root_dir
        +	local active_clients = {}
        +	if vim.fn.has('nvim-0.10') == 1 then
        +		active_clients = vim.lsp.get_clients({ name = 'jdtls' })
        +	else
        +		active_clients = vim.lsp.get_active_clients({ name = 'jdtls' })
        +	end
        +
        +	return active_clients[1].config.root_dir
         end
         
         ---TODO use this function to execute commands
      '')
    ];

    meta.homepage = "https://github.com/atm1020/neotest-jdtls";
  };
}
