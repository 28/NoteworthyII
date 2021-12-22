package org.theparanoidtimes.noteworthywrapper;

import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;

public class Hasher {

    public static String hashPackage(Path packagePath, String algorithm) throws Exception {
        var instance = MessageDigest.getInstance(algorithm);
        var source = Files.readAllBytes(packagePath);
        return convertByteArrayToHexString(instance.digest(source));
    }

    private static String convertByteArrayToHexString(byte[] arrayBytes) {
        var stringBuffer = new StringBuilder();
        for (var arrayByte : arrayBytes) {
            stringBuffer.append(Integer.toString((arrayByte & 0xff) + 0x100, 16).substring(1));
        }
        return stringBuffer.toString();
    }
}
