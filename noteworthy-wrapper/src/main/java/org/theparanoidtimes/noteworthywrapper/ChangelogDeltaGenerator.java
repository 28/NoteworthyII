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
        String normalizedVersionHeadingFrom = normalizeVersionHeading(versionHeadingFrom);
        String normalizedVersionHeadingTo = normalizeVersionHeading(versionHeadingTo);
        boolean foundFromParagraph = false;
        var stringBuilder = new StringBuilder();
        for (String paragraph : paragraphs) {
            if (foundFromParagraph) {
                if (normalizedVersionHeadingTo == null)
                    break;
                else if (paragraph.contains(normalizedVersionHeadingTo.toUpperCase())) {
                    append(stringBuilder, paragraph);
                    break;
                } else
                    append(stringBuilder, paragraph);
            } else if (paragraph.contains(normalizedVersionHeadingFrom.toUpperCase())) {
                append(stringBuilder, paragraph);
                foundFromParagraph = true;
            }
        }
        return stringBuilder.toString().trim();
    }

    private static String normalizeVersionHeading(String versionHeading) {
        if (versionHeading == null)
            return null;
        int dashIndex = versionHeading.indexOf("-");
        if (dashIndex != -1) {
            return versionHeading.substring(0, dashIndex);
        } else
            return versionHeading;
    }

    private static void append(StringBuilder stringBuilder, String line) {
        stringBuilder.append(CHANGELOG_HEADING_DELIMITER);
        stringBuilder.append(" ");
        stringBuilder.append(line.stripLeading());
    }
}
