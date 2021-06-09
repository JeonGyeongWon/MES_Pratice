package kr.co.bps.scs.quality.ship;

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
 * @ClassName : QualShipService.java
 * @Description : QualShip Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 07.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class QualShipService extends BaseService {

	/**
	 * 출하검사등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipmentInspMasterList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertShipmentInspMasterList Service Start.. >>>>>>>>>> " + params);
		String inspno = null;
		try {
			String InspNo = StringUtil.nullConvert(params.get("ShipInsNo"));
			if (InspNo.isEmpty()) {
				params.put("GUBUN", "SI");
				List noList = dao.selectListByIbatis("quality.ship.new.inspno.select", params);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				params.put("SHIPINSNO", current.get("SHIPINSNO"));
				inspno = (String) current.get("SHIPINSNO");
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

			master.put("SHIPINSNO", inspno);

			System.out.println("SHIPINSNO >>>>>>>>>> " + inspno);

			int updateResult = dao.update("quality.ship.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SHIPMENT_INSPECTION_H fail.");
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
	 * 출하검사등록 // 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipmentInspDetailGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertShipmentInspDetailGrid Service Start. >>>>>>>>>> " + params);
		try {
			System.out.println("insertShipmentInspDetailGrid 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			System.out.println("insertShipmentInspDetailGrid 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());
				
				int updateResult = dao.update("quality.ship.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_SHIPMENT_INSPECTION_D fail.");
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
	 * 출하검사등록 마스터 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipmentInspMasterList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateShipmentInspMasterList Service Start.. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("quality.ship.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SHIPMENT_INSPECTION_H fail.");
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
	 * 출하검사등록 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipmentInspMaster(HashMap<String, Object> params) throws Exception {

		System.out.println("deleteShipmentInspMaster Service Start. >>>>>>>>>> ");

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			int updateResult = dao.delete("quality.ship.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE CB_SHIPMENT_INSPECTION_H fail.");
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
	 * 출하검사등록 // 그리드 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipmentInspDetailGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("updateShipmentInspDetailGrid Service Start. >>>>>>>>>> " + params);
		try {
			System.out.println("updateShipmentInspDetailGrid 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateShipmentInspDetailGrid 2. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				// 등록유무 확인
				List noList = dao.selectListByIbatis("quality.ship.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int noCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateShipmentInspDetailGrid noCheck >>>>>>>>>> " + noCheck);
				if (noCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("quality.ship.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_SHIPMENT_INSPECTION_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("quality.ship.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_SHIPMENT_INSPECTION_D fail.");
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
	 * 출하검사등록 상세 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipmentInspDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		try {
			LoginVO loginVO = getLoginVO();
			int errcnt = 0;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);

				int updateResult = dao.update("quality.ship.detail.delete", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_SHIPMENT_INSPECTION_D fail.");
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
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 출하대기 LIST 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipmentInspPopupList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipmentInspPopupList Service Start. >>>>>>>>>> " + params);

		return dao.list("quality.ship.popup.list.select", params);
	}

	/**
	 * 출하대기 LIST 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipmentInspPopupCount(HashMap<String, Object> params) {
		System.out.println("selectShipmentInspPopupCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("quality.ship.popup.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

}