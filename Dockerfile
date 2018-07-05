
# Setting the escape character to ` is especially useful on Windows, where \ is the directory path separator.

# escape=`

FROM microsoft/windowsservercore:latest
SHELL ["powershell", "-command"]
LABEL maintainer=nordine.dot.b@gmail.com description="Storage Emulator in a container"

ENV LOCAL_DB_URL https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SqlLocalDB.msi
RUN powershell -NoProfile -Command Invoke-WebRequest $ENV:LOCAL_DB_URL -OutFile SqlLocalDB.msi;

ENV AZ_STOR_EMU_URL https://download.visualstudio.microsoft.com/download/pr/12654037/ed13b6c95f758c232c579c61de4ecba2/MicrosoftAzureStorageEmulator.msi
RUN powershell -NoProfile -Command Invoke-WebRequest $ENV:AZ_STOR_EMU_URL -OutFile MicrosoftAzureStorageEmulator.msi;

RUN Start-Process -FilePath msiexec -ArgumentList /q, /i, SqlLocalDB.msi, IACCEPTSQLLOCALDBLICENSETERMS=YES -Wait;
RUN Start-Process -FilePath msiexec -ArgumentList /q, /i, MicrosoftAzureStorageEmulator.msi -Wait;

RUN powershell -NoProfile -Command  Remove-Item -Force *.msi;

RUN '$(Get-Content "C:\Program Files (x86)\Microsoft SDKs\Azure\Storage Emulator\AzureStorageEmulator.exe.config").replace("devstoreaccount1", "devstoreaccount2") | Set-Content "C:\Program Files (x86)\Microsoft SDKs\Azure\Storage Emulator\AzureStorageEmulator.exe.config" -Force'
RUN "& 'C:\Program Files\Microsoft SQL Server\130\Tools\Binn\SqlLocalDB.exe' create azure -s"
RUN "& 'C:\Program Files (x86)\Microsoft SDKs\Azure\Storage Emulator\AzureStorageEmulator.exe' init /server '(localdb)\azure'"

EXPOSE 10000 10001 10002

# Configure and launch
COPY start.ps1 .
CMD .\start