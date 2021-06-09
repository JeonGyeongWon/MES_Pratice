package kr.co.bps.scs.scm.trade;

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
 * @ClassName : ScmTradeService.java
 * @Description : ScmTrade Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2021. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ScmTradeService extends BaseService {

	/**
	 * 외주 거래명세서 마스터 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcTradeMasterList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outproctrade.master.select", params);
	}

	/**
	 * 외주 거래명세서 마스터 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcTradeMasterTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outproctrade.master.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 외주 거래명세서 상세 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectOutProcTradeDetailList(Map<String, Object> params) throws Exception {

		return dao.list("scm.outproctrade.detail.select", params);
	}

	/**
	 * 외주 거래명세서 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectOutProcTradeDetailTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("scm.outproctrade.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 외주 거래명세서 // 마스터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcTradeMasterList(HashMap<String, Object> params) throws Exception {

		String tradeno = null;
		try {
			String TradeNo = StringUtil.nullConvert(params.get("TradeNo"));
			if (TradeNo.isEmpty()) {
				List noList = dao.selectListByIbatis("scm.outproctrade.new.tradeno.select", params);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				params.put("TRADENO", current.get("TRADENO"));
				tradeno = (String) current.get("TRADENO");
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

			master.put("TRADENO", tradeno);

			System.out.println("insertOutProcTradeMasterList No >>>>>>>>>> " + tradeno);

			int updateResult = dao.update("scm.outproctrade.master.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SCM_TRADE_H fail.");
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
	 * 외주 거래명세서 // 상세 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertOutProcTradeDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertOutProcTradeDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertOutProcTradeDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			Map<String, Object> temp = null;
			System.out.println("insertOutProcTradeDetailList 2. >>>>>>>>>> " + list.size());
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				detail.put("REGISTID", loginVO.getId());
				
				int updateResult = dao.update("scm.outproctrade.detail.insert", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_SCM_TRADE_D fail.");
				} else {

					String orgid = StringUtil.nullConvert(detail.get("ORGID"));
					String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
					String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
					Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
					String gubun = "I";

					detail.put("ORGID", orgid);
					detail.put("COMPANYID", companyid);
					detail.put("TRADENO", tradeno);
					detail.put("TRADESEQ", tradeseq);
					detail.put("GUBUN", gubun);
					detail.put("REGISTID", loginVO.getId());

					detail.put("RETURNSTATUS", "");
					detail.put("MSGDATA", "");
					System.out.println("외주 거래명세서 등록 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("scm.outproctrade.detail.manage.call.Procedure", detail);
					System.out.println("외주 거래명세서 등록 PROCEDURE 호출 End.  >>>>>>>> " + detail);

					String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt++;
						throw new Exception("call CB_SCM_PKG.CB_SCM_TRADE_D_MANAGE FAIL.");
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
	 * 외주 거래명세서 // 마스터 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcTradeMasterList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.update("scm.outproctrade.master.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_SCM_TRADE_H fail.");
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
	 * 외주 거래명세서 // 상세 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateOutProcTradeDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("updateOutProcTradeDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("updateOutProcTradeDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 마스터 등록
			int errcnt = 0, count = 0;
			List<?> list = (List<?>) params.get("data");
			final int SIZE = list.size();

			LoginVO loginVO = getLoginVO();
			System.out.println("updateOutProcTradeDetailList 2. >>>>>>>>>> " + list.size());
			Map<String, Object> temp = null;
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);
				temp = (Map<String, Object>) list.get(i);

				// 등록유무 확인
				List noList = dao.selectListByIbatis("scm.outproctrade.detail.find.select", detail);
				Map<String, Object> current = (Map<String, Object>) noList.get(0);
				int noCheck = NumberUtil.getInteger(current.get("COUNT"));

				System.out.println("2. updateOutProcTradeDetailList noCheck >>>>>>>>>> " + noCheck);
				if (noCheck == 0) {
					// 생성
					detail.put("REGISTID", loginVO.getId());
					
					int updateResult = dao.update("scm.outproctrade.detail.insert", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("insert into CB_SCM_TRADE_D fail.");
					} else {

						String orgid = StringUtil.nullConvert(detail.get("ORGID"));
						String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
						String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
						Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
						String gubun = "I";

						detail.put("ORGID", orgid);
						detail.put("COMPANYID", companyid);
						detail.put("TRADENO", tradeno);
						detail.put("TRADESEQ", tradeseq);
						detail.put("GUBUN", gubun);
						detail.put("REGISTID", loginVO.getId());

						detail.put("RETURNSTATUS", "");
						detail.put("MSGDATA", "");
						System.out.println("외주 거래명세서 등록 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("scm.outproctrade.detail.manage.call.Procedure", detail);
						System.out.println("외주 거래명세서 등록 PROCEDURE 호출 End.  >>>>>>>> " + detail);

						String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
						if (!status.equals("S")) {
							errcnt++;
							throw new Exception("call CB_SCM_PKG.CB_SCM_TRADE_D_MANAGE FAIL.");
						}
					}
				} else {
					// 변경
					detail.put("UPDATEID", loginVO.getId());

					int updateResult = dao.update("scm.outproctrade.detail.update", detail);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_SCM_TRADE_D fail.");
					} else {

						String orgid = StringUtil.nullConvert(detail.get("ORGID"));
						String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
						String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
						Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
						String gubun = "U";

						detail.put("ORGID", orgid);
						detail.put("COMPANYID", companyid);
						detail.put("TRADENO", tradeno);
						detail.put("TRADESEQ", tradeseq);
						detail.put("GUBUN", gubun);
						detail.put("REGISTID", loginVO.getId());

						detail.put("RETURNSTATUS", "");
						detail.put("MSGDATA", "");
						System.out.println("외주 거래명세서 변경 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("scm.outproctrade.detail.manage.call.Procedure", detail);
						System.out.println("외주 거래명세서 변경 PROCEDURE 호출 End.  >>>>>>>> " + detail);

						String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
						if (!status.equals("S")) {
							errcnt++;
							throw new Exception("call CB_SCM_PKG.CB_SCM_TRADE_D_MANAGE FAIL.");
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
	 * 외주 거래명세서 등록 // 마스터 데이터 삭제
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOutProcTradeMasterList(HashMap<String, Object> params) throws Exception {

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

			int updateResult = dao.delete("scm.outproctrade.master.delete", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_SCM_TRADE_H fail.");
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
	 * 외주 거래명세서 등록 // 상세 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteOutProcTradeDetailList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> detail = (Map<String, Object>) list.get(i);

			{
				String orgid = StringUtil.nullConvert(detail.get("ORGID"));
				String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
				String tradeno = StringUtil.nullConvert(detail.get("TRADENO"));
				Integer tradeseq = NumberUtil.getInteger(detail.get("TRADESEQ"));
				String gubun = "D";

				detail.put("ORGID", orgid);
				detail.put("COMPANYID", companyid);
				detail.put("TRADENO", tradeno);
				detail.put("TRADESEQ", tradeseq);
				detail.put("GUBUN", gubun);
				detail.put("REGISTID", login.getId());

				detail.put("RETURNSTATUS", "");
				detail.put("MSGDATA", "");
				System.out.println("외주 거래명세서 삭제 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("scm.outproctrade.detail.manage.call.Procedure", detail);
				System.out.println("외주 거래명세서 삭제 PROCEDURE 호출 End.  >>>>>>>> " + detail);

				String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt++;
					throw new Exception("call CB_SCM_PKG.CB_SCM_TRADE_D_MANAGE FAIL.");
				}
			}
			
			int deleteResult = dao.delete("scm.outproctrade.detail.delete", detail);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_SCM_TRADE_D fail.");
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