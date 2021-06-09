package kr.co.bps.scs.prod.process;

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
 * @ClassName : ProdProcessService.java
 * @Description : ProdProcess Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 11. @modify 2017. 01.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class ProdProcessService extends BaseService {
	/**
	 * 2017.03.13 자주 검사 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectFmlList(Map<String, Object> params) throws Exception {
		System.out.println("selectFmlList Start. >>>>>>>>>> " + params);

		List<?> result = null;

		result = dao.list("prod.work.fml.list.select", params);
		return result;
	}

	/**
	 * 2017.03.13 자주 검사 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectFmlCount(HashMap<String, Object> params) throws Exception {
		System.out.println("selectFmlCount Start. >>>>>>>>>> " + params);

		int result = 0;

		result = (int) dao.select("prod.work.fml.list.count", params);
		return result;
	}

	/**
	 * 2017.03.13 자주 데이터 저장.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return Map<String, Object>
	 * @exception Exception
	 */
	public Map<String, Object> updateFmlRegist(Map<String, Object> params) throws Exception {
		System.out.println("updateFmlRegist Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		final int SIZE = list.size();
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO loginVO = getLoginVO();
		int count = 0, errcnt = 0;
		String fmltype = null, checkdt = null;
		for (int i = 0; i < list.size(); i++) {
			// (디테일) 자주 검사 저장
			Map<String, Object> detail = (Map<String, Object>) list.get(i);
			System.out.println("detail >>>>" + detail);

			detail.put("UPDATEID", loginVO.getId());

			int updateResult = dao.update("prod.work.fml.detail.update", detail);
			if (updateResult == 0) {
				errcnt += 1;
				throw new Exception("UPDATE CB_FML_CHECK_RESULT FAIL.");
			} else {
				String orgid = StringUtil.nullConvert(detail.get("ORGID"));
				String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
				String fmlid = StringUtil.nullConvert(detail.get("FMLID"));
				String personid = StringUtil.nullConvert(detail.get("PERSONID"));
				String starttime = StringUtil.nullConvert(detail.get("STARTTIME"));
				String oldlotno = StringUtil.nullConvert(detail.get("LOTNOVISUALOLD"));
				String lotno = StringUtil.nullConvert(detail.get("LOTNOVISUAL"));

				//				Integer orgid = NumberUtil.getInteger(detail.get("ORGID"));
				//				Integer companyid = NumberUtil.getInteger(detail.get("COMPANYID"));
				//				Integer fmlid = NumberUtil.getInteger(detail.get("FMLID"));

				detail.put("ORGID", orgid);
				detail.put("COMPANYID", companyid);
				detail.put("FMLID", fmlid);
				detail.put("PERSONID", personid);
				detail.put("STARTTIME", starttime);
				detail.put("LOTNOVISUALOLD", oldlotno);
				detail.put("LOTNOVISUAL", lotno);
				detail.put("REGISTID", loginVO.getId());

				detail.put("RETURNSTATUS", "");
				detail.put("MSGDATA", "");
				System.out.println("검사여부 UPDATE PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("work.order.history.master.call.Procedure", detail);
				System.out.println("검사여부 UPDATE PROCEDURE 호출 End.  >>>>>>>> " + detail);

				String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
				if (!status.equals("S")) {
					errcnt++;
					throw new Exception("call CB_MFG_PKG.CB_FML_MASTER_INSP_UPDATE FAIL.");
				}
			}
		}

		//		for (int i = 0; i < 1; i++) {
		//			// (마스터) 자주 검사여부 저장
		//			Map<String, Object> master = (Map<String, Object>) list.get(i);
		//			System.out.println("master >>>>" + master);
		//
		//			// BY PASS 여부
		//			String bpyn = StringUtil.nullConvert(master.get("BPYN"));
		//
		//			// 저장 버튼 클릭시
		//			if (!bpyn.equals("Y")) {
		//
		//				fmltype = StringUtil.nullConvert(master.get("FMLTYPE"));
		//
		//				// 자주 검사여부 확인 ( 미검사항목 개수 구하기 )
		//				Map<String, Object> checkList = (Map<String, Object>) dao.selectByIbatis("prod.work.fml.checkyn.select", master);
		//
		//				System.out.println("checkList >>>>" + checkList);
		//				int countCheck = NumberUtil.getInteger(checkList.get("COUNT"));
		//				System.out.println("countCheck >>>>" + countCheck);
		//				// 미검사 항목이 없으면 검사처리, 있으면 잔여검사가 남은 것으로...
		//				if (countCheck == 0) {
		//					master.put("INSPECTIONYN", "Y");
		//				}
		//			} else {
		//				// BP 버튼 클릭시
		//				master.put("INSPECTIONYN", "Y");
		//			}
		//
		//			System.out.println("updateFmlRegist updateMaster. >>>>>>>>>> ");
		//			int updateMaster = dao.update("prod.work.fml.master.update", master);
		//			System.out.println("updateMaster ::: " + updateMaster);
		//			if (updateMaster == 0) {
		//				errcnt += 1;
		//				throw new Exception("UPDATE CB_FML_CHECK_MASTER FAIL.");
		//			}
		//		}

		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 바코드 출력 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectBarcodeList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.barcode.select", params);
	}

	/**
	 * 공구 변경점 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectToolChangeRegistList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.tool.change.list.select", params);
	}

	/**
	 * 공구 변경점 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectToolChangeRegistCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.tool.change.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공구 변경점 등록 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolChangeRegist(Map<String, Object> params) throws Exception {
		System.out.println("insertToolChangeRegist Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			int updateResult = dao.update("prod.work.tool.change.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TOOL_CHANGE_RESULT fail.");
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
	 * 공구 변경점 등록 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolChangeRegist(Map<String, Object> params) throws Exception {
		System.out.println("updateToolChangeRegist Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			int updateResult = dao.update("prod.work.tool.change.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TOOL_CHANGE_RESULT fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWarehousingRegistList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.warehousing.list.select", params);
	}

	/**
	 * 공정관리 > 입고등록 ( 현장용 ) 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWarehousingRegistCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.warehousing.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공정관리 > 공정실적 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkResultNewList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.process.new.list.select", params);
	}

	/**
	 * 공정관리 > 공정실적 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkResultNewCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.process.new.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공정관리 > 자주검사 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkCheckNewList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.check.new.list.select", params);
	}

	/**
	 * 공정관리 > 자주검사 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkCheckNewCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.check.new.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 작업지시 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderList(Map<String, Object> params) throws Exception {

		return dao.list("prod.workorder.process.list.select", params);
	}

	/**
	 * 작업지시 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.workorder.process.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/** 2018-06-11
	 *  생산실적 및 불량유형 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderResultHeader(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.orderresult.header.select", params);
	}

	/**2018-06-11
	 *   생산실적 및 불량유형 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderResultHeaderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.orderresult.header.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
		
	/**
	 * 생산실적 데이터 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkFaultListH(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("prod.work.result.list.delete", list) > 0;
		if(isSuccess){
			LoginVO login = getLoginVO();
			Map<String, Object> master = (Map<String, Object>) list.get(0);
			
			System.out.println("데이터삭제  master >>>>>>>> " + master);
			String orgid = String.valueOf(master.get("ORGID"));
			String companyid = String.valueOf(master.get("COMPANYID"));
			String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
			Integer workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ")); //.nullConvert(master.get("WORKORDERSEQ"));
			Integer seqno = NumberUtil.getInteger(master.get("SEQNO"));
			String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
			String workcenter = StringUtil.nullConvert(master.get("WORKCENTERCODE"));
			Integer qty = NumberUtil.getInteger(master.get("HAPQTY"));
			//String worktime = StringUtil.nullConvert(master.get("WORKTIMEHOUR"));
			Integer worktime = NumberUtil.getInteger(master.get("WORKTIMEHOUR"));
			String worker = StringUtil.nullConvert(master.get("WORKER"));
			String lotno = StringUtil.nullConvert(master.get("LOTNO"));
			String ampm = StringUtil.nullConvert(master.get("WORKDIV"));
			Integer weight = NumberUtil.getInteger(master.get("WEIGHT"));
			Integer ifqty = NumberUtil.getInteger(master.get("IFQTY"));
			String variablecol4 = StringUtil.nullConvert(master.get("VARIABLECOL4"));

			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", workorderseq);
			master.put("SEQNO", seqno);
			master.put("ITEMCODE", itemcode);
			master.put("WORKCENTERCODE", workcenter);
			master.put("QTY", qty);
			master.put("WORKTIMEHOUR", worktime);
			master.put("WORKER", worker);
			master.put("LOTNO", lotno);
			master.put("AMPM", ampm);
			master.put("WEIGHT", weight);
			master.put("IFQTY", ifqty);
			master.put("LOGIN", login.getId());
			master.put("RSCODE", "");
			master.put("RSSTATUS", "");

			String starttime = StringUtil.nullConvert(master.get("STARTTIME"));
			String endtime = StringUtil.nullConvert(master.get("ENDTIME"));

			String[] sList1 = starttime.split("T");
			String[] sList2 = endtime.split("T");

			master.put("STARTTIME", sList1[0]);
			master.put("ENDTIME", sList2[0]);

			System.out.println("작업실적관리 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("routing.workorder.detaildelete.call.Procedure", master);
			System.out.println("작업실적관리 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String rstatus = StringUtil.nullConvert(master.get("RSSTATUS"));
			System.out.println("status.  >>>>>>>> " + rstatus);
			if (!rstatus.equals("S")) {
				//throw new Exception("call CB_ROUTING_COPY.CB_ROUTING_CONTROL_COPY FAIL.");
				throw new Exception("call CB_MFG_PKG.CB_WORK_CONFIRM_QTY FAIL.");
			}
		}
		
		return super.getExtGridResultMap(isSuccess, "delete");
	}
	
	/**
	 * 2018-06-11 공정 불량 등록 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderResultDetailList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.orderresult.detail.select", params);
	}

	/**
	 * 2018-06-11 공정 불량 등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderResultDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.orderresult.detail.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 생산실적 공정검사 불량유형 // 데이터 등록 / 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkOrderResultDetail(Map<String, Object> params) throws Exception {

		System.out.println("insertWorkOrderResultDetail Start. >>>>>>>>>> params " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		System.out.println("insertWorkOrderResultDetail Start. >>>>>>>>>> list " + list);
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			List faultList = dao.selectListByIbatis("prod.work.result.detail.find.select", master);
			Map<String, Object> current = (Map<String, Object>) faultList.get(0);
			int faultCheck = NumberUtil.getInteger(current.get("COUNT"));

			System.out.println("1. insertWorkOrderResultDetail faultCheck >>>>>>>>>> " + faultCheck);

			if (faultCheck == 0) {
				// 생성
				System.out.println("2-1. insertWorkOrderResultDetail insert. >>>>>>>>>> ");

				master.put("REGISTID", login.getId());
				int updateResult = dao.update("prod.work.result.detail.insert", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_WORK_ORDER_FAULT fail.");
				}
			} else {
				// 변경
				System.out.println("2-2. insertWorkOrderResultDetail update. >>>>>>>>>> ");

				master.put("UPDATEID", login.getId());
				int updateResult = dao.update("prod.work.result.detail.update", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("UPDATE CB_WORK_ORDER_FAULT fail.");
				}
			}

			String orgid = String.valueOf(master.get("ORGID"));
			String companyid = String.valueOf(master.get("COMPANYID"));
			String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
			Integer workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
			Integer seqno = NumberUtil.getInteger(master.get("SEQNO"));

			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", workorderseq);
			master.put("SEQNO", seqno);
			master.put("LOGIN", login.getId());
			master.put("RSCODE", "");
			master.put("RSSTATUS", "");
			dao.list("routing.workorder.faultinsert.call.Procedure", master);
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}
	
	/**
	 * 생산실적 HISTORY // 데이터 등록 / 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkFaultListH(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkFaultListH Start. >>>>>>>>>> params " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		System.out.println("updateWorkFaultListH Start. >>>>>>>>>> list " + list);
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			List faultList = dao.selectListByIbatis("prod.work.fault.list.find.select", master);
			Map<String, Object> current = (Map<String, Object>) faultList.get(0);
			int faultCheck = NumberUtil.getInteger(current.get("COUNT"));

			System.out.println("1. updateWorkFaultListH faultCheck >>>>>>>>>> " + faultCheck);

			if (faultCheck == 0) {
				// 생성
				//				System.out.println("2-1. updateWorkFaultListH insert. >>>>>>>>>> " );
				//
				//				master.put("REGISTID", login.getId());
				//				int updateResult = dao.update("prod.work.result.list.insert", master);
				//				if (updateResult == 0) {
				//					// 저장 실패시 띄우는 예외처리
				//					errcnt += 1;
				//					throw new Exception("insert into CB_WORK_ORDER_D fail.");
				//				}
				// 생성
				//System.out.println("2-1. updateWorkFaultListH insert. >>>>>>>>>> " );

				//master.put("REGISTID", login.getId());
				//int updateResult = dao.update("prod.work.result.list.insert", master);
				//if (updateResult == 0) {
				//	// 저장 실패시 띄우는 예외처리
				//	errcnt += 1;
				//	throw new Exception("insert into CB_WORK_ORDER_D fail.");
				//}

				String orgid = String.valueOf(master.get("ORGID"));
				String companyid = String.valueOf(master.get("COMPANYID"));
				String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
				Integer workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ")); //.nullConvert(master.get("WORKORDERSEQ"));
				String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
				String workcenter = StringUtil.nullConvert(master.get("WORKCENTERCODE"));
				Integer qty = NumberUtil.getInteger(master.get("QTY"));
				//String worktime = StringUtil.nullConvert(master.get("WORKTIMEHOUR"));
				Integer worktime = NumberUtil.getInteger(master.get("WORKTIMEHOUR"));
				String worker = StringUtil.nullConvert(master.get("WORKER"));
				String lotno = StringUtil.nullConvert(master.get("LOTNO"));
				String ampm = StringUtil.nullConvert(master.get("WORKDIV"));
				Integer weight = NumberUtil.getInteger(master.get("WEIGHT"));
				Integer IFQTY = NumberUtil.getInteger(master.get("IFQTY"));
				String variablecol4 = StringUtil.nullConvert(master.get("VARIABLECOL4"));

				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("WORKORDERID", workorderid);
				master.put("WORKORDERSEQ", workorderseq);
				master.put("ITEMCODE", itemcode);
				master.put("WORKCENTERCODE", workcenter);
				master.put("QTY", qty);
				master.put("WORKTIMEHOUR", worktime);
				master.put("WORKER", worker);
				master.put("LOTNO", lotno);
				master.put("AMPM", ampm);
				master.put("WEIGHT", weight);
				master.put("IFQTY", weight);
				master.put("LOGIN", login.getId());
				master.put("SEQNO", "");
				master.put("RSCODE", "");
				master.put("RSSTATUS", "");

				String starttime = StringUtil.nullConvert(master.get("STARTTIME"));
				String endtime = StringUtil.nullConvert(master.get("ENDTIME"));

				String[] sList1 = starttime.split("T");
				String[] sList2 = endtime.split("T");

				master.put("STARTTIME", sList1[0]);
				master.put("ENDTIME", sList2[0]);

				System.out.println("작업실적관리 PROCEDURE 호출 Start. >>>>>>>> " + master);
				//dao.list("routing.routingcopy.call.Procedure", params);
				//dao.list("routing.bomcopymodel.call.Procedure", params);
				dao.list("routing.workorder.detailinsert.call.Procedure", master);
				System.out.println("작업실적관리 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String rstatus = StringUtil.nullConvert(master.get("RSSTATUS"));
				System.out.println("status.  >>>>>>>> " + rstatus);
				if (!rstatus.equals("S")) {
					errcnt++;
					//throw new Exception("call CB_ROUTING_COPY.CB_ROUTING_CONTROL_COPY FAIL.");
					throw new Exception("call CB_MFG_PKG.CB_WORK_CONFIRM_QTY FAIL.");
				} else {
					Integer Orgid = NumberUtil.getInteger(master.get("ORGID"));
					Integer Companyid = NumberUtil.getInteger(master.get("COMPANYID"));
					String Workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
					Integer Workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
					String Workerid = StringUtil.nullConvert(master.get("WORKER"));
					int Seqno = NumberUtil.getInteger(master.get("SEQNO"));

					master.put("ORGID", Orgid);
					master.put("COMPANYID", Companyid);
					master.put("WORKORDERID", Workorderid);
					master.put("WORKORDERSEQ", Workorderseq);
					master.put("WORKERID", Workerid);
					master.put("SEQ", Seqno);
					master.put("REGISTID", login.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("자주검사 / 공정순회검사 생성 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("prod.workorder.check.create.call.Procedure", master);
					System.out.println("자주검사 / 공정순회검사 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

					String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt += 1;
						throw new Exception("call CB_MFG_PKG.CB_WORK_CHECK_CREATE fail.");
					}
					
					// 철수시간이 입력되면 완료처리
					if (!endtime.isEmpty()) {
						master.put("ORGID", Orgid);
						master.put("COMPANYID", Companyid);
						master.put("WORKORDERID", Workorderid);
						master.put("WORKORDERSEQ", Workorderseq);
						master.put("WORKERID", Workerid);
						master.put("SEQ", Seqno);
						master.put("REGISTID", login.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");

						master.put("REGISTID", login.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("자주검사 / 공정순회검사 완료 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prod.workorder.check.complete.call.Procedure", master);
						System.out.println("자주검사 / 공정순회검사 완료 PROCEDURE 호출 End.  >>>>>>>> " + master);

						String status2 = StringUtil.nullConvert(master.get("RETURNSTATUS"));
						if (!status2.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_MFG_PKG.CB_WORK_CHECK_COMPLETE_U fail.");
						}

						// 소재출고
						{
							master.put("ORGID", Orgid);
							master.put("COMPANYID", Companyid);
							master.put("WORKORDERID", Workorderid);
							master.put("WORKORDERSEQ", Workorderseq);
							master.put("SEQ", Seqno);
							master.put("REGISTID", login.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");

							master.put("REGISTID", login.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");
							System.out.println("소재출고 PROCEDURE 호출 Start. >>>>>>>> ");
							dao.list("prod.workorder.bom.qty.call.Procedure", master);
							System.out.println("소재출고 PROCEDURE 호출 End.  >>>>>>>> " + master);

							String status3 = StringUtil.nullConvert(master.get("RETURNSTATUS"));
							if (!status2.equals("S")) {
								errcnt += 1;
								throw new Exception("call CB_MFG_PKG.CB_WORK_BOM_QTY_CREATE fail.");
							}
						}
						
					}
				}
			} else {
				// 변경
				System.out.println("2-2. updateWorkFaultListH update. >>>>>>>>>> ");

				String orgid = String.valueOf(master.get("ORGID"));
				String companyid = String.valueOf(master.get("COMPANYID"));
				String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
				Integer workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ")); //.nullConvert(master.get("WORKORDERSEQ"));
				Integer seqno = NumberUtil.getInteger(master.get("SEQNO"));
				String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
				String workcenter = StringUtil.nullConvert(master.get("WORKCENTERCODE"));
				Integer qty = NumberUtil.getInteger(master.get("QTY"));
				//String worktime = StringUtil.nullConvert(master.get("WORKTIMEHOUR"));
				Integer worktime = NumberUtil.getInteger(master.get("WORKTIMEHOUR"));
				String worker = StringUtil.nullConvert(master.get("WORKER"));
				String lotno = StringUtil.nullConvert(master.get("LOTNO"));
				String ampm = StringUtil.nullConvert(master.get("WORKDIV"));
				Integer weight = NumberUtil.getInteger(master.get("WEIGHT"));
				Integer ifqty = NumberUtil.getInteger(master.get("IFQTY"));
				String variablecol4 = StringUtil.nullConvert(master.get("VARIABLECOL4"));

				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("WORKORDERID", workorderid);
				master.put("WORKORDERSEQ", workorderseq);
				master.put("SEQNO", seqno);
				master.put("ITEMCODE", itemcode);
				master.put("WORKCENTERCODE", workcenter);
				master.put("QTY", qty);
				master.put("WORKTIMEHOUR", worktime);
				master.put("WORKER", worker);
				master.put("LOTNO", lotno);
				master.put("AMPM", ampm);
				master.put("WEIGHT", weight);
				master.put("IFQTY", ifqty);
				master.put("LOGIN", login.getId());
				master.put("RSCODE", "");
				master.put("RSSTATUS", "");

				String starttime = StringUtil.nullConvert(master.get("STARTTIME"));
				String endtime = StringUtil.nullConvert(master.get("ENDTIME"));

				String[] sList1 = starttime.split("T");
				String[] sList2 = endtime.split("T");

				master.put("STARTTIME", sList1[0]);
				master.put("ENDTIME", sList2[0]);

				System.out.println("작업실적관리 PROCEDURE 호출 Start. >>>>>>>> " + master);
				//dao.list("routing.routingcopy.call.Procedure", params);
				//dao.list("routing.bomcopymodel.call.Procedure", params);
				dao.list("routing.workorder.detailupdate.call.Procedure", master);
				System.out.println("작업실적관리 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String rstatus = StringUtil.nullConvert(master.get("RSSTATUS"));
				System.out.println("status.  >>>>>>>> " + rstatus);
				if (!rstatus.equals("S")) {
					errcnt++;
					//throw new Exception("call CB_ROUTING_COPY.CB_ROUTING_CONTROL_COPY FAIL.");
					throw new Exception("call CB_MFG_PKG.CB_WORK_CONFIRM_QTY FAIL.");
				} else {
					// 철수시간이 입력되면 완료처리
					if (!endtime.isEmpty()) {
						Integer Orgid = NumberUtil.getInteger(master.get("ORGID"));
						Integer Companyid = NumberUtil.getInteger(master.get("COMPANYID"));
						String Workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
						Integer Workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
						String Workerid = StringUtil.nullConvert(master.get("WORKER"));
						int Seqno = NumberUtil.getInteger(master.get("SEQNO"));
						
						master.put("ORGID", Orgid);
						master.put("COMPANYID", Companyid);
						master.put("WORKORDERID", Workorderid);
						master.put("WORKORDERSEQ", Workorderseq);
						master.put("WORKERID", Workerid);
						master.put("SEQ", Seqno);
						master.put("REGISTID", login.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");

						master.put("REGISTID", login.getId());
						master.put("RETURNSTATUS", "");
						master.put("MSGDATA", "");
						System.out.println("자주검사 / 공정순회검사 완료 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prod.workorder.check.complete.call.Procedure", master);
						System.out.println("자주검사 / 공정순회검사 완료 PROCEDURE 호출 End.  >>>>>>>> " + master);

						String status2 = StringUtil.nullConvert(master.get("RETURNSTATUS"));
						if (!status2.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_MFG_PKG.CB_WORK_CHECK_COMPLETE_U fail.");
						}
						
						// 소재출고
						{
							master.put("ORGID", Orgid);
							master.put("COMPANYID", Companyid);
							master.put("WORKORDERID", Workorderid);
							master.put("WORKORDERSEQ", Workorderseq);
							master.put("SEQ", Seqno);
							master.put("REGISTID", login.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");

							master.put("REGISTID", login.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");
							System.out.println("소재출고 PROCEDURE 호출 Start. >>>>>>>> ");
							dao.list("prod.workorder.bom.qty.call.Procedure", master);
							System.out.println("소재출고 PROCEDURE 호출 End.  >>>>>>>> " + master);

							String status3 = StringUtil.nullConvert(master.get("RETURNSTATUS"));
							if (!status2.equals("S")) {
								errcnt += 1;
								throw new Exception("call CB_MFG_PKG.CB_WORK_BOM_QTY_CREATE fail.");
							}
						}
						
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
		return super.getExtGridResultMap(isSuccess, "update");
	}
	
	/**
	 *비가동유형등록 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderOperateList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.order.operate.select", params);
	}

	/**
	 * 비가동유형등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderOperateListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.order.operate.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 비가동유형등록 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkOrderOperateList(Map<String, Object> params) throws Exception {
		System.out.println("insertWorkOrderOperateList Start. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("prod.work.operate.popup.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_WORK_ORDER_OPERATE fail.");
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
	 * 비가동유형등록 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkOrderOperateList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateWorkOrderOperateList >>>>>>>>>> " + list);
		boolean isSuccess = dao.updateListByIbatis("prod.work.operate.popup.list.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 비가동유형등록 // 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkOrderOperateList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);


		System.out.println("deleteWorkOrderOperateList >>>>>>>>>> " + list);
		boolean isSuccess = dao.deleteListByIbatis("prod.work.operate.popup.list.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
	
	/**
	 * 설비그룹 변경
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return WorkCenterMaService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkgroupChangeGrid(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkgroupChangeGrid SERVICE Start. >>>>>>>>>> ");
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
			System.out.println("updateWorkgroupChangeGrid 1. >>>>>>>>>> " + master);

			master.put("UPDATEID", login.getId());
//			String orgid = StringUtil.nullConvert(params.get("ORGID"));
//			String companyid = StringUtil.nullConvert(params.get("COMPANYID"));
//			String chk = StringUtil.nullConvert(params.get("CHK"));
			
			int updateResult = dao.update("prod.work.center.group.change.update", master);
			if (updateResult == 0) {
				errcnt++;
				throw new Exception("UPDATE CB_WORK_CENTER fail.");
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
	 * 공정관리 외주발주 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOutOrderList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.outorder.select", params);
	}

	/**
	 * 공정관리 외주발주 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOutOrderCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.outorder.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 공정관리 > 외주발주
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return WorkCenterMaService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkOutOrderRegist(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkOutOrderRegist SERVICE Start. >>>>>>>>>> "+params);
		List<?> list = (List<?>) params.get("data");
		final int SIZE = list.size();

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> detail = (Map<String, Object>) list.get(i);
			System.out.println("updateWorkOutOrderRegist 1. >>>>>>>>>> " +detail);
			
			String orgid = StringUtil.nullConvert(detail.get("ORGID"));
			String companyid = StringUtil.nullConvert(detail.get("COMPANYID"));
			String itemcode = StringUtil.nullConvert(detail.get("ITEMCODE"));
			String routingcode = StringUtil.nullConvert(detail.get("ROUTINGCODE"));
			String workorderid = StringUtil.nullConvert(detail.get("WORKORDERID"));
			String customercode = StringUtil.nullConvert(detail.get("CUSTOMERCODE"));
			BigDecimal orderqty = NumberUtil.getBigDecimal(detail.get("REMAINQTY"));
			BigDecimal modqty = NumberUtil.getBigDecimal(detail.get("MODQTY"));
			String outpodate = StringUtil.nullConvert(detail.get("OUTPODATE"));
			String flag = StringUtil.nullConvert(detail.get("FLAG"));
			
			detail.put("ORGID", orgid);
			detail.put("COMPANYID", companyid);
			detail.put("ITEMCODE", itemcode);
			detail.put("ROUTINGCODE", routingcode);
			detail.put("WORKORDERID", workorderid);
			detail.put("CUSTOMERCODE", customercode);
			detail.put("ORDERQTY", orderqty);
			detail.put("MODQTY", modqty);
			detail.put("OUTPODATE", outpodate);
			detail.put("FLAG", flag);
			
			detail.put("REGISTID", login.getId());
			detail.put("RETURNSTATUS", "");
			detail.put("MSGDATA", "");
			detail.put("OUTPONO", "");
			System.out.println("외주발주 생성 처리 PROCEDURE 호출 Start. >>>>>>>> " + detail);
			dao.list("prod.work.outorder.create.call.Procedure", detail);
			System.out.println("외주발주 생성 처리 PROCEDURE 호출 End.  >>>>>>>> " + detail);

			String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
//				throw new Exception("call CB_OUTSIDE_ORDER_PKG.CB_WORK_OUT_ORDER_CREATE fail.");
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
	 * 반입반출 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderInOutList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.order.out.list.select", params);
	}

	/**
	 * 반입반출 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderInOutCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.order.out.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 도장공정 투입작지 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkOrderInOut(Map<String, Object> params) throws Exception {
		System.out.println("insertWorkOrderInOut Start. >>>>>>>>>> " + params);
		
		List<?> list = (List<?>) params.get("data");
		final int SIZE = list.size();

		String itemcode = "";
		String workoutid = "";
		String workinid = "";
		LoginVO login = getLoginVO();
		int errcnt = 0;
		
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			System.out.println("insertWorkOrderPaintList 1-1. >>>>>>>>>> " + master);
			//품목코드가 있음  => 반출
			if(StringUtil.nullConvert(master.get("ITEMCODE")).isEmpty())
			{
				List itemcodeList = dao.selectListByIbatis("prod.work.order.out.itemcode.select", master);
				Map<String, Object> itemcodeMap = (Map<String, Object>) itemcodeList.get(0);
				itemcode = StringUtil.nullConvert(itemcodeMap.get("ITEMCODE"));
				if (itemcode.isEmpty())
				{
					errcnt += 1;
					return super.getExtGridResultMap(false, "insert");
				}
				master.put("ITEMCODE", itemcode);
		
				String[] outdateList = (StringUtil.nullConvert(master.get("OUTDATE"))).split("T");
				System.out.println("insertWorkOrderPaintList 4. >>>>>>>>>> " + outdateList);
				master.put("OUTDATE", outdateList[0]);
				
				
				List workoutidList = dao.selectListByIbatis("prod.work.order.out.new.select", master);
				Map<String, Object> workoutidMap = (Map<String, Object>) workoutidList.get(0);
				workoutid = (String) workoutidMap.get("WORKOUTID");
				master.put("WORKOUTID", workoutid);
				
				master.put("REGISTID", login.getId());

				System.out.println("insertWorkOrderPaintList master >>>>>>>>>> " + master);
				int updateResult1 = dao.update("prod.work.order.out.insert", master);
				if (updateResult1 == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_WORK_ORDER_OUT fail.");
				}
			}
			//품목코드가 없음  => 반입
			else{
				
				List workinidList = dao.selectListByIbatis("prod.work.order.in.new.select", master);
				Map<String, Object> workinidMap = (Map<String, Object>) workinidList.get(0);
				workinid = (String) workinidMap.get("WORKINID");
				master.put("WORKINID", workinid);
				
				String[] indateList = (StringUtil.nullConvert(master.get("INDATE"))).split("T");
				System.out.println("insertWorkOrderPaintList 4. >>>>>>>>>> " + indateList);
				master.put("INDATE", indateList[0]);
				master.put("REGISTID", login.getId());

				int updateResult1 = dao.update("prod.work.order.in.insert", master);
				if (updateResult1 == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_WORK_ORDER_IN fail.");
				}
				
			}

		}

		System.out.println("insertWorkOrderPaintList 5. >>>>>>>>>> " +errcnt);
		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		System.out.println("insertWorkOrderPaintList isSuccess >>>>>>>>>> " +isSuccess);
		return super.getExtGridResultMap(isSuccess, "insert");
	}
	
	/**
	 * 생산실적 HISTORY // 데이터 등록 / 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkOrderInOut(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkFaultListH Start. >>>>>>>>>> params " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		System.out.println("updateWorkFaultListH Start. >>>>>>>>>> list " + list);
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			master.put("UPDATEID", login.getId());
			
			int updateResult1 = dao.update("prod.work.order.out.update", master);
			if (updateResult1 == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_WORK_ORDER_OUT fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}
	

	/**
	 * 공정관리 > 생산실적등록 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderBtnList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.order.button.list.select", params);
	}

	/**
	 * 공정관리 > 생산실적등록 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderBtnCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.order.button.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 생산실적등록 // 실적 등록, 완료
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkOrderBtnList(HashMap<String, Object> params) throws Exception {

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
			String orgid = StringUtil.nullConvert(master.get("ORGID"));
			String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
			Integer workorderseq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
			String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
			String workcentercode = StringUtil.nullConvert(master.get("WORKCENTERCODE"));
			String workdiv = StringUtil.nullConvert(master.get("WORKDIV"));
			String worker = StringUtil.nullConvert(master.get("WORKER"));
			Integer inputqty = NumberUtil.getInteger(master.get("INPUTQTY"));
			String workflag = StringUtil.nullConvert(master.get("WORKFLAG"));
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", workorderseq);
			master.put("ITEMCODE", itemcode);
			master.put("WORKCENTERCODE", workcentercode);
			master.put("WORKDIV", workdiv);
			master.put("WORKER", worker);
			master.put("QTY", inputqty);
			master.put("GUBUN", workflag);
			
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업실적 갱신 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("prod.work.detail.manage.call.Procedure", master);
			System.out.println("작업실적 갱신 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_WORK_D_MANAGE fail.");
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