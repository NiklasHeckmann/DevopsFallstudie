# Stage 1: Build (Das schwere Werkzeug)
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY ["DevopsFallstudie.csproj", "./"]
RUN dotnet restore "./DevopsFallstudie.csproj"
COPY . .
RUN dotnet publish "DevopsFallstudie.csproj" -c Release -o /app/publish

# Stage 2: Run (Das leichte, sichere Image für Hetzner)
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "DevopsFallstudie.dll"]