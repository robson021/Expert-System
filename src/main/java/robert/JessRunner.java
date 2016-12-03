package robert;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class JessRunner {

	private static final JessRunner singleton = new JessRunner();

	private JessRunner() {
	}

	public static JessRunner getInstance() {
		return singleton;
	}

	public void runJess() throws Exception {
		// TODO
		Process process = new ProcessBuilder(
				"jess.bat", "facts.clp")
				.start();
		InputStream is = process.getInputStream();
		InputStreamReader isr = new InputStreamReader(is);
		BufferedReader br = new BufferedReader(isr);

		String line;
		while ((line = br.readLine()) != null) {
			System.out.println(line);
		}
	}
}
