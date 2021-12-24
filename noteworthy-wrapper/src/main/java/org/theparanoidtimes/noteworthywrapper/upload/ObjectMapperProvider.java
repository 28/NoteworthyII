package org.theparanoidtimes.noteworthywrapper.upload;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import org.theparanoidtimes.noteworthywrapper.upload.domain.ChangelogType;
import org.theparanoidtimes.noteworthywrapper.upload.domain.RelationType;
import org.theparanoidtimes.noteworthywrapper.upload.domain.ReleaseType;

public abstract class ObjectMapperProvider {

    private static ObjectMapper objectMapper;

    public static ObjectMapper getObjectMapper() {
        if (objectMapper == null) {
            objectMapper = new ObjectMapper();
            var module = new SimpleModule();
            module.addSerializer(ReleaseType.class, new ReleaseType.Serializer());
            module.addSerializer(ChangelogType.class, new ChangelogType.Serializer());
            module.addSerializer(RelationType.class, new RelationType.Serializer());
            objectMapper.registerModule(module);
        }
        return objectMapper;
    }
}
