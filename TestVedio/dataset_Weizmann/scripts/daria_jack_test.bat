@echo off
setlocal enabledelayedexpansion

:: Set paths
set VTM_PATH=E:\AProject\VVCSoftware_VTM
set INPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\input_yuv
set OUTPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\vvc_files
set RECON_DIR=E:\AProject\TestVedio\dataset_Weizmann\output_yuv
set RESULTS_DIR=E:\AProject\TestVedio\dataset_Weizmann\result

:: Video file name
set filename=daria_jack

:: Create result files if not exist
if not exist "%RESULTS_DIR%\encoding_results.csv" (
    echo Video,Config,QP,OriginalSize,CompressedSize,CompressionRatio,PSNR,EncodingTime > "%RESULTS_DIR%\encoding_results.csv"
)

echo ========================================
echo Starting remaining encoding tests for %filename%
echo ========================================
echo %date% %time%: Starting remaining %filename% encoding >> "%RESULTS_DIR%\encoding_log.txt"

:: Only test remaining configurations
set configs=encoder_intra_vtm.cfg
set config_names=intra
set qp_values=22 32 42 50

:: Set encoding for log files
chcp 65001 > nul

:: Loop through configurations
for %%c in (%configs%) do (
    if "%%c"=="encoder_intra_vtm.cfg" set config_dir=intra
    
    echo.
    echo Processing configuration: !config_dir!
    
    :: Loop through QP values
    for %%q in (%qp_values%) do (
        echo   Testing QP: %%q
        
        :: Create output directories if they don't exist
        if not exist "%OUTPUT_DIR%\!config_dir!" mkdir "%OUTPUT_DIR%\!config_dir!"
        if not exist "%RECON_DIR%\!config_dir!" mkdir "%RECON_DIR%\!config_dir!"
        if not exist "%RESULTS_DIR%\!config_dir!" mkdir "%RESULTS_DIR%\!config_dir!"
        
        :: Get original file size
        for %%f in ("%INPUT_DIR%\%filename%.yuv") do set original_size=%%~zf
        
        :: Record start time
        set start_time=!time!
        
        :: Run encoder
        echo     Running VTM encoder...
        "%VTM_PATH%\bin\vs17\msvc-19.44\x86_64\release\EncoderApp.exe" ^
            -c "%VTM_PATH%\cfg\%%c" ^
            -i "%INPUT_DIR%\%filename%.yuv" ^
            -wdt 180 -hgt 144 -fr 25 -f 89 ^
            -q %%q ^
            -b "%OUTPUT_DIR%\!config_dir!\%filename%_q%%q.bin" ^
            -o "%RECON_DIR%\!config_dir!\%filename%_q%%q_reconstructed.yuv" ^
            > "%RESULTS_DIR%\!config_dir!\%filename%_q%%q_encoder_log.txt" 2>&1
        
        :: Record end time
        set end_time=!time!
        
        :: Get compressed file size
        for %%f in ("%OUTPUT_DIR%\!config_dir!\%filename%_q%%q.bin") do set compressed_size=%%~zf
        
        :: Calculate compression ratio
        set /a compression_ratio=!original_size!/!compressed_size!
        
        :: Extract PSNR from log file (simplified - you may need to adjust this)
        set psnr=N/A
        for /f "tokens=*" %%i in ('findstr /c:"SUMMARY" "%RESULTS_DIR%\!config_dir!\%filename%_q%%q_encoder_log.txt"') do (
            set psnr=%%i
        )
        
        :: Write results to CSV
        echo %filename%,!config_dir!,%%q,!original_size!,!compressed_size!,!compression_ratio!,!psnr!,!start_time!-!end_time! >> "%RESULTS_DIR%\encoding_results.csv"
        
        :: Log completion
        echo %date% %time%: Completed %filename% !config_dir! QP%%q >> "%RESULTS_DIR%\encoding_log.txt"
        
        echo     Completed: Original=!original_size! bytes, Compressed=!compressed_size! bytes, Ratio=!compression_ratio!:1
    )
)

echo.
echo ========================================
echo Remaining encoding tests completed for %filename%
echo ========================================
echo %date% %time%: Finished remaining %filename% encoding >> "%RESULTS_DIR%\encoding_log.txt"

pause 