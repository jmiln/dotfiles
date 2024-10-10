# Windows setup

- Run the scripts
    * Install script will install some of the basic stuff that is always there
        - Git, Eza, 7Zip
        - Windows Terminal (For win10 where it's not default)
        - Powershell 7
        - Neovim (And fd for telescope)

    * CreateLinks script will link the configs in this dir over to where they need to be to work
        - The `./wezterm` dir gets linked to `$HOME\.config\wezterm`
        - The Powershell file goes to `$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
        - The `../nvim` dir goes to `$HOME\AppData\Local\nvim`
