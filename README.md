# VVC编码测试项目

这个项目用于测试VVC（Versatile Video Coding）编码器在不同视频序列上的性能。

## 项目结构

```
TestVedio/
└── dataset_UVG/
    ├── input_yuv/        # 输入YUV文件
    ├── output_yuv/       # 编码输出文件
    ├── result/          # 编码结果和日志
    └── scripts/         # 测试脚本
```

## 测试序列

项目包含以下测试序列：
- Beauty
- HoneyBee
- Jockey
- ReadySteadyGo
- ShakeNDry
- YachtRide

## 编码参数

- 分辨率：1920x1080
- 帧率：120fps
- 色度格式：420
- 位深度：8bit
- QP值：32（低）和52（高）
- 编码模式：lowdelay和lowdelay_P

## 使用方法

1. 确保已安装VVC软件（VTM）
2. 将测试序列YUV文件放入 `input_yuv` 目录
3. 运行对应的测试脚本，例如：
   ```bash
   run_beauty_test.bat
   ```

## 环境要求

- Windows操作系统
- VVC软件（VTM）版本：vs17/msvc-19.44
- 足够的磁盘空间用于存储编码结果

## 注意事项

- 输入YUV文件较大，请确保有足够的磁盘空间
- 编码过程可能需要较长时间，请耐心等待
- 建议分批次运行测试脚本 