package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder({"gameVersionTypeId", "id", "name", "slug"})
public class GameVersion {

    @JsonProperty("gameVersionTypeID")
    private Long gameVersionTypeId;

    @JsonProperty("id")
    private Long id;

    @JsonProperty("name")
    private String name;

    @JsonProperty("slug")
    private String slug;

    @Override
    public String toString() {
        return "GameVersion{" +
                "gameVersionTypeId=" + gameVersionTypeId +
                ", id=" + id +
                ", name='" + name + '\'' +
                ", slug='" + slug + '\'' +
                '}';
    }

    public Long getGameVersionTypeId() {
        return gameVersionTypeId;
    }

    public void setGameVersionTypeId(Long gameVersionTypeId) {
        this.gameVersionTypeId = gameVersionTypeId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }
}
