# Downloads are done from the oficial github release page links
$downloadUrl = "https://github.com/OpenCppCoverage/OpenCppCoverage/releases/download/release-0.9.6.1/OpenCppCoverageSetup-x64-0.9.6.1.exe"
$installerPath = [System.IO.Path]::Combine($Env:USERPROFILE, "Downloads", "OpenCppCoverageSetup.exe")

if(-Not (Test-Path $installerPath)) {
    Write-Host -ForegroundColor White ("Downloading OpenCppCoverage from: " + $downloadUrl)
    Start-FileDownload $downloadUrl -FileName $installerPath
}

Write-Host -ForegroundColor White "About to install OpenCppCoverage..."

$installProcess = (Start-Process $installerPath -ArgumentList '/VERYSILENT' -PassThru -Wait)
if($installProcess.ExitCode -ne 0) {
    throw [System.String]::Format("Failed to install OpenCppCoverage, ExitCode: {0}.", $installProcess.ExitCode)
}

# Assume standard, boring, installation path of ".../Program Files/OpenCppCoverage"
$installPath = [System.IO.Path]::Combine(${Env:ProgramFiles}, "OpenCppCoverage")
$env:Path="$env:Path;$installPath"



# Test that Open Cpp Coverage was installed properly
$openCppCoverageExe = [System.IO.Path]::Combine($installPath, "OpenCppCoverage.exe")
(& $openCppCoverageExe -h) 2>&1 | Select -First 1 | Write-Host -ForegroundColor White
# OpenCppCoverage returns 1 with no passed options...
if($LASTEXITCODE -ne 1) {
    throw [System.String]::Format("Failed to check the OpenCppCoverage version, ExitCode: {0}.", $LASTEXITCODE)
}
