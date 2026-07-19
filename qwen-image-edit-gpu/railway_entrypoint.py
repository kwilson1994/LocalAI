"""Launch the upstream Gradio app using Railway's assigned port."""

import os
import runpy

os.environ.setdefault("GRADIO_SERVER_NAME", "0.0.0.0")
os.environ.setdefault("GRADIO_SERVER_PORT", os.environ.get("PORT", "7860"))
os.environ.setdefault("GRADIO_ANALYTICS_ENABLED", "False")

os.chdir("/opt/qwen-image-edit")
runpy.run_path("/opt/qwen-image-edit/app.py", run_name="__main__")
