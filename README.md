# Control Fox

Sample to show how to use a docker image to run a powershell command to check RBAC roles on Azure

# Using Docker 

Build the image

```bash
docker build --pull --rm -f "Dockerfile" -t controlfox:latest "." 
```

Run the image

```bash
docker run --rm -it  controlfox:latest

# run with an environment file
docker run --rm -it --env-file local.env controlfox:latest
```


# References

- Powershell Authentication https://docs.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-4.1.0