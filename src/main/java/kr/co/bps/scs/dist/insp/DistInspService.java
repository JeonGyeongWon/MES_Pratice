package kr.co.bps.scs.dist.insp;

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
 * @author jmpark
 * @since 2016. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class DistInspService extends BaseService {
	/**
	 * 조회 부분에 입고검사 등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectMatReceiptInspRegistList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.list.select", params);
	}

	/**
	 * 조회 부분에 입고검사 등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectMatReceiptInspRegistCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 입고검사 등록상세현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectMatReceiptInspRegistDetailList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.detaillist.select", params);
	}

	/**
	 * 조회 부분에 입고검사 상세현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectMatReceiptInspRegistDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.detaillist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	//여기까지 입고검사등록 조회화면

	
	
	/**
	 * 2016.12.21 입고검사 등록 상세 화면 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectMatReceiptInspRegistDList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.detaillist.select", params);
	}

	/**
	 * 2016.12.21 입고검사등록 상세 화면 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectMatReceiptInspRegistDCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.detaillist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.21 입고검사등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertMatReceiptInspRegistD(HashMap<String, Object> params) throws Exception {

		String inspno = null;
		try {

			String InspNo = StringUtil.nullConvert(params.get("InspNo"));
			if (!InspNo.isEmpty()) {

			} else {
				List ordernoList = dao.selectListByIbatis("dist.new.inspno.select", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("INSPECTIONPLANNO", current.get("INSPECTIONPLANNO"));
				inspno = (String) current.get("INSPECTIONPLANNO");
			}

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

			// 접수시 상태
			master.put("STATUS", "STAND_BY");
			master.put("INSPECTIONPLANNO", inspno);

			System.out.println("inspno No >>>>>>>>>> " + inspno);

			int updateResult = dao.update("dist.insp.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_INSPCETION_H fail.");
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
	 * 2016.12.21 입고검사등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * 
	 * @return RequestPurchaseService 성공여부
	 * 
	 * @exception Exception
	 */
	public Map<String, Object> insertMatReceiptInspRegistDGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertMatReceiptInspRegistDGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("insertMatReceiptInspRegistDGrid 1. >>>>>>>>>> ");
			System.out.println("insertMatReceiptInspRegistDGrid 2. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			//			if (list == null || list.size() == 0) {
			//				super.setUpdateParams(params);
			//				list = new ArrayList<Object>();
			//				list.add(params.get("data"));
			//				//    		return super.getExtGridResultMap(false);
			//			}

			Map<String, Object> temp = null;
			System.out.println("insertMatReceiptInspRegistDGrid 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());
				master.put("REQCONFIRMQTY", "0");
				master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("dist.insp.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TRANS_D fail.");
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
	 * 2016.12.21 입고검사 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatReceiptInspRegistD(HashMap<String, Object> params) throws Exception {

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

			master.put("UPDATEID", loginVO.getId());

			int updateResult = dao.update("dist.insp.header.update", master);
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
	 * 2016.12.21 입고검사상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatReceiptInspRegistDGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatReceiptInspRegistDGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("updateMatReceiptInspRegistDGrid 1. >>>>>>>>>> ");
			System.out.println("updateMatReceiptInspRegistDGrid 2. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			//			if (list == null || list.size() == 0) {
			//				super.setUpdateParams(params);
			//				list = new ArrayList<Object>();
			//				list.add(params.get("data"));
			//				//    		return super.getExtGridResultMap(false);
			//			}

			System.out.println("updateMatReceiptInspRegistDGrid 3. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("dist.insp.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateMatReceiptInspRegistDGrid poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());
					//					master.put("REQCONFRIMQTY", "0");
					master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

					int updateResult = dao.update("dist.insp.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TRANS_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("dist.insp.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TRANS_D fail.");
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
	 * 2016.12.21 입고검사 상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatReceiptInspRegistD(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("dist.insp.detail.delete", list) > 0;

		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 2016.12.21 입고검사 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteMatReceiptInspRegistDM(HashMap<String, Object> params) throws Exception {

		String inspno = null;
		try {
			inspno = StringUtil.nullConvert(params.get("InspsNo"));

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

			master.put("INSPECTIONPLANNO", inspno);

			System.out.println("inspno No >>>>>>>>>> " + inspno);

			int updateResultd = dao.delete("dist.insp.detail.all.delete", master);
			if (updateResultd == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_INSPECTION_D fail.");
			}

			int updateResult = dao.delete("dist.insp.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_INSPECTION_H fail.");
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
	 * 2016.12.22 조회 부분에 검사번호 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> InspNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.inspno.list.lov.select", params);
	}

	/**
	 * 2016.12.22 조회 부분에 검사번호 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int InspNoLovDTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.inspno.list.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.22 조회 화면에서 마스터 정보 클릭시 세부정보 조회 화면 호출 데이터 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> InspNoLovDList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.list.select", params);
	}

	/**
	 * 2016.12.22 조회 화면에서 마스터 정보 클릭시 세부정보 조회 화면 호출 데이터 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int InspNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 입고검사 LIST // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> MatReceiptInspRegistInspPopList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.inspno.list.pop.select", params);
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 입고검사 LIST // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int MatReceiptInspRegistInspPopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.inspno.list.pop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 아이템별 품질 기준 마스터 LIST // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> MatReceiptInspRegistInspPopCheckList(Map<String, Object> params) throws Exception {

		return dao.list("dist.insp.inspno.list.popcheck.select", params);
	}

	/**
	 * 2016.12.23 입고검사 상세화면에서 아이템별 품질 기준 마스터 LIST // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int MatReceiptInspRegistInspPopCheckTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("dist.insp.inspno.list.popcheck.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

}