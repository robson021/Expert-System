package robert;

import java.util.Collections;
import java.util.List;

public class FileLoader {
	private static final FileLoader self = new FileLoader();

	private static final String DEFAULT_FILE = "input_data.xml";

	private FileLoader() {
	}

	public List<String> parseXML(String fileName) {
		if (fileName == null || "".equals(fileName)) {
			fileName = DEFAULT_FILE;
		}
		// TODO
		return Collections.emptyList();
	}


	public static FileLoader getInstance() {
		return self;
	}
}
