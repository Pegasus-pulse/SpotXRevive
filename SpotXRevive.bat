@echo off
title SpotXRevive -Update SpotX

setlocal enabledelayedexpansion

if exist "%localappdata%\Spotify\Update" (
    icacls "%localappdata%\Spotify\Update" /reset /T > NUL 2>&1
)

set actions=0

echo Checking if Spotify is installed or not... 
if exist "%appdata%\Spotify\Spotify.exe" (
    start "" /wait "%appdata%\Spotify\Spotify.exe" /UNINSTALL /SILENT
    set /a actions+=1
)

timeout /t 1 > NUL 2>&1

for %%d in ("%appdata%\Spotify" "%localappdata%\Spotify") do (
    if exist "%%d" (
        rd /s/q "%%d" > NUL 2>&1
        set /a actions+=1
    )
)

if exist "%temp%\SpotifyUninstall.exe" (
    del /s /q  "%temp%\SpotifyUninstall.exe" > NUL 2>&1
    set /a actions+=1
)

if !actions! == 0 (
    echo Spotify is not installed or not found.
) else (
    echo Spotify has been successfully uninstalled.
)

timeout /t 3 > NUL 2>&1

echo.
echo Do you want to Install SpotX? (Y/N)
set /p userChoice=Enter your choice: 

if /I "%userChoice%" NEQ "Y" (
    echo Exiting the script...
    timeout /t 2 > NUL 2>&1
    exit /b
)

set param=-new_theme

set url='https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1'
set url2='https://spotx-official.github.io/run.ps1'
set tls=[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe ^
-Command %tls% $p='%param%'; """ & { $(try { iwr -useb %url% } catch { $p+= ' -m'; iwr -useb %url2% })} $p """" | iex

echo You can now close this window; it will close automatically in 4 seconds.
timeout /t 4 > NUL 2>&1
exit /b
