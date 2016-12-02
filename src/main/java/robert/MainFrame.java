package robert;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class MainFrame extends JFrame {

	private final List<JTextField> textFields = new LinkedList<>();

	private final JTextField fileNameTextField;

	private static final JTextArea console = new JTextArea();

	private MainFrame() {
		super("Expert System");
		this.setLayout(new BorderLayout());
		final FlowLayout flowLayout = new FlowLayout();

		JPanel northPanel = new JPanel(flowLayout);
		northPanel.add(new JLabel("Enter the facts via form below or load them from XML file."));
		this.add(northPanel, BorderLayout.NORTH);

		JPanel formPanel = generateFormPanel();
		JPanel consolePanel = generateConsole();

		JPanel centerPanel = new JPanel(new BorderLayout());
		centerPanel.add(formPanel, BorderLayout.NORTH);
		centerPanel.add(consolePanel, BorderLayout.CENTER);
		this.add(centerPanel, BorderLayout.CENTER);

		JPanel southPanel = new JPanel(flowLayout);
		JButton loadFromFileButton = new JButton("Load input from the file");

		loadFromFileButton.addActionListener(new LoadFormFileButtonAction());
		southPanel.add(loadFromFileButton);

		fileNameTextField = new JTextField(Constants.DEFAULT_TEXT_FIELD_WIDTH * 2 / 3);
		southPanel.add(fileNameTextField);
		southPanel.add(new JLabel(".xml"));

		this.add(southPanel, BorderLayout.SOUTH);
	}

	private JPanel generateConsole() {
		console.setEditable(false);
		console.setWrapStyleWord(true);
		console.setColumns(Constants.DEFAULT_TEXT_AREA_WIDTH);
		console.setRows(Constants.DEFAULT_TEXT_FIELD_WIDTH);

		JPanel panel = new JPanel();
		panel.add(new JScrollPane(console));
		return panel;
	}

	private JPanel generateFormPanel() {
		JPanel targetPanel = new JPanel(new GridBagLayout());
		GridBagConstraints gbc = new GridBagConstraints();
		int insets = 7;
		gbc.insets = new Insets(insets, insets, insets, insets);
		gbc.gridx = gbc.gridy = 0;

		for (String labelName : Constants.LABEL_NAMES) {
			JTextField textField = new JTextField(Constants.DEFAULT_TEXT_FIELD_WIDTH);
			this.textFields.add(textField);

			targetPanel.add(new JLabel(labelName), gbc);
			gbc.gridx++;
			targetPanel.add(textField, gbc);

			gbc.gridx = 0;
			gbc.gridy++;
		}
		JButton submitFormButton = new JButton("Submit form");
		submitFormButton.addActionListener(new SubmitButtonAction());
		gbc.gridx++;
		targetPanel.add(submitFormButton, gbc);
		return targetPanel;
	}

	private void validateAndSubmitData(Collection<String> values) {
		if (values.size() < Constants.LABEL_NAMES.length) {
			logEvent("Error: Bad input data.");
			throw new RuntimeException();
		}
		logEvent("Validation complete.");
		generateJessFile(values);
	}

	private void generateJessFile(Collection<String> values) {
		logEvent("Input values:");
		values.forEach(MainFrame::logEvent);
		// TODO - generation of jess file
		logEvent("Jess file generated.");
		logEvent("-------------------------------------");
	}

	public static void logEvent(String text) {
		console.append(text);
		console.append("\n");
	}

	private class SubmitButtonAction implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent e) {
			List<String> allTextFieldsValues = textFields.stream()
					.filter(jTextField -> !"".equals(jTextField.getText()))
					.map(JTextField::getText)
					.collect(Collectors.toList());
			logEvent("Data form form is loaded. Validating...");
			validateAndSubmitData(allTextFieldsValues);
		}
	}

	private class LoadFormFileButtonAction implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent e) {
			String fileName = fileNameTextField.getText() + ".xml";
			List<String> data = FileLoader.getInstance()
					.parseXML(fileName.trim());
			logEvent("XML parsed. Validating...");
			validateAndSubmitData(data);
		}
	}

	public static void main(String[] args) {
		SwingUtilities.invokeLater(() -> {
			JFrame frame = new MainFrame();
			frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
			frame.setResizable(false);
			frame.pack();
			frame.setLocationRelativeTo(null);
			frame.setVisible(true);
			System.out.println("Frame initiated.");
		});
	}
}