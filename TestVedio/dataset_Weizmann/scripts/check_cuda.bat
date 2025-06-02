@echo off
echo 检查CUDA环境...
echo ========================================

:: 检查Python版本
echo 检查Python版本：
python --version

:: 检查PyTorch和CUDA
echo.
echo 检查PyTorch和CUDA：
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA是否可用:', torch.cuda.is_available()); print('CUDA版本:', torch.version.cuda if torch.cuda.is_available() else '不可用')"

:: 检查CUDA驱动
echo.
echo 检查CUDA驱动：
nvidia-smi

echo.
echo ========================================
pause 