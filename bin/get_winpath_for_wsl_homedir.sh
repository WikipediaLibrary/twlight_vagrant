#!/usr/bin/env bash

# Checks to see if this is a WSL environment;
# If true, it fetches the path for the WSL filesystem from the windows registry
# and concatenates that with the WSL home directory and prints the result.
# Logic for check pulled from https://stackoverflow.com/a/43618657
if grep -qE "(Microsoft|WSL)" /proc/version &> /dev/null ; then
  echo "Path to WSL home directory in Windows 10:"
  ubuntu_homedir=$(powershell.exe -Command '$WSLREGKEY="HKCU:\Software\Microsoft\Windows\CurrentVersion\Lxss"; $WSLDEFID=(Get-ItemProperty "$WSLREGKEY").DefaultDistribution; (Get-ItemProperty "$WSLREGKEY\$WSLDEFID").BasePath | Write-Host')
ubuntu_homedir=${ubuntu_homedir}'\rootfs\'${USER}
  echo ${ubuntu_homedir}
else
  echo "Not a WSL environment."
fi
