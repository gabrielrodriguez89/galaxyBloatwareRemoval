@ECHO OFF
SETLOCAL enabledelayedexpansion 
	
CD %~dp0platform-tools

:devicescan
REM start adb server and pipe results of device scan to file
adb start-server
adb devices > deviceconnection.txt

REM check to see if a device is connected scanning above file
FINDSTR "\<device\>" deviceconnection.txt >nul 2>&1

REM if device connected run through prompts to clear bloatware else rescan for device or exit
if %errorlevel% == 0 (
	ECHO Device found:
	@ECHO:
	FINDSTR "\<device\>" deviceconnection.txt
    @ECHO:
	@ECHO:

	ECHO  __________________________________________________________________
	ECHO ^| If your device is not listed above                               ^|
	ECHO ^| Make sure you have accepted the device connection for debugging  ^|
	ECHO ^| Then enter n to rescan                                           ^|
	ECHO ^|__________________________________________________________________^|

	@ECHO:
	@ECHO:

	SET /p devicelisted= "Is your device listed under list of devices attached? (y, n)"
    
	if "!devicelisted!" == "n" (
	    CLS
		GOTO devicescan
	) 
	
	CLS

	ECHO  ____________________________________________________
	ECHO ^| To clean bloatware type u                          ^|
	ECHO ^| To re-install bloatware removed previously type r  ^|
	ECHO ^|____________________________________________________^|

	@ECHO:
	@ECHO:
	SET /p promptclean= "Would you like to clean or re-install bloatware? (u, r)"
    
	if "!promptclean!" == "u" (
	    CLS
		adb shell < %~dp0uninstall.txt
	) else if "!promptclean!" == "r" (
	    CLS
		adb shell < %~dp0reinstall.txt
	) else  (
	    GOTO endof 
	)
) else (
    Echo No device found please connect a device and accept the connection on the phone to continue.
	@ECHO:
	SET /p devicelisted= "Would you like to retry? (y, n)"
    
	if "!devicelisted!" == "y" (
	    CLS
		GOTO devicescan
	) else (
	    GOTO endof 
	)
)

ECHO complete
PAUSE

:endof
EXIT