@echo off
setlocal enabledelayedexpansion
title RootRPG - Terminal Awakening
mode con: cols=80 lines=25
color 0a

:menu
cls
echo.
echo    ########################################################################
echo    #                                                                      #
echo    #      _____              _     _____  _____   _____                   #
echo    #     |  __ \            | |   |  __ \|  __ \ / ____|                  #
echo    #     | |__) |___   ___  | |_  | |__) | |__) | |  __                   #
echo    #     |  _  // _ \ / _ \ | __| |  _  /|  ___/| | |_ |                  #
echo    #     | | \ \ (_) | (_) || |_  | | \ \| |    | |__| |                  #
echo    #     |_|  \_\___/ \___/  \__| |_|  \_\_|     \_____|                  #
echo    #                                                                      #
echo    #                      - TERMINAL AWAKENING -                          #
echo    #                                                                      #
echo    ########################################################################
echo.
echo    [1] Start New Mission
echo    [2] Credits
echo    [3] Exit
echo.
set /p choice="> "
if "%choice%"=="1" goto char_creation
if "%choice%"=="2" goto credits
if "%choice%"=="3" exit
goto menu

:credits
cls
echo.
echo    ------------------------------------------------------------------------
echo    RootRPG Created by: GitHub Agent
echo    Version: 1.0.0
echo    Built on: Pure Windows Batch
echo    ------------------------------------------------------------------------
echo.
pause
goto menu

:char_creation
set hp=100
set level=1
set exp=0
set firewall=50
set creds=100
set inv=0
cls
echo.
echo    [ SYSTEM INITIALIZING ]
echo.
echo    Enter your Operator Handle:
set /p name="> "
if "%name%"=="" set name=Operator_Null

:intro
cls
echo.
echo    Welcome, %name%.
echo.
echo    You wake up in a cold, neon-lit room. The screen in front of you
echo    flickers. You are deep inside the 'Under-Grid'.
echo.
echo    A notification appears: "CRITICAL BREACH DETECTED IN SECTOR 7"
echo.
pause
goto hub

:hub
cls
echo    ------------------------------------------------------------------------
echo    HANDLE: %name% | HP: %hp% | CREDS: %creds% | LVL: %level%
echo    ------------------------------------------------------------------------
echo    Current Location: Under-Grid Hub
echo.
echo    What is your next move?
echo.
echo    [1] Enter Sector 7 (Mission)
echo    [2] Check Inventory
echo    [3] Access Data-Shop
echo    [4] Sleep (Restore HP)
echo    [q] Abort Mission (Quit)
echo.
set /p choice="> "
if "%choice%"=="1" goto sector7
if "%choice%"=="2" goto inventory
if "%choice%"=="3" goto shop
if "%choice%"=="4" goto sleep
if "%choice%"=="q" goto menu
goto hub

:sleep
cls
echo.
echo    Rebooting systems...
set /a hp=%hp% + 20
if %hp% gtr 100 set hp=100
timeout /t 2 >nul
echo    HP Restored. Current HP: %hp%
pause
goto hub

:inventory
cls
echo    ------------------------------------------------------------------------
echo    INVENTORY
echo    ------------------------------------------------------------------------
if %inv% equ 0 echo    Your data-packets are empty.
if %inv% equ 1 echo    [1] Overclock Module (Damage Boost)
echo.
pause
goto hub

:shop
cls
echo.
echo    [ DATA-SHOP ]
echo    Credits: %creds%
echo.
echo    [1] Repair Kit (Restore 50 HP) - 50 Credits
echo    [2] Overclock Module - 150 Credits
echo    [3] Back to Hub
echo.
set /p choice="> "
if "%choice%"=="1" (
    if %creds% geq 50 (
        set /a creds=%creds%-50
        set /a hp=%hp%+50
        if %hp% gtr 100 set hp=100
echo    Repair complete.
    ) else (
        echo    Insufficient Credits.
    )
)
if "%choice%"=="2" (
    if %creds% geq 150 (
        set /a creds=%creds%-150
        set inv=1
echo    Module installed.
    ) else (
        echo    Insufficient Credits.
    )
)
pause
goto hub

:sector7
set enemy_hp=50
cls
echo.
echo    [ ENTERING SECTOR 7 ]
echo.
echo    A security 'Sentinel' blocks your path.
echo.
:combat
echo    ------------------------------------------------------------------------
echo    SENTINEL HP: %enemy_hp% | YOUR HP: %hp%
echo    ------------------------------------------------------------------------
echo    [1] Execute Attack
echo    [2] Attempt Hack (Risk: High)
echo    [3] Defend
echo.
set /p choice="> "
if "%choice%"=="1" (
    set /a dmg=%random% %% 15 + 5
    if %inv% equ 1 set /a dmg=%dmg% + 10
    set /a enemy_hp=%enemy_hp% - %dmg%
echo    You hit the Sentinel for %dmg% damage!
)
if "%choice%"=="2" (
    set /a chance=%random% %% 100
    if !chance! gtr 60 (
        set /a enemy_hp=0
echo    System Hack Successful! Sentinel Neutralized.
    ) else (
        set /a self_dmg=20
        set /a hp=%hp% - !self_dmg!
echo    Hack Failed! System Backlash: %self_dmg% damage taken.
    )
)
if "%choice%"=="3" (
    echo    You brace for impact. Damage reduced.
    set /a enemy_dmg=%random% %% 5
    set /a hp=%hp% - !enemy_dmg!
    goto enemy_turn_end
)

if %enemy_hp% leq 0 goto victory

:: Enemy Turn
set /a enemy_dmg=%random% %% 15 + 5
set /a hp=%hp% - %enemy_dmg%
echo    Sentinel counters for %enemy_dmg% damage!

:enemy_turn_end
if %hp% leq 0 goto gameover
pause
goto combat

:victory
cls
echo.
echo    [ MISSION SUCCESS ]
echo.
echo    The Sentinel collapses into digital static.
echo    You retrieved the core-data.
echo.
set /a creds=%creds% + 100
set /a exp=%exp% + 50
echo    +100 Credits | +50 EXP
pause
goto win_screen

:win_screen
cls
echo.
echo    Congratulations, Operator %name%.
echo.
echo    You have successfully completed the prototype mission.
echo    The Grid is safe... for now.
echo.
pause
goto menu

:gameover
cls
color 0c
echo.
echo    ########################################################################
echo    #                                                                      #
echo    #                          SYSTEM CRITICAL                             #
echo    #                          CONNECTION LOST                             #
echo    #                                                                      #
echo    ########################################################################
echo.
echo    Operator %name% has been purged from the system.
echo.
pause
color 0a
goto menu
