import org.theparanoidtimes.noteworthywrapper.SourcePackaging;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;

import java.nio.file.Path;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.concurrent.Callable;

@SuppressWarnings({"FieldCanBeLocal", "FieldMayBeFinal"})
@Command(name = "pack",
        description = "Packages the Noteworthy II source to a zip file. Package version can be provided to be included in the name, otherwise current timestamp is appended.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true)
public class pack implements Callable<Integer> {

    private static final String timestampFormat = "ddMMyyyHHmmss";

    @Option(names = {"-b", "--baseDir"},
            description = "Noteworthy II source location. Default is the local directory.")
    private String baseDirectory = ".";

    @Option(names = {"-pv", "--packageVersion"},
            description = "Package version that will be included in the name.")
    private String packageVersion = getCurrentTimestamp();

    @Option(names = {"-rd", "--resultDir"},
            description = "Location of the package output. Default is the local directory.")
    private String resultDirectory = ".";

    @Override
    public Integer call() throws Exception {
        SourcePackaging.zipSourceDirectory(Path.of(baseDirectory), Path.of(resultDirectory), packageVersion);
        return 0;
    }

    private String getCurrentTimestamp() {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern(timestampFormat);
        return dateTimeFormatter.format(now);
    }

    public static void main(String[] args) {
        int resultCode = new CommandLine(new pack()).execute(args);
        System.exit(resultCode);
    }
}
