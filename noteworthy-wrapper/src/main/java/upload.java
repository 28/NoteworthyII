import org.theparanoidtimes.noteworthywrapper.ChangelogDeltaGenerator;
import org.theparanoidtimes.noteworthywrapper.upload.CurseForgeUploader;
import org.theparanoidtimes.noteworthywrapper.upload.domain.UploadRequest;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.nio.file.Path;
import java.util.concurrent.Callable;

import static org.theparanoidtimes.noteworthywrapper.Constants.CHANGELOG_PATH;

@Command(name = "upload",
        description = "Uploads a Noteworthy II package and its associated metadata to CurseForge as a release.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true)
public class upload implements Callable<Integer> {

    @Option(names = {"-p", "--pathToPackage"},
            description = "Path to the release package.",
            required = true)
    private String pathToPackage;

    @Option(names = {"-rv", "--releaseVersion"},
            description = "Release version of the Noteworthy II package.",
            required = true)
    private String releaseVersion;

    @Option(names = {"-gv", "--gameVersion"},
            description = "Supported WoW version by the package being uploaded.",
            required = true)
    private String gameVersion;

    @Override
    public Integer call() {
        try {
            String changelogDelta = ChangelogDeltaGenerator.generateChangelogDelta(Path.of(CHANGELOG_PATH), releaseVersion);
            var uploadRequest = new UploadRequest();
            uploadRequest.setChangelog(changelogDelta);
            uploadRequest.setDisplayName(releaseVersion);
            Long fileId = CurseForgeUploader.uploadReleaseToCurseForge(Path.of(pathToPackage), gameVersion, uploadRequest);
            System.out.println("Release uploaded to CurseForge, file ID: " + fileId);
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return -28;
        }
    }

    public static void main(String[] args) {
        var resultCode = new CommandLine(new upload()).execute(args);
        System.exit(resultCode);
    }
}
