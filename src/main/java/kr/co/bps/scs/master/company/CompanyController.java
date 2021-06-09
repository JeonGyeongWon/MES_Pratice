package kr.co.bps.scs.master.company;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.file.ExcelFileService;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : CompanyController.java
 * @Description : Company Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsmun
 * @since 2016. 12
 * @version 1.0
 * @see 공장정보
 * 
 */

@Controller
public class CompanyController extends BaseController {

	@Autowired
	private CompanyService companyService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private ExcelFileService excelFileService;

	/**
	 * Company // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/company/CompanyRegedit")
	public String showCompanyGridViewPage(@ModelAttribute("searchVO") HashMap<String, Object> searchVO, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> params)
			throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "공장 관리");
		model.addAttribute("searchVO", searchVO);

		params.putAll(super.getGridParam4paging(params));
		System.out.println("params >>>>>>>>> " + params);

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "/master/company/CompanyRegedit";
	}

	/**
	 * 공장  조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/company/CompanyRegedit.do")
	@ResponseBody
	public Object selectCompanyRegedit(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCompanyRegedit Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectCompanyRegedit Start. params>>>>>>>>>>" + params);

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(companyService.selectCompanyRegeditCount(params));
		extGrid.setData(companyService.selectCompanyRegedit(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectCompanyRegedit End. >>>>>>>>>>");
		return extGrid;
	}


	/**
	 * company // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/company/CompanyRegedit.do")
	@ResponseBody
	public Object insertCompanyRegedit(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertCompanyRegedit Start >>>>> ");
		return companyService.insertCompanyRegedit(params);
	}

	/**
	 * company // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/company/CompanyRegedit.do")
	@ResponseBody
	public Object updatetCompanyRegedit(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetCompanyRegedit >>>>>>>>>>");
		return companyService.updateCompanyRegedit(params);
	}

	/**
	 * company // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/company/CompanyRegedit.do")
	@ResponseBody
	public Object deleteCompanyRegedit(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCompanyRegedit >>>>>>>>>>");
		return companyService.deleteCompanyRegedit(params);
	}


}