@rem AviUtl Auto Installer Script by minfia

@rem AviUtl Auto Installer Script�͖��ۏ؂Œ񋟂���܂��B
@rem ���̃v���O�������g�p�������Ŕ��������S�Ă̑��Q�ɂ��ĕۏ؂��܂���B
@rem ���̃v���O�����́APowerShell3.0�ȏオ�Ώۂł��B
@rem ���̃v���O���������s����ꍇ�́A�l�b�g���[�N���ڑ����ꂽ�ꏊ�ŁA�o���邾���L���ڑ��Ŏ��s���ĉ������B
@rem �����l�b�g���[�N�̐ڑ�����肭�����Ȃ��ꍇ�͎��Ԃ�u���Ď��s���ĉ������B
@rem ���̍ۂɍ쐬����Ă���AviUtl�t�H���_�͎����ō폜����܂����A
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
@rem �E�o�j�V���O�|�C���g2 (by �e�B����)
@rem �E���C���g�[�����n�[�t�g�[�� (by �e�B����)
@rem �EPNG�o�� (by yu_noimage_��)

@echo off
setlocal ENABLEDELAYEDEXPANSION

title AviUtl Auto Installer

set SCRIPT_VER=3.2.0

@rem PowerShell�̃o�[�W�����`�F�b�N(3�ȏ�)
for /f "usebackq" %%a in (`powershell -Command "(Get-Host).version"`) do (
    set PSVER=%%a
)
if not %PSVER% geq 3 (
    call :SHOW_MSG "PowerShell�̃o�[�W������3�ȏ�ł���K�v������܂�" vbCritical "�G���[" "modal"
    exit
)

@rem ���s�O��AviUtl���N�����Ă����ꍇ�ɃG���[
call :SEARCH_EXE
if %ERRORLEVEL% equ 0 (
    call :SHOW_MSG "AviUtl���N������Ă��܂��AAviUtl���I�����Ă�������" vbCritical "�G���[" "modal"
    exit
)

set DL_RETRY=3
set X264GUIEX_VER=2.59
set X264GUIEX_ZIP=x264guiEx_%X264GUIEX_VER%.7z

@rem �o�b�`�t�@�C�����s���̏����I��
@rem 0:�C���X�g�[�� 1:�A�b�v�f�[�g
set SEL_UPDATE=0
@rem �e�X�g��AviUtl�C���X�g�[���t���O
set INSTALL_AVIUTL_RC_FLAG=0

@rem �R�}���h���C���I�v�V��������
:OPTION
    if not "%1"=="" (
        if "%1"=="--rc" (
            set INSTALL_AVIUTL_RC_FLAG=1
        )else if "%1"=="--help" (
            goto :HELP
        ) else if "%1"=="--version" (
            echo version: %SCRIPT_VER%
            exit /b
        ) else (
            goto :HELP
        )
        shift /1
        goto :OPTION
    )


where aviutl.exe > nul 2>&1
if %ERRORLEVEL% equ 0 (
    set SEL_UPDATE=1
    goto :UPDATE
) else (
    goto :INSATALL
)


@rem �A�b�v�f�[�g����
:UPDATE
@rem �A�b�v�f�[�g�ꗗ�i�[�z��
set UPDATE_LIST=
@rem �A�b�v�f�[�g���s���[�`���ꗗ�i�[�z��
set UPDATE_ROUTINE_LIST=
@rem UPDATE_LIST�̗v�f��
set UPDATE_LIST_CNT=-1

@rem �f�B���N�g���̐ݒ�
@rem �J�����g�f�B���N�g��
set INSTALL_DIR_PRE=%~dp0
set INSTALL_DIR_PRE=!INSTALL_DIR_PRE:~0,-1!
set INSTALL_DIR=%INSTALL_DIR_PRE%
set INSTALL_DIR_PRE="""%INSTALL_DIR_PRE%"""

@rem ��Ɗ��\�z
call :WORKING_ENV_SETUP

@rem AviUtl�̃A�b�v�f�[�g�`�F�b�N
call :AVIUTL_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "AviUtl" ":AVIUTL_INSTALL"

@rem �g���ҏW�̃A�b�v�f�[�g�`�F�b�N
call :EXEDIT_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "�g���ҏW" ":EXEDIT_INSTALL"

@rem PSDToolkit�̃A�b�v�f�[�g
call :PSDTOOLKIT_GET_LATEST_VER
call :PSDTOOLKIT_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "PSDToolkit" ":PSDTOOLKIT_INSTALL"

if %UPDATE_LIST_CNT% lss 0 (
    call :CLEANUP
    call :SHOW_MSG "�A�b�v�f�[�g�͂���܂���" vbInformation "���" "modal"
    exit
) else (
    echo �A�b�v�f�[�g�Ώۂ͈ȉ��ɂȂ�܂�
    for /l %%i in (0,1,%UPDATE_LIST_CNT%) do (
        echo �E!UPDATE_LIST[%%i]!
    )
    @rem �A�b�v�f�[�g�m�F
    set /p UPDATE_SUCCESS="�A�b�v�f�[�g���s���܂����H(Y/N)�F"
    if /i not !UPDATE_SUCCESS!==Y (
        call :CLEANUP
        call :SHOW_MSG "�A�b�v�f�[�g�𒆎~���܂���" vbInformation "���" "modal"
        exit
    )
)

for /l %%i in (0,1,%UPDATE_LIST_CNT%) do (
    call !UPDATE_ROUTINE_LIST[%%i]!
)
call :X264GUIEX_INSTALL

call :CLEANUP
call :SHOW_MSG "�A�b�v�f�[�g���������܂���" vbInformation "���" "modal"

exit


@rem �C���X�g�[������
:INSATALL
echo script version %SCRIPT_VER%
echo �����AviUtl�̊����\�z����v���O�����ł��B
echo �܂��A��������̍\���ƂȂ�܂��B
echo AviUtl�̃C���X�g�[������t���p�X�Ŏw�肵�Ă��������B
echo �܂��A�p�X�̍Ō��"\"��t���Ȃ��ŉ������A���܂������܂���B
echo �o�b�`�t�@�C���Ɠ����ꏊ�ɃC���X�g�[������ꍇ��ENTER�������Ă��������B
set /P INSTALL_DIR_PRE="�C���X�g�[����F"

if "%INSTALL_DIR_PRE%"=="" (
set INSTALL_DIR_PRE=%~dp0
set INSTALL_DIR_PRE=!INSTALL_DIR_PRE:~0,-1!
)
set INSTALL_DIR=%INSTALL_DIR_PRE%
set INSTALL_DIR_PRE="""%INSTALL_DIR_PRE%"""

set LSMASH_VER=r935-2
set LSMASH_ZIP=L-SMASH_Works_%LSMASH_VER%_plugins.zip

@rem ��Ɗ��\�z
call :WORKING_ENV_SETUP

echo AviUtl�̃C���X�g�[��
call :AVIUTL_GET_LATEST_VER_DATE
call :AVIUTL_INSTALL

@rem AviUtl�̐ݒ�t�@�C���𐶐�����
call :EXEC_AVIUTL
timeout /t 3 /nobreak > nul
:SEARCH_INI
    for %%a in (aviutl.ini) do @set INI_FILE=%%a
    if /i not !INI_FILE!==aviutl.ini (
        goto SEARCH_INI
    )

@rem aviutl�̐ݒ�t�@�C����ҏW
@rem �ύX���e
@rem �ő�摜�T�C�Y(1280x720 -> 2200x1200)
@rem �L���b�V���t���[����(8 -> 32)
@rem ���T�C�Y�𑜓x���X�g(1920x1080��ǉ�)
@rem �Đ��E�B���h�E�����C���E�B���h�E�ɕ\������(���� -> �L��)
call :FILE_SEARCH_STR "%AVIUTL_DIR%\aviutl.ini" "[system]"
set SYSTEM_POS=%ERRORLEVEL%
call :FILE_LINE_CNT "%AVIUTL_DIR%\aviutl.ini"
set LINE=%ERRORLEVEL%
set /a TAILE=LINE-SYSTEM_POS
powershell -Command "Get-Content -en string \"%AVIUTL_DIR%\aviutl.ini\" | Select-Object -first %SYSTEM_POS% | Set-Content -en string \"%AVIUTL_DIR%\A-1.bin\""
powershell -Command "echo "width=2200`r`nheight=1200`r`nframe=320000`r`ncache=32^
`r`nmoveA=5`r`nmoveB=30`r`nmoveC=899`r`nmoveD=8991`r`nsaveunitsize=4096`r`ncompprofile=1`r`nplugincache=1^
`r`nstartframe=1`r`nshiftselect=1`r`nyuy2mode=0`r`nmovieplaymain=1`r`nvfplugin=1`r`nyuy2limit=0`r`neditresume=0`r`nfpsnoconvert=0^
`r`ntempconfig=0`r`nload30fps=0`r`nloadfpsadjust=0`r`noverwritecheck=0`r`ndragdropdialog=0`r`nopenprojectaup=1`r`nclosedialog=0^
`r`nprojectonfig=0`r`nwindowsnap=0`r`ndragdropactive=1`r`ntrackbarclick=1`r`ndefaultsavefile=%%p`r`nfinishsound=^
`r`nresizelist=1920x1080`,1280x720`,640x480`,352x240`,320x240^
`r`nfpslist=*`,30000/1001`,24000/1001`,60000/1001`,60`,50`,30`,25`,24`,20`,15`,12`,10`,8`,6`,5`,4`,3`,2`,1^
`r`nsse=1`r`nsse2=1" | Set-Content -en string \"%AVIUTL_DIR%\A-12.bin\""
powershell -Command "Get-Content -en string \"%AVIUTL_DIR%\aviutl.ini\" | Select-Object -last %TAILE% | Set-Content -en string \"%AVIUTL_DIR%\A-2.bin\""
copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.ini"
del "%AVIUTL_DIR%"\*.bin

echo �g���ҏW�̃C���X�g�[��
call :EXEDIT_GET_LATEST_VER_DATE
call :EXEDIT_INSTALL

echo L-SMASH�̃_�E�����[�h...
call :FILE_DOWNLOAD "https://pop.4-bit.jp/bin/l-smash/%LSMASH_ZIP%" "%DL_DIR%\%LSMASH_ZIP%"
echo L-SMASH�̃_�E�����[�h����

@rem �v���O�C���Ȃǂ�W�J
%SZEXE% x "%DL_DIR%\%LSMASH_ZIP%" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\lw*.*" "%PLUGINS_DIR%"
call :X264GUIEX_INSTALL


@rem ����������\�z
@rem ��������t�@�C����DL
@rem PSDToolkit
set PSDTOOLKIT_VER=
call :PSDTOOLKIT_GET_LATEST_VER
call :PSDTOOLKIT_INSTALL

@rem ���h��
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/WindShk.zip"  "%DL_DIR%\WindShk.zip"

@rem �C���N�i�{�Ђ傤����j
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/InkV2.zip" "%DL_DIR%\InkV2.zip"

@rem �����T
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/Framing.zip" "%DL_DIR%\Framing.zip"

@rem ���[����]
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/ReelRot.zip" "%DL_DIR%\ReelRot.zip"

@rem �o�j�V���O�|�C���g2
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/VanishP2_V2.zip" "%DL_DIR%\VanishP2_V2.zip"

@rem ���C���g�[�����n�[�t�g�[��
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/LinHal.zip" "%DL_DIR%\LinHal.zip"

@rem PNG�o��
call :FILE_DOWNLOAD "http://auls.client.jp/plugin/auls_outputpng.zip" "%DL_DIR%\auls_outputpng.zip"


@rem �e�B�����̃X�N���v�g��W�J
set TIM3_DIR_MK=%SCRIPT_DIR_MK%\�e�B����
mkdir %TIM3_DIR_MK%
set TIM3_DIR=%SCRIPT_DIR%\�e�B����
%SZEXE% x "%DL_DIR%\WindShk.zip" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\WindShk\*.*" "%TIM3_DIR%"
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
call :CLEANUP
call :SHOW_MSG "�C���X�g�[�����������܂���" vbInformation "���" "modal"

exit


@rem �ȉ��A�T�u���[�`��

@rem �w���v��\������
:HELP
    echo �g����: %0 [�I�v�V����]
    echo �I�v�V����:
    echo    --rc         �e�X�g�o�[�W�������C���X�g�[������
    echo    --help       �w���v��\������
    echo    --version    �o�[�W������\������
exit /b

@rem �C���X�g�[��/�A�b�v�f�[�g���\�z
:WORKING_ENV_SETUP
    if %SEL_UPDATE% equ 0 (
        @rem �C���X�g�[����I��
        @rem �f�B���N�g���̍쐬
        set AVIUTL_DIR_MK=%INSTALL_DIR_PRE%\AviUtl
        set PLUGINS_DIR_MK=!AVIUTL_DIR_MK!\plugins
        set FIGURE_DIR_MK=!PLUGINS_DIR_MK!\figure
        set SCRIPT_DIR_MK=!PLUGINS_DIR_MK!\script
        set DL_TEMP_DIR_MK=!AVIUTL_DIR_MK!\DL_TEMP
        set SVZIP_DIR_MK=!DL_TEMP_DIR_MK!\7z
        set FILE_TEMP_DIR_MK=!AVIUTL_DIR_MK!\FILE_TEMP
        @rem �f�B���N�g���̍쐬(���łɑ��݂���ꍇ�͂��̃G���[���o�͂��Ȃ��悤��)
        mkdir !AVIUTL_DIR_MK! !PLUGINS_DIR_MK! !SCRIPT_DIR_MK! !FIGURE_DIR_MK! > nul 2>&1
        mkdir !DL_TEMP_DIR_MK! !SVZIP_DIR_MK! !FILE_TEMP_DIR_MK! > nul 2>&1

        @rem ��ƃf�B���N�g���̐ݒ�
        set AVIUTL_DIR=%INSTALL_DIR%\AviUtl
        set PLUGINS_DIR=!AVIUTL_DIR!\plugins
        set FIGURE_DIR=!PLUGINS_DIR!\figure
        set SCRIPT_DIR=!PLUGINS_DIR!\script
        set DL_DIR=!AVIUTL_DIR!\DL_TEMP
        set SVZIP_DIR=!DL_DIR!\7z
        set FILE_DIR=!AVIUTL_DIR!\FILE_TEMP
    ) else (
        @rem �A�b�v�f�[�g��I��
        @rem AviUtl�f�B���N�g��
        set AVIUTL_DIR=%INSTALL_DIR%
        @rem plugins�f�B���N�g��
        set PLUGINS_DIR=!AVIUTL_DIR!\plugins
        @rem script�f�B���N�g��
        set SCRIPT_DIR=!PLUGINS_DIR!\script

        @rem DL�t�@�C���̈ꎞ�f�B���N�g��
        set DL_DIR=!AVIUTL_DIR!\DL_TEMP
        @rem �o�̓t�@�C���̈ꎞ�f�B���N�g��
        set FILE_DIR=!AVIUTL_DIR!\FILE_TEMP
        @rem 7z�̓W�J�f�B���N�g��
        set SVZIP_DIR=!AVIUTL_DIR!\DL_TEMP\7z
        mkdir "!DL_DIR!" "!FILE_DIR!" "!SVZIP_DIR!"
    )
    call :SZ_SETUP
    call :HTOX_SETUP
exit /b

@rem �t�@�C�����犮�S��v�̍s����������
@rem ����: %1-�t�@�C�� %2-�������镶����
@rem �߂�l 0<:�q�b�g�����s�� 0:�q�b�g�Ȃ�
:FILE_SEARCH_STR
set CNT=1
    set FILE_TXT=%1
    for /f "usebackq" %%a in (%FILE_TXT%) do (
        if "%%a"==%2 (
            goto :HIT_STR
        )
        set /a CNT=CNT+1
    )
    set CNT=0
    :HIT_STR
exit /b !CNT!

@rem �t�@�C���̍s�����J�E���g����
@rem ����: %1-�t�@�C��
@rem �߂�l �s��
:FILE_LINE_CNT
    set CNT=0
    set FILE_TXT=%1
    for /f "usebackq" %%a in (%FILE_TXT%) do (
        set /a CNT=CNT+1
    )
exit /b !CNT!

@rem AviUtl�����s���A�I������
:EXEC_AVIUTL
    start "" "%AVIUTL_DIR%\aviutl.exe"
    timeout /t 2 /nobreak >nul
:SEARCH_EXE_LOOP
    call :SEARCH_EXE
    if %ERRORLEVEL% equ 0 (
        taskkill /im aviutl.exe
    ) else (
        call :SEARCH_EXE_LOOP
    )
exit /b

@rem AviUtl�����s����Ă��邩�`�F�b�N
@rem �߂�l 0:�q�b�g 1:�q�b�g�Ȃ�
:SEARCH_EXE
    for /F "usebackq tokens=1" %%a in (`tasklist /fi "IMAGENAME eq aviutl.exe"`) do @set AVIUTL_EXE=%%a
    if /i !AVIUTL_EXE!==aviutl.exe (
        exit /b 0
    )
exit /b 1

@rem �t�@�C�����_�E�����[�h����
@rem ����: %1-URL %2-�_�E�����[�h�����t�@�C����
:FILE_DOWNLOAD 
    for /l %%a in (0,1,%DL_RETRY%) do (
        if %%a gtr 0 (
            echo Retry %%a/%DL_RETRY%
        )
        powershell -Command "[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12 -bor [System.Net.SecurityProtocolType]::Tls11 ; wget %1 -Outfile """%2""""
        if !ERRORLEVEL! equ 0  (
            goto :DOWNLOAD_SUCCESS
        )
        echo retVal:!ERRORLEVEL!
    )
    call :SHOW_MSG "�t�@�C���̃_�E�����[�h�Ɏ��s���܂���" vbCritical "�G���[" "modal"
    if %SEL_UPDATE% equ 0 (
        rmdir /s /q "%AVIUTL_DIR%"
    ) else (
        call :CLEANUP
    )
    exit
:DOWNLOAD_SUCCESS
exit /b

@rem ���b�Z�[�W�{�b�N�X��\������
@rem %1-�\���e�L�X�g %2-���b�Z�[�W�A�C�R��(VB) %3-�^�C�g�� %4-���[�_���ݒ�("modal"�Ń��[�_���\��,""�Ŕ񃂁[�_���\��)
:SHOW_MSG
    if %4=="modal" (
        set MSG_MODAL=vbSystemModal
    ) else (
        set MSG_MODAL=0
    )
    echo msgbox %1,%2  Or %MSG_MODAL%,%3 > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
    del %TEMP%\msgbox.vbs
exit /b

@rem �����񌟍�
@rem ����: %1-�����Ώ� %2-�������镶����
@rem �߂�l 0<:�q�b�g�����ʒu -1:%1���� -2:%2���� -3:�q�b�g�Ȃ�
:STRSTR
    if "%~1" equ "" exit /b -1
    if "%~2" equ "" exit /b -2
    set s1=%~1
    set s2=%~2
    set s1_p=0
    set s2_p=0
:STRSTR_LOOP
    if /I "!s1:~%s1_p%,1!" neq "!s2:~%s2_p%,1!" (
        @rem �s��v
        set s2_p=0
    ) else (
        set /a s2_p+=1
    )
    set /a s1_p+=1
    if "!s2:~%s2_p%,1!" equ "" (
        set /a s1_p-=s2_p
        exit /b !s1_p!
    )
    if "!s1:~%s1_p%,1!" equ "" exit /b -3
    goto :STRSTR_LOOP

@rem ������̒�����Ԃ�
@rem ����: %1-�����Ώ�
@rem �߂�l 0<=:������ -1:%1����
:STRLEN
    if "%~1" equ "" exit /b -1
    set str=%~1
    set len=0
:STRLEN_LOOP
    if "%str%" equ "" exit /b %len%
    set str=%str:~1%
    set /a len+=1
    goto :STRLEN_LOOP

@rem �p��̌��\�L���琔���ɕϊ�
@rem ����: %1-�p��\�L�̌�
@rem �߂�l 1�`12:�ϊ����ꂽ�� -1:�����Ȃ� -2:�����G���[
:CONV_MONTH
    if "%~1" equ "" exit /b -1
    if /i %1=="January"   goto :M_JAN
    if /i %1=="Jan"       goto :M_JAN
    if /i %1=="February"  goto :M_FEB
    if /i %1=="Feb"       goto :M_FEB
    if /i %1=="March"     goto :M_MAR
    if /i %1=="Mar"       goto :M_MAR
    if /i %1=="April"     goto :M_APR
    if /i %1=="Apr"       goto :M_APR
    if /i %1=="May"       goto :M_MAY
    if /i %1=="June"      goto :M_JUN
    if /i %1=="Jun"       goto :M_JUN
    if /i %1=="July"      goto :M_JUL
    if /i %1=="Jul"       goto :M_JUL
    if /i %1=="August"    goto :M_AUG
    if /i %1=="Aug"       goto :M_AUG
    if /i %1=="September" goto :M_SEP
    if /i %1=="Sep"       goto :M_SEP
    if /i %1=="October"   goto :M_OCT
    if /i %1=="Oct"       goto :M_OCT
    if /i %1=="November"  goto :M_NOV
    if /i %1=="Nov"       goto :M_NOV
    if /i %1=="December"  goto :M_DEC
    if /i %1=="Dec"       goto :M_DEC
    goto :M_OTHER

    :M_JAN
        exit /b 1
    :M_FEB
        exit /b 2
    :M_MAR
        exit /b 3
    :M_APR
        exit /b 4
    :M_MAY
        exit /b 5
    :M_JUN
        exit /b 6
    :M_JUL
        exit /b 7
    :M_AUG
        exit /b 8
    :M_SEP
        exit /b 9
    :M_OCT
        exit /b 10
    :M_NOV
        exit /b 11
    :M_DEC
        exit /b 12
    :M_OTHER
        exit /b -2

@rem JST����(yyyy/M/d HH:mm)����UTC�N����(yyyy/M/d)�֕ϊ�����
@rem �ϐ�:DT�Ɋi�[�����
@rem ����: %1-�v�Z�Ώۓ���
@rem �߂�l 0:�ϊ����� -1:�����G���[
:CONV_UTC
    if "%~1" equ "" exit /b -1
    set DT=%~1
    set DT=%DT:/= %
    set DT=%DT::= %
    echo !DT! > %TEMP%\dt.txt
    for /f "tokens=1,2,3,4,5" %%a in (%TEMP%\dt.txt) do (
        set Y=%%a
        set /a MO=1%%b-100
        set /a D=1%%c-100
        set /a H=1%%d-100
        set /a MI=1%%e-100
    )
    set /a H_PRE=!H!-9
    if !H_PRE! lss 0 (
        set /a D=!D!-1
        if !D! equ 0 (
            set T_F=false
            if not !MO! equ 3 if not !MO! equ 5 if not !MO! equ 7 if not !MO! equ 8 if not !MO! equ 10 if not !MO! equ 12 set T_F=true
            if !T_F!==true (
                set D=31
            ) else (
                if !MO! equ 3 (
                    set /a RC=!Y!%%4
                    if !RC! equ 0 (
                        set D=29
                    ) else (
                        set D=28
                    )
                ) else (
                    set D=30
                )
            )
            if !MO! equ 1 (
                set MO=12
                set /a Y=!Y!-1
            ) else (
                set /a MO=!MO!-1
            )
        )
    )
    del %TEMP%\dt.txt
    set DT=!Y!/!MO!/!D! !H!:!MI!
exit /b 0

@rem ������0�n�܂���폜
@rem �ϐ�:DT�Ɋi�[�����
@rem �߂�l 0:�ϊ����� -1:�����G���[
:DATETIME_ZERO_DEL
    if "%~1" equ "" exit /b -1
    set DT=%~1
    set DT=%DT:/= %
    set DT=%DT::= %
    echo !DT! > %TEMP%\dt.txt
    for /f "tokens=1,2,3,4,5" %%a in (%TEMP%\dt.txt) do (
        set Y=%%a
        set /a MO=1%%b-100
        set /a D=1%%c-100
        set /a H=1%%d-100
        set /a MI=1%%e-100
    )
    del %TEMP%\dt.txt
    set DT=!Y!/!MO!/!D! !H!:!MI!
exit /b 0

@rem �A�b�v�f�[�g�z��ɑΏۖ���o�^
@rem ����: %1-�A�b�v�f�[�g�̃`�F�b�N���� %2-�o�^���镶���� %3-�o�^����T�u���[�`���̃��x��
@rem �߂�l 0:���� -1:�����G���[
:UPDATE_NAME_REGIST
    if "%~1" equ "" exit /b -1
    if "%~2" equ "" exit /b -1
    if "%~3" equ "" exit /b -1
    if %1 equ 1 (
        set /a UPDATE_LIST_CNT=UPDATE_LIST_CNT+1
        set UPDATE_LIST[!UPDATE_LIST_CNT!]=%~2
        set UPDATE_ROUTINE_LIST[!UPDATE_LIST_CNT!]=%~3
    )
exit /b 0

@rem TEMP�t�H���_�̌�n��
:CLEANUP
    rmdir /s /q "%DL_DIR%"
    rmdir /s /q "%FILE_DIR%"
exit /b

@rem 7z�̊��\�z
:SZ_SETUP
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
exit /b

@rem HtoX�̊��\�z
:HTOX_SETUP
    @rem HtoX(HTML��̓c�[��)��DL
    call :FILE_DOWNLOAD "http://win32lab.com/lib/htox4173.exe" "%DL_DIR%\htox4173.exe"
    @rem HtoX�̎��ȉ𓀂����s
    %SZEXE% x "%DL_DIR%\htox4173.exe" -aoa -o"%DL_DIR%"
    set HTOX="%DL_DIR%\HtoX32c.exe"
exit /b

@rem x264guiEx�̃C���X�g�[��
:X264GUIEX_INSTALL
    echo x264guiEx�̃_�E�����[�h...
    call :FILE_DOWNLOAD "https://drive.google.com/uc?id=1fp6i-suNAlwCLsjXovJ-xXuUlNQmMQXK" "%DL_DIR%\%X264GUIEX_ZIP%"
    echo x264guiEx�̃_�E�����[�h����

    %SZEXE% x "%DL_DIR%\%X264GUIEX_ZIP%" -aoa -o"%TEMP%"
    "%TEMP%\x264guiEx_%X264GUIEX_VER%\auo_setup.exe" -autorun -nogui -dir "%AVIUTL_DIR%"
    rmdir /s /q %TEMP%\x264guiEx_%X264GUIEX_VER%

exit /b

@rem GitHub�̍ŐV�����[�X���擾
@rem ����: %1-URL %2-�ŐV�����[�X�e�L�X�g�o�͐�
@rem �߂�l 0:���� -1:�����G���[
:GITHUB_GET_LATEST_RELEASE_VER
    if "%~1" equ "" exit /b -1
    call :FILE_DOWNLOAD %1 "%DL_DIR%\github_release.html"
    @rem html�����
    %HTOX% /I8 "%DL_DIR%\github_release.html" > "%FILE_DIR%\htmlparse.txt"
    @rem psdtoolkit�̍ŐV�o�[�W�����擾
    findstr /C:"*  v" "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\tag.txt"
    set /p LINE=<"%FILE_DIR%\tag.txt"
    echo %LINE% > "%FILE_DIR%\tag.txt"
exit /b 0

@rem GitHub�̍ŐV�����[�X�̓��t���擾
@rem ����: %1-�����[�X���擾�̌���������
@rem ���ʂ�GITHUB_DATE�Ɋi�[����
@rem �߂�l 0:���� -1:�����G���[
:GITHUB_GET_LATEST_RELEASE_DATE
    if "%~1" equ "" exit /b -1
    findstr /C:%1 "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\date.txt"
    @rem 1�s�ڂ���
    set /p LINE=<"%FILE_DIR%\date.txt"
    @rem �N�����݂̂𒊏o
    call :STRSTR "%LINE%" "this "
    if %ERRORLEVEL% equ -3 (
        call :SHOW_MSG "�������[�h:this ���������܂���ł����B�G���[���e���o�b�`�t�@�C������҂ɕ񍐂��Ă�������" vbCritical "�G���[" "modal"
        call :CLEANUP
        exit
    )
    set FRONT_LEN=%ERRORLEVEL%
    call :STRSTR "%LINE%" "�E"
    if %ERRORLEVEL% equ -3 (
        call :STRLEN "%LINE%" 
    )
    set LAST_LEN=%ERRORLEVEL%
    set /a FRONT_LEN+=5
    set /a DIFF=%LAST_LEN%-%FRONT_LEN%
    set LINE=!LINE:~%FRONT_LEN%,%DIFF%!
    echo %LINE% > "%FILE_DIR%\date.txt"
    @rem �N������ϐ����ɕ���
    set YEAR=
    set MONTH=
    set DAY=
    for /f "usebackq tokens=1,2,3" %%i in ("%FILE_DIR%\date.txt") do (
        set MONTH=%%i
        set DAY=%%j
        set YEAR=%%k
    )
    @rem ������̌��𐔎��ɕϊ�
    call :CONV_MONTH "%MONTH%"
    set MONTH=%ERRORLEVEL%
    @rem GitHub�̃����[�X��(yyyy/M/d)����
    set GITHUB_DATE=%YEAR%/%MONTH%/%DAY:,=%
exit /b 0

@rem PSDToolkit�̍X�V�������擾
:PSDTOOLKIT_GET_DATE
    set PSDFILE_DATETIME_PRE=
    for %%i in (plugins\PSDToolKit.auf) do (
        set PSDFILE_DATETIME_PRE=%%~ti
    )
    call :CONV_UTC "%PSDFILE_DATETIME_PRE%"
    set PSDFILE_DATETIME=!DT!
    echo !PSDFILE_DATETIME! > "%FILE_DIR%\psddatetime.txt"

    set PSDFILE_DATE=
    for /f "usebackq tokens=1" %%i in ("%FILE_DIR%\psddatetime.txt") do (
        set PSDFILE_DATE=%%i
    )
exit /b

@rem PSDToolkit�ŐV�o�[�W�����擾
:PSDTOOLKIT_GET_LATEST_VER
    @rem PSDToolkit�̍ŐV�����[�X���擾
    call :GITHUB_GET_LATEST_RELEASE_VER "https://github.com/oov/aviutl_psdtoolkit/releases"
    set PSDTOOLKIT_VER=
    for /f "usebackq tokens=2" %%i in ("%FILE_DIR%\tag.txt") do (
        set PSDTOOLKIT_VER=%%i
    )
exit /b

@rem PSDToolkit�A�b�v�f�[�g�`�F�b�N
@rem �߂�l 0:�A�b�v�f�[�g�Ȃ� 1:�A�b�v�f�[�g����
:PSDTOOLKIT_UPDATE_CHECK
    @rem psdtoolkit�̍ŐVtag�̓��t�擾
    call :GITHUB_GET_LATEST_RELEASE_DATE "oov released this "
    set GITHUB_PSD_DATE=%GITHUB_DATE%
    @rem PSDToolkit�̍X�V�������擾
    call :PSDTOOLKIT_GET_DATE
    if !PSDFILE_DATE! lss !GITHUB_PSD_DATE! (
        exit /b 1
    )
exit /b 0

@rem PSDToolkit�̃C���X�g�[��
:PSDTOOLKIT_INSTALL
    call :FILE_DOWNLOAD "https://github.com/oov/aviutl_psdtoolkit/releases/download/%PSDTOOLKIT_VER%/psdtoolkit_%PSDTOOLKIT_VER%.zip" "%DL_DIR%\psdtoolkit_%PSDTOOLKIT_VER%.zip"
    @rem PSDToolKit��W�J
    %SZEXE% x "%DL_DIR%\psdtoolkit_%PSDTOOLKIT_VER%.zip" -aoa -o"%PLUGINS_DIR%"

    rmdir /s /q "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
    mkdir "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
    @move "%PLUGINS_DIR%\PSDToolKitDocs" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
    @move "%PLUGINS_DIR%\*.txt" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
    @move "%PLUGINS_DIR%\*.html" "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q"
    @move "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q\exedit.txt" "%PLUGINS_DIR%"
    @move "%AVIUTL_DIR%\PSDToolKit�̐����t�@�C���Q\lua.txt" "%PLUGINS_DIR%"
exit /b

@rem AviUtl�ŐV�o�[�W�����ƍX�V�����擾
@rem AVIUTL_VER��AVIUTL_DATE�Ɋi�[
:AVIUTL_GET_LATEST_VER_DATE
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/" "%DL_DIR%\aviutl.html"
    %HTOX% /I8 "%DL_DIR%\aviutl.html" > "%FILE_DIR%\htmlparse.txt"
    findstr /I /R /C:"\<aviutl[0-9]." "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\list.txt"
    if %INSTALL_AVIUTL_RC_FLAG% equ 1 (
        findstr /I /C:"�e�X�g��" "%FILE_DIR%\list.txt" > "%FILE_DIR%\rclist.txt"
        type "%FILE_DIR%\rclist.txt" > "%FILE_DIR%\list.txt"
    )
    set /p LINE=<"%FILE_DIR%\list.txt"
    echo %LINE% > "%FILE_DIR%\latest.txt"
    for /f "usebackq tokens=1,3" %%i in ("%FILE_DIR%\latest.txt") do (
        set AVIUTL_VER=%%~ni
        set AVIUTL_DATE=%%j
    )
exit /b

@rem AviUtl�̃A�b�v�f�[�g�`�F�b�N
@rem �߂�l 0:�A�b�v�f�[�g�Ȃ� 1:�A�b�v�f�[�g����
:AVIUTL_UPDATE_CHECK
    call :AVIUTL_GET_LATEST_VER_DATE
    for %%i in ("%AVIUTL_DIR%\aviutl.exe") do (
        set AVIUTL_EXE_DATE_PRE=%%~ti
    )
    call :DATETIME_ZERO_DEL "%AVIUTL_EXE_DATE_PRE%"
    set AVIUTL_EXE_DATE=!DT!
    echo %AVIUTL_EXE_DATE% > "%FILE_DIR%\aviutldatetime.txt"
    for /f "usebackq tokens=1" %%i in ("%FILE_DIR%\aviutldatetime.txt") do (
        set AVIUTL_EXE_DATE=%%i
    )
    if %AVIUTL_EXE_DATE% lss %AVIUTL_DATE% (
        exit /b 1
    )
exit /b 0

@rem AviUtl�C���X�g�[��
:AVIUTL_INSTALL
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/%AVIUTL_VER%.zip" "%DL_DIR%\%AVIUTL_VER%.zip"
    @rem AviUtl�̓W�J
    %SZEXE% x "%DL_DIR%\%AVIUTL_VER%.zip" -aoa -o"%AVIUTL_DIR%"
    set AVIUTL_DATE=
    for %%i in ("%AVIUTL_DIR%\aviutl.exe") do (
        set AVIUTL_DATE=%%~ti
    )

    if "%AVIUTL_VER%"=="aviutl100" (
        @rem LargeAddressAware��L����
        echo AviUtl��LargeAddressAware��L���ɂ��܂��i����ɂ�1���قǂ�����܂��j
        echo 0%%����
        powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -first 262 | Set-Content -en byte \"%AVIUTL_DIR%\A-1.bin\""
        echo 25%%����
        powershell -Command "[System.Text.Encoding]::ASCII.GetBytes(\"/\") | Set-Content -en byte \"%AVIUTL_DIR%\A-12.bin\""
        echo 50%%����
        powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -last 487161 | Set-Content -en byte \"%AVIUTL_DIR%\A-2.bin\""
        echo 75%%����
        copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.exe"
        powershell -Command "Set-ItemProperty \"%AVIUTL_DIR%\aviutl.exe\" -name LastWriteTime -value \"%AVIUTL_DATE%""
        del "%AVIUTL_DIR%"\*.bin
        echo 100%%����
    )
exit /b

@rem �g���ҏW�̍ŐV�o�[�W�����ƍX�V�����擾
@rem EXEDIT_VER��EXEDIT_DATE�Ɋi�[
:EXEDIT_GET_LATEST_VER_DATE
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/" "%DL_DIR%\aviutl.html"
    %HTOX% /I8 "%DL_DIR%\aviutl.html" > "%FILE_DIR%\htmlparse.txt"
    findstr /I /R /C:"\<exedit[0-9]." "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\list.txt"
    set /p LINE=<"%FILE_DIR%\list.txt"
    echo %LINE% > "%FILE_DIR%\latest.txt"
    for /f "usebackq tokens=1,3" %%i in ("%FILE_DIR%\latest.txt") do (
        set EXEDIT_VER=%%~ni
        set EXEDIT_DATE=%%j
    )
exit /b

@rem �g���ҏW�̃A�b�v�f�[�g�`�F�b�N
@rem �߂�l 0:�A�b�v�f�[�g�Ȃ� 1:�A�b�v�f�[�g����
:EXEDIT_UPDATE_CHECK
    call :EXEDIT_GET_LATEST_VER_DATE
    for %%i in ("%AVIUTL_DIR%\plugins\exedit.auf") do (
        set EXEDIT_AUF_DATE_PRE=%%~ti
    )
    call :DATETIME_ZERO_DEL %EXEDIT_AUF_DATE_PRE%
    set EXEDIT_AUF_DATE=!DT!
    echo %EXEDIT_AUF_DATE% > "%FILE_DIR%\exeditdatetime.txt"
    for /f "usebackq tokens=1" %%i in ("%FILE_DIR%\exeditdatetime.txt") do (
        set EXEDIT_AUF_DATE=%%i
    )
    if %EXEDIT_AUF_DATE% lss %EXEDIT_DATE% (
        exit /b 1
    )
exit /b 0

@rem �g���ҏW�C���X�g�[��
:EXEDIT_INSTALL
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/%EXEDIT_VER%.zip" "%DL_DIR%\%EXEDIT_VER%.zip"
    @rem �g���ҏW�̓W�J
    %SZEXE% x "%DL_DIR%\%EXEDIT_VER%.zip" -aoa -o"%PLUGINS_DIR%"
exit /b

@rem �����[�X�m�[�g
@rem 2019/9/19 (v3.2.0)
@rem     LargeAddressAware��L�������aviutl.exe�̍X�V�����I���W�i���Ɠ����ɂ���悤�ɕύX
@rem     ��Ɗ��\�z���[�`���ǉ�
@rem     �p��\�L�̌��̏���������C��
@rem     ���͂̏C��
@rem 2019/7/4 (v3.1.0)
@rem     GitHub�̃����[�X���̎擾���C��
@rem     �G���[������ǉ�
@rem 2019/5/12 (v3.0.1)
@rem     �C���f���g�ƃR�����g,����C���X�g�[�����̃R�����g�������e�i���X
@rem 2019/5/12 (v3.0.0)
@rem     PSDToolkit�̃A�b�v�f�[�g�@�\��ǉ�
@rem     x264guiEx�̃A�b�v�f�[�g�@�\��ǉ�
@rem     �ŐV��PSDToolkit���C���X�g�[������悤�ɕύX
@rem 2019/5/11 (v2.2.0)
@rem     �C���X�g�[���p�X�ɋ󔒂��������ۂɃ_�E�����[�h�G���[�y�сAaviutl.ini�t�@�C���̕ҏW���o���Ă��Ȃ������̂��C��
@rem 2019/5/4 (v2.1.0)
@rem     https�̐ڑ����s�����Ƃ��ɁA"SSL/TLS �̃Z�L�����e�B�ŕی삳��Ă���`���l�����쐬�ł��܂���ł���"�ƕ\������ă_�E�����[�h�G���[�ƂȂ��Ă��܂����Ƃ��������̂��C��
@rem 2019/4/29 (v2.0.0)
@rem     �t�@�C���̃_�E�����[�h���_�E�����[�h����wget����Invoke-WebRequest(wget)�ɕύX
@rem 2019/4/29 (v1.6.0)
@rem     �_�E�����[�h�G���[���ɍĎ��s������悤�ɕύX
@rem     �C���X�g�[�����s�O��AviUtl�̋N���`�F�b�N��ǉ�
@rem 2019/4/24 (v1.5.0)
@rem     ���h��T���T�u�t�H���_�ɓ����Ă����̂��C��
@rem     ���b�Z�[�W�{�b�N�X���T�u���[�`����
@rem 2019/4/22 (v1.4.0)
@rem     �_�E�����[�h�������T�u���[�`����
@rem 2019/4/21 (v1.3.0)
@rem     �_�E�����[�h�G���[�\����ǉ�
@rem     x256guiEx�̃_�E�����[�h���ύX
@rem     �ݒ�t�@�C�������܂��ҏW����Ȃ��\�����������̂��C��
@rem     aviutl.exe�̌��������܂�����ĂȂ��\��������̂��C��
@rem 2019/4/16 (v1.2.0)
@rem     �ݒ�t�@�C�������܂��ҏW�ł��Ă��Ȃ������̂��C��
@rem 2019/3/26 (v1.1.1)
@rem     PSDToolKit�̃o�[�W�����ύX�ɑΉ�
@rem 2019/3/2 (v1.1.0)
@rem     �󔒕�������ł��C���X�g�[���ł���悤�ɏC��
@rem     �^�X�N�L���̊m�������A�b�v
@rem     ���s��Ԃ̕\����ǉ�
@rem     �_�E�����[�h���s���Ƀ��b�Z�[�W�E�B���h�E��\������悤�ɕύX
@rem 2019/2/24 (v1.0.0)
@rem     ���񃊃��[�X
