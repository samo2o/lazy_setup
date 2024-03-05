function ExpressJS-Setup {
    param (
        [string]$projectName
    )

    New-Item -ItemType Directory -Path $projectName | Out-Null
    Set-Location -Path $projectName
    
    npm init -y
    npm install axios bcryptjs express express-validator jsonwebtoken mongoose mongoose-unique-validator multer uuid dotenv
    npm install nodemon --save-dev

    $sourcePath = "$env:APPDATA\DevScripts\ExpressJS"
    Copy-Item -Path $sourcePath\* -Destination $PWD -Recurse -Force

    $nodemonLine = '    "start": "nodemon server.js",'

    $packageJsonPath = Join-Path $PWD "package.json"
    $packageJsonContent = Get-Content -Path $packageJsonPath -Raw

    $scriptsIndex = $packageJsonContent.IndexOf('"scripts"')
    $newContent = $packageJsonContent.Insert($scriptsIndex + 12, "`n$nodemonLine")

    Set-Content -Path $packageJsonPath -Value $newContent

    (Get-Content -Path $packageJsonPath) -replace '("main":\s*")index.js(")', '$1server.js$2' | Set-Content -Path $packageJsonPath

    Write-Host "Backend project setup complete." -ForegroundColor Green
    code .
}

function Frontend-Setup {
    Write-Host "Expo React Native project setup option is not ready yet!" -ForegroundColor Red
}

function Expo-Setup {
    Write-Host "Expo React Native project setup option is not ready yet!" -ForegroundColor Red
}

function Empty-Setup {
    param (
        [string]$projectName
    )

    New-Item -ItemType Directory -Path $projectName | Out-Null
    Set-Location -Path $projectName

    npm init -y

    Write-Host "Empty project setup complete." -ForegroundColor Green
    code .
}