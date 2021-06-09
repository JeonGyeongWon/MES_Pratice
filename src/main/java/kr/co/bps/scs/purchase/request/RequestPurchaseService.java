package kr.co.bps.scs.purchase.request;

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
 * @ClassName : RequestPurchaseService.java
 * @Description : RequestPurchase Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class RequestPurchaseService extends BaseService {

	/**
	 * 조회 부분에 자재요청현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectRequestPurchaseList(Map<String, Object> params) throws Exception {

		return dao.list("purchase.request.list.select", params);
	}

	/**
	 * 조회 부분에 자재요청현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectRequestPurchaseCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.request.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 자재 요청
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertPurchaseRequestManageList(HashMap<String, Object> params) throws Exception {

		String porno = null;
		try {
			String PorNo = StringUtil.nullConvert(params.get("PorNo"));
			if (PorNo.isEmpty()) {
				List<?> noList = dao.selectListByIbatis("purchase.new.porno.select", params);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				params.put("PORNO", current.get("PORNO"));
				porno = (String) current.get("PORNO");
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

			// 접수시 상태
			master.put("STATUS", "STAND_BY");
			master.put("PORNO", porno);

			System.out.println("insertPurchaseRequestManageList porno >>>>>>>>>> " + porno);

			int updateResult = dao.update("purchase.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_PURCHASE_H fail.");
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
	 * 자재요청 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatePurchaseRequestManageList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("purchase.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_PURCHASE_H fail.");
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
	 * 구매요청 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deletePurchaseRequestManageList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.delete("purchase.header.delete", master);
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
		

	/**
	 * 요청상세현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectRequestPurchaseDetailList(Map<String, Object> params) throws Exception {

		return dao.list("purchase.request.detaillist.select", params);
	}

	/**
	 * 요청상세현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectRequestPurchaseDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.request.detaillist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 요청 상세 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertPurchaseRequestEtcMasterList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertPurchaseRequestEtcMasterList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertPurchaseRequestEtcMasterList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			Map<String, Object> temp = null;
			System.out.println("insertPurchaseRequestEtcMasterList 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());
//				master.put("REQCONFIRMQTY", "0");
//				master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("purchase.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_PURCHASE_D fail.");
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
	 * 요청 상세 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatePurchaseRequestEtcMasterList(HashMap<String, Object> params) throws Exception {

		try {
			System.out.println("updatePurchaseRequestEtcMasterList 1. >>>>>>>>>> "+ params.get("data"));
			// 마스터 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updatePurchaseRequestEtcMasterList 2. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// 등록유무 확인
				List noList = dao.selectListByIbatis("purchase.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int noCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateSalesOrderMasterList noCheck >>>>>>>>>> " + noCheck);
				if (noCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("purchase.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_PURCHASE_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("purchase.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_PURCHASE_D fail.");
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

	/**
	 * 요청 등록 상세 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deletePurchaseRequestEtcMasterList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> detail = (Map<String, Object>) list.get(i);

			int updateResult = dao.delete("purchase.detail.delete", detail);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_PURCHASE_D fail.");
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
	 * 구매요청 상태변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> changePurchaseRequestStatus(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("purchase.header.status.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_PURCHASE_H fail.");
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
}