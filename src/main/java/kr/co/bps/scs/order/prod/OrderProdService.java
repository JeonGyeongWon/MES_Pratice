package kr.co.bps.scs.order.prod;

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
 * @ClassName : OrderProdService.java
 * @Description : OrderProd Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author jsHwang
 * @since 2018. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class OrderProdService extends BaseService {

	/**
	 * 조회 부분에 제품수불현황 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdInventoryList(Map<String, Object> params) throws Exception {

		return dao.list("order.prod.inventory.list.select", params);
	}

	/**
	 * 조회 부분에 제품수불현황 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdInventoryCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.prod.inventory.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	
	/**
	 * 출하관리 > 제품 입출고 // Master 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdRelList(Map<String, Object> params) throws Exception {
		System.out.println("selectProdRelList Start. >>>>>>>>>> " + params);

		return dao.list("order.prod.release.master.list.select", params);
	}

	/**
	 * 출하관리 > 제품 입출고 // Master 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdRelCount(HashMap<String, Object> reqMap) {
		System.out.println("selectProdRelCount Start. >>>>>>>>>> " + reqMap);
		List<?> count = dao.list("order.prod.release.master.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 *  출하관리 > 제품 입출고 // 상세 항목을 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectProdRelDetailList(Map<String, Object> params) throws Exception {

		return dao.list("order.prod.release.detail.list.select", params);
	}

	/**
	 *  출하관리 > 제품 입출고 // 상세 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectProdRelDetailCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.prod.release.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/** 
	 * 출하관리 > 제품 입출고 // Grid 마스터 삭제
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteProdRelManage(HashMap<String, Object> params) throws Exception {

		String relno = null;
		try {
			relno = StringUtil.nullConvert(params.get("RelNo"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		List<Object> list = super.getGridData(params);
		if (list == null || list.size() == 0) {
			super.setUpdateParams(params);
			list = new ArrayList<Object>();
			list.add(params);
			//    		return super.getExtGridResultMap(false);
		}

		int errcnt = 0, count = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("RELNO", relno);
			
			System.out.println("Release No >>>>>>>>>> " + relno);

			int deleteResult = dao.delete("order.prod.release.header.delete", master);
			if (deleteResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("delete CB_RELEASE_H fail.");
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
	 * 재고실사,조정처리 항목 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ProdInvAdjustRegistList(Map<String, Object> params) throws Exception {

		return dao.list("order.prod.inventory.adjust.select", params);
	}

	/**
	 * 재고실사,조정처리 항목 총 갯수를 조회한다.
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ProdInvAdjustRegistListCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("order.prod.inventory.adjust.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 *  재고실사,조정처리  // 조정처리
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> callProdInvAdjustRegist(HashMap<String, Object> params) throws Exception {

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

			List checknoList = dao.selectListByIbatis("order.prod.inventory.adjust.checkno.select", master);
			Map<String, Object> current = (Map<String, Object>) checknoList.get(0);
			
			int checkno = NumberUtil.getInteger(current.get("CHECKNO"));
			master.put("CHECKNO", checkno);
			
			int updateResult = dao.update("order.prod.inventory.adjust.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("INSERT INTO CB_INV_CHECK fail");
			} else {
				master.put("P_ORG_ID", master.get("ORGID"));
				master.put("P_COMPANY_ID", master.get("COMPANYID"));
				master.put("P_ITEM_CODE", master.get("ITEMCODE"));
				master.put("P_TRX_GUBUN", "OUT");
				master.put("P_TRX_TYPE", "재고실사");
				master.put("P_TRX_QTY", NumberUtil.getInteger(master.get("CHECKQTY")));
				master.put("P_TRX_SOURCE_NO", String.valueOf(checkno));
				master.put("P_TRX_SOURCE_NO_SEQ", 0);
				master.put("P_TRX_WAREHOUSING", "");
				master.put("P_TRX_DATE", master.get("CHECKDATE"));
				master.put("P_REMARKS", StringUtil.nullConvert(master.get("REMARKS")));
				master.put("P_LOGIN", loginVO.getId());
				master.put("RS_CODE", "");
				master.put("RS_STATUS", "");

				System.out.println("재고관리 트랜잭션 호출 Start. >>>>>>>> " + master);
				dao.list("order.prod.inventory.adjust.call.procedure", master);
				System.out.println("재고관리 트랜잭션 호출 End.  >>>>>>>> " + master);
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