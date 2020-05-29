# FROM python:3.7
FROM mcr.microsoft.com/powershell

# Install AZ Module
RUN pwsh -Command 'Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted'
RUN pwsh -Command 'Install-Module -Name Az -AllowClobber -Scope AllUsers' 

WORKDIR /app

# Add script file to image
COPY Scripts/*.ps1 .
