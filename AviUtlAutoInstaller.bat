@rem AviUtl Auto Installer Script by minfia

@rem AviUtl Auto Installer Scriptは無保証で提供されます。
@rem このプログラムを使用した事で発生した全ての損害について保証しません。
@rem このプログラムを実行する場合は、ネットワークが接続された場所で、出来るだけ有線接続で実行して下さい。
@rem もしネットワークの接続が上手くいかない場合は時間を置いて実行して下さい。
@rem その際に作成されているAviTulフォルダは自動で削除されいますが、
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
@rem ・バーニングポイント2 (by ティム氏)
@rem ・ライントーン＆ハーフトーン (by ティム氏)
@rem ・PNG出力 (by yu_noimage_氏)

@echo off
setlocal ENABLEDELAYEDEXPANSION

title AviUtl Auto Installer

echo script version 1.1.1
echo これはAviUtlの環境を構築するプログラムです。
echo また、劇場向けの構成となります。
echo AviUtlのインストール先をフルパスで指定してください。
echo また、パスの最後に"\"を付けないで下さい、多分うまくいきません。
echo バッチファイルと同じ場所にインストールする場合はENTERを押してください。
set /P INSTALL_DIR_PRE="インストール先："

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

@rem AviUtlディレクトリ名
set AVIUTL_DIR_NAME=AviUtl
@rem ファイルの一時ディレクトリ名
set DL_DIR_NAME=DL_TEMP
@rem pluginsディレクトリ名
set PLUGINS_DIR_NAME=plugins
@rem figureディレクトリ名
set FIGURE_DIR_NAME=figure
@rem scriptディレクトリ名
set SCRIPT_DIR_NAME=script
@rem 7zディレクトリ名
set SVZIP_DIR_NAME=7z
@rem wgetディレクトリ名
set WGET_DIR_NAME=wget

@rem AviUtlディレクトリ作成
set AVIUTL_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%
mkdir %AVIUTL_DIR_MK%
@rem ファイルの一時ディレクトリ作成
set DL_TEMP_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%DL_DIR_NAME%
mkdir %DL_TEMP_DIR_MK%
@rem pluginsディレクトリ作成
set PLUGINS_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%
mkdir %PLUGINS_DIR_MK%
@rem figureディレクトリ作成
set FIGURE_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%\%FIGURE_DIR_NAME%
mkdir %FIGURE_DIR_MK%
@rem scriptディレクトリ作成
set SCRIPT_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%PLUGINS_DIR_NAME%\%SCRIPT_DIR_NAME%
mkdir %SCRIPT_DIR_MK%
@rem 7zディレクトリ作成
set SVZIP_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%SVZIP_DIR_NAME%
mkdir %SVZIP_DIR_MK%
@rem wgetディレクトリ作成
set WGET_DIR_MK=%INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%WGET_DIR_NAME%
mkdir %WGET_DIR_MK%

@rem AviUtlディレクトリ
set AVIUTL_DIR=%INSTALL_DIR%\AviUtl
@rem ファイルの一時ディレクトリ
set DL_DIR=%AVIUTL_DIR%\DL_TEMP
@rem pluginsディレクトリ
set PLUGINS_DIR=%AVIUTL_DIR%\plugins
@rem figureディレクトリ
set FIGURE_DIR=%PLUGINS_DIR%\figure
@rem scriptディレクトリ
set SCRIPT_DIR=%PLUGINS_DIR%\script
@rem 7zの展開ディレクトリ
set SVZIP_DIR=%AVIUTL_DIR%\7z
@rem wgetの展開ディレクトリ
set WGET_DIR=%AVIUTL_DIR%\wget


@rem 7zの環境構築
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

@rem wgetの環境構築
echo wgetのダウンロード...
powershell -Command "(new-object System.Net.WebClient).DownloadFile(\"https://eternallybored.org/misc/wget/%WGET_VER%/32/wget.exe\",\"%WGET_DIR%\wget.exe\")"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
echo wgetのダウンロード完了
@rem wget.exeを変数に格納
set WGETEXE="%WGET_DIR%\wget.exe"


@rem 基本環境構築
@rem 基本ファイルのDL
%WGETEXE% http://spring-fragrance.mints.ne.jp/aviutl/%AVIUTL_ZIP% -O "%DL_DIR%\%AVIUTL_ZIP%"
%WGETEXE% http://spring-fragrance.mints.ne.jp/aviutl/%EXEDIT_ZIP% -O "%DL_DIR%\%EXEDIT_ZIP%"
%WGETEXE% --no-check-certificate https://pop.4-bit.jp/bin/l-smash/%LSMASH_ZIP% -O "%DL_DIR%\%LSMASH_ZIP%"
%WGETEXE% --no-check-certificate https://drive.google.com/uc?id=10RpwYSiSjjp4f0uIEOQzGuc1YOVF24u_ -O "%DL_DIR%\%X264GUIEX_ZIP%"

@rem AviUtlの展開
%SZEXE% x "%DL_DIR%\%AVIUTL_ZIP%" -aoa -o"%AVIUTL_DIR%"

@rem LargeAddressAwareを有効化
echo AviUtlのLargeAddressAwareを有効にします(これには1分ほどかかります)
echo 0%%完了
powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -first 262 | Set-Content -en byte \"%AVIUTL_DIR%\A-1.bin\""
echo 25%%完了
powershell -Command "[System.Text.Encoding]::ASCII.GetBytes(\"/\") | Set-Content -en byte \"%AVIUTL_DIR%\A-12.bin\""
echo 50%%完了
powershell -Command "Get-Content -en byte \"%AVIUTL_DIR%\aviutl.exe\" | Select-Object -last 487161 | Set-Content -en byte \"%AVIUTL_DIR%\A-2.bin\""
echo 75%%完了
copy /b /y "%AVIUTL_DIR%\A-1.bin" + "%AVIUTL_DIR%\A-12.bin" + "%AVIUTL_DIR%\A-2.bin" "%AVIUTL_DIR%\aviutl.exe"
del "%AVIUTL_DIR%"\*.bin
echo 100%%完了

@rem AviUtlの設定ファイルを生成する
call :EXEC_AVIUTL

@rem aviutlの設定ファイルを編集
@rem 変更内容
@rem 最大画像サイズ(1280x720 -> 2200x1200)
@rem キャッシュフレーム数(8 -> 32)
@rem リサイズ解像度リスト(1920x1080を追加)
@rem 再生ウィンドウをメインウィンドウに表示する(無効 -> 有効)
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

@rem プラグインなどを展開
%SZEXE% x "%DL_DIR%\%EXEDIT_ZIP%" -aoa -o"%PLUGINS_DIR%"
%SZEXE% x "%DL_DIR%\%LSMASH_ZIP%" -aoa -o"%DL_DIR%"
@move "%DL_DIR%\lw*.*" "%PLUGINS_DIR%"
%SZEXE% x "%DL_DIR%\%X264GUIEX_ZIP%" -aoa -o"%TEMP%"
"%TEMP%\x264guiEx_%X264GUIEX_VER%\auo_setup.exe" -autorun -nogui -dir "%AVIUTL_DIR%"
rmdir /s /q %TEMP%\x264guiEx_%X264GUIEX_VER%


@rem 劇場向け環境構築
@rem 一時ディレクトリを再作成
rmdir /s /q "%DL_DIR%"
mkdir %INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\%DL_DIR_NAME%

@rem 劇場向けファイルのDL
%WGETEXE% https://github.com/oov/aviutl_psdtoolkit/releases/download/%PSDTOOLKIT_VER%/%PSDTOOLKIT_ZIP% -O "%DL_DIR%\%PSDTOOLKIT_ZIP%"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem 風揺れ
%WGETEXE% https://tim3.web.fc2.com/script/WindShk.zip -O "%DL_DIR%\WindShk.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem インク（＋ひょうたん）
%WGETEXE% https://tim3.web.fc2.com/script/InkV2.zip -O "%DL_DIR%\InkV2.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem 縁取りT
%WGETEXE% https://tim3.web.fc2.com/script/Framing.zip -O "%DL_DIR%\Framing.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem リール回転
%WGETEXE% https://tim3.web.fc2.com/script/ReelRot.zip -O "%DL_DIR%\ReelRot.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem バーニングポイント2
%WGETEXE% https://tim3.web.fc2.com/script/VanishP2_V2.zip -O "%DL_DIR%\VanishP2_V2.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem ライントーン＆ハーフトーン
%WGETEXE% https://tim3.web.fc2.com/script/LinHal.zip -O "%DL_DIR%\LinHal.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)
@rem PNG出力
%WGETEXE% http://auls.client.jp/plugin/auls_outputpng.zip -O "%DL_DIR%\auls_outputpng.zip"
if %ERRORLEVEL% neq 0 (
call :CONNECT_ERROR
exit
)

@rem PSDToolKitを展開
%SZEXE% x "%DL_DIR%\%PSDTOOLKIT_ZIP%" -aoa -o"%PLUGINS_DIR%"
mkdir %INSTALL_DIR_PRE%\%AVIUTL_DIR_NAME%\PSDToolKitの説明ファイル群
@move "%PLUGINS_DIR%\PSDToolKitDocs" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
@move "%PLUGINS_DIR%\*.txt" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
@move "%PLUGINS_DIR%\*.html" "%AVIUTL_DIR%\PSDToolKitの説明ファイル群"
@move "%AVIUTL_DIR%\PSDToolKitの説明ファイル群\exedit.txt" "%PLUGINS_DIR%"
@move "%AVIUTL_DIR%\PSDToolKitの説明ファイル群\lua.txt" "%PLUGINS_DIR%"

@rem ティム氏のスクリプトを展開
set TIM3_DIR_MK=%SCRIPT_DIR_MK%\ティム氏
mkdir %TIM3_DIR_MK%
set TIM3_DIR=%SCRIPT_DIR%\ティム氏
%SZEXE% x "%DL_DIR%\WindShk.zip" -aoa -o"%TIM3_DIR%"
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
rmdir /s /q "%DL_DIR%"
rmdir /s /q "%SVZIP_DIR%"
rmdir /s /q "%WGET_DIR%"

echo msgbox "インストールが完了しました",vbInformation,"情報" > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
del %TEMP%\msgbox.vbs
for /F "usebackq tokens=1" %%a in (`tasklist /fi "IMAGENAME eq aviutl.exe"`) do @set AVIUTL_EXE=%%a
if /i not %AVIUTL_EXE%==aviutl.exe (
goto SEARCH_EXE
)
exit

@rem 以下、サブルーチン

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
echo msgbox "ファイルのダウンロードに失敗しました",vbCritical,"エラー" > %TEMP%\msgbox.vbs & %TEMP%\msgbox.vbs
del %TEMP%\msgbox.vbs
rmdir /s /q "%AVIUTL_DIR%"
exit /b

@rem リリースノート
@rem 2019/3/26
@rem     PSDToolKitのバージョン変更に対応
@rem 2019/3/2
@rem     空白文字入りでもインストールできるように修正
@rem     タスクキルの確実性をアップ
@rem     実行状態の表示を追加
@rem     ダウンロード失敗時にメッセージウィンドウを表示するように変更
@rem 2019/2/24
@rem     初回リリース