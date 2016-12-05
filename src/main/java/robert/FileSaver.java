package robert;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;

public class FileSaver {

	private static final FileSaver singleton = new FileSaver();

	private static final File file = new File(Paths.get("jess", "bin", "facts.clp").toUri());

	private FileSaver() {
	}

	public void saveInputDataToClpFile(Collection<String> inputData) throws Exception {
		if (Constants.LABEL_NAMES.length != Constants.CLP_VARIABLES.length) {
			MainFrame.logEvent("ERROR: Not enough CLP variables");
			throw new RuntimeException();
		}

		List<String> list = new LinkedList<>();

		int i = 0;
		for (String value : inputData) {
			String clpVariable = Constants.CLP_VARIABLES[i++];
			String formatted = String.format(clpVariable, value);
			list.add(formatted);
		}

		FileUtils.deleteQuietly(file);
		FileUtils.writeLines(file, list);
	}


	public static FileSaver getInstance() {
		return singleton;
	}
}
