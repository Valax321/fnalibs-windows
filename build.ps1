$sdlVersion = '3.2.18'
$fna3dVersion = '25.07'

# Get and extract the latest SDL3 VC build
&gh -R 'libsdl-org/SDL' release download "release-$sdlVersion" --pattern "SDL3-devel-$sdlVersion-VC.zip"
Expand-Archive -LiteralPath "SDL3-devel-$sdlVersion-VC.zip" -DestinationPath "src"

# Get FNA3D
&gh repo clone 'FNA-XNA/FNA3D' src/FNA3D -- -b $fna3dVersion --recursive

# Get FAudio
&gh repo clone 'FNA-XNA/FAudio' src/FAudio -- -b $fna3dVersion --recursive

&gh repo clone 'FNA-XNA/Theorafile' 'src/theorafile'

# Build FNA3D
&cmake -S src\FNA3D -B build\FNA3D -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=Release "-DSDL3_DIR=$pwd\src\SDL3-$sdlVersion\cmake"
&cmake --build build\FNA3D --config Release

# Build FAudio
&cmake -S src\FAudio -B build\FAudio -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=Release "-DSDL3_DIR=$pwd\src\SDL3-$sdlVersion\cmake"
&cmake --build build\FAudio --config Release

# Upgrade theorafile to current VS platform version and build
&devenv /upgrade "src\theorafile\visualc\libtheorafile\libtheorafile.vcxproj"
&msbuild "src\theorafile\visualc\libtheorafile\libtheorafile.vcxproj" /p:Configuration=Release /p:Platform=x64

# Copy files to upload location

New-Item -ItemType "Directory" -Name "artifacts"
Copy-Item "src\SDL3-$sdlVersion\lib\x64\SDL3.dll" -Destination "$pwd\artifacts"
Copy-Item "src\SDL3-$sdlVersion\lib\x64\SDL3.lib" -Destination "$pwd\artifacts"

Copy-Item "build\FNA3D\Release\FNA3D.dll" -Destination "$pwd\artifacts"
Copy-Item "build\FNA3D\Release\FNA3D.lib" -Destination "$pwd\artifacts"

Copy-Item "build\FAudio\Release\FAudio.dll" -Destination "$pwd\artifacts"
Copy-Item "build\FAudio\Release\FAudio.lib" -Destination "$pwd\artifacts"

Copy-Item "src\theorafile\visualc\libtheorafile\x64\Release\libtheorafile.dll" -Destination "$pwd\artifacts"
Copy-Item "src\theorafile\visualc\libtheorafile\x64\Release\libtheorafile.lib" -Destination "$pwd\artifacts"
