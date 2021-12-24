package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;

import java.io.IOException;

public enum RelationType {

    EMBEDDED("embeddedLibrary"),
    INCOMPATIBLE("incompatible"),
    OPTIONAL("optionalDependency"),
    REQUIRED("requiredDependency"),
    TOOL("tool");

    private final String id;

    RelationType(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public static class Serializer extends StdSerializer<RelationType> {

        public Serializer() {
            this(null);
        }

        protected Serializer(Class<RelationType> t) {
            super(t);
        }

        @Override
        public void serialize(RelationType value, JsonGenerator gen, SerializerProvider provider) throws IOException {
            gen.writeString(value.getId());
        }
    }
}
