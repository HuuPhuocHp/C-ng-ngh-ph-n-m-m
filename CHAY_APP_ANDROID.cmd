@echo off
setlocal
cd /d "%~dp0"
rem Tim Flutter: PATH, hoac cac thu muc hay dat (cua so mo bang bam dup co the chua nhan PATH moi).
where flutter >nul 2>nul
if not errorlevel 1 goto found
for %%D in ("D:\Android\flutter\bin" "D:\CNPM\flutter\bin" "D:\src\flutter\bin" "C:\src\flutter\bin" "%USERPROFILE%\dev\flutter\bin" "%USERPROFILE%\flutter\bin") do if exist "%%~D\flutter.bat" set "PATH=%%~D;%PATH%"
where flutter >nul 2>nul
if errorlevel 1 goto missing
:found
rem Gradle / Java khong chay duoc khi duong dan co dau tieng Viet (vd: D:\CONG NGHE PHAN MEM).
rem => tao tam mot o dia ao tro vao thu muc cha, chay app tu do (khong doi ten, khong di chuyen gi).
for %%I in ("%~dp0..") do set "PARENT=%%~fI"
for %%I in ("%~dp0.") do set "APPNAME=%%~nxI"
set "DRV="
for %%L in (W X Y Z V U T S R Q) do if not defined DRV if not exist %%L:\ set "DRV=%%L:"
if not defined DRV goto nodrive
subst %DRV% "%PARENT%"
if errorlevel 1 goto nodrive
cd /d %DRV%\%APPNAME%
echo Dang chay tu o dia ao %DRV%\%APPNAME% (tro toi %PARENT%)
goto main
:nodrive
echo Khong tao duoc o dia ao, chay truc tiep tu thu muc hien tai.
set "DRV="
:main
echo Mo Android emulator (hoac cam dien thoai bat USB debugging) roi chay app.
echo Emulator tu dung API http://10.0.2.2:5099. Dien thoai that: chay CHAY_API_LAN.cmd va doi dia chi trong Tai khoan ^> May chu.
call flutter pub get
call flutter run
goto cleanup
:cleanup
cd /d "%~dp0"
if defined DRV subst %DRV% /d
pause
exit /b 0
:missing
echo Chua tim thay Flutter SDK. Xem huong dan trong README_APP.md.
pause
exit /b 1
