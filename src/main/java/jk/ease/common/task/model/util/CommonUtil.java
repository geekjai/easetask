package jk.ease.common.task.model.util;

public class CommonUtil {

	public static boolean isWindows() {

		boolean isWindows = System.getProperty("os.name").toLowerCase().startsWith("windows");
		return isWindows;
	}

}
