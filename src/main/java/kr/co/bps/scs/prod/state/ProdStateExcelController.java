package kr.co.bps.scs.prod.state;

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
 * @ClassName : ProdStateExcelController.java
 * @Description : ProdState Excel Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 09.
 * @version 1.0
 * @see 출력물 (엑셀 다운로드 기능 추가) - 작업자별 실적달성율
 * 
 */
@Controller
public class ProdStateExcelController extends BaseController {

	@Autowired
	private ProdStateService ProdStateService;

	@Resource(name = "egovAuthorGroupService")
	private EgovAuthorGroupService egovAuthorGroupService;

	/**
	 * 작업자별 실적달성율// 조회된 Grid 데이터를 Excel로 다운로드 한다.
	 * 
	 * @return ModelAndView
	 * @exception Exception
	 */
	@RequestMapping(value = "/prod/state/AccPerformExcelDownload.do")
	public ModelAndView ProdStateAccPerformExcelDownload(@RequestParam HashMap<String, Object> params, @RequestParam Map requestMap) throws Exception {

		System.out.println("ProdStateAccPerformExcelDownload params >>>>>>>>> " + params);
		ModelAndView mav = new ModelAndView("excelDownloadXlsx");
		Map resultObject = new HashMap();

		int count = 0;
		//		String datefrom = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		//		String dateto = EgovDateUtil.addYearMonthDay2((java.util.Date) null, 0, 0, 0, "yyyy-MM-dd");
		try {
			String orgid = StringUtil.nullConvert(params.get("ORGID"));
			if ( orgid.isEmpty() ) {
				count++;
			}

			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
			if ( companyid.isEmpty() ) {
				count++;
			}

			String searchfrom = StringUtil.nullConvert(params.get("SEARCHFROM"));
			if ( searchfrom.isEmpty() ) {
				count++;
			}

			String searchto = StringUtil.nullConvert(params.get("SEARCHTO"));
			if ( searchto.isEmpty() ) {
				count++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<?> resultList = ProdStateService.WorkerAccPerformList(params);

		String headers = "";
		String columns = "";
		String types = "";

		headers += "순번;";
		headers += "일자;";
		headers += "작업자;";
		headers += "주야구분;";
		headers += "설비명;";
		headers += "품번;";
//		headers += "도번;";
		headers += "품명;";
		headers += "기종;";
//		headers += "재질;";
		
		headers += "공정명;";
		headers += "작업반;";
		headers += "투입시간(분);";
		headers += "작업시간(분);";
		headers += "비가동시간(분);";
		headers += "목표수량;";
		headers += "생산수량;";
		headers += "양품수량;";
		headers += "생산금액;";
		headers += "불량수량;";
		
		headers += "불량금액;";
		headers += "비고;";
		System.out.println("ProdStateAccPerformExcelDownload 1. >>>>>>>>>> " + headers);

		columns += "RN;";
		columns += "PRODDATE;";
		columns += "KRNAME;";
		columns += "WORKDIVNAME;";
		columns += "WORKCENTERNAME;";
		columns += "ORDERNAME;";
//		columns += "DRAWINGNO;";
		columns += "ITEMNAME;";
		columns += "MODELNAME;";
//		columns += "MATERIALTYPE;";
		
		columns += "ROUTINGNAME;";
		columns += "WORKDEPTNAME;";
		columns += "CLOSINGTIME;";
		columns += "WORKERTIME;";
		columns += "NONOPERQTY;";
		columns += "WORKPLANQTY;";
		columns += "DEFECTEDQTY;";
		columns += "PRODQTY;";
		columns += "PRODCOST;";
		columns += "FAULTQTY;";
		
		columns += "FAULTCOST;";
		columns += "REMARKS;";
		System.out.println("ProdStateAccPerformExcelDownload 2. >>>>>>>>>> " + columns);

		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
		types += "S;";
//		types += "S;";
		types += "S;";
		types += "S;";
//		types += "S;";
		
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
		System.out.println("ProdStateAccPerformExcelDownload 3. >>>>>>>>>> " + types);

		resultObject.put("title", "작업자별_실적달성율");
		resultObject.put("header", headers);
		resultObject.put("columns", columns);
		resultObject.put("type", types);
		resultObject.put("data", resultList);

		mav.addAllObjects(resultObject);

		return mav;
	}
}