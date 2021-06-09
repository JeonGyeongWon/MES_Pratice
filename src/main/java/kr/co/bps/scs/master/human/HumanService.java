package kr.co.bps.scs.master.human;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : HumanService.java
 * @Description : Human Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author shseo
 * @since 2016. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class HumanService extends BaseService {
	/**
	 * 사원 관리
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectHumanList(Map<String, Object> params) throws Exception {
		System.out.println("selecthuman >>>>>>>>>>");

		return dao.list("human.list.select", params);
	}

	/**
	 * 사원 관리
	 * 
	 * @param params - 조회할 정보
	 * @return int 갯수
	 * @exception Exception
	 */
	public int selectHumanCount(Map<String, Object> params) throws Exception {
		System.out.println("selectroutingItemCount >>>>>>>>>>");

		List<?> count = dao.list("human.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 사원 관리 // 데이터 등록
	 * 
	 * @param params - 조회할 정보
	 * @return Map<String, Object> 결과
	 * @exception Exception
	 */
	public Map<String, Object> insertHumanResourceList(Map<String, Object> params) throws Exception {
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

			int insertResult = dao.update("human.list.insert", master);
			if (insertResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_HUMANRESOURCE_MANAGER fail.");
			} else {
				master.put("GUBUN", "I");

				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("사원관리 자동생성 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("human.manage.call.Procedure", master);
				System.out.println("사원관리 자동생성 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
//					throw new Exception("call CB_HUMAN_PKG.CB_HUMAN_MANAGER FAIL.");
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
	 * 사원 관리 // 데이터 변경
	 * 
	 * @param params - 조회할 정보
	 * @return Map<String, Object> 결과
	 * @exception Exception
	 */
	public Map<String, Object> updateHumanResourceList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATETID", login.getId());
			
			int updateResult = dao.update("human.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_HUMANRESOURCE_MANAGER fail.");
			} else {
				master.put("GUBUN", "U");

				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("사원관리 자동변경 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("human.manage.call.Procedure", master);
				System.out.println("사원관리 자동변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
//					throw new Exception("call CB_HUMAN_PKG.CB_HUMAN_MANAGER FAIL.");
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
	 * 사원 관리 // 데이터 삭제
	 * 
	 * @param params - 조회할 정보
	 * @return Map<String, Object> 결과
	 * @exception Exception
	 */
	public Map<String, Object> deleteHumanResourceList(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATETID", login.getId());
			
			int deleteResult = dao.update("human.list.delete", master);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("DELETE FROM CB_HUMANRESOURCE_MANAGER fail.");
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

	/** 2016.12.07
	 * 사원관리 사업장연결 
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return HumanService 목록
	 * @exception Exception
	 */
	public List<?> selectHumanDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectHumanDetailList >>>>>>>>>>");

		return dao.list("human.org.select", params);
	}

	/**2016.12.07
	 * @param params
	 *            - 조회할 정보
	 * @return HumanService 총 갯수
	 * @exception Exception
	 */
	public int selectHumanDetailCount(Map<String, Object> params) throws Exception {
		System.out.println("selectHumanDetailCount >>>>>>>>>>");

		List<?> count = dao.list("human.org.count", params);

		int result = (Integer) count.get(0);
		return result;
	}	
	
	/** 2016.12.07
	 * 사원정보 사업장연결  추가
	 */

	public Map<String, Object> insertHumanDetail(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			LoginVO loginVO = getLoginVO();
			master.put("REGISTID", loginVO.getId());
			master.put("UPDATETID", loginVO.getId());

			int updateResult = dao.update("human.org.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into human_auth fail.");
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
	
	
	/** 2016.12.07
	 * 사원정보 사업장연결  수정
	 */
	public Map<String, Object> updateHumanResourceDetail(Map<String, Object> params) throws Exception {
		
		String employee = StringUtil.nullConvert(params.get("EmployeeNumberVal"));
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATETID", login.getId());
			master.put("REGISTID", login.getId());
			master.put("EmployeeNumberVal", employee);

			String chk = null;
			String empno = null;
			chk = StringUtil.nullConvert(master.get("CHK"));
			empno = StringUtil.nullConvert(master.get("EMPLOYEENUMBER"));

			System.out.println("2. updateHumanDetail employee >>>>>>>>>> " + employee);
			System.out.println("2. updateHumanDetail chk >>>>>>>>>> " + chk);
			System.out.println("2. updateHumanDetail empno >>>>>>>>>> " + empno);
			if (!empno.isEmpty()) {

				if (chk.equals("Y")) {
					System.out.println("selectHumanRousourceDetail 1-1 >>>>>>>>> " + params);

					int updateResult = dao.update("human.org.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_HUMANRESOURCE_MANAGER_AUTH fail.");
					}
				} else {
					System.out.println("selectHumanRousourceDetail 1-2 >>>>>>>>> " + params);
					int updateResult = dao.update("human.org.delete", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("DELETE CB_HUMANRESOURCE_MANAGER_AUTH fail.");
					}
				}
			} else {
				if (chk.equals("Y")) {
					System.out.println("selectHumanRousourceDetail 2-1 >>>>>>>>> " + params);
					int updateResult = dao.update("human.org.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("INSERT CB_HUMANRESOURCE_MANAGER_AUTH fail.");
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
		
		return params;
	}

	/** 2016.12.28
	 * 사원관리 설비연결 
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return HumanService 목록
	 * @exception Exception
	 */
	public List<?> selectHumanEquipList(Map<String, Object> params) throws Exception {
		System.out.println("selectHumanEquipList >>>>>>>>>>");

		return dao.list("human.equip.select", params);
	}

	/**2016.12.28
	 * @param params
	 *            - 조회할 정보
	 * @return HumanService 총 갯수
	 * @exception Exception
	 */
	public int selectHumanEquipCount(Map<String, Object> params) throws Exception {
		System.out.println("selectHumanEquipCount >>>>>>>>>>");

		List<?> count = dao.list("human.equip.count", params);

		int result = (Integer) count.get(0);
		return result;
	}	
	

	/** 2016.12.28
	 * 사원정보 사업장연결  추가
	 */

	public Map<String, Object> insertHumanEquip(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
		}

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			LoginVO loginVO = getLoginVO();
			master.put("REGISTID", loginVO.getId());
			master.put("UPDATETID", loginVO.getId());

			int updateResult = dao.update("human.equip.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into human_equip fail.");
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
	
	
	/** 2016.12.28
	 * 사원정보 설비연결  수정
	 */
	public Map<String, Object> updateHumanResourceEquip(Map<String, Object> params) throws Exception {
		
		String employee = StringUtil.nullConvert(params.get("EmployeeNumberVal"));
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("EmployeeNumberVal", employee);

			boolean chk = false;
			String empno = null;
			chk = (boolean) master.get("CHK");
			empno = StringUtil.nullConvert(master.get("EMPLOYEENUMBER"));

			System.out.println("2. updateHumanEquip employee >>>>>>>>>> " + employee);
			System.out.println("2. updateHumanEquip chk >>>>>>>>>> " + chk);
			System.out.println("2. updateHumanEquip empno >>>>>>>>>> " + empno);
			if (!empno.isEmpty()) {
				master.put("UPDATETID", login.getId());
				
				if (chk) {
					System.out.println("selectHumanRousourceEquip 1-1 >>>>>>>>> " + params);

					master.put("USEYN", "Y");
					int updateResult = dao.update("human.equip.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_HUMANRESOURCE_EQUIP fail.");
					}
				} else {
					System.out.println("selectHumanRousourceEquip 1-2 >>>>>>>>> " + params);
//					int deleteResult = dao.update("human.equip.delete", master);
//					if (deleteResult == 0) {
//						// 저장 실패시 띄우는 예외처리
//						errcnt += 1;
//						throw new Exception("DELETE CB_HUMANRESOURCE_EQUIP fail.");
//					}
					master.put("USEYN", "N");
					int updateResult = dao.update("human.equip.update", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("UPDATE CB_HUMANRESOURCE_EQUIP fail.");
					}
				}
			} else {
				if (chk) {
					System.out.println("selectHumanRousourceEquip 2-1 >>>>>>>>> " + params);
					
					master.put("REGISTID", login.getId());
					master.put("USEYN", "Y");
					
					int updateResult = dao.update("human.equip.insert", master);
					if (updateResult == 0) {
						// 저장 실패시 띄우는 예외처리
						errcnt += 1;
						throw new Exception("INSERT CB_HUMANRESOURCE_EQUIP fail.");
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
		
		return params;
	}

	/** 2016.12.28
	 * 사원정보 설비연결  삭제
	 */
	public Map<String, Object> deleteHumanEquip(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("human.equip.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
	
}