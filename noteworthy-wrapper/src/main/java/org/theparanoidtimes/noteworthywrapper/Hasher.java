package org.theparanoidtimes.noteworthywrapper;

import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;

public class Hasher {

    public static String hashPackage(Path packagePath, String algorithm) throws Exception {
        MessageDigest instance = MessageDigest.getInstance(algorithm);
        byte[] source = Files.readAllBytes(packagePath);
        return convertByteArrayToHexString(instance.digest(source));
    }

    private static String convertByteArrayToHexString(byte[] arrayBytes) {
        StringBuilder stringBuffer = new StringBuilder();
        for (byte arrayByte : arrayBytes) {
            stringBuffer.append(Integer.toString((arrayByte & 0xff) + 0x100, 16).substring(1));
        }
        return stringBuffer.toString();
    }
}
