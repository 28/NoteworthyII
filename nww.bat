@REM Windows runner script for Noteworthy Wrapper
@REM https://github.com/28/Noteworthy-Wrapper
@REM Expects the Noteworthy Wrapper jar (nww.jar) at .nww folder.
@echo off
java -cp .\.nww\nww.jar %*
