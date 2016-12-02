package robert;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.InputStream;
import java.util.LinkedList;
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

	private List<String> parseDocument(Document doc) {
		doc.getDocumentElement().normalize();
		System.out.println("Doc is normalized now.");
		System.out.println("Root element :" + doc.getDocumentElement().getNodeName());
		NodeList nList = doc.getElementsByTagName("rule");
		List<String> list = new LinkedList<>();
		for (int i = 0; i < nList.getLength(); i++) {
			Node nNode = nList.item(i);
			if (nNode.getNodeType() != Node.ELEMENT_NODE) continue;
			Element eElement = (Element) nNode;
			String value = eElement.getElementsByTagName("value").item(0).getTextContent();
			list.add(value);
		}
		return list;
	}

	public static FileLoader getInstance() {
		return self;
	}

	private Document loadDocument(String fileName) {
		/*String filePath = Paths.get("resources", fileName).toString();
		MainFrame.logEvent("File path:\t" + filePath);*/

		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true);

		System.out.println("File name: " + fileName);
		ClassLoader classloader = Thread.currentThread().getContextClassLoader();
		InputStream is = classloader.getResourceAsStream(fileName);
		try {
			return factory.newDocumentBuilder().parse(is);
		} catch (Exception e) {
			MainFrame.logEvent("ERROR: Could not load the file");
			return null;
		}
	}
}
