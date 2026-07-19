# Separate GPU service for Qwen-Image-Edit.
# Requires an NVIDIA CUDA GPU. It is intentionally not compatible with the
# existing CPU-only LocalAI Railway service.
FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    HF_HOME=/data/huggingface \
    HUGGINGFACE_HUB_CACHE=/data/huggingface/hub \
    TRANSFORMERS_CACHE=/data/huggingface/transformers \
    GRADIO_SERVER_NAME=0.0.0.0 \
    GRADIO_ANALYTICS_ENABLED=False

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3.12 python3.12-venv python3-pip \
        git build-essential ffmpeg libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/qwen-image-edit

# Keep this overrideable from Railway's build arguments, but use the upstream
# default branch unless a specific known-good revision is supplied.
ARG QWEN_IMAGE_EDIT_REF=main
RUN git clone --depth 1 --branch "${QWEN_IMAGE_EDIT_REF}" \
      https://github.com/PRITHIVSAKTHIUR/Qwen-Image-Edit-2511-LoRAs-Fast-Lazy-Load.git .

RUN python3.12 -m pip install --upgrade pip \
    && python3.12 -m pip install --no-cache-dir -r pre-requirements.txt \
    && python3.12 -m pip install --no-cache-dir -r requirements.txt

COPY qwen-image-edit-gpu/railway_entrypoint.py /opt/qwen-image-edit/railway_entrypoint.py

# Gradio defaults to 7860; the entrypoint honors Railway's PORT at runtime.
EXPOSE 7860
CMD ["python3.12", "/opt/qwen-image-edit/railway_entrypoint.py"]
