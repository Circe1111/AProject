@echo off
setlocal enabledelayedexpansion

:: 设置路径
set VTM_PATH=E:\AProject\VVCSoftware_VTM
set INPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\input_yuv
set OUTPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\vvc_files
set RECON_DIR=E:\AProject\TestVedio\dataset_Weizmann\output_yuv
set RESULTS_DIR=E:\AProject\TestVedio\dataset_Weizmann\result

:: 视频文件名
set filename=daria_jack

:: 创建结果文件（如果不存在）
if not exist "%RESULTS_DIR%\encoding_results.csv" (
    echo Video,Config,QP,OriginalSize,CompressedSize,CompressionRatio,PSNR,EncodingTime > "%RESULTS_DIR%\encoding_results.csv"
)

echo ========================================
echo 开始编码测试：%filename%
echo ========================================
echo %date% %time%: 开始 %filename% 编码 >> "%RESULTS_DIR%\encoding_log.txt"

:: 设置配置文件和QP值
set configs=encoder_lowdelay_P_vtm.cfg
set config_names=lowdelay
set qp_values=42 32

:: 设置编码
chcp 65001 > nul

:: 遍历配置文件
for %%c in (%configs%) do (
    if "%%c"=="encoder_lowdelay_P_vtm.cfg" set config_dir=lowdelay
    
    echo.
    echo 处理配置: !config_dir!
    
    :: 遍历QP值
    for %%q in (%qp_values%) do (
        echo  测试 QP: %%q
        
        :: 创建输出目录（如果不存在）
        if not exist "%OUTPUT_DIR%\!config_dir!" mkdir "%OUTPUT_DIR%\!config_dir!"
        if not exist "%RECON_DIR%\!config_dir!" mkdir "%RECON_DIR%\!config_dir!"
        if not exist "%RESULTS_DIR%\!config_dir!" mkdir "%RESULTS_DIR%\!config_dir!"
        
        :: 获取原始文件大小
        for %%f in ("%INPUT_DIR%\%filename%.yuv") do set original_size=%%~zf
        
        :: 记录开始时间
        set start_time=!time!
        
        :: 运行编码器
        echo     运行 VTM 编码器...
        "%VTM_PATH%\bin\vs17\msvc-19.44\x86_64\release\EncoderApp.exe" ^
            -c "%VTM_PATH%\cfg\%%c" ^
            -i "%INPUT_DIR%\%filename%.yuv" ^
            -wdt 180 -hgt 144 -fr 25 -f 89 ^
            -q %%q ^
            -b "%OUTPUT_DIR%\!config_dir!\%filename%_q%%q.bin" ^
            -o "%RECON_DIR%\!config_dir!\%filename%_q%%q_reconstructed.yuv" ^
            > "%RESULTS_DIR%\!config_dir!\%filename%_q%%q_encoder_log.txt" 2>&1
        
        :: 记录结束时间
        set end_time=!time!
        
        :: 获取压缩文件大小
        for %%f in ("%OUTPUT_DIR%\!config_dir!\%filename%_q%%q.bin") do set compressed_size=%%~zf
        
        :: 计算压缩比
        set /a compression_ratio=!original_size!/!compressed_size!
        
        :: 从日志文件中提取PSNR
        set psnr=N/A
        for /f "tokens=*" %%i in ('findstr /c:"SUMMARY" "%RESULTS_DIR%\!config_dir!\%filename%_q%%q_encoder_log.txt"') do (
            set psnr=%%i
        )
        
        :: 写入结果到CSV
        echo %filename%,!config_dir!,%%q,!original_size!,!compressed_size!,!compression_ratio!,!psnr!,!start_time!-!end_time! >> "%RESULTS_DIR%\encoding_results.csv"
        
        :: 记录完成
        echo %date% %time%: 完成 %filename% !config_dir! QP%%q >> "%RESULTS_DIR%\encoding_log.txt"
        
        echo     完成: 原始大小=!original_size! 字节, 压缩后=!compressed_size! 字节, 压缩比=!compression_ratio!:1
    )
)

echo.
echo ========================================
echo 编码测试完成：%filename%
echo ========================================
echo %date% %time%: 完成 %filename% 编码 >> "%RESULTS_DIR%\encoding_log.txt"

pause 