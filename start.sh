#!/bin/bash
set -e

# Optional: Start SSH if PUBLIC_KEY env var is set (RunPod handles this automatically in most cases)
if [[ $PUBLIC_KEY ]]; then
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    echo $PUBLIC_KEY >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
    service ssh start
fi

# Start Jupyter Lab if JUPYTER_PASSWORD is set (exposes on port 8888)
if [[ $JUPYTER_PASSWORD ]]; then
    exec jupyter lab \
        --allow-root \
        --no-browser \
        --port=8888 \
        --ip=0.0.0.0 \
        --ServerApp.token=$JUPYTER_PASSWORD \
        --ServerApp.allow_origin='*' \
        --ServerApp.preferred_dir=/workspace \
        --ServerApp.terminado_settings='{"shell_command": ["/bin/bash"]}'
else
    # Fallback to bash if no password set
    exec /bin/bash
fi
