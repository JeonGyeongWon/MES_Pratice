package kr.co.bps.scs.master.checkhistory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : CheckHistoryController.java
 * @Description : CheckHistory Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 09.
 * @version 1.0
 * @see 검사성적서 변경이력관리
 * 
 */
@Controller
public class CheckHistoryController extends BaseController {

	@Autowired
	private CheckHistoryService checkhistoryService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 검사성적서 변경이력관리 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkhistory/CheckHistoryManage.do")
	public String showCheckHistoryManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "검사성적서 변경이력 관리");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			HashMap<String, Object> params = new HashMap<String, Object>();

			// 로그인 사용자의 org company 정보 
			System.out.println("show loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("show params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("show groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("show orgid. >>>>>>>>>>" + orgid);
			System.out.println("show companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid);
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));

			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String, Object>) orgList.get(0);

			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);

			if (companyid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999);//임의의값
					params.put("COMPANYID", 999);//임의의값
				}
			} else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/checkhistory/CheckHistoryManage";
	}

	/**
	 * 변경이력관리 // Grid 데이터 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkhistory/CheckHistoryManage.do")
	@ResponseBody
	public Object selectCheckHistoryManageGrid(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selectCheckHistoryManageGrid Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String Itemcode = StringUtil.nullConvert(params.get("itemcode"));
			if (Itemcode.isEmpty()) {
				System.out.println("selectCheckHistoryManageGrid 1 >>>>>>>>> " + Itemcode);

				List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList);

				if (itemList.size() > 0) {
					System.out.println("itemList size >>>>>>>>>> " + itemList.size());
					HashMap<String, Object> itemMap = (HashMap<String, Object>) itemList.get(0);
					System.out.println("itemMap >>>>>>>>>> " + itemMap);
					if (itemMap.size() > 0) {
						params.put("orgid", itemMap.get("ORGID"));
						params.put("companyid", itemMap.get("COMPANYID"));
						params.put("itemcode", itemMap.get("ITEMCODE"));
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
			try {
				extGrid.setTotcnt(checkhistoryService.selectCheckHistoryCount(params));
				extGrid.setData(checkhistoryService.selectCheckHistoryList(params));
				//				System.out.println("Data : " + extGrid.getData());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		System.out.println("selectCheckHistoryManageGrid End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 변경이력관리 // 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/checkhistory/CheckHistoryManage.do")
	@ResponseBody
	public Object insertCheckHistoryManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertCheckHistoryManage >>>>>>>>>> " + params);
		return checkhistoryService.insertCheckHistoryManage(params);
	}

	/**
	 * 변경이력관리 // 데이터 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/checkhistory/CheckHistoryManage.do")
	@ResponseBody
	public Object updateCheckHistoryManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateCheckHistoryManage >>>>>>>>>> " + params);
		return checkhistoryService.updateCheckHistoryManage(params);
	}

	/**
	 * 변경이력관리 // 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/checkhistory/CheckHistoryManage.do")
	@ResponseBody
	public Object deleteCheckHistoryManage(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCheckHistoryManage >>>>>>>>>> " + params);
		return checkhistoryService.deleteCheckHistoryManage(params);
	}

}