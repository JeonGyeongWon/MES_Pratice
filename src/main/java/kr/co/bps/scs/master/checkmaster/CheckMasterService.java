package kr.co.bps.scs.master.checkmaster;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : CheckMasterService.java
 * @Description : CheckMaster Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 07.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class CheckMasterService extends BaseService {

	/**
	 * 2016-12-06 Item 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectItemMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMaster >>>>>>>>>> ");

		return dao.list("checkmaster.item.select", params);
	}

	/**
	 * 2016-12-06 Item 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectItemMasterCount(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterCount >>>>>>>>>> ");

		List<?> count = dao.list("checkmaster.item.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2016-12-20 품질 기준 마스터 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectCheckMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckMasterList >>>>>>>>>> ");

		return dao.list("master.check.select", params);
	}

	/**
	 * 2016-12-20 품질 기준 마스터 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectCheckMasterCount(Map<String, Object> params) throws Exception {
		System.out.println("selectCheckMasterCount >>>>>>>>>> ");

		List<?> count = dao.list("master.check.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	// frist select
	public String selectFirstItemcd(HashMap<String, Object> params) throws Exception {
		String result = null;

		try {
			Map<String, Object> itemcodeMap = (Map<String, Object>) dao.selectByIbatis("checkmaster.first.select", params);
			System.out.println("itemcodeMap >>>>>>>>>> " + itemcodeMap);

			if (itemcodeMap.isEmpty()) {
				result = null;
			} else {
				String[] itemcodeList = itemcodeMap.get("ITEMCODE").toString().split(",");

				result = itemcodeList[0].toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * 2016.12.21 검사기준 정보 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertCheckMasterD(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("master.check.insert", master);
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
	 * 2016.12.21 검사기준 정보 데이터 수정
	 * 
	 * @param params
	 *            - 수정할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateCheckMasterD(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateCheckMasterD >>>>>>>>>>" + list);
		boolean isSuccess = dao.updateListByIbatis("master.check.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 2016.12.21 검사기준 정보 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CheckclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteCheckMasterD(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("master.check.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 검사기준정보POPUP // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CheckmasterPopList(Map<String, Object> params) throws Exception {

		return dao.list("master.check.list.pop.select", params);
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 검사기준정보POPUP // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CheckmasterPopTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("master.check.list.pop.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 아이템별 품질 기준 마스터 // POPUP LIST 를 호출한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 목록
	 * @exception Exception
	 */
	public List<?> CheckmasterPopCheckList(Map<String, Object> params) throws Exception {

		return dao.list("master.check.list.popcheck.select", params);
	}

	/**
	 * 2017.03.10 품질기준마스터 화면에서 아이템별 품질 기준 마스터 // POPUP LIST 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return SearchService 총 갯수
	 * @exception Exception
	 */
	public int CheckmasterPopCheckTotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("master.check.list.popcheck.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

}