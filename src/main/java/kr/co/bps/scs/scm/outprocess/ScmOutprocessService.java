package kr.co.bps.scs.scm.outprocess;

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
 * @since 2016. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ScmOutprocessService extends BaseService {

	//	여기부터 외주입고등록 조회 화면
	/**
	 * 조회 부분에 외주입고등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutWarehousingList(Map<String, Object> params) throws Exception {
		
		return dao.list("scm.outprocess.list.select", params);
	}

	/**
	 * 조회 부분에 외주입고등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutWarehousingCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

    //	여기부터 외주입고내역정보 조회 화면
	/**
	 * 조회 부분에 외주입고등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectScmOutprocessDetail(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.detail.select", params);
	}

	/**
	 * 조회 부분에 외주입고등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectScmOutprocessDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	
    //여기부터 입하등록 상세 화면
	/**
	 * 2018.03.15 입하등록 상세 화면 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectScmOutprocessRegistDetail(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.detail.select", params);
	}

	/**
	 * 2018.03.15 입하등록 상세 화면 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectScmOutprocessRegistDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ScmOutprocessRegistPopList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.list.pop.select", params);
	}

	/**
	 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ScmOutprocessRegistPopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.list.pop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	
	/**
	 * 2018.03.22 입고등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutWarehousingRegist(HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutWarehousingRegist Start. >>>>>>>>>> ");
		String transno = null;
		try {
			String outtransno = StringUtil.nullConvert(params.get("OutTransNo"));
			if (outtransno.isEmpty()) {
				List ordernoList = dao.selectListByIbatis("prod.outtrans.new.outtransno.select", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("OUTTRANSNO", current.get("OUTTRANSNO"));
				transno = (String) current.get("OUTTRANSNO");
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

		int errcnt = 0;
		LoginVO loginVO = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", loginVO.getId());

			// 접수시 상태
			//master.put("STATUS", "STAND_BY");
			master.put("OUTTRANSNO", transno);

			System.out.println("outtransno No >>>>>>>>>> " + transno);

			int updateResult = dao.update("prod.outtrans.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_OUT_TRANS_H fail.");
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

	/*
	 * 2018.12.16 입고등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * 
	 * @return RequestPurchaseService 성공여부
	 * 
	 * @exception Exception
	 */
	public Map<String, Object> insertOutWarehousingRegistGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutWarehousingRegistGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("insertOutWarehousingRegistGrid 1. >>>>>>>>>> " + params.get("data"));
			// 디테일 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			
			System.out.println("insertOutWarehousingRegistGrid 3. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());

				int updateResult = dao.update("prod.outtrans.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_OUT_TRANS_D fail.");
				}else {
						// 저장 성공시 생산수량 생성 PKG 호출
						Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
						Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
						String outtransno = StringUtil.nullConvert(master.get("OUTTRANSNO"));
						Integer outtransseq = NumberUtil.getInteger(master.get("OUTTRANSSEQ"));
						String gubun = "I";

						master.put("ORGID", orgid);
						master.put("COMPANYID", companyid);
						master.put("OUTTRANSNO", outtransno);
						master.put("OUTTRANSSEQ", outtransseq);
						master.put("GUBUN", gubun);

						master.put("P_LOGIN", loginVO.getId());
						master.put("RS_CODE", "");
						master.put("RS_STATUS", "");
						System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prodWorkOrderCreate.call.Procedure", master);
						System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

						String status = StringUtil.nullConvert(master.get("RS_STATUS"));
						String rscode = StringUtil.nullConvert(master.get("RS_CODE"));
						if (!rscode.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_OUTSIDE_ORDER_PKG.CB_WORK_ORDER_CREATE fail. >>>>>>>>>>>>   " + status);
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
			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

	/**
	 * 2018.03.23 입고 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutWarehousingRegist(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("prod.outtrans.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_OUT_TRANS_H fail.");
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
	 * 2016.12.19 입하상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutWarehousingRegistGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("updateOutWarehousingRegistGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("updateOutWarehousingRegistGrid 1. >>>>>>>>>> "+ params.get("data"));
			// 마스터 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");

			System.out.println("updateOutWarehousingRegistGrid 3. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("prod.outtrans.detail.find.select", detail);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateOutWarehousingRegistGrid poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					detail.put("REGISTID", loginVO.getId());
					//					master.put("REQCONFRIMQTY", "0");
					detail.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

					int updateResult = dao.update("prod.outtrans.detail.insert", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_OUT_TRANS_D fail.");
					}
				} else {
					// 변경
					detail.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("prod.outtrans.detail.update", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_OUT_TRANS_D fail.");
					}else {
							// 저장 성공시 생산수량 생성 PKG 호출
							Integer orgid = NumberUtil.getInteger(detail.get("ORGID"));
							Integer companyid = NumberUtil.getInteger(detail.get("COMPANYID"));
							String outtransno = StringUtil.nullConvert(detail.get("OUTTRANSNO"));
							Integer outtransseq = NumberUtil.getInteger(detail.get("OUTTRANSSEQ"));
							String gubun = "U";

							detail.put("ORGID", orgid);
							detail.put("COMPANYID", companyid);
							detail.put("OUTTRANSNO", outtransno);
							detail.put("OUTTRANSSEQ", outtransseq);
							detail.put("GUBUN", gubun);

							detail.put("P_LOGIN", loginVO.getId());
							detail.put("RS_CODE", "");
							detail.put("RS_STATUS", "");
							System.out.println("로그인 ID >>>>>>>> " + loginVO.getId() );
							System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 Start. >>>>>>>> ");
							dao.list("prodWorkOrderCreate.call.Procedure", detail);
							System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 End.  >>>>>>>> " + detail);

							String status = StringUtil.nullConvert(detail.get("RS_STATUS"));
							String rscode = StringUtil.nullConvert(detail.get("RS_CODE"));
							if (!rscode.equals("S")) {
								errcnt += 1;
								throw new Exception("call CB_OUTSIDE_ORDER_PKG.CB_WORK_ORDER_CREATE fail. >>>>>>>>>>>>   " + status);
							}
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
	 * 2018.03.26 외주입고 상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteScmOutprocessRegistDetail(Map<String, Object> params) throws Exception {
		String lotno = null;
		try {
			lotno = StringUtil.nullConvert(params.get("LOTNO"));
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

			master.put("LOTNO", lotno);

			System.out.println("lotno No >>>>>>>>>> " + lotno);
			
			List<?> cklist = dao.selectListByIbatis("scm.outproc.tradecheck.select", master);
			System.out.println("deleteOutProcLotRegistD >>>>>>>>>> " + cklist);
			Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
			int tradecnt = NumberUtil.getInteger(ck.get("LOTCNT"));
			System.out.println("tradecnt >>>>>>>>>> " + tradecnt);
			
			if(tradecnt > 0){
				params.put("masage", "해당 입고번호의 LOT바코드 데이터가 존재합니다.<br/>삭제 후 제거가 가능합니다.");
				System.out.println("tradecnt N >>>>>>>>>> " + tradecnt);
			}else{
				int updateResult = dao.delete("scm.outprocess.detail.delete", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_TRANS_LOT_H fail.");
				}else{
					params.put("masage", "정상적으로 삭제 하였습니다.");
					System.out.println("tradecnt Y >>>>>>>>>> " + tradecnt);
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

		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	/**
	 * 2018.03.26 외주입고 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteScmOutprocessRegistHeader(HashMap<String, Object> params) throws Exception {

		String outtransno = null;
		try {

			outtransno = StringUtil.nullConvert(params.get("searchTransNo"));

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

			master.put("OUTTRANSNO", outtransno);

			System.out.println("outtransno No >>>>>>>>>> " + outtransno);

			int updateResult = dao.delete("scm.outprocess.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_OUT_TRANS_H fail.");
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
	 * 외주공정LOT 바코드등록 // Master 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcLotRegistMasterList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outproclotregist.master.select", params);
	}

	/**
	 * 외주공정LOT 바코드등록 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcLotRegistMasterTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outproclotregist.master.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 외주공정LOT 바코드등록 첫번째 리스트를 출력한다. 
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectOutProcLotRegistFirstMasterList(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("scm.outprocess.outproclotregist.firstmaster.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] lotno = FirstListMap.get("LOTNO").toString().split(",");

			result = lotno[0].toString();
		}

		return result;
	}
	
	/**
	 * 외주공정LOT 바코드등록 // Detail 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcLotRegistDetailList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outproclotregist.detail.select", params);
	}

	/**
	 * 외주공정LOT 바코드등록 // Detail 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcLotRegistDetailTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outproclotregist.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주공정LOT 바코드등록 // Master 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcLotRegist(HashMap<String, Object> params) throws Exception {
		String lotno = null;
		try {

			String LotNo = StringUtil.nullConvert(params.get("LotNo"));
			if (!LotNo.isEmpty()) {

			} else {
				List ordernoList = dao.selectListByIbatis("scm.outprocess.outproclotregist.lotno.find", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("LOTNO", current.get("LOTNO"));
				lotno = (String) current.get("LOTNO");
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

			master.put("STATUS", "STAND_BY");
			master.put("LOTNO", lotno);

			System.out.println("lotno No >>>>>>>>>> " + lotno);

			int updateResult = dao.update("scm.outprocess.outproclotregist.master.insert", master);
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
	 * 외주공정LOT 바코드등록 // Detail 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcLotRegistD(HashMap<String, Object> params) throws Exception {
		System.out.println("insertMatLotBarcodeRegistD Start. >>>>>>>>>> ");
		try {
			System.out.println("insertMatLotBarcodeRegistD 1. >>>>>>>>>> ");
			System.out.println("insertMatLotBarcodeRegistD 2. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			Map<String, Object> temp = null;
			System.out.println("insertMatLotBarcodeRegistD 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());
				//master.put("REQCONFIRMQTY", "0");
				//master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

				int updateResult = dao.update("scm.outprocess.outproclotregist.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TRANS_LOT_D fail.");
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
	 * 외주공정LOT 바코드등록 // Master 수정
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcLotRegist(HashMap<String, Object> params) throws Exception {
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

			int updateResult = dao.update("scm.outprocess.outproclotregist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TRANS_LOT_H fail.");
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
	 * 외주공정LOT 바코드등록 // Detail 수정
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcLotRegistD(HashMap<String, Object> params) throws Exception {

		System.out.println("updateMatLotBarcodeRegistD Start. >>>>>>>>>> ");
		try {
			System.out.println("updateMatLotBarcodeRegistD 1. >>>>>>>>>> ");
			System.out.println("updateMatLotBarcodeRegistD 2. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateMatLotBarcodeRegistD 3. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				// porno 등록유무 확인
				List noList = dao.selectListByIbatis("scm.outprocess.outproclotregist.detail.find", master);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateMatLotBarcodeRegistD poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("scm.outprocess.outproclotregist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TRANS_LOT_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("scm.outprocess.outproclotregist.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TRANS_LOT_D fail.");
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
	 * 외주공정LOT 바코드등록 // Master 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOutProcLotRegist(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}
		System.out.println("DELETE >>>>>>>>>> ");

		boolean isSuccess = dao.deleteListByIbatis("scm.outprocess.outproclotregist.master.delete", list) > 0;

		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 외주공정LOT 바코드등록 // Detail 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOutProcLotRegistD(HashMap<String, Object> params) throws Exception {
		String lotno = null;
		try {
			lotno = StringUtil.nullConvert(params.get("LOTNO"));
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

			master.put("LOTNO", lotno);

			System.out.println("lotno No >>>>>>>>>> " + lotno);
			
			List<?> cklist = dao.selectListByIbatis("scm.outproc.tradecheck.select", master);
			System.out.println("deleteOutProcLotRegistD >>>>>>>>>> " + cklist);
			Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
			int tradecnt = NumberUtil.getInteger(ck.get("TRADECNT"));
			System.out.println("tradecnt >>>>>>>>>> " + tradecnt);
			
			if(tradecnt > 0){
				params.put("masage", "해당 LOT번호의 거래명세서 데이터가 존재합니다.<br/>삭제 후 제거가 가능합니다.");
				System.out.println("tradecnt N >>>>>>>>>> " + tradecnt);
			}else{
				int updateResult = dao.delete("scm.outprocess.outproclotregist.detail.delete", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_TRANS_LOT_H fail.");
				}else{
					params.put("masage", "정상적으로 삭제 하였습니다.");
					System.out.println("tradecnt Y >>>>>>>>>> " + tradecnt);
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

		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}
		
	/**
	 * 외주공정LOT 바코드등록 // PopUp List항목을 조회한다
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> OutProcLotRegistPopList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outproclotregistd.listpop.select", params);
	}

	/**
	 * 외주공정LOT 바코드등록 // PopUp List항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int OutProcLotRegistPopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outproclotregistd.listpop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주공정검사등록 Master항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcessInspMasterList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessinspregist.list.select", params);
	}

	/**
	 * 외주공정검사등록 Master항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcessInspMasterTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessinspregist.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 조회 부분에 외주공정검사등록 Master항목 첫번째 리스트를 출력한다. 
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public String selectOutProcessInspMasterFirstList(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> FirstListMap = (Map<String, Object>) dao.selectByIbatis("scm.outprocess.outprocessinspregist.firstmaster.select", params);
		System.out.println("FirstListMap >>>>>>>>>> " + FirstListMap);

		if (FirstListMap == null) {
			result = null;
		} else {
			String[] inspectionplanno = FirstListMap.get("INSPECTIONPLANNO").toString().split(",");

			result = inspectionplanno[0].toString();
		}

		return result;
	}
	
	/**
	 * 외주공정검사등록 Detail항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcessInspDetailList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessinspregist.detail.select", params);
	}

	/**
	 * 외주공정검사등록 Detail항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcessInspDetailTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessinspregist.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2018.04.19 외주공정검사등록 화면에서 입고대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcessInspRegistPopList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessinspregist.pop.select", params);
	}

	/**
	 * 2018.04.19 외주공정검사등록 화면에서 입고대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcessInspRegistPopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessinspregist.pop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주공정검사 등록 // PopUp에서 적용되는 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcessInspRegistApplyList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessinspregist.popcheck.select", params);
	}

	/**
	 * 외주공정검사 등록 // PopUp에서 적용되는 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcessInspRegistApplyTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessinspregist.popcheck.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주공정검사 등록 // Master 데이터등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcessInspRegist(HashMap<String, Object> params) throws Exception {

		String inspno = null;
		try {

			String InspNo = StringUtil.nullConvert(params.get("InspNo"));
			if (!InspNo.isEmpty()) {

			} else {
				List ordernoList = dao.selectListByIbatis("scm.outprocess.outprocessinspregist.inspectionplanno.find", params);
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

			System.out.println("inspno No >>>>>>>>>> " + inspno);

			int updateResult = dao.update("scm.outprocess.outprocessinspregist.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SCM_INSPCETION_H fail.");
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
	 * 외주공정검사 등록 // Detail 데이터등록
	 * 
	 * @param params - 등록할 정보
	 * 
	 * @return RequestPurchaseService 성공여부
	 * 
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcessInspRegistD(HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutProcessInspRegistDGrid 1. >>>>>>>>>> ");
		try {
			System.out.println("insertOutProcessInspRegistDGrid 2. >>>>>>>>>> " + params.get("data"));
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
			System.out.println("insertOutProcessInspRegistD 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				master.put("REGISTID", loginVO.getId());
				master.put("REQCONFIRMQTY", "0");
				// 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경
				master.put("CONFIRMYN", "Y");

				int updateResult = dao.update("scm.outprocess.outprocessinspregist.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_SCM_INSPECTION_D fail.");
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
	 * 외주공정검사 등록 // Master 데이터변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcessInspRegist(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("scm.outprocess.outprocessinspregist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SCM_INSPECTION_H fail.");
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
	 * 외주공정검사 등록 // Detail 데이터변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcessInspRegistD(HashMap<String, Object> params) throws Exception {

		System.out.println("updateOutProcessInspRegistD Start. >>>>>>>>>> ");
		try {
			System.out.println("updateOutProcessInspRegistD 1. >>>>>>>>>> ");
			System.out.println("updateOutProcessInspRegistD 2. >>>>>>>>>> " + params.get("data"));
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

			System.out.println("updateOutProcessInspRegistD 3. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				LoginVO loginVO = getLoginVO();

				// porno 등록유무 확인
				List pornoList = dao.selectListByIbatis("scm.outprocess.outprocessinspregist.detail.find", master);
				Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
				int poCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateOutProcessInspRegistD poCheck >>>>>>>>>> " + poCheck);
				if (poCheck == 0) {
					// 생성
					master.put("REGISTID", loginVO.getId());
					// 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경
					master.put("CONFIRMYN", "Y");

					int updateResult = dao.update("scm.outprocess.outprocessinspregist.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_SCM_INSPECTION_D fail.");
					}
				} else {
					// 변경
					master.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("scm.outprocess.outprocessinspregist.detail.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_SCM_INSPECTION_D fail.");
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
	 * 외주공정검사 등록 // Detail 데이터삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOutProcessInspRegistMD(HashMap<String, Object> params) throws Exception {

		String inspno = null;
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

			inspno = StringUtil.nullConvert(master.get("InspNo"));
			
			master.put("REGISTID", loginVO.getId());

			master.put("INSPECTIONPLANNO", inspno);

			System.out.println("inspno No >>>>>>>>>> " + inspno);
			
			List<?> cklist = dao.selectListByIbatis("scm.outproc.transcheck.select", master);
			System.out.println("deleteOutProcLotRegistD >>>>>>>>>> " + cklist);
			Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
			int inspcnt = NumberUtil.getInteger(ck.get("INSPCNT"));
			System.out.println("tradecnt >>>>>>>>>> " + inspcnt);
			
			if(inspcnt > 0){
				params.put("masage", "해당 검사번호의 외주입고 데이터가 존재합니다.<br/>삭제 후 제거가 가능합니다.");
				System.out.println("tradecnt N >>>>>>>>>> " + inspcnt);
			}else{
				int updateResultd = dao.delete("scm.outprocess.outprocessinspregist.all.delete", master);
				if (updateResultd == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_SCM_INSPECTION_D fail.");
				}else{
					params.put("masage", "정상적으로 삭제 하였습니다.");
					System.out.println("tradecnt Y >>>>>>>>>> " + inspcnt);
				}

				int updateResult = dao.delete("scm.outprocess.outprocessinspregist.master.delete", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("delete CB_SCM_INSPECTION_H fail.");
				}else{
					params.put("masage", "정상적으로 삭제 하였습니다.");
					System.out.println("tradecnt Y >>>>>>>>>> " + inspcnt);
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

		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}
	
	/**
	 * 외주공정검사관리 // 검사번호 Lov List항목 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> OutProcessInspNoLovList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessinspregist.lov.select", params);
	}

	/**
	 * 외주공정검사관리 // 검사번호 Lov List항목 총 갯수를 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int OutProcessInspNoLovTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessinspregist.lov.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 외주공정 발주현황 조회 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcOrderStateList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.outprocessorderstatelist.select", params);
	}

	/**
	 * 외주공정 발주현황 조회 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcOrderStateTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.outprocessorderstatelist.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 외주입고 확정 // 상태 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutTransDetailStatus(HashMap<String, Object> params) throws Exception {

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

			master.put("UPDATEID", login.getId());
			int updateResult1 = dao.update("scm.outprocess.trans.detail.status.update", master);
			if (updateResult1 == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_OUT_TRANS_D fail.");
			}
			

			Integer orgid = NumberUtil.getInteger(params.get("ORGID"));
			Integer companyid = NumberUtil.getInteger(params.get("COMPANYID"));
			String outtransno = StringUtil.nullConvert(params.get("OUTTRANSNO"));
			Integer outtransseq = NumberUtil.getInteger(params.get("OUTTRANSSEQ"));
			String transyn = StringUtil.nullConvert(params.get("TRANSYN"));
			params.put("ORGID", orgid);
			params.put("COMPANYID", companyid);
			params.put("OUTTRANSNO", outtransno);
			params.put("OUTTRANSSEQ", outtransseq);
			params.put("TRANSYN", transyn);
			
			params.put("REGISTID", login.getId());
			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");
			System.out.println("외주입고 > 부적합 데이터 생성 / 삭제 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("scmoutprocess.change.ncr.update.call.Procedure", params);
			System.out.println("외주입고 > 부적합 데이터 생성 / 삭제 PROCEDURE 호출 End.  >>>>>>>> " + params);
			
			String status = StringUtil.nullConvert(params.get("RETURNSTATUS"));
			if ( !status.equals("S") ) {
				errcnt++;
				throw new Exception("call CB_SCM_PKG.CB_CHANGE_NCR_U FAIL.");
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
	 * 외주입고대기 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertScmOutTransWaitList(Map<String, Object> params) throws Exception {
		System.out.println("insertScmOutTransWaitList Start. >>>>>>>>>> " + params);
		
		List<?> list = (List<?>) params.get("data");
		final int SIZE = list.size();

		LoginVO login = getLoginVO();
		int errcnt = 0;

		LoginVO loginVO = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			System.out.println("insertScmOutTransWaitList 1-1. >>>>>>>>>> " + master);

			master.put("OutTransDate",master.get("TRANSDATE")); 
			List ordernoList = dao.selectListByIbatis("prod.outtrans.new.outtransno.select", master);
			Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
			master.put("OUTTRANSNO", current.get("OUTTRANSNO"));
			
			master.put("REGISTID", loginVO.getId());

			master.put("searchOrgId", master.get("ORGID"));
			master.put("searchCompanyId", master.get("COMPANYID"));
			master.put("OutTransDate", master.get("TRANSDATE"));
			master.put("PersonCode", master.get("OUTPOPERSON"));
			master.put("CustomerCode", master.get("CUSTOMERCODEOUT"));
			int updateResult = dao.update("prod.outtrans.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_OUT_TRANS_H fail.");
			}
			
			master.put("TRANSQTY",master.get("EXTRANSQTY"));
			
			int updateResult2 = dao.update("prod.outtrans.detail.insert", master);
			if (updateResult2 == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_OUT_TRANS_D fail.");
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
	 * 단가적용 // 상태 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcOrderStateList(HashMap<String, Object> params) throws Exception {

		int errcnt = 0;
		List<?> list = (List<?>) params.get("data");
		final int SIZE = list.size();

		LoginVO login = getLoginVO();
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());
			String standdate = StringUtil.nullConvert(master.get("STANDDATE"));
			String[] sList1 = standdate.split("T");
			master.put("STANDDATE", sList1[0]);
			
			int updateResult = dao.update("prod.sales.price.routing.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SALES_PRICE_ROUTING fail.");
			}
			
			dao.update("prod.sales.price.routing.update", master);
			
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
	 * 월별 외주입고현황 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectScmOutTransModelList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outprocess.trans.model.list.select", params);
	}

	/**
	 * 월별 외주입고현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectScmOutTransModelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outprocess.trans.model.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
}