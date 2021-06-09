package kr.co.bps.scs.master.customer;

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
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;
import egovframework.let.sec.rgm.service.EgovAuthorGroupService;
import egovframework.let.utl.fcc.service.EgovDateUtil;

/**
 * @ClassName : CustomerController.java
 * @Description : Customer Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 10
 * @version 1.0
 * @see 기준정보 > 거래처 관리
 * 
 */

@Controller
public class CustomerController extends BaseController {

	@Autowired
	private CustomerService customerService;
	
	@Autowired
	private searchService searchService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * Customer // Grid화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/customer/CustomerList.do")
	public String showCustomerListViewPage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		System.out.println("showCustomerListViewPage Start. >>>>>>>>>> " + requestMap);
		LoginVO loVo = super.getLoginVO();

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

				
				if  (orgid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						//params.put("ORGID", orgid );
					}else {
						System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
						// org
						requestMap.put("ORGID", "");
						params.put("ORGID",999 ); //임의의값
					}
				}else {
					System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID", orgid );
				}
				labelBox.put("findByOrgId", searchService.OrgLovList(params));
				
				List<?> orgList = (List<?>) searchService.OrgLovList(params);
				HashMap<String, Object> orgMap = (HashMap<String,Object>) orgList.get(0);
				
				String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
				System.out.println("3-1. orgid >>>>>>>>>> " + result_org);
				

				if  (companyid == "") {
					if  ( groupid.equals("ROLE_ADMIN") ) {
						System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						//params.put("ORGID", orgid );
						//params.put("COMPANYID", companyid );
					}else {
						System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
						// company
						requestMap.put("COMPANYID", "");
						params.put("ORGID", 999 );//임의의값
						params.put("COMPANYID", 999 );//임의의값
					}
				}else {
					System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", orgid );
					params.put("COMPANYID", companyid );
				}
				labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

				List<?> compList = (List<?>) searchService.CompanyLovList(params);
				HashMap<String, Object> compMap = (HashMap<String,Object>) compList.get(0);
				
				String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
				System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);

				model.addAttribute("labelBox", labelBox);

				// 예외처리
			requestMap.put("USEYN", "Y");
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("pageTitle", "거래처 관리");
		model.addAttribute("searchVO", requestMap);

		return "/master/customer/CustomerList";
	}

	/**
	 * 거래처 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/customer/CustomerList.do")
	@ResponseBody
	public Object selectCustomerList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCustomerList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

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
			extGrid.setTotcnt(customerService.selectCustomerCount(params));
			extGrid.setData(customerService.selectCustomerList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCustomerList End. >>>>>>>>>>");
		return extGrid;
	}
	
	/**
	 * 거래처 등록 & 조회 // Grid 화면을 처리한다.
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/customer/CustomerManage.do")
	public String showCustomerManagePage(HttpSession session, ModelMap model, @RequestParam HashMap<String, Object> requestMap) throws Exception {
		egovframework.com.cmm.LoginVO loVo = (egovframework.com.cmm.LoginVO) session.getAttribute("LoginVO");
		System.out.println("showCustomerManagePage Start. >>>>>>>>>>");

		Map<String, List> labelBox = new HashMap<String, List>();
		try {
	
			HashMap<String, Object> params = new HashMap<String, Object>();
			
			
			String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
			requestMap.put("datefrom", datefrom);
			
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

			
			if  (orgid == "") {
				if  ( groupid.equals("ROLE_ADMIN") ) {
					System.out.println("1 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					//params.put("ORGID", orgid );
				}else {
					System.out.println("2 show groupid. >>>>>>>>>>" + groupid);
					// org
					requestMap.put("ORGID", "");
					params.put("ORGID",999 ); //임의의값
				}
			}else {
				System.out.println("3 show groupid. >>>>>>>>>>" + groupid);
				// org
				requestMap.put("ORGID", "");
				params.put("ORGID", orgid );
			}
			labelBox.put("findByOrgId", searchService.OrgLovList(params));
			
			List<?> orgList = (List<?>) searchService.OrgLovList(params);
			HashMap<String, Object> orgMap = (HashMap<String,Object>) orgList.get(0);
			
			String result_org = StringUtil.nullConvert(orgMap.get("VALUE"));
			System.out.println("3-1. orgid >>>>>>>>>> " + result_org);
			

			if  (companyid == "") {
				if  ( groupid.equals("ROLE_ADMIN") ) {
					System.out.println("4 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					//params.put("ORGID", orgid );
					//params.put("COMPANYID", companyid );
				}else {
					System.out.println("5 show groupid. >>>>>>>>>>" + groupid);
					// company
					requestMap.put("COMPANYID", "");
					params.put("ORGID", 999 );//임의의값
					params.put("COMPANYID", 999 );//임의의값
				}
			}else {
				System.out.println("6 show groupid. >>>>>>>>>>" + groupid);
				// company
				requestMap.put("COMPANYID", "");
				params.put("ORGID", orgid );
				params.put("COMPANYID", companyid );
			}
			labelBox.put("findByCompanyId", searchService.CompanyLovList(params));

			List<?> compList = (List<?>) searchService.CompanyLovList(params);
			HashMap<String, Object> compMap = (HashMap<String,Object>) compList.get(0);
			
			String result_comp = StringUtil.nullConvert(compMap.get("VALUE"));
			System.out.println("3-2. companyid >>>>>>>>>> " + result_comp);
			
			// 1. 거래처 분류
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
	     	params.put("BIGCD", "CMM");
	     	params.put("MIDDLECD", "CUSTOMER_TYPE");
	     	params.put("GUBUN", "CUSTOMER_TYPE");

			labelBox.put("findByCustomerType", searchService.SmallCodeLovList(params));

			// 2. 거래처 구분
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
	     	params.put("BIGCD", "CMM");
	     	params.put("MIDDLECD", "CUSTOMER_DIV");
	     	params.put("GUBUN", "CUSTOMER_DIV");

			labelBox.put("findByCustomerDiv", searchService.SmallCodeLovList(params));
			
			// 3. 단가 구분
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
	     	params.put("BIGCD", "CMM");
	     	params.put("MIDDLECD", "UNIT_DIV");
	     	params.put("GUBUN", "UNIT_DIV");

			labelBox.put("findByUnitDiv", searchService.SmallCodeLovList(params));
			
			// 4. 마감일 구분
			params.put("ORGID", result_org );
			params.put("COMPANYID", result_comp );
	     	params.put("BIGCD", "CMM");
	     	params.put("MIDDLECD", "CLOSING_DATE");
	     	params.put("GUBUN", "CLOSING_DATE");

			labelBox.put("findByClosingDate", searchService.SmallCodeLovList(params));
			
			model.addAttribute("labelBox", labelBox);
			
			String CustomerCode = StringUtil.nullConvert(requestMap.get("code"));
			System.out.println("showCustomerManagePage CustomerCode>>>>>>>>>>>>>>>>> " + CustomerCode);
			if ( !CustomerCode.isEmpty() ) {
				// 거래처코드가 있을 경우 수정
				model.addAttribute("pageTitle", "거래처 상세 및 수정");

				requestMap.put("searchCustomerCode", CustomerCode);
				
				requestMap.put("USEYN", "Y");
				List customerList = customerService.selectCustomerList(requestMap);
				Map<String, Object> current = (Map<String, Object>) customerList.get(0);

				requestMap.put("GUBUN", "MODIFY");	// 수정
				requestMap.put("ORGID", current.get("ORGID"));
				requestMap.put("COMPANYID", current.get("COMPANYID"));
				requestMap.put("CUSTOMERCODE", current.get("CUSTOMERCODE"));
				requestMap.put("CUSTOMERNAME", current.get("CUSTOMERNAME"));
				requestMap.put("CUSTOMERTYPE", current.get("CUSTOMERTYPE"));
				requestMap.put("CUSTOMERTYPENAME", current.get("CUSTOMERTYPENAME"));
				requestMap.put("CUSTOMERDIV", current.get("CUSTOMERDIV"));
				requestMap.put("CUSTOMERDIVNAME", current.get("CUSTOMERDIVNAME"));
				requestMap.put("UNITPRICEDIV", current.get("UNITPRICEDIV"));
				requestMap.put("UNITPRICEDIVNAME", current.get("UNITPRICEDIVNAME"));
				requestMap.put("LICENSENO", current.get("LICENSENO"));
				requestMap.put("OWNER", current.get("OWNER"));
				requestMap.put("PHONENUMBER", current.get("PHONENUMBER"));
				requestMap.put("FAXNUMBER", current.get("FAXNUMBER"));
				requestMap.put("BISSTATUS", current.get("BISSTATUS"));
				requestMap.put("BISTYPE", current.get("BISTYPE"));
				requestMap.put("ZIPCODE", current.get("ZIPCODE"));
				requestMap.put("ADDRESS", current.get("ADDRESS"));
				requestMap.put("PERSON", current.get("PERSON"));
				requestMap.put("PERSONDEPT", current.get("PERSONDEPT"));
				requestMap.put("PERSONPHONE", current.get("PERSONPHONE"));
				requestMap.put("PERSONCELL", current.get("PERSONCELL"));
				requestMap.put("PERSONMAIL", current.get("PERSONMAIL"));
				requestMap.put("USEYN", current.get("USEYN"));
				requestMap.put("REMARKS", current.get("REMARKS"));
				requestMap.put("HOMEPAGE", current.get("HOMEPAGE"));
				requestMap.put("FREIGHTPOINT", current.get("FREIGHTPOINT"));
				requestMap.put("BANKCODE", current.get("BANKCODE"));
				requestMap.put("BANKNAME", current.get("BANKNAME"));
				requestMap.put("BANKACCOUNT", current.get("BANKACCOUNT"));
				requestMap.put("BANKNAME", current.get("BANKNAME"));
				requestMap.put("DMZIPCODE", current.get("DMZIPCODE"));
				requestMap.put("DMADDRESS", current.get("DMADDRESS"));
				requestMap.put("SEARCHDESC", current.get("SEARCHDESC"));
				requestMap.put("ORDERYN", current.get("ORDERYN"));
				requestMap.put("CLOSINGDATE", current.get("CLOSINGDATE"));
			} else {
				// 없을 경우 등록
				model.addAttribute("pageTitle", "거래처 등록");

				requestMap.put("GUBUN", "REGIST");	// 등록
				requestMap.put("ORGID", result_org);
				requestMap.put("COMPANYID",result_comp);
				requestMap.put("CUSTOMERTYPE", "A");
				requestMap.put("CUSTOMERDIV", "A");
				requestMap.put("UNITPRICEDIV", "A");
				requestMap.put("USEYN", "Y");	// 사용유무는 기본 값 Y
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("searchVO", requestMap);

		System.out.println("showCustomerManagePage End. >>>>>>>>>>");
		return "/master/customer/CustomerManage";
	}

	/**
	 * 거래처 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/customer/CustomerManage.do")
	@ResponseBody
	public Object insertCustomerManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("insertCustomerManage Params. >>>>>>>>>> " + params);
		
		return customerService.insertCustomerManage(params);
	}
	

	/**
	 * 거래처 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/customer/CustomerManage.do")
	@ResponseBody
	public Object updateCustomerManage(@RequestParam HashMap<String, Object> params) throws Exception {

		System.out.println("updateCustomerManage Params. >>>>>>>>>> " + params);
		
		return customerService.updateCustomerManage(params);
	}
	
	/**
	 * 거래처의 추가정보 조회
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/select/customer/CustomerMemberList.do")
	@ResponseBody
	public Object selectCustomerMemberList(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("selectCustomerMemberList Start. >>>>>>>>>> " + params);
		params.putAll(super.getGridParam4paging(params));

		int count = 0;
		try {

			String masterclick = StringUtil.nullConvert(params.get("MASTERCLICK"));
			if(!masterclick.isEmpty()){
				String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
				if (customercode.isEmpty()) {
					count++;
				}
			}else{
				String gubun = StringUtil.nullConvert(params.get("GUBUN"));
				if (gubun.isEmpty()) {
					String customercode = StringUtil.nullConvert(params.get("CUSTOMERCODE"));
					if (customercode.isEmpty()) {
						count++;
					}
				}else{
					String firstCustomercode = StringUtil.nullConvert(customerService.selectCustomerFirstList(params));
					System.out.println("firstCustomercode >>>>>>>>> " + firstCustomercode);

					if( firstCustomercode != ""){
						params.put("CUSTOMERCODE", firstCustomercode);
					}else{
						count++;
					}
				}
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
			extGrid.setTotcnt(customerService.selectCustomerMemberTotCnt(params));
			extGrid.setData(customerService.selectCustomerMemberList(params));
			//			System.out.println("Data : " + extGrid.getData());
		}

		System.out.println("selectCustomerMemberList End. >>>>>>>>>>");
		return extGrid;
	}

	/**
	 * 거래처의 추가정보 // 데이터 등록
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/insert/customer/CustomerMemberList.do")
	@ResponseBody
	public Object insertCustomerMemberList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("insertCustomerMemberList Params. >>>>>>>>>> " + params);

		return customerService.insertCustomerMemberList(params);
	}
	
	/**
	 * 거래처의 추가정보 // 데이터 변경
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/update/customer/CustomerMemberList.do")
	@ResponseBody
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = { Exception.class })
	public Object updateCustomerMemberList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("updateCustomerMemberList Start. >>>>>>>>>> " + params);

		Object result = null;
		try {
			result = customerService.updateCustomerMemberList(params);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 거래처의 추가정보 // 데이터 삭제
	 * 
	 * @return json
	 * @exception Exception
	 */
	@RequestMapping(value = "/delete/customer/CustomerMemberList.do")
	@ResponseBody
	public Object deleteCustomerMemberList(@RequestParam HashMap<String, Object> params) throws Exception {
		System.out.println("deleteCustomerMemberList Start. >>>>>>>>>> " + params);

		return customerService.deleteCustomerMemberList(params);
	}
}