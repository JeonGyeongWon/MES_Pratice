package kr.co.bps.scs.prod.outorder;

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
public class ProdOutOrderService extends BaseService {
	/**
	 * 구매발주조회 마스터 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdOutOrderList(Map<String, Object> params) throws Exception {

		return dao.list("prod.outorder.master.list", params);
	}

	/**
	 * 구매발주조회 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdOutOrderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outorder.master.count", reqMap);

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
	public List<?> selectProdOutOrderDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.outorder.detail.list", params);
	}

	/**
	 * 구매발주조회 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdOutOrderDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outorder.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 엑셀다운로드 > 구매발주조회 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdOutOrderDetailExcelList(Map<String, Object> params) throws Exception {

		return dao.list("prod.outorder.detail.excel.list", params);
	}

	/**
	 * 엑셀다운로드 > 구매발주조회 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdOutOrderDetailExcelCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outorder.detail.excel.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2018.03.27 외주발주상세정보 화면에서 공정작업대기LIST(발주정보) // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> ProdOutOrderManagePopList(Map<String, Object> params) throws Exception {

		return dao.list("prod.outorder.list.pop.select", params);
	}

	/**
	 * 2018.03.27 외주발주상세정보 화면에서 공정작업대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int ProdOutOrderManagePopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outorder.list.pop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 2018.03.28 발주등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertProdOutorderRegist(HashMap<String, Object> params) throws Exception {

		System.out.println("insertProdOutorderManage Start. >>>>>>>>>> ");
		String pono = null;
		try {
			String outpono = StringUtil.nullConvert(params.get("PoNo"));
			if (outpono.isEmpty()) {
				List ordernoList = dao.selectListByIbatis("prod.outorder.new.outpono.select", params);
				Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
				params.put("OUTPONO", current.get("OUTPONO"));
				pono = (String) current.get("OUTPONO");
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
			//master.put("STATUS", "STAND_BY");
			master.put("OUTPONO", pono);

			System.out.println("outpono No >>>>>>>>>> " + pono);

			int updateResult = dao.update("prod.outorder.header.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_OUT_ORDER_H fail.");
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
	 * 2018.03.28 발주등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * 
	 * @return RequestPurchaseService 성공여부
	 * 
	 * @exception Exception
	 */
	public Map<String, Object> insertProdOutorderRegistGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertProdOutorderManageGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("insertProdOutorderManageGrid 1. >>>>>>>>>> ");
			System.out.println("insertProdOutorderManageGrid 2. >>>>>>>>>> " + params.get("data"));
			// 디테일 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			System.out.println("insertProdOuttransManageGrid 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				System.out.println("insertProdOutorderManageGrid 1. master >>>>>>>>>> " + master);

				master.put("REGISTID", loginVO.getId());

				String[] dateSplit = StringUtil.nullConvert(master.get("DUEDATE")).split("T");
				master.put("DUEDATE", dateSplit[0]);
				
				//master.put("REQCONFIRMQTY", "0");
				//master.put("FINISHYN", "Y");

				String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
				if ( workorderid.isEmpty() ) {
					int updateResult = dao.update("prod.outorder.detail.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_OUT_ORDER_D fail.");
					}
				} else {
					List<?> cklist = dao.selectListByIbatis("prod.outorder.matcheck.find.select", master);
					System.out.println("insertProdOutorderRegistGrid >>>>>>>>>> " + cklist);
					Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
					String matcheck = StringUtil.nullConvert(ck.get("MATCHECK"));
					System.out.println("insertProdOutorderManageGrid matcheck >>>>>>>>>> " + matcheck);
					// N: 자재재고 충분, Y: 자재재고 부족, P: 첫공정이 외주가 아닐경우(저장은 하되 선입선출은 불가), T: 현재 작지순번이 첫공정이 아닐경우
					if (matcheck.equals("N")) {
						params.put("MATCHECK", matcheck);
						int updateResult = dao.update("prod.outorder.detail.insert", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_OUT_ORDER_D fail.");
						} else {
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");
							System.out.println("자재 선입선출 PROCEDURE 호출 Start. >>>>>>>> ");
							dao.list("OutMatPutCreate.call.Procedure", master);
							System.out.println("자재 선입선출 PROCEDURE 호출 End. >>>>>>>> " + master);
							String returnstatus = StringUtil.nullConvert(master.get("RETURNSTATUS"));
							params.put("RETURNSTATUS", returnstatus);
						}

						String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
						System.out.println("update WorkOrder EndDate SYSDATE. >>>>>>>>>> " + workstatus);
						// 공정작업상태가 진행일 경우에만 시작일 UPDATE
						if (workstatus.equals("STAND_BY") || workstatus.equals("PROGRESS")) {
							master.put("UPDATEID", loginVO.getId());
							master.put("STARTDATE", "Y");
							master.put("WORKSTATUS", "START");

							int updateResult1 = dao.update("prod.outorder.workorder.startdate.update", master);
							if (updateResult1 == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("update CB_WORK_ORDER fail.");
							}
						}
					} else if (matcheck.equals("P")) {
						params.put("MATCHECK", matcheck);
						int updateResult = dao.update("prod.outorder.detail.insert", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_OUT_TRANS_D fail.");
						}

						String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
						System.out.println("update WorkOrder EndDate SYSDATE. >>>>>>>>>> " + workstatus);
						// 공정작업상태가 진행일 경우에만 시작일 UPDATE
						if (workstatus.equals("STAND_BY") || workstatus.equals("PROGRESS")) {
							master.put("UPDATEID", loginVO.getId());
							master.put("STARTDATE", "Y");
							master.put("WORKSTATUS", "START");

							int updateResult1 = dao.update("prod.outorder.workorder.startdate.update", master);
							if (updateResult1 == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("update CB_WORK_ORDER fail.");
							}
						}
						System.out.println("insertProdOutorderRegistGrid matcheck. >>>>>>>>>> " + matcheck);
					} else if (matcheck.equals("T")) {
						params.put("MATCHECK", matcheck);
						int updateResult = dao.update("prod.outorder.detail.insert", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_OUT_TRANS_D fail.");
						}

						String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
						System.out.println("update WorkOrder EndDate SYSDATE. >>>>>>>>>> " + workstatus);
						// 공정작업상태가 진행일 경우에만 시작일 UPDATE
						if (workstatus.equals("STAND_BY") || workstatus.equals("PROGRESS")) {
							master.put("UPDATEID", loginVO.getId());
							master.put("STARTDATE", "Y");
							master.put("WORKSTATUS", "START");

							int updateResult1 = dao.update("prod.outorder.workorder.startdate.update", master);
							if (updateResult1 == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("update CB_WORK_ORDER fail.");
							}
						}
						System.out.println("insertProdOutorderRegistGrid matcheck. >>>>>>>>>> " + matcheck);
					} else if (matcheck.equals("Y")) {
						String orgid = StringUtil.nullConvert(master.get("ORGID"));
						String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
						String outpono = StringUtil.nullConvert(master.get("OUTPONO"));
						master.put("searchOrgId", orgid);
						master.put("searchCompanyId", companyid);
						master.put("PoNo", outpono);
						int updateResult = dao.delete("prod.outorder.header.delete", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("delete CB_OUT_ORDER_H fail.");
						} else {
							params.put("MATCHECK", matcheck);
							// params.put("msg", "해당 자재의 LOT수량이 부족하여 저장에 실패하였습니다.");
						}
						System.out.println("insertProdOutorderRegistGrid matcheck. >>>>>>>>>> " + matcheck);
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
	 * 2018.03.29 외주발주 상세정보 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateProdOutOrderManage(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("prod.outorder.header.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_OUT_ORDER_H fail.");
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
	 * 2018.03.29 외주발주 상세정보 그리드 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateProdOutOrderManageGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("updateProdOutOrderManageGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("updateProdOutOrderManageGrid 1. >>>>>>>>>> ");
			System.out.println("updateProdOutOrderManageGrid 2. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			System.out.println("updateProdOutOrderManageGrid 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				System.out.println("updateProdOutOrderManageGrid 1. master >>>>>>>>>> " + master);
				
				LoginVO loginVO = getLoginVO();
				String[] dateSplit = StringUtil.nullConvert(master.get("DUEDATE")).split("T");
				master.put("DUEDATE", dateSplit[0]);

				String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
				if ( workorderid.isEmpty() ) {
					// porno 등록유무 확인
					List pornoList = dao.selectListByIbatis("prod.outorder.detail.find.select", master);
					Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
					int poCheck = NumberUtil.getInteger(current.get("COUNT"));

					System.out.println("2. updateProdOutOrderManageGrid poCheck >>>>>>>>>> " + poCheck);
					if (poCheck == 0) {
						// 생성
						master.put("REGISTID", loginVO.getId());
						// master.put("REQCONFRIMQTY", "0");
						master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

						int updateResult = dao.update("prod.outorder.detail.insert", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_OUT_ORDER_D fail.");
						}
					} else {
						// 변경
						master.put("UPDATEID", loginVO.getId());

						int updateResult = dao.update("prod.outorder.detail.update", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("UPDATE CB_OUT_ORDER_D fail.");
						}
					}
				} else {
					List<?> cklist = dao.selectListByIbatis("prod.outorder.matcheck.find.select", master);
					System.out.println("updateProdOutOrderManageGrid >>>>>>>>>> " + cklist);
					Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
					String matcheck = StringUtil.nullConvert(ck.get("MATCHECK"));
					System.out.println("updateProdOutOrderManageGrid matcheck >>>>>>>>>> " + matcheck);
					// N: 자재재고 충분, P: 첫공정이 외주가 아님(저장은 하되 선입선출은 불가), Y: 자재재고 부족
					if (matcheck.equals("N")) {
						params.put("MATCHECK", matcheck);
						// porno 등록유무 확인
						List pornoList = dao.selectListByIbatis("prod.outorder.detail.find.select", master);
						Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
						int poCheck = NumberUtil.getInteger(current.get("COUNT"));

						System.out.println("2. updateProdOutOrderManageGrid poCheck >>>>>>>>>> " + poCheck);
						if (poCheck == 0) {
							// 생성
							master.put("REGISTID", loginVO.getId());
							// master.put("REQCONFRIMQTY", "0");
							master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

							int updateResult = dao.update("prod.outorder.detail.insert", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("insert into CB_OUT_ORDER_D fail.");
							} else {
								master.put("RETURNSTATUS", "");
								master.put("MSGDATA", "");
								System.out.println("자재 선입선출 PROCEDURE 호출 Start. >>>>>>>> ");
								dao.list("OutMatPutCreate.call.Procedure", master);
								System.out.println("자재 선입선출 PROCEDURE 호출 End. >>>>>>>> " + master);
								String returnstatus = StringUtil.nullConvert(master.get("RETURNSTATUS"));
								params.put("RETURNSTATUS", returnstatus);
							}
						} else {
							// 변경
							master.put("UPDATEID", loginVO.getId());

							int updateResult = dao.update("prod.outorder.detail.update", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("UPDATE CB_OUT_ORDER_D fail.");
							} else {
								master.put("RETURNSTATUS", "");
								master.put("MSGDATA", "");
								master.put("REGISTID", loginVO.getId());
								System.out.println("자재 선입선출 PROCEDURE 호출 Start. >>>>>>>> ");
								dao.list("OutMatPutCreate.call.Procedure", master);
								System.out.println("자재 선입선출 PROCEDURE 호출 End. >>>>>>>> " + master);
								String returnstatus = StringUtil.nullConvert(master.get("RETURNSTATUS"));
								params.put("RETURNSTATUS", returnstatus);
							}
						}
					} else if (matcheck.equals("P")) {
						params.put("MATCHECK", matcheck);
						// porno 등록유무 확인
						List pornoList = dao.selectListByIbatis("prod.outorder.detail.find.select", master);
						Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
						int poCheck = NumberUtil.getInteger(current.get("COUNT"));

						System.out.println("2. updateProdOutOrderManageGrid poCheck >>>>>>>>>> " + poCheck);
						if (poCheck == 0) {
							// 생성
							master.put("REGISTID", loginVO.getId());
							// master.put("REQCONFRIMQTY", "0");
							master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

							int updateResult = dao.update("prod.outorder.detail.insert", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("insert into CB_OUT_TRANS_D fail.");
							}
						} else {
							// 변경
							master.put("UPDATEID", loginVO.getId());

							int updateResult = dao.update("prod.outorder.detail.update", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("UPDATE CB_OUT_ORDER_D fail.");
							}
						}
						System.out.println("updateProdOutOrderManageGrid matcheck. >>>>>>>>>> " + matcheck);

					} else if (matcheck.equals("T")) {
						params.put("MATCHECK", matcheck);
						// porno 등록유무 확인
						List pornoList = dao.selectListByIbatis("prod.outorder.detail.find.select", master);
						Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
						int poCheck = NumberUtil.getInteger(current.get("COUNT"));

						System.out.println("2. updateProdOutOrderManageGrid poCheck >>>>>>>>>> " + poCheck);
						if (poCheck == 0) {
							// 생성
							master.put("REGISTID", loginVO.getId());
							// master.put("REQCONFRIMQTY", "0");
							master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정
															// 상태 ( N -> Y )로 변경

							int updateResult = dao.update("prod.outorder.detail.insert", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("insert into CB_OUT_TRANS_D fail.");
							}
						} else {
							// 변경
							master.put("UPDATEID", loginVO.getId());

							int updateResult = dao.update("prod.outorder.detail.update", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("UPDATE CB_OUT_ORDER_D fail.");
							}
						}
						System.out.println("updateProdOutOrderManageGrid matcheck. >>>>>>>>>> " + matcheck);
					} else if (matcheck.equals("Y")) {
						params.put("MATCHECK", matcheck);
						System.out.println("updateProdOutOrderManageGrid matcheck. >>>>>>>>>> " + matcheck);
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
	 * 2018.03.29 외주발주 상세정보 등록 내역 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteProdOutOrderRegistGrid(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}
		
		Map<String, Object> master = (Map<String, Object>) list.get(0);
     	LoginVO loginVO = getLoginVO();
     	boolean isSuccess = false;
		List<?> cklist = dao.selectListByIbatis("scm.outproc.outordercheck.select", master);
		System.out.println("deleteOutProcLotRegistD >>>>>>>>>> " + cklist);
		Map<String, Object> ck = (Map<String, Object>) cklist.get(0);
		int prevchk = NumberUtil.getInteger(ck.get("PREVCHK"));
		System.out.println("prevchk >>>>>>>>>> " + prevchk);
		
		if(prevchk > 0){
			params.put("masage", "해당 발주번호의 외주입고 또는 외주검사 데이터가 존재합니다.<br/>삭제 후 제거가 가능합니다.");
			System.out.println("tradecnt N >>>>>>>>>> " + prevchk);
		}else{
			isSuccess = dao.deleteListByIbatis("prod.outorder.detail.delete", list) > 0;
			if(isSuccess){				
				int workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
				int orderqty = NumberUtil.getInteger(master.get("ORDERQTY"));
				master.put("WORKORDERSEQ", workorderseq);
				master.put("ORDERQTY", orderqty);
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				master.put("REGISTID", loginVO.getId());
				
				System.out.println("자재 선입선출 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("OutMatOutCreate.call.Procedure", master);
				System.out.println("자재 선입선출 PROCEDURE 호출 End. >>>>>>>> " + master);
				String returnstatus = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				params.put("RETURNSTATUS", returnstatus);
				
				params.put("masage", "정상적으로 삭제 하였습니다.");
				System.out.println("tradecnt Y >>>>>>>>>> " + prevchk);
			}
		}

		params.putAll(super.getExtGridResultMap(isSuccess, "delete"));
		return params;
	}

	/**
	 * 2018.03.29 외주발주 상세정보 등록 마스터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return SpecShippedService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteProdOutOrderRegist(HashMap<String, Object> params) throws Exception {

		String outpono = null;
		try {

			outpono = StringUtil.nullConvert(params.get("PoNo"));

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

			master.put("OUTPONO", outpono);

			System.out.println("outpono No >>>>>>>>>> " + outpono);

			int updateResult = dao.delete("prod.outorder.header.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_OUT_ORDER_H fail.");
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

	public int selectOutOrderInOutListCount(HashMap<String, Object> params) {
		
		List<?> count = dao.list("prod.outorder.InOut.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	public List<?> selectOutOrderInOutListData(HashMap<String, Object> params) {
		
		return dao.list("prod.outorder.InOut.list",params);
	}

	public List<?> selectOutOrderInOutListExcelData(HashMap<String, Object> params) {
		// TODO Auto-generated method stub
		return dao.list("prod.outorder.InOut.Excel.list",params);
	}


}