package robert;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

public class FileLoader {

    private static final FileLoader singleton = new FileLoader();

    private static final String DEFAULT_FILE = "input_data.xml";

    private FileLoader() {
    }

    public List<String> parseXML(String fileName) {
        fileName = fileName.trim();
        if (".xml".equals(fileName)) {
            fileName = DEFAULT_FILE;
        }
        Document document = loadDocument(fileName);
        return parseDocument(document);
    }

    public List<String> loadLastResult() {


        try {
            return Files.readAllLines(Paths.get("jess", "bin", "result.txt"));
        } catch (IOException e) {
            e.printStackTrace();
            MainFrame.logEvent("Could not load the file.");
            return Collections.emptyList();
        }
    }

    private List<String> parseDocument(Document doc) {
        doc.getDocumentElement().normalize();
        System.out.println("Doc is normalized now.");
        System.out.println("Root element: " + doc.getDocumentElement().getNodeName());
        NodeList nList = doc.getElementsByTagName("fact");
        List<String> list = new LinkedList<>();
        for (int i = 0; i < nList.getLength(); i++) {
            Node nNode = nList.item(i);
            if (nNode.getNodeType() != Node.ELEMENT_NODE) continue;
            Element eElement = (Element) nNode;
            String value = eElement.getElementsByTagName("value")
                    .item(0)
                    .getTextContent();
            list.add(value);
        }
        return list;
    }

    public static FileLoader getInstance() {
        return singleton;
    }

    private Document loadDocument(String fileName) {
        System.out.println("File name: " + fileName);
        ClassLoader classloader = Thread.currentThread().getContextClassLoader();
        InputStream is = classloader.getResourceAsStream(fileName);

        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        try {
            return factory.newDocumentBuilder()
                    .parse(is);
        } catch (Exception e) {
            MainFrame.logEvent("ERROR: Could not load the file");
            return null;
        }
    }
}
