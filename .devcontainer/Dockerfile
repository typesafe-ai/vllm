FROM vllm/vllm-openai:latest

# No need to remove or rebuild FlashInfer; it's already built for Torch 2.7/CUDA 12.8
COPY setup.sh /tmp/setup.sh



# FROM vllm/vllm-openai:latest
# # NEW COOK trying to get a build working with torch 2.6

# ARG HOST_UID=1008
# ARG HOST_GID=1010
# RUN groupadd -g $HOST_GID devuser && \
#     useradd -m -u $HOST_UID -g $HOST_GID -s /bin/bash -G sudo devuser && \
#     echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# # Remove pre-installed flashinfer and precompiled vllm
# RUN pip uninstall -y flashinfer-python vllm || true

# # Install build essentials
# RUN pip install setuptools==75.6.0 packaging==23.2 ninja==1.11.1.3 build==1.2.2.post1

# ENV TORCH_CUDA_ARCH_LIST="8.9"

# # Install the correct FlashInfer wheel (compatible with torch 2.6)
# RUN pip install flashinfer-python==0.2.5+cu124torch2.6 -f https://flashinfer.ai/wheels/torch2.6/cu124/

# # Final permissions fix
# RUN chown -R devuser:devuser /home/devuser

# # Explicitly set FlashInfer permissions (critical)
# RUN mkdir -p /home/devuser/.cache/flashinfer && \
#     chown -R devuser:devuser /home/devuser/.cache

# COPY setup.sh /tmp/setup.sh


# OLD cook trying to get flashinfer built

# FROM vllm/vllm-openai:latest
# # https://hub.docker.com/r/vllm/vllm-openai/tags
# # this seems to have builds: https://buildkite.com/vllm

# # If you have custom registry, change registry mirror here or 
# # install essential build tools


# # Create non-root user with specified UID and GID
# # NOTE: Replace with your own UID and GID. This is a workaround from https://github.com/microsoft/vscode-remote-release/issues/49#issuecomment-489060908.
# # hopefully these get properly picked up from the devcontainer.json but it likely wont work on mac
# # you can find them with the `id` command
# ARG HOST_UID=1008
# ARG HOST_GID=1010
# RUN groupadd -g $HOST_GID devuser && \
#     useradd -m -u $HOST_UID -g $HOST_GID -s /bin/bash -G sudo devuser && \
#     echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


# # this is because the base image uses an imporper flashinfer remove this once it works
# RUN pip uninstall -y flashinfer-python || true

# # USER devuser
# # This makes sure tools installed with pip install --user can be run in the terminal.
# RUN echo 'export PATH="/home/devuser/.local/bin:$PATH"' >> /home/devuser/.bashrc

# # *********************** attempting compilation of flashInfer  ***********************
# # because they dont have a wheel for torch 2.7 yet
# # this is specifically for the box I'm on you'll want to detect your CUDA arch
# ENV TORCH_CUDA_ARCH_LIST="8.9"
# RUN pip install setuptools==75.6.0 packaging==23.2 ninja==1.11.1.3 build==1.2.2.post1


# # Build flashinfer from source using ccache and pip cache mounts 
# # # changed: dist dir to /home/devuser/flashinfer-dist and removed `rm -rf flashinfer`
# # checking out a specific commit after it builds for torch 2.7 but also has a successful jenkins build
# # --no-cache-dir: Ensures a fresh install and avoids confusion with pip caches.
# # --no-deps: Prevents pip from messing with torch versions.
# # --break-system-packages: Required on some Python 3.12+ installs to explicitly allow installing into system-wide site-packages.
# RUN --mount=type=cache,target=/home/devuser/.cache/ccache \
#     --mount=type=cache,target=/home/devuser/.cache/pip \
#     cd /home/devuser && \
#     git clone --recursive https://github.com/flashinfer-ai/flashinfer.git && \
#     cd flashinfer && \
#     git checkout 6d322570763035b0108919392220f8e925778cef && \
#     git submodule update --init --recursive && \
#     mkdir -p /home/devuser/wheel-cache && \
#     FLASHINFER_ENABLE_AOT=1 python3 setup.py bdist_wheel --dist-dir=/home/devuser/wheel-cache && \
#     pip install --no-cache-dir --no-deps --break-system-packages /home/devuser/wheel-cache/*.whl && \
#     cd .. && rm -rf flashinfer

# # *********************** end of flashInfer compilation ***********************

# # fix ownership to not have to deal with using devuser as things inside of the base image were installed as root
# RUN chown -R devuser:devuser /home/devuser


# # Ensure FlashInfer runtime directory permissions explicitly
# # I dont know if this will fix things if you get a permission error for flashinfer run 
# # sudo mkdir -p /home/devuser/.cache/flashinfer
# # sudo chown -R devuser:devuser /home/devuser/.cache 
# # inside of your contianer
# RUN mkdir -p /home/devuser/.cache/flashinfer \
#     && chown -R devuser:devuser /home/devuser/.cache


# COPY setup.sh /tmp/setup.sh