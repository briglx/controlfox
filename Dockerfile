# FROM python:3.7
FROM mcr.microsoft.com/powershell

# Install AZ Module
RUN Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
RUN Install-Module -Name Az -AllowClobber -Scope AllUsers 

WORKDIR /app

# Add script file to image
COPY Scripts/*.ps1 .
