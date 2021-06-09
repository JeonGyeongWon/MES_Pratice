package kr.co.bps.scs.prod.outtrans;

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
public class ProdOutTransService extends BaseService {

	//	여기부터 외주입고등록 조회 화면
	/**
	 * 조회 부분에 외주입고등록현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 목록
	 * @exception Exception
	 */
	public List<?> selectProdOutTransList(Map<String, Object> params) throws Exception {

		return dao.list("prod.outtrans.list.select", params);
	}

	/**
	 * 조회 부분에 외주입고등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectProdOutTransCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outtrans.list.count", reqMap);

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
	public List<?> selectProdOutTransDetail(Map<String, Object> params) throws Exception {

		return dao.list("prod.outtrans.detail.select", params);
	}

	/**
	 * 조회 부분에 외주입고등록현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return RequestPurchaseService 총 갯수
	 * @exception Exception
	 */
	public int selectProdOutTransDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.outtrans.detail.count", reqMap);

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
		public List<?> selectProdOutTransManageDetail(Map<String, Object> params) throws Exception {

			return dao.list("prod.outtrans.detail.select", params);
		}

		/**
		 * 2018.03.15 입하등록 상세 화면 항목 총 갯수를 조회한다.
		 * 
		 * @param params
		 *            - 조회할 정보
		 * @return RequestPurchaseService 총 갯수
		 * @exception Exception
		 */
		public int selectProdOutTransManageDetailCount(HashMap<String, Object> reqMap) {
			List<?> count = dao.list("prod.outtrans.detail.count", reqMap);

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
		public List<?> ProdOutTransMnagePopList(Map<String, Object> params) throws Exception {

			return dao.list("prod.outtrans.list.pop.select", params);
		}

		/**
		 * 2017.02.22 입하상세정보 화면에서 입하대기LIST(발주정보) // POPUP LIST 총 갯수를 조회한다.
		 * 
		 * @param params
		 *            - 조회할 정보
		 * @return SearchService 총 갯수
		 * @exception Exception
		 */
		public int ProdOutTransMnagePopTotCnt(HashMap<String, Object> reqMap) {
			List<?> count = dao.list("prod.outtrans.list.pop.count", reqMap);

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
		public Map<String, Object> insertProdOuttransManage(HashMap<String, Object> params) throws Exception {

			System.out.println("insertProdOuttransManage Start. >>>>>>>>>> ");
			String transno = null;
			try {

				String outtransno = StringUtil.nullConvert(params.get("searchTransNo"));
				if (!outtransno.isEmpty()) {

				} else {
					List ordernoList = dao.selectListByIbatis("prod.outtrans.new.outtransno.select", params);
					Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
					params.put("OUTTRANSNO", current.get("OUTTRANSNO"));
					transno = (String) current.get("OUTTRANSNO");
//					params.put("OUTTRANSDATE", current.get("OUTTRANSDATE"));
//					OutTransDate = (String) current.get("OUTTRANSDATE");
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

	/**
	 * 2018.12.16 입고등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * @return RequestPurchaseService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertProdOuttransManageGrid(HashMap<String, Object> params) throws Exception {

		System.out.println("insertProdOuttransManageGrid Start. >>>>>>>>>> ");
		try {
			System.out.println("insertProdOuttransManageGrid 1. >>>>>>>>>> " + params.get("data"));
			// 디테일 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			System.out.println("insertProdOuttransManageGrid 2. >>>>>>>>>> " + list.size());

			LoginVO loginVO = getLoginVO();
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);

				master.put("REGISTID", loginVO.getId());
				//master.put("REQCONFIRMQTY", "0");
				//master.put("FINISHYN", "Y");

				int updateResult = dao.update("prod.outtrans.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_OUT_TRANS_D fail.");
				} else {
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
					// 생산수량 생성 PKG 호출 끝
				}

//				String finishyn = StringUtil.nullConvert(master.get("FINISHYN"));
//				String postatus = StringUtil.nullConvert(master.get("POSTATUS"));
//				String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
//				if (finishyn.equals("Y")) {
//					// 완료일 때 발주 완료 처리
//
//					System.out.println("완료 프로세스  >>>>>>>> " + master);
//					System.out.println("FINISHYN  >>>>>>>> " + finishyn);
//					System.out.println("POSTATUS  >>>>>>>> " + postatus);
//					System.out.println("WORKSTATUS  >>>>>>>> " + workstatus);
//
//					if (postatus.equals("STAND_BY")) {
//						master.put("UPDATEID", loginVO.getId());
//						master.put("CHANGESTATUS", "COMPLETE");
//
//						int updateResult1 = dao.update("prod.outtrans.postatus.update", master);
//						if (updateResult1 == 0) {
//							// 저장 실패시 띄우는 예외처리
//							errcnt += 1;
//							throw new Exception("update CB_OUT_ORDER_H fail.");
//						}
//					}
//
//					// 완료일때 공정 종료일자 UPDATE
//					if (workstatus.equals("START") || workstatus.equals("PROGRESS") || workstatus.equals("END")) {
//
//						Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
//						Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
//						String outtransno = StringUtil.nullConvert(master.get("OUTTRANSNO"));
//						Integer outtransseq = NumberUtil.getInteger(master.get("OUTTRANSSEQ"));
//
//						master.put("ORGID", orgid);
//						master.put("COMPANYID", companyid);
//						master.put("OUTTRANSNO", outtransno);
//						master.put("OUTTRANSSEQ", outtransseq);
//
//						List qtycheckt = dao.selectListByIbatis("prod.outtrans.workplanqty.check.select", master);
//						Map<String, Object> current = (Map<String, Object>) qtycheckt.get(0);
//						Integer sumqty = NumberUtil.getInteger(current.get("SUMQTY"));
//						Integer orderqty = NumberUtil.getInteger(current.get("ORDERQTY"));
//						System.out.println("sumqty  >>>>>>>> " + sumqty);
//						System.out.println("orderqty  >>>>>>>> " + orderqty);
//
//						// 계획수량보다 해당 작지의 입고수량의 합이 같거나 클 경우 공정완료상태 변경
//						if (sumqty >= orderqty) {
//							master.put("UPDATEID", loginVO.getId());
//							master.put("ENDDATE", "Y");
//							master.put("WORKSTATUS", "END");
//
//							System.out.println("완료일때 공정 종료일자 UPDATE  >>>>>>>> " + master);
//
//							int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//							if (updateResult2 == 0) {
//								// 저장 실패시 띄우는 예외처리
//								errcnt += 1;
//								throw new Exception("update CB_WORK_ORDER fail.");
//							}
//						} else {
//							master.put("UPDATEID", loginVO.getId());
//							master.put("ENDDATE", "N");
//							master.put("WORKSTATUS", "START");
//
//							int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//							if (updateResult2 == 0) {
//								// 저장 실패시 띄우는 예외처리
//								errcnt += 1;
//								throw new Exception("update CB_WORK_ORDER fail.");
//							}
//						}
//					}
//
//				} else {
//					// 미완료일 때 발주 대기 처리
//					System.out.println("완료 프로세스  >>>>>>>> " + master);
//					System.out.println("FINISHYN  >>>>>>>> " + finishyn);
//					System.out.println("POSTATUS  >>>>>>>> " + postatus);
//					System.out.println("WORKSTATUS  >>>>>>>> " + workstatus);
//
//					if (postatus.equals("COMPLETE")) {
//						master.put("UPDATEID", loginVO.getId());
//						master.put("CHANGESTATUS", "STAND_BY");
//
//						System.out.println("미완료일 때 발주 대기 처리 UPDATE  >>>>>>>> " + master);
//						int updateResult1 = dao.update("prod.outtrans.postatus.update", master);
//						if (updateResult1 == 0) {
//							// 저장 실패시 띄우는 예외처리
//							errcnt += 1;
//							throw new Exception("update CB_OUT_ORDER_H fail.");
//						}
//					}
//
//					// 미완료일때 공정 종료일자 NULL 처리
//					if (workstatus.equals("START") || workstatus.equals("PROGRESS") || workstatus.equals("END")) {
//						master.put("UPDATEID", loginVO.getId());
//						master.put("ENDDATE", "N");
//
//						System.out.println("미완료일때 공정 종료일자 NULL 처리 UPDATE  >>>>>>>> " + master);
//						int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//						if (updateResult2 == 0) {
//							// 저장 실패시 띄우는 예외처리
//							errcnt += 1;
//							throw new Exception("update CB_WORK_ORDER fail.");
//						}
//					}
//				}
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
		public Map<String, Object> updateProdOutTransManage(HashMap<String, Object> params) throws Exception {

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

			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
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
		public Map<String, Object> updateProdOutTransManageGrid(HashMap<String, Object> params) throws Exception {

			System.out.println("updateProdOutTransManageGrid Start. >>>>>>>>>> ");
			try {
				System.out.println("updateProdOutTransManageGrid 1. >>>>>>>>>> " + params.get("data"));
				// 마스터 등록
				int errcnt = 0;
				List<?> list = (List<?>) params.get("data");

				System.out.println("updateProdOutTransManageGrid 3. >>>>>>>>>> " + list.size());
				LoginVO loginVO = getLoginVO();
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> master = (Map<String, Object>) list.get(i);

					// porno 등록유무 확인
					List pornoList = dao.selectListByIbatis("prod.outtrans.detail.find.select", master);
					Map<String, Object> current = (Map<String, Object>) pornoList.get(0);
					int poCheck = NumberUtil.getInteger(current.get("COUNT"));

					System.out.println("2. updateProdOutTransManageGrid poCheck >>>>>>>>>> " + poCheck);
					if (poCheck == 0) {
						// 생성
						master.put("REGISTID", loginVO.getId());
						//					master.put("REQCONFRIMQTY", "0");
						master.put("CONFIRMYN", "Y"); // 2016.10.05 기본값 확정 상태 ( N -> Y )로 변경

						int updateResult = dao.update("prod.outtrans.detail.insert", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("insert into CB_OUT_TRANS_D fail.");
						}
					} else {
						// 변경
						master.put("UPDATEID", loginVO.getId());

						int updateResult = dao.update("prod.outtrans.detail.update", master);
						if (updateResult == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("UPDATE CB_OUT_TRANS_D fail.");
						}else {
								// 저장 성공시 생산수량 생성 PKG 호출
								Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
								Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
								String outtransno = StringUtil.nullConvert(master.get("OUTTRANSNO"));
								Integer outtransseq = NumberUtil.getInteger(master.get("OUTTRANSSEQ"));
								String gubun = "U";

								master.put("ORGID", orgid);
								master.put("COMPANYID", companyid);
								master.put("OUTTRANSNO", outtransno);
								master.put("OUTTRANSSEQ", outtransseq);
								master.put("GUBUN", gubun);

								master.put("P_LOGIN", loginVO.getId());
								master.put("RS_CODE", "");
								master.put("RS_STATUS", "");
								System.out.println("로그인 ID >>>>>>>> " + loginVO.getId() );
								System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 Start. >>>>>>>> ");
								dao.list("prodWorkOrderCreate.call.Procedure", master);
								System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

								String status = StringUtil.nullConvert(master.get("RS_STATUS"));
								String rscode = StringUtil.nullConvert(master.get("RS_CODE"));
								if (!rscode.equals("S")) {
									errcnt += 1;
									throw new Exception("call CB_OUTSIDE_ORDER_PKG.CB_WORK_ORDER_CREATE fail. >>>>>>>>>>>>   " + status);
								}
								// 생산수량 생성 PKG 호출 끝
						}
					}
					
//					String finishyn = StringUtil.nullConvert(master.get("FINISHYN"));
//					String postatus = StringUtil.nullConvert(master.get("POSTATUS"));
//					String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
////					Number orderqty = master.get("ORDERQTY");
////					String transqty = master.get("TRANSQTY");
////					String extransqty = master.get("EXTRANSQTY");
//					if ( finishyn.equals("Y") ) {
//						// 완료일 때 발주 완료 처리
//						if ( postatus.equals("STAND_BY") ) {
//							master.put("UPDATEID", loginVO.getId());
//							master.put("CHANGESTATUS", "COMPLETE");
//
//							int updateResult1 = dao.update("prod.outtrans.postatus.update", master);
//							if (updateResult1 == 0) {
//								// 저장 실패시 띄우는 예외처리
//								errcnt += 1;
//								throw new Exception("update CB_OUT_ORDER_H fail.");
//							}
//						}
//						
//						System.out.println(" updateWorkOrder EndDate Update >>>>>>>>>> " + workstatus);
//						//if (orderqty == transqty + extransqty){
//							// 완료, (발주수량 = 입고수량+기입고수량)  일때 공정 종료일자 UPDATE
//							if ( workstatus.equals("START") || workstatus.equals("END")) {
//								
//								Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
//								Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
//								String outtransno = StringUtil.nullConvert(master.get("OUTTRANSNO"));
//								Integer outtransseq = NumberUtil.getInteger(master.get("OUTTRANSSEQ"));
//								
//								master.put("ORGID", orgid);
//								master.put("COMPANYID", companyid);
//								master.put("OUTTRANSNO", outtransno);
//								master.put("OUTTRANSSEQ", outtransseq);
//								
//								List qtycheckt = dao.selectListByIbatis("prod.outtrans.workplanqty.check.select", master);
//								Map<String, Object> currents = (Map<String, Object>) qtycheckt.get(0);
//								Integer sumqty = NumberUtil.getInteger(currents.get("SUMQTY"));
//								Integer orderqty = NumberUtil.getInteger(currents.get("ORDERQTY"));
//								System.out.println("sumqty  >>>>>>>> " + sumqty);
//								System.out.println("orderqty  >>>>>>>> " + orderqty);
//								
//								// 계획수량보다 해당 작지의 입고수량의 합이 같거나 클 경우 공정완료상태 변경
//								if(sumqty >=  orderqty){
//									master.put("UPDATEID", loginVO.getId());
//									master.put("ENDDATE", "Y");
//		
//									int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//									if (updateResult2 == 0) {
//										// 저장 실패시 띄우는 예외처리
//										errcnt += 1;
//										throw new Exception("update CB_WORK_ORDER fail.");
//									}
//								}else{
//									master.put("UPDATEID", loginVO.getId());
//									master.put("ENDDATE", "N");
//									master.put("WORKSTATUS", "START");
//		
//									int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//									if (updateResult2 == 0) {
//										// 저장 실패시 띄우는 예외처리
//										errcnt += 1;
//										throw new Exception("update CB_WORK_ORDER fail.");
//									}
//								}
//							}
//						//}
//
//					} else {
//						// 미완료일 때 발주 대기 처리
//						if ( postatus.equals("COMPLETE") ) {
//							master.put("UPDATEID", loginVO.getId());
//							master.put("CHANGESTATUS", "STAND_BY");
//
//							int updateResult1 = dao.update("prod.outtrans.postatus.update", master);
//							if (updateResult1 == 0) {
//								// 저장 실패시 띄우는 예외처리
//								errcnt += 1;
//								throw new Exception("update CB_OUT_ORDER_H fail.");
//							}
//						}
//						
//						System.out.println(" updateWorkOrder EndDate Update >>>>>>>>>> " + workstatus);
//						// 미완료일때 공정 종료일자 NULL 처리
//						if ( workstatus.equals("START") || workstatus.equals("END")) {
//							master.put("UPDATEID", loginVO.getId());
//							master.put("ENDDATE", "N");
//
//							int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
//							if (updateResult2 == 0) {
//								// 저장 실패시 띄우는 예외처리
//								errcnt += 1;
//								throw new Exception("update CB_WORK_ORDER fail.");
//							}
//						}
//					}
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
		public Map<String, Object> deleteProdOutTransManageD(Map<String, Object> params) throws Exception {

			List<Object> list = super.getGridData(params);
			if (list.size() == 0)
				return super.getExtGridResultMap(false);
						
			int errcnt = 0, count = 0;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> master = (Map<String, Object>) list.get(i);
				
				Integer orgid = NumberUtil.getInteger(master.get("ORGID"));
				Integer companyid = NumberUtil.getInteger(master.get("COMPANYID"));
				String outpono = StringUtil.nullConvert(master.get("OUTPONO"));
				//Integer outposeq = NumberUtil.getInteger(master.get("OUTPOSEQ"));
				
				LoginVO loginVO = getLoginVO();
				
				master.put("REGISTID", loginVO.getId());
				
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("OUTPONO", outpono);
				//master.put("OUTPOSEQ", outposeq);
				master.put("CHANGESTATUS", "STAND_BY");
				
				System.out.println("outpono No >>>>>>>>>> " + outpono);
				//System.out.println("outposeq SEQ >>>>>>>>>> " + outposeq);
				
				int updateResult = dao.delete("prod.outtrans.header.delete.outorderflagupdate", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("update CB_OUT_ORDER_H fail.");
				}else{
					master.put("UPDATEID", loginVO.getId());
					master.put("ENDDATE", "N");
					master.put("WORKSTATUS", "START");
					int updateResult2 = dao.update("prod.outtrans.workorder.enddate.update", master);
					if (updateResult2 == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("update CB_WORK_ORDER fail.");
					}else{
						int updateResult3 = dao.update("prod.outtrans.header.delete.outorderflagdelete", master);
						if (updateResult3 == 0) {
							// 저장 실패시 띄우는 예외처리
							errcnt += 1;
							throw new Exception("update CB_WORK_ORDER_D fail.");
						}
					}
				}
			}

			boolean isSuccess = dao.deleteListByIbatis("prod.outtrans.detail.delete", list) > 0;

			return super.getExtGridResultMap(isSuccess, "delete");
		}

		/**
		 * 2018.03.26 외주입고 상세정보 등록 마스터 삭제
		 * 
		 * @param params
		 *            - 등록할 정보
		 * @return SpecShippedService 성공여부
		 * @exception Exception
		 */
		public Map<String, Object> deleteProdOutTransManageH(HashMap<String, Object> params) throws Exception {

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

				int updateResult = dao.delete("prod.outtrans.header.delete", master);
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
		
}