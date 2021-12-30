package org.theparanoidtimes.noteworthywrapper;

import java.nio.file.Path;

public abstract class Constants {

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
    public static final String CF_TOKEN_HEADER = "X-Api-Token";
    public static final String CF_API_TOKEN = System.getenv("CF_API_TOKEN");
    public static final String CF_BASE_URL = "https://wow.curseforge.com";
    public static final String CF_VERSION_URL = "/api/game/versions";
    public static final String CF_UPLOAD_URL = "/api/projects/%d/upload-file";
    public static final Long CF_PROJECT_ID = 400633L;
}
