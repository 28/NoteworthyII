package org.theparanoidtimes.noteworthywrapper;

import org.junit.jupiter.api.Test;

import java.nio.file.Path;
import java.util.Objects;

import static org.assertj.core.api.Assertions.assertThat;

class ChangelogDeltaGeneratorTest {

    @Test
    void generatorWillReturnOnlyOneParagraphForTheSpecifiedVersion() throws Exception {
        var changelogPath = Path.of(Objects.requireNonNull(ChangelogDeltaGeneratorTest.class.getResource("/changelog.txt")).toURI());
        var paragraph = ChangelogDeltaGenerator.generateChangelogDelta(changelogPath, "v2.3.0");
        var expectedResult = """
                ## V2.3.0
                - General
                  - Introduce the undo feature for each tab
                - UI
                  - Introduce 'Undo' button in the top right corner of the Noteworthy window""";
        assertThat(paragraph).isEqualToIgnoringNewLines(expectedResult);
    }

    @Test
    void generatorWillReturnRangeOfParagraphsForARangeOfVersions() throws Exception {
        var changelogPath = Path.of(Objects.requireNonNull(ChangelogDeltaGeneratorTest.class.getResource("/changelog.txt")).toURI());
        var paragraph = ChangelogDeltaGenerator.generateChangelogDelta(changelogPath, "v2.3.0", "V2.2.1");
        var expectedResult = """
                ## V2.3.0
                - General
                  - Introduce the undo feature for each tab
                - UI
                  - Introduce 'Undo' button in the top right corner of the Noteworthy window

                ## V2.2.1
                - General
                  - Update interface version""";
        assertThat(paragraph).isEqualToIgnoringNewLines(expectedResult);
    }

    @Test
    void generatorWillReturnNothingIfFromVersionDoesNotExist() throws Exception {
        var changelogPath = Path.of(Objects.requireNonNull(ChangelogDeltaGeneratorTest.class.getResource("/changelog.txt")).toURI());
        var paragraph = ChangelogDeltaGenerator.generateChangelogDelta(changelogPath, "v42");
        assertThat(paragraph).isEmpty();
    }

    @Test
    void generatorWillReturnWholeChangelogIfToVersionDoesNotExist() throws Exception {
        var changelogPath = Path.of(Objects.requireNonNull(ChangelogDeltaGeneratorTest.class.getResource("/changelog.txt")).toURI());
        var paragraph = ChangelogDeltaGenerator.generateChangelogDelta(changelogPath, "v2.3.0", "V42");
        var expectedResult = """                                            
                ## V2.3.0
                - General
                  - Introduce the undo feature for each tab
                - UI
                  - Introduce 'Undo' button in the top right corner of the Noteworthy window
                                
                ## V2.2.1
                - General
                  - Update interface version
                                
                ## V2.2.0
                - General
                  - Character notes are now saved as 'Character-Realm'
                - UI
                  - Noteworthy window size changed to 400x450
                  - Reminder window size changed to 350x100
                  - Reminder checkbox moved under the text area in character notes screen""";
        assertThat(paragraph).isEqualToIgnoringNewLines(expectedResult);
    }
}
