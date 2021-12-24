package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder({"slug", "relationType"})
public class Project {

    @JsonProperty("slug")
    private String slug;

    @JsonProperty("type")
    private RelationType relationType;

    public Project() {}

    public Project(String slug, RelationType relationType) {
        this.slug = slug;
        this.relationType = relationType;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public RelationType getRelationType() {
        return relationType;
    }

    public void setRelationType(RelationType relationType) {
        this.relationType = relationType;
    }
}
