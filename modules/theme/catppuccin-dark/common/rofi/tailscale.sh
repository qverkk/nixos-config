#!/usr/bin/env bash

# TODO: Add option to ssh into a machine
# Add option to send files from a thunar popup or something

# Command output
command_output=$(tailscale status --json=true --self=false)

# Extracting required fields
if [[ -n "$command_output" ]]; then
    peers=$(echo "$command_output" | jq -r '.Peer')

    # Sort peers by status (online first, offline second) and then by name
    sorted_peers=$(echo "$command_output" | jq -r '.Peer | to_entries | sort_by((.value.Online | not), .value.HostName) | .[].key')

    for peer in $sorted_peers; do
        hostname=$(echo "$peers" | jq -r ".\"$peer\".HostName")
        os=$(echo "$peers" | jq -r ".\"$peer\".OS")
        ipv4=$(echo "$peers" | jq -r ".\"$peer\".TailscaleIPs[0]")
        online=$(echo "$peers" | jq -r ".\"$peer\".Online")
        exitnodeoption=$(echo "$peers" | jq -r ".\"$peer\".ExitNodeOption")

        printf "%-15s %-20s %-10s %-15s %-10s\n" "$ipv4" "$hostname" "$os" "$exitnodeoption" "$online"
    done
else
    echo "No output from the command."
fi
