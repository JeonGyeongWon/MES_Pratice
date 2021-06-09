package kr.co.bps.scs.cost.std;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * @ClassName : CostStdService.java
 * @Description : CostStd Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha
 * @since 2017. 03.
 * @modify 2018. 02.
 * @version 1.0
 * @see
 */
@Transactional
@Service
public class CostStdService extends BaseService {

	/**
	 * 2017.03.27 매출현황 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdSalesList(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdSalesList Start. >>>>>>>>>> " + params);
		return dao.list("cost.std.sales.master.list.select", params);
	}

	/**
	 * 2017.03.27 매출현황 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdSalesListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.sales.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.03.27 매출현황 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdSalesLine(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdSalesLine Start. >>>>>>>>>> " + params);
		return dao.list("cost.std.sales.line.list.select", params);
	}

	/**
	 * 2017.03.27 매출현황 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdSalesLineCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.sales.line.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2017.03.28 매출현황상세 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdSalesListDetail(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdSalesListDetail params. >>>>>>>>>> " + params);
		return dao.list("cost.std.sales.detail.list.select", params);
	}

	/**
	 * 2017.03.2 매출현황상세 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdSalesListDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.sales.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.03.29 매입현황 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdPoList(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdPoList Start. >>>>>>>>>> " + params);
		return dao.list("cost.std.polist.select", params);
	}

	/**
	 * 2017.03.29 매입현황 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdPoListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.polist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	// A/S등록관리의 첫번째 항목 조회
	public String selectCostStdPoFirstList(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("cost.std.polist.first.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap.isEmpty() == true) {
			result = null;
		} else {
			String[] customercode = FirstListMap.get("CUSTOMERCODE").toString().split(",");

			result = customercode[0].toString();
		}

		return result;
	}

	/**
	 * 2017.03.29 매입현황상세 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdPoListDetail(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdPoListDetail params. >>>>>>>>>> " + params);
		return dao.list("cost.std.polistdetail.select", params);
	}

	/**
	 * 2017.03.29 매입현황상세 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdPoListDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.polistdetail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 매출 집계 리스트를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSalesTotalList(Map<String, Object> params) throws Exception {

		System.out.println("selectSalesTotalList params. >>>>>>>>>> " + params);
		return dao.list("cost.std.sales.list.total.select", params);
	}

	/**
	 * 매출 집계 리스트 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSalesTotalCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.sales.list.total.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 거래처별 매입집계 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectCostStdPoTotalList(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdPoTotalList params. >>>>>>>>>> " + params);
		return dao.list("cost.std.po.list.total.select", params);
	}

	/**
	 * 거래처별 매입집계 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectCostStdPoTotalTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("cost.std.po.list.total.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 매입현황 회계I/F 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> selectCostStdPoIFList(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdPoIFList Start. >>>>>>>>>> " + params);
		return dao.list("cost.std.poiflist.select", params);
	}
	
	/**
	 * 매출현황 회계I/F 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public List<?> selectCostStdSalesIFList(Map<String, Object> params) throws Exception {

		System.out.println("selectCostStdSalesIFList Start. >>>>>>>>>> " + params);
		return dao.list("cost.std.salesiflist.select", params);
	}
}