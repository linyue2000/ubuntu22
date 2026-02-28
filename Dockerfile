FROM ubuntu:22.04

# 1. 屏蔽交互提示，设置时区和语言字符集
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# 2. 从官方源直接拉取 JDK 21 和所有底层依赖（彻底告别 PPA）
RUN apt-get update && apt-get install -y --no-install-recommends \
    # 核心：直接用 22.04 官方更新源里的 21 编译器！
    openjdk-21-jdk-headless \
    # 音频分析必备
    ffmpeg \
    # Audiveris OMR 强依赖
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-osd \
    # 图像处理和 Java AWT 所需的底层库
    libglib2.0-0 \
    libgl1 \
    libgomp1 \
    libpng16-16 \
    libjpeg-turbo8 \
    libtiff5 \
    libfontconfig1 \
    libfreetype6 \
    libxrender1 \
    libxtst6 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. 设置全局 JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin
