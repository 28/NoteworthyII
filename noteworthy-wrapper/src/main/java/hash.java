import org.theparanoidtimes.noteworthywrapper.Hasher;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

import java.nio.file.Path;
import java.util.concurrent.Callable;

@SuppressWarnings({"FieldCanBeLocal", "FieldMayBeFinal"})
@Command(name = "hash",
        description = "Creates a hash value for the given package file. Can use MD5, SHA-1, SHA-256, SHA-384 and SHA-512.",
        version = "Version 1.0 Noteworthy II Wrapper",
        mixinStandardHelpOptions = true)
public class hash implements Callable<Integer> {

    @Option(names = {"-a", "--algorithm"}, description = "Algorithm to use for hashing. Can be MD5, SHA-1, SHA-256, SHA-384 and SHA-512. Default is MD5.")
    private String algorithm = "MD5";

    @Parameters(index = "0", description = "Package to hash.")
    private String packageToHash;

    @Override
    public Integer call() throws Exception {
        String hash = Hasher.hashPackage(Path.of(packageToHash), algorithm);
        System.out.println(hash);
        return 0;
    }

    public static void main(String[] args) {
        int resultCode = new CommandLine(new hash()).execute(args);
        System.exit(resultCode);
    }
}
