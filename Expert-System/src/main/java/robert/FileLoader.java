package robert;

import java.util.Collections;
import java.util.List;

public class FileLoader {
	private static final FileLoader self = new FileLoader();

	private FileLoader() {
	}

	public List<String> loadDataFromTheFile() {
		return Collections.emptyList();
	}

	public static FileLoader getInstance() {
		return self;
	}
}
