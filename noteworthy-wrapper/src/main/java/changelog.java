import org.theparanoidtimes.noteworthywrapper.ChangelogDeltaGenerator;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.nio.file.Path;
import java.util.concurrent.Callable;

import static org.theparanoidtimes.noteworthywrapper.Constants.CHANGELOG_PATH;

@Command(name = "changelog",
        description = "Extracts info from the Change log for the required version range.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true
)
public class changelog implements Callable<Integer> {

    @Option(names = {"-vf", "--versionFrom"},
            description = "Starting version / heading.",
            required = true)
    private String versionFrom;

    @Option(names = {"-vt", "--versionTo"},
            description = "End version / heading.")
    private String versionTo;

    @Option(names = {"-c", "--changelogLocation"},
            description = "The location of the change log file. Default is the file from the repository.")
    private String changelogLocation = CHANGELOG_PATH;

    @Override
    public Integer call() throws Exception {
        var delta = ChangelogDeltaGenerator.generateChangelogDelta(Path.of(changelogLocation), versionFrom, versionTo);
        System.out.println(delta);
        return 0;
    }

    public static void main(String[] args) {
        var resultCode = new CommandLine(new changelog()).execute(args);
        System.exit(resultCode);
    }
}
