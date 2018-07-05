# Azure Storage Emulator Docker Image

# Build the docker container
```Posh
docker build --rm --no-cache -t azure-storage-emulator -f Dockerfile .
```

# Usage
```Posh
docker run --rm -it -p 10000:10000 -p 10001:10001 -p 10002:10002 --name azure-storage-emulator azure-storage-emulator
```