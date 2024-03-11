function Insert-Line {
    param (
        [string]$fileName,
        [string]$search,
        [string]$lineToAdd,
        [int]$spaceAfterIndex
    )

    $filePath = Join-Path $PWD $fileName

    if (Test-Path $filePath) {
        $fileContent = Get-Content -Path $filePath -Raw
        $lineIndex = $fileContent.IndexOf($search)
        $newContent = $fileContent.Insert($lineIndex + $spaceAfterIndex, $lineToAdd)
        Set-Content -Path $filePath -Value $newContent
    }
}

function Replace-String {
    param (
        [string]$fileName,
        [string]$search,
        [string]$replace
    )

    $filePath = Join-Path $PWD $fileName

    if (Test-Path $filePath) {
        $fileContent = Get-Content -Path $filePath -Raw
        $newContent = $fileContent -replace $search, $replace
        Set-Content -Path $filePath -Value $newContent
    }
}

function Copy-DefaultFiles {
    param (
        [string]$folderName
    )

    $sourcePath = "$env:APPDATA\DevScripts\$folderName"
    Copy-Item -Path $sourcePath\* -Destination $PWD -Recurse -Force
}