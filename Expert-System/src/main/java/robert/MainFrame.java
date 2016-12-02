package robert;

import javax.swing.*;
import java.awt.*;

public class MainFrame extends JFrame {

	private MainFrame() {
		super("Expert System");
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
			}
		});
	}
}
