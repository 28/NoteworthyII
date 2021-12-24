package org.theparanoidtimes.noteworthywrapper.upload.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

import java.util.ArrayList;
import java.util.List;

@JsonPropertyOrder({"projects"})
public class Relations {

    @JsonProperty("projects")
    private List<Project> projects = new ArrayList<>();

    public Relations() {}

    public Relations(List<Project> projects) {
        this.projects = projects;
    }

    public List<Project> getProjects() {
        return projects;
    }

    public void setProjects(List<Project> projects) {
        this.projects = projects;
    }
}
