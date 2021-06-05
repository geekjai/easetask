package jk.ease.common.task.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import jk.ease.common.task.model.util.CommonUtil;

@ConfigurationProperties("storage")
public class StorageProperties {

	/**
	 * Folder location for storing files
	 */
	private final String location;

	public StorageProperties() {

		if (CommonUtil.isWindows()) {
			location = "D:/";
		} else {
			location = "/scratch/jakishan/easecommontask/storage";
		}
	}

	public String getLocation() {
		return location;
	}

}