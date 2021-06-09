package kr.co.bps.scs.master.checkclass;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : CheckclassService.java
 * @Description : Checkclass Service class
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
public class CheckclassService extends BaseService {

	// bigclass 조회
	public List<?> selectCheckbigclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckbigclassList >>>>>>>>>>");

		return dao.list("checkclass.big.select", params);
	}

	public int selectCheckbigclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckbigclassListCount >>>>>>>>>>");

		List<?> count = dao.list("checkclass.big.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// bigclass lov
	public List<?> selectCheckclassLovList(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckclassLovList >>>>>>>>>>");

		return dao.list("checkclass.lov.select", params);
	}

	public int selectCheckclassLovListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckclassLovListCount >>>>>>>>>>");

		List<?> count = dao.list("checkclass.lov.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// middleclass 조회
	public List<?> selectCheckmiddleclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckmiddleclassList >>>>>>>>>>");

		return dao.list("checkclass.middle.select", params);
	}

	public int selectCheckmiddleclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckmiddleclassListCount >>>>>>>>>>");

		List<?> count = dao.list("checkclass.middle.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// smallclass 조회
	public List<?> selectChecksmallclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectChecksmallclassList >>>>>>>>>>");

		return dao.list("checkclass.small.select", params);
	}

	public int selectChecksmallclassListCount(Map<String, Object> params) throws Exception {
		System.out.println("selectChecksmallclassListCount >>>>>>>>>>");

		List<?> count = dao.list("checkclass.small.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// frist select
	public String selectFirstbigcd(HashMap<String, Object> params) throws Exception {
		String result = null;

		try {
			Map<String, Object> bigcdMap = (Map<String, Object>) dao.selectByIbatis("checkclass.first.select", params);
			System.out.println("bigcdMap >>>>>>>>>> " + bigcdMap);

			if ( bigcdMap.isEmpty() ) {
				result = null;
			} else {
				String[] bigcdList = bigcdMap.get("BIGCD").toString().split(",");
	
				result = bigcdList[0].toString();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}

	public String selectFirstmiddlecd(HashMap<String, Object> params) throws Exception {
		String result = null;

		try {
			Map<String, Object> middlecdMap = (Map<String, Object>) dao.selectByIbatis("checkclass.mfirst.select", params);
			System.out.println("middlecdMap >>>>>>>>>> " + middlecdMap);
	
			if ( middlecdMap.isEmpty() ) {
				result = null;
			} else {
				String[] middlecdList = middlecdMap.get("MIDDLECD").toString().split(",");
	
				result = middlecdList[0].toString();
			}
		} catch ( Exception e ) {
			e.printStackTrace();
		}
		
		return result;
	}

	/**
	 * Bigclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCheckBigclass(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("checkclass.big.insert", master);
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
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCheckBigclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updatetCheckBigclass >>>>>>>>>>" + list);
		boolean isSuccess = dao.updateListByIbatis("checkclass.big.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Bigclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCheckBigclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("checkclass.big.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * Middleclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCheckMiddleclass(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("checkclass.middle.insert", master);
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
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCheckMiddleclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("checkclass.middle.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Middleclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCheckMiddleclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("checkclass.middle.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * Smallclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCheckSmallclass(Map<String, Object> params) throws Exception {
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
			int updateResult = dao.update("checkclass.small.insert", master);
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
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCheckSmallclass(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("checkclass.small.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Smallclass 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCheckSmallclass(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		System.out.println("list :::::::::::::: " + list);

		boolean isSuccess = dao.deleteListByIbatis("checkclass.small.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
}