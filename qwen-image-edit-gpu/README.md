# Qwen Image Edit GPU service

This branch packages [Qwen-Image-Edit-2511 with fast lazy-loaded LoRAs](https://github.com/PRITHIVSAKTHIUR/Qwen-Image-Edit-2511-LoRAs-Fast-Lazy-Load) as a separate Railway service.

It is not a replacement for the existing CPU LocalAI service. The upstream application loads a CUDA model at startup and requires an NVIDIA GPU.

## Deploy

1. In Railway, create a **new service** from `kwilson1994/LocalAI`.
2. Set the source branch to `railway-qwen-image-edit-gpu`.
3. Confirm Railway uses the repository's `railway.toml`; it selects `qwen-image-edit-gpu/Dockerfile`.
4. Choose a Railway environment that provides a modern NVIDIA CUDA GPU. Do not deploy this service to the CPU-only LocalAI service.
5. Add a persistent volume mounted at `/data`. This retains the large Hugging Face model and adapter downloads between redeploys.
6. Generate a Railway public domain after the deployment becomes healthy.

The first startup downloads the base model. It can take several minutes; the health-check timeout is set to ten minutes accordingly.

## Optional build argument

Set `QWEN_IMAGE_EDIT_REF` in Railway build arguments to a specific upstream Git revision after validating one. The default is `main`.
