@echo off
setlocal EnableDelayedExpansion

set fwName="IISExpressWeb"
netsh advfirewall firewall show rule name=!fwName!>nul
if errorlevel 1 (
	echo Adding firewall rule !fwName!
	netsh advfirewall firewall add rule name=!fwName! dir=in protocol=tcp localport=44300-44399 profile=private,domain remoteip=localsubnet action=allow enable=yes
) else (
	netsh advfirewall firewall set rule name=!fwName! new dir=in protocol=tcp localport=44300-44399 profile=private,domain remoteip=localsubnet action=allow enable=yes
)

for /L %%i in (44300,1,44399) do (
	netsh http delete urlacl url=https://flairstech.local:%%i/>nul
	netsh http add urlacl url=https://flairstech.local:%%i/ user=everyone
)
