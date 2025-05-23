#!/bin/bash
set -eux

echo "Setting up vLLM environment (editable install)"

cd /workspaces/vllm
# *************** flashinfer build ***************
# this is all a workaround for the fact that flashinfer is not available on PyPI for torch 2.7
# remove this when it is available
# Uninstall existing incompatible version
pip uninstall -y flashinfer-python

# Install adjusted build dependencies (setuptools fixed)
pip install setuptools==79.0.1 packaging==23.2 ninja==1.11.1.3 build==1.2.2.post1

# Clone FlashInfer at correct commit
git clone --recursive https://github.com/flashinfer-ai/flashinfer.git
cd flashinfer
git checkout 21ea1d2545f74782b91eb8c08fd503ac4c0743fc

# Environment for correct build
export FLASHINFER_ENABLE_AOT=1
export TORCH_CUDA_ARCH_LIST='8.9'

# Build FlashInfer wheel
python3 setup.py bdist_wheel --dist-dir=./dist --verbose

# Install built wheel
pip install ./dist/flashinfer_python*.whl
# *************** flashinfer build end ***************

echo "Installing vLLM dev and test dependencies..."
pip install -r requirements/dev.txt -r requirements/test.txt

# clean out the non-editable build
pip uninstall -y vllm

echo "Setting up vLLM in editable mode with precompiled kernels..."
VLLM_USE_PRECOMPILED=1 pip install --editable . --no-build-isolation


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