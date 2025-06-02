@echo off
echo 开始安装PyTorch...
echo ========================================

:: 卸载现有的PyTorch（如果有）
echo 卸载现有的PyTorch...
pip uninstall torch torchvision torchaudio -y

:: 安装PyTorch（使用CUDA 12.1版本，因为这是最接近您系统CUDA 12.3的稳定版本）
echo 安装PyTorch...
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

:: 验证安装
echo.
echo 验证安装：
python -c "import torch; print('PyTorch版本:', torch.__version__); print('CUDA是否可用:', torch.cuda.is_available()); print('CUDA版本:', torch.version.cuda if torch.cuda.is_available() else '不可用')"

echo.
echo ========================================
pause 