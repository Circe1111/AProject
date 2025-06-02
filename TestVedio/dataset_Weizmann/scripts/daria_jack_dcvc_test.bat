@echo off
setlocal enabledelayedexpansion

:: 设置路径
set DCVC_PATH=E:\AProject\DCVC
set INPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\input_yuv
set OUTPUT_DIR=E:\AProject\TestVedio\dataset_Weizmann\vvc_files
set RECON_DIR=E:\AProject\TestVedio\dataset_Weizmann\output_yuv
set RESULTS_DIR=E:\AProject\TestVedio\dataset_Weizmann\result
set CONFIG_DIR=E:\AProject\TestVedio\dataset_Weizmann\config_dcvc

:: 视频文件名
set filename=daria_jack

:: 设置QP值（可以在这里修改）
set qp_values=35

:: 创建结果文件（如果不存在）
if not exist "%RESULTS_DIR%\encoding_results.csv" (
    echo Video,Config,QP,OriginalSize,CompressedSize,CompressionRatio,PSNR,EncodingTime > "%RESULTS_DIR%\encoding_results.csv"
)

echo ========================================
echo 开始编码测试：%filename%
echo ========================================
echo %date% %time%: 开始 %filename% 编码 >> "%RESULTS_DIR%\encoding_log.txt"

:: 检查Python环境
echo 检查Python环境...
python -c "import sys; print('Python版本:', sys.version)" > "%RESULTS_DIR%\dcvc\python_info.txt"
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA是否可用:', torch.cuda.is_available())" >> "%RESULTS_DIR%\dcvc\python_info.txt"
python -c "import PIL; print('PIL版本:', PIL.__version__)" >> "%RESULTS_DIR%\dcvc\python_info.txt"

:: 设置编码
chcp 65001 > nul

:: 遍历QP值
for %%q in (%qp_values%) do (
    echo  测试 QP: %%q
    
    :: 创建输出目录（如果不存在）
    if not exist "%OUTPUT_DIR%\dcvc" mkdir "%OUTPUT_DIR%\dcvc"
    if not exist "%RECON_DIR%\dcvc" mkdir "%RECON_DIR%\dcvc"
    if not exist "%RESULTS_DIR%\dcvc" mkdir "%RESULTS_DIR%\dcvc"
    
    :: 获取原始文件大小
    for %%f in ("%INPUT_DIR%\%filename%.yuv") do set original_size=%%~zf
    
    :: 记录开始时间
    set start_time=!time!
    
    :: 运行DCVC编码器
    echo     运行 DCVC 编码器...
    echo 开始时间: !start_time! > "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo 输入文件: %INPUT_DIR%\%filename%.yuv >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo 输出文件: %OUTPUT_DIR%\dcvc\%filename%_q%%q.bin >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo 重建文件: %RECON_DIR%\dcvc\%filename%_q%%q_reconstructed.yuv >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo 配置文件: %CONFIG_DIR%\%filename%_config.json >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo. >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    
    python "%DCVC_PATH%\test_video.py" ^
        --test_config "%CONFIG_DIR%\%filename%_config.json" ^
        --output_path "%OUTPUT_DIR%\dcvc\%filename%_q%%q.bin" ^
        --save_decoded_frame "%RECON_DIR%\dcvc\%filename%_q%%q_reconstructed.yuv" ^
        --qp_i %%q ^
        --qp_p %%q ^
        --force_intra 1 ^
        --cuda 1 ^
        --verbose 1 ^
        >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt" 2>&1
    
    :: 记录结束时间
    set end_time=!time!
    echo. >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    echo 结束时间: !end_time! >> "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"
    
    :: 获取压缩文件大小
    for %%f in ("%OUTPUT_DIR%\dcvc\%filename%_q%%q.bin") do set compressed_size=%%~zf
    
    :: 计算压缩比
    set /a compression_ratio=!original_size!/!compressed_size!
    
    :: 从日志文件中提取PSNR
    set psnr=N/A
    for /f "tokens=*" %%i in ('findstr /c:"PSNR" "%RESULTS_DIR%\dcvc\%filename%_q%%q_encoder_log.txt"') do (
        set psnr=%%i
    )
    
    :: 写入结果到CSV
    echo %filename%,dcvc,%%q,!original_size!,!compressed_size!,!compression_ratio!,!psnr!,!start_time!-!end_time! >> "%RESULTS_DIR%\encoding_results.csv"
    
    :: 记录完成
    echo %date% %time%: 完成 %filename% dcvc QP%%q >> "%RESULTS_DIR%\encoding_log.txt"
    
    echo     完成: 原始大小=!original_size! 字节, 压缩后=!compressed_size! 字节, 压缩比=!compression_ratio!:1
)

echo.
echo ========================================
echo 编码测试完成：%filename%
echo ========================================
echo %date% %time%: 完成 %filename% 编码 >> "%RESULTS_DIR%\encoding_log.txt"

pause 