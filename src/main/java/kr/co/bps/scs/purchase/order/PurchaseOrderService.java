package kr.co.bps.scs.purchase.order;

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
 * @ClassName : PurchaseOrderService.java
 * @Description : PurchaseOrder Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jshwang
 * @since 2017. 01.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class PurchaseOrderService extends BaseService {
	/**
	 * 구매발주조회 마스터 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectPurchaseOrderList(Map<String, Object> params) throws Exception {

		return dao.list("purchase.order.master.list.select", params);
	}

	/**
	 * 구매발주조회 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectPurchaseOrderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.order.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	

	/**
	 * 구매발주조회 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectPurchaseOrderDetailList(Map<String, Object> params) throws Exception {

		return dao.list("purchase.order.detail.list.select", params);
	}

	/**
	 * 구매발주조회 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectPurchaseOrderDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.order.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	
	/**
	 * 구매발주조회
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertPurchaseOrderMasterList(HashMap<String, Object> params) throws Exception {

		String pono = null;
		try {
			String PoNo = StringUtil.nullConvert(params.get("PONO"));
			if ( !PoNo.isEmpty() ) {
				pono = PoNo;
			} else {
				// 발주 구분 : D
				params.put("USEDIV", "D");
				List ponoList = dao.selectListByIbatis("purchase.order.po.new.pono.select", params);
				Map<String, Object> current = (Map<String, Object>) ponoList.get(0);
				params.put("PoNo", current.get("PONO"));
				pono = (String) current.get("PONO");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			master.put("PoNo", pono);
			System.out.println("Purchase Order No >>>>>>>>>> " + pono);

			int updateResult = dao.update("purchase.order.po.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_ORDER_H fail.");
			}
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
	 * 구매발주조회 상세 데이터 생성
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertPurchaseOrderDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertPurchaseOrderDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertPurchaseOrderDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			System.out.println("insertPurchaseOrderDetailList 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());

//				master.put("ORDERFINISHYN", "N");

				String source = StringUtil.nullConvert(master.get("DUEDATE"));
				String[] sList = source.split("T");
				
				master.put("DUEDATE", sList[0]);
				
				int updateResult = dao.update("purchase.order.po.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_ORDER_D fail.");
				}
			}

			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}
			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 구매발주 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatePurchaseOrderMasterList(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", loginVO.getId());

			int updateResult = dao.update("purchase.order.po.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_ORDER_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		return params;
	}

	/**  
	 * 구매발주 상태변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> changePurchaseOrderStatus(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", loginVO.getId());
			String changestatus = StringUtil.nullConvert(master.get("CHANGESTATUS"));
			master.put("CONFIRMSTATUS", changestatus);

			int updateResult = dao.update("purchase.order.header.status.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_ORDER_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		return params;
	}
	
	/**
	 * 구매발주 상세 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatePurchaseOrderDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updatePurchaseOrderDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("updatePurchaseOrderDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updatePurchaseOrderDetailList 3. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				// pono 등록유무 확인
				List ponoList = dao.selectListByIbatis("purchase.order.po.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) ponoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updatePurchaseOrderDetailList poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());
					
					String source = StringUtil.nullConvert(master.get("DUEDATE"));
					String[] sList = source.split("T");
					
					master.put("DUEDATE", sList[0]);
					
					int updateResult = dao.update("purchase.order.po.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_ORDER_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					String source = StringUtil.nullConvert(master.get("DUEDATE"));
					String[] sList = source.split("T");
					
					master.put("DUEDATE", sList[0]);
					
					int updateResult = dao.update("purchase.order.po.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_ORDER_D fail.");
					}
				}
			}

			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}

			params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}
	
	/** 2017.01.23 
	 * 구매발주 상세 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deletePurchaseOrderListDetail(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			int updateResult = dao.delete("purchase.order.po.detail.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_ORDER_D fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}
	
	/**
	 * 구매발주 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deletePurchaseOrderRegistList(HashMap<String, Object> params) throws Exception {

		System.out.println("deletePurchaseOrderRegistList Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();
			master.put("REGISTID", loginVO.getId());

			int updateResult = dao.delete("purchase.order.po.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_PURCHASE_H fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}

	/** 2017.02.23
	 *구매발주 화면에서 요청서불러오기 // POPUP LIST 를 호출한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> PurchaseOrderPop1List(Map<String, Object> params) throws Exception {

		return dao.list("purchase.order.list.pop1.select", params);
	}

	/**2017.02.23
	 *구매발주 화면에서 요청서불러오기 // POPUP LIST  총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int PurchaseOrderPop1TotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.order.list.pop1.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 구매발주의 단가적용 Package
	 * 
	 * @param params - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> PkgPurchasePriceDefault(HashMap<String, Object> params) throws Exception {

		try {
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();
			
			master.put("REGISTID", loginVO.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("구매발주의 단가적용 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("PurchasePriceDefault.call.Procedure", master);
			System.out.println("구매발주의 단가적용 PROCEDURE 호출 End.  >>>>>>>> " + master);
			
			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			String msgdata = StringUtil.nullConvert(master.get("MSGDATA"));

			params.put("STATUS", status);
			params.put("MSGDATA", msgdata);
		}
		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		return params;
	}
}