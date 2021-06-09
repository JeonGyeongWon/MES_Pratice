package kr.co.bps.scs.prod.order;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.search.searchService;
import kr.co.bps.scs.util.NumberUtil;
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
 * @ClassName : ProdOrderController.java
 * @Description : ProdOrder Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 09.
 * @version 1.0
 * @see 기간별 검사현황
 * 
 */
@Controller
public class ProdOrderController extends BaseController {

	@Autowired
	private ProdOrderService prodOrderService;

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 기간별 검사현황 // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/order/WorkHistoryList.do")
	public String showWorkHistoryListPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		LoginVO loVo = super.getLoginVO();

		model.addAttribute("pageTitle", "기간별 검사현황");

		Map<String, List> labelBox = new HashMap<String, List>();
		HashMap<String, Object> params = new HashMap<String, Object>();
		try {
			// 1. 현재 일자 기준으로 1개월치 날짜 가져오기
			List dummyList = dao.selectListByIbatis("work.order.dummy.month.select", requestMap);
			Map<String, Object> dummy = (Map<String, Object>) dummyList.get(0);
			System.out.println("showWorkHistoryListPage Dummy. >>>>>>>>>>" + dummy);

			if (dummy.size() > 0) {
				// 더미 사용
				requestMap.put("dateFrom", dummy.get("YESTERDAY"));
				requestMap.put("dateTo", dummy.get("YESTERDAY"));
				requestMap.put("dateSys", dummy.get("DATESYS"));
			}

			// 로그인 사용자의 ORG Company 정보 
			System.out.println("showWorkHistoryListPage loVo.getId(). >>>>>>>>>>" + loVo.getId());
			params.put("USERID", loVo.getId());
			System.out.println("showWorkHistoryListPage params. >>>>>>>>>>" + params);
			requestMap.put("uniqId", loVo.getId());
			String groupid = searchService.selectGroupid(requestMap);
			System.out.println("showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
			requestMap.put("groupId", groupid);

			List<?> userList = dao.list("search.login.lov.select", params);
			Map<String, Object> userData = (Map<String, Object>) userList.get(0);

			// 더미 사용
			String orgid = StringUtil.nullConvert(userData.get("ORGID"));
			String companyid = StringUtil.nullConvert(userData.get("COMPANYID"));
			System.out.println("showWorkHistoryListPage orgid. >>>>>>>>>>" + orgid);
			System.out.println("showWorkHistoryListPage companyid. >>>>>>>>>>" + companyid);

			if (orgid == "") {
				if (groupid.equals("ROLE_ADMIN")) {
					System.out.println("1 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
				} else {
					System.out.println("2 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("ORGID", "");
					params.put("ORGID", 999); // 임의의 값
				}
			} else {
				System.out.println("3 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
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
					System.out.println("4 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
				} else {
					System.out.println("5 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999); // 임의의 값
					params.put("COMPANYID", 999); // 임의의 값
				}
			} else {
				System.out.println("6 showWorkHistoryListPage groupid. >>>>>>>>>>" + groupid);
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String, Object>) compList.get(0);

			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

			// 상태
			requestMap.put("CHECKYN", "");
			//			params.put("ORGID", result_org );
			//			params.put("COMPANYID", result_comp );
			//			params.put("BIGCD", "QM");
			//			params.put("MIDDLECD", "CHECK_YN");
			//params.put("GUBUN", "STATUS");

			//			labelBox.put("findByCheckyn", searchService.SmallCodeLovList(params));
			labelBox.put("findByCheckyn", dao.selectListByIbatis("work.order.checkyn.select", requestMap));

			// 검사구분
			requestMap.put("CHECKBIG", "");
			params.put("ORGID", result_org);
			params.put("COMPANYID", result_comp);
			params.put("REMARKS", "Y");

			labelBox.put("findByCheckBig", searchService.CheckBigCodeLovList(params));

			model.addAttribute("labelBox", labelBox);

			System.out.println("8. showWorkReportListPage params >>>>>>>>>>>> " + params);
			System.out.println("9. showWorkReportListPage requestMap >>>>>>>>>>>> " + requestMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		model.addAttribute("searchVO", requestMap);

		return "/prod/order/WorkHistoryList";
	}

	/**
	 * 기간별 검사현황 // 목록과 총 갯수를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/prod/order/WorkHistoryList.do")
	@ResponseBody
	public Object selectWorkHistoryList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectWorkHistoryList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if ( gubun.isEmpty() ) {

				String searchFrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
				if (searchFrom.isEmpty()) {
					count++;
				}

				String searchTo = StringUtil.nullConvert(params.get("SEARCHTO"));
				if (searchTo.isEmpty()) {
					count++;
				}
			} else {
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(prodOrderService.selectWorkHistoryCount(params));
			extGrid.setData(prodOrderService.selectWorkHistoryList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectWorkHistoryList End. >>>>>>>>>>");
		return extGrid;
	}

}