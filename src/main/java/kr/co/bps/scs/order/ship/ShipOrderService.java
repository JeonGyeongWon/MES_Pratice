package kr.co.bps.scs.order.ship;

import java.math.BigDecimal;
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
 * @ClassName : ShipOrderService.java
 * @Description : ShipOrder Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha, jshwang
 * @since 2017. 06
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ShipOrderService extends BaseService {

	/**
	 * 출하계획관리 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipPlanList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipPlanList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.order.plan.select", params);
	}

	/**
	 * 출하계획관리 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipPlanCount(HashMap<String, Object> params) {
		System.out.println("selectShipPlanCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.order.plan.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하계획관리 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipPlanRegist(Map<String, Object> params) throws Exception {
		System.out.println("insertShipPlanRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		String shipno = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			List noList = dao.selectListByIbatis("ship.order.new.shipno.select", master);
			Map<String, Object> noMap = (Map<String, Object>) noList.get(0);
			shipno = (String) noMap.get("SHIPNO");
			master.put("SHIPNO", shipno);

			master.put("REGISTID", loginVO.getId());

			System.out.println("insertShipPlanRegist master >>>>>>>>>> " + master);

			int updateResult = dao.update("ship.order.plan.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SHIPPING_H fail.");
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
	 * 출하계획관리 // 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipPlanRegist(Map<String, Object> params) throws Exception {
		System.out.println("updateShipPlanRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("ship.order.plan.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 출하계획관리 // 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipPlanRegist(Map<String, Object> params) throws Exception {
		System.out.println("deleteShipPlanRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("ship.order.plan.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 조회 부분에 출하지시현황 Master 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipOrderList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipOrderList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.order.list.select", params);
	}

	/**
	 * 조회 부분에 출하지시현황 Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipOrderCount(HashMap<String, Object> params) {
		System.out.println("selectShipOrderCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.order.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 출하지시현황 Detail 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipOrderDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipOrderDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.order.detail.select", params);
	}

	/**
	 * 조회 부분에 출하지시현황 Detail 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipOrderDetailCount(HashMap<String, Object> params) {
		System.out.println("selectShipOrderDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.order.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하지시관리 // 이월 데이터 PKG 삽입
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipOrderPkgStart(Map<String, Object> params) throws Exception {
		System.out.println("insertShipOrderPkgStart Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			// 프로시저 호출
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("출하지시 이월 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("ship.order.call.procedure", master);
			System.out.println("출하지시 이월 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_SHIPPING_CARREIED_CREATE fail.");
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
	 * 출하지시관리 // Detail 데이터 삽입
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipOrderDetailRegist(Map<String, Object> params) throws Exception {
		System.out.println("insertShipOrderDetailRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			System.out.println("insert master >>>>>>>>>> " + master);

			int updateResult = dao.update("ship.order.detail.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_WORK_ORDER_Detail fail.");
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
	 * 출하지시관리 // Detail 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipOrderDetailRegist(Map<String, Object> params) throws Exception {
		System.out.println("updateShipOrderDetailRegist Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
			System.out.println("update ShipOrder >>>>>>>>>> " + master);
		}

		boolean isSuccess = dao.updateListByIbatis("ship.order.detail.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 출하지시관리 // Detail 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipOrderDetailRegist(Map<String, Object> params) throws Exception {
		System.out.println("deleteShipOrderDetailRegist Service Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("ship.order.detail.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 2016.12.01 출하지시관리 투입처리
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> apprShipOrderRegist(HashMap<String, Object> params) throws Exception {
		System.out.println("apprShipOrderRegist Service Start. >>>>>>>>>> " + params);

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

			int updateResult = dao.update("ship.order.appr", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SHIPPING_H fail.");
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
	 * 조회 부분에 입하등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDistMatMatReceiveRegistList(Map<String, Object> params) throws Exception {
		System.out.println("selectDistMatMatReceiveRegistList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.ship.list.select", params);
	}

	/**
	 * 조회 부분에 입하등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDistMatMatReceiveRegistCount(HashMap<String, Object> params) {
		System.out.println("selectDistMatMatReceiveRegistCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.ship.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 입하등록상세현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDistMatMatReceiveRegistDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectDistMatMatReceiveRegistDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.ship.detaillist.select", params);
	}

	/**
	 * 조회 부분에 자재요청상세현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDistMatMatReceiveRegistDetailCount(HashMap<String, Object> params) {
		System.out.println("selectDistMatMatReceiveRegistDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.ship.detaillist.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.16 입하등록 상세 화면 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectDistMatReceiveRegistDList(Map<String, Object> params) throws Exception {
		System.out.println("selectDistMatReceiveRegistDList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.ship.detaillist.select", params);
	}

	/**
	 * 016.12.16 입하등록 상세 화면 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectDistMatReceiveRegistDCount(HashMap<String, Object> params) {
		System.out.println("selectDistMatReceiveRegistDCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.ship.detaillist.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.16 입하등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertDistMatMatReceiveRegistD(HashMap<String, Object> params) throws Exception {

		System.out.println("insertDistMatMatReceiveRegistD Service Start. >>>>>>>>>> ");
		String transno = null;
		try {

			String TransNo = StringUtil.nullConvert(params.get("TransNo"));
			if (TransNo.isEmpty()) {
				List ordernoList = dao.selectListByIbatis("dist.new.transno.select", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("TRANSNO", current.get("TRANSNO"));
				transno = (String) current.get("TRANSNO");
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
			master.put("TRANSNO", transno);

			System.out.println("transno No >>>>>>>>>> " + transno);

			int updateResult = dao.update("dist.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TRANS_H fail.");
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
	 * 입하등록 그리드 데이터 INSERT
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertDistMatMatReceiveRegistDGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertDistMatMatReceiveRegistDGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("insertDistMatMatReceiveRegistDGrid 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			Map<String, Object> temp = null;
			System.out.println("insertDistMatMatReceiveRegistDGrid 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());
				master.put("REQCONFIRMQTY", "0");
				master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("dist.detail.insert", master);
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
	 * 2016.12.19 입하 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatReceiveRegistD(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatReceiveRegistD Service Start. >>>>>>>>>> " + params);

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

			int updateResult = dao.update("dist.header.update", master);
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
	 * 2016.12.19 입하상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateMatReceiveRegistDGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatReceiveRegistDGrid Service Start. >>>>>>>>>> ");
		try {
			System.out.println("updateMatReceiveRegistDGrid 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateMatReceiveRegistDGrid 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("dist.detail.find.select", master);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateMatReceiveRegistDGrid poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());
					//					master.put("REQCONFRIMQTY", "0");
					master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

					int updateResult = dao.update("dist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TRANS_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("dist.detail.update", master);
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
	 * 2016.12.19 입하 상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteReceiveRegistD(Map<String, Object> params) throws Exception {
		System.out.println("deleteReceiveRegistD Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("dist.detail.delete", list) > 0;

		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 2016.12.19 입하 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteReceiveRegistDM(HashMap<String, Object> params) throws Exception {

		System.out.println("deleteReceiveRegistDM Service Start. >>>>>>>>>> ");

		String transno = null;
		try {
			transno = StringUtil.nullConvert(params.get("TransNo"));

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

			master.put("TRADENO", transno);

			System.out.println("transno No >>>>>>>>>> " + transno);

			int updateResult = dao.delete("dist.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_TRANS_H fail.");
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
	 * 출하계획번호 Lov 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ShipNoLovList(Map<String, Object> params) throws Exception {
		System.out.println("ShipNoLovList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.order.list.select", params);
	}

	/**
	 * 출하계획번호 항목 Lov 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ShipNoLovTotCnt(HashMap<String, Object> params) {
		System.out.println("ShipNoLovTotCnt Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.order.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipStatusList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipStatusList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.status.list.select", params);
	}

	/**
	 * 출하현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipStatusCount(HashMap<String, Object> params) {
		System.out.println("selectShipStatusCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.status.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하현황을 조회(Excel)
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipStatusExcelList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipStatusExcelList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.status.excel.select", params);
	}

	/**
	 * 조회 부분에 출하검사등록 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipInspectionMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipInspectionMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.inspection.master.list.select", params);
	}

	/**
	 * 조회 부분에 출하검사등록 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipInspectionMasterCount(HashMap<String, Object> params) {
		System.out.println("selectShipInspectionMasterCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.inspection.master.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 조회 부분에 출하검사등록 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipInspectionDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipInspectionDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("ship.inspection.detail.list.select", params);
	}

	/**
	 * 조회 부분에 출하검사등록 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipInspectionDetailCount(HashMap<String, Object> params) {
		System.out.println("selectShipInspectionDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("ship.inspection.detail.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하검사등록 마스터 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipInspectionMasterList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateShipInspectionMasterList Service Start. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("ship.inspection.master.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SHIPMENT_INSPECTION_H fail.");
			} else {
				int updateResult1 = dao.update("ship.order.shipcheckstatus.change.update", master);

				if (updateResult1 == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("update CB_SHIPPING_D fail.");
				} else {
					dao.update("ship.order.salesorderstatus.change.update", master);
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
		return params;
	}

	/**
	 * 출하검사등록 // 상세 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipInspectionDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateShipInspectionDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("updateShipInspectionDetailList 1. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateShipInspectionDetailList 2. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < SIZE; i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("UPDATEID", loginVO.getId());

				int updateResult = dao.update("ship.inspection.detail.list.update", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("update CB_SHIPMENT_INSPECTION_D fail.");
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
	 * 출하등록관리의 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipRegistManageMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipRegistManageMasterList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.ship.shipregistmanagelist.master.select", params);
	}

	/**
	 * 출하등록관리의 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipRegistManageMasterCount(HashMap<String, Object> params) {
		System.out.println("selectShipRegistManageMasterCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.ship.shipregistmanagelist.master.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 출하등록관리의 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipRegistManageDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectShipRegistManageDetailList Service Start. >>>>>>>>>> " + params);

		return dao.list("order.ship.shipregistmanagelist.detail.select", params);
	}

	/**
	 * 출하등록관리의 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipRegistManageDetailCount(HashMap<String, Object> params) {
		System.out.println("selectShipRegistManageDetailCount Service Start. >>>>>>>>>> " + params);

		List<?> count = dao.list("order.ship.shipregistmanagelist.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 출하등록 // 마스터 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipRegistManageMasterList(HashMap<String, Object> params) throws Exception {
		System.out.println("insertShipRegistManageMasterList Service Start. >>>>>>>>>> " + params);
		String outpono = null;
		try {
			outpono = StringUtil.nullConvert(params.get("OutPoNo"));
			if (outpono.isEmpty()) {
				List<?> sonolist = dao.selectListByIbatis("order.ship.shipno.find", params);
				Map<String, Object> current = (Map<String, Object>) sonolist.get(0);
				params.put("Shipno", current.get("FINDSHIPNO"));
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

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			LoginVO loginVO = getLoginVO();

			master.put("REGISTID", loginVO.getId());

			master.put("OutPoNo", outpono);
			System.out.println("insertShipRegistManageMasterList Master >>>>>>>>>> " + master);
			System.out.println("insertShipRegistManageMasterList No >>>>>>>>>> " + outpono);

			int updateResult = dao.update("order.ship.shipregistmanagelist.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SHIPPING_H fail.");
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
	 * 출하등록 // 디테일 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertShipRegistManageDetailList(Map<String, Object> params) throws Exception {
		System.out.println("insertShipRegistManageDetailList Service Start. >>>>>>>>>> ");
		try {
			System.out.println("insertShipRegistManageDetailList Start. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			String shipno = null;
			String orgid = null;
			String companyid = null;
			LoginVO loginVO = getLoginVO();
			System.out.println("insertShipRegistManageDetailList 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));
				shipno = StringUtil.nullConvert(master.get("Shipno"));
				int shipseq = NumberUtil.getInteger(master.get("SHIPSEQ"));

				{
					// 재고 트랜잭션 호출
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					String mfgno = StringUtil.nullConvert(master.get("MFGNO"));
					String trxgubun = "I";
					String trxtype = "제품-출하";
					Integer trxqty = NumberUtil.getInteger(master.get("SHIPQTY"));
					Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
					String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
					String trxiud = "INSERT";
					String remarks = StringUtil.nullConvert(master.get("REMARKS"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("ITEMCODE", itemcode);
					master.put("LOTNO", mfgno);
					master.put("TRXGUBUN", trxgubun);
					master.put("TRXTYPE", trxtype);
					master.put("TRXQTY", trxqty);
					master.put("TRXUNITPRICE", trxunitprice);
					master.put("TRXWAREHOUSING", trxwarehousing);
					master.put("TRXNO", shipno);
					master.put("TRXSEQ", shipseq);
					master.put("TRXIUD", trxiud);
					master.put("REMARKS", remarks);
					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("출하등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("ship.item.transaction.call.procedure", master);
					System.out.println("출하등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
				}
				

				master.put("REGISTID", loginVO.getId());

				master.put("Shipno", shipno);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);

				int updateResult = dao.update("order.ship.shipregistmanagelist.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_SHIPPING_D fail.");
				} else {
					// 마지막에 거래명세서 PKG 호출
					int lastpage = SIZE - 1;
					if ( i == lastpage ) {
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("SHIPNO", shipno);
						master.put("GUBUN", "AUTO");
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("거래명세서 생성 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("ship.trade.create.call.Procedure", master);
						System.out.println("거래명세서 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

//						String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
//						if (!status.equals("S")) {
//							errcnt += 1;
//							throw new Exception("call CB_EXCEL_UPLOAD_PKG.CB_TRADE_CREATE fail.");
//						}
					}
				}
				
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("SHIPNO", shipno);
				master.put("SHIPSEQ", shipseq);
				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("수주관리의 완료여부 업데이트 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("ship.soComplete.update.call.procedure", master);
				System.out.println("수주관리의 완료여부 업데이트 PROCEDURE 호출 End.  >>>>>>>> " + master);
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
	 * 출하등록 // 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipRegistManageMasterList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipRegistManageMasterList Service Start. >>>>>>>>>> " + params);

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

			System.out.println("updateShipRegistManageMasterList 1. >>>>>>>>>> " + master);

			int updateResult = dao.update("order.ship.shipregistmanagelist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SHIPPING_H fail.");
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
	 * 출하등록 // 디테일 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateShipRegistManageDetailList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipRegistManageDetailList Start. >>>>>>>>>> ");

		try {
			System.out.println("updateShipRegistManageDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			String shipno = null;
			String orgid = null;
			String companyid = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				orgid = StringUtil.nullConvert(master.get("Orgid"));
				companyid = StringUtil.nullConvert(master.get("CompanyId"));
				shipno = StringUtil.nullConvert(master.get("Shipno"));
				int shipseq = NumberUtil.getInteger(master.get("SHIPSEQ"));

				master.put("Shipno", shipno);
				master.put("Orgid", orgid);
				master.put("CompanyId", companyid);

				System.out.println("1. updateShipRegistManageDetailList master >>>>>>>>>> " + master);
				// porno 등록유무 확인
				List sonoList = dao.selectListByIbatis("order.ship.shipseq.find", master);
				Map<String, Object> current = (Map<String, Object>) sonoList.get(0);
				int soCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateShipRegistManageDetailList soCheck >>>>>>>>>> " + soCheck);
				if (soCheck == 0) {
					// 생성
					{
						// 재고 트랜잭션 호출
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						String mfgno = StringUtil.nullConvert(master.get("MFGNO"));
						String trxgubun = "I";
						String trxtype = "제품-출하";
						Integer trxqty = NumberUtil.getInteger(master.get("SHIPQTY"));
						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						String trxiud = "INSERT";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
						master.put("LOTNO", mfgno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
						master.put("TRXUNITPRICE", trxunitprice);
						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", shipno);
						master.put("TRXSEQ", shipseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("출하등록 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("ship.item.transaction.call.procedure", master);
						System.out.println("출하등록 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					}

					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("order.ship.shipregistmanagelist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_SHIPPING_D fail.");
					} else {
						// 마지막에 거래명세서 PKG 호출
						int lastpage = SIZE - 1;
						if ( i == lastpage ) {
							master.put("ORGID", orgid);
							master.put("COMPANYID", companyid);
							master.put("SHIPNO", shipno);
							master.put("GUBUN", "AUTO");
							master.put("REGISTID", loginVO.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");
							System.out.println("거래명세서 생성 PROCEDURE 호출 Start. >>>>>>>> ");
							dao.list("ship.trade.create.call.Procedure", master);
							System.out.println("거래명세서 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

							String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
//							if (!status.equals("S")) {
//								errcnt += 1;
//								throw new Exception("call CB_EXCEL_UPLOAD_PKG.CB_TRADE_CREATE fail.");
//							}
						}
					}
				} else {
					// 변경
					{
						// 재고 트랜잭션 호출
						String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
						String mfgno = StringUtil.nullConvert(master.get("MFGNO"));
						String trxgubun = "U";
						String trxtype = "제품-출하";
						Integer trxqty = NumberUtil.getInteger(master.get("SHIPQTY"));
						Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
						String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
						String trxiud = "UPDATE";
						String remarks = StringUtil.nullConvert(master.get("REMARKS"));
						
						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("ITEMCODE", itemcode);
						master.put("LOTNO", mfgno);
						master.put("TRXGUBUN", trxgubun);
						master.put("TRXTYPE", trxtype);
						master.put("TRXQTY", trxqty);
						master.put("TRXUNITPRICE", trxunitprice);
						master.put("TRXWAREHOUSING", trxwarehousing);
						master.put("TRXNO", shipno);
						master.put("TRXSEQ", shipseq);
						master.put("TRXIUD", trxiud);
						master.put("REMARKS", remarks);
						master.put("REGISTID", loginVO.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("출하변경 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("ship.item.transaction.call.procedure", master);
						System.out.println("출하변경 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
					}

					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("order.ship.shipregistmanagelist.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_SHIPPING_D fail.");
					}
				}
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("SHIPNO", shipno);
				master.put("SHIPSEQ", shipseq);
				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("수주관리의 완료여부 업데이트 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("ship.soComplete.update.call.procedure", master);
				System.out.println("수주관리의 완료여부 업데이트 PROCEDURE 호출 End.  >>>>>>>> " + master);
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
	 * 출하등록 // 마스터 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipRegistManageMasterList(Map<String, Object> params) throws Exception {
		System.out.println("deleteShipRegistManageMasterList Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);

		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		boolean isSuccess = dao.deleteListByIbatis("order.ship.shipregistmanagelist.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 출하등록 // 디테일 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteShipRegistManageDetailList(HashMap<String, Object> params) throws Exception {
		System.out.println("deleteShipRegistManageDetailList Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		LoginVO loginVO = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			String	shipno = StringUtil.nullConvert(master.get("SHIPNO"));
			String	orgid = StringUtil.nullConvert(master.get("ORGID"));
			String	companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			int shipseq = NumberUtil.getInteger(master.get("SHIPSEQ"));

			{
				// 재고 트랜잭션 호출
				String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
				String mfgno = StringUtil.nullConvert(master.get("MFGNO"));
				String trxgubun = "D";
				String trxtype = "제품-출하";
				Integer trxqty = NumberUtil.getInteger(master.get("SHIPQTY"));
				Integer trxunitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
				String trxwarehousing = StringUtil.nullConvert(master.get("WAREHOUSINGNO"));
				String trxiud = "DELETE";
				String remarks = StringUtil.nullConvert(master.get("REMARKS"));
				
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("ITEMCODE", itemcode);
				master.put("LOTNO", mfgno);
				master.put("TRXGUBUN", trxgubun);
				master.put("TRXTYPE", trxtype);
				master.put("TRXQTY", trxqty);
				master.put("TRXUNITPRICE", trxunitprice);
				master.put("TRXWAREHOUSING", trxwarehousing);
				master.put("TRXNO", shipno);
				master.put("TRXSEQ", shipseq);
				master.put("TRXIUD", trxiud);
				master.put("REMARKS", remarks);
				master.put("REGISTID", loginVO.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("출하삭제 재고 트랜잭션 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("ship.item.transaction.call.procedure", master);
				System.out.println("출하삭제 재고 트랜잭션 PROCEDURE 호출 End.  >>>>>>>> " + master);
			}

			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("SHIPNO", shipno);
			master.put("SHIPSEQ", shipseq);
			master.put("REGISTID", loginVO.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			
			System.out.println("수주관리의 완료여부 출하삭제시 업데이트 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("ship.soComplete.delete.call.procedure", master);
			System.out.println("수주관리의 완료여부 출하삭제시 업데이트 PROCEDURE 호출 End.  >>>>>>>> " + master);

			int updateResult = dao.delete("order.ship.shipregistmanagelist.detail.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_SHIPPING_D fail.");
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
	 * 출하 파일 업로드 // 파일 업로드 데이터 등록
	 * 
	 * @param params
	 *            - 등록 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> uploadShipRegistList(List<Object> list, String sourcecd) throws Exception {
		System.out.println("uploadShipRegistList Service Start. >>>>>>>>>> " + list);
		Map<String, Object> result = new HashMap<String, Object>();
		if (list == null || list.size() == 0) {
			return super.getExtGridResultMap(false, "insert");
		}
		int totcnt = list.size();
		int failCnt = 0;

		HashMap<String, Object> params = new HashMap<String, Object>();
		LoginVO loVo = getLoginVO();
		String orgid = null, companyid = null;
		try {
			// 1. 사업장, 공장 자동 부여
			params.put("USERID", loVo.getId());
			List<?> userList = dao.list("search.login.lov.select", params);

			if (userList.size() > 0) {
				Map<String, Object> userData = (Map<String, Object>) userList.get(0);

				orgid = StringUtil.nullConvert(userData.get("ORGID"));
				companyid = StringUtil.nullConvert(userData.get("COMPANYID"));

				if ( orgid.isEmpty() ) {
					orgid = 1 + "";
				}
				
				if ( companyid.isEmpty() ) {
					companyid = 1 + "";
				}
			} else {
				orgid = 1 + "";
				companyid = 1 + "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		// 에러실패 체크 시작
		int forCount = 0;
		String NameTemp = "";
		for (int i = 0; i < list.size(); i++) {
			if(forCount >= 5){
				break;
			}
			Map<String, Object> CheckListMap = (Map<String, Object>) list.get(i);
			HashMap<String, Object> tempMap = new HashMap<String, Object>();

			String customerName = StringUtil.nullConvert(CheckListMap.get("CUSTOMERNAME"));
			String orderName = StringUtil.nullConvert(CheckListMap.get("ORDERNAME")).replace(".0", "");
//			String itemName = StringUtil.nullConvert(CheckListMap.get("ITEMNAME"));
			String shipQty = StringUtil.nullConvert(CheckListMap.get("SHIPQTY")).replace(".0", "");
			String shipDate = StringUtil.nullConvert(CheckListMap.get("SHIPDATE")).replace(".", "").replace("E7", "");
			String unitPrice = StringUtil.nullConvert(CheckListMap.get("UNITPRICE")).replace(".0", "");
			String supplyPrice = StringUtil.nullConvert(CheckListMap.get("SUPPLYPRICE")).replace(".0", "");
			
			if (customerName.length() == 0 || orderName.length() == 0 || shipQty.length() == 0 || shipDate.length() == 0 || unitPrice.length() == 0 || supplyPrice.length() == 0) {
				NameTemp += "<br/>" + (i + 1) + "번째 라인의 ";
				forCount++;
			}

			String tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			if (customerName.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "거래처" : ", 거래처");
			}
			if (orderName.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "품번" : ", 품번");
			}
			if (shipQty.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "출하수량" : ", 출하수량");
			}
			if (shipDate.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "출하일자" : ", 출하일자");
			}
			if (unitPrice.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "출하단가" : ", 출하단가");
			}
			if (supplyPrice.isEmpty()) {
				tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
				tempMap.put("TEMPDATA", (tempdata.isEmpty()) ? "공급가액" : ", 공급가액");
			}
			tempdata = StringUtil.nullConvert(tempMap.get("TEMPDATA"));
			NameTemp += tempdata;
		}
		System.out.println("uploadOrderStateList NameTemp. >>>>>>>>>>" + NameTemp);
		// 에러실패 체크 끝

		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> excelMap = (Map<String, Object>) list.get(i);
			HashMap<String, Object> tempMap = new HashMap<String, Object>();
			excelMap.put("REGISTID", loVo.getId());

			try {
				excelMap.put("ORGID", orgid);
				tempMap.put("ORGID", orgid);
				System.out.println("uploadShipRegistList orgid. >>>>>>>>>>" + orgid);

				excelMap.put("COMPANYID", companyid);
				tempMap.put("COMPANYID", companyid);
				System.out.println("uploadShipRegistList companyid. >>>>>>>>>>" + companyid);

				String CustomerName = null, OrderName = null, ItemName = null, ShipDate = null;
				BigDecimal ShipQty = null, UnitPrice = null, SupplyPrice = null;
				// 2. 거래처
				CustomerName = StringUtil.nullConvert(excelMap.get("CUSTOMERNAME").toString());
				if (!CustomerName.isEmpty()) {

					tempMap.put("CUSTOMERNAME2", CustomerName);
					tempMap.put("CUSTOMERTYPE1", "S");
					List CustomerList = dao.selectListByIbatis("search.customer.name.lov.select", tempMap);
					System.out.println("uploadShipRegistList CustomerList. >>>>>>>>>>" + CustomerList.size());
					if ( CustomerList.size() == 0 ) {
						failCnt++;
						NameTemp += "<br/>" + (i + 1) + "번째 라인의 거래처";
					} else {
						Map<String, Object> CustomerMap = (Map<String, Object>) CustomerList.get(0);
						CustomerName = StringUtil.nullConvert(CustomerMap.get("LABEL"));

						excelMap.put("CUSTOMERNAME", CustomerName);
					}
				}
				System.out.println("uploadShipRegistList CustomerName. >>>>>>>>>>" + CustomerName);

				// 3. 품번
				OrderName = StringUtil.nullConvert(excelMap.get("ORDERNAME").toString()).replace(".0", "");
				if (!OrderName.isEmpty()) {
					// tempMap.put("ORDERNAME", OrderName); // .0 삭제

					tempMap.put("ORDERNAME2", OrderName);
					List OrderList = dao.selectListByIbatis("search.item.name.lov.select", tempMap);
					System.out.println("uploadShipRegistList OrderList. >>>>>>>>>>" + OrderList.size());
					if ( OrderList.size() == 0 ) {
						failCnt++;
						NameTemp += "<br/>" + (i + 1) + "번째 라인의 품번&품명";	
					} else {
						Map<String, Object> OrderMap = (Map<String, Object>) OrderList.get(0);
						OrderName = StringUtil.nullConvert(OrderMap.get("ORDERNAME"));
						excelMap.put("ORDERNAME", OrderName);
						
						String itemcode = StringUtil.nullConvert(OrderMap.get("ITEMCODE"));
						tempMap.put("ITEMCODE", itemcode);
						List SoList = dao.selectListByIbatis("search.shipping.excelupload.solist.select", tempMap);
						if ( SoList.size() == 0 ) {
							failCnt++;
							NameTemp += "<br/>" + (i + 1) + "번째 라인의 품번&품명으로  등록 된 수주내역";	
						}
					}
				}
				System.out.println("uploadShipRegistList OrderName. >>>>>>>>>>" + OrderName);

			
			
				try {
					
				} catch (Exception e) {
					
				}

				// 5. 출하수량
				ShipQty = NumberUtil.getBigDecimal(excelMap.get("SHIPQTY"));
				System.out.println("uploadShipRegistList ShipQty. >>>>>>>>>>" + ShipQty);
				excelMap.put("SHIPQTY", ShipQty);

				// 6. 출하일자
				ShipDate = StringUtil.nullConvert(excelMap.get("SHIPDATE").toString()).replace(".", "").replace("E7", "");
				System.out.println("uploadShipRegistList ShipDate. >>>>>>>>>>" + ShipDate);
				if (!ShipDate.isEmpty()) {
					excelMap.put("SHIPDATE", ShipDate);
				}

				// 7. 출하단가
				UnitPrice = NumberUtil.getBigDecimal(excelMap.get("UNITPRICE"));
				System.out.println("uploadShipRegistList UnitPrice. >>>>>>>>>>" + UnitPrice);
				excelMap.put("UNITPRICE", UnitPrice);

				// 8. 공급가액
				SupplyPrice = NumberUtil.getBigDecimal(excelMap.get("SUPPLYPRICE"));
				System.out.println("uploadShipRegistList SupplyPrice. >>>>>>>>>>" + SupplyPrice);
				excelMap.put("SUPPLYPRICE", SupplyPrice);

				// 필수 항목이 입력되지 않으면 실패 처리
				if (/*ShipQty.length() == 0 || */ShipDate.length() == 0 /*|| UnitPrice.length() == 0 || SupplyPrice.length() == 0*/) {
					failCnt++;
//					list.remove(i);
//					i--;
				}
			} catch (Exception e) {
				failCnt++;
//				list.remove(i);
//				i--;
//				System.out.println("여기서 에러 : 바로 위의 품번, 품명 조회시 리스트 2개이상 올라오면 에러 남 >>>>>>>>>>>");
			}
		}

		try {

			List chkList = dao.selectListByIbatis("excel.ship.find.select", null);
			Map<String, Object> current = (Map<String, Object>) chkList.get(0);
			int isCheck = NumberUtil.getInteger(current.get("COUNT"));

			System.out.println("2. uploadShipRegistList isCheck >>>>>>>>>> " + isCheck);
			if (isCheck > 0) {
				System.out.println("uploadShipRegistList DELETE Start. >>>>>>>>>>");
				int deleteResult = dao.delete("excel.ship.delete", null);
				if (deleteResult == 0) {
					// 저장 실패시 띄우는 예외처리
					throw new Exception("delete CB_SHIPPING_TEMP fail.");
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		List<Object> uploadlist = dao.insertListByIbatis("excel.ship.insert", list);
		StringBuffer sbMsg = new StringBuffer();
		sbMsg.append("총 " + totcnt + " 건 중");
		sbMsg.append("<br/>생성 성공 : " + (uploadlist.size() - failCnt)  + "건");
		sbMsg.append("<br/>생성 실패 : " + failCnt + "건");
		if (!NameTemp.equals("") ) {
			sbMsg.append("<br/><br/>실패 요인 : " + NameTemp + " 항목을 확인해 주세요.");
		}
//		if (NameTemp.length() > 0) {
//			sbMsg.append("<br/><br/>실패 요인 : " + NameTemp + " 항목을 확인해 주세요.");
//		}
		System.out.println("uploadShipRegistList NameTemp >>>>>>>>>>" + NameTemp);
		System.out.println("uploadShipRegistList sbMsg >>>>>>>>>>" + sbMsg);

		if (failCnt == 0) {
			try {
				// 출하 UPLOAD PKG 호출
				params.put("ORGID", orgid);
				params.put("COMPANYID", companyid);
				params.put("REGISTID", loVo.getId());

				params.put("RETURNSTATUS", "");
				params.put("MSGDATA", "");
				System.out.println("출하 UPLOAD PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("excel.ship.upload.call.Procedure", params);
				System.out.println("출하 UPLOAD PROCEDURE 호출 End.  >>>>>>>> " + params);

				String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					String errMsg = StringUtil.nullConvert(params.get("MSGDATA"));
					sbMsg.append("<br/>오류메시지 : " + errMsg);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		result.put("successCnt", uploadlist.size());
		result.putAll(super.getExtGridResultMap(uploadlist.size() > 0, "insert", sbMsg.toString()));
		return result;
	}
	

	/**
	 * 월별 출하현황 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectShipModelList(HashMap<String, Object> params) {
		System.out.println("selectShipModelList Service Start. >>>>>>>>>> " + params);
		return dao.list("ship.model.total.list.select", params);
	}

	/**
	 * 월별 출하현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectShipModelCount(HashMap<String, Object> params) {
		List<?> count = dao.list("ship.model.total.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 단가적용 // 프로시저 호출
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> callUnitPriceManage(HashMap<String, Object> params) throws Exception {
		System.out.println("callUnitPriceManage SERVICE Start. >>>>>>>>>> ");
		LoginVO loginVO = getLoginVO();
		int errcnt = 0;
		String msgData = null;
		try {
			List<Object> list = super.getGridData(params);
			if (list == null || list.size() == 0) {
				super.setUpdateParams(params);
				list = new ArrayList<Object>();
				list.add(params);
			}

			System.out.println("callUnitPriceManage 2. >>>>>>>>>> " + list.size());
			try {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> master = (Map<String, Object>) list.get(i);
					
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					String sono = StringUtil.nullConvert(master.get("SHIPNO"));
					String soseq = StringUtil.nullConvert(master.get("SHIPSEQ"));
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("SHIPNO", sono);
					master.put("SHIPSEQ", soseq);
					master.put("ITEMCODE", itemcode);

					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("단가 적용 프로시저 호출 Start. >>>>>>>> ");
					dao.list("order.ship.unitprice.call.Procedure", master);
					System.out.println("단가 적용 프로시저 호출 End.  >>>>>>>> " + master);

					String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt++;
						msgData = StringUtil.nullConvert(master.get("MSGDATA"));
					} else {
						msgData = "정상적으로 적용하였습니다.";
					}
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
			System.out.println("메시지 확인1. >>>>>>>> " + msgData);
			System.out.println("메시지 확인2. >>>>>>>> " + msgData.length());
			if (msgData.length() > 0) {
				params.put("success", isSuccess);
				params.put("msg", msgData);
			} else {
				params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}
	
}