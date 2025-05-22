# try setting up a venv busted on my old box
uv venv --python 3.12 --seed
idk if this will break blocks its python 3.11

source .venv/bin/activate

VLLM_USE_PRECOMPILED=1 pip install --editable .

    If you change C++ or kernel code, you cannot use Python-only build; otherwise you will see an import error about library not found or undefined symbol.

    If you rebase your dev branch, it is recommended to uninstall vllm and re-run the above command to make sure your libraries are up to date.

to install unit testing tools
pip install -r requirements/dev.txt

Scratch all that lets try this now

idk about this 
export VLLM_COMMIT=33f460b17a54acb3b6cc0b03f4a17876cff5eafd # use full commit hash from the main branch
docker pull public.ecr.aws/q9t5s3a7/vllm-ci-postmerge-repo:${VLLM_COMMIT}


maybe this works? 
docker run --runtime=nvidia --gpus all \
  -v ~/.cache/huggingface:/root/.cache/huggingface \
  -v $(pwd):/workspace \
  -w /workspace \
  -it vllm/vllm-openai:latest /bin/bash

ignore everything above this
okay fuck that lets try using docker to build the docker/Dockerfile dev

# docker works 2 hour build time with 24 cores, unclear if caching works
our docker is out of date and doesnt support the newer features of heardoc
sudo apt-get update
sudo apt-get install --only-upgrade docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo apt install ccache

build the image

DOCKER_BUILDKIT=1 docker build -f docker/Dockerfile --target test -t vllm-dev . --build-arg max_jobs=24 --build-arg nvcc_threads=1 --build-arg RUN_WHEEL_CHECK=false --build-arg torch_cuda_arch_list="8.9"

this takes forever

try with these additional flags to get it parallel building
--build-arg max_jobs=24 --build-arg nvcc_threads=1

This makes it so the build system has to autodetect only the cuda arch relavent to the system
--build-arg torch_cuda_arch_list=""
I dont think autodetection works try
--build-arg torch_cuda_arch_list="8.9"


prevent checking the build size as this is for development
--build-arg RUN_WHEEL_CHECK=false


it seems like total jobs is max_jobs / nncc_threads

we are going to edit the dockerfile to include 
CCACHE_NOHASHDIR="true"
to share the ccache between builds and edit all the pip install commands to include 
--no-build-isolation
to hopefully make it so that pip doesnt prevent the ccache from being able to be used

I'm going to create a local cache_dir for docker and point it to that instead of the docker internal cache for ccache
mkdir -p ~/vllm/.cache/docker_ccache

then mount it with 
idk if this helps tbh
RUN --mount=type=bind,source=.cache/docker_ccache,target=/root/.cache/ccache,rw \

# run a unit test
docker run --runtime nvidia \
 --env "HUGGING_FACE_HUB_TOKEN={YOUR TOKEN}" \
 --gpus all \
 --privileged=true \
 --ipc=host vllm-dev pytest tests/
breaks 


docker run -it --runtime nvidia \
  --env "HUGGING_FACE_HUB_TOKEN={YOUR TOKEN}" \
  --gpus all \
  --privileged --ipc=host \
  -v $(pwd)/docker-cache:/root/.cache \
  -v $(pwd):/workspace \
  -w /workspace \
  vllm-dev bash

insie run this
pip install -e . --no-build-isolation --resume-retries 5

we need to pass the huggingface token so it can dl specific models for unit tests
this flag so that process group changes can work properly 
--privileged

# attempt at dev container
lets try 


# extra docker stuff
print all the docker cache stuff
docker buildx du

delete all the cached stuff
docker builder prune -af
