:: This script is executed by restic
::
:: Set the environment variable RESTIC_PASSWORD_COMMAND as
:: $env:RESTIC_PASSWORD_COMMAND="get-restic-pw-from-gopass.bat"
::
@ECHO OFF
IF "%RESTIC_PASSWORD_IDENTITY%" == "" (
  ECHO Cant find password, is RESTIC_PASSWORD_IDENTITY exported ? Exiting.
  EXIT 47
)

gopass show --password "%RESTIC_PASSWORD_IDENTITY%"
