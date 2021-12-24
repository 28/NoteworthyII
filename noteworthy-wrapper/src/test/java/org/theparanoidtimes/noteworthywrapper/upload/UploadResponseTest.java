package org.theparanoidtimes.noteworthywrapper.upload;

import org.junit.jupiter.api.Test;
import org.theparanoidtimes.noteworthywrapper.upload.domain.UploadResponse;

import static org.assertj.core.api.Assertions.assertThat;
import static org.theparanoidtimes.noteworthywrapper.upload.ObjectMapperProvider.getObjectMapper;

class UploadResponseTest {

    @Test
    void uploadResponseWillCorrectlyBeParsed() throws Exception {
        var uploadResponseJsonString = """
                {
                    "id": 20402
                }
                """;
        var uploadResponse = getObjectMapper().readValue(uploadResponseJsonString, UploadResponse.class);

        assertThat(uploadResponse.getFileId()).isEqualTo(20402L);
    }
}
