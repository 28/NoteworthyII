package org.theparanoidtimes.noteworthywrapper;

import org.junit.jupiter.api.Test;

import java.nio.file.Path;
import java.util.Objects;

import static org.assertj.core.api.Assertions.assertThat;

class HashingTest {

    @Test
    void hasherWillProvideHashStringForAllMD5SHA1AndSha256() throws Exception {
        Path file = Path.of(Objects.requireNonNull(HashingTest.class.getResource("/source/lib/testlib.lua")).toURI());
        String md5 = Hasher.hashPackage(file, "MD5");
        String sha1 = Hasher.hashPackage(file, "SHA1");
        String sha256 = Hasher.hashPackage(file, "SHA-256");

        assertThat(md5).isEqualTo("d41d8cd98f00b204e9800998ecf8427e");
        assertThat(sha1).isEqualTo("da39a3ee5e6b4b0d3255bfef95601890afd80709");
        assertThat(sha256).isEqualTo("e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
    }
}
