package kr.co.bps.scs.prod.insp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.NumberUtil;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : MatProdService.java
 * @Description : MatProd Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark
 * @since 2017. 03.
 * @modify 2017. 03.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class InspProdService extends BaseService {

	/**
	 * 조회 부분에 부적합품등록 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectInspProdList(Map<String, Object> params) throws Exception {

		return dao.list("prod.insp.list.select", params);
	}

	/**
	 * 조회 부분에 부적합품등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectInspProdCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.insp.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 부적합품등록 첫번째 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectInspProdFirstList1(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("prod.insp.firstlist.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] workorderid = FirstListMap.get("WORKORDERID").toString().split(",");

			result = workorderid[0].toString();
		}

		return result;
	}
	
	/**
	 * 조회 부분에 부적합품등록 첫번째 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectInspProdFirstList2(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("prod.insp.firstlist.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] workorderseq = FirstListMap.get("WORKORDERSEQ").toString().split(",");

			result = workorderseq[0].toString();
		}

		return result;
	}
	
	/**
	 * 조회 부분에 부적합품등록 첫번째 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectInspProdFirstList3(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("prod.insp.firstlist.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] employeeseq = FirstListMap.get("EMPLOYEESEQ").toString().split(",");

			result = employeeseq[0].toString();
		}

		return result;
	}
	
	/**
	 * 조회 부분에 부적합품등록 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectInspProdDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.insp.detail.select", params);
	}

	/**
	 * 조회 부분에 부적합품등록 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectInspProdDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.insp.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.03.08 부적합품등록 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertProdInsNonConfirmRegist(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		System.out.println("insert params >>>>>>>>>> " + params);

		int errcnt = 0;
		String ncrno = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			List woList = dao.selectListByIbatis("prod.insp.new.ncrno.select", master);
			Map<String, Object> woMap = (Map<String, Object>) woList.get(0);
			ncrno = (String) woMap.get("NCRNO");
			master.put("NCRNO", ncrno);

			master.put("REGISTID", login.getId());

			System.out.println("insert master >>>>>>>>>> " + master);

			int updateResult = dao.update("prod.insp.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_NCR fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "insert");
	}

	/**
	 * 2017.03.08 부적합품 등록 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateProdInsNonConfirmRegist(Map<String, Object> params) throws Exception {

		System.out.println("updateProdInsNonConfirmRegist Service Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			Object Check = master.get("CHK");
			System.out.println("updateProdInsNonConfirmRegist chk. >>>>>>>>>> " + Check);
			
			if(Check != null) {
				boolean chk = (boolean) master.get("CHK");
				System.out.println("updateProdInsNonConfirmRegist chk. >>>>>>>>>> " + chk);

				if (chk) {
					// 1. 선택된 항목이 있을 경우에 한하여 재작업지시 TEMP 유무 확인
					List<?> checkList = dao.selectListByIbatis("prod.insp.work.order.find.select", master);
					Map<String, Object> checkMap = (Map<String, Object>) checkList.get(0);
					Integer count = NumberUtil.getInteger(checkMap.get("COUNT"));
					System.out.println("updateProdInsNonConfirmRegist count. >>>>>>>>>> " + count);

					if (count == 0) {
						// 2. 재작업지시 미등록시 TEMP에 해당 내역 저장
						master.put("REGISTID", login.getId());

						int insertResult = dao.update("prod.insp.work.order.insert", master);
						if (insertResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_NCR_WORK_ORDER fail.");
						}
					}
				}
			}

			String ncrresult = StringUtil.nullConvert(master.get("NCRRESULT"));
			if ( ncrresult.equals("B") ) {
				// 특채를 선택하였을 경우
				Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
				Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
				String ncrno = String.valueOf(master.get("NCRNO"));
				Integer qty = NumberUtil.getInteger(master.get("NCRQTY"));
				Integer oldqty = NumberUtil.getInteger(master.get("OLDNCRQTY"));

				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("NCRNO", ncrno);
				params.put("NCRQTY", qty);
				params.put("OLDNCRQTY", oldqty);
				params.put("REGISTID", login.getId());
				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");
				System.out.println("부적합품 데이터 복사 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("prod.insp.ncr.copy.call.Procedure", params);
				System.out.println("부적합품 데이터 복사 PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status1 = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status1.equals("S")) {
					errcnt++;
					throw new Exception("call CB_MFG_PKG.CB_NCR_COPY FAIL.");
				}

			} else {
				master.put("UPDATEID", login.getId());

				int updateResult = dao.update("prod.insp.update", master);
				if (updateResult == 0) {
					errcnt++;
					throw new Exception("update CB_NCR fail.");
				}
			}
		}

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 재작업지시 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> callReWorkOrderCreate(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		try {
			params.put("REGISTID", login.getId());
			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");
			System.out.println("재작업지시 생성 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("prod.insp.work.order.create.call.Procedure", params);
			System.out.println("재작업지시 생성 PROCEDURE 호출 End.  >>>>>>>> " + params);

			String status1 = StringUtil.nullConvert(params.get("RETURNSTATUS"));
			if (!status1.equals("S")) {
				errcnt++;
				throw new Exception("call CB_MFG_PKG.CB_WORK_ORDER_CREATE_R FAIL.");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		return params;
	}

	/**
	 * 2017.03.08 부적합품 등록 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteProdInsNonConfirmRegist(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			System.out.println("delete CB_NCR >>>>>>>>>> " + master);

			int updateResult = dao.update("prod.insp.delete", master);
			if (updateResult == 0) {
				errcnt++;
				throw new Exception("delete CB_NCR fail.");
			}
		}

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 2017.03.08 그리드 부분의 아이템(재고) 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> searchItemLovList(Map<String, Object> params) throws Exception {

		return dao.list("prod.insp.item.lov.select", params);
	}

	/**
	 * 2017.03.08 그리드 부분의 아이템(재고) 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int searchItemLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.insp.item.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.03.08 조회조건 lov // 조회 항목 부적합품번호 LOV를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> searchNcrNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("prod.insp.list.select", params);
	}

	/**
	 * 2017.03.08 조회조건 lov // 조회 항목 부적합품번호 LOV를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int searchNcrNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.insp.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 부적합품 등록의 엑셀(불량유형현황) 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectInspProdExcelList(Map<String, Object> params) throws Exception {

		return dao.list("prod.insp.excellist.select", params);
	}

	/**
	 * 부적합 집계 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectIncTotalList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.total.select", params);
	}

	/**
	 * 부적합 집계 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectIncTotalCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.total.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 부적합 불량수량 집계 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdIncTotalChartList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.total.chart.select", params);
	}

	/**
	 * 부적합 불량수량 집계 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdIncTotalChartCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.total.chart.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 부적합 불량수량 집계 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdIncDetailChartList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.detail.chart.select", params);
	}

	/**
	 * 부적합 불량수량 집계 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdIncDetailChartCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.detail.chart.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 부적합 상세내역 팝업 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdIncDetailPopupList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.detail.popup.select", params);
	}

	/**
	 * 부적합 상세내역 팝업 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdIncDetailPopupCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.detail.popup.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
		
	/**
	 * 부적합 상세내역 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdIncDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.detail.select", params);
	}

	/**
	 * 부적합 상세내역 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdIncDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 불량현황의 KPI 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectFaultStatusKpiList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.fault.kpi.select", params);
	}

	/**
	 * 불량현황의 KPI 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectFaultStatusKpiCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.fault.kpi.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 불량현황 리스트 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectFaultStatusList(Map<String, Object> params) throws Exception {

		return dao.list("prod.inc.fault.list.select", params);
	}

	/**
	 * 불량현황의 리스트 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectFaultStatusCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.inc.fault.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}