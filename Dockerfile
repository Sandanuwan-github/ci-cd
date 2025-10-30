# Use the official .NET SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln ./
COPY testAPI/*.csproj ./testAPI/
RUN dotnet restore

# Copy everything else and build
COPY testAPI/. ./testAPI/
WORKDIR /app/testAPI
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/testAPI/out ./
ENTRYPOINT ["dotnet", "testAPI.dll"]
