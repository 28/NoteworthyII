package org.theparanoidtimes.noteworthywrapper;

import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.Objects;

import static org.assertj.core.api.Assertions.assertThat;

class PackageInstallationTest {

    private static Path testSourcePath;
    private static Path testPackageInstallationPath;

    @BeforeAll
    static void prepare() throws Exception {
        testSourcePath = Path.of(Objects.requireNonNull(SourcePackagingTest.class.getResource("/source")).toURI());
        testPackageInstallationPath = Path.of(Objects.requireNonNull(SourcePackagingTest.class.getResource("/install")).toURI());
    }

    @SuppressWarnings("ResultOfMethodCallIgnored")
    @BeforeEach
    void cleanInstallDirectory() throws Exception {
        Files.walk(testPackageInstallationPath)
                .sorted(Comparator.reverseOrder())
                .map(Path::toFile)
                .filter(file -> !file.isDirectory())
                .filter(file -> !file.getName().equals(".gitignore"))
                .forEach(File::delete);
    }

    @Test
    void wrapperWillInstallAllRequiredFilesToTheSpecifiedLocation() throws Exception {
        PackageInstallation.installLocally(testSourcePath, testPackageInstallationPath);

        assertThat(testPackageInstallationPath.resolve("Interface/AddOns/NoteworthyII/test.lua")).exists();
        assertThat(testPackageInstallationPath.resolve("Interface/AddOns/NoteworthyII/test.xml")).exists();
        assertThat(testPackageInstallationPath.resolve("Interface/AddOns/NoteworthyII/NoteworthyII.toc")).exists();
        assertThat(testPackageInstallationPath.resolve("Interface/AddOns/NoteworthyII/lib/testlib.lua")).exists();
    }
}
