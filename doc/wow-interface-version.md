# WoW interface version

To find out the current version of the WoW user interface log in to
the game and paste the following code to the console:
``` lua
/run print((select(4, GetBuildInfo())))
```

Output will contain the current version number.
