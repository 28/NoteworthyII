package org.theparanoidtimes.noteworthywrapper;

import java.nio.file.Path;

public final class Constants {

    public static final Path LUA_SOURCE_PATH = Path.of("src/lua");
    public static final Path XML_SOURCE_PATH = Path.of("src/xml");
    public static final Path LIBRARIES_PATH = Path.of("lib");
    public static final Path TOC_PATH = Path.of("NoteworthyII.toc");
    public static final Path README_PATH = Path.of("README.md");
    public static final Path LICENSE_PATH = Path.of("LICENSE.txt");
    public static final String CHANGELOG_PATH = "doc/CHANGELOG.md";
    public static final String CHANGELOG_HEADING_DELIMITER = "##";
    public static final String INSTALLATION_DIRECTORY_ENV_VAR = "WOWIL";
    public static final String INSTALL_LOCATION = "Interface/AddOns/NoteworthyII";
}
