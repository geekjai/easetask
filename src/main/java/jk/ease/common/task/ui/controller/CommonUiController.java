package jk.ease.common.task.ui.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jk.ease.common.task.model.constant.SystemConstant;
import jk.ease.common.task.model.service.StorageService;
import jk.ease.common.task.model.util.CommonUtil;

@Controller
public class CommonUiController {

	private final StorageService storageService;

	@Autowired
	public CommonUiController(StorageService storageService) {
		this.storageService = storageService;
	}

	@RequestMapping("/")
	public ModelAndView index() throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("index");
		return modelAndView;
	}

	@RequestMapping("/transactionAnalyser")
	public ModelAndView transactionAnalyser() throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("transactionAnalyser");
		return modelAndView;
	}

	@PostMapping("/transactionAnalyserUpload")
	public String handleFileUpload(@RequestParam("file") MultipartFile file, RedirectAttributes redirectAttributes) {

		if (CommonUtil.isWindows()) {
			storageService.store(file);
		} else {
			storageService.store(file, "TransactionAnalyser.txt");
		}

		redirectAttributes.addFlashAttribute("message",
				"You successfully uploaded " + file.getOriginalFilename() + "!");

		return "redirect:/transactionAnalyser";
	}

	@GetMapping("/serveTransactionReport")
	@ResponseBody
	public ResponseEntity<Resource> serveMegaTransReport() {

		String filename = null;
		if (CommonUtil.isWindows()) {
			filename = "D:/TransactionAnalyser.txt";
		} else {
			String fileCmdString = SystemConstant.TRANS_ANALYSER_SCRIPT + " " + SystemConstant.TRANS_LIST_FILE_NAME;
			String[] cmd = { "bash", "-c", fileCmdString };
			Process process;
			try {
				process = Runtime.getRuntime().exec(cmd);
				process.waitFor();
				filename = SystemConstant.TRAN_ANALYSER_REPORT_NAME;
			} catch (IOException e1) {

			} catch (InterruptedException e) {

			}
		}

		Resource file = storageService.loadAsResource(filename);
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
				.body(file);
	}
	
	@GetMapping("/serveTransactionBugReport")
	@ResponseBody
	public ResponseEntity<Resource> serveMegaTransBugReport() {

		String filename = null;
		if (CommonUtil.isWindows()) {
			filename = "D:/TransactionAnalyser.txt";
		} else {
			String fileCmdString = SystemConstant.BUG_ANALYSER_SCRIPT + " " + SystemConstant.TRANS_BUG_LIST_FILE_NAME;
			String[] cmd = { "bash", "-c", fileCmdString };
			Process process;
			try {
				process = Runtime.getRuntime().exec(cmd);
				process.waitFor();
				filename = SystemConstant.BUG_ANALYSER_BUG_REPORT_NAME;
			} catch (IOException e1) {

			} catch (InterruptedException e) {

			}
		}

		Resource file = storageService.loadAsResource(filename);
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
				.body(file);
	}
	
}
