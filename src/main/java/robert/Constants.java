package robert;

public interface Constants {
	String[] LABEL_NAMES = new String[]{
			"Distance of route (km)",
			"Crew experience (years)",
			"Available average flight speed (km/h)",
			"Weather condition (poor/normal/good)",
			"Airport preparation, runway (poor/normal/good)",
			"Number of passengers (latecomer probability)"
	};

	short DEFAULT_TEXT_FIELD_WIDTH = 7;

	short DEFAULT_TEXT_AREA_WIDTH = DEFAULT_TEXT_FIELD_WIDTH * 8;
}
