package kr.co.bps.scs.search;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.base.vo.ExtGridVO;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : SearchController.java
 * @Description : Search Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 12.
 * @version 1.0
 * @see 그리드 LOV 검색용
 * 
 */

@Controller
public class searchController extends BaseController {

	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * Org // 사업장 정보 list
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchOrgLov.do")
	@ResponseBody
	public Object searchOrgLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchOrgLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.OrgLovTotCnt(params));
			extGrid.setData(searchService.OrgLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchOrgLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * Company // 공장 정보 list
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCompanyLov.do")
	@ResponseBody
	public Object searchCompanyLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCompanyLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.CompanyLovTotCnt(params));
			extGrid.setData(searchService.CompanyLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCompanyLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.11.30 ITEMCODE, ITEMNAME // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchItemNameLov.do")
	@ResponseBody
	public Object searchItemNameLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchItemNameLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.ItemNameLovTotCnt(params));
			extGrid.setData(searchService.ItemNameLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchItemNameLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.11.30 WorkNO // 작업지시투입관리 화면에서 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkNoListLov.do")
	@ResponseBody
	public Object searchWorkNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.WorkNoLovTotCnt(params));
			extGrid.setData(searchService.WorkNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchWorkNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.01 routing // 작업지시투입관리 화면에서 공정명 등록 항목 LOV를 호출한다. routing // 해당 품목에 물려있는 공정 표시
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchRoutingItemLov.do")
	@ResponseBody
	public Object searchRoutingItemLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchRoutingItemLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.RoutingItemLovTotCnt(params));
			extGrid.setData(searchService.RoutingItemLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchRoutingItemLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.01 routing // 작업지시투입관리 화면에서 설비명 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkCenterLov.do")
	@ResponseBody
	public Object searchWorkCenterLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkCenterLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.WorkCenterLovTotCnt(params));
		extGrid.setData(searchService.WorkCenterLovList(params));
//		System.out.println("Data : " + extGrid.getData());

		System.out.println("searchWorkCenterLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.01 routing // 작업지시투입관리 화면에서 공정별 설비명 등록 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchEquipmentLov.do")
	@ResponseBody
	public Object searchEquipmentLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchEquipmentLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}

			String routingid = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingid.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.EquipmentLovTotCnt(params));
			extGrid.setData(searchService.EquipmentLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchEquipmentLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2016.12.16 ITEMCODE, ITEMNAME ,ORDERNAME , ITEMTYPE// POPUP ITEM LOV를
	 * 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchItemCodeOrderLov.do")
	@ResponseBody
	public Object searchItemCodeOrderLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchItemCodeOrderLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			// 필수 조건 미입력시 제약
//			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
//			if (groupcode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.ItemCodeOrderLovTotCnt(params));
			extGrid.setData(searchService.ItemCodeOrderLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchItemCodeOrderLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * SMALL_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchSmallCodeListLov.do")
	@ResponseBody
	public Object searchSmallCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSmallCodeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
//			String orgid = StringUtil.nullConvert(params.get("ORGID"));
//			if (orgid.isEmpty()) {
//				count++;
//			}
//
//			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
//			if (companyid.isEmpty()) {
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
			extGrid.setTotcnt(searchService.SmallCodeLovTotCnt(params));
			extGrid.setData(searchService.SmallCodeLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchSmallCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * MIDDLE_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMiddleCodeListLov.do")
	@ResponseBody
	public Object searchMiddleCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMiddleCodeListLov Start. >>>>>>>>>> " + params);
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.MiddleCodeLovTotCnt(params));
			extGrid.setData(searchService.MiddleCodeLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchMiddleCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * BIG_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchBigCodeListLov.do")
	@ResponseBody
	public Object searchBigCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchBigCodeListLov Start. >>>>>>>>>> " + params);
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
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.BigCodeLovTotCnt(params));
			extGrid.setData(searchService.BigCodeLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchBigCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * CHECK BIG_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckBigCodeListLov.do")
	@ResponseBody
	public Object searchCheckBigCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckBigCodeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.CheckBigCodeLovTotCnt(params));
		extGrid.setData(searchService.CheckBigCodeLovList(params));
//		System.out.println("Data : " + extGrid.getData());

		System.out.println("searchCheckBigCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * CHECK MIDDLE_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckMiddleCodeListLov.do")
	@ResponseBody
	public Object searchCheckMiddleCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckMiddleCodeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.CheckMiddleCodeLovTotCnt(params));
		extGrid.setData(searchService.CheckMiddleCodeLovList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("searchCheckMiddleCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * CHECK SMALL_CODE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckSmallCodeListLov.do")
	@ResponseBody
	public Object searchCheckSmallCodeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckSmallCodeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		System.out.println("params >>>>>>>>> " + params);
		try {
			//			String bigcd = StringUtil.nullConvert(params.get("BIGCD"));
			//			if (bigcd.isEmpty()) {
			//				count++;
			//			}
			//
			//			String middlecd = StringUtil.nullConvert(params.get("MIDDLECD"));
			//			if (middlecd.isEmpty()) {
			//				count++;
			//			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			// 처음 화면을 조회할 때
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.CheckSmallCodeLovTotCnt(params));
			extGrid.setData(searchService.CheckSmallCodeLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCheckSmallCodeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * DUMMY Y / N // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDummyYNLov.do")
	@ResponseBody
	public Object searchDummyYNLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchDummyYNLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String param1 = StringUtil.nullConvert(params.get("PARAM1"));
			if (param1.isEmpty()) {
				count++;
			}

			//			String param2 = StringUtil.nullConvert(params.get("PARAM2"));
			//			if (param2.isEmpty()) {
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
			extGrid.setTotcnt(searchService.DummyYNLovTotCnt(params));
			extGrid.setData(searchService.DummyYNLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDummyOKNGLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * DUMMY OK / NG // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDummyOKNG2Lov.do")
	@ResponseBody
	public Object searchDummyOKNG2Lov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchDummyOKNG2Lov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String param1 = StringUtil.nullConvert(params.get("PARAM1"));
			if (param1.isEmpty()) {
				count++;
			}

			//			String param2 = StringUtil.nullConvert(params.get("PARAM2"));
			//			if (param2.isEmpty()) {
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
			extGrid.setTotcnt(searchService.DummyOKNG2LovTotCnt(params));
			extGrid.setData(searchService.DummyOKNG2LovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDummyOKNG2Lov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * DUMMY OK / NG // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDummyOKNGLov.do")
	@ResponseBody
	public Object searchDummyOKNGLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchDummyOKNGLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String bigcd = StringUtil.nullConvert(params.get("BIGCD"));
			if (!bigcd.isEmpty()) {
				System.out.println("1 >>>>>>>>>>>> ");
			} else {
				count++;
			}

			String checkinterval = StringUtil.nullConvert(params.get("CHECKINTERVAL"));
			if ( checkinterval.isEmpty() ) {
				String middlecd = StringUtil.nullConvert(params.get("MIDDLECD"));
				if (!middlecd.isEmpty()) {
					System.out.println("2 >>>>>>>>>>>> ");
					if (middlecd.equals("!@#$%")) {
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
			String checkinterval = StringUtil.nullConvert(params.get("CHECKINTERVAL"));
			if ( checkinterval.isEmpty() ) {
				extGrid.setTotcnt(searchService.DummyOKNGLovTotCnt(params));
				extGrid.setData(searchService.DummyOKNGLovList(params));
				System.out.println("1 : " + extGrid.getData());
			} else {
				extGrid.setTotcnt(searchService.DummyNumberLovTotCnt(params));
				extGrid.setData(searchService.DummyNumberLovList(params));
				System.out.println("2 : " + extGrid.getData());
			}
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDummyOKNGLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * CUSTOMER // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCustomernameLov.do")
	@ResponseBody
	public Object searchCustomernameLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCustomernameLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.CustomernameLovTotCnt(params));
		extGrid.setData(searchService.CustomerLovList(params));
//		System.out.println("Data : " + extGrid.getData());

		System.out.println("searchCustomernameLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * CUSTOMER // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCustomerMemberLov.do")
	@ResponseBody
	public Object searchCustomerMemberLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCustomerMemberLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}
			
			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			if (customercode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.CustomerMemberLovTotCnt(params));
			extGrid.setData(searchService.CustomerMemberLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCustomerMemberLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * HUMANRESOURCE // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkerLov.do")
	@ResponseBody
	public Object searchWorkerLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkerLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.WorkerLovTotCnt(params));
		extGrid.setData(searchService.WorkerLovList(params));
//		System.out.println("Data : " + extGrid.getData());

		System.out.println("searchWorkerLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 설비 연결 > 사원 조회 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkerEquipLov.do")
	@ResponseBody
	public Object searchWorkerEquipLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkerEquipLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
//			String inspectiontype = StringUtil.nullConvert(params.get("INSPECTORTYPE"));
//			if (inspectiontype.isEmpty()) {
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
			extGrid.setTotcnt(searchService.WorkerEquipLovTotCnt(params));
			extGrid.setData(searchService.WorkerEquipLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchWorkerEquipLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 설비 연결 > 사원 조회 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkerPCListLov.do")
	@ResponseBody
	public Object searchWorkerPCListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkerPCListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if ( orgid.isEmpty() ) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if ( companyid.isEmpty() ) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();
		
		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchWorkerPCTotCnt(params));
			extGrid.setData(searchService.searchWorkerPCList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchWorkerPCListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * SMALL_CLASS // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchSmallClassListLov.do")
	@ResponseBody
	public Object searchSmallClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSmallClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			if (groupcode.isEmpty()) {
				count++;
			}

			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			if (bigcode.isEmpty()) {
				count++;
			}

			String middlecode = StringUtil.nullConvert(params.get("MIDDLECODE"));
			if (middlecode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.SmallClassLovTotCnt(params));
			extGrid.setData(searchService.SmallClassLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchSmallClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 소분류 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDistinctSmallClassListLov.do")
	@ResponseBody
	public Object searchDistinctSmallClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSmallClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			if (groupcode.isEmpty()) {
				count++;
			}

//			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
//			if (bigcode.isEmpty()) {
//				count++;
//			}
//
//			String middlecode = StringUtil.nullConvert(params.get("MIDDLECODE"));
//			if (middlecode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.SmallClassDistinctLovTotCnt(params));
			extGrid.setData(searchService.SmallClassDistinctLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDistinctSmallClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * MIDDLE_CLASS // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMiddleClassListLov.do")
	@ResponseBody
	public Object searchMiddleClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMiddleClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			if (groupcode.isEmpty()) {
				count++;
			}

			String bigcode = StringUtil.nullConvert(params.get("BIGCODE"));
			if (bigcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.MiddleClassLovTotCnt(params));
			extGrid.setData(searchService.MiddleClassLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchMiddleClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 중분류 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDistinctMiddleClassListLov.do")
	@ResponseBody
	public Object searchDistinctMiddleClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchDistinctMiddleClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			if (groupcode.isEmpty()) {
				count++;
			}

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
			extGrid.setTotcnt(searchService.MiddleClassDistinctLovTotCnt(params));
			extGrid.setData(searchService.MiddleClassDistinctLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDistinctMiddleClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * BIG_CLASS // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchBigClassListLov.do")
	@ResponseBody
	public Object searchBigClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchBigClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.isEmpty()) {
				String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
				if (groupcode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.BigClassLovTotCnt(params));
			extGrid.setData(searchService.BigClassLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchBigClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 대분류 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchDistinctBigClassListLov.do")
	@ResponseBody
	public Object searchDistinctBigClassListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchDistinctBigClassListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String groupcode = StringUtil.nullConvert(params.get("GROUPCODE"));
			if (groupcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.BigClassDistinctLovTotCnt(params));
			extGrid.setData(searchService.BigClassDistinctLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchDistinctBigClassListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * PORNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchPorNoListLov.do")
	@ResponseBody
	public Object searchPorNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchPorNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.PorNoLovTotCnt(params));
			extGrid.setData(searchService.PorNoLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchPorNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * PORNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchTransNoListLov.do")
	@ResponseBody
	public Object searchTransNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchTransNoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			//			String transdate = StringUtil.nullConvert(params.get("TRANSDATE"));
			//			if (transdate.isEmpty()) {
			//				count++;
			//			}
			//
			//			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			//			if (customercode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.TransNoLovTotCnt(params));
			extGrid.setData(searchService.TransNoLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchTransNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * TRANSNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchTransNoListLov2.do")
	@ResponseBody
	public Object searchTransNoListLov2(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchTransNoListLov2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String transfrom = StringUtil.nullConvert(params.get("TRANSFROM"));
			if (transfrom.isEmpty()) {
				count++;
			}

			String transto = StringUtil.nullConvert(params.get("TRANSTO"));
			if (transto.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.TransNoLovTotCnt2(params));
			extGrid.setData(searchService.TransNoLovList2(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchTransNoListLov2 End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * PONO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchPonoListLov.do")
	@ResponseBody
	public Object searchPonoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchPonoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if (gubun.equals("LIST")) {
				String pofrom = StringUtil.nullConvert(params.get("POFROM"));
				if (pofrom.isEmpty()) {
					count++;
				}

				String poto = StringUtil.nullConvert(params.get("POTO"));
				if (poto.isEmpty()) {
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
			extGrid.setTotcnt(searchService.PonoLovTotCnt(params));
			extGrid.setData(searchService.PonoLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchPonoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * REQUSETNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchReqNoListLov.do")
	@ResponseBody
	public Object searchReqNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchReqNoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String requestfromdate = StringUtil.nullConvert(params.get("REQFROM"));
			if (requestfromdate.isEmpty()) {
				count++;
			}
			String requesttodate = StringUtil.nullConvert(params.get("REQTO"));
			if (requesttodate.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.ReqNoLovTotCnt(params));
			extGrid.setData(searchService.ReqNoLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchReqNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * SHIPNO // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchShipnoListLov.do")
	@ResponseBody
	public Object searchShipnoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShipnoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
			if (customercode.isEmpty()) {
				count++;
			}

			String shipdate = StringUtil.nullConvert(params.get("SHIPDATE"));
			if (shipdate.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.ShipnoLovTotCnt(params));
			extGrid.setData(searchService.ShipnoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchShipnoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 입고현황 팝업 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWarehousingListLov.do")
	@ResponseBody
	public Object searchWarehousingListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWarehousingListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String warefrom = StringUtil.nullConvert(params.get("WAREFROM"));
			if (warefrom.isEmpty()) {
				count++;
			}
			String wareto = StringUtil.nullConvert(params.get("WARETO"));
			if (wareto.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.WarehousingLovTotCnt(params));
			extGrid.setData(searchService.WarehousingLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchWarehousingListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * RELNO (이동, 기타입) 출고번호 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchRelNoListLov.do")
	@ResponseBody
	public Object searchRelNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchRelNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.RelNoLovTotCnt(params));
			extGrid.setData(searchService.RelNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchRelNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * RELNO 제품 입출고번호 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchProdRelNoListLov.do")
	@ResponseBody
	public Object searchProdRelNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchProdRelNoListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.selectProdRelNoLovTotCnt(params));
			extGrid.setData(searchService.selectProdRelNoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchProdRelNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 2017.01.20 출고요청 테이블에서 작업지시번호를 호출 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchRelNoListLov2.do")
	@ResponseBody
	public Object searchRelNoListLov2(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchRelNoListLov2 Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.RelNoLovTotCnt2(params));
			extGrid.setData(searchService.RelNoLovList2(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchRelNoListLov2 End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * ITEMCODE, ITEMNAME ,ORDERNAME , ITEMTYPE // POPUP ITEM LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchBarCodeOrderLov.do")
	@ResponseBody
	public Object searchBarCodeOrderLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchBarCodeOrderLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.BarCodeOrderLovTotCnt(params));
			extGrid.setData(searchService.BarCodeOrderLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchBarCodeOrderLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 검사기준정보 // LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckMasterListLov.do")
	@ResponseBody
	public Object searchCheckMasterListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckMasterListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.CheckMasterLovTotCnt(params));
			extGrid.setData(searchService.CheckMasterLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCheckMasterListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구명 // 조회 항목 LOV를 호출한다. ( 공구 변경점 등록 화면에서 사용 )
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchToolNameListLov.do")
	@ResponseBody
	public Object searchToolNameListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchToolNameListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if ( gubun.equals("REGIST") ) {
				// 공구 변경점 등록 화면에서 사용
				String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
				if (workcentercode.isEmpty()) {
					count++;
				}
			} else if ( gubun.equals("MANAGE") ) {
				// 공구변경 현황관리 화면에서 사용
				String routingid = StringUtil.nullConvert(params.get("ROUTINGID"));
				if (routingid.isEmpty()) {
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
			extGrid.setTotcnt(searchService.ToolNameLovTotCnt(params));
			extGrid.setData(searchService.ToolNameLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchToolNameListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구명 // 조회 항목 LOV를 호출한다. ( 공구 변경 현황관리 화면에서 사용 )
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchToolChangeNameListLov.do")
	@ResponseBody
	public Object searchToolChangeNameListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchToolChangeNameListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String routingid = StringUtil.nullConvert(params.get("ROUTINGID"));
			if (routingid.isEmpty()) {
				count++;
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.ToolChangeNameLovTotCnt(params));
			extGrid.setData(searchService.ToolChangeNameLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchToolChangeNameListLov End. >>>>>>>>>>");
		return extGrid;
	}
	

	/**
	 * LOT 이력 관리 조회용 // LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchHistoryLotNoListLov.do")
	@ResponseBody
	public Object searchHistoryLotNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchHistoryLotNoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.HistoryLotNoTotCnt(params));
			extGrid.setData(searchService.HistoryLotNoList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchHistoryLotNoListLov End. >>>>>>>>>>");
		return extGrid;
	}
	

	/**
	 * 제품 LOV // LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchOrderItemLovList.do")
	@ResponseBody
	public Object searchOrderItemLovListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchOrderItemLovListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchOrderItemLovTotCnt(params));
			extGrid.setData(searchService.searchOrderItemLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchOrderItemLovListLov End. >>>>>>>>>>");
		return extGrid;
	}
	

	/**
	 * 출하등록 // 수주현황 PopUp항목을 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchShipRegistManagePopupList.do")
	@ResponseBody
	public Object searchShipRegistManagePopupList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShipRegistManagePopupList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchShipRegistManagePopupTotCnt(params));
			extGrid.setData(searchService.searchShipRegistManagePopupList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchShipRegistManagePopupList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 출하등록 // 출하현황 PopUp항목을 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchShipRegistManagePopup2List.do")
	@ResponseBody
	public Object searchShipRegistManagePopup2List(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShipRegistManagePopup2List Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchShipRegistManagePopup2TotCnt(params));
			extGrid.setData(searchService.searchShipRegistManagePopup2List(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchShipRegistManagePopup2List End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 수주관리 //수주번호 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchSoNoFindLovList.do")
	@ResponseBody
	public Object searchSoNoFindLovList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSoNoFindLovList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchSoNoFindLovTotCnt(params));
			extGrid.setData(searchService.searchSoNoFindLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchSoNoFindLovList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 출하등록 // 출하번호 LOV항목을 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchShipNoFindLovList.do")
	@ResponseBody
	public Object searchShipNoFindLovList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShipNoLovList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchShipNoLovTotCnt(params));
			extGrid.setData(searchService.searchShipNoLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchShipNoLovList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 자주검사/공정순회검사 결과조회 POPUP // 결과조회 LOV항목을 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckResultPopupList.do")
	@ResponseBody
	public Object searchCheckResultPopupList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckResultPopupList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
				count++;
			}

			String workorderseq = StringUtil.nullConvert(params.get("WORKORDERSEQ"));
			if (workorderseq.isEmpty()) {
				count++;
			}

			String fmltype = StringUtil.nullConvert(params.get("FMLTYPE"));
			if (fmltype.isEmpty()) {
				count++;
			}

			String type = StringUtil.nullConvert(params.get("TYPE"));
			switch (type) {
			case "4":
				// 4. 자주 검사
				params.put("CHECKBIG", "F");
				break;
			case "6":
				// 6. 공정순회 검사
				params.put("CHECKBIG", "H");
				break;
			default:
				params.put("CHECKBIG", "F");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchCheckResultPopupTotCnt(params));
			extGrid.setData(searchService.searchCheckResultPopupList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCheckResultPopupList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공정순회검사 결과조회 POPUP // 결과조회 LOV항목을 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchCheckResultPopupList2.do")
	@ResponseBody
	public Object searchCheckResultPopupList2(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchCheckResultPopupList2 Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String workorderid = StringUtil.nullConvert(params.get("WORKORDERID"));
			if (workorderid.isEmpty()) {
				count++;
			}

			String workorderseq = StringUtil.nullConvert(params.get("WORKORDERSEQ"));
			if (workorderseq.isEmpty()) {
				count++;
			}

//			String fmltype = StringUtil.nullConvert(params.get("FMLTYPE"));
//			if (fmltype.isEmpty()) {
//				count++;
//			}

			String type = StringUtil.nullConvert(params.get("TYPE"));
			switch (type) {
			case "4":
				// 4. 자주 검사
				params.put("CHECKBIG", "H");
				break;
			default:
				params.put("CHECKBIG", "H");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchCheckResultPopup2TotCnt(params));
			extGrid.setData(searchService.searchCheckResultPopup2List(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchCheckResultPopupList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 거래명세서의 거래명세서 번호 Lov // Lov를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchTransnoLovList.do")
	@ResponseBody
	public Object searchTransnoLovList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchTransnoLovList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.TransnoLovTotcnt(params));
			extGrid.setData(searchService.TransnoLovList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchTransnoLovList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 거래명세서의 출하현황PopupList // PopupList를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchTransShippingPopupList.do")
	@ResponseBody
	public Object searchTransShippingPopupList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchTransShippingPopupList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.TransShippingPopupTotcnt(params));
			extGrid.setData(searchService.TransShippingPopupList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchTransShippingPopupList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 거래명세서의 수주현황PopupList // PopupList를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchSalesShippingPopupList.do")
	@ResponseBody
	public Object searchSalesShippingPopupList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSalesShippingPopupList Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.TransSalesPopupTotcnt(params));
			extGrid.setData(searchService.TransSalesPopupList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchSalesShippingPopupList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 작업지시등록 > 작업자 투입/철수 관리 > 철수시간 선택시 설비 I/F 데이터 가공 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkerInterfaceLov.do")
	@ResponseBody
	public Object searchWorkerInterfaceLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkerInterfaceLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String starttime = StringUtil.nullConvert(params.get("STARTTIME"));
			if (starttime.isEmpty()) {
				count++;
			}

			String endtime = StringUtil.nullConvert(params.get("ENDTIME"));
			if (endtime.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.WorkerInterfaceTotCnt(params));
			extGrid.setData(searchService.WorkerInterfaceList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchWorkerInterfaceLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 월별 생산실적현황 (작업자) // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMonthlyWorkerListLov.do")
	@ResponseBody
	public Object searchMonthlyWorkerListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMonthlyWorkerListLov Start. >>>>>>>>>> " + params);
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

			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchMonthlyWorkerTotCnt(params));
			extGrid.setData(searchService.searchMonthlyWorkerList(params));
			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchMonthlyWorkerListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 월별 생산실적현황 (장비별) // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMonthlyEquipListLov.do")
	@ResponseBody
	public Object searchMonthlyEquipListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMonthlyWorkerListLov Start. >>>>>>>>>> " + params);
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

			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			String gubun = StringUtil.nullConvert(params.get("GUBUN"));
			if ( gubun.equals("WORKCENTER")) {

				extGrid.setTotcnt(searchService.searchMonthlyEquipTotCnt(params));
				extGrid.setData(searchService.searchMonthlyEquipList(params));	
			} else if ( gubun.equals("WORKDEPT")) {

				extGrid.setTotcnt(searchService.searchMonthlyWorkDeptTotCnt(params));
				extGrid.setData(searchService.searchMonthlyWorkDeptList(params));
			}
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchMonthlyEquipListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 라우팅 복사 lov // LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchRoutingCopyListLov.do")
	@ResponseBody
	public Object searchRoutingCopyListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchRoutingCopyListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.RoutingCopyTotCnt(params));
			extGrid.setData(searchService.RoutingCopyList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchRoutingCopyListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 자재 거래명세서 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMatTradeNoListLov.do")
	@ResponseBody
	public Object searchMatTradeNoListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMatTradeNoListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if (searchfrom.isEmpty()) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if (searchto.isEmpty()) {
				count++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchMatTradeNoTotCnt(params));
			extGrid.setData(searchService.searchMatTradeNoList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchMatTradeNoListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 자재 거래명세서 > 발주현황불러오기 // 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchScmTradePopupLov.do")
	@ResponseBody
	public Object searchScmTradePopupLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchScmTradePopupLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchScmTradePopupTotCnt(params));
			extGrid.setData(searchService.searchScmTradePopupList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchScmTradePopupLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 외주공정 거래명세서 > 외주발주불러오기 // 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchScmOutProcTradePopup.do")
	@ResponseBody
	public Object searchScmOutProcTradePopup(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchScmOutProcTradePopup Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.searchScmOutProcTradePopupTotCnt(params));
			extGrid.setData(searchService.searchScmOutProcTradePopupList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchScmOutProcTradePopup End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 반출내역 불러오기 Popup // 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchToolOutListLov.do")
	@ResponseBody
	public Object searchToolOutListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchToolOutListLov Start. >>>>>>>>>> " + params);
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
			extGrid.setTotcnt(searchService.ToolOutLovTotCnt(params));
			extGrid.setData(searchService.ToolOutLovList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchToolOutListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 공구변경 > 공정명 // 조회 항목 LOV를 호출한다. ( 공구 변경 현황관리 화면에서 사용 )
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchToolRoutingItemNameListLov.do")
	@ResponseBody
	public Object searchToolRoutingItemNameListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchToolRoutingItemNameListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
//			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
//			if (workcentercode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.ToolRoutingItemNameLovTotCnt(params));
			extGrid.setData(searchService.ToolRoutingItemNameLovList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchToolRoutingItemNameListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 공정관리 - 실적의 양품수량 lov(cavity) // lov List 항목 조회
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkOrderProdQtyCavityLov.do")
	@ResponseBody
	public Object WorkOrderProdQtyCavityLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("WorkOrderProdQtyCavityLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		ExtGridVO extGrid = new ExtGridVO();
		extGrid.setTotcnt(searchService.WorkOrderProdQtyCavityLovTotCnt(params));
		extGrid.setData(searchService.WorkOrderProdQtyCavityLovList(params));
		System.out.println("Data : " + extGrid.getData());

		System.out.println("WorkOrderProdQtyCavityLov End. >>>>>>>>>>");
		return extGrid;
	}
	

	/**
	 * 공정 정보 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchRoutingListLov.do")
	@ResponseBody
	public Object searchRoutingListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchRoutingListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
			if (itemcode.isEmpty()) {
				count++;
			}
			
			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchRoutingCount(params));
			extGrid.setData(searchService.searchRoutingList(params));
//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("searchRoutingListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	
	/**
	 * 타입 정보 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchItemstandarddetailLov.do")
	@ResponseBody
	public Object searchItemstandarddetailLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchItemstandarddetailLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchItemstandarddetailCount(params));
			extGrid.setData(searchService.searchItemstandarddetailList(params));
		}

		System.out.println("searchRoutingListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 타입 정보 // 조회 항목 LOV를 호출한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchShippingItemGroup.do")
	@ResponseBody
	public Object searchShippingItemGroupLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchShippingItemGroupLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchShippingItemGroupLovCount(params));
			extGrid.setData(searchService.searchShippingItemGroupLovList(params));
		}

		System.out.println("searchShippingItemGroupLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	//search.outType.list.lov.list
	
	
	/**
	 * 반출타입 / 반출타입 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchOutTypeListLov.do")
	@ResponseBody
	public Object searchOutTypeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchOutTypeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchOutTypeListLovCount(params));
			extGrid.setData(searchService.searchOutTypeListLovList(params));
		}

		System.out.println("searchOutTypeListLov End. >>>>>>>>>>");
		return extGrid;
	}
	
	
	/**
	 * 근로자들 / 현재 재직중인 근로자들을 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchAllEmployeeLov.do")
	@ResponseBody
	public Object searchAllEmployeeListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchAllEmployeeListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
//			String orgid = StringUtil.nullConvert(params.get("ORGID"));
//			if (orgid.isEmpty()) {
//				count++;
//			}
//
//			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
//			if (companyid.isEmpty()) {
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
			extGrid.setTotcnt(searchService.searchAllEmployeeListLovCount(params));
			extGrid.setData(searchService.searchAllEmployeeListLovList(params));
		}

		System.out.println("searchAllEmployeeListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * [일별기종별생산실적] 매출그룹, 공정별 기종 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchGroupModelListLov.do")
	@ResponseBody
	public Object searchGroupModelListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchGroupModelListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchGroupModelCount(params));
			extGrid.setData(searchService.searchGroupModelList(params));
		}

		System.out.println("searchGroupModelListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * [일별기종별생산실적] 매출그룹, 공정별, 기종별 타입 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchGroupItemDetailListLov.do")
	@ResponseBody
	public Object searchGroupItemDetailListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchGroupItemDetailListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchGroupItemDetailCount(params));
			extGrid.setData(searchService.searchGroupItemDetailList(params));
		}

		System.out.println("searchGroupItemDetailListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * [일별기종별생산실적] 매출그룹, 공정별 기종 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchGroupYearModelListLov.do")
	@ResponseBody
	public Object searchGroupYearModelListLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchGroupYearModelListLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchGroupYearModelCount(params));
			extGrid.setData(searchService.searchGroupYearModelList(params));
		}

		System.out.println("searchGroupYearModelListLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * [생산실적] 설비별 기종 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkModelList.do")
	@ResponseBody
	public Object searchWorkModelList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkModelList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

//			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
//			if (workcentercode.isEmpty()) {
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
			extGrid.setTotcnt(searchService.searchWorkModelCount(params));
			extGrid.setData(searchService.searchWorkModelList(params));
		}

		System.out.println("searchCarTypeList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * [생산실적] 설비별 타입 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchWorkItemStandardDList.do")
	@ResponseBody
	public Object searchWorkItemStandardDList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchWorkItemStandardDList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

//			String workcentercode = StringUtil.nullConvert(params.get("WORKCENTERCODE"));
//			if (workcentercode.isEmpty()) {
//				count++;
//			}

			String model = StringUtil.nullConvert(params.get("MODEL"));
			if (model.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchWorkItemStandardDCount(params));
			extGrid.setData(searchService.searchWorkItemStandardDList(params));
		}

		System.out.println("searchWorkItemStandardDList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 기종그룸 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchModelGroupList.do")
	@ResponseBody
	public Object searchModelGroupList(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchModelGroupList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}
			
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.ModelGroupListCount(params));
			extGrid.setData(searchService.ModelGroupList(params));
		}

		System.out.println("searchModelGroupList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 품목별 매출 실적현황 > 거래처 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchSalesCustomerLov.do")
	@ResponseBody
	public Object searchSalesCustomerLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchSalesCustomerLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String searchyear = StringUtil.nullConvert(params.get("SEARCHYEAR"));
			if (searchyear.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchSalesCustomerCount(params));
			extGrid.setData(searchService.searchSalesCustomerList(params));
		}

		System.out.println("searchSalesCustomerLov End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 마감관리 > 영역별 마감 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMonthlyCloseLov.do")
	@ResponseBody
	public Object searchMonthlyCloseLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMonthlyCloseLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if (orgid.isEmpty()) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if (companyid.isEmpty()) {
				count++;
			}

			String searchdate = StringUtil.nullConvert(params.get("SEARCHDATE"));
			if (searchdate.isEmpty()) {
				count++;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchMonthlyCloseCount(params));
			extGrid.setData(searchService.searchMonthlyCloseList(params));
		}

		System.out.println("searchMonthlyCloseLov End. >>>>>>>>>>");
		return extGrid;
	}
	

	/**
	 * 경영자정보 (모바일) > 모바일 메뉴 정보를 조회한다.
	 * 
	 * @return Object
	 * @exception Exception
	 */
	@RequestMapping(value = "/searchMobileMenuLov.do")
	@ResponseBody
	public Object searchMobileMenuLov(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("searchMobileMenuLov Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {
			// 필수 조건 미입력시 제약
		} catch (Exception e) {
			e.printStackTrace();
		}

		ExtGridVO extGrid = new ExtGridVO();

		if (count > 0) {
			extGrid.setTotcnt(0);
			extGrid.setData(null);
		} else {
			extGrid.setTotcnt(searchService.searchMobileMenuCount(params));
			extGrid.setData(searchService.searchMobileMenuList(params));
		}

		System.out.println("searchMobileMenuLov End. >>>>>>>>>>");
		return extGrid;
	}
}