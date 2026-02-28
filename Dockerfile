FROM ubuntu:22.04

# 1. 环境变量：屏蔽交互、设置时区、字符集（解决中文乱码与 Java 读写问题）
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 2. 合并所有安装逻辑：减少镜像层数，清理缓存以减小体积
RUN apt-get update && apt-get install -y --no-install-recommends \
    # 基础工具与 Java 21 所需的 PPA 管理工具
    software-properties-common \
    ca-certificates \
    curl \
    # 添加 Java 21 的官方 PPA (Ubuntu 22.04 官方仓库只到 JDK 17)
    && add-apt-repository ppa:openjdk-r/ppa -y \
    && apt-get update && apt-get install -y --no-install-recommends \
    # 安装 Java 21 JRE (Headless 版更精简，如果 Audiveris 报错再换成普通版)
    openjdk-21-jre-headless \
    # 安装 FFmpeg
    ffmpeg \
    # Tesseract OCR 引擎 (OMR 强依赖)
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-osd \
    # 底层图像与运算库 (OpenCV & Java AWT 所需)
    libglib2.0-0 \
    libgl1 \
    libgomp1 \
    libpng16-16 \
    libjpeg8 \
    libtiff5 \
    libfontconfig1 \
    libfreetype6 \
    libxrender1 \
    libxtst6 \
    # 彻底清理 apt 缓存，不留工业垃圾
    && rm -rf /var/lib/apt/lists/*

# 3. 设置 Java 环境变量 (确保 java 命令全局可用)
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# 4. 工作目录与卷挂载点 (配合你之前的 /data 逻辑)
WORKDIR /app


