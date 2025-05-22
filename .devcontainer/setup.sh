#!/bin/bash
set -eux

echo "Setting up vLLM environment (editable install)"

cd /workspaces/vllm

# # Find vLLM installed location (from pip)
# VLLM_INSTALL_DIR=$(python3 -c 'import vllm; import os; print(os.path.dirname(vllm.__file__))')
# echo "Found vLLM installed at: $VLLM_INSTALL_DIR"

# # Backup existing python vllm package
# mv "$VLLM_INSTALL_DIR" "${VLLM_INSTALL_DIR}_backup"

# # Symlink your source code as the installed vllm package
# ln -s "$(pwd)/vllm" "$VLLM_INSTALL_DIR"

echo "Editable mode setup complete."



# #!/bin/bash
# set -eux

# echo "Setting up vLLM environment for Python development"

# cd /workspaces/vllm

# # Clean torch constraints first
# python3 use_existing_torch.py

# # install build dependencies
# # pip install -r requirements/build.txt

# # Install dev and test dependencies explicitly
# pip install -r requirements/dev.txt -r requirements/test.txt


# # Install editable vLLM (no precompiled, using existing torch)
# VLLM_USE_PRECOMPILED=1 pip install --no-build-isolation -e . --no-deps


# echo "Setup complete"





# Old cook
# #!/bin/bash
# set -eux

# echo "Setting up vLLM environment for Python development"

# # workaround for flashinfer not having torch 2.7
# # Remove incompatible PyPI flashinfer if it was pre-installed by base image
# # now installing system wide we'll see
# # sudo pip uninstall -y flashinfer-python || true

# # Set workspace (mounted by VSCode at /workspaces/<folder-name>)
# cd /workspaces/vllm

# # Install editable with prebuilt kernels
# # --no-deps because of a manual install of flashinfer
# # remove it when flashinfer is available on PyPI 
# VLLM_USE_PRECOMPILED=1 pip install --editable ".[dev,test]" --no-deps


# # Optional: install pre-commit, Ruff, or other tools
# # pre-commit install

# echo "Setup complete"