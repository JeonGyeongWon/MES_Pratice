package kr.co.bps.scs.sys.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : ProdOrderExcelController.java
 * @Description : ProdOrder Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author shseo
 * @since 2018. 04.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 사용자별 사용현황
 * 
 */
@Controller
public class SysUserExcelController extends BaseController {

	@Autowired
	private SysUserService sysUserService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 사용자별 사용현황 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/sys/user/ExcelDownload.do")
	public ModelAndView UserListExcelDownload(@RequestParam HashMap<String, Object> params,
			@RequestParam Map requestMap) throws Exception {

		System.out.println("UserListExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		
		String headers = "";
		String columns = "";
		String types = "";
		String width = "";
		
		
		List<?> resultList = sysUserService.selectUserList(params);

		headers += "순번;";
		headers += "일시;";
		headers += "사용자;";
		headers += "화면명;";
		headers += "비고;";
		
		System.out.println("UserListExcelDownload 1-1. >>>>>>>>>> " + headers);
		
		columns += "RN;";
		columns += "STARTDATE;";
		columns += "USERNAME;";
		columns += "NOTE;";
		columns += "REMARK;";
		
		System.out.println("UserListExcelDownload 1-2. >>>>>>>>>> " + columns);

		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		System.out.println("UserListExcelDownload 1-3. >>>>>>>>>> " + types);
		
	
		
		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("prodOrderExcelDownload temp2. >>>>>>>>>> " + temp2);

		resultObject.put("title", temp2);
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);
		

		mav.addAllObjects(resultObject);

		return mav;
	}
}