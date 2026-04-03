# Stage 1: Build
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Sucht jede .csproj Datei, egal wie sie genau heißt
COPY *.csproj ./
RUN dotnet restore

# Kopiert den Rest und veröffentlicht die App
COPY . .
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# Stage 2: Run
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Der kritischste Punkt: Der Name der DLL muss exakt stimmen
# Falls es knallt, schau nach, wie die Datei im Ordner /bin/Release/net10.0/ heißt
ENTRYPOINT ["dotnet", "DevopsFallstudie.dll"]