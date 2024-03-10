function Initiate {
    Clear-Host
    Write-Host "
     __         ______     ______     __  __        _____     ______     __   __  
    /\ \       /\  __ \   /\___  \   /\ \_\ \      /\  __-.  /\  ___\   /\ \ / /  
    \ \ \____  \ \  __ \  \/_/  /__  \ \____ \     \ \ \/\ \ \ \  __\   \ \ \'/   
     \ \_____\  \ \_\ \_\   /\_____\  \/\_____\     \ \____-  \ \_____\  \ \__|   
      \/_____/   \/_/\/_/   \/_____/   \/_____/      \/____/   \/_____/   \/_/    

    " -ForegroundColor Red
}

function Clear-Ui {
    Initiate
}

function Get-ProjectName {
    $pn = Read-Host "Enter project name"
    if ($pn -eq "") {
        Write-Host "Please write a project name
        " -ForegroundColor Yellow
        $pn = Read-Host "Enter project name"
        if ($pn -eq "") {
            Write-Host "Enter any key to close..."
            Read-Host
            exit
        }
    }
    return $pn
}

function Project-TypeOptions {
    param (
        [string]$projectName
    )

    CLear-Ui
    . $env:APPDATA\DevScripts\setup.ps1

    Write-Host "Project name: " -NoNewLine
    Write-Host "$projectName
    " -ForegroundColor Green

    Write-Host "[ 1 ] Backend  - ExpressJS"
    Write-Host "[ 2 ] Frontend - ReactJS / NextJS"
    Write-Host "[ 3 ] Expo app - React Native"
    Write-Host "[ 4 ] Empty"
    Write-Host ""

    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        '1' {
            ExpressJS-Setup -projectName $projectName
        }
        '2' {
            CLear-Ui
            Write-Host "[ 1 ] ReactJS"
            Write-Host "[ 2 ] NextJS"
            Write-Host ""

            $TypeChoice = Read-Host "Enter your choice"

            Frontend-Setup -projectName $projectName -projectType $TypeChoice
        }
        '3' {
            Expo-Setup -projectName $projectName
        }
        '4' {
            Empty-Setup -projectName $projectName
        }
        default {
            Write-Host "Invalid choice." -ForegroundColor Yellow
            Write-Host "Click Enter to try again..."
            Read-Host
            Project-TypeOptions -projectName $projectName
        }
    }
}