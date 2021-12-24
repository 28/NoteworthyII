package org.theparanoidtimes.noteworthywrapper.upload;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.junit.jupiter.api.Test;
import org.theparanoidtimes.noteworthywrapper.upload.domain.*;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class UploadRequestTest {

    @Test
    void uploadRequestObjectWillCorrectlyBeSerializedToJsonString() throws JsonProcessingException {
        var uploadRequest = new UploadRequest();
        uploadRequest.setChangelog("A string describing changes.");
        uploadRequest.setChangelogType(ChangelogType.MARKDOWN);
        uploadRequest.setDisplayName("Foo");
        uploadRequest.setParentFileId(42L);
        uploadRequest.setGameVersions(List.of(157L, 158L));
        uploadRequest.setReleaseType(ReleaseType.ALPHA);
        uploadRequest.setRelations(new Relations(List.of(new Project("mantle", RelationType.EMBEDDED))));

        var expectedJsonString = """
                {
                    "changelog":" A string describing changes.",
                    "changelogType": "markdown",
                    "displayName": "Foo",
                    "parentFileID": 42,
                    "gameVersions": [157, 158],
                    "releaseType": "alpha",
                    "relations": {
                        "projects": [{
                            "slug": "mantle",
                            "type": "embeddedLibrary"
                        }]
                    }
                }
                """;
        var objectMapper = ObjectMapperProvider.getObjectMapper();
        var jsonString = objectMapper.writeValueAsString(uploadRequest);
        assertThat(jsonString).isEqualToIgnoringWhitespace(expectedJsonString);
    }
}
