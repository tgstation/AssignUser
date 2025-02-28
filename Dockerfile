# Set the base image as the .NET 5.0 SDK (this includes the runtime)
FROM mcr.microsoft.com/dotnet/sdk:5.0 as build-env

# Copy everything and publish the release (publish implicitly restores and builds)
COPY . ./
RUN dotnet publish ./AssignUser/AssignUser.csproj -c Release -o out --no-self-contained

# Label the container
LABEL maintainer="Gamer025 <33846895+Gamer025@users.noreply.github.com>"
LABEL repository="https://github.com/Gamer025/AssignUser"
LABEL homepage="https://github.com/Gamer025/AssignUser"

# Label as GitHub action
LABEL com.github.actions.name="AssignUser"
# Limit to 160 characters
LABEL com.github.actions.description="Github action for assigning users to PRs/issues."
# See branding:
# https://docs.github.com/actions/creating-actions/metadata-syntax-for-github-actions#branding
LABEL com.github.actions.icon="user"
LABEL com.github.actions.color="white"

# Relayer the .NET SDK, anew with the build output
FROM mcr.microsoft.com/dotnet/runtime:5.0
COPY --from=build-env /out .
ENTRYPOINT ["dotnet", "/AssignUser.dll"]