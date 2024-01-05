
@echo off
set errorlevel=
if "%~1"=="bcp" goto play
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
echo;
echo;Install Tasks
echo;&pause
schtasks -create -tn "CDBF\CDBFTasks" -xml "%~dp0CDBFTasks.xml"
:re
echo;
echo;Set Mode
choice /c ab /m "Local=A  SMB_Wake=B"
if %errorlevel%==1 schtasks -change -tn "CDBF\CDBFTasks" -tr "wscript '%~dp0START.vbs' sr"&goto sk
schtasks -change -tn "CDBF\CDBFTasks" -tr "schtasks -change -tn \CDBF\Smbup -enable"
if %errorlevel%==0 schtasks -create -tn "CDBF\Smbup" -tr "wscript '%~dp0START.vbs' sr" -rl highest -f -delay 0003:00 -sc onevent -ec microsoft-windows-smbclient/connectivity -mo *[system/eventid=30800]
:sk
if errorlevel 1 goto re
schtasks -change -tn "\CDBF\Smbup" -disable >nul 2>nul
echo;&pause
exit
:play
::备份保存路径👇【PAT=？】
set PAT=%~dp0
echo;%pat%\ >errlog.log
dir "%pat%\" 2>>errlog.log
if errorlevel 1 "%~dp0start.vbs" err&exit
call :lck %* 3>>%0
:lck
cd /d "%~dp0" 2>>errlog.log
schtasks -change -tn "\CDBF\Smbup" -disable
set cdate=%date:~0,4%%date:~5,2%%date:~8,2%
set ct=%cdate%\%time:~0,2%.%time:~3,2%.%time:~6,2%
set userd=%pat%\userdata\%cdate%
::save备份保留份数【SKIP=？】按日期
for /f "delims=" %%a in (CDBF.ini) do (
xcopy "%%a" "%pat%\save\%%~nxa\%ct%\%%~nxa\" /h /f /y /i /s /k /z /exclude:CDBF_NO.ini 2>>errlog.log
for /f "SKIP=10 delims=" %%i in ('dir /b /ad /o-n "%pat%\save\%%~nxa"') do (rd /s /q "%pat%\save\%%~nxa\%%i")
)
for /f "delims=" %%a in ('dir /b /ad "%pat%\userdata"') do set /a datep=%cdate%-%%a
if "%datep%"=="" goto userdata
::UserData最短备👇份频率【LEQ ？】100=1个月
if %datep% LEQ 200 exit
:UserData
xcopy "%localappdata%\Microsoft\Edge\User Data\Default\*.*" "%userd%\edge" /i /h /z
xcopy "%appdata%\Microsoft\Crypto" "%userd%\syskey\Crypto" /h /i /g /e /z
xcopy "%appdata%\Microsoft\Protect" "%userd%\syskey\Protect" /h /i /g /e /z
xcopy "%appdata%\Microsoft\SystemCertificates" "%userd%\syskey\SystemCertificates" /h /i /g /e /z
exit
