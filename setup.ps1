. $env:APPDATA\DevScripts\utils.ps1

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
    param (
        [string]$projectName,
        [string]$projectType
    )

    # ReactJS
    if ( $projectType -eq '1' ) {
        npm create vite@latest $projectName --template react-ts
        cd $projectName

        npm install
        npm install --save-dev eslint-config-prettier eslint-plugin-prettier

        Copy-DefaultFiles -folderName "default"

        Insert-Line -fileName ".eslintrc.cjs" -search "'eslint:recommended'," -lineToAdd "'plugin:prettier/recommended',`n" -spaceAfterIndex 26
        Insert-Line -fileName ".eslintrc.cjs" -search "plugins" -lineToAdd ", 'prettier'" -spaceAfterIndex 25
        Insert-Line -fileName ".eslintrc.cjs" -search "rules" -lineToAdd "'prettier/prettier': 'warn',`n    " -spaceAfterIndex 13

        npx prettier --write .

        Write-Host "ReactJS project setup complete." -ForegroundColor Green
        code .
    }
    
    # nextJS
    if ( $projectType -eq '2' ) {
        npx create-next-app@latest $projectName
        cd $projectName

        npm install --save-dev eslint-config-prettier eslint-plugin-prettier

        Copy-DefaultFiles -folderName "default"

        $eslintrcPath = Join-Path $PWD ".eslintrc.json"

        $newContent = '{ "extends": [
            "next/core-web-vitals",
            "eslint:recommended",
            "plugin:@typescript-eslint/recommended",
            "prettier"
            ],
            "plugins": ["prettier", "@typescript-eslint"],
            "parser": "@typescript-eslint/parser",
            "rules": {
                "prettier/prettier": "warn"
            },
            "root": true
        }'

        Set-Content -Path $eslintrcPath -Value $newContent

        npx prettier --write .

        Write-Host "NextJS project setup complete." -ForegroundColor Green
        code .
    }
}

function Expo-Setup {
    Write-Host "Expo React Native project setup option is not ready yet!" -ForegroundColor Red
    Read-Host "Click enter to close..."
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