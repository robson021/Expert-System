package robert;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Paths;

public class JessRunner {

    private static final JessRunner singleton = new JessRunner();

    private JessRunner() {
    }

    public static JessRunner getInstance() {
        return singleton;
    }

    public void runJess() throws Exception {

        String facts = Paths.get("jess", "bin", "facts.clp").toAbsolutePath().toString();
        String bat = Paths.get("jess", "bin", "jess.bat").toAbsolutePath().toString();

        Process process = new ProcessBuilder(bat, facts)
                .start();

        InputStream is = process.getInputStream();
        InputStreamReader isr = new InputStreamReader(is);

        BufferedReader br = new BufferedReader(isr);

        MainFrame.logEvent("\tOUTPUT:");
        String line;
        while ((line = br.readLine()) != null) {
            MainFrame.logEvent(line);
            System.out.println(line);
        }
        System.out.println("End of jess process.");
    }
}
