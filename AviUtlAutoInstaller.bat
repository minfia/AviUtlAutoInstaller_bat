@rem AviUtl Auto Installer Script by minfia

@rem AviUtl Auto Installer Script�͖��ۏ؂Œ񋟂���܂��B
@rem ���̃v���O�������g�p�������Ŕ��������S�Ă̑��Q�ɂ��ĕۏ؂��܂���B
@rem ���̃v���O���������s����ꍇ�́A�l�b�g���[�N���ڑ����ꂽ�ꏊ�ŁA�o���邾���L���ڑ��Ŏ��s���ĉ������B
@rem �����l�b�g���[�N�̐ڑ�����肭�����Ȃ��ꍇ�͎��Ԃ�u���Ď��s���ĉ������B
@rem ���̍ۂɍ쐬����Ă���AviTul�t�H���_�͎����ō폜���ꂢ�܂����A
@rem �����폜����Ă��Ȃ��ꍇ�͎蓮�ō폜���ĉ������B

@rem AviUtl�y�уv���O�C���A�X�N���v�g�̎g�����͊e���ł��m�F�������B
@rem �\���ꗗ
@rem �EAviUtl + �g���ҏW (by KEN����)
@rem �EL-SMASH Works (by POPn��)
@rem �Ex264GuiEx (by rigaya��)
@rem �EPSDToolKit (by �����Ԏ�)
@rem �E���h�� (by �e�B����)
@rem �E�C���N�i�{�Ђ傤����j(by �e�B����)
@rem �E�����T (by �e�B����)
@rem �E���[����] (by �e�B����)
@rem �E�o�[�j���O�|�C���g2 (by �e�B����)
@rem �E���C���g�[�����n�[�t�g�[�� (by �e�B����)
@rem �EPNG�o�� (by yu_noimage_��)

@echo off
setlocal ENABLEDELAYEDEXPANSION

title AviUtl Auto Installer

echo script version 1.1.1
echo �����AviUtl�̊����\�z����v���O�����ł��B
echo �܂��A��������̍\���ƂȂ�܂��B
echo AviUtl�̃C���X�g�[������t���p�X�Ŏw�肵�Ă��������B
echo �܂��A�p�X�̍Ō��"\"��t���Ȃ��ŉ������A�������܂������܂���B
echo �o�b�`�t�@�C���Ɠ����ꏊ�ɃC���X�g�[������ꍇ��ENTER�������Ă��������B
set /P INSTALL_DIR_PRE="�C���X�g�[����F"

if "%INSTALL_DIR_PRE%"=="" (
set INSTALL_DIR_PRE=%~dp0
set INSTALL_DIR_PRE=!INSTALL_DIR_PRE:~0,-1!
)
set INSTALL_DIR=%INSTALL_DIR_PRE%
set INSTALL_DIR_PRE="""%INSTALL_DIR_PRE%"""

set WGET_VER=1.20
set AVIUTL_ZIP=aviutl100.zip
set EXEDIT_ZIP=exedit92.zip
set LSMASH_VER=r935-2
set LSMASH_ZIP=L-SMASH_Works_%LSMASH_VER%_plugins.zip
set X264GUIEX_VER=2.59
set X264GUIEX_ZIP=x264guiEx_%X264GUIEX_VER%.zip
set PSDTOOLKIT_VER=v0.2beta35
set PSDTOOLKIT_ZIP=psdtoolkit_%PSDTOOLKIT_VER%.zip

@rem AviUtl�f�B���N�g����
set AVIUTL_DIR_NAME=AviUtl
@rem �t�@�C���̈ꎞ�f�B���N�g����
set DL_DIR_NAME=DL_TEMP
@rem plugins�f�B���N�g����
set PLUGINS_DIR_NAME=plugins
@rem figure�f�B���N�g����
set FIGURE_DIR_NAME=figure
@rem script�f�B���N�g����
set SCRIPT_DIR_NAME=script
@rem 7z�f�B���N�g����
set SVZIP_DIR_NAME=7z
@rem wget�f�B���N�g����
set WGET_DIR_NAME=wget

@rem AviUtl�f�B���N�g���쐬
set AVIUTL_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%
mkdir %AVIUTL_DIR_MK%
@rem �t�@�C���̈ꎞ�f�B���N�g���쐬
set DL_TEMP_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%DL_DIR_NAME%
mkdir %DL_TEMP_DIR_MK%
@rem plugins�f�B���N�g���쐬
set PLUGINS_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%
mkdir %PLUGINS_DIR_MK%
@rem figure�f�B���N�g���쐬
set FIGURE_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%\%FIGURE_DIR_NAME%
mkdir %FIGURE_DIR_MK%
@rem script�f�B���N�g���쐬
set SCRIPT_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%\%SCRIPT_DIR_NAME%
mkdir %SCRIPT_DIR_MK%
@rem 7z�f�B���N�g���쐬
set SVZIP_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%SVZIP_DIR_NAME%
mkdir %SVZIP_DIR_MK%
@rem wget�f�B���N�g���쐬
set WGET_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%WGET_DIR_NAME%
mkdir %WGET_DIR_MK%

@rem AviUtl�f�B���N�g��
set AVIUTL_DIR=%INSTALL_DIR%\AviUtl
@rem �t�@�C���̈ꎞ�f�B���N�g��
set DL_DIR=%AVIUTL_DIR%\DL_TEMP
@rem plugins�f�B���N�g��
set PLUGINS_DIR=%AVIUTL_DIR%\plugins
@rem figure�f�B���N�g��
set FIGURE_DIR=%PLUGINS_DIR%\figure
@rem script�f�B���N�g��
set SCRIPT_DIR=%PLUGINS_DIR%\script
@rem 7z�̓W�J�f�B���N�g��
set SVZIP_DIR=%AVIUTL_DIR%\7z
@rem wget�̓W�J�f�B���N�g��
set WGET_DIR=%AVIUTL_DIR%\wget


@rem 7z�̊��\�z
echo 7z�̃_�E�����[�h...
powershell -Command "(new-object System.Net.WebClient).DownloadFile(\"https://ja.osdn.net/frs/redir.php?m=jaist^&f=sevenzip%%2F70468%%2F7z1806.msi\",\"%DL_DIR%\7z.msi\")"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
echo 7z�̃_�E�����[�h����
@rem DL����7z��W�J
echo 7z�̓W�J...
msiexec /a "%DL_DIR%\7z.msi" targetdir="%SVZIP_DIR%" /qn
@rem 7z.exe��ϐ��Ɋi�[
set SZEXE="%SVZIP_DIR%\Files\7-Zip\7z.exe"
echo 7z�̓W�J����

@rem wget�̊��\�z
echo wget�̃_�E�����[�h...
powershell -Command "(new-object System.Net.WebClient).DownloadFile(\"https://eternallybored.org/misc/wget/%WGET_VER%/32/wget.exe\",\"%WGET_DIR%\wget.exe\")"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
echo wget�̃_�E�����[�h����
@rem wget.exe��ϐ��Ɋi�[
set WGETEXE="%WGET_DIR%\wget.exe"


@rem ��{���\�z
@rem ��{�t�@�C����DL
%WGETEXE% http://spring-fragrance.mints.ne.jp/aviutl/%AVIUTL_ZIP% -O "%DL_DIR%\%AVIUTL_ZIP%"
%WGETEXE% http://spring-fragrance.mints.ne.jp/aviutl/%EXEDIT_ZIP% -O "%DL_DIR%\%EXEDIT_ZIP%"
%WGETEXE% --no-check-certificate https://pop.4-bit.jp/bin/l-smash/%LSMASH_ZIP% -O "%DL_DIR%\%LSMASH_ZIP%"
%WGETEXE% --no-check-certificate https://drive.google.com/uc?id=10RpwYSiSjjp4f0uIEOQzGuc1YOVF24u_ -O "%DL_DIR%\%X264GUIEX_ZIP%"

@rem AviUtl�̓W�J
%SZEXE% x "%DL_DIR%\%AVIUTL_ZIP%" -aoa -o"%AVIUTL_DIR%"

@rem LargeAddressAware��L����
echo AviUtl��LargeAddressAware��L���ɂ��܂�(����ɂ�1���قǂ�����܂�)
echo 0%%����
powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -first 262 | Set-Content -en byte \"%AVIUTL_DIR%\A-1.bin\""
echo 25%%����
powershell -Command "[System.Text.Encoding]::ASCII.GetBytes(\"/\") | Set-Content -en byte \"%AVIUTL_DIR%\A-12.bin\""
echo 50%%����
powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -last 487161 | Set-Content -en byte \"%AVIUTL_DIR%\A-2.bin\""
echo 75%%����
copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.exe"
del "%AVIUTL_DIR%"\*.bin
echo 100%%����

@rem AviUtl�̐ݒ�t�@�C���𐶐�����
call :EXEC_AVIUTL

@rem aviutl�̐ݒ�t�@�C����ҏW
@rem �ύX���e
@rem �ő�摜�T�C�Y(1280x720 -> 2200x1200)
@rem �L���b�V���t���[����(8 -> 32)
@rem ���T�C�Y�𑜓x���X�g(1920x1080��ǉ�)
@rem �Đ��E�B���h�E�����C���E�B���h�E�ɕ\������(���� -> �L��)
powershell -Command "Get-Content -en string \"%AVIUTL_DIR%\aviutl.ini\" | Select-Object -first 189 | Set-Content -en string \"%AVIUTL_DIR%\A-1.bin\""
powershell -Command "echo "width=2200`r`nheight=1200`r`nframe=320000`r`ncache=32^
`r`nmoveA=5`r`nmoveB=30`r`nmoveC=899`r`nmoveD=8991`r`nsaveunitsize=4096`r`ncompprofile=1`r`nplugincache=1^
`r`nstartframe=1`r`nshiftselect=1`r`nyuy2mode=0`r`nmovieplaymain=1`r`nvfplugin=1`r`nyuy2limit=0`r`neditresume=0`r`nfpsnoconvert=0^
`r`ntempconfig=0`r`nload30fps=0`r`nloadfpsadjust=0`r`noverwritecheck=0`r`ndragdropdialog=0`r`nopenprojectaup=1`r`nclosedialog=1^
`r`nprojectonfig=0`r`nwindowsnap=0`r`ndragdropactive=1`r`ntrackbarclick=1`r`ndefaultsavefile=%%p`r`nfinishsound=^
`r`nresizelist=1920x1080`,1280x720`,640x480`,352x240`,320x240^
`r`nfpslist=*`,30000/1001`,24000/1001`,60000/1001`,60`,50`,30`,25`,24`,20`,15`,12`,10`,8`,6`,5`,4`,3`,2`,1^
`r`nsse=1`r`nsse2=1" | Set-Content -en string \"%AVIUTL_DIR%\A-12.bin\""
powershell -Command "Get-Content -en string \"%AVIUTL_DIR%\aviutl.ini\" | Select-Object -last 25 | Set-Content -en string \"%AVIUTL_DIR%\A-2.bin\""
copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.ini"
del "%AVIUTL_DIR%"\*.bin

@rem �v���O�C���Ȃǂ�W�J
%SZEXE% x "%DL_DIR%\%EXEDIT_ZIP%" -aoa -o"%PLUGINS_DIR%"
%SZEXE% x "%DL_DIR%\%LSMASH_ZIP%" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\lw*.*" "%PLUGINS_DIR%"
%SZEXE% x "%DL_DIR%\%X264GUIEX_ZIP%" -aoa -o"%TEMP%"
"%TEMP%\x264guiEx_%X264GUIEX_VER%\auo_setup.exe" -autorun -nogui -dir "%AVIUTL_DIR%"
rmdir /s /q %TEMP%\x264guiEx_%X264GUIEX_VER%


@rem ����������\�z
@rem �ꎞ�f�B���N�g�����č쐬
rmdir /s /q "%DL_DIR%"
mkdir %INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%DL_DIR_NAME%

@rem ��������t�@�C����DL
%WGETEXE% https://github.com/oov/aviutl_psdtoolkit/releases/download/%PSDTOOLKIT_VER%/%PSDTOOLKIT_ZIP% -O "%DL_DIR%\%PSDTOOLKIT_ZIP%"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem ���h��
%WGETEXE% https://tim3.web.fc2.com/script/WindShk.zip -O "%DL_DIR%\WindShk.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem �C���N�i�{�Ђ傤����j
%WGETEXE% https://tim3.web.fc2.com/script/InkV2.zip -O "%DL_DIR%\InkV2.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem �����T
%WGETEXE% https://tim3.web.fc2.com/script/Framing.zip -O "%DL_DIR%\Framing.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem ���[����]
%WGETEXE% https://tim3.web.fc2.com/script/ReelRot.zip -O "%DL_DIR%\ReelRot.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem �o�[�j���O�|�C���g2
%WGETEXE% https://tim3.web.fc2.com/script/VanishP2_V2.zip -O "%DL_DIR%\VanishP2_V2.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem ���C���g�[�����n�[�t�g�[��
%WGETEXE% https://tim3.web.fc2.com/script/LinHal.zip -O "%DL_DIR%\LinHal.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem PNG�o��
%WGETEXE% http://auls.client.jp/plugin/auls_outputpng.zip -O "%DL_DIR%\auls_outputpng.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)

@rem PSDToolKit��W�J
%SZEXE% x "%DL_DIR%\%PSDTOOLKIT_ZIP%" -aoa -o"%PLUGINS_DIR%"
mkdir %INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\PSDToolKit�̐����t�@�C���Q
@move "%PLUGINS_DIR%\PSDToolKitDocs" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
@move "%PLUGINS_DIR%\*.txt" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
@move "%PLUGINS_DIR%\*.html" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
@move "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q\exedit.txt" "%PLUGINS_DIR%"
@move "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q\lua.txt" "%PLUGINS_DIR%"

@rem �e�B�����̃X�N���v�g��W�J
set TIM3_DIR_MK=%SCRIPT_DIR_MK%\�e�B����
mkdir %TIM3_DIR_MK%
set TIM3_DIR=%SCRIPT_DIR%\�e�B����
%SZEXE% x "%DL_DIR%\WindShk.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\InkV2.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\Framing.zip" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\Framing\*.*" "%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\ReelRot.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\VanishP2_V2.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\LinHal.zip" -aoa -o"%TIM3_DIR%"

@rem yu_noimage_���̃v���O�C����W�J
%SZEXE% x "%DL_DIR%\auls_outputpng.zip" -aoa -o"%DL_DIR%"
@move  "%DL_DIR%\auls_outputpng\*.auf" "%PLUGINS_DIR%"

@rem ���܂ŃC���X�g�[�������v���O�C���A�X�N���v�g��aviutl.ini�ɔ��f
call :EXEC_AVIUTL


@rem ��n��
rmdir /s /q "%DL_DIR%"
rmdir /s /q "%SVZIP_DIR%"
rmdir /s /q "%WGET_DIR%"

echo msgbox "�C���X�g�[�����������܂���",vbInformation,"���" > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
del %TEMP%\msgbox.vbs
for /F "usebackq tokens=1" %%a in (`tasklist /fi "IMAGENAME eq aviutl.exe"`) do @set AVIUTL_EXE=%%a
if /i not %AVIUTL_EXE%==aviutl.exe (
goto SEARCH_EXE
)
exit

@rem �ȉ��A�T�u���[�`��

:EXEC_AVIUTL
start "" "%AVIUTL_DIR%\aviutl.exe"
timeout /t 2 /nobreak >nul
call :KILL_AVIUTL
taskkill /im aviutl.exe
exit /b

:KILL_AVIUTL
for /F "usebackq tokens=1" %%a in (`tasklist /fi "IMAGENAME eq aviutl.exe"`) do @set AVIUTL_EXE=%%a
    if /i not !AVIUTL_EXE!==aviutl.exe (
    goto SEARCH_EXE
)
exit /b

:CONNECT_ERROR
echo msgbox "�t�@�C���̃_�E�����[�h�Ɏ��s���܂���",vbCritical,"�G���[" > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
del %TEMP%\msgbox.vbs
rmdir /s /q "%AVIUTL_DIR%"
exit /b

@rem �����[�X�m�[�g
@rem 2019/3/26
@rem     PSDToolKit�̃o�[�W�����ύX�ɑΉ�
@rem 2019/3/2
@rem     �󔒕�������ł��C���X�g�[���ł���悤�ɏC��
@rem     �^�X�N�L���̊m�������A�b�v
@rem     ���s��Ԃ̕\����ǉ�
@rem     �_�E�����[�h���s���Ƀ��b�Z�[�W�E�B���h�E��\������悤�ɕύX
@rem 2019/2/24
@rem     ���񃊃��[�X