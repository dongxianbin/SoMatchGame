@echo off
cd /d %~dp0
cd ../..
set "pp=%cd%"
cd /d %~dp0
start cnqp.exe -workdir %pp%\client_dev -position 300,80 -console enable -resolution 1334x750 -file start3123.lua