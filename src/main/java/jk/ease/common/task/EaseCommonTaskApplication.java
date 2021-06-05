package jk.ease.common.task;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

import jk.ease.common.task.config.StorageProperties;

@SpringBootApplication
@EnableConfigurationProperties(StorageProperties.class)
public class EaseCommonTaskApplication {

	public static void main(String[] args) {
		SpringApplication.run(EaseCommonTaskApplication.class, args);
	}

}
