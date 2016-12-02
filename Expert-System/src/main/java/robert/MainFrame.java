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
		JButton submitFormButton = new JButton("Submit form");
		JButton loadFromFileButton = new JButton("Load input from the file");

		submitFormButton.addActionListener(new SubmitButtonAction());
		loadFromFileButton.addActionListener(new LoadFormFileButtonAction());

		southPanel.add(submitFormButton);
		southPanel.add(loadFromFileButton);
		this.add(southPanel, BorderLayout.SOUTH);
	}

	private JPanel generateConsole() {
		JTextArea textArea = new JTextArea();
		textArea.setEditable(false);
		textArea.setWrapStyleWord(true);
		textArea.setColumns(Constants.DEFAULT_TEXT_AREA_WIDTH);
		textArea.setRows(Constants.DEFAULT_TEXT_FIELD_WIDTH);

		JPanel panel = new JPanel();
		panel.add(new JScrollPane(textArea));
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
		return targetPanel;
	}

	private void validateInputData(Collection<String> values) {
		if (values.size() < Constants.LABEL_NAMES.length) {
			throw new RuntimeException("Not all fields have been filled");
		}
		values.forEach(str -> {
			if ("".equals(str.trim())) {
				throw new RuntimeException("NULL value at some field");
			}
		});
		System.out.println("Validation complete.");
	}

	private class SubmitButtonAction implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent e) {
			List<String> allTextFieldsValues = textFields.stream()
					.filter(jTextField -> !"".equals(jTextField.getText()))
					.map(JTextField::getText)
					.collect(Collectors.toList());
			validateInputData(allTextFieldsValues);
		}
	}

	private class LoadFormFileButtonAction implements ActionListener {
		@Override
		public void actionPerformed(ActionEvent e) {
			List<String> data = FileLoader.getInstance().loadDataFromTheFile();
			validateInputData(data);
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
