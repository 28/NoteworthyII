package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

import java.io.IOException;
import java.util.Arrays;
import java.util.Optional;

public enum ReleaseType {

    ALPHA("alpha"),
    BETA("beta"),
    RELEASE("release");

    private final String id;

    ReleaseType(String id) {
        this.id = id;
    }

    public static Optional<ReleaseType> fromId(String releaseTypeId) {
        return Arrays.stream(ReleaseType.values()).filter(rt -> rt.id.equals(releaseTypeId)).findFirst();
    }

    public String getId() {
        return id;
    }

    public static class Serializer extends StdSerializer<ReleaseType> {

        public Serializer() {
            this(null);
        }

        protected Serializer(Class<ReleaseType> t) {
            super(t);
        }

        @Override
        public void serialize(ReleaseType value, JsonGenerator gen, SerializerProvider provider) throws IOException {
            gen.writeString(value.getId());
        }
    }
}
