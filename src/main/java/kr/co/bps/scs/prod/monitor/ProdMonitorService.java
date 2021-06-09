package kr.co.bps.scs.prod.monitor;

import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : ProdMonitorService.java
 * @Description : ProdMonitor Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 07.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdMonitorService extends BaseService {
	/**
	 * X 차트로 보여줄 자주 검사 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectXChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectXChartList >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.chart.xchart.select", params);
	}

	/**
	 * X 차트로 보여줄 자주 검사 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectXChartCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.chart.xchart.count", params);
	}
	
	/**
	 * R 차트로 보여줄 자주 검사 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectRChartList(Map<String, Object> params) throws Exception {
		System.out.println("selectRChartList >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.chart.rchart.select", params);
	}

	/**
	 * R 차트로 보여줄 자주 검사 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectRChartCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.chart.rchart.count", params);
	}

	/**
	 * 검사내역 결과를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectTotalList(Map<String, Object> params) throws Exception {
		System.out.println("selectTotalList >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.spc.total.select", params);
	}

	/**
	 * 검사내역 결과 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectTotalCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.spc.total.count", params);
	}
	
	/**
	 * SPC 검사 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSPCList(Map<String, Object> params) throws Exception {
		System.out.println("selectSPCList >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.chart.fml.list.select", params);
	}

	/**
	 * SPC 검사 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSPCCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.chart.fml.list.count", params);
	}

	/**
	 * SPC Dummy 검사 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSPCDummyList(Map<String, Object> params) throws Exception {
		System.out.println("selectSPCDummyList >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.chart.dummy.list.select", params);
	}

	/**
	 * SPC Dummy 검사 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSPCDummyCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.chart.dummy.list.count", params);
	}
	

	/**
	 * 공정 LOT 화면 목록을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitor3WorkList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WorkList Start. >>>>>>>>>> " + params);

		return dao.list("work.monitor.work.list.select", params);
	}
	
	/**
	 * 공정 LOT 화면 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitor3WorkCount(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WorkCount Start. >>>>>>>>>> " + params);

		int work = (int) dao.selectByIbatis("work.monitor.work.list.count", params);

		return work;
	}

	/**
	 * 자재 LOT 화면 목록을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitor3TransList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3TransList Start. >>>>>>>>>> " + params);

		return dao.list("work.monitor.trans.list.select", params);
	}
	
	/**
	 * 자재 LOT 화면 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitor3TransCount(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3TransCount Start. >>>>>>>>>> " + params);

		int work = (int) dao.selectByIbatis("work.monitor.trans.list.count", params);

		return work;
	}

	/**
	 * 출하 LOT 화면 목록을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitor3WarehousingList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WarehousingList Start. >>>>>>>>>> " + params);

		return dao.list("work.monitor.warehousing.list.select", params);
	}
	
	/**
	 * 출하 LOT 화면 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitor3WarehousingCount(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitor3WarehousingCount Start. >>>>>>>>>> " + params);

		int work = (int) dao.selectByIbatis("work.monitor.warehousing.list.count", params);

		return work;
	}

	
	/**
	 * 1페이지 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitorPage1List(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitorPage1List >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.monitor.page1.select", params);
	}

	/**
	 * 1페이지 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitorPage1Count(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.monitor.page1.count", params);
	}

	/**
	 * 2페이지 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitorPage2List(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitorPage2List >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.monitor.page2.select", params);
	}

	/**
	 * 2페이지 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitorPage2Count(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.monitor.page2.count", params);
	}

	/**
	 * 3페이지 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitorPage3List(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitorPage3List >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.monitor.page3.select", params);
	}

	/**
	 * 3페이지 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitorPage3Count(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.monitor.page3.count", params);
	}

	/**
	 * 변경 > 3페이지 내역을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdMonitorPage3ListAggList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdMonitorPage3List >>>>>>>>>>");

		return dao.selectListByIbatis("work.order.monitor.page3.listagg.select", params);
	}

	/**
	 * 변경 > 3페이지 내역 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdMonitorPage3ListAggCount(Map<String, Object> params) throws Exception {
		return (int) dao.select("work.order.monitor.page3.listagg.count", params);
	}
	
}