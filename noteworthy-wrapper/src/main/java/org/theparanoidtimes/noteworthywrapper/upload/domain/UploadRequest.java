package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_NULL;

@JsonInclude(NON_NULL)
@JsonPropertyOrder({"changelog", "changelogType", "displayName", "parentFileId", "gameVersions", "releaseType", "relations"})
public class UploadRequest {

    @JsonProperty("changelog")
    private String changelog;

    @JsonProperty("changelogType")
    private ChangelogType changelogType = ChangelogType.MARKDOWN;

    @JsonProperty("displayName")
    private String displayName;

    @JsonProperty("parentFileID")
    private Long parentFileId;

    @JsonProperty("gameVersions")
    private List<Long> gameVersions;

    @JsonProperty("releaseType")
    private ReleaseType releaseType = ReleaseType.RELEASE;

    @JsonProperty("relations")
    private Relations relations;

    @Override
    public String toString() {
        return "UploadRequest{" +
                "changelog='" + changelog + '\'' +
                ", changelogType=" + changelogType +
                ", displayName='" + displayName + '\'' +
                ", parentFileId=" + parentFileId +
                ", gameVersions=" + gameVersions +
                ", releaseType=" + releaseType +
                ", relations=" + relations +
                '}';
    }

    public String getChangelog() {
        return changelog;
    }

    public void setChangelog(String changelog) {
        this.changelog = changelog;
    }

    public ChangelogType getChangelogType() {
        return changelogType;
    }

    public void setChangelogType(ChangelogType changelogType) {
        this.changelogType = changelogType;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public Long getParentFileId() {
        return parentFileId;
    }

    public void setParentFileId(Long parentFileId) {
        this.parentFileId = parentFileId;
    }

    public List<Long> getGameVersions() {
        return gameVersions;
    }

    public void setGameVersions(List<Long> gameVersions) {
        this.gameVersions = gameVersions;
    }

    public ReleaseType getReleaseType() {
        return releaseType;
    }

    public void setReleaseType(ReleaseType releaseType) {
        this.releaseType = releaseType;
    }

    public Relations getRelations() {
        return relations;
    }

    public void setRelations(Relations relations) {
        this.relations = relations;
    }
}
