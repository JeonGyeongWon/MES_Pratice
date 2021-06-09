package kr.co.bps.scs.master.workcenter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : WorkCenterMaService.java
 * @Description : WorkCenterMa Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2017. 11.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class WorkCenterMaService extends BaseService {

	/**
	 * 전체 작업장의 목록을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkCenterList(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterList >>>>>>>>>>");

		return dao.list("workcenter.list.select", params);
	}

	/**
	 * 전체 작업장의 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkCenterCount(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterCount >>>>>>>>>>");

		List<?> count = dao.list("workcenter.list.count", params);
		System.out.println("count >>>>>>>>>>>>>>> " + count.get(0));

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 작업장 관리 화면 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkCenterGrid(Map<String, Object> params) throws Exception {

		System.out.println("insertWorkCenterGrid Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			int insertResult = dao.update("workcenter.list.insert", master);
			if (insertResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_WORK_CENTER fail.");
			} else {
				master.put("GUBUN", "I");

				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("설비관리 자동생성 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("workcenter.manage.call.Procedure", master);
				System.out.println("설비관리 자동생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
//					throw new Exception("call CB_WORK_CENTER_PKG.CB_WORK_CENTER_MANAGE FAIL.");
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
	 * 작업장 관리 화면 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkCenterGrid(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkCenterGrid Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			int updateResult = dao.update("workcenter.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("UPDATE CB_WORK_CENTER fail.");
			} else {
				master.put("GUBUN", "U");

				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("설비관리 자동변경 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("workcenter.manage.call.Procedure", master);
				System.out.println("설비관리 자동변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
//					throw new Exception("call CB_WORK_CENTER_PKG.CB_WORK_CENTER_MANAGE FAIL.");
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
	 * 작업장 관리 화면 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkCenterGrid(Map<String, Object> params) throws Exception {

		System.out.println("deleteWorkCenterGrid Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			{
				master.put("GUBUN", "D");

				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("설비관리 자동삭제 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("workcenter.manage.call.Procedure", master);
				System.out.println("설비관리 자동삭제 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
//					throw new Exception("call CB_WORK_CENTER_PKG.CB_WORK_CENTER_MANAGE FAIL.");
				} else {
					int deleteResult = dao.update("workcenter.list.delete", master);
					if (deleteResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("DELETE FROM CB_WORK_CENTER fail.");
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
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 설비이력관리 목록을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkCenterRepairList(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterRepairList >>>>>>>>>>");

		return dao.list("workcenter.repair.select", params);
	}

	/**
	 * 설비이력관리 목록의 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkCenterRepairCount(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterRepairCount >>>>>>>>>>");

		List<?> count = dao.list("workcenter.repair.count", params);
		System.out.println("count >>>>>>>>>>>>>>> " + count.get(0));

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 작업장 관리 화면 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertWorkCenterRepairList(Map<String, Object> params) throws Exception {

		System.out.println("insertWorkCenterRepairList Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("REGISTID", login.getId());

			int insertResult = dao.update("workcenter.repair.insert", master);
			if (insertResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_WORK_CENTER_REPAIR fail.");
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
	 * 작업장 관리 화면 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return WorkCenterMaService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateWorkCenterRepairList(Map<String, Object> params) throws Exception {

		System.out.println("updateWorkCenterRepairList Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			int updateResult = dao.update("workcenter.repair.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("UPDATE CB_WORK_CENTER_REPAIR fail.");
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
	 * 작업장 관리 화면 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return WorkCenterMaService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteWorkCenterRepairList(Map<String, Object> params) throws Exception {

		System.out.println("deleteWorkCenterGrid Start. >>>>>>>>>> " + params);
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		
		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			
			int deleteResult = dao.update("workcenter.repair.delete", master);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE FROM CB_WORK_CENTER_REPAIR fail.");
			}
		}

		// 저장시 ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 설비 I/F // 목록을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectWorkCenterIFList(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterIFList >>>>>>>>>> " + params);

		return dao.list("workcenter.interface.list.select", params);
	}

	/**
	 * 설비 I/F // 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectWorkCenterIFCount(Map<String, Object> params) throws Exception {
		System.out.println("selectWorkCenterIFCount >>>>>>>>>> " + params);

		List<?> count = dao.list("workcenter.interface.list.count", params);
		System.out.println("count >>>>>>>>>> " + count.get(0));

		int result = (Integer) count.get(0);
		return result;
	}

}