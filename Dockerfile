FROM ubuntu:22.04

# 1. 屏蔽交互提示，设置时区和语言字符集（防止 Java 读写含有中文路径的谱子时乱码）
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 3. 安装底层依赖（核心避坑区）
# 虽然你有自己的 .so，但 .so 依然会依赖操作系统的基础 C/C++ 库和图形库
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Tesseract OCR 引擎及其英文/数学符号训练数据（OMR 强依赖）
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-osd \
    # OpenCV 和 Tesseract 可能会用到的底层运算和图像库
    libglib2.0-0 \
    libgl1 \
    libgomp1 \
    libpng16-16 \
    libjpeg8 \
    libtiff5 \
    # Java AWT Headless 模式绘图所需的字体和渲染库
    libfontconfig1 \
    libfreetype6 \
    libxrender1 \
    libxtst6 \
    # 常用工具，方便在容器内 debug（查 Log、排查依赖）
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    # ... 前面的 Tesseract 和图形库保持不变 ...
    libxrender1 \
    libxtst6 \
    # 加入 FFmpeg
    ffmpeg \
    # 常用工具
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

