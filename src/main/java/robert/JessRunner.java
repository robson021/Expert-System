package robert;

public class JessRunner {

	private static final JessRunner singleton = new JessRunner();

	private JessRunner() {
	}

	public static JessRunner getInstance() {
		return singleton;
	}

	public void runJess() {

	}
}
