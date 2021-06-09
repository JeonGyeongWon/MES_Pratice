package kr.co.bps.scs.scm.outprocess;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.file.ExcelFileService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import egovframework.let.sec.rgm.service.EgovAuthorGroupService;

/**
 * @ClassName : OrderManageExcelController.java
 * @Description : OrderManage Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2018. 11.
 * @version 1.0
 * @see 출력물 (엑셀 업로드 기능 추가) - 1. 외주공정 발주현황 조회
 * 
 */
@Controller
public class ScmOutprocessExcelController extends BaseController {

	@Autowired
	private ScmOutprocessService ScmOutprocessService;

	@Autowired
	private ExcelFileService excelFileService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 외주공정발주현황조회 // 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/scm/outprocess/ExcelDownload.do")
	public ModelAndView ScmOutProcessExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("ScmOutProcessExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");

		List<?> resultList = ScmOutprocessService.selectOutProcOrderStateList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "외주발주번호;";
		headers += "외주발주순번;";
		headers += "외주발주일자;";
		headers += "가공처;";
		headers += "납기요구일;";
		headers += "품번;";
		headers += "품명;";
		headers += "기종;";
		headers += "타입;";
		
		headers += "공정명;";
		headers += "작업지시번호;";
		headers += "외주입고번호;";
		headers += "외주입고순번;";
		headers += "외주입고일자;";
		headers += "단위;";
		headers += "발주수량;";
		headers += "입고수량;";
		headers += "불량수량;";
		headers += "단가;";
		
		headers += "공급가액;";
		headers += "부가세;";
		headers += "합계;";
		headers += "비고;";
		System.out.println("ScmOutProcessExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "OUTPONO;";
		columns += "OUTPOSEQ;";
		columns += "OUTPODATE;";
		columns += "CUSTOMERNAME;";
		columns += "DUEDATE;";
		columns += "ORDERNAME;";
		columns += "ITEMNAME;";
		columns += "CARTYPENAME;";
		columns += "ITEMSTANDARDDETAIL;";
		
		columns += "ROUTINGNAME;";
		columns += "WORKORDERID;";
		columns += "OUTTRANSNO;";
		columns += "OUTTRANSSEQ;";
		columns += "OUTTRANSDATE;";
		columns += "UOMNAME;";
		columns += "ORDERQTY;";
		columns += "TRANSQTY;";
		columns += "FAULTQTY;";
		columns += "UNITPRICE;";
		
		columns += "SUPPLYPRICE;";
		columns += "ADDITIONALTAX;";
		columns += "TOTAL;";
		columns += "REMARKS;";	
		System.out.println("ScmOutProcessExcelDownload 2. >>>>>>>>>> " + columns);

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
		System.out.println("ScmOutProcessExcelDownload 7. >>>>>>>>>> " + types);

		String title = StringUtil.nullConvert(params.get("TITLE"));
		String temp, temp1, temp2;
		temp = title.replaceAll(" ", "_");
		temp1 = temp.replaceAll("\\(", "");
		temp2 = temp1.replaceAll("\\)", "");
		System.out.println("ScmOutProcessExcelDownload temp2. >>>>>>>>>> " + temp2);
		resultObject.put("title", temp );

		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}