package kr.co.bps.scs.master.item;

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
 * @ClassName : ItemService.java
 * @Description : Item Service class
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
public class ItemService extends BaseService {
	/**
	 * Bigclass 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectbigclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectbigclassList >>>>>>>>>>");

		return dao.list("item.bigclass.select", params);
	}

	/**
	 * Bigclass 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectbigclassCount(Map<String, Object> params) throws Exception {
		System.out.println("selectbigclassCount >>>>>>>>>>");

		List<?> count = dao.list("item.bigclass.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Bigclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertbigclassList(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("item.bigclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_BIG_CLASS fail.");
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
	 * Bigclass 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatebigclassList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updatebigclassList >>>>>>>>>> " + list);
		boolean isSuccess = dao.updateListByIbatis("item.bigclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Bigclass 첫번째 대분류 코드 가져오기
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 첫번째 대분류코드
	 * @exception Exception
	 */
	public String selectFirstBigcode(HashMap<String, Object> params) {
		String result = null;

		try {
			Map<String, Object> bigcodeMap = (Map<String, Object>) dao.selectByIbatis("item.bigclass.first.select", params);
			System.out.println("bigcodeMap >>>>>>>>>> " + bigcodeMap);

			if (bigcodeMap.isEmpty()) {
				result = null;
			} else {
				String[] bigcodeList = bigcodeMap.get("BIGCODE").toString().split(",");

				result = bigcodeList[0].toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * Middleclass 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectmiddleclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectmiddleclassList >>>>>>>>>> ");

		return dao.list("item.middleclass.select", params);
	}

	/**
	 * Middleclass 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectmiddleclassCount(Map<String, Object> params) throws Exception {
		System.out.println("selectmiddleclassCount >>>>>>>>>> ");

		List<?> count = dao.list("item.middleclass.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Middleclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertmiddleclassList(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("item.middleclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_MIDDLE_CLASS fail.");
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
	 * Middleclass 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatemiddleclassList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		boolean isSuccess = dao.updateListByIbatis("item.middleclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Middleclass 첫번째 중분류 코드 가져오기
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 첫번째 중분류코드
	 * @exception Exception
	 */
	public String selectFirstMiddlecode(HashMap<String, Object> params) {
		String result = null;

		try {
			Map<String, Object> middlecodeMap = (Map<String, Object>) dao.selectByIbatis("item.middleclass.first.select", params);
			System.out.println("middlecodeMap >>>>>>>>>> " + middlecodeMap);

			if (middlecodeMap.isEmpty()) {
				result = null;
			} else {
				String[] middlecodeList = middlecodeMap.get("MIDDLECODE").toString().split(",");

				result = middlecodeList[0].toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * Smallclass 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectsmallclassList(Map<String, Object> params) throws Exception {
		System.out.println("selectsmallclassList >>>>>>>>>> ");

		return dao.list("item.smallclass.select", params);
	}

	/**
	 * Smallclass 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectsmallclassCount(Map<String, Object> params) throws Exception {
		System.out.println("selectsmallclassCount >>>>>>>>>> ");

		List<?> count = dao.list("item.smallclass.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Smallclass 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertsmallclassList(Map<String, Object> params) throws Exception {
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

			int updateResult = dao.update("item.smallclass.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SMALL_CLASS fail.");
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
	 * Smallclass 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updatesmallclassList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = dao.updateListByIbatis("item.smallclass.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Smallclass 첫번째 소분류 코드 가져오기
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 첫번째 소분류코드
	 * @exception Exception
	 */
	public String selectFirstSmallcode(HashMap<String, Object> params) {
		String result = null;

		try {
			Map<String, Object> smallcodeMap = (Map<String, Object>) dao.selectByIbatis("item.smallclass.first.select", params);
			System.out.println("smallcodeMap >>>>>>>>>> " + smallcodeMap);

			if (smallcodeMap.isEmpty()) {
				result = null;
			} else {
				String[] smallcodeList = smallcodeMap.get("SMALLCODE").toString().split(",");

				result = smallcodeList[0].toString();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	/**
	 * Item 제품 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectitemProductList(Map<String, Object> params) throws Exception {
		System.out.println("selectitemProductList >>>>>>>>>> ");

		return dao.list("item.master.product.select", params);
	}

	/**
	 * Item 제품 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectitemProductCount(Map<String, Object> params) throws Exception {
		System.out.println("selectitemProductCount >>>>>>>>>> ");

		List<?> count = dao.list("item.master.product.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Item 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertitemList(Map<String, Object> params) throws Exception {
		System.out.println("insertitemList Start >>>>>>>>>> " + params);
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

			String groupcode = StringUtil.nullConvert(master.get("GROUPCODE"));
			String itemcode = StringUtil.nullConvert(master.get("ITEMCODE"));

			int updateResult = 0;
			if (!groupcode.isEmpty()) {
				// 품목코드 생성
				if (itemcode.isEmpty()) {
					System.out.println("insertitemList 품목코드 생성 >>>>>>>>>> ");
					List itemList = dao.selectListByIbatis("item.master.new.itemcode.select", master);
					Map<String, Object> itemMap = (Map<String, Object>) itemList.get(0);
					itemcode = (String) itemMap.get("ITEMCODE");
					master.put("ITEMCODE", itemcode);
					System.out.println("insertitemList itemcode >>>>>>>>>> " + itemcode);
				}

				if (groupcode.equals("A")) {
					updateResult = dao.update("item.master.product.insert", master);
				} else if (groupcode.equals("M")) {
					updateResult = dao.update("item.master.material.insert", master);
				} else if (groupcode.equals("T")) {
					updateResult = dao.update("item.master.tool.insert", master);
				}

				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_ITEM_MASTER fail.");
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
	 * Item 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateitemList(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;

		String groupcode = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());

			groupcode = StringUtil.nullConvert(master.get("GROUPCODE"));
		}

		boolean isSuccess = false;

		if (!groupcode.isEmpty()) {
			if (groupcode.equals("A")) {
				isSuccess = dao.updateListByIbatis("item.master.product.update", list) > 0;
			} else if (groupcode.equals("M")) {
				isSuccess = dao.updateListByIbatis("item.master.material.update", list) > 0;
			} else if (groupcode.equals("T")) {
				isSuccess = dao.updateListByIbatis("item.master.tool.update", list) > 0;
			}
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * Item 자재 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectitemMaterialList(Map<String, Object> params) throws Exception {
		System.out.println("selectitemMaterialList >>>>>>>>>> ");

		return dao.list("item.master.material.select", params);
	}

	/**
	 * Item 자재 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectitemMaterialCount(Map<String, Object> params) throws Exception {
		System.out.println("selectitemMaterialCount >>>>>>>>>> ");

		List<?> count = dao.list("item.master.material.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * Item 공구 데이터 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectitemToolList(Map<String, Object> params) throws Exception {
		System.out.println("selectitemToolList >>>>>>>>>> ");

		return dao.list("item.master.tool.select", params);
	}

	/**
	 * Item 공구 데이터 건수 확인
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectitemToolCount(Map<String, Object> params) throws Exception {
		System.out.println("selectitemToolCount >>>>>>>>>> ");

		List<?> count = dao.list("item.master.tool.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/** 2016-12-06
	 * Item   데이터 조회
	 * 
	 * @param params - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectItemMasterList(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMaster >>>>>>>>>> ");

		return dao.list("item.master.master.select", params);
	}

	/**2016-12-06
	 * Item  데이터 건수 확인
	 * 
	 * @param params - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectItemMasterCount(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterCount >>>>>>>>>> ");

		List<?> count = dao.list("item.master.master.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**2016-12-06
	 * Item 데이터 등록
	 * 
	 * @param params - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertItemMaster(Map<String, Object> params) throws Exception {
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

			// 검사여부는 기본 값 N으로 설정
			master.put("ROUTINGYN", "N");
			master.put("PROCESSINSPECTIONYN", "N");
			master.put("SHIPMENTINSPECTIONYN", "N");
			
			int updateResult = 0;
				updateResult = dao.update("item.master.master.insert", master);
				
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_ITEM_MASTER fail.");
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
	
	/**2016-12-06
	 * Item 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateItemMaster(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;

		String groupcode = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = false;
		isSuccess = dao.updateListByIbatis("item.master.master.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**2016-12-06
	 * Item 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteItemMaster(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		System.out.println("list :::::::::::::: " + list);

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			int deleteResult = dao.delete("item.master.master.delete", master);
			
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_ITEM_MASTER fail.");
			}
		}

		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
//		boolean isSuccess = dao.deleteListByIbatis("item.master.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}	

	/**
	 * Item Price // 데이터 조회
	 * 
	 * @param params - 조회 정보
	 * @return Map<String, Object> 목록
	 * @exception Exception
	 */
	public List<?> selectItemMasterPriceList(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterPriceList SERVICE. >>>>>>>>>> " + params);

		return dao.list("item.master.masterprice.select", params);
	}

	/**
	 * Item Price // 데이터 건수 확인
	 * 
	 * @param params - 조회 정보
	 * @return int 건수
	 * @exception Exception
	 */
	public int selectItemMasterPriceCount(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterPriceCount SERVICE. >>>>>>>>>> " + params);

		List<?> count = dao.list("item.master.masterprice.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * Item Price // 데이터 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertItemMasterPrice(Map<String, Object> params) throws Exception {
		System.out.println("insertItemMasterPrice SERVICE. >>>>>>>>>> " + params);
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
//			System.out.println("insertItemMasterPrice master. >>>>>>>>>> " + master);

			master.put("REGISTID", login.getId());

			int insertResult = 0;
			insertResult = dao.update("item.master.masterprice.insert", master);
				
			if (insertResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_ITEM_PRICE fail.");
			} else {
				master.put("UPDATEID", login.getId());
				int updateResult = 0;
				updateResult = dao.update("item.master.master.updateprice", master);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("update CB_ITEM_MASTER PRICE fail.");
				}

				String orgid = String.valueOf(params.get("ORGID"));
				String companyid = String.valueOf(params.get("COMPANYID"));
				String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
				master.put("ORGID", orgid);
				master.put("COMPANYID", companyid);
				master.put("ITEMCODE", itemcode);
				
				// 단가 일자 변경
				master.put("REGISTID", login.getId());
				master.put("RETURNSTATUS", "");
				master.put("MSGDATA", "");
				System.out.println("단가 일자 변경 PROCEDURE 호출 Start. >>>>>>>> ");
				dao.list("item.master.price.change.call.Procedure", master);
				System.out.println("단가 일자 변경 PROCEDURE 호출 End.  >>>>>>>> " + master);

				String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
				System.out.println("status.  >>>>>>>> " + status);
				if ( !status.equals("S") ) {
					errcnt++;
					throw new Exception("call CB_COMMON_STANDARD_PKG.CB_SALES_PRICE_CHANGE FAIL.");
				}
			}
		}

		// ajax 성공유무 여부 호출
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
	 * ItemPrice // 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateItemMasterPrice(Map<String, Object> params) throws Exception {
		System.out.println("updateItemMasterPrice SERVICE. >>>>>>>>>> " + params);
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

			master.put("UPDATEID", login.getId());

			int updateResult = 0;
				updateResult = dao.update("item.master.masterprice.update", master);
				
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_ITEM_PRICE fail.");
			}
		}

		// ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * ItemPrice // 데이터 삭제
	 * 
	 * @param params - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteItemMasterPrice(Map<String, Object> params) throws Exception {
		System.out.println("deleteItemMasterPrice SERVICE. >>>>>>>>>> " + params);
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

			int deleteResult = 0;
			deleteResult = dao.update("item.master.masterprice.delete", master);
				
			if (deleteResult == 0) {
				// 삭제 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_ITEM_PRICE fail.");
			}
		}

		// ajax 성공유무 여부 호출
		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
		return super.getExtGridResultMap(isSuccess, "delete");
	}
	
	/** 2017-04-25
	 * Item sales  데이터 조회
	 * 
	 * @param params - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectItemMasterSalesList(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterSales >>>>>>>>>> ");

		return dao.list("item.master.mastersales.select", params);
	}

	/**2017-04-25
	 * Item sales 데이터 건수 확인
	 * 
	 * @param params - 조회 정보
	 * @return ItemService 건수
	 * @exception Exception
	 */
	public int selectItemMasterSalesCount(Map<String, Object> params) throws Exception {
		System.out.println("selectItemMasterSalesCount >>>>>>>>>> ");

		List<?> count = dao.list("item.master.mastersales.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**2017-04-25
	 * Item Sales 데이터 등록
	 * 
	 * @param params - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertItemMasterSales(Map<String, Object> params) throws Exception {
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

			// 검사여부는 기본 값 N으로 설정
			
			int updateResult = 0;
				updateResult = dao.update("item.master.mastersales.insert", master);
				
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_ITEM_PRICE fail.");
			} else {
				int updateResult1 = 0;
				updateResult1 = dao.update("item.master.master.updatesales", master);
				if (updateResult1 == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("update into CB_ITEM_MASTER PRICE fail.");
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
	
	/**2017-04-25
	 * Item Sales 데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return ItemService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateItemMasterSales(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;

		String groupcode = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}
		boolean isSuccess = false;
		isSuccess = dao.updateListByIbatis("item.master.mastersales.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**2017-04-25
	 * Item Sales 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return CmmclassService 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteItemMasterSales(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);
		System.out.println("list :::::::::::::: " + list);

		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);
			int deleteResult = dao.delete("item.master.mastersales.delete", master);
			
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_ITEM_PRICE fail.");
			}
		}

		boolean isSuccess = false;
		if (errcnt > 0) {
			isSuccess = false;
		} else {
			isSuccess = true;
		}
//		boolean isSuccess = dao.deleteListByIbatis("item.master.master.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}
	
	/**
	 * 품목관리(제품, 자재, 공구) // Excel List 조회
	 * 
	 * @param params
	 *            - 조회 정보
	 * @return ItemService 목록
	 * @exception Exception
	 */
	public List<?> selectItemExcelList(Map<String, Object> params) throws Exception {
		System.out.println("selectItemExcelList >>>>>>>>>>");

		return dao.list("item.master.itemproductexcellist.select", params);
	}
}