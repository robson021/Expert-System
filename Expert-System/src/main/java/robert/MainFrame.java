package robert;

import robert.enums.InputLabels;

import javax.swing.*;
import java.awt.*;
import java.util.LinkedList;
import java.util.List;

public class MainFrame extends JFrame {

	private final List<JTextField> textFields = new LinkedList<>();

	private MainFrame() {
		super("Expert System");
		this.setLayout(new BorderLayout());
		final FlowLayout flowLayout = new FlowLayout();

		JPanel northPanel = new JPanel(flowLayout);
		northPanel.add(new JLabel("Enter the rules via form or load them with XML file."));
		this.add(northPanel, BorderLayout.NORTH);

		JPanel formPanel = generateFormPanel();
		JPanel consolePanel = generateConsole();

		JPanel centerPanel = new JPanel(new GridLayout(2, 1));
		centerPanel.add(formPanel);
		centerPanel.add(consolePanel);
		this.add(centerPanel, BorderLayout.CENTER);

		JPanel southPanel = new JPanel(flowLayout);
		JButton submitFormButton = new JButton("Submit form");
		JButton loadFromFileButton = new JButton("Load input from the file");

		southPanel.add(submitFormButton);
		southPanel.add(loadFromFileButton);
		this.add(southPanel, BorderLayout.SOUTH);
	}

	private JPanel generateConsole() {
		JTextArea textArea = new JTextArea();
		textArea.setEditable(false);
		textArea.setWrapStyleWord(true);
		textArea.setColumns(InputLabels.DEFAULT_TEXT_FIELD_WITH * 4);
		textArea.setRows(InputLabels.DEFAULT_TEXT_FIELD_WITH);

		JPanel panel = new JPanel();
		panel.add(new JScrollPane(textArea));
		return panel;
	}

	private JPanel generateFormPanel() {
		int numOfLabels = InputLabels.LABEL_NAMES.length;
		JPanel targetPanel = new JPanel(new GridLayout(numOfLabels, 2));

		for (String labelName : InputLabels.LABEL_NAMES) {
			JTextField textField = new JTextField(InputLabels.DEFAULT_TEXT_FIELD_WITH);
			this.textFields.add(textField);
			JPanel tmpPanel = new JPanel(new FlowLayout());
			tmpPanel.add(new JLabel(labelName));
			targetPanel.add(tmpPanel);
			tmpPanel = new JPanel(new FlowLayout());
			tmpPanel.add(textField);
			targetPanel.add(tmpPanel);
		}
		return targetPanel;
	}

	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				JFrame frame = new MainFrame();
				frame.setDefaultCloseOperation(WindowConstants.EXIT_ON_CLOSE);
				frame.setMinimumSize(new Dimension(300, 300));
				frame.setLocationRelativeTo(null);
				frame.setResizable(false);
				frame.pack();
				frame.setVisible(true);
				System.out.println("Frame initiated.");
			}
		});
	}
}
