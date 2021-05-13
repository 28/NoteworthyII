import org.theparanoidtimes.noteworthywrapper.PackageInstallation;
import picocli.CommandLine;
import picocli.CommandLine.Command;

import java.nio.file.Path;
import java.util.concurrent.Callable;

import static org.theparanoidtimes.noteworthywrapper.Constants.INSTALLATION_DIRECTORY_ENV_VAR;
import static picocli.CommandLine.Option;

@SuppressWarnings({"FieldCanBeLocal", "FieldMayBeFinal"})
@Command(name = "install",
        description = "Installs the given Noteworthy II source to the WoW installation directory. The directory can be passed as a parameter. If not, it is read from 'WOWIL' environment variable.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true)
public class install implements Callable<Integer> {

    @Option(names = {"-b", "--baseDir"},
            description = "Noteworthy II source location. Default is the local directory.")
    private String baseDirectory = ".";

    @Option(names = {"-i", "--installationDir"},
            description = "WoW game installation directory. Default is the value of 'WOWIL' environment variable if present, otherwise local directory.")
    private String installationDirectory = getDefaultInstallationDirectory();

    @Override
    public Integer call() throws Exception {
        PackageInstallation.installLocally(Path.of(baseDirectory), Path.of(installationDirectory));
        return 0;
    }

    private String getDefaultInstallationDirectory() {
        String value = System.getenv(INSTALLATION_DIRECTORY_ENV_VAR);
        return value != null ? value : ".";
    }

    public static void main(String[] args) {
        int resultCode = new CommandLine(new install()).execute(args);
        System.exit(resultCode);
    }
}
