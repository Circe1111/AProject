@echo off
REM ============= 可配置参数 =============
set QP_LOW=32
set QP_HIGH=52
REM =====================================

set VVC_PATH=E:\AProject\VVCSoftware_VTM\bin\vs17\msvc-19.44\x86_64\release
set INPUT_PATH=E:\AProject\TestVedio\dataset_UVG\input_yuv
set OUTPUT_PATH=E:\AProject\TestVedio\dataset_UVG\output_yuv
set RESULT_PATH=E:\AProject\TestVedio\dataset_UVG\result
set CONFIG_PATH=E:\AProject\VVCSoftware_VTM\cfg

REM 检查必要文件是否存在
if not exist "%VVC_PATH%\EncoderApp.exe" (
    echo Error: EncoderApp.exe not found at %VVC_PATH%
    exit /b 1
)

if not exist "%INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv" (
    echo Error: Input file not found at %INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv
    exit /b 1
)

if not exist "%CONFIG_PATH%\encoder_lowdelay_vtm.cfg" (
    echo Error: Config file not found at %CONFIG_PATH%\encoder_lowdelay_vtm.cfg
    exit /b 1
)

if not exist "%CONFIG_PATH%\encoder_lowdelay_P_vtm.cfg" (
    echo Error: Config file not found at %CONFIG_PATH%\encoder_lowdelay_P_vtm.cfg
    exit /b 1
)

REM Create output directories if they don't exist
mkdir "%OUTPUT_PATH%\lowdelay" 2>nul
mkdir "%OUTPUT_PATH%\lowdelay_P" 2>nul
mkdir "%RESULT_PATH%\lowdelay" 2>nul
mkdir "%RESULT_PATH%\lowdelay_P" 2>nul

echo Starting encoding tests...
echo VVC Path: %VVC_PATH%
echo Input Path: %INPUT_PATH%
echo Output Path: %OUTPUT_PATH%
echo Result Path: %RESULT_PATH%
echo Config Path: %CONFIG_PATH%

REM Run lowdelay tests
echo Running Beauty lowdelay QP%QP_HIGH% test...
"%VVC_PATH%\EncoderApp.exe" -c "%CONFIG_PATH%\encoder_lowdelay_vtm.cfg" -i "%INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv" -b "%OUTPUT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%.bin" -o "%OUTPUT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%_reconstructed.yuv" -q %QP_HIGH% -v 1 -f 120 -wdt 1920 -hgt 1080 -fr 120 -ip 1 > "%RESULT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%_encoder_log.txt" 2>&1

if errorlevel 1 (
    echo Error occurred during lowdelay QP%QP_HIGH% encoding
    exit /b 1
)

echo Running Beauty lowdelay QP%QP_LOW% test...
"%VVC_PATH%\EncoderApp.exe" -c "%CONFIG_PATH%\encoder_lowdelay_vtm.cfg" -i "%INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv" -b "%OUTPUT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%.bin" -o "%OUTPUT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%_reconstructed.yuv" -q %QP_LOW% -v 1 -f 120 -wdt 1920 -hgt 1080 -fr 120 -ip 1 > "%RESULT_PATH%\lowdelay\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%_encoder_log.txt" 2>&1

if errorlevel 1 (
    echo Error occurred during lowdelay QP%QP_LOW% encoding
    exit /b 1
)

REM Run lowdelay_P tests
echo Running Beauty lowdelay_P QP%QP_HIGH% test...
"%VVC_PATH%\EncoderApp.exe" -c "%CONFIG_PATH%\encoder_lowdelay_P_vtm.cfg" -i "%INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv" -b "%OUTPUT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%.bin" -o "%OUTPUT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%_reconstructed.yuv" -q %QP_HIGH% -v 1 -f 120 -wdt 1920 -hgt 1080 -fr 120 -ip 1 > "%RESULT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_HIGH%_encoder_log.txt" 2>&1

if errorlevel 1 (
    echo Error occurred during lowdelay_P QP%QP_HIGH% encoding
    exit /b 1
)

echo Running Beauty lowdelay_P QP%QP_LOW% test...
"%VVC_PATH%\EncoderApp.exe" -c "%CONFIG_PATH%\encoder_lowdelay_P_vtm.cfg" -i "%INPUT_PATH%\Beauty_1920x1080_120fps_420_8bit_YUV.yuv" -b "%OUTPUT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%.bin" -o "%OUTPUT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%_reconstructed.yuv" -q %QP_LOW% -v 1 -f 120 -wdt 1920 -hgt 1080 -fr 120 -ip 1 > "%RESULT_PATH%\lowdelay_P\Beauty_1920x1080_120fps_420_8bit_YUV_q%QP_LOW%_encoder_log.txt" 2>&1

if errorlevel 1 (
    echo Error occurred during lowdelay_P QP%QP_LOW% encoding
    exit /b 1
)

echo All tests completed for Beauty sequence. 