# FROM python:3.7
FROM mcr.microsoft.com/powershell


# Add script file to image
COPY Scripts/*.py .
