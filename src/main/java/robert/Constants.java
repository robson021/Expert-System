package robert;

public interface Constants {
	String[] LABEL_NAMES = new String[]{
            "Distance of route (0 - 3000km)",
			"Available flight speed (300 - 1000km/h)",
			"Weather condition (-1.0  -  1.0)"
    };

	String[] CLP_VARIABLES = new String[]{
			"(defglobal ?*distance* = %s )",
            "(defglobal ?*speed* = %s )",
            "(defglobal ?*weather* = %s )"
    };

	short DEFAULT_TEXT_FIELD_WIDTH = 7;

	short DEFAULT_TEXT_AREA_WIDTH = DEFAULT_TEXT_FIELD_WIDTH * 8;
}
