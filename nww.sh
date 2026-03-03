#!/usr/bin/env bash
# Windows runner script for Noteworthy Wrapper
# https://github.com/28/Noteworthy-Wrapper
# Expects the Noteworthy Wrapper jar (nww.jar) at .nww folder.
java -cp ./.nww/nww.jar $@
