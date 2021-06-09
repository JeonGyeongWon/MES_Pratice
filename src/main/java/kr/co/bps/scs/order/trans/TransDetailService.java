package kr.co.bps.scs.order.trans;

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
 * @ClassName : TransDetailService.java
 * @Description : TransDetail Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2017. 11.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class TransDetailService extends BaseService {

	/**
	 * 거래명세서관리의 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectTransDetailMasterList(Map<String, Object> params) throws Exception {

		return dao.list("order.trans.transdetaillist.master.select", params);
	}

	/**
	 * 거래명세서관리의 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectTransDetailMasterTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.trans.transdetaillist.master.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 거래명세서관리의 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectTransDetailDetailList(Map<String, Object> params) throws Exception {

		return dao.list("order.trans.transdetaillist.detail.select", params);
	}

	/**
	 * 거래명세서관리의 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectTransDetailDetailTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.trans.transdetaillist.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 거래명세서관리 // 마스터 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertTransDetailMasterList(HashMap<String, Object> params) throws Exception {
		String tradeno = null;
		try {
			tradeno = StringUtil.nullConvert(params.get("TradeNo"));
			if (tradeno.isEmpty()) {
				List sonolist = dao.selectListByIbatis("order.trans.transdetaillist.transno.find", params);
				Map<String, Object> current = (Map<String, Object>) sonolist.get(0);
				params.put("Tradeno", current.get("FINDTRADENO"));
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

			String tradedate = StringUtil.nullConvert(master.get("TradeDate"));
			String[] sList1 = tradedate.split("T");
			master.put("TRADEDATE", sList1[0]);
			
			System.out.println("insertShipRegistManageMasterList Master >>>>>>>>>> " + master);
			System.out.println("insertShipRegistManageMasterList tradedate >>>>>>>>>> " + sList1);

			int updateResult = dao.update("order.trans.transdetaillist.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TRADE_H fail.");
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
	 * 거래명세서관리 // 디테일 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertTransDetailDetailList(Map<String, Object> params) throws Exception {
		try {
			System.out.println("insertShipRegistManageDetailList Start. >>>>>>>>>> " + params.get("data"));
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			Map<String, Object> temp = null;
			System.out.println("insertShipRegistManageDetailList 3. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				detail.put("REGISTID", loginVO.getId());
				
				String enddate = StringUtil.nullConvert(detail.get("ENDDATE"));
				String[] sList1 = enddate.split("T");
				detail.put("ENDDATE", sList1[0]);
				
				int updateResult = dao.update("order.trans.transdetaillist.detail.insert", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_TRADE_D fail.");
				} else {
					String orgid = StringUtil.nullConvert(detail.get("ORGID"));
					String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
					String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
					Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
					
					detail.put("ORGID", orgid);
					detail.put("COMPANYID", companyid);
					detail.put("TRADENO", tradeno);
					detail.put("TRADESEQ", tradeseq);
					detail.put("GUBUN", "C");
					detail.put("REGISTID", loginVO.getId());

					detail.put("RETURNSTATUS", "");
					detail.put("MSGDATA", "");
					System.out.println("생성] 거래명세서 생성여부 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("order.trans.ship.transyn.update.call.Procedure", detail);
					System.out.println("생성] 거래명세서 생성여부 PROCEDURE 호출 End.  >>>>>>>> " + detail);

					String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt += 1;
						throw new Exception("call CB_TRADE_PKG.CB_SHIPPING_TRADE_YN_UPDATE fail.");
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
	 * 거래명세서관리 // 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateTransDetailMasterList(HashMap<String, Object> params) throws Exception {

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

			master.put("UPDATEID", loginVO.getId());
			System.out.println("마스터 데이터 변경  master >>>>>>>> " + master);
			int updateResult = dao.update("order.trans.transdetaillist.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TRADE_H fail.");
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
	 * 거래명세서관리 // 디테일 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateTransDetailDetailList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateShipRegistManageDetailList Start. >>>>>>>>>> ");

		try {
			System.out.println("updateShipRegistManageDetailList 1. >>>>>>>>>> "+ params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();
			
			System.out.println("updateShipRegistManageDetailList 3. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			String shipno = null;
			String orgid = null;
			String companyid = null;
			
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);
				
                shipno = StringUtil.nullConvert(detail.get("Shipno"));
				orgid = StringUtil.nullConvert(detail.get("Orgid"));
				companyid = StringUtil.nullConvert(detail.get("CompanyId"));
				
				detail.put("Shipno", shipno);
				detail.put("Orgid", orgid);
				detail.put("CompanyId", companyid);
				
				String enddate = StringUtil.nullConvert(detail.get("ENDDATE"));
				String[] sList1 = enddate.split("T");
				detail.put("ENDDATE", sList1[0]);

				LoginVO loginVO = getLoginVO();
				System.out.println("1. updateShipRegistManageDetailList master >>>>>>>>>> " + detail);
				// porno 등록유무 확인
				List sonoList = dao.selectListByIbatis("order.trans.transdetaillist.transseq.find", detail);
				Map<String, Object> current = (Map<String, Object>) sonoList.get(0);
				int soCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateShipRegistManageDetailList soCheck >>>>>>>>>> " + soCheck);
				if (soCheck == 0) {
					// 생성
					detail.put("REGISTID", loginVO.getId());

					int updateResult = dao.update("order.trans.transdetaillist.detail.insert", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_TRADE_D fail.");
					} else {

						orgid = StringUtil.nullConvert(detail.get("ORGID"));
						companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
						String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
						Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
						
						detail.put("ORGID", orgid);
						detail.put("COMPANYID", companyid);
						detail.put("TRADENO", tradeno);
						detail.put("TRADESEQ", tradeseq);
						detail.put("GUBUN", "C");
						detail.put("REGISTID", loginVO.getId());

						detail.put("RETURNSTATUS", "");
						detail.put("MSGDATA", "");
						System.out.println("생성] 거래명세서 생성여부 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("order.trans.ship.transyn.update.call.Procedure", detail);
						System.out.println("생성] 거래명세서 생성여부 PROCEDURE 호출 End.  >>>>>>>> " + detail);

						String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
						if (!status.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_TRADE_PKG.CB_SHIPPING_TRADE_YN_UPDATE fail.");
						}
					}
				} else {
					// 변경
					detail.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("order.trans.transdetaillist.detail.update", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_TRADE_D fail.");
					} else {

						orgid = StringUtil.nullConvert(detail.get("ORGID"));
						companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
						String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
						Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
						
						detail.put("ORGID", orgid);
						detail.put("COMPANYID", companyid);
						detail.put("TRADENO", tradeno);
						detail.put("TRADESEQ", tradeseq);
						detail.put("GUBUN", "U");
						detail.put("REGISTID", loginVO.getId());

						detail.put("RETURNSTATUS", "");
						detail.put("MSGDATA", "");
						System.out.println("변경] 거래명세서 생성여부 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("order.trans.ship.transyn.update.call.Procedure", detail);
						System.out.println("변경] 거래명세서 생성여부 PROCEDURE 호출 End.  >>>>>>>> " + detail);

						String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
						if (!status.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_TRADE_PKG.CB_SHIPPING_TRADE_YN_UPDATE fail.");
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
	 * 거래명세서관리 // 마스터 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteTransDetailMasterList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		boolean isSuccess = dao.deleteListByIbatis("order.trans.transdetaillist.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 거래명세서관리 // 디테일 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteTransDetailDetailList(HashMap<String, Object> params) throws Exception {

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

			String orgid = StringUtil.nullConvert(detail.get("ORGID"));
			String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
			String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
			Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
			
			detail.put("ORGID", orgid);
			detail.put("COMPANYID", companyid);
			detail.put("TRADENO", tradeno);
			detail.put("TRADESEQ", tradeseq);
			detail.put("GUBUN", "D");
			detail.put("REGISTID", loginVO.getId());

			detail.put("RETURNSTATUS", "");
			detail.put("MSGDATA", "");
			System.out.println("삭제] 거래명세서 생성여부 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("order.trans.ship.transyn.update.call.Procedure", detail);
			System.out.println("삭제] 거래명세서 생성여부 PROCEDURE 호출 End.  >>>>>>>> " + detail);

			String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_TRADE_PKG.CB_SHIPPING_TRADE_YN_UPDATE fail.");
			}
			
			int updateResult = dao.delete("order.trans.transdetaillist.detail.delete", detail);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_TRADE_D fail.");
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
	 * 거래명세서관리의 출력물 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectTransDetailExcelList(Map<String, Object> params) throws Exception {

		return dao.list("order.trans.transexcellist.excel.select", params);
	}
	
	/**
	 * 거래명세서 발행현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectTransDetailStatusList(Map<String, Object> params) throws Exception {

		return dao.list("order.trans.transdetailstatus.list.select", params);
	}

	/**
	 * 거래명세서 발행현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectTransDetailStatusTotcnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.trans.transdetailstatus.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 거래명세서 // 마감일자(이월) 수정
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateTransDetailStatus(HashMap<String, Object> params) throws Exception {

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

			master.put("UPDATEID", loginVO.getId());
			System.out.println("마스터 데이터 변경  master >>>>>>>> " + master);
			int updateResult = dao.update("order.trans.transdetailstatus.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TRADE_D fail.");
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
}