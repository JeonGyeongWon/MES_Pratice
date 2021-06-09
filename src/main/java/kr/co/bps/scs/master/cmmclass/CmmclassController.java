package kr.co.bps.scs.master.cmmclass;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

/**
 * @ClassName : CmmclassController.java
 * @Description : Cmmclass Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsmun, ymha
 * @since    2016. 01
 * @modify 2018. 06
 * @version 1.0
 * @see 기준정보
 * 
 */

@Controller
public class CmmclassController extends BaseController {

	@Autowired
	private CmmclassService cmmclassService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 공통코드 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/cmmclass/Cmmcode.do")
	public String showCmmclassGridViewPage(@ModelAttribute("searchVO") HashMap<String, Object> searchVO,
			HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> params) throws Exception {

		LoginVO loVo = super.getLoginVO();
		model.addAttribute("pageTitle", "공통코드 관리");
		model.addAttribute("searchVO", searchVO);

		params.putAll(super.getGridParam4paging(params));
		System.out.println("params >>>>>>>>> " + params);

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 로그인 사용자의 org company 정보
			System.out.println("showCmmclassGridViewPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showCmmclassGridViewPage params. >>>>>>>>>>" + params);
			params.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(params);
			System.out.println("showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
			params.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showCmmclassGridViewPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showCmmclassGridViewPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					params.put("ORGID", "");
				} else {
					System.out.println("2 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					params.put("ORGID", "");
					params.put("ORGID", 999); // 임의의값
				}
			} else {
				System.out.println("3 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
				params.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					params.put("COMPANYID", "");
				} else {
					System.out.println("5 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
					params.put("COMPANYID", "");
					params.put("ORGID", 999);
					params.put("COMPANYID", 999);
				}
			} else {
				System.out.println("6 showCmmclassGridViewPage groupid. >>>>>>>>>>" + groupid);
				params.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			model.addAttribute("labelBox", labelBox);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", params);

		return "/master/cmmclass/CmmclassList";
	}

	/**
	 * Bigclass // 대분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cmmclass/CmmbigclassList.do")
	@ResponseBody
	public Object selectCmmbigclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap)
			throws Exception {

		System.out.println("selectCmmbigclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(cmmclassService.selectCmmbigclassListCount(params));
		extGrid.setData(cmmclassService.selectCmmbigclassList(params));
		// System.out.println("Data : " + extGrid.getData());

		System.out.println("selectCmmbigclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Middleclass // 중분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cmmclass/CmmmiddleclassList.do")
	@ResponseBody
	public Object selectCmmmiddleclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap)
			throws Exception {

		params.putAll(super.getGridParam4paging(params));
		System.out.println("selectCmmmiddleclassList Start >>>>>>>>> " + params);
		int count = 0;
		try {
			// String orgid = StringUtil.nullConvert(params.get("ORGID"));
			// String companyid =
			// StringUtil.nullConvert(params.get("COMPANYID"));
			String bigcd = StringUtil.nullConvert(params.get("bigcd"));
			if (!bigcd.isEmpty()) {
				System.out.println("selectCmmmiddleclassList bigcd >>>>>>>>>> " + bigcd);
			} else {
				// 대분류 코드 가져오는 부분
				List<?> codeList = dao.list("cmmclass.first.select", params);
				System.out.println("codeList >>>>>>>>>> " + codeList);
				
				if ( codeList.size() > 0 ) {
					HashMap<String, Object> codeMap = (HashMap<String, Object>) codeList.get(0);
					System.out.println("codeMap >>>>>>>>>> " + codeMap);
					if (codeMap.size() > 0) {
						params.put("orgid", codeMap.get("ORGID"));
						params.put("companyid", codeMap.get("COMPANYID"));
						params.put("bigcd", codeMap.get("BIGCD"));
					} else {
						count++;
					}
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(cmmclassService.selectCmmmiddleclassListCount(params));
			extGrid.setData(cmmclassService.selectCmmmiddleclassList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCmmmiddleclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Smallclass // 소분류 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/cmmclass/CmmsmallclassList.do")
	@ResponseBody
	public Object selectCmmsmallclassList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap)
			throws Exception {

		System.out.println("selectCmmsmallclassList Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcd = StringUtil.nullConvert(params.get("bigcd"));
			if (!bigcd.isEmpty()) {
				System.out.println("selectCmmsmallclassList bigcd >>>>>>>>>> " + bigcd);
			} else {
				// 대분류 코드 가져오는 부분
				List<?> codeList = dao.list("cmmclass.first.select", params);
				System.out.println("codeList >>>>>>>>>> " + codeList);
				
				if ( codeList.size() > 0 ) {
					HashMap<String, Object> codeMap = (HashMap<String, Object>) codeList.get(0);
					System.out.println("codeMap >>>>>>>>>> " + codeMap);
					if (codeMap.size() > 0) {
						params.put("orgid", codeMap.get("ORGID"));
						params.put("companyid", codeMap.get("COMPANYID"));
						params.put("bigcd", codeMap.get("BIGCD"));
					} else {
						count++;
					}
				} else {
					count++;
				}
			}
			
			String middlecd = StringUtil.nullConvert(params.get("middlecd"));
			if (!middlecd.isEmpty()) {
				System.out.println("selectCmmsmallclassList middlecd >>>>>>>>>> " + middlecd);
			} else {
				// 중분류 코드 가져오는 부분
				List<?> codeList = dao.list("cmmclass.mfirst.select", params);
				System.out.println("codeList >>>>>>>>>> " + codeList);
				
				if ( codeList.size() > 0 ) {
					HashMap<String, Object> codeMap = (HashMap<String, Object>) codeList.get(0);
					System.out.println("codeMap >>>>>>>>>> " + codeMap);
					if (codeMap.size() > 0) {
						params.put("middlecd", codeMap.get("MIDDLECD"));
					} else {
						count++;
					}
				} else {
					count++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(cmmclassService.selectCmmsmallclassListCount(params));
			extGrid.setData(cmmclassService.selectCmmsmallclassList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCmmsmallclassList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Bigclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/cmmclass/CmmbigclassList.do")
	@ResponseBody
	public Object insertCmmBigclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertCmmBigclass Start >>>>> ");
		return cmmclassService.insertCmmBigClass(params);
	}

	/**
	 * Bigclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/cmmclass/CmmbigclassList.do")
	@ResponseBody
	public Object updatetCmmBigclass(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updatetCmmBigclass >>>>>>>>>>");
		return cmmclassService.updateCmmBigclass(params);
	}

	/**
	 * Bigclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/cmmclass/CmmbigclassList.do")
	@ResponseBody
	public Object deleteCmmBigclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCmmBigclass >>>>>>>>>>");
		return cmmclassService.deleteCmmBigclass(params);
	}

	/**
	 * Middleclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/cmmclass/CmmmiddleclassList.do")
	@ResponseBody
	public Object insertCmmMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return cmmclassService.insertCmmMiddleclass(params);
	}

	/**
	 * Middleclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/cmmclass/CmmmiddleclassList.do")
	@ResponseBody
	public Object updatetCmmMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return cmmclassService.updateCmmMiddleclass(params);
	}

	/**
	 * Middleclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/cmmclass/CmmmiddleclassList.do")
	@ResponseBody
	public Object deleteCmmMiddleclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCmmMiddleclass >>>>>>>>>>");
		return cmmclassService.deleteCmmMiddleclass(params);
	}

	/**
	 * Smallclass // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/cmmclass/CmmsmallclassList.do")
	@ResponseBody
	public Object insertCmmSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return cmmclassService.insertCmmSmallclass(params);
	}

	/**
	 * Smallclass // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/cmmclass/CmmsmallclassList.do")
	@ResponseBody
	public Object updatetCmmSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {

		return cmmclassService.updateCmmSmallclass(params);
	}

	/**
	 * Smallclass // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/cmmclass/CmmsmallclassList.do")
	@ResponseBody
	public Object deleteCmmSmallclass(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCmmSmallclass >>>>>>>>>>");
		return cmmclassService.deleteCmmSmallclass(params);
	}
}