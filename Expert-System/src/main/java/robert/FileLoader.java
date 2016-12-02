package robert;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.File;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.List;

public class FileLoader {

	private static final FileLoader self = new FileLoader();

	private static final String DEFAULT_FILE = "input_data.xml";

	public List<String> parseXML(String fileName) {
		fileName = fileName.trim();
		if (".xml".equals(fileName)) {
			fileName = DEFAULT_FILE;
		}
		Document document = loadDocument(fileName);
		return parseDocument(document);
	}

	private List<String> parseDocument(Document document) {
		document.getDocumentElement().normalize();
		NodeList rules = document.getElementsByTagName("rules");
		for (int i = 0; i < rules.getLength(); i++) {
			Node item = rules.item(i);
		}
		// TODO
		return Collections.emptyList();
	}

	public static FileLoader getInstance() {
		return self;
	}

	private Document loadDocument(String fileName) {
		String filePath = Paths.get("resources", fileName).toAbsolutePath().toString();
		MainFrame.logEvent("File path:\t" + filePath);
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);
		try {
			return factory.newDocumentBuilder().parse(new File(filePath));
		} catch (Exception e) {
			MainFrame.logEvent("ERROR: Could not load the file");
			return null;
		}
	}
}
