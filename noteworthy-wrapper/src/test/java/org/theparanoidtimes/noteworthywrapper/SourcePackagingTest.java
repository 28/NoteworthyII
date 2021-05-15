package org.theparanoidtimes.noteworthywrapper;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import static org.assertj.core.api.Assertions.assertThat;

class SourcePackagingTest {

    private static Path testSourcePath;
    private static Path testPackageDestinationPath;

    @BeforeAll
    static void prepare() throws Exception {
        testSourcePath = Path.of(Objects.requireNonNull(SourcePackagingTest.class.getResource("/source")).toURI());
        testPackageDestinationPath = Path.of(Objects.requireNonNull(SourcePackagingTest.class.getResource("/source")).toURI());
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    @BeforeEach
    void cleanSourceDirectory() throws Exception {
        Files.walk(testSourcePath)
                .sorted(Comparator.reverseOrder())
                .map(Path::toFile)
                .filter(file -> !file.isDirectory())
                .filter(file -> file.getName().matches(".*\\.zip"))
                .forEach(File::delete);
    }

    @Test
    void wrapperWillPackageAllSourceFilesInZipWithTimestamp() throws Exception {
        String currentTimeMillis = String.valueOf(System.currentTimeMillis());
        SourcePackaging.zipSourceDirectory(testSourcePath, testPackageDestinationPath, currentTimeMillis);

        String finalName = testPackageDestinationPath.resolve("NoteworthyII_" + currentTimeMillis + ".zip").toString();
        assertThat(Path.of(finalName)).exists();
        assertThat(Path.of(finalName).toFile()).isNotEmpty();

        ZipFile zipFile = new ZipFile(finalName);
        Set<String> zippedFilesSet = zipFile.stream().map(ZipEntry::getName).collect(Collectors.toSet());
        assertThat(zippedFilesSet).contains("NoteworthyII/test.lua");
        assertThat(zippedFilesSet).contains("NoteworthyII/test.xml");
        assertThat(zippedFilesSet).contains("NoteworthyII/lib/testlib.lua");
        assertThat(zippedFilesSet).contains("NoteworthyII/NoteworthyII.toc");
        assertThat(zippedFilesSet).contains("NoteworthyII/README.md");
        assertThat(zippedFilesSet).contains("NoteworthyII/LICENSE.txt");
    }

    @Test
    void wrapperWillPackageAllSourceFilesInZipWithVersionInName() throws Exception {
        String version = "v28.0";
        SourcePackaging.zipSourceDirectory(testSourcePath, testPackageDestinationPath, version);

        String finalName = testPackageDestinationPath.resolve("NoteworthyII_" + version + ".zip").toString();
        assertThat(Path.of(finalName)).exists();
        assertThat(Path.of(finalName).toFile()).isNotEmpty();

        ZipFile zipFile = new ZipFile(finalName);
        Set<String> zippedFilesSet = zipFile.stream().map(ZipEntry::getName).collect(Collectors.toSet());
        assertThat(zippedFilesSet).contains("NoteworthyII/test.lua");
        assertThat(zippedFilesSet).contains("NoteworthyII/test.xml");
        assertThat(zippedFilesSet).contains("NoteworthyII/lib/testlib.lua");
        assertThat(zippedFilesSet).contains("NoteworthyII/NoteworthyII.toc");
        assertThat(zippedFilesSet).contains("NoteworthyII/README.md");
        assertThat(zippedFilesSet).contains("NoteworthyII/LICENSE.txt");
    }
}
