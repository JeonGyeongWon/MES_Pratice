package kr.co.bps.scs.purchase.confirm;

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
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : PurchaseConfirmController.java
 * @Description : PurchaseConfirm Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 02.
 * @version 1.0
 * @see 매입확정
 * 
 */
@Controller
public class PurchaseConfirmController extends BaseController {

	@Autowired
	private PurchaseConfirmService purchaseConfirmService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 매입확정
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/purchase/confirm/PurchaseConfirmRegist.do")
	public String showPurchaseConfirmRegistPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();
		System.out.println("loginVO.getId() >>>>>>>>>>" + loVo.getId());

		model.addAttribute("pageTitle", "매입확정");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("dist.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showPurchaseConfirmRegistPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("DATEFROM"));
				requestMap.put("dateTo", dummy.get("DATETO"));
				requestMap.put("predateSys", dummy.get("PREDATESYS"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
				requestMap.put("predateFrom", dummy.get("PREDATEFROM"));
				requestMap.put("predateTo", dummy.get("PREDATETO"));
				requestMap.put("postdateFrom", dummy.get("POSTDATEFROM"));
				requestMap.put("postdateTo", dummy.get("POSTDATETO"));
			}

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
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				} else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); //임의의값
				}
			} else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				// org
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
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				} else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
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
			
			// 유형
			requestMap.put("ITEMTYPE", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("BIGCD", "CMM");
			params.put("MIDDLECD", "ITEM_TYPE");

			labelBox.put("findByItemType", searchService.SmallCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		return "/purchase/confirm/PurchaseConfirmRegist";
	}

	/**
	 * 매입확정 // Grid 데이터 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/purchase/confirm/PurchaseConfirmRegist.do")
	@ResponseBody
	public Object selectPurchaseConfirmRegistGrid(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("selectPurchaseConfirmRegistGrid Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String pofrom = StringUtil.nullConvert(params.get("TRANSFROM"));
			if (pofrom.isEmpty()) {
				count++;
			}

			String poto = StringUtil.nullConvert(params.get("TRANSTO"));
			if (poto.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			// 필수 값을 입력을 했을 경우 데이터 조회
			extGrid.setTotcnt(purchaseConfirmService.selectPurchaseConfirmCount(params));
			extGrid.setData(purchaseConfirmService.selectPurchaseConfirmList(params));
			//						System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectPurchaseConfirmRegistGrid End. >>>>>>>>>> ");
		return extGrid;
	}

	/**
	 * 매입확정 // 확정 / 취소
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/appr/purchase/confirm/PurchaseConfirmRegist.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object apprPurchaseConfirm(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("apprPurchaseConfirm Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = purchaseConfirmService.apprPurchaseConfirm(params);
			System.out.println("apprPurchaseConfirm result >>>>>>>>> " + result);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

}