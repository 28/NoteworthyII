package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

import java.io.IOException;

public enum ReleaseType {

    ALPHA("alpha"),
    BETA("beta"),
    RELEASE("release");

    private final String id;

    ReleaseType(String id) {
        this.id = id;
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
