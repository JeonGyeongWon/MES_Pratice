package kr.co.bps.scs.prod.work;

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
 * @ClassName : WorkProdService.java
 * @Description : WorkProd Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jmpark, ymha
 * @since 2016. 11.
 * @modify 2016. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class WorkProdService extends BaseService {

	/**
	 * 조회 부분에 작업지시투입현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkProdList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.list.select", params);
	}

	/**
	 * 조회 부분에 작업지시투입현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkProdCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016.12.01 작업지시투입관리 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkProdStart(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		LoginVO login = getLoginVO();
		System.out.println("insert params >>>>>>>>>> " + params);

		int errcnt = 0;
		String workorderid = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("WORKDIV", "W");

			List woList = dao.selectListByIbatis("prod.work.new.workorderid.select", master);
			Map<String, Object> woMap = (Map<String, Object>) woList.get(0);
			workorderid = (String) woMap.get("WORKORDERID");
			master.put("WORKORDERID", workorderid);

			master.put("REGISTID", login.getId());

			System.out.println("insert master >>>>>>>>>> " + master);

			int updateResult = dao.update("prod.work.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_WORK_ORDER_HEADER fail.");
			} else {
				// 프로시저 호출
				//				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("작업지시별 공정 처리 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("workRoutingCreate.call.Procedure", master);
				System.out.println("작업지시별 공정 처리 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("insertWorkProdStart status >>>>>>>> " + status);
				if (!status.equals("S")) {
					// 공정별 작업지시 생성시 초중종 데이터 생성
//					master.put("RETURNSTATUS", "");
//					master.put("MSGDATA", "");
//					System.out.println("자주검사 외 데이터 생성 PROCEDURE 호출 Start. >>>>>>>> ");
//					dao.list("prod.wo.fml.create.call.Procedure", master);
//					System.out.println("자주검사 외 데이터 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);
//
//					String fml_status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
//					System.out.println("insertWorkProdStart fml_status >>>>>>>> " + fml_status);
//					if (!status.equals("S")) {
//						// 초중종 데이터 생성 실패시
//						errcnt += 1;
//						throw new Exception("insert into CB_FML_CHECK_MASTER / CB_FML_CHECK_RESULT fail.");
//					}
//				} else {
					// 작업지시 생성 실패시
					errcnt += 1;
					throw new Exception("insert into CB_WORK_ORDER fail.");
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
		return super.getExtGridResultMap(isSuccess, "insert");
	}

	/**
	 * 2016.12.01 작업지시투입관리 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkProdStart(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
			System.out.println("update work orde HEADERr >>>>>>>>>> " + master);

			int updateResult = dao.update("prod.work.update", master);
			if (updateResult == 0) {
				errcnt++;
				throw new Exception("update CB_WORK_ORDER_HEADER fail.");
			}

			// 프로시저 호출
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workRoutingUpdate.call.Procedure", master);
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_ROUTING_UPDATE fail.");
			}
		}
		//		boolean isSuccess = dao.updateListByIbatis("prod.work.update", list) > 0;

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 2016.12.01 작업지시투입관리 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkProdStart(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			// 프로시저 호출
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workRoutingDelete.call.Procedure", master);
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_ROUTING_DELETE fail.");
			} else {
				System.out.println("deleteWorkProdStart Delete >>>>>>>>>> " + master);
				int updateResult = dao.update("prod.work.delete", master);
				if (updateResult == 0) {
					errcnt++;
					throw new Exception("delete CB_WORK_ORDER_HEADER fail.");
				}
			}
		}

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 작업지시투입관리 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatetWorkProdStartMonth(Map<String, Object> params) throws Exception {

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
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workRoutingMonth.call.Procedure", master);
			System.out.println("작업지시별 공정 처리 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_ROUTING_UPDATE fail.");
			}
		}
		//		boolean isSuccess = dao.updateListByIbatis("prod.work.update", list) > 0;

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		return super.getExtGridResultMap(isSuccess, "update");
	}
	
	/**
	 * 2017.01.04 조회 부분에 작업지시투입현황 DETAIL 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkProdDList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.listD.select", params);
	}

	/**
	 * 2017.01.04 조회 부분에 작업지시투입현황 DETAIL 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkProdDCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.listD.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.01.04 작업지시투입관리 DETAIL 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkProdStartD(Map<String, Object> params) throws Exception {
		System.out.println("insertWorkProdStartD Service Start. >>>>>>>>>> " + params);
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

			detail.put("REGISTID", login.getId());

			int updateResult = dao.update("prod.workD.insert", detail);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_WORK_ORDER fail.");
			} else {
				String firstorder = StringUtil.nullConvert(detail.get("FIRSTORDER"));
				System.out.println("firstorder >>>>>>>> " + firstorder);
				if ( !firstorder.isEmpty() ) {
					// 우선순위여부가 있을경우
					String orgid = String.valueOf(detail.get("ORGID"));
					String companyid = String.valueOf(detail.get("COMPANYID"));
					String workorderid = StringUtil.nullConvert(detail.get("WORKORDERID"));
					Integer workorderseq = NumberUtil.getInteger(detail.get("WORKORDERSEQ"));

					detail.put("ORGID", orgid);
					detail.put("COMPANYID", companyid);
					detail.put("WORKORDERID", workorderid);
					detail.put("WORKORDERSEQ", workorderseq);
					
					detail.put("REGISTID", login.getId());
					detail.put("RETURNSTATUS", "");
					detail.put("MSGDATA", "");
					System.out.println("작업지시등록 > 설비별 우선순위 변경 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("prod.wo.first.order.update.call.Procedure", detail);
					System.out.println("작업지시등록 > 설비별 우선순위 변경 PROCEDURE 호출 End.  >>>>>>>> " + detail);
	
					String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt += 1;
						throw new Exception("call CB_MFG_PKG.CB_WORK_FIRST_ORDER_U fail.");
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
		return super.getExtGridResultMap(isSuccess, "insert");
	}

	/**
	 * 2017.01.04 작업지시투입관리 DETAIL 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkProdStartD(Map<String, Object> params) throws Exception {
		System.out.println("updateWorkProdStartD Service Start. >>>>>>>>>> " + params);

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> detail = (Map<String, Object>) list.get(i);

			detail.put("UPDATEID", login.getId());

			int updateResult = dao.update("prod.workD.update", detail);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_WORK_ORDER fail.");
			}  else {
				String firstorder = StringUtil.nullConvert(detail.get("FIRSTORDER"));
				if ( !firstorder.isEmpty() ) {
					// 우선순위여부가 있을경우
					String orgid = String.valueOf(detail.get("ORGID"));
					String companyid = String.valueOf(detail.get("COMPANYID"));
					String workorderid = StringUtil.nullConvert(detail.get("WORKORDERID"));
					Integer workorderseq = NumberUtil.getInteger(detail.get("WORKORDERSEQ"));

					detail.put("ORGID", orgid);
					detail.put("COMPANYID", companyid);
					detail.put("WORKORDERID", workorderid);
					detail.put("WORKORDERSEQ", workorderseq);
					
					detail.put("REGISTID", login.getId());
					detail.put("RETURNSTATUS", "");
					detail.put("MSGDATA", "");
					System.out.println("작업지시변경 > 설비별 우선순위 변경 PROCEDURE 호출 Start. >>>>>>>> ");
					dao.list("prod.wo.first.order.update.call.Procedure", detail);
					System.out.println("작업지시변경 > 설비별 우선순위 변경 PROCEDURE 호출 End.  >>>>>>>> " + detail);
	
					String status = StringUtil.nullConvert(detail.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt += 1;
						throw new Exception("call CB_MFG_PKG.CB_WORK_FIRST_ORDER_U fail.");
					}
				}
			}
		}
		
//		boolean isSuccess = dao.updateListByIbatis("prod.workD.update", list) > 0;
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
	 * 2017.01.04 작업지시투입관리 DETAIL 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkProdStartD(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("prod.workD.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 작업지시투입관리 // 상태 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkProdStatus(HashMap<String, Object> params) throws Exception {

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
			String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", "");
			master.put("GUBUN", workstatus);
			
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업지시 상태 변경 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workStatusUpdate.call.Procedure", master);
			System.out.println("작업지시 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_WORK_STATUS_U fail.");
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
	 * 작업지시투입관리 상세 // 상태 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkProdDetailStatus(HashMap<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}
		
		String lump = "N";
		String lastchk = "N";
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			// 프로시저 호출

			String orgid = StringUtil.nullConvert(master.get("ORGID"));
			String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
			String workorderseq = StringUtil.nullConvert(master.get("WORKORDERSEQ"));
			String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", workorderseq);
			master.put("GUBUN", workstatus);
			
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업지시 상태 변경 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workStatusUpdate.call.Procedure", master);
			System.out.println("작업지시 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_WORK_STATUS_U fail.");
			}else{
				// 일괄인지 각각인지 체크하는 파라미터
				lump = StringUtil.nullConvert(master.get("LUMP"));
				lastchk = StringUtil.nullConvert(master.get("LASTCHK"));				
				
				//일괄일 경우 패키지에 넣지않고 temp 테이블에만 담는다.(마지막 for문일 때 일괄적으로 패키지에서 생성시킴)
				System.out.println("lump.  >>>>>>>> " + lump);
				System.out.println("lastchk 1.  >>>>>>>> " + lastchk);
				if(lump.equals("Y")){
					
					System.out.println("workstatus.  >>>>>>>> " + workstatus);
					if(workstatus.equals("PROGRESS")){
						String outsideordergubun = StringUtil.nullConvert(master.get("OUTSIDEORDERGUBUN"));
						String chk = StringUtil.nullConvert(master.get("CHK"));
						System.out.println("outsideordergubun.  >>>>>>>> " + outsideordergubun);
						System.out.println("chk.  >>>>>>>> " + chk);
						
						// 외주구분이고 체크가 되어있는 것만
						if(outsideordergubun.equals("Y") && chk.equals("true")){
							int updateResult = dao.update("prod.work.outorder.temp.insert", master);
							if (updateResult == 0) {
								// 저장 실패시 띄우는 예외처리
								errcnt += 1;
								throw new Exception("insert into CB_WORK_OUT_TEMP fail.");
							}						
						}
					}					
			    // 일괄이 아닐 경우
				}else{
					System.out.println("workstatus.  >>>>>>>> " + workstatus);
					if(workstatus.equals("PROGRESS")){
						String outsideordergubun = StringUtil.nullConvert(master.get("OUTSIDEORDERGUBUN"));
						
						if(outsideordergubun.equals("Y")){
							Integer org = NumberUtil.getInteger(master.get("ORGID"));
							Integer company = NumberUtil.getInteger(master.get("COMPANYID"));
							String id = StringUtil.nullConvert(master.get("WORKORDERID"));
							Integer seq = NumberUtil.getInteger(master.get("WORKORDERSEQ"));
							Integer orderqty = NumberUtil.getInteger(master.get("DAILYQTY"));
							String customercodeout = StringUtil.nullConvert(master.get("CUSTOMERCODEOUT"));
							
							master.put("ORGID", org);
							master.put("COMPANYID", company);
							master.put("WORKORDERID", id);
							master.put("WORKORDERSEQ", seq);
							master.put("ORDERQTY", orderqty);
							master.put("CUSTOMERCODE", customercodeout);					
							master.put("REGISTID", login.getId());
							master.put("RETURNSTATUS", "");
							master.put("MSGDATA", "");
							
							System.out.println("공정실적 > 외주발주 생성 PROCEDURE 호출 Start. >>>>>>>> " + master);
							dao.list("prod.workorder.out.order.create1.call.Procedure", master);
							System.out.println("공정실적 > 외주발주 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);
						}
					}
				}
			}			
		}
		
		// jsp단에서 마지막 for문일 때
		System.out.println("lastchk 2.  >>>>>>>> " + lastchk);
		if(lastchk.equals("Y")){
			params.put("REGISTID", login.getId());
			params.put("RETURNSTATUS", "");
			params.put("MSGDATA", "");
			System.out.println("공정실적 > 일괄 외주발주 생성 PROCEDURE 호출 Start. >>>>>>>> " + params);
			dao.list("prod.workorder.out.order.create2.call.Procedure", params);
			System.out.println("공정실적 > 일괄 외주발주 생성 PROCEDURE 호출 End.  >>>>>>>> " + params);
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
	 * 작업지시 완료/마감 // 상태 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkProdEndStatus(HashMap<String, Object> params) throws Exception {

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
			String workstatus = StringUtil.nullConvert(master.get("WORKSTATUS"));
			
			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("WORKORDERID", workorderid);
			master.put("WORKORDERSEQ", "");
			master.put("GUBUN", workstatus);
			
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("작업지시 완료/마감 상태 변경 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("workStatusUpdate.call.Procedure", master);
			System.out.println("작업지시 완료/마감 상태 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt += 1;
				throw new Exception("call CB_MFG_PKG.CB_WORK_STATUS_U fail.");
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
	 * 2017.04.19 작업지시투입관리 초중종 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> fmlWorkProdStart(HashMap<String, Object> params) throws Exception {
		//    	List<Object> list = super.getGridData(params);
		//		if (list.size() == 0)
		//			return super.getExtGridResultMap(false);

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
			System.out.println("insert cb_fml_master >>>>>>>>>> " + master);

			// 프로시저 호출
			master.put("REGISTID", login.getId());
			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("초중종 수기 추가 생성 PROCEDURE 호출 Start. >>>>>>>> " + master);
			dao.list("prodWorkFmlCreate.call.Procedure", master);
			System.out.println("초중종 수기 추가 생성 PROCEDURE 호출 End.  >>>>>>>> " + master);
		}
		//		boolean isSuccess = dao.updateListByIbatis("prod.work.update", list) > 0;

		boolean isSuccess = true;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}

		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 작업지시 완료 / 마감 // 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderEndList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.end.list.select", params);
	}

	/**
	 * 작업지시 완료 / 마감항목 // 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderEndCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.end.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.01.23 작업지시완료마감 DETAIL 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkEndDList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.endD.select", params);
	}

	/**
	 * 2017.01.23 작업지시완료마감 DETAIL 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkEndDCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.endD.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 작업지시 COPY // 데이터 생성
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkOrderCopy(HashMap<String, Object> params) throws Exception {
		System.out.println("insertWorkOrderCopy SERVICE Start. >>>>>>>>>> ");
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

			System.out.println("insertWorkOrderCopy 2. >>>>>>>>>> " + list.size());
			try {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> master = (Map<String, Object>) list.get(i);
					
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					String workorderidf = StringUtil.nullConvert(master.get("WORKORDERIDF"));
					String workorderidt = StringUtil.nullConvert(master.get("WORKORDERIDT"));
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					String gubun = "I";
					String startyn = StringUtil.nullConvert(master.get("STARTYN"));
					String endyn = StringUtil.nullConvert(master.get("ENDYN"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("WORKORDERIDF", workorderidf);
					master.put("WORKORDERIDT", workorderidt);
					master.put("ITEMCODE", itemcode);
					master.put("GUBUN", gubun);
					master.put("STARTYN", startyn);
					master.put("ENDYN", endyn);

					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("작업지시 복사 생성 호출 Start. >>>>>>>> ");
					dao.list("prod.work.copy.create.call.Procedure", master);
					System.out.println("작업지시 복사 생성 호출 End.  >>>>>>>> " + master);

					String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt++;
						msgData = StringUtil.nullConvert(master.get("MSGDATA"));
					} else {
						msgData = "정상적으로 저장하였습니다.";
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
//			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
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


	/**
	 * 조회 부분에 작업지시투입현황 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkOrderEquipmentList(Map<String, Object> params) throws Exception {

		return dao.list("prod.work.equipment.list.select", params);
	}

	/**
	 * 조회 부분에 작업지시투입현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkOrderEquipmentCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("prod.work.equipment.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 작업지시 -> 생산계획 -> 수주 연결 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkOrderEquipmentList(HashMap<String, Object> params) throws Exception {
		System.out.println("updateWorkOrderEquipmentList SERVICE Start. >>>>>>>>>> ");
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

			System.out.println("updateWorkOrderEquipmentList 2. >>>>>>>>>> " + list.size());
			try {
				for (int i = 0; i < list.size(); i++) {
					Map<String, Object> master = (Map<String, Object>) list.get(i);
					
					String orgid = StringUtil.nullConvert(master.get("ORGID"));
					String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
					String sono = StringUtil.nullConvert(master.get("SONO"));
					String soseq = StringUtil.nullConvert(master.get("SOSEQ"));
					String workplanno = StringUtil.nullConvert(master.get("WORKPLANNO"));
					String workorderid = StringUtil.nullConvert(master.get("WORKORDERID"));
					String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));
					
					master.put("ORGID", orgid);
					master.put("COMPANYID", companyid);
					master.put("SONO", sono);
					master.put("SOSEQ", soseq);
					master.put("WORKPLANNO", workplanno);
					master.put("WORKORDERID", workorderid);
					master.put("ITEMCODE", itemcode);

					master.put("REGISTID", loginVO.getId());
					master.put("RETURNSTATUS", "");
					master.put("MSGDATA", "");
					System.out.println("작업지시 -> 수주 연결 프로시저 호출 Start. >>>>>>>> ");
					dao.list("prod.work.plan.update.call.Procedure", master);
					System.out.println("작업지시 -> 수주 연결 프로시저 호출 End.  >>>>>>>> " + master);

					String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
					if (!status.equals("S")) {
						errcnt++;
						msgData = StringUtil.nullConvert(master.get("MSGDATA"));
					} else {
						msgData = "정상적으로 연결하였습니다.";
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
//			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
			System.out.println("메시지 확인1. >>>>>>>> " + msgData);
			System.out.println("메시지 확인2. >>>>>>>> " + msgData.length());
			if (msgData.length() > 0) {
				params.put("success", isSuccess);
				params.put("msg", msgData);
			} else {
				params.putAll(super.getExtGridResultMap(isSuccess, "update"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}

}