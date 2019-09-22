@rem AviUtl Auto Installer Script by minfia

@rem AviUtl Auto Installer Scriptは無保証で提供されます。
@rem このプログラムを使用した事で発生した全ての損害について保証しません。
@rem このプログラムは、PowerShell3.0以上が対象です。
@rem このプログラムを実行する場合は、ネットワークが接続された場所で、出来るだけ有線接続で実行して下さい。
@rem もしネットワークの接続が上手くいかない場合は時間を置いて実行して下さい。
@rem その際に作成されているAviUtlフォルダは自動で削除されますが、
@rem もし削除されていない場合は手動で削除して下さい。

@rem AviUtl及びプラグイン、スクリプトの使い方は各自でご確認下さい。
@rem 構成一覧
@rem ・AviUtl + 拡張編集 (by KENくん氏)
@rem ・L-SMASH Works (by POPn氏)
@rem ・x264GuiEx (by rigaya氏)
@rem ・PSDToolKit (by おおぶ氏)
@rem ・風揺れ (by ティム氏)
@rem ・インク（＋ひょうたん）(by ティム氏)
@rem ・縁取りT (by ティム氏)
@rem ・リール回転 (by ティム氏)
@rem ・バニシングポイント2 (by ティム氏)
@rem ・ライントーン＆ハーフトーン (by ティム氏)
@rem ・PNG出力 (by yu_noimage_氏)

@echo off
setlocal ENABLEDELAYEDEXPANSION

title AviUtl Auto Installer

set SCRIPT_VER=3.2.0

@rem PowerShellのバージョンチェック(3以上)
for /f "usebackq" %%a in (`powershell -Command "(Get-Host).version"`) do (
    set PSVER=%%a
)
if not %PSVER% geq 3 (
    call :SHOW_MSG "PowerShellのバージョンが3以上である必要があります" vbCritical "エラー" "modal"
    exit
)

@rem 実行前にAviUtlが起動していた場合にエラー
call :SEARCH_EXE
if %ERRORLEVEL% equ 0 (
    call :SHOW_MSG "AviUtlが起動されています、AviUtlを終了してください" vbCritical "エラー" "modal"
    exit
)

set DL_RETRY=3
set X264GUIEX_VER=2.59
set X264GUIEX_ZIP=x264guiEx_%X264GUIEX_VER%.7z

set SEL_UPDATE=0

where aviutl.exe > nul
if %ERRORLEVEL% equ 0 (
    set SEL_UPDATE=1
    call :UPDATE
) else (
    goto :INSATALL
)


:UPDATE
@rem アップデート一覧格納配列
set UPDATE_LIST=
@rem アップデート実行ルーチン一覧格納配列
set UPDATE_ROUTINE_LIST=
@rem UPDATE_LISTの要素数
set UPDATE_LIST_CNT=-1

@rem ディレクトリの設定
@rem カレントディレクトリ
set INSTALL_DIR_PRE=%~dp0
set INSTALL_DIR_PRE=!INSTALL_DIR_PRE:~0,-1!
set INSTALL_DIR=%INSTALL_DIR_PRE%
set INSTALL_DIR_PRE="""%INSTALL_DIR_PRE%"""

@rem 作業環境構築
call :WORKING_ENV_SETUP

@rem AviUtlのアップデートチェック
call :AVIUTL_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "AviUtl" ":AVIUTL_INSTALL"

@rem 拡張編集のアップデートチェック
call :EXEDIT_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "拡張編集" ":EXEDIT_INSTALL"

@rem PSDToolkitのアップデート
call :PSDTOOLKIT_GET_LATEST_VER
call :PSDTOOLKIT_UPDATE_CHECK
call :UPDATE_NAME_REGIST %ERRORLEVEL% "PSDToolkit" ":PSDTOOLKIT_INSTALL"

if %UPDATE_LIST_CNT% lss 0 (
    call :CLEANUP
    call :SHOW_MSG "アップデートはありません" vbInformation "情報" "modal"
    exit
) else (
    echo アップデート対象は以下になります
    for /l %%i in (0,1,%UPDATE_LIST_CNT%) do (
        echo ・!UPDATE_LIST[%%i]!
    )
    @rem アップデート確認
    set /p UPDATE_SUCCESS="アップデートを行いますか？(Y/N)："
    if /i not !UPDATE_SUCCESS!==Y (
        call :CLEANUP
        call :SHOW_MSG "アップデートを中止しました" vbInformation "情報" "modal"
        exit
    )
)

for /l %%i in (0,1,%UPDATE_LIST_CNT%) do (
    call !UPDATE_ROUTINE_LIST[%%i]!
)
call :X264GUIEX_INSTALL

call :CLEANUP
call :SHOW_MSG "アップデートが完了しました" vbInformation "情報" "modal"

exit


:INSATALL
echo script version %SCRIPT_VER%
echo これはAviUtlの環境を構築するプログラムです。
echo また、劇場向けの構成となります。
echo AviUtlのインストール先をフルパスで指定してください。
echo また、パスの最後に"\"を付けないで下さい、うまくいきません。
echo バッチファイルと同じ場所にインストールする場合はENTERを押してください。
set /P INSTALL_DIR_PRE="インストール先："

if "%INSTALL_DIR_PRE%"=="" (
set INSTALL_DIR_PRE=%~dp0
set INSTALL_DIR_PRE=!INSTALL_DIR_PRE:~0,-1!
)
set INSTALL_DIR=%INSTALL_DIR_PRE%
set INSTALL_DIR_PRE="""%INSTALL_DIR_PRE%"""

set AVIUTL_VER=aviutl100
set EXEDIT_VER=exedit92
set LSMASH_VER=r935-2
set LSMASH_ZIP=L-SMASH_Works_%LSMASH_VER%_plugins.zip

@rem 作業環境構築
call :WORKING_ENV_SETUP

echo AviUtlのインストール
call :AVIUTL_INSTALL

@rem AviUtlの設定ファイルを生成する
call :EXEC_AVIUTL
timeout /t 3 /nobreak > nul
:SEARCH_INI
    for %%a in (aviutl.ini) do @set INI_FILE=%%a
    if /i not !INI_FILE!==aviutl.ini (
        goto SEARCH_INI
    )

@rem aviutlの設定ファイルを編集
@rem 変更内容
@rem 最大画像サイズ(1280x720 -> 2200x1200)
@rem キャッシュフレーム数(8 -> 32)
@rem リサイズ解像度リスト(1920x1080を追加)
@rem 再生ウィンドウをメインウィンドウに表示する(無効 -> 有効)
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

echo 拡張編集のインストール
call :EXEDIT_INSTALL

echo L-SMASHのダウンロード...
call :FILE_DOWNLOAD "https://pop.4-bit.jp/bin/l-smash/%LSMASH_ZIP%" "%DL_DIR%\%LSMASH_ZIP%"
echo L-SMASHのダウンロード完了

@rem プラグインなどを展開
%SZEXE% x "%DL_DIR%\%LSMASH_ZIP%" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\lw*.*" "%PLUGINS_DIR%"
call :X264GUIEX_INSTALL


@rem 劇場向け環境構築
@rem 劇場向けファイルのDL
@rem PSDToolkit
set PSDTOOLKIT_VER=
call :PSDTOOLKIT_GET_LATEST_VER
call :PSDTOOLKIT_INSTALL

@rem 風揺れ
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/WindShk.zip"  "%DL_DIR%\WindShk.zip"

@rem インク（＋ひょうたん）
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/InkV2.zip" "%DL_DIR%\InkV2.zip"

@rem 縁取りT
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/Framing.zip" "%DL_DIR%\Framing.zip"

@rem リール回転
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/ReelRot.zip" "%DL_DIR%\ReelRot.zip"

@rem バニシングポイント2
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/VanishP2_V2.zip" "%DL_DIR%\VanishP2_V2.zip"

@rem ライントーン＆ハーフトーン
call :FILE_DOWNLOAD "https://tim3.web.fc2.com/script/LinHal.zip" "%DL_DIR%\LinHal.zip"

@rem PNG出力
call :FILE_DOWNLOAD "http://auls.client.jp/plugin/auls_outputpng.zip" "%DL_DIR%\auls_outputpng.zip"


@rem ティム氏のスクリプトを展開
set TIM3_DIR_MK=%SCRIPT_DIR_MK%\ティム氏
mkdir %TIM3_DIR_MK%
set TIM3_DIR=%SCRIPT_DIR%\ティム氏
%SZEXE% x "%DL_DIR%\WindShk.zip" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\WindShk\*.*" "%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\InkV2.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\Framing.zip" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\Framing\*.*" "%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\ReelRot.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\VanishP2_V2.zip" -aoa -o"%TIM3_DIR%"
%SZEXE% x "%DL_DIR%\LinHal.zip" -aoa -o"%TIM3_DIR%"

@rem yu_noimage_氏のプラグインを展開
%SZEXE% x "%DL_DIR%\auls_outputpng.zip" -aoa -o"%DL_DIR%"
@move  "%DL_DIR%\auls_outputpng\*.auf" "%PLUGINS_DIR%"

@rem 今までインストールしたプラグイン、スクリプトをaviutl.iniに反映
call :EXEC_AVIUTL


@rem 後始末
call :CLEANUP
call :SHOW_MSG "インストールが完了しました" vbInformation "情報" "modal"

exit

@rem 以下、サブルーチン

@rem Install/Update環境構築
@rem 7zとHtoX
:WORKING_ENV_SETUP
    if %SEL_UPDATE% equ 0 (
        @rem インストールを選択
        @rem ディレクトリの作成
        set AVIUTL_DIR_MK=%INSTALL_DIR_PRE%\AviUtl
        set PLUGINS_DIR_MK=!AVIUTL_DIR_MK!\plugins
        set FIGURE_DIR_MK=!PLUGINS_DIR_MK!\figure
        set SCRIPT_DIR_MK=!PLUGINS_DIR_MK!\script
        set DL_TEMP_DIR_MK=!AVIUTL_DIR_MK!\DL_TEMP
        set SVZIP_DIR_MK=!DL_TEMP_DIR_MK!\7z
        set FILE_TEMP_DIR_MK=!AVIUTL_DIR_MK!\FILE_TEMP
        @rem ディレクトリの作成(すでに存在する場合はそのエラーを出力しないように)
        mkdir !AVIUTL_DIR_MK! !PLUGINS_DIR_MK! !SCRIPT_DIR_MK! !FIGURE_DIR_MK! > nul 2>&1
        mkdir !DL_TEMP_DIR_MK! !SVZIP_DIR_MK! !FILE_TEMP_DIR_MK! > nul 2>&1

        @rem 作業ディレクトリの設定
        set AVIUTL_DIR=%INSTALL_DIR%\AviUtl
        set PLUGINS_DIR=!AVIUTL_DIR!\plugins
        set FIGURE_DIR=!PLUGINS_DIR!\figure
        set SCRIPT_DIR=!PLUGINS_DIR!\script
        set DL_DIR=!AVIUTL_DIR!\DL_TEMP
        set SVZIP_DIR=!DL_DIR!\7z
        set FILE_DIR=!AVIUTL_DIR!\FILE_TEMP
    ) else (
        @rem アップデートを選択
        @rem AviUtlディレクトリ
        set AVIUTL_DIR=%INSTALL_DIR%
        @rem pluginsディレクトリ
        set PLUGINS_DIR=!AVIUTL_DIR!\plugins
        @rem scriptディレクトリ
        set SCRIPT_DIR=!PLUGINS_DIR!\script

        @rem DLファイルの一時ディレクトリ
        set DL_DIR=!AVIUTL_DIR!\DL_TEMP
        @rem 出力ファイルの一時ディレクトリ
        set FILE_DIR=!AVIUTL_DIR!\FILE_TEMP
        @rem 7zの展開ディレクトリ
        set SVZIP_DIR=!AVIUTL_DIR!\DL_TEMP\7z
        mkdir "!DL_DIR!" "!FILE_DIR!" "!SVZIP_DIR!"
    )
    call :SZ_SETUP
    call :HTOX_SETUP
exit /b

@rem ファイルから完全一致の行を検索する
@rem 引数: %1-ファイル %2-検索する文字列
@rem 戻り値 0<:ヒットした行数 0:ヒットなし
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

@rem ファイルの行数をカウントする
@rem 引数: %1-ファイル
@rem 戻り値 行数
:FILE_LINE_CNT
    set CNT=0
    set FILE_TXT=%1
    for /f "usebackq" %%a in (%FILE_TXT%) do (
        set /a CNT=CNT+1
    )
exit /b !CNT!

@rem AviUtlを実行し、終了する
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

@rem AviUtlが実行されているかチェック
@rem 戻り値 0:ヒット 1:ヒットなし
:SEARCH_EXE
    for /F "usebackq tokens=1" %%a in (`tasklist /fi "IMAGENAME eq aviutl.exe"`) do @set AVIUTL_EXE=%%a
    if /i !AVIUTL_EXE!==aviutl.exe (
        exit /b 0
    )
exit /b 1

@rem ファイルをダウンロードする
@rem 引数: %1-URL %2-ダウンロードしたファイル名
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
    call :SHOW_MSG "ファイルのダウンロードに失敗しました" vbCritical "エラー" "modal"
    rmdir /s /q "%AVIUTL_DIR%"
    exit
:DOWNLOAD_SUCCESS
exit /b

@rem メッセージボックスを表示する
@rem %1-表示テキスト %2-メッセージアイコン(VB) %3-タイトル %4-モーダル設定("modal"でモーダル表示,""で非モーダル表示)
:SHOW_MSG
    if %4=="modal" (
        set MSG_MODAL=vbSystemModal
    ) else (
        set MSG_MODAL=0
    )
    echo msgbox %1,%2  Or %MSG_MODAL%,%3 > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
    del %TEMP%\msgbox.vbs
exit /b

@rem 文字列検索
@rem 引数: %1-検索対象 %2-検索する文字列
@rem 戻り値 0<:ヒットした位置 -1:%1が空白 -2:%2が空白 -3:ヒットなし
:STRSTR
    if "%~1" equ "" exit /b -1
    if "%~2" equ "" exit /b -2
    set s1=%~1
    set s2=%~2
    set s1_p=0
    set s2_p=0
:STRSTR_LOOP
    if /I "!s1:~%s1_p%,1!" neq "!s2:~%s2_p%,1!" (
        @rem 不一致
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

@rem 文字列の長さを返す
@rem 引数: %1-検索対象
@rem 戻り値 0<=:文字数 -1:%1が空白
:STRLEN
    if "%~1" equ "" exit /b -1
    set str=%~1
    set len=0
:STRLEN_LOOP
    if "%str%" equ "" exit /b %len%
    set str=%str:~1%
    set /a len+=1
    goto :STRLEN_LOOP

@rem 英語の月表記から数字に変換
@rem 引数: %1-英語表記の月
@rem 戻り値 1〜12:変換された月 -1:引数なし -2:引数エラー
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

@rem JST日時(yyyy/M/d HH:mm)からUTC年月日(yyyy/M/d)へ変換する
@rem 変数:DTに格納される
@rem 引数: %1-計算対象日時
@rem 戻り値 0:変換成功 -1:引数エラー
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

@rem アップデート配列に対象名を登録
@rem 引数: %1-アップデートのチェック結果 %2-登録する文字列 %3-登録するサブルーチンのラベル
@rem 戻り値 0:成功 -1:引数エラー
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

@rem TEMPフォルダの後始末
:CLEANUP
    rmdir /s /q "%DL_DIR%"
    rmdir /s /q "%FILE_DIR%"
exit /b

@rem 7zの環境構築
:SZ_SETUP
    echo 7zのダウンロード...
    powershell -Command "(new-object System.Net.WebClient).DownloadFile(\"https://ja.osdn.net/frs/redir.php?m=jaist^&f=sevenzip%%2F70468%%2F7z1806.msi\",\"%DL_DIR%\7z.msi\")"
    if %ERRORLEVEL% neq 0 (
        call :CONNECT_ERROR
        exit
    )
    echo 7zのダウンロード完了
    @rem DLした7zを展開
    echo 7zの展開...
    msiexec /a "%DL_DIR%\7z.msi" targetdir="%SVZIP_DIR%" /qn
    @rem 7z.exeを変数に格納
    set SZEXE="%SVZIP_DIR%\Files\7-Zip\7z.exe"
    echo 7zの展開完了
exit /b

@rem HtoXの環境構築
:HTOX_SETUP
    @rem HtoX(HTML解析ツール)のDL
    call :FILE_DOWNLOAD "http://win32lab.com/lib/htox4173.exe" "%DL_DIR%\htox4173.exe"
    @rem HtoXの自己解凍を実行
    %SZEXE% x "%DL_DIR%\htox4173.exe" -aoa -o"%DL_DIR%"
    set HTOX="%DL_DIR%\HtoX32c.exe"
exit /b

@rem x264guiExのインストール
:X264GUIEX_INSTALL
    echo x264guiExのダウンロード...
    call :FILE_DOWNLOAD "https://drive.google.com/uc?id=1fp6i-suNAlwCLsjXovJ-xXuUlNQmMQXK" "%DL_DIR%\%X264GUIEX_ZIP%"
    echo x264guiExのダウンロード完了

    %SZEXE% x "%DL_DIR%\%X264GUIEX_ZIP%" -aoa -o"%TEMP%"
    "%TEMP%\x264guiEx_%X264GUIEX_VER%\auo_setup.exe" -autorun -nogui -dir "%AVIUTL_DIR%"
    rmdir /s /q %TEMP%\x264guiEx_%X264GUIEX_VER%

exit /b

@rem GitHubの最新リリースを取得
@rem 引数: %1-URL %2-最新リリーステキスト出力先
@rem 戻り値 0:成功 -1:引数エラー
:GITHUB_GET_LATEST_RELEASE_VER
    if "%~1" equ "" exit /b -1
    call :FILE_DOWNLOAD %1 "%DL_DIR%\github_release.html"
    @rem htmlを解析
    %HTOX% /I8 "%DL_DIR%\github_release.html" > "%FILE_DIR%\htmlparse.txt"
    @rem psdtoolkitの最新バージョン取得
    findstr /C:"*  v" "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\tag.txt"
    set /p LINE=<"%FILE_DIR%\tag.txt"
    echo %LINE% > "%FILE_DIR%\tag.txt"
exit /b 0

@rem GitHubの最新リリースの日付を取得
@rem 引数: %1-リリース日取得の検索文字列
@rem 結果はGITHUB_DATEに格納する
@rem 戻り値 0:成功 -1:引数エラー
:GITHUB_GET_LATEST_RELEASE_DATE
    if "%~1" equ "" exit /b -1
    findstr /C:%1 "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\date.txt"
    @rem 1行目を代入
    set /p LINE=<"%FILE_DIR%\date.txt"
    @rem 年月日のみを抽出
    call :STRSTR "%LINE%" "this "
    if %ERRORLEVEL% equ -3 (
        call :SHOW_MSG "検索ワード:this が見つけられませんでした。エラー内容をバッチファイル製作者に報告してください" vbCritical "エラー" "modal"
        call :CLEANUP
        exit
    )
    set FRONT_LEN=%ERRORLEVEL%
    call :STRSTR "%LINE%" "・"
    if %ERRORLEVEL% equ -3 (
        call :STRLEN "%LINE%" 
    )
    set LAST_LEN=%ERRORLEVEL%
    set /a FRONT_LEN+=5
    set /a DIFF=%LAST_LEN%-%FRONT_LEN%
    set LINE=!LINE:~%FRONT_LEN%,%DIFF%!
    echo %LINE% > "%FILE_DIR%\date.txt"
    @rem 年月日を変数毎に分割
    set YEAR=
    set MONTH=
    set DAY=
    for /f "usebackq tokens=1,2,3" %%i in ("%FILE_DIR%\date.txt") do (
        set MONTH=%%i
        set DAY=%%j
        set YEAR=%%k
    )
    @rem 文字列の月を数字に変換
    call :CONV_MONTH "%MONTH%"
    set MONTH=%ERRORLEVEL%
    @rem GitHubのリリース日(yyyy/M/d)を代入
    set GITHUB_DATE=%YEAR%/%MONTH%/%DAY:,=%
exit /b 0

@rem PSDToolkitの更新日時を取得
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

@rem PSDToolkit最新バージョン取得
:PSDTOOLKIT_GET_LATEST_VER
    @rem PSDToolkitの最新リリースを取得
    call :GITHUB_GET_LATEST_RELEASE_VER "https://github.com/oov/aviutl_psdtoolkit/releases"
    set PSDTOOLKIT_VER=
    for /f "usebackq tokens=2" %%i in ("%FILE_DIR%\tag.txt") do (
        set PSDTOOLKIT_VER=%%i
    )
exit /b

@rem PSDToolkitアップデートチェック
@rem 戻り値 0:アップデートなし 1:アップデートあり
:PSDTOOLKIT_UPDATE_CHECK
    @rem psdtoolkitの最新tagの日付取得
    call :GITHUB_GET_LATEST_RELEASE_DATE "oov released this "
    set GITHUB_PSD_DATE=%GITHUB_DATE%
    @rem PSDToolkitの更新日時を取得
    call :PSDTOOLKIT_GET_DATE
    if !PSDFILE_DATE! lss !GITHUB_PSD_DATE! (
        exit /b 1
    )
exit /b 0

@rem PSDToolkitのインストール
:PSDTOOLKIT_INSTALL
    call :FILE_DOWNLOAD "https://github.com/oov/aviutl_psdtoolkit/releases/download/%PSDTOOLKIT_VER%/psdtoolkit_%PSDTOOLKIT_VER%.zip" "%DL_DIR%\psdtoolkit_%PSDTOOLKIT_VER%.zip"
    @rem PSDToolKitを展開
    %SZEXE% x "%DL_DIR%\psdtoolkit_%PSDTOOLKIT_VER%.zip" -aoa -o"%PLUGINS_DIR%"

    rmdir /s /q "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
    mkdir "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
    @move "%PLUGINS_DIR%\PSDToolKitDocs" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
    @move "%PLUGINS_DIR%\*.txt" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
    @move "%PLUGINS_DIR%\*.html" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
    @move "%AVIUTL_DIR%\PSDToolKitの説明ファイル群\exedit.txt" "%PLUGINS_DIR%"
    @move "%AVIUTL_DIR%\PSDToolKitの説明ファイル群\lua.txt" "%PLUGINS_DIR%"
exit /b

@rem AviUtl最新バージョンと更新日を取得
@rem AVIUTL_VERとAVIUTL_DATEに格納
:AVIUTL_GET_LATEST_VER_DATE
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/" "%DL_DIR%\aviutl.html"
    %HTOX% /I8 "%DL_DIR%\aviutl.html" > "%FILE_DIR%\htmlparse.txt"
    findstr /I /R /C:"\<aviutl[0-9]." "%FILE_DIR%\htmlparse.txt" > "%FILE_DIR%\list.txt"
    set /p LINE=<"%FILE_DIR%\list.txt"
    echo %LINE% > "%FILE_DIR%\latest.txt"
    for /f "usebackq tokens=1,3" %%i in ("%FILE_DIR%\latest.txt") do (
        set AVIUTL_VER=%%~ni
        set AVIUTL_DATE=%%j
    )
exit /b

@rem AviUtlのアップデートチェック
@rem 戻り値 0:アップデートなし 1:アップデートあり
:AVIUTL_UPDATE_CHECK
    call :AVIUTL_GET_LATEST_VER_DATE
    for %%i in ("%AVIUTL_DIR%\aviutl.exe") do (
        set AVIUTL_EXE_DATE_PRE=%%~ti
    )
    echo %AVIUTL_EXE_DATE_PRE% > "%FILE_DIR%\aviutldatetime.txt"
    set AVIUTL_EXE_DATE=
    for /f "usebackq tokens=1" %%i in ("%FILE_DIR%\aviutldatetime.txt") do (
        set AVIUTL_EXE_DATE=%%i
    )
    if %AVIUTL_EXE_DATE% lss %AVIUTL_DATE% (
        exit /b 1
    )
exit /b 0

@rem AviUtlインストール
:AVIUTL_INSTALL
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/%AVIUTL_VER%.zip" "%DL_DIR%\%AVIUTL_VER%.zip"
    @rem AviUtlの展開
    %SZEXE% x "%DL_DIR%\%AVIUTL_VER%.zip" -aoa -o"%AVIUTL_DIR%"
    set AVIUTL_DATE=
    for %%i in ("%AVIUTL_DIR%\aviutl.exe") do (
        set AVIUTL_DATE=%%~ti
    )

    if "%AVIUTL_VER%"=="aviutl100" (
        @rem LargeAddressAwareを有効化
        echo AviUtlのLargeAddressAwareを有効にします（これには1分ほどかかります）
        echo 0%%完了
        powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -first 262 | Set-Content -en byte \"%AVIUTL_DIR%\A-1.bin\""
        echo 25%%完了
        powershell -Command "[System.Text.Encoding]::ASCII.GetBytes(\"/\") | Set-Content -en byte \"%AVIUTL_DIR%\A-12.bin\""
        echo 50%%完了
        powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -last 487161 | Set-Content -en byte \"%AVIUTL_DIR%\A-2.bin\""
        echo 75%%完了
        copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.exe"
        powershell -Command "Set-ItemProperty \"%AVIUTL_DIR%\aviutl.exe\" -name LastWriteTime -value \"%AVIUTL_DATE%""
        del "%AVIUTL_DIR%"\*.bin
        echo 100%%完了
    )
exit /b

@rem 拡張編集の最新バージョンと更新日を取得
@rem EXEDIT_VERとEXEDIT_DATEに格納
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

@rem 拡張編集のアップデートチェック
@rem 戻り値 0:アップデートなし 1:アップデートあり
:EXEDIT_UPDATE_CHECK
    call :EXEDIT_GET_LATEST_VER_DATE
    for %%i in ("%AVIUTL_DIR%\plugins\exedit.auf") do (
        set EXEDIT_AUF_DATE_PRE=%%~ti
    )
    echo %EXEDIT_AUF_DATE_PRE% > "%FILE_DIR%\exeditdatetime.txt"
    set EXEDIT_AUF_DATE=
    for /f "usebackq tokens=1" %%i in ("%FILE_DIR%\exeditdatetime.txt") do (
        set EXEDIT_AUF_DATE=%%i
    )
    if %EXEDIT_AUF_DATE% lss %EXEDIT_DATE% (
        exit /b 1
    )
exit /b 0

@rem 拡張編集インストール
:EXEDIT_INSTALL
    call :FILE_DOWNLOAD "http://spring-fragrance.mints.ne.jp/aviutl/%EXEDIT_VER%.zip" "%DL_DIR%\%EXEDIT_VER%.zip"
    @rem 拡張編集の展開
    %SZEXE% x "%DL_DIR%\%EXEDIT_VER%.zip" -aoa -o"%PLUGINS_DIR%"
exit /b

@rem リリースノート
@rem 2019/9/19(v3.2.0)
@rem     LargeAddressAwareを有効化後のaviutl.exeの更新日をオリジナルと同じにするように変更
@rem     作業環境構築ルーチン追加
@rem     英語表記の月の条件分岐を修正
@rem     文章の修正
@rem 2019/7/4 (v3.1.0)
@rem     GitHubのリリース日の取得を修正
@rem     エラー処理を追加
@rem 2019/5/12 (v3.0.1)
@rem     インデントとコメント,初回インストール時のコメントをメンテナンス
@rem 2019/5/12 (v3.0.0)
@rem     PSDToolkitのアップデート機能を追加
@rem     x264guiExのアップデート機能を追加
@rem     最新のPSDToolkitをインストールするように変更
@rem 2019/5/11 (v2.2.0)
@rem     インストールパスに空白があった際にダウンロードエラー及び、aviutl.iniファイルの編集が出来ていなかったのを修正
@rem 2019/5/4 (v2.1.0)
@rem     httpsの接続を行ったときに、"SSL/TLS のセキュリティで保護されているチャネルを作成できませんでした"と表示されてダウンロードエラーとなってしまうことがあったのを修正
@rem 2019/4/29 (v2.0.0)
@rem     ファイルのダウンロードをダウンロードしたwgetからInvoke-WebRequest(wget)に変更
@rem 2019/4/29 (v1.6.0)
@rem     ダウンロードエラー時に再試行をするように変更
@rem     インストール実行前にAviUtlの起動チェックを追加
@rem 2019/4/24 (v1.5.0)
@rem     風揺れTがサブフォルダに入っていたのを修正
@rem     メッセージボックスをサブルーチン化
@rem 2019/4/22 (v1.4.0)
@rem     ダウンロード処理をサブルーチン化
@rem 2019/4/21 (v1.3.0)
@rem     ダウンロードエラー表示を追加
@rem     x256guiExのダウンロード先を変更
@rem     設定ファイルがうまく編集されない可能性があったのを修正
@rem     aviutl.exeの検索がうまくされてない可能性があるのを修正
@rem 2019/4/16 (v1.2.0)
@rem     設定ファイルがうまく編集できていなかったのを修正
@rem 2019/3/26 (v1.1.1)
@rem     PSDToolKitのバージョン変更に対応
@rem 2019/3/2 (v1.1.0)
@rem     空白文字入りでもインストールできるように修正
@rem     タスクキルの確実性をアップ
@rem     実行状態の表示を追加
@rem     ダウンロード失敗時にメッセージウィンドウを表示するように変更
@rem 2019/2/24 (v1.0.0)
@rem     初回リリース
