package kr.co.bps.scs.report;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.bps.scs.base.controller.BaseController;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;
import net.sf.jasperreports.engine.JRDataSource;
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : ReportController.java
 * @Description : Report Controller class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 11.
 * @version 1.0
 * @see 출력물관리
 * 
 */
@Controller
public class ReportController extends BaseController {

	/**
	 * 작업실적 > 바코드 출력 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/SemiItemLotReport.pdf")
	public ModelAndView SemiItemLotReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("SemiItemLotReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("orgid"));
			if (!orgid.isEmpty()) {
				System.out.println("SemiItemLotReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("companyid"));
			if (!companyid.isEmpty()) {
				System.out.println("SemiItemLotReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String workorderid = StringUtil.nullConvert(requestMap.get("workorderid"));
			if (!workorderid.isEmpty()) {
				System.out.println("SemiItemLotReport 3. >>>>>>>>>> " + workorderid);
				requestMap.put("WORKORDERID", workorderid);
			}

			String workorderseq = StringUtil.nullConvert(requestMap.get("workorderseq"));
			if (!workorderseq.isEmpty()) {
				System.out.println("SemiItemLotReport 4. >>>>>>>>>> " + workorderseq);
				requestMap.put("WORKORDERSEQ", workorderseq);
			}

			String seqno = StringUtil.nullConvert(requestMap.get("seqno"));
			String seqno2 = StringUtil.nullConvert(requestMap.get("seqno2"));
			if (!seqno.isEmpty()) {
				System.out.println("SemiItemLotReport 5-1. >>>>>>>>>> " + seqno);
				requestMap.put("SEQNO", seqno);
			} else {
				System.out.println("SemiItemLotReport 5-2. >>>>>>>>>> " + seqno2);
				requestMap.put("SEQNO", seqno2);
			}

			List<?> resultList = dao.list("report.work.result.item.lot.select", requestMap);

			// JasperReport 엔진에 데이터소스를 전달하기 위해 사용함.
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			//			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "semiitemlotreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("WORKORDERID", requestMap.get("WORKORDERID"));
			mv.addObject("WORKORDERSEQ", requestMap.get("WORKORDERSEQ"));
			mv.addObject("SEQNO", requestMap.get("SEQNO"));

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}

	/**
	 * 출하 바코드 생성 > 바코드 출력 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipLotReport.pdf")
	public ModelAndView ShipLotReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipLotReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("ShipLotReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("ShipLotReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			String shipno = StringUtil.nullConvert(requestMap.get("shipno"));
			if (!shipno.isEmpty()) {
				System.out.println("ShipLotReport 3. >>>>>>>>>> " + shipno);
				requestMap.put("SHIPNO", shipno);
			}
			String shipseq = StringUtil.nullConvert(requestMap.get("shipseq"));
			if (!shipseq.isEmpty()) {
				System.out.println("ShipLotReport 4. >>>>>>>>>> " + shipseq);
				requestMap.put("SHIPSEQ", shipseq);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			List<?> tempList = dao.list("report.order.ship.lot.select", requestMap);
			System.out.println("ShipLotReport 2. >>>>>>>>>> " + tempList);
			final int LOTCNT = NumberUtil.getInteger(requestMap.get("lotcnt"));
			for (int i = 0; i < LOTCNT; i++) {
				HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(0);
				resultList.add(list_temp);
			}

			// JasperReport 엔진에 데이터소스를 전달하기 위해 사용함.
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "shiplotreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("SHIPNO", requestMap.get("SHIPNO"));
			mv.addObject("SEQFROM", requestMap.get("SEQFROM"));
			mv.addObject("SEQTO", requestMap.get("SEQTO"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}
	
	/**
	 * 자재LOT바코드 생성 상세정보 > 자재 LOT 출력 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/MaterialLotReport.pdf")
	public ModelAndView MaterialLotReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("MaterialLotReport Start. >>>>>>>>>> " + requestMap);
		try {
			String LotNo = StringUtil.nullConvert(requestMap.get("LotNo"));
			if (!LotNo.isEmpty()) {
				System.out.println("MaterialLotReport 1. >>>>>>>>>> " + LotNo);
				requestMap.put("LOTNO", LotNo);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			final int LOTCNT = NumberUtil.getInteger(requestMap.get("LotCnt"));
			for (int i = 0; i < LOTCNT; i++) {
				requestMap.put("PAGECOUNT", (i + 1));
				requestMap.put("SEQ", (i + 1));
				List<?> tempList = dao.list("report.dist.lot.mat.lot.select", requestMap);
				System.out.println("MaterialLotReport 2. >>>>>>>>>> " + tempList);
				HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(0);
				resultList.add(list_temp);
			}

			// JasperReport 엔진에 데이터소스를 전달하기 위해 사용함.
			//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "materiallotreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("LOTNO", requestMap.get("LOTNO"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}
	
	/**
	 * 외주공정LOT바코드 출력 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/OutProcLotReport.pdf")
	public ModelAndView OutProcLotReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("OutProcLotReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("ShipLotReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("ShipLotReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			String LotNo = StringUtil.nullConvert(requestMap.get("LotNo"));
			if (!LotNo.isEmpty()) {
				System.out.println("OutProcLotReport 1. >>>>>>>>>> " + LotNo);
				requestMap.put("LOTNO", LotNo);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			final int LOTCNT = NumberUtil.getInteger(requestMap.get("LotCnt"));
			for (int i = 0; i < LOTCNT; i++) {
				requestMap.put("PAGECOUNT", (i + 1));
				requestMap.put("SEQ", (i + 1));
				List<?> tempList = dao.list("report.scm.outprocess.lot.select", requestMap);
				System.out.println("MaterialLotReport 2. >>>>>>>>>> " + tempList);
				HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(0);
				resultList.add(list_temp);
			}

			// JasperReport 엔진에 데이터소스를 전달하기 위해 사용함.
			//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "outproclotreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("LOTNO", requestMap.get("LOTNO"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}

	/**
	 * 발주서 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/OrderReport.pdf")
	public ModelAndView OrderReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("OrderReport Start. >>>>>>>>>> " + requestMap);
		try {
			String pono = StringUtil.nullConvert(requestMap.get("PoNo"));

			if (!pono.isEmpty()) {
				System.out.println("MaterialOrderReport 1. >>>>>>>>>> " + pono);
			}

			List<?> resultList = dao.list("report.purchase.order.select", requestMap);

			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			//			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "orderreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("PONO", requestMap.get("PoNo"));
			mv.addObject("ORGID", requestMap.get("searchOrgId"));
			mv.addObject("COMPANYID", requestMap.get("searchCompanyId"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("OrderReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 공정 이동전표 출력 ( 작업지시투입관리 ) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/LotTransSlipReport.pdf")
	public ModelAndView LotTransSlipReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("LotTransSlipReport Start. >>>>>>>>>> " + requestMap);
		try {
			String viewname = null;
			String workorderid = StringUtil.nullConvert(requestMap.get("WORKORDERID"));
			if (!workorderid.isEmpty()) {
				System.out.println("LotTransSlipReport 1. >>>>>>>>>> " + workorderid);
				requestMap.put("WORKORDERID", workorderid);
			}

			List<?> resultList = dao.list("report.lottransslipreport.report.select", requestMap);

			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			viewname = "lottransslipcustreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);
			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("WORKORDERID", requestMap.get("WORKORDERID"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}

	/**
	 * 공정 이동전표 출력 ( 공정실적 ) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/LotTransSlipReportQ.pdf")
	public ModelAndView LotTransSlipReportQ(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("LotTransSlipReportQ Start. >>>>>>>>>> " + requestMap);
		try {
			String viewname = null;
			String orgid = StringUtil.nullConvert(requestMap.get("orgid"));
			if (!orgid.isEmpty()) {
				System.out.println("LotTransSlipReportQ 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("companyid"));
			if (!companyid.isEmpty()) {
				System.out.println("LotTransSlipReportQ 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String workorderid = StringUtil.nullConvert(requestMap.get("workorderid"));
			if (!workorderid.isEmpty()) {
				System.out.println("LotTransSlipReportQ 3. >>>>>>>>>> " + workorderid);
				requestMap.put("WORKORDERID", workorderid);
			}

			int workorderseq = NumberUtil.getInteger(requestMap.get("workorderseq"));
			if ( workorderseq > 0 ) {
				System.out.println("LotTransSlipReportQ 4. >>>>>>>>>> " + workorderseq);
				requestMap.put("WORKORDERSEQ", workorderseq);
			}

			String equipmentcode = StringUtil.nullConvert(requestMap.get("equipmentcode"));
			if (!equipmentcode.isEmpty()) {
				System.out.println("LotTransSlipReportQ 5. >>>>>>>>>> " + equipmentcode);
				requestMap.put("EQUIPMENTCODE", equipmentcode);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			int boxCount = NumberUtil.getInteger(requestMap.get("reportBoxcount"));
			int boxAmount = NumberUtil.getInteger(requestMap.get("reportBoxamount"));

			final int PRINT_CNT = 1; // 출력매수 1장
			for (int i = 0; i < PRINT_CNT; i++) {
				requestMap.put("BOXQTY", boxAmount);
				requestMap.put("BOXCNT", boxCount);
				
				List<?> tempList = dao.list("report.lot.trans.slip.select", requestMap);
				System.out.println("LotTransSlipReport 2. >>>>>>>>>> " + tempList);

				viewname = "lottransslipreport";

				for (int j = 0; j < tempList.size(); j++) {
					HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(j);
					resultList.add(list_temp);
				}
			}

			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("WORKORDERID", requestMap.get("WORKORDERID"));
			mv.addObject("WORKORDERSEQ", requestMap.get("WORKORDERSEQ"));
			mv.addObject("BOXQTY", requestMap.get("BOXQTY"));
			mv.addObject("BOXCNT", requestMap.get("BOXCNT"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");

		return mv;
	}

	/**
	 * 거래명세서 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/TransactionDetailsReport.pdf")
	public ModelAndView TransactionDetailsReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("TransactionDetailsReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("TransactionDetailsReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
		
			String orgid = StringUtil.nullConvert(requestMap.get("ORGID"));

			if (!orgid.isEmpty()) {
				System.out.println("TransactionDetailsReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("COMPANYID"));

			if (!companyid.isEmpty()) {
				System.out.println("TransactionDetailsReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String tradeno = StringUtil.nullConvert(requestMap.get("TRADENO"));

			if (!tradeno.isEmpty()) {
				System.out.println("TransactionDetailsReport 3. >>>>>>>>>> " + tradeno);
				requestMap.put("TRADENO", tradeno);
			}

			List<?> resultList = dao.list("report.transaction.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.transaction.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			String viewname = "transactiondetailsreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1); // 서브리포트와 쿼리 동일

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("TRADENO", requestMap.get("TRADENO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("TransactionDetailsReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 거래명세서 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/TransactionDetailsArReport.pdf")
	public ModelAndView TransactionDetailsArReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("TransactionDetailsArReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("TransactionDetailsArReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
		
			String orgid = StringUtil.nullConvert(requestMap.get("ORGID"));

			if (!orgid.isEmpty()) {
				System.out.println("TransactionDetailsArReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("COMPANYID"));

			if (!companyid.isEmpty()) {
				System.out.println("TransactionDetailsArReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String tradeno = StringUtil.nullConvert(requestMap.get("TRADENO"));

			if (!tradeno.isEmpty()) {
				System.out.println("TransactionDetailsArReport 3. >>>>>>>>>> " + tradeno);
				requestMap.put("TRADENO", tradeno);
			}
			
			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			requestMap.put("TYPEGUBUN", "TEMP");
			List<?> tempSize = dao.list("report.transaction.main.select", requestMap);
			
			int ListCnt = (int) Math.ceil((double) tempSize.size() / 21);
			int LastCnt = 21;
			
			System.out.println("TransactionDetailsArReport ListCnt. >>>>>>>>>> " + ListCnt);
			System.out.println("TransactionDetailsArReport tempListsize. >>>>>>>>>> " + tempSize.size());
			
		    for(int i = 1; i <= 2; i++){
    			if(i == 1){
    				requestMap.put("TYPEGUBUN", "공급자 보관용");
    			}else if(i == 2){
    				requestMap.put("TYPEGUBUN", "공급 받는자 보관용");
    			}
    			List<?> tempList = dao.list("report.transaction.main.select", requestMap);
		    	for(int j = 1; j <= ListCnt; j++){
		    		for(int k = ((j - 1) * LastCnt) + 1; k <= (LastCnt * j); k++){
		    			if(k <= tempList.size()){
		    				System.out.println("TransactionDetailsArReport in k. >>>>>>>>>> " + j + " - " +k);
		    				HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(k - 1);
		    				System.out.println("TransactionDetailsArReport list_temp. >>>>>>>>>> " + list_temp);
							resultList.add(list_temp);
		    			}else{
		    				System.out.println("TransactionDetailsArReport out k. >>>>>>>>>> " + j + " - " +k);
		    				resultList.add(null);
		    			}
		    		}
		    	}
		    }
			
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			//			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "transactiondetailsarreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("TRADENO", requestMap.get("TRADENO"));
			mv.addObject("TYPEGUBUN", requestMap.get("TYPEGUBUN"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("TransactionDetailsArReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 외주공정 거래명세서(SCM용) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ScmOutTransactionDetailsReport.pdf")
	public ModelAndView ScmOutTransactionDetailsReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ScmOutTransactionDetailsReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("FaultTypeReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String orgid = StringUtil.nullConvert(requestMap.get("ORGID"));
			if (!orgid.isEmpty()) {
				System.out.println("ScmOutTransactionDetailsReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("COMPANYID"));
			if (!companyid.isEmpty()) {
				System.out.println("ScmOutTransactionDetailsReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String tradeno = StringUtil.nullConvert(requestMap.get("TRADENO"));
			if (!tradeno.isEmpty()) {
				System.out.println("ScmOutTransactionDetailsReport 3. >>>>>>>>>> " + tradeno);
				requestMap.put("TRADENO", tradeno);
			}

			List<?> resultList = dao.list("report.scm.out.transaction.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
//			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.scm.out.transaction.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			String viewname = "scmouttransactiondetailsreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1); // 서브리포트와 쿼리 동일

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("TRADENO", requestMap.get("TRADENO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ScmOutTransactionDetailsReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 외주공정 거래명세서(SCM용) // Report 출력 A4 2장 ( 공급자 / 공급받는자 )
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ScmOutTransactionA4Report.pdf")
	public ModelAndView ScmOutTransactionA4Report(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ScmOutTransactionA4Report Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("FaultTypeReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String orgid = StringUtil.nullConvert(requestMap.get("ORGID"));
			if (!orgid.isEmpty()) {
				System.out.println("ScmOutTransactionA4Report 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("COMPANYID"));
			if (!companyid.isEmpty()) {
				System.out.println("ScmOutTransactionA4Report 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String tradeno = StringUtil.nullConvert(requestMap.get("TRADENO"));
			if (!tradeno.isEmpty()) {
				System.out.println("ScmOutTransactionA4Report 3. >>>>>>>>>> " + tradeno);
				requestMap.put("TRADENO", tradeno);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			requestMap.put("TYPEGUBUN", "TEMP");
			List<?> tempSize = dao.list("report.scm.out.transaction.main.select", requestMap);
			
			int ListCnt = (int) Math.ceil((double) tempSize.size() / 21);
			int LastCnt = 21;
			
			System.out.println("ScmOutTransactionA4Report ListCnt. >>>>>>>>>> " + ListCnt);
			System.out.println("ScmOutTransactionA4Report tempListsize. >>>>>>>>>> " + tempSize.size());
			
		    for(int i = 1; i <= 2; i++){
    			if(i == 1){
    				requestMap.put("TYPEGUBUN", "공급자 보관용");
    			}else if(i == 2){
    				requestMap.put("TYPEGUBUN", "공급 받는자 보관용");
    			}
    			List<?> tempList = dao.list("report.scm.out.transaction.main.select", requestMap);
		    	for(int j = 1; j <= ListCnt; j++){
		    		for(int k = ((j - 1) * LastCnt) + 1; k <= (LastCnt * j); k++){
		    			if(k <= tempList.size()){
		    				System.out.println("ScmOutTransactionA4Report in k. >>>>>>>>>> " + j + " - " +k);
		    				HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(k - 1);
		    				System.out.println("ScmOutTransactionA4Report list_temp. >>>>>>>>>> " + list_temp);
							resultList.add(list_temp);
		    			}else{
		    				System.out.println("ScmOutTransactionA4Report out k. >>>>>>>>>> " + j + " - " +k);
		    				resultList.add(null);
		    			}
		    		}
		    	}
		    }
			
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "scmouttransactiona4report";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("TRADENO", requestMap.get("TRADENO"));
			mv.addObject("TYPEGUBUN", requestMap.get("TYPEGUBUN"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ScmOutTransactionA4Report EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 매출매입실적 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/SalesPurchaseResultReport.pdf")
	public ModelAndView SalesPurchaseResultReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("SalesPurchaseResultReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("SalesPurchaseResultReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("SalesPurchaseResultReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("SalesPurchaseResultReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchDate = StringUtil.nullConvert(requestMap.get("searchTo"));
			if (!searchDate.isEmpty()) {
				System.out.println("SalesPurchaseResultReport 3. >>>>>>>>>> " + searchDate);
				requestMap.put("SEARCHDATE", searchDate);
			}

			List<?> resultList = dao.list("report.sales.purchase.result.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.sales.purchase.result.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			List<?> subList2 = dao.list("report.sales.purchase.result.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			List<?> subList3 = dao.list("report.sales.purchase.result.sub3.select", requestMap);
			JRBeanCollectionDataSource src3 = new JRBeanCollectionDataSource(subList3);

			String viewname = "salespurchaseresultreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			mv.addObject("subdata3", src3);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHDATE", requestMap.get("SEARCHDATE"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("SalesPurchaseResultReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 자주검사 체크시트 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@SuppressWarnings({ "null", "unchecked" })
	@RequestMapping(value = "/report/workHistoryChecksheetReport.pdf")
	public ModelAndView workHistoryChecksheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("workHistoryChecksheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportOrgAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("SalesPurchaseResultReport 0. >>>>>>>>>> " + path);
				requestMap.put("ORGIMAGE", path);
			}
			
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("workHistoryChecksheetReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("workHistoryChecksheetReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			
			String workorderid = StringUtil.nullConvert(requestMap.get("workorderid"));
			String workorderseq = StringUtil.nullConvert(requestMap.get("workorderseq"));
			String checkbig = StringUtil.nullConvert(requestMap.get("checkbig"));
			String employeeseq = StringUtil.nullConvert(requestMap.get("employeeseq"));
			String checkqty = StringUtil.nullConvert(requestMap.get("checkqty"));
			
			System.out.println("workHistoryChecksheetReport 2-1. >>>>>>>>>> " + workorderid);
			System.out.println("workHistoryChecksheetReport 2-2. >>>>>>>>>> " + workorderseq);
			System.out.println("workHistoryChecksheetReport 2-3. >>>>>>>>>> " + checkbig);
			System.out.println("workHistoryChecksheetReport 2-4. >>>>>>>>>> " + employeeseq);
			System.out.println("workHistoryChecksheetReport 2-5. >>>>>>>>>> " + checkqty);

			String[] workorderidArray = workorderid.split(",");
			String[] workorderseqArray = workorderseq.split(",");
			String[] checkbigArray = checkbig.split(",");
			String[] employeeseqArray = employeeseq.split(",");
			String[] checkqtyArray = checkqty.split(",");

			final int MaxCount = 44; // 22;

			int ParamsCount = workorderidArray.length;
			
			System.out.println("workHistoryChecksheetReport 3-1. >>>>>>>>>> " + ParamsCount);
			for (int i = 0; i < ParamsCount; i++) {
				int CheckPage = Integer.parseInt(checkqtyArray[i]) * 1;

				System.out.println("workHistoryChecksheetReport 3-2. >>>>>>>>>> " + CheckPage);
				for (int j = 0; j < CheckPage; j++) {
					
					requestMap.put("WORKORDERID", workorderidArray[i]);
					requestMap.put("WORKORDERSEQ", workorderseqArray[i]);
					requestMap.put("CHECKBIG", checkbigArray[i]);
					requestMap.put("EMPLOYEESEQ", employeeseqArray[i]);
					requestMap.put("CHECKCOUNT", (j +1));
					
					List<?> CountList = dao.list("report.work.workhistorylist.checksheet.select", requestMap);
				
					int forSize = CountList.size();
					System.out.println("workHistoryChecksheetReport 3-3. >>>>>>>>>> " + forSize);
					double forCount = 0;
					int mok = 0;
					
					if(forSize <= MaxCount){
						mok = MaxCount - forSize;
						forCount = MaxCount; // 22;
					} else {
						mok = MaxCount % forSize;
//						forCount = 22 * Math.ceil( (double) forSize / 22);
						forCount = MaxCount * Math.ceil((double) forSize / MaxCount);
					}

					for(int k = 0; k < forCount; k++){
						if(k < forSize){
							HashMap<String, Object> list_temp = (HashMap<String, Object>) CountList.get(k);
							resultList.add(list_temp);
						} else {
							HashMap<String, Object> list_temp = new HashMap<String,Object>();

//							List<?> OrgList = dao.list("search.org.lov.select", requestMap);
//							System.out.println("OrgList 2. >>>>>>>>>> " + OrgList.size());
//							if ( OrgList.size() > 0 ) {
//								Map<String, Object> list_org = (Map<String,Object>) OrgList.get(0);
//
//								String orgname = StringUtil.nullConvert(list_org.get("LABEL"));
//								list_temp.put("ORGID", orgid);
//								list_temp.put("ORGNAME", orgname);
								list_temp.put("ORGIMAGE", path);
//							}
							resultList.add(list_temp);
						}
					}
				}
			}
						
//			System.out.println("resultList 2. >>>>>>>>>> " + resultList);

//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "workhistorychecksheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("WORKORDERID", requestMap.get("WORKORDERID"));
			mv.addObject("WORKORDERSEQ", requestMap.get("WORKORDERSEQ"));
			mv.addObject("CHECKBIG", requestMap.get("CHECKBIG"));
			mv.addObject("EMPLOYEESEQ", requestMap.get("EMPLOYEESEQ"));
			mv.addObject("CHECKCOUNT", requestMap.get("CHECKCOUNT"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("workHistoryChecksheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 재고금액 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/StockAmountReport.pdf")
	public ModelAndView StockAmountReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		LoginVO login = getLoginVO();
		System.out.println("StockAmountReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("StockAmountReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("StockAmountReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("StockAmountReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchDate = StringUtil.nullConvert(requestMap.get("searchDate"));
			if (!searchDate.isEmpty()) {
				System.out.println("StockAmountReport 3. >>>>>>>>>> " + searchDate);
				requestMap.put("SEARCHDATE", searchDate);
			}

			// 1. 출력물 출력전 재고금액 데이터 생성 / 재갱신 PKG 호출
			List monthList = dao.selectListByIbatis("report.prod.stock.amount.month.find.select", requestMap);
			Map<String, Object> current = (Map<String, Object>) monthList.get(0);
			String searchMonth = StringUtil.nullConvert(current.get("SEARCHMONTH"));
			requestMap.put("SEARCHMONTH", searchMonth);

			requestMap.put("REGISTID", login.getId());
			requestMap.put("RETURNSTATUS", "");
			requestMap.put("MSGDATA", "");

			System.out.println("재고 금액 생성/갱신 PROCEDURE 호출 Start. >>>>>>>> " + requestMap);
			dao.list("report.prod.stock.amount.create.proc.call.Procedure", requestMap);
			System.out.println("재고 금액 생성/갱신 PROCEDURE 호출 End.  >>>>>>>> " + requestMap);

//			String status = StringUtil.nullConvert(requestMap.get("RETURNSTATUS"));
//			if (!status.equals("S")) {
//				throw new Exception("call CB_MFG_PKG.CB_STOCK_AMOUNT_CREATE fail.");
//			}
			
			List<?> resultList = dao.list("report.prod.stock.amount.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.prod.stock.amount.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			List<?> subList2 = dao.list("report.prod.stock.amount.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			String viewname = "stockamountreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHDATE", requestMap.get("SEARCHDATE"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("StockAmountReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 불량유형현황 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/FaultTypeReport.pdf")
	public ModelAndView FaultTypeReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("FaultTypeReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("FaultTypeReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
			
			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("FaultTypeReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("FaultTypeReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchPrintMonth = StringUtil.nullConvert(requestMap.get("searchPrintMonth"));
			if (!searchPrintMonth.isEmpty()) {
				System.out.println("FaultTypeReport 3. >>>>>>>>>> " + searchPrintMonth);
				requestMap.put("SEARCHDATE", searchPrintMonth);
			}

			List<?> resultList = dao.list("report.prod.insp.fault.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.prod.insp.fault.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			String viewname = "faulttypereport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHDATE", requestMap.get("SEARCHDATE"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("FaultTypeReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 공정유형현황 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/RoutingGroupReport.pdf")
	public ModelAndView RoutingGroupReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("RoutingGroupReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("RoutingGroupReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("RoutingGroupReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("RoutingGroupReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchPrintMonth = StringUtil.nullConvert(requestMap.get("searchPrintMonth"));
			if (!searchPrintMonth.isEmpty()) {
				System.out.println("RoutingGroupReport 3. >>>>>>>>>> " + searchPrintMonth);
				requestMap.put("SEARCHDATE", searchPrintMonth);
			}

			List<?> resultList = dao.list("report.prod.insp.routing.group.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.prod.insp.routing.group.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			List<?> subList2 = dao.list("report.prod.insp.routing.group.sub1.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			String viewname = "routinggroupreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHDATE", requestMap.get("SEARCHDATE"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("RoutingGroupReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	

	/**
	 * 생산집계표 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ProdSheetReport.pdf")
	public ModelAndView ProdSheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ProdSheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("ProdSheetReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
			
			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("ProdSheetReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("ProdSheetReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchDate = StringUtil.nullConvert(requestMap.get("searchTo"));
			if (!searchDate.isEmpty()) {
				System.out.println("ProdSheetReport 3. >>>>>>>>>> " + searchDate);
				requestMap.put("SEARCHDATE", searchDate);
			}

			List<?> resultList = dao.list("report.prod.sheet.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.prod.sheet.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			List<?> subList2 = dao.list("report.prod.sheet.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			List<?> subList3 = dao.list("report.prod.sheet.sub3.select", requestMap);
			JRBeanCollectionDataSource src3 = new JRBeanCollectionDataSource(subList3);

			List<?> subList4 = dao.list("report.prod.sheet.sub4.select", requestMap);
			JRBeanCollectionDataSource src4 = new JRBeanCollectionDataSource(subList4);

			String viewname = "prodsheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			mv.addObject("subdata3", src3);
			mv.addObject("subdata4", src4);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHDATE", requestMap.get("SEARCHDATE"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ProdSheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 일일작업지시현황 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/DayWorkOrderStatusReport.pdf")
	public ModelAndView DayWorkOrderStatusReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();
		LoginVO login = getLoginVO();

		System.out.println("DayWorkOrderStatusReport Start. >>>>>>>>>> " + requestMap);
		try {
			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("DayWorkOrderStatusReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("DayWorkOrderStatusReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchPrintDate = StringUtil.nullConvert(requestMap.get("searchPrintDate"));
			if (!searchPrintDate.isEmpty()) {
				System.out.println("DayWorkOrderStatusReport 3. >>>>>>>>>> " + searchPrintDate);
				requestMap.put("PRINTDATE", searchPrintDate);
			}

			requestMap.put("LOGINID", login.getId());

			List<?> resultList = dao.list("report.day.work.order.status.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "dayworkorderstatusreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("PRINTDATE", requestMap.get("PRINTDATE"));
			mv.addObject("LOGINID", requestMap.get("LOGINID"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("DayWorkOrderStatusReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 출하검사기준서 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipInspectionReport.pdf")
	public ModelAndView ShipInspectionReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipInspectionReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("ShipInspectionReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));

			if (!searchOrgId.isEmpty()) {
				System.out.println("ShipInspectionReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));

			if (!searchCompanyId.isEmpty()) {
				System.out.println("ShipInspectionReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String ShipInsNo = StringUtil.nullConvert(requestMap.get("ShipInsNo"));

			if (!ShipInsNo.isEmpty()) {
				System.out.println("ShipInspectionReport 3. >>>>>>>>>> " + ShipInsNo);
				requestMap.put("SHIPINSNO", ShipInsNo);
			}
			String viewname = null;
			String CustomerName = StringUtil.nullConvert(requestMap.get("CustomerName"));
			System.out.println("ShipInspectionReport 4. >>>>>>>>>> " + CustomerName);
			String targetName = "두산모트롤";
			if ( CustomerName.indexOf(targetName) > -1 ) {
				System.out.println("ShipInspectionReport 4-1. >>>>>>>>>> " );
				viewname = "shipinspectionreportds";
			} else {
				System.out.println("ShipInspectionReport 4-2. >>>>>>>>>> " );
			}

			List<?> resultList = dao.list("report.ship.insp.doosan.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList = dao.list("report.ship.insp.doosan.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList);

			List<?> subList2 = dao.list("report.ship.insp.doosan.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SHIPINSNO", requestMap.get("SHIPINSNO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ShipInspectionReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 출하검사기준서(이튼) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipInspectionETReport.pdf")
	public ModelAndView ShipInspectionETReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipInspectionETReport Start. >>>>>>>>>> " + requestMap);
		try {
			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));

			if (!searchOrgId.isEmpty()) {
				System.out.println("ShipInspectionETReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));

			if (!searchCompanyId.isEmpty()) {
				System.out.println("ShipInspectionETReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String ShipInsNo = StringUtil.nullConvert(requestMap.get("ShipInsNo"));

			if (!ShipInsNo.isEmpty()) {
				System.out.println("ShipInspectionETReport 3. >>>>>>>>>> " + ShipInsNo);
				requestMap.put("SHIPINSNO", ShipInsNo);
			}
			String viewname = null;
			String CustomerName = StringUtil.nullConvert(requestMap.get("CustomerName"));
			System.out.println("ShipInspectionETReport 4. >>>>>>>>>> " + CustomerName);
			String targetName = "이튼인더스트리스 유한회사";
			if ( CustomerName.indexOf(targetName) > -1 ) {
				System.out.println("ShipInspectionETReport 4-1. >>>>>>>>>> " );
				viewname = "shipinspectionreportet";
			} else {
				System.out.println("ShipInspectionETReport 4-2. >>>>>>>>>> " );
			}

			List<?> resultList = dao.list("report.ship.insp.eaton.report.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SHIPINSNO", requestMap.get("SHIPINSNO"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ShipInspectionETReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 출하검사기준서(하이드로텍㈜) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipInspectionHDReport.pdf")
	public ModelAndView ShipInspectionHDReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipInspectionHDReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("ShipInspectionHDReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));

			if (!searchOrgId.isEmpty()) {
				System.out.println("ShipInspectionHDReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));

			if (!searchCompanyId.isEmpty()) {
				System.out.println("ShipInspectionHDReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String ShipInsNo = StringUtil.nullConvert(requestMap.get("ShipInsNo"));

			if (!ShipInsNo.isEmpty()) {
				System.out.println("ShipInspectionHDReport 3. >>>>>>>>>> " + ShipInsNo);
				requestMap.put("SHIPINSNO", ShipInsNo);
			}
			String viewname = null;
			String CustomerName = StringUtil.nullConvert(requestMap.get("CustomerName"));
			System.out.println("ShipInspectionHDReport 4. >>>>>>>>>> " + CustomerName);
			String targetName = "하이드로텍㈜";
			if ( CustomerName.indexOf(targetName) > -1 ) {
				System.out.println("ShipInspectionHDReport 4-1. >>>>>>>>>> " );
				viewname = "shipinspectionreporthd";
			} else {
				System.out.println("ShipInspectionHDReport 4-2. >>>>>>>>>> " );
			}

			List<?> resultList = dao.list("report.ship.insp.hydrotek.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList = dao.list("report.ship.insp.hydrotek.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList);

			List<?> subList2 = dao.list("report.ship.insp.hydrotek.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SHIPINSNO", requestMap.get("SHIPINSNO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ShipInspectionHDReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 출하검사기준서(훌루테크㈜) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipInspectionFLReport.pdf")
	public ModelAndView ShipInspectionFLReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipInspectionFLReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("ShipInspectionFLReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));

			if (!searchOrgId.isEmpty()) {
				System.out.println("ShipInspectionFLReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));

			if (!searchCompanyId.isEmpty()) {
				System.out.println("ShipInspectionFLReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String ShipInsNo = StringUtil.nullConvert(requestMap.get("ShipInsNo"));

			if (!ShipInsNo.isEmpty()) {
				System.out.println("ShipInspectionFLReport 3. >>>>>>>>>> " + ShipInsNo);
				requestMap.put("SHIPINSNO", ShipInsNo);
			}
			
			System.out.println("ShipInspectionFLReport Middle. >>>>>>>>>> " + requestMap);
			
			String viewname = null;
			String CustomerName = StringUtil.nullConvert(requestMap.get("CustomerName"));
			System.out.println("ShipInspectionFLReport 4. >>>>>>>>>> " + CustomerName);
			String targetName = "훌루테크㈜";
			
			if ( CustomerName.indexOf(targetName) > -1 ) {
				System.out.println("ShipInspectionFLReport 4-1. >>>>>>>>>> " );
				viewname = "shipinspectionreportfl";
			} else {
				System.out.println("ShipInspectionFLReport 4-2. >>>>>>>>>> " );
			}
			
			List<?> resultList = dao.list("report.ship.insp.flutek.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList = dao.list("report.ship.insp.flutek.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList);

			List<?> subList2 = dao.list("report.ship.insp.flutek.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SHIPINSNO", requestMap.get("SHIPINSNO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ShipInspectionFLReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 출하검사기준서(기타) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ShipInspectionEtcReport.pdf")
	public ModelAndView ShipInspectionEtcReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ShipInspectionEtcReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("ShipInspectionEtcReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));

			if (!searchOrgId.isEmpty()) {
				System.out.println("ShipInspectionEtcReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));

			if (!searchCompanyId.isEmpty()) {
				System.out.println("ShipInspectionEtcReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String ShipInsNo = StringUtil.nullConvert(requestMap.get("ShipInsNo"));

			if (!ShipInsNo.isEmpty()) {
				System.out.println("ShipInspectionEtcReport 3. >>>>>>>>>> " + ShipInsNo);
				requestMap.put("SHIPINSNO", ShipInsNo);
			}
			String viewname = null;
			String CustomerName = StringUtil.nullConvert(requestMap.get("CustomerName"));

			viewname = "shipinspectionEtcreport";

			List<?> resultList = dao.list("report.ship.insp.doosan.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList = dao.list("report.ship.insp.doosan.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList);

			List<?> subList2 = dao.list("report.ship.insp.doosan.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SHIPINSNO", requestMap.get("SHIPINSNO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ShipInspectionReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 자주검사 체크시트 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/InspWorkCheckSheetReport.pdf")
	public ModelAndView InspWorkCheckSheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("InspWorkCheckSheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("InspWorkCheckSheetReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("InspWorkCheckSheetReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String searchfrom = StringUtil.nullConvert(requestMap.get("searchFrom"));
			if (!searchfrom.isEmpty()) {
				System.out.println("InspWorkCheckSheetReport 3. >>>>>>>>>> " + searchfrom);
				requestMap.put("SEARCHFROM", searchfrom);
			}

			String searchto = StringUtil.nullConvert(requestMap.get("searchTo"));
			if (!searchto.isEmpty()) {
				System.out.println("InspWorkCheckSheetReport 4. >>>>>>>>>> " + searchto);
				requestMap.put("SEARCHTO", searchto);
			}

			String searchCheckBig = StringUtil.nullConvert(requestMap.get("checkbig"));
			if (!searchCheckBig.isEmpty()) {
				System.out.println("InspWorkCheckSheetReport 5. >>>>>>>>>> " + searchCheckBig);
				requestMap.put("CHECKBIG", searchCheckBig);
			}


			String itemcode = StringUtil.nullConvert(requestMap.get("itemcode"));
			String routingid = StringUtil.nullConvert(requestMap.get("routingid"));
			String checkbig = StringUtil.nullConvert(requestMap.get("checkbig"));
			String workorderid = StringUtil.nullConvert(requestMap.get("workorderid"));
			String workorderseq = StringUtil.nullConvert(requestMap.get("workorderseq"));
			String employeeseq = StringUtil.nullConvert(requestMap.get("employeeseq"));
			
			System.out.println("InspWorkCheckSheetReport 2-2. >>>>>>>>>> " + itemcode);
			System.out.println("InspWorkCheckSheetReport 2-3. >>>>>>>>>> " + routingid);
			System.out.println("InspWorkCheckSheetReport 2-4. >>>>>>>>>> " + checkbig);
			System.out.println("InspWorkCheckSheetReport 2-5. >>>>>>>>>> " + workorderid);
			System.out.println("InspWorkCheckSheetReport 2-6. >>>>>>>>>> " + workorderseq);
			System.out.println("InspWorkCheckSheetReport 2-7. >>>>>>>>>> " + employeeseq);

			String[] itemcodeArray = itemcode.split(",");
			String[] routingidArray = routingid.split(",");
			String[] checkbigArray = checkbig.split(",");
			String[] workorderidArray = workorderid.split(",");
			String[] workorderseqArray = workorderseq.split(",");

			final int MaxCount = 10;
			int iCount = itemcodeArray.length;
			System.out.println("InspWorkCheckSheetReport 3-1. >>>>>>>>>> " + iCount);
			ArrayList<HashMap> resultList = new ArrayList<HashMap>();
			for (int i = 0 ; i < iCount ; i++ ) {
				requestMap.put("ITEMCODE", itemcodeArray[i]);
				requestMap.put("ROUTINGID", routingidArray[i]);
				requestMap.put("CHECKBIG", checkbigArray[i]);
				requestMap.put("WORKORDERID", workorderidArray[i]);
				requestMap.put("WORKORDERSEQ", workorderseqArray[i]);
				requestMap.put("EMPLOYEESEQ", employeeseq);
				
				// 1. 페이지 개수 확인
				List<?> checkList = dao.list("report.insp.work.check.sheet.list.select", requestMap);
				if ( checkList.size() > 0 ) {
					HashMap<String, Object> checkMap = (HashMap<String, Object>) checkList.get(0);
					
					int count = (StringUtil.nullConvert(checkMap.get("COUNT")).isEmpty()) ? 1 : NumberUtil.getInteger(checkMap.get("COUNT"));
					int maxcount = (int) Math.ceil((double) count / (double) 16);
					System.out.println("InspWorkCheckSheetReport maxcount. >>>>>>>>>> " + maxcount);

					final int PAGE_COUNT = 10;
					for (int j = 0 ; j < maxcount ; j++ ) {
						int colno = ( 16 * ( j + 1 ) ) - 15;
						requestMap.put("COLNO", colno );
						requestMap.put("PAGECNT", ( j + 1 ) );
						
						List<?> tempList = dao.list("report.insp.work.check.sheet.main.select", requestMap);
						System.out.println("InspWorkCheckSheetReport tempList.size() >>>>>>>>>> " + tempList.size());
						if ( tempList.size() > 0 ) {
							// 일단 10개까지 제한
							for ( int k = 0 ; k < PAGE_COUNT ; k++ ) {

								HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(k);
								resultList.add(list_temp);
							}
						}
					}
				}

			}
						
			System.out.println("InspWorkCheckSheetReport 2. >>>>>>>>>> " + resultList);

//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "inspworkchecksheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("ITEMCODE", requestMap.get("ITEMCODE"));
			mv.addObject("ROUTINGID", requestMap.get("ROUTINGID"));
			mv.addObject("CHECKBIG", requestMap.get("CHECKBIG"));
			mv.addObject("SEARCHFROM", requestMap.get("SEARCHFROM"));
			mv.addObject("SEARCHTO", requestMap.get("SEARCHTO"));
			mv.addObject("EQUIPMENTCODE", requestMap.get("EQUIPMENTCODE"));
			mv.addObject("WORKORDERID", requestMap.get("WORKORDERID"));
			mv.addObject("WORKORDERSEQ", requestMap.get("WORKORDERSEQ"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("InspWorkCheckSheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 자주검사 체크시트 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ProcCapaSheetReport.pdf")
	public ModelAndView ProcCapaSheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ProcCapaSheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("ProcCapaSheetReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("ProcCapaSheetReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String itemcode = StringUtil.nullConvert(requestMap.get("searchItemCode"));
			if (!itemcode.isEmpty()) {
				System.out.println("ProcCapaSheetReport 3. >>>>>>>>>> " + itemcode);
				requestMap.put("ITEMCODE", itemcode);
			}

			String checklistid = StringUtil.nullConvert(requestMap.get("searchCheckSmallCode"));
			if (!checklistid.isEmpty()) {
				System.out.println("ProcCapaSheetReport 4. >>>>>>>>>> " + checklistid);
				requestMap.put("CHECKLISTID", checklistid);
			}

			String searchfrom = StringUtil.nullConvert(requestMap.get("searchFrom"));
			if (!searchfrom.isEmpty()) {
				System.out.println("ProcCapaSheetReport 5. >>>>>>>>>> " + searchfrom);
				requestMap.put("SEARCHFROM", searchfrom);
			}

			String searchto = StringUtil.nullConvert(requestMap.get("searchTo"));
			if (!searchto.isEmpty()) {
				System.out.println("ProcCapaSheetReport 6. >>>>>>>>>> " + searchto);
				requestMap.put("SEARCHTO", searchto);
			}

			String checkbig = StringUtil.nullConvert(requestMap.get("searchCheckBig"));
			if (!checkbig.isEmpty()) {
				System.out.println("ProcCapaSheetReport 7. >>>>>>>>>> " + checkbig);
				requestMap.put("CHECKBIG", checkbig);
			}

			List<?> resultList = dao.list("report.proc.capa.worksheet.main.select", requestMap);
			
//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "proccapasheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", List);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("ITEMCODE", requestMap.get("ITEMCODE"));
			mv.addObject("CHECKLISTID", requestMap.get("CHECKLISTID"));
			mv.addObject("SEARCHFROM", requestMap.get("SEARCHFROM"));
			mv.addObject("SEARCHTO", requestMap.get("SEARCHTO"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ProcCapaSheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 자주검사 체크시트(scm의 외주공정검사) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ScmOutCheckSheetReport.pdf")
	public ModelAndView ScmOutCheckSheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ScmOutCheckSheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("ScmOutCheckSheetReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("ScmOutCheckSheetReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String inspectionplanno = StringUtil.nullConvert(requestMap.get("InspNo"));
			if (!inspectionplanno.isEmpty()) {
				System.out.println("ScmOutCheckSheetReport 5. >>>>>>>>>> " + inspectionplanno);
				requestMap.put("INSPECTIONPLANNO", inspectionplanno);
			}

			List<?> resultList = dao.list("report.scm.out.checksheet.report.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "scmoutchecksheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", resultList);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("INSPECTIONPLANNO", requestMap.get("INSPECTIONPLANNO"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ScmOutCheckSheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 자주검사 체크시트(scm의 자재수입검사) // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/ScmMatCheckSheetReport.pdf")
	public ModelAndView ScmMatCheckSheetReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("ScmMatCheckSheetReport Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("ScmMatCheckSheetReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("ScmMatCheckSheetReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String inspectionplanno = StringUtil.nullConvert(requestMap.get("InspNo"));
			if (!inspectionplanno.isEmpty()) {
				System.out.println("ScmMatCheckSheetReport 5. >>>>>>>>>> " + inspectionplanno);
				requestMap.put("INSPECTIONPLANNO", inspectionplanno);
			}

			List<?> resultList = dao.list("report.scm.mat.checksheet.report.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "scmmatchecksheetreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", resultList);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("INSPECTIONPLANNO", requestMap.get("INSPECTIONPLANNO"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("ScmMatCheckSheetReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * SPC 관리도 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/SPCControlChartReport.pdf")
	public ModelAndView SPCControlChartReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("SPCControlChartReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("SPCControlChartReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!orgid.isEmpty()) {
				System.out.println("SPCControlChartReport 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}

			String companyid = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!companyid.isEmpty()) {
				System.out.println("SPCControlChartReport 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}

			String itemcode = StringUtil.nullConvert(requestMap.get("searchItemCode"));
			if (!itemcode.isEmpty()) {
				System.out.println("SPCControlChartReport 3. >>>>>>>>>> " + itemcode);
				requestMap.put("ITEMCODE", itemcode);
			}

			String checklistid = StringUtil.nullConvert(requestMap.get("searchCheckSmallCode"));
			if (!checklistid.isEmpty()) {
				System.out.println("SPCControlChartReport 4. >>>>>>>>>> " + checklistid);
				requestMap.put("CHECKLISTID", checklistid);
			}

			String searchfrom = StringUtil.nullConvert(requestMap.get("searchFrom"));
			if (!searchfrom.isEmpty()) {
				System.out.println("SPCControlChartReport 5. >>>>>>>>>> " + searchfrom);
				requestMap.put("SEARCHFROM", searchfrom);
			}

			String searchto = StringUtil.nullConvert(requestMap.get("searchTo"));
			if (!searchto.isEmpty()) {
				System.out.println("SPCControlChartReport 6. >>>>>>>>>> " + searchto);
				requestMap.put("SEARCHTO", searchto);
			}

			String checkbig = StringUtil.nullConvert(requestMap.get("searchCheckBig"));
			if (!checkbig.isEmpty()) {
				System.out.println("SPCControlChartReport 7. >>>>>>>>>> " + checkbig);
				requestMap.put("CHECKBIG", checkbig);
			}

			List<?> resultList = dao.list("report.spc.control.chart.main.select", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList = dao.list("report.spc.control.chart.sub1.select", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList);

			List<?> subList2 = dao.list("report.spc.control.chart.sub2.select", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			String viewname = "spccontrolchartreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("ITEMCODE", requestMap.get("ITEMCODE"));
			mv.addObject("CHECKLISTID", requestMap.get("CHECKLISTID"));
			mv.addObject("SEARCHFROM", requestMap.get("SEARCHFROM"));
			mv.addObject("SEARCHTO", requestMap.get("SEARCHTO"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("SPCControlChartReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}

	/**
	 * 반출증 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/OutOrderReport.pdf")
	public ModelAndView OutOrderReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("OutOrderReport Start. >>>>>>>>>> " + requestMap);
		try {
			String pono = StringUtil.nullConvert(requestMap.get("PoNo"));
			if (!pono.isEmpty()) {
				System.out.println("OutOrderReport 1. >>>>>>>>>> " + pono);
			}

			List<?> resultList = dao.list("report.outside.order.select", requestMap);

			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			//			JRDataSource List = new JRBeanCollectionDataSource(resultList);

			String viewname = "outorderreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("PONO", requestMap.get("PoNo"));
			mv.addObject("ORGID", requestMap.get("searchOrgId"));
			mv.addObject("COMPANYID", requestMap.get("searchCompanyId"));
			
			

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("OutOrderReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	
	
	
	/**
	 * 19.06.26
	 * 업체별 외주가공비집계
	 * 
	 * */
	@RequestMapping(value = "/report/CostStdPoPerforList.pdf") 
	public ModelAndView CostStdPoPerforList(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("CostStdPoPerforList Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			String companyid  = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			String searchyear = StringUtil.nullConvert(requestMap.get("searchYear"));
		
			if (!orgid.isEmpty()) {
				System.out.println("CostStdPoPerforList 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			
			if (!companyid.isEmpty()) {
				System.out.println("CostStdPoPerforList 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			
			if (!searchyear.isEmpty()) {
				System.out.println("CostStdPoPerforList 3. >>>>>>>>>> " + searchyear);
				requestMap.put("SEARCHYEAR", searchyear);
			}

			
			List<?> resultList = dao.list("report.CostPo.customer.list", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "monthlycostporeport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("CostStdPoPerforList EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	
	/**
	 * 
	 * 19.06.25
	 * (월별,년도별)매출실적
	 * */
	@RequestMapping(value = "/report/CostStdSalesPerforList.pdf")
	public ModelAndView CostStdSalesPerforList(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("CostStdSalesPerforList Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			String companyid  = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			String searchyear = StringUtil.nullConvert(requestMap.get("searchYear"));
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("SPCControlChartReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
			if (!orgid.isEmpty()) {
				System.out.println("CostStdSalesPerforList 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			
			if (!companyid.isEmpty()) {
				System.out.println("CostStdSalesPerforList 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			
			if (!searchyear.isEmpty()) {
				System.out.println("CostStdSalesPerforList 3. >>>>>>>>>> " + searchyear);
				requestMap.put("SEARCHYEAR", searchyear);
			}

//			List<?> resultList = dao.list("report.outside.order.select", requestMap);
//
//			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);
			//			JRDataSource List = new JRBeanCollectionDataSource(resultList);
			
			List<?> resultList = dao.list("report.CostStdSales.PerforList.main", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.CostStdSales.PerforList.sub1", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);
			
			List<?> subList2 = dao.list("report.CostStdSales.PerforList.sub2", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);
			
			List<?> subList3 = dao.list("report.CostStdSales.PerforList.sub3", requestMap);
			JRBeanCollectionDataSource src3 = new JRBeanCollectionDataSource(subList3);
			
			List<?> subList4 = dao.list("report.CostStdSales.PerforList.sub4", requestMap);
			JRBeanCollectionDataSource src4 = new JRBeanCollectionDataSource(subList4);
			

			
			
			String viewname = "monthlycostreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			mv.addObject("subdata3", src3);
			mv.addObject("subdata4", src4);
			

			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));
			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("CostStdSalesPerforList EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	
	
	/**
	 * 
	 * 19.06.27
	 * 품목별 매출실적
	 * */
	@RequestMapping(value = "/report/CostStdSalesPerforItemList.pdf")
	public ModelAndView CostStdSalesPerforItemList(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("CostStdSalesPerforItemList Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			String companyid  = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			String searchyear = StringUtil.nullConvert(requestMap.get("searchYear"));
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("CostStdSalesPerforItemList 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}
			if (!orgid.isEmpty()) {
				System.out.println("CostStdSalesPerforItemList 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			
			if (!companyid.isEmpty()) {
				System.out.println("CostStdSalesPerforItemList 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			
			if (!searchyear.isEmpty()) {
				System.out.println("CostStdSalesPerforItemList 3. >>>>>>>>>> " + searchyear);
				requestMap.put("SEARCHYEAR", searchyear);
			}

			List<?> resultList = dao.list("report.CostStdSales.PerforList.item.main", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.CostStdSales.PerforList.item.sub1", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);
			
			List<?> subList2 = dao.list("report.CostStdSales.PerforList.item.sub2", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);
			
			String viewname = "yearlyitemcostreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			

			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));
			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("CostStdSalesPerforItemList EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	
	
	/**
	 * 19.06.26
	 * 업체별 외주가공비집계
	 * 
	 * */
	@RequestMapping(value = "/report/CostStdPerforDetailList.pdf") 
	public ModelAndView CostStdPerforDetailList(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("CostStdPerforDetailList Start. >>>>>>>>>> " + requestMap);
		try {
			String orgid = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			String companyid  = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			String searchyear = StringUtil.nullConvert(requestMap.get("searchYear"));
		
			if (!orgid.isEmpty()) {
				System.out.println("CostStdPerforDetailList 1. >>>>>>>>>> " + orgid);
				requestMap.put("ORGID", orgid);
			}
			
			if (!companyid.isEmpty()) {
				System.out.println("CostStdPerforDetailList 2. >>>>>>>>>> " + companyid);
				requestMap.put("COMPANYID", companyid);
			}
			
			if (!searchyear.isEmpty()) {
				System.out.println("CostStdPerforDetailList 3. >>>>>>>>>> " + searchyear);
				requestMap.put("SEARCHYEAR", searchyear);
			}

			
			List<?> resultList = dao.list("report.CostStdSales.Perfor.Detail.list", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			String viewname = "monthlycostDetailreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("CostStdPerforDetailList EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 매출매입현황 종합요약 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/EisSynthesisSummaryReport.pdf")
	public ModelAndView EisSynthesisSummaryReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("EisSynthesisSummaryReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("EisSynthesisSummaryReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("EisSynthesisSummaryReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("EisSynthesisSummaryReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchDate = StringUtil.nullConvert(requestMap.get("searchYear"));
			if (!searchDate.isEmpty()) {
				System.out.println("EisSynthesisSummaryReport 3. >>>>>>>>>> " + searchDate);
				requestMap.put("SEARCHYEAR", searchDate);
			}

			List<?> resultList = dao.list("report.eis.synthesis.summary.main.list", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			List<?> subList1 = dao.list("report.eis.synthesis.summary.sub1.list", requestMap);
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);

			List<?> subList2 = dao.list("report.eis.synthesis.summary.sub2.list", requestMap);
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			List<?> subList3 = dao.list("report.eis.synthesis.summary.sub3.list", requestMap);
			JRBeanCollectionDataSource src3 = new JRBeanCollectionDataSource(subList3);

			List<?> subList4 = dao.list("report.eis.synthesis.summary.sub4.list", requestMap);
			JRBeanCollectionDataSource src4 = new JRBeanCollectionDataSource(subList4);
			
			String viewname = "eissynthesissummaryreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			mv.addObject("subdata3", src3);
			mv.addObject("subdata4", src4);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("EisSynthesisSummaryReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
	
	/**
	 * 월별/년도별 매출실적 // Report 출력
	 * 
	 * @return String
	 * @exception Exception
	 */
	@RequestMapping(value = "/report/EisMonthlyYearSalesResultReport.pdf")
	public ModelAndView EisMonthlyYearSalesResultReport(HttpServletRequest request, @RequestParam HashMap<String, Object> requestMap, ModelMap model) throws Exception {
		long s_time = System.currentTimeMillis();
		ModelAndView mv = new ModelAndView();

		System.out.println("EisMonthlyYearSalesResultReport Start. >>>>>>>>>> " + requestMap);
		try {
			String path = super.propertiesService.getString("Globals.reportAbsolutePath");
			if (!path.isEmpty()) {
				System.out.println("EisMonthlyYearSalesResultReport 0. >>>>>>>>>> " + path);
				requestMap.put("SUBDIR", path);
			}

			String searchOrgId = StringUtil.nullConvert(requestMap.get("searchOrgId"));
			if (!searchOrgId.isEmpty()) {
				System.out.println("EisMonthlyYearSalesResultReport 1. >>>>>>>>>> " + searchOrgId);
				requestMap.put("ORGID", searchOrgId);
			}

			String searchCompanyId = StringUtil.nullConvert(requestMap.get("searchCompanyId"));
			if (!searchCompanyId.isEmpty()) {
				System.out.println("EisMonthlyYearSalesResultReport 2. >>>>>>>>>> " + searchCompanyId);
				requestMap.put("COMPANYID", searchCompanyId);
			}

			String searchDate = StringUtil.nullConvert(requestMap.get("searchYear"));
			if (!searchDate.isEmpty()) {
				System.out.println("EisMonthlyYearSalesResultReport 3. >>>>>>>>>> " + searchDate);
				requestMap.put("SEARCHYEAR", searchDate);
			}
			
			List<?> resultList = dao.list("report.eis.monthlyyear.sales.result.main.list", requestMap);
			JRBeanCollectionDataSource src = new JRBeanCollectionDataSource(resultList);

			
			final int PAGE_CNT = 5;
			List<?> count = dao.list("report.eis.monthlyyear.sales.result.sub1.count", requestMap);
			int resultCount = (Integer) count.get(0);
			if (resultCount>5)
			requestMap.put("COUNT", resultCount);
			
			List<?> tempList = dao.list("report.eis.monthlyyear.sales.result.sub1.list", requestMap);
			
			ArrayList<HashMap> subList1 = new ArrayList<HashMap>();
			for ( int l = 0 ; l < 5 ; l++ ) {
                if(l < resultCount){
                   HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList.get(l);
                   
                   subList1.add(list_temp);
                } else {
                   HashMap<String, Object> list_temp = new HashMap<String,Object>();

                   subList1.add(list_temp);
                }
			}
			JRBeanCollectionDataSource src1 = new JRBeanCollectionDataSource(subList1);
			
			

			List<?> tempList2 = dao.list("report.eis.monthlyyear.sales.result.sub2.list", requestMap);
			
			ArrayList<HashMap> subList2 = new ArrayList<HashMap>();
			for ( int l = 0 ; l < 5 ; l++ ) {
                  if(l < resultCount){
                     HashMap<String, Object> list_temp = (HashMap<String, Object>) tempList2.get(l);
                     
                     subList2.add(list_temp);
                  } else {
                     HashMap<String, Object> list_temp = new HashMap<String,Object>();

                     subList2.add(list_temp);
                  }
			}
			
			JRBeanCollectionDataSource src2 = new JRBeanCollectionDataSource(subList2);

			List<?> subList3 = dao.list("report.eis.monthlyyear.sales.result.sub3.list", requestMap);
			JRBeanCollectionDataSource src3 = new JRBeanCollectionDataSource(subList3);

			List<?> subList4 = dao.list("report.eis.monthlyyear.sales.result.sub4.list", requestMap);
			JRBeanCollectionDataSource src4 = new JRBeanCollectionDataSource(subList4);
			
			String viewname = "eismonthlyyearsalesresultreport";
			String format = "pdf";

			mv.setViewName(viewname);
			mv.addObject("format", format);
			mv.addObject("datasource", src);
			mv.addObject("subdata1", src1);
			mv.addObject("subdata2", src2);
			mv.addObject("subdata3", src3);
			mv.addObject("subdata4", src4);

			mv.addObject("ORGID", requestMap.get("ORGID"));
			mv.addObject("COMPANYID", requestMap.get("COMPANYID"));
			mv.addObject("SEARCHYEAR", requestMap.get("SEARCHYEAR"));
			mv.addObject("SUBDIR", requestMap.get("SUBDIR"));

		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("EisMonthlyYearSalesResultReport EndTime >>>>>>>>>> " + ((System.currentTimeMillis() - s_time) / 1000.0) + "초");
		return mv;
	}
}