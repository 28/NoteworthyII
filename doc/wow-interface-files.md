# Extracting WoW interface files

The interface files are no longer hosted online and in order to use
them they need to be extracted from the game client. Files are
extracted using the game console. Console is enabled by adding the
`-console` flag while starting the game (this can be done in the
Blizzard launcher).

Once in game, lower the console by pressing `~` and type in the
following:
``` shell
exportInterfaceFiles code
exportInterfaceFiles art
```

The game will lag a bit until all the files are extracted (and
possibly disconnect). The files will be in the game install
directory (folder BlizzardInterfaceCode).

To use them in for Noteworthy dev copy the code files into
the `Interface` directory.
