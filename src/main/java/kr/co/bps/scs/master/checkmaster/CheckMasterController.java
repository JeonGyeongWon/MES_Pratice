package kr.co.bps.scs.master.checkmaster;

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
 * @ClassName : CheckMasterController.java
 * @Description : CheckMaster Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @version 1.0
 * @see 품질기준 마스터
 * 
 */
@Controller
public class CheckMasterController extends BaseController {

	@Autowired
	private CheckMasterService checkmasterService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 품질기준 마스터 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkmaster/CheckMaster.do")
	public String showItemMasterGridViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {

		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		requestMap.put("datefrom", datefrom);

		model.addAttribute("pageTitle", "품질 기준 마스터");

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

			// 품목유형
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");
			params.put("GUBUN", "STATUS");
			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			// 기종
			requestMap.put("MODELTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "MODEL");
			params.put("GUBUN", "STATUS");

			labelBox.put("findByModelType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			String firstitemcd = StringUtil.nullConvert(checkmasterService.selectFirstItemcd(params));

			System.out.println("3-2. firstitemcd >>>>>>>>>> " + firstitemcd);

			if (!firstitemcd.isEmpty()) {
				model.addAttribute("ItemCodeVal", firstitemcd);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/master/checkmaster/CheckMaster";
	}

	/**
	 * 품질기준마스터 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkmaster/CheckMaster.do")
	@ResponseBody
	public Object selecCheckMaster(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selecCheckMaster Start. >>>>>>>>>>");
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			try {
				extGrid.setTotcnt(checkmasterService.selectItemMasterCount(params));
				extGrid.setData(checkmasterService.selectItemMasterList(params));
//				System.out.println("Data : " + extGrid.getData());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		System.out.println("selecCheckMaster End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 품질기준마스터 // 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/checkmaster/CheckMasterD.do")
	@ResponseBody
	public Object selecCheckMasterD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("selecCheckMasterD Start. >>>>>>>>>>" + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String Itemcode = StringUtil.nullConvert(params.get("itemcode"));
			if ( Itemcode.isEmpty() ) {
				System.out.println("selecCheckMasterD 1 >>>>>>>>> " + Itemcode);
				
				List<?> itemList = dao.list("checkmaster.first.select", params);
				System.out.println("itemList >>>>>>>>>> " + itemList);
				
				if ( itemList.size() > 0 ) {
					System.out.println("itemList size >>>>>>>>>> " + itemList.size() );
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

		// detail 부분의 조회를 최초에는 실행x, master 클릭시 조회.
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(checkmasterService.selectCheckMasterCount(params));
			extGrid.setData(checkmasterService.selectCheckMasterList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selecCheckMasterD End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 검사기준정보 // 데이터 삽입
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/checkmaster/CheckMasterD.do")
	@ResponseBody
	public Object insertCheckMasterD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertCheckMasterD >>>>>>>>>> " + params);
		return checkmasterService.insertCheckMasterD(params);
	}

	/**
	 * 검사기준정보 // 수정
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/checkmaster/CheckMasterD.do")
	@ResponseBody
	public Object updateCheckMasterD(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateCheckMasterD >>>>>>>>>> " + params);
		return checkmasterService.updateCheckMasterD(params);
	}

	/**
	 * 검사기준정보 // 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/checkmaster/CheckMasterD.do")
	@ResponseBody
	public Object deleteCheckMasterD(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCheckMasterD >>>>>>>>>> " + params);
		return checkmasterService.deleteCheckMasterD(params);
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 검사기준정보POPUP // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkmaster/CheckmasterPop.do")
	@ResponseBody
	public Object CheckmasterPop(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("CheckmasterPop Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
			//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			//			if (groupcode.isEmpty()) {
			//				count++;
			//			}
			//
			//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			//			if (bigcode.isEmpty()) {
			//				count++;
			//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(checkmasterService.CheckmasterPopTotCnt(params));
			extGrid.setData(checkmasterService.CheckmasterPopList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("CheckmasterPop End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 아이템별 품질 기준 마스터 // POPUP LIST 를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/checkmaster/CheckmasterPopCheck.do")
	@ResponseBody
	public Object CheckmasterPopCheck(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("CheckmasterPopCheck Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
			//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			//			if (groupcode.isEmpty()) {
			//				count++;
			//			}
			//
			//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			//			if (bigcode.isEmpty()) {
			//				count++;
			//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(checkmasterService.CheckmasterPopCheckTotCnt(params));
			extGrid.setData(checkmasterService.CheckmasterPopCheckList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("CheckmasterPopCheck End. >>>>>>>>>>");
		return extGrid;
	}
}