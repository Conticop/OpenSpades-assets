git clone --recursive "https://github.com/yvt/openspades" OpenSpades

Push-Location OpenSpades

$RepoRoot = "" + (Get-Location)

$BinaryDir = Join-Path "$RepoRoot" openspades.mk bin MinSizeRel

Remove-Item -Path "vcpkg" -Force -Recurse -ErrorAction SilentlyContinue

git clone "https://github.com/microsoft/vcpkg"

vcpkg/bootstrap-vcpkg.bat -disableMetrics

vcpkg/vcpkg install "@vcpkg_x86-windows.txt"

cmake -A Win32 -D "CMAKE_BUILD_TYPE=MinSizeRel" -D "CMAKE_TOOLCHAIN_FILE=$RepoRoot/vcpkg/scripts/buildsystems/vcpkg.cmake" -D "VCPKG_TARGET_TRIPLET=x86-windows-static" "-S$RepoRoot" "-B$RepoRoot/openspades.mk"

cmake --build "$RepoRoot/openspades.mk" --config MinSizeRel --parallel 8

Push-Location -Path "$BinaryDir"

Invoke-WebRequest -Uri "https://github.com/Conticop/OpenSpades-assets/raw/main/assets.zip" -OutFile "assets.zip"

Expand-Archive -Path "assets.zip" -DestinationPath "." -Force

Remove-Item -Path "assets.zip" -Force -ErrorAction SilentlyContinue
