@echo off
CD /D %~d0%~p0

SET RS_UTILITY_PATH="D:\Program Files (x86)\Microsoft SQL Server\110\Tools\Binn\rs.exe"
SET SERVER=localhost
SET BACKUP_DIR="D:\Backup_Reports"
SET DEPLOY_DIR="%CD%\Deploy"

SET USE_PASSWORD=0
SET USER=
SET PASS=



FOR %%A IN (%DEPLOY_DIR%\*.*) DO SET PACK_NAME=%%~nA
FOR %%A IN (%DEPLOY_DIR%\*.*) DO SET PACK_DIR=%%~dA%%~pA
FOR %%A IN (%DEPLOY_DIR%\*.*) DO SET PACK_FULLPATH=%%~A



::Get date and time in format YYYYMMDDHHMM
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
SET DATETIME=%datetime:~0,12%


::Exctrat the package in same directory
7za.exe x %PACK_FULLPATH% -aoa -o%PACK_DIR%
echo --

IF %USE_PASSWORD%==0 %RS_UTILITY_PATH% -i DeployReports.rss -s http://%SERVER%/Reportserver -v BACKUP_DIR=%BACKUP_DIR%\%DATETIME%_%PACK_NAME% -v DEPLOY_DIR=%DEPLOY_DIR%
IF %USE_PASSWORD%==1 %RS_UTILITY_PATH% -i DeployReports.rss -s http://%SERVER%/Reportserver -v BACKUP_DIR=%BACKUP_DIR%\%DATETIME%_%PACK_NAME% -v DEPLOY_DIR=%DEPLOY_DIR% -u %USER% -p %PASS%


::Empty the directory , removing and re-creating
rmdir /s /q %DEPLOY_DIR% 
mkdir %DEPLOY_DIR% 