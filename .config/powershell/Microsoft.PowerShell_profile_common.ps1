#
# PowerShell Profile Settings
#
# Inlude this file in your PowerShell profile
# PS> notepad $Profile
# # load common things from dotfiles repository
# . "$env:HOME/.config/powershell/Microsoft.PowerShell_profile_common.ps1"
#

# PowerShell is executed in Shell
if ($host.Name -eq "ConsoleHost")
{
}

# PowerShell is executed in Visual Studio Code
if ($host.Name -eq "VSCode")
{
}

Import-Module posh-git

# use changed oh-my-posh theme paradox
oh-my-posh init pwsh --config "~/.config/powershell/paradox.omp.json" | Invoke-Expression

$env:POSH_GIT_ENABLED = $true

# Disable Bell in PowerShell
Set-PSReadlineOption -BellStyle None

Set-PSReadlineOption -Color @{
    "Command" = "#de935f"
    "Number" = "#8abeb7"
    "String" = "#81a2be"
    "Member" = "b5bd68"
    "Type" = "#cc6666"
    "Parameter" = "#f0c674"
    "Operator" = "#cc6666"
    "Variable" = "#b294bb"
    "Comment" = "#4d5057"
    "ContinuationPrompt" = "#c5c8c6"
    "Default" = "#c5c8c6"
}

# Aliases
#function ls_git { & "C:\Program Files\Git\usr\bin\ls" --color=auto -hF $args }
#Set-Alias -Name ls -Value ls_git -Option AllScope
function ls {
  param(
    [Switch] $lrt
  )
  if ( $lrt ) {
    Get-ChildItem | Sort-Object LastWriteTime
  }
  else {
    Get-ChildItem $args
  }
}
function config_git { git --git-dir=$HOME\.cfg --work-tree=$HOME $args }
New-Alias config config_git
function pwsh_touch { New-Item -Type File -Path $args > $null }
New-Alias touch pwsh_touch
New-Alias which where.exe
New-Alias open ii
function Get-PathOnly
{
  return (Get-Location).Path
}
New-Alias -Force pwd Get-PathOnly
New-Alias vi vim

## Autocompletion
## bash-like autocompletion
Set-PSReadlineKeyHandler -Key Tab -Function Complete
## Shows navigable menu of all options when hitting Tab
#Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
#
## Autocompletion for arrow keys
#Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
#Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
