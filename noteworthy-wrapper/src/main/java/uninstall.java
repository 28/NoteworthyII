import picocli.CommandLine;
import picocli.CommandLine.Command;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.concurrent.Callable;

import static org.theparanoidtimes.noteworthywrapper.Constants.INSTALLATION_DIRECTORY_ENV_VAR;
import static org.theparanoidtimes.noteworthywrapper.Constants.INSTALL_LOCATION;

@Command(name = "uninstall",
        description = "Uninstalls Noteworthy II from WoW addons location.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true)
public class uninstall implements Callable<Integer> {

    @CommandLine.Option(names = {"-i", "--installationDir"},
            description = "WoW game installation directory. Default is the value of 'WOWIL' environment variable if present, otherwise local directory.")
    private String installationDirectory = getDefaultInstallationDirectory();

    @SuppressWarnings("ResultOfMethodCallIgnored")
    @Override
    public Integer call() throws Exception {
        Path installationDir = Path.of(installationDirectory).resolve(INSTALL_LOCATION);
        System.out.println("Uninstalling Noteworthy II from: " + installationDir);
        if (installationDir.toFile().exists()) {
            Files.walk(installationDir)
                    .sorted(Comparator.reverseOrder())
                    .map(Path::toFile)
                    .forEach(File::delete);
        }
        System.out.println("Noteworthy II uninstalled.");
        return 0;
    }

    private String getDefaultInstallationDirectory() {
        var value = System.getenv(INSTALLATION_DIRECTORY_ENV_VAR);
        return value != null ? value : ".";
    }

    public static void main(String[] args) {
        var resultCode = new CommandLine(new uninstall()).execute(args);
        System.exit(resultCode);
    }
}
