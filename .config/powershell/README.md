# Windows PowerShell

Include the common PowerShell configuration into current profile:

```powershell
PS> notepad $PROFILE
```

Add the following lines in the beginning of the file:

```powershell
# load common things from dotfiles repository
. "$env:HOME/.config/powershell/Microsoft.PowerShell_profile_common.ps1"
```

Adjust the Oh-My-Posh theme:

```powershell
PS> cp .config/powershell/paradox.omp.json.dist .config/powershell/paradox.omp.json
```

Specify the path for Git, Subversion, Cloud, ... substitution.
