package kr.co.bps.scs.master.org;

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
 * @ClassName : OrgController.java
 * @Description : Org Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsmun
 * @since 2016. 12
 * @version 1.0
 * @see 사업장정보
 * 
 */

@Controller
public class OrgController extends BaseController {

	@Autowired
	private OrgService orgService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	@Autowired
	private ExcelFileService excelFileService;

	/**
	 * Org // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/org/OrgRegedit")
	public String showOrgGridViewPage(@ModelAttribute("searchVO") HashMap<String, Object> searchVO, HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> params)
			throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "사업장 관리");
		model.addAttribute("searchVO", searchVO);

		params.putAll(super.getGridParam4paging(params));
		System.out.println("params >>>>>>>>> " + params);

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "/master/org/OrgRegedit";
	}

	/**
	 * 사업장  조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/org/OrgRegedit.do")
	@ResponseBody
	public Object selectOrgRegedit(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectOrgRegedit Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectOrgRegedit Start. params>>>>>>>>>>" + params);

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(orgService.selectOrgRegeditCount(params));
		extGrid.setData(orgService.selectOrgRegedit(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("selectOrgRegedit End. >>>>>>>>>>");
		return extGrid;
	}


	/**
	 * org // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/org/OrgRegedit.do")
	@ResponseBody
	public Object insertOrgRegedit(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertOrgRegedit Start >>>>> ");
		return orgService.insertOrgRegedit(params);
	}

	/**
	 * org // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/org/OrgRegedit.do")
	@ResponseBody
	public Object updatetOrgRegedit(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetOrgRegedit >>>>>>>>>>");
		return orgService.updateOrgRegedit(params);
	}

	/**
	 * org // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/org/OrgRegedit.do")
	@ResponseBody
	public Object deleteOrgRegedit(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteOrgRegedit >>>>>>>>>>");
		return orgService.deleteOrgRegedit(params);
	}


}