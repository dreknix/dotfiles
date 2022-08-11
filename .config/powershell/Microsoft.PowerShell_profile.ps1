# Disable bell
#
Set-PSReadlineOption -BellStyle None

# Set the prompt
#
if ($IsLinux) {
  if ($env:USER -match "^root$") {
    $isAdministrator = $true
  }
  else {
    $isAdministrator = $false
    $isAdministrator = $true
  }
}
elseif ($IsMacOS) {
  Write-Error "macOS is not supported" -ErrorAction Stop
}
elseif ($IsWindows) {
  $isAdministrator = (
    [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
  ).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')
}
function Prompt {
	$currentDir = $pwd.Path.Replace($env:USERPROFILE, "~")

	$prefix = ''
	if ($isAdministrator) {
		$prefix = 'ADMIN: '
	}
	$Host.UI.RawUI.WindowTitle = "$prefix$(Split-Path $currentDir -Leaf)"

	$prompt = '$'
	if ($isAdministrator) {
		$prompt = '#'
	}
	return "`n$currentDir`n$prompt "
}


# Set SolarizedDark
# https://github.com/neilpa/cmd-colors-solarized/blob/master/Set-SolarizedDarkColorDefaults.ps1

# Host Foreground
$Host.PrivateData.ErrorForegroundColor = 'Red'
$Host.PrivateData.WarningForegroundColor = 'Yellow'
$Host.PrivateData.DebugForegroundColor = 'Green'
$Host.PrivateData.VerboseForegroundColor = 'Blue'
$Host.PrivateData.ProgressForegroundColor = 'Gray'

# Host Background
$Host.PrivateData.ErrorBackgroundColor = 'DarkGray'
$Host.PrivateData.WarningBackgroundColor = 'DarkGray'
$Host.PrivateData.DebugBackgroundColor = 'DarkGray'
$Host.PrivateData.VerboseBackgroundColor = 'DarkGray'
$Host.PrivateData.ProgressBackgroundColor = 'Cyan'

# Check for PSReadline
if (Get-Module -ListAvailable -Name "PSReadline") {
    $options = Get-PSReadlineOption

	if ([System.Version](Get-Module PSReadline).Version -lt [System.Version]"2.0.0") {
		# Foreground
		$options.CommandForegroundColor = 'Yellow'
		$options.ContinuationPromptForegroundColor = 'DarkBlue'
		$options.DefaultTokenForegroundColor = 'DarkBlue'
		$options.EmphasisForegroundColor = 'Cyan'
		$options.ErrorForegroundColor = 'Red'
		$options.KeywordForegroundColor = 'Green'
		$options.MemberForegroundColor = 'DarkCyan'
		$options.NumberForegroundColor = 'DarkCyan'
		$options.OperatorForegroundColor = 'DarkGreen'
		$options.ParameterForegroundColor = 'DarkGreen'
		$options.StringForegroundColor = 'Blue'
		$options.TypeForegroundColor = 'DarkYellow'
		$options.VariableForegroundColor = 'Green'

		# Background
		$options.CommandBackgroundColor = 'Black'
		$options.ContinuationPromptBackgroundColor = 'Black'
		$options.DefaultTokenBackgroundColor = 'Black'
		$options.EmphasisBackgroundColor = 'Black'
		$options.ErrorBackgroundColor = 'Black'
		$options.KeywordBackgroundColor = 'Black'
		$options.MemberBackgroundColor = 'Black'
		$options.NumberBackgroundColor = 'Black'
		$options.OperatorBackgroundColor = 'Black'
		$options.ParameterBackgroundColor = 'Black'
		$options.StringBackgroundColor = 'Black'
		$options.TypeBackgroundColor = 'Black'
		$options.VariableBackgroundColor = 'Black'
	} else {
	    # New version of PSReadline renames Foreground colors and eliminates Background
		$options.CommandColor = 'Yellow'
		$options.ContinuationPromptColor = 'DarkBlue'
		$options.DefaultTokenColor = 'DarkBlue'
		$options.EmphasisColor = 'Cyan'
		$options.ErrorColor = 'Red'
		$options.KeywordColor = 'Green'
		$options.MemberColor = 'DarkCyan'
		$options.NumberColor = 'DarkCyan'
		$options.OperatorColor = 'DarkGreen'
		$options.ParameterColor = 'DarkGreen'
		$options.StringColor = 'Blue'
		$options.TypeColor = 'DarkYellow'
		$options.VariableColor = 'Green'
	}
}
