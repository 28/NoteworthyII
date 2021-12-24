package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonPropertyOrder({"id"})
public class UploadResponse {

    @JsonProperty("id")
    private Long fileId;

    @Override
    public String toString() {
        return "UploadResponse{" +
                "fileId=" + fileId +
                '}';
    }

    public Long getFileId() {
        return fileId;
    }

    public void setFileId(Long fileId) {
        this.fileId = fileId;
    }
}
