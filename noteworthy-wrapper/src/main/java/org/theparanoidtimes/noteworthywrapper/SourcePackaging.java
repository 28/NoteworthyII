package org.theparanoidtimes.noteworthywrapper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import static org.theparanoidtimes.noteworthywrapper.Constants.*;

public final class SourcePackaging {

    private static final String PACKAGE_NAME = "NoteworthyII";
    private static final int BUFFER_SIZE = 1024;

    public static void zipSourceDirectory(Path basePath, Path resultPath, String packageNameSuffix) throws Exception {
        String outputPackageName = resolvePackageName(resultPath, packageNameSuffix);
        System.out.println("Creating: " + outputPackageName);
        Path luaSourcePath = basePath.resolve(LUA_SOURCE_PATH);
        Path xmlSourcePath = basePath.resolve(XML_SOURCE_PATH);
        Path librariesPath = basePath.resolve(LIBRARIES_PATH);
        Path tocPath = basePath.resolve(TOC_PATH);
        Path readmePath = basePath.resolve(README_PATH);
        Path licensePath = basePath.resolve(LICENSE_PATH);
        try (FileOutputStream fileOutputStream = new FileOutputStream(outputPackageName);
             ZipOutputStream zipOutputStream = new ZipOutputStream(fileOutputStream)) {
            doZipSourceDirectory(luaSourcePath, zipOutputStream);
            doZipSourceDirectory(xmlSourcePath, zipOutputStream);
            doZipSourceDirectory(librariesPath, zipOutputStream, "lib/");
            doZipSourceDirectory(tocPath, zipOutputStream);
            doZipSourceDirectory(readmePath, zipOutputStream);
            doZipSourceDirectory(licensePath, zipOutputStream);
        }
        System.out.println(outputPackageName + " created.");
    }

    private static void doZipSourceDirectory(Path sourcePath, ZipOutputStream zipOutputStream) throws Exception {
        doZipSourceDirectory(sourcePath, zipOutputStream, "");
    }

    private static void doZipSourceDirectory(Path sourcePath, ZipOutputStream zipOutputStream, String subfolderName) throws Exception {
        Files.walkFileTree(sourcePath, new SimpleFileVisitor<>() {
            @Override
            public FileVisitResult visitFile(Path path, BasicFileAttributes attrs) throws IOException {
                System.out.println("Zipping: " + path);
                File file = path.toFile();
                try (FileInputStream fileInputStream = new FileInputStream(file)) {
                    ZipEntry zipEntry = new ZipEntry(subfolderName + file.getName());
                    zipOutputStream.putNextEntry(zipEntry);

                    byte[] bytes = new byte[BUFFER_SIZE];
                    int length;
                    while ((length = fileInputStream.read(bytes)) >= 0) {
                        zipOutputStream.write(bytes, 0, length);
                    }
                }
                return super.visitFile(path, attrs);
            }
        });
    }

    private static String resolvePackageName(Path resultPath, String packageNameSuffix) {
        return String.format("%s/%s_%s.zip", resultPath.toString(), PACKAGE_NAME, packageNameSuffix);
    }
}
