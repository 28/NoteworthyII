package org.theparanoidtimes.noteworthywrapper;

import java.nio.file.Files;
import java.nio.file.Path;

import static java.util.Arrays.stream;
import static org.theparanoidtimes.noteworthywrapper.Constants.CHANGELOG_HEADING_DELIMITER;

public final class ChangelogDeltaGenerator {

    public static String generateChangelogDelta(Path changelogLocation, String versionHeadingFrom) throws Exception {
        return generateChangelogDelta(changelogLocation, versionHeadingFrom, null);
    }

    public static String generateChangelogDelta(Path changelogLocation, String versionHeadingFrom, String versionHeadingTo) throws Exception {
        var changelog = Files.readString(changelogLocation);
        var paragraphs = stream(changelog.split(CHANGELOG_HEADING_DELIMITER)).skip(1).toList();
        boolean foundFromParagraph = false;
        var stringBuilder = new StringBuilder();
        for (String paragraph : paragraphs) {
            if (foundFromParagraph) {
                if (versionHeadingTo == null)
                    break;
                else if (paragraph.contains(versionHeadingTo.toUpperCase())) {
                    append(stringBuilder, paragraph);
                    break;
                } else
                    append(stringBuilder, paragraph);
            } else if (paragraph.contains(versionHeadingFrom.toUpperCase())) {
                append(stringBuilder, paragraph);
                foundFromParagraph = true;
            }
        }
        return stringBuilder.toString().trim();
    }

    private static void append(StringBuilder stringBuilder, String line) {
        stringBuilder.append(CHANGELOG_HEADING_DELIMITER);
        stringBuilder.append(" ");
        stringBuilder.append(line.stripLeading());
    }
}
