package kr.co.bps.scs.master.cmmclass;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : CmmclassService.java
 * @Description : Cmmclass Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author sjmun
 * @since 2016. 01
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class CmmclassService extends BaseService {

	// 대분류 SELECT
	public List<?> selectCmmbigclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmclassList >>>>>>>>>>");

		return dao.list("cmmclass.select", params);
	}

	public int selectCmmbigclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmclassListCount >>>>>>>>>>");

		List<?> count = dao.list("cmmclass.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// 중분류 SELECT
	public List<?> selectCmmmiddleclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmmiddleclassList >>>>>>>>>>");

		return dao.list("cmmclass.middle.select", params);
	}

	public int selectCmmmiddleclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmmiddleclassListCount >>>>>>>>>>");

		List<?> count = dao.list("cmmclass.middle.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// 소분류 SELECT
	public List<?> selectCmmsmallclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmsmallclassList >>>>>>>>>>");

		return dao.list("cmmclass.small.select", params);
	}

	public int selectCmmsmallclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCmmsmallclassListCount >>>>>>>>>>");

		List<?> count = dao.list("cmmclass.small.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// 첫번째 SELECT
	public String selectFirstbigcd(HashMap<String, Object> params) {
		String result = null;

		Map<String, Object> bigcdMap = (Map<String, Object>) dao.selectByIbatis("cmmclass.first.select", params);
		System.out.println("bigcdMap >>>>>>>>>> " + bigcdMap);

		if (bigcdMap.isEmpty() == true) {
			result = null;
		} else {
			String[] bigcdList = bigcdMap.get("BIGCD").toString().split(",");

			result = bigcdList[0].toString();
		}

		return result;
	}

	public String selectFirstmiddlecd(HashMap<String, Object> params) {

		String result = null;

		Map<String, Object> middlecdMap = (Map<String, Object>) dao.selectByIbatis("cmmclass.mfirst.select", params);
		System.out.println("middlecdMap >>>>>>>>>> " + middlecdMap);

		if (middlecdMap.isEmpty() == true) {
			result = null;
		} else {
			String[] middlecdList = middlecdMap.get("MIDDLECD").toString().split(",");

			result = middlecdList[0].toString();
		}

		return result;
	}

	/**
	 * Bigclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCmmBigClass(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("cmmbigclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update into item fail.");
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
	 * Bigclass 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCmmBigclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updatetCmmBigclass >>>>>>>>>>" + list);
		boolean isSuccess = dao.updateListByIbatis("cmmbigclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Bigclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCmmBigclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("cmmbigclass.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * Middleclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCmmMiddleclass(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("cmmmiddleclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update into item fail.");
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
	 * Middleclass 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCmmMiddleclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("cmmmiddleclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Middleclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCmmMiddleclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("cmmmiddleclass.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * Smallclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCmmSmallclass(Map<String, Object> params) throws Exception {
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
			int updateResult = dao.update("cmmsmallclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update into item fail.");
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
	 * Smallclass 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCmmSmallclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("cmmsmallclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Smallclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCmmSmallclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		System.out.println("list :::::::::::::: " + list);

		boolean isSuccess = dao.deleteListByIbatis("cmmsmallclass.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
}