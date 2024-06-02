@echo off
title SpotXRevive -Update SpotX

setlocal enabledelayedexpansion

if exist "%appdata%\spicetify" (
    icacls "%appdata%\spicetify" /reset /T > NUL 2>&1
)

if exist "%localappdata%\spicetify" (
    icacls "%localappdata%\spicetify" /reset /T > NUL 2>&1
)

set respicetify=0
set respotify=0

echo Removing Spicetify if installed...
for %%d in ("%appdata%\spicetify" "%localappdata%\spicetify") do (
    if exist "%%d" (
        rd /s/q "%%d" > NUL 2>&1
        set /a respicetify+=1
    )
)

if !respicetify! == 0 (
    echo Spicetify is not installed or not found.
) else (
    echo Spicetify has been successfully removed.
)

if exist "%localappdata%\Spotify\Update" (
    icacls "%localappdata%\Spotify\Update" /reset /T > NUL 2>&1
)

echo.
echo Uninstalling Spotify[SpotX] if installed...
if exist "%appdata%\Spotify\Spotify.exe" (
    start "" /wait "%appdata%\Spotify\Spotify.exe" /UNINSTALL /SILENT
    set /a respotify+=1
)

timeout /t 1 > NUL 2>&1

for %%d in ("%appdata%\Spotify" "%localappdata%\Spotify") do (
    if exist "%%d" (
        rd /s/q "%%d" > NUL 2>&1
        set /a respotify+=1
    )
)

if exist "%temp%\SpotifyUninstall.exe" (
    del /s /q  "%temp%\SpotifyUninstall.exe" > NUL 2>&1
    set /a respotify+=1
)

if !respotify! == 0 (
    echo Spotify[SpotX] is not installed or not found.
) else (
    echo Spotify[SpotX] has been successfully uninstalled.
)

timeout /t 3 > NUL 2>&1

echo.
:AskInstall
set /p userChoice="Do you want to Install SpotX? (Y/N): "
if /I "%userChoice%" == "Y" (
	echo.
    echo Launching SpotX Installer...
) else if /I "%userChoice%" == "N" (
    echo Exiting the script...
    timeout /t 2 > NUL 2>&1
    exit /b
) else (
	echo.
    echo Invalid choice. Please enter Y or N.
    goto AskInstall
)


set param=-new_theme

set url='https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1'
set url2='https://spotx-official.github.io/run.ps1'
set tls=[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12;

:DownloadAndExecute
set retries=3
set success=0

for /L %%i in (1,1,%retries%) do (
    %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\powershell.exe ^
	-Command %tls% $p='%param%'; """ & { $(try { iwr -useb %url% } catch { $p+= ' -m'; iwr -useb %url2% })} $p """" | iex

    if !errorlevel! == 0 (
        set success=1
        goto :Success
    ) else (
        echo Attempt %%i failed. Retrying in 3 seconds...
        timeout /t 3 > NUL 2>&1
    )
)

:Success
if !success! == 0 (
	echo.
	echo --------------------------------------------------------------------
    echo Failed to download and execute the script after %retries% attempts.
    echo Please check your internet connection and try again.
	echo --------------------------------------------------------------------
	echo.
    timeout /t 3 > NUL 2>&1
    pause
	exit /b
)

echo You can now close this window; it will close automatically in 4 seconds.
timeout /t 4 > NUL 2>&1
exit /b
