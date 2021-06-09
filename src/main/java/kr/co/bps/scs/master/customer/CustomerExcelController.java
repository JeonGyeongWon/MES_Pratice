package kr.co.bps.scs.master.customer;

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
 * @ClassName : CustomerExcelController.java
 * @Description : Customer Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 12.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 1. 거래처 관리
 * 
 */
@Controller
public class CustomerExcelController extends BaseController {

	@Autowired
	private CustomerService customerService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 거래처 관리 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/customer/ExcelDownload.do")
	public ModelAndView customerExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("customerExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		String gubun = StringUtil.nullConvert(params.get("GUBUN"));
		String headers = "";
		String columns = "";
		String types = "";
		if (gubun.equals("CUSTOMER")) {
			// 거래처 관리 엑셀 다운로드
			List<?> resultList = customerService.selectCustomerList(params);

			headers += "순번;";
			headers += "거래처코드;";
			headers += "거래처명;";
			headers += "거래처분류;";
			headers += "거래처구분;";
			headers += "단가구분;";
			headers += "사업자번호;";
			headers += "대표자명;";
			headers += "전화번호;";
			headers += "팩스번호;";

			headers += "업태;";
			headers += "업종;";
			headers += "우편번호;";
			headers += "주소;";
			headers += "담당자;";
			headers += "담당자 부서;";
			headers += "담당자 번호;";
			headers += "담당자 휴대폰번호;";
			headers += "담당자 E-mail;";
			headers += "마감일;";
			headers += "검색항목;";

			headers += "발주번호 출력여부;";
			headers += "사용유무;";
			headers += "비고;";
			System.out.println("customerExcelDownload 1-1. >>>>>>>>>> " + headers);

			columns += "RN;";
			columns += "CUSTOMERCODE;";
			columns += "CUSTOMERNAME;";
			columns += "CUSTOMERTYPENAME;";
			columns += "CUSTOMERDIVNAME;";
			columns += "UNITPRICEDIVNAME;";
			columns += "LICENSENO;";
			columns += "OWNER;";
			columns += "PHONENUMBER;";
			columns += "FAXNUMBER;";

			columns += "BISSTATUS;";
			columns += "BISTYPE;";
			columns += "ZIPCODE;";
			columns += "ADDRESS;";
			columns += "PERSON;";
			columns += "PERSONDEPT;";
			columns += "PERSONPHONE;";
			columns += "PERSONCELL;";
			columns += "PERSONMAIL;";
			columns += "CLOSINGDATE;";
			columns += "SEARCHDESC;";

			columns += "ORDERYN;";
			columns += "USEYN;";
			columns += "REMARKS;";
			System.out.println("customerExcelDownload 1-2. >>>>>>>>>> " + columns);

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";

			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";
			types += "S;";

			types += "S;";
			types += "S;";
			types += "S;";
			System.out.println("customerExcelDownload 1-3. >>>>>>>>>> " + types);

			String title = StringUtil.nullConvert(params.get("TITLE"));
			String temp, temp1, temp2;
			temp = title.replaceAll(" ", "_");
			temp1 = temp.replaceAll("\\(", "");
			temp2 = temp1.replaceAll("\\)", "");
			System.out.println("customerExcelDownload temp2. >>>>>>>>>> " + temp2);

			resultObject.put("title", temp2);
			resultObject.put("header", headers);
			resultObject.put("columns", columns);
			resultObject.put("type", types);
			resultObject.put("data", resultList);
		}

		mav.addAllObjects(resultObject);

		return mav;
	}
}