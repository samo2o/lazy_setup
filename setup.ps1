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

        # TODO:
        # - make an insert function to make the proccess easier to copy

        $sourcePath = "$env:APPDATA\DevScripts\default"
        Copy-Item -Path $sourcePath\* -Destination $PWD -Recurse -Force

        $eslintrcPath = Join-Path $PWD ".eslintrc.cjs"
        $eslintrcJsonContent = Get-Content -Path $eslintrcPath -Raw

        $lineIndex = $eslintrcJsonContent.IndexOf("'eslint:recommended',")
        $toAdd = "    'plugin:prettier/recommended',"
        $newContent = $eslintrcJsonContent.Insert($lineIndex + 22, "$toAdd`n")

        $lineIndex2 = $newContent.IndexOf("plugins")
        $toAdd2 = ", 'prettier'"
        $newContent2 = $newContent.Insert($lineIndex2 + 25, "$toAdd2")

        $lineIndex3 = $newContent2.IndexOf("rules")
        $toAdd3 = "'prettier/prettier': 'warn',"
        $newContent3 = $newContent2.Insert($lineIndex3 + 13, "$toAdd3`n    ")

        Set-Content -Path $eslintrcPath -Value $newContent3

        npx prettier --write .

        Write-Host "ReactJS project setup complete." -ForegroundColor Green
        code .
    }
    
    # nextJS
    if ( $projectType -eq '2' ) {
        npx create-next-app@latest $projectName
        cd $projectName

        npm install --save-dev eslint-config-prettier eslint-plugin-prettier

        # TODO:
        # - no prettier warns work with next JS!?
        # - make an insert function to make the proccess easier to copy

        $sourcePath = "$env:APPDATA\DevScripts\default"
        Copy-Item -Path $sourcePath\* -Destination $PWD -Recurse -Force

        # $eslintrcPath = Join-Path $PWD ".eslintrc.json"
        # $newContent = '{ "extends": [
        #     "next/core-web-vitals",
        #     "eslint:recommended",
        #     "plugin:@typescript-eslint/recommended",
        #     "prettier"
        #     ],
        #     "plugins": ["prettier", "@typescript-eslint"],
        #     "parser": "@typescript-eslint/parser",
        #     "rules": {
        #         "prettier/prettier": "warn"
        #     },
        #     "root": true
        # }'

        # Set-Content -Path $eslintrcPath -Value $newContent

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