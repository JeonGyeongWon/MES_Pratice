package kr.co.bps.scs.eis;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : EisService.java
 * @Description : Eis Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2020. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class EisService extends BaseService {
	/**
	 * 매출 및 매입현황 종합요약 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSynthesisSummaryList(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.synthesis.summary.list.select", params);
	}

	/**
	 * 매출 및 매입현황 종합요약 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSynthesisSummaryCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.synthesis.summary.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매출 // 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSynthesisSummaryChart1List(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryChart1List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.synthesis.summary.chart1.select", params);
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매출 // 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSynthesisSummaryChart1Count(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.synthesis.summary.chart1.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매입 // 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSynthesisSummaryChart2List(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryChart2List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.synthesis.summary.chart2.select", params);
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매입 // 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSynthesisSummaryChart2Count(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.synthesis.summary.chart2.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매입 비율 // 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSynthesisSummaryChart3List(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryChart3List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.synthesis.summary.chart3.select", params);
	}

	/**
	 * 매출 및 매입현황 종합요약 > 매입 비율 // 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSynthesisSummaryChart3Count(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.synthesis.summary.chart3.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 품목군 별 매입집계 현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemPurSummaryList(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.pur.summary.list.select", params);
	}

	/**
	 * 품목군 별 매입집계 현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemPurSummaryCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.pur.summary.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 품목군 별 매입집계 현황 // 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemPurSummaryChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisItemPurSummaryChart3List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.pur.summary.chart.select", params);
	}

	/**
	 * 품목군 별 매입집계 현황 // 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemPurSummaryChartCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.pur.summary.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 품목별 매출 실적현황 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemSalesResultList(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.sales.result.list.select", params);
	}

	/**
	 * 품목별 매출 실적현황 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemSalesResultListCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.sales.result.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 품목군 별 매입집계 현황 // 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemSalesResultChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisItemPurSummaryChart3List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.sales.result.chart.select", params);
	}

	/**
	 * 품목군 별 매입집계 현황 // 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemSalesResultChartCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.sales.result.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 품목/기종별 매출수량 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemModelSalesList(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.model.sales.list.select", params);
	}

	/**
	 * 품목/기종별 매출수량 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemModelSalesCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.model.sales.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 품목/기종별 매출수량 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisItemModelSalesChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisItemModelSalesChartList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.item.model.sales.chart.select", params);
	}

	/**
	 * 품목/기종별 매출수량 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisItemModelSalesChartCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.item.model.sales.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 업체별 매출 실적현황을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> EisCustSalesResultList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisCustSalesResultList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.cust.sales.result.list.select", params);
	}

	/**
	 * 업체별 매출 실적현황 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int EisCustSalesResultListCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.cust.sales.result.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 월별/년도별 매출 실적 그리드1 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMonthlyYearSalesResultList(Map<String, Object> params) throws Exception {
		System.out.println("selectSynthesisSummaryList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.monthly.year.sales.result.list1.select", params);
	}

	/**
	 * 월별/년도별 매출 실적 그리드1 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMonthlyYearSalesResultCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.monthly.year.sales.result.list1.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 월별/년도별 매출 실적 그리드2 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMonthlyYearSalesResultList2(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMonthlyYearSalesResultList2 Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.monthly.year.sales.result.list2.select", params);
	}

	/**
	 * 월별/년도별 매출 실적 그리드2 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMonthlyYearSalesResultCount2(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.monthly.year.sales.result.list2.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 월별/년도별 매출 실적 차트 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMonthlyYearSalesResultChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMonthlyYearSalesResultChartList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.sales.result.monthly.chart.select", params);
	}

	/**
	 * 월별/년도별 매출 실적 차트 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMonthlyYearSalesResultChartCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.sales.result.monthly.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 월별/년도별 매출 실적 차트2 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMonthlyYearSalesResultChart2List(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMonthlyYearSalesResultChart2List Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.sales.result.year.chart.select", params);
	}

	/**
	 * 월별/년도별 매출 실적 차트2 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMonthlyYearSalesResultChart2Count(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.sales.result.year.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 경영자정보 (모바일) // 년도별 매출실적 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMobileTab1YearList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMobileTab1YearList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.mobile.tab1.year.chart.select", params);
	}

	/**
	 * 경영자정보 (모바일) // 년도별 매출실적 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMobileTab1YearCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.mobile.tab1.year.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 경영자정보 (모바일) // 월별 매출실적 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMobileTab1MonthlyList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMobileTab1MonthlyList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.mobile.tab1.monthly.chart.select", params);
	}

	/**
	 * 경영자정보 (모바일) // 월별 매출실적 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMobileTab1MonthlyCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.mobile.tab1.monthly.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMobileTab3MonthlyList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMobileTab3MonthlyList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.mobile.tab3.monthly.chart.select", params);
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMobileTab3MonthlyCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.mobile.tab3.monthly.chart.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectEisMobileTab3MonthlyGridList(Map<String, Object> params) throws Exception {
		System.out.println("selectEisMobileTab3MonthlyGridList Service. >>>>>>>>>> " + params);

		return dao.selectListByIbatis("eis.mobile.tab3.monthly.list.select", params);
	}

	/**
	 * 경영자정보 (모바일) // 월별 생산실적 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectEisMobileTab3MonthlyGridCount(Map<String, Object> params) throws Exception {
		List<?> count = dao.list("eis.mobile.tab3.monthly.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
}