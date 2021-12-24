package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

import java.io.IOException;

public enum ChangelogType {

    TEXT("text"),
    HTML("html"),
    MARKDOWN("markdown");

    private final String id;

    ChangelogType(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public static class Serializer extends StdSerializer<ChangelogType> {

        public Serializer() {
            this(null);
        }

        protected Serializer(Class<ChangelogType> t) {
            super(t);
        }

        @Override
        public void serialize(ChangelogType value, JsonGenerator gen, SerializerProvider provider) throws IOException {
            gen.writeString(value.getId());
        }
    }
}
