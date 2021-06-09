package kr.co.bps.scs.order.deposit;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.file.ExcelFileService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : OrderDepositExcelController.java
 * @Description : OrderDeposit Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 01.
 * @version 1.0
 * @see 출력물 (엑셀 업로드 기능 추가) - 1. 수주등록관리
 * 
 */
@Controller
public class OrderDepositExcelController extends BaseController {

	@Autowired
	private OrderDepositService orderDepositService;

	@Autowired
	private ExcelFileService excelFileService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 수금등록 업로드 // 엑셀데이터 가져오기
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/order/deposit/ExcelUpload.do")
	public String OrderDepositExcelUpload(final MultipartHttpServletRequest multiRequest) throws Exception {

		System.out.println("OrderDepositExcelUpload Start. >>>>>>>>>> " + multiRequest);
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);

		final Map<String, MultipartFile> filesmap = multiRequest.getFileMap();
		List<Object> sheet = new ArrayList<Object>();
		if (!filesmap.isEmpty()) {
			sheet = excelFileService.getExcelData(filesmap, 0, 0, 9);
			if (!sheet.isEmpty()) {
				fm.putAll(orderDepositService.uploadDepositList(sheet, "excelupload"));
			}
		}
		fm.put("isExcelUploaded", true);

		return "redirect:/order/deposit/DepositList.do";
	}

	
}