package kr.co.bps.scs.master.routing;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import kr.co.bps.scs.base.service.BaseService;
import kr.co.bps.scs.util.StringUtil;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import egovframework.com.cmm.LoginVO;

/**
 * @ClassName : RoutingService.java
 * @Description : Routing Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2016. 12.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class RoutingService extends BaseService {
	/**
	 * 공정 등록 // 목록 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> RoutingRegisterList(Map<String, Object> params) throws Exception {
		System.out.println("RoutingRegisterList >>>>>>>>>> " + params);

		return dao.list("master.routing.list.select", params);
	}

	/**
	 * 공정 등록 // 총 개수 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int RoutingRegisterTotCnt(Map<String, Object> params) throws Exception {
		System.out.println("RoutingRegisterTotCnt >>>>>>>>>> " + params);

		List<?> count = dao.list("master.routing.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공정 등록 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertRoutingRegister(Map<String, Object> params) throws Exception {
		System.out.println("insertRoutingRegister Start. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("master.routing.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_ROUTING_CONTROL fail.");
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
	 * 공정 등록 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateRoutingRegister(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateRoutingRegister >>>>>>>>>> " + list);
		boolean isSuccess = dao.updateListByIbatis("master.routing.list.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 공정 불량 등록 선택 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteRoutingRegister(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("master.routing.list.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

	/**
	 * 공정별 설비 // 목록 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectRoutingDetailList(Map<String, Object> params) throws Exception {
		System.out.println("selectRoutingDetailList >>>>>>>>>> " + params);

		return dao.list("master.routing.detail.select", params);
	}

	/**
	 * 공정별 설비 // 총 개수 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectRoutingDetailCount(Map<String, Object> params) throws Exception {
		System.out.println("RoutingRegisterTotCnt >>>>>>>>>> " + params);

		List<?> count = dao.list("master.routing.detail.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공정별 설비 // insert, update, delete 호출
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateRoutingDetail(Map<String, Object> params) throws Exception {
		System.out.println("updateRoutingDetail Start. >>>>>>>>>> " + params);
		String routing = StringUtil.nullConvert(params.get("routingid"));
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		String msgData = null;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("routingid", routing);
			String chk = StringUtil.nullConvert(master.get("CHK"));
			String routingid = StringUtil.nullConvert(master.get("ROUTINGID"));

			System.out.println("1. updateRoutingDetail routing >>>>>>>>>> " + routing);
			System.out.println("2. updateRoutingDetail routingid >>>>>>>>>> " + routingid);
			System.out.println("3. updateRoutingDetail chk >>>>>>>>>> " + chk);
			if (!routingid.isEmpty()) {
//				if (chk.equals("Y")) {
					System.out.println("updateRoutingDetail 1-1 >>>>>>>>> " + params);

					master.put("UPDATETID", login.getId());
					int updateResult = dao.update("master.routing.detail.update", master);
					if (updateResult == 0) {
						errcnt += 1;
						throw new Exception("UPDATE CB_EQUIPMENT_MASTER fail.");
					} else {
						msgData = "정상적으로 변경하였습니다.";
					}
//				} else {
//					System.out.println("updateRoutingDetail 1-2 >>>>>>>>> " + params);
//					int updateResult = dao.update("master.routing.detail.delete", master);
//					if (updateResult == 0) {
//						errcnt += 1;
//						throw new Exception("DELETE CB_EQUIPMENT_MASTER fail.");
//					} else {
//						msgData = "정상적으로 삭제하였습니다.";
//					}
//				}
			} else {
				if (chk.equals("Y")) {
					System.out.println("updateRoutingDetail 2-1 >>>>>>>>> " + params);

					if ( !routing.isEmpty() ) {
						master.put("REGISTID", login.getId());
						int updateResult = dao.update("master.routing.detail.insert", master);
						if (updateResult == 0) {
							errcnt += 1;
							throw new Exception("INSERT INTO CB_EQUIPMENT_MASTER fail.");
						} else {
							msgData = "정상적으로 저장하였습니다.";
						}
					} else {
						errcnt += 1;
						msgData = "[오류] 공정이 선택되지 않았습니다.<br/>다시 확인해주세요.";
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
//		params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		if ( msgData.length() > 0 ) {
			params.put("success", isSuccess);
			params.put("msg", msgData);
		} else {
			params.putAll(super.getExtGridResultMap(isSuccess, "update"));
		}
		return params;
	}
	

	/**
	 * 공구 LIST 정보 // 목록 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> ToolCheckList(Map<String, Object> params) throws Exception {
		System.out.println("ToolCheckList SERVICE. >>>>>>>>>> " + params);

		return dao.list("master.tool.list.select", params);
	}

	/**
	 * 공구 LIST 정보 // 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int ToolCheckTotCnt(Map<String, Object> params) throws Exception {
		System.out.println("ToolCheckTotCnt SERVICE. >>>>>>>>>> " + params);

		List<?> count = dao.list("master.tool.list.count", params);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 공구 LIST 정보 //  데이터 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertToolCheckList(Map<String, Object> params) throws Exception {
		System.out.println("insertToolCheckList SERVICE. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("master.tool.list.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_TOOL_CHECK_MASTER fail.");
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
	 * 공구 LIST 정보 //  데이터 변경
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateToolCheckList(Map<String, Object> params) throws Exception {
		System.out.println("insertToolCheckList SERVICE. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("master.tool.list.update", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("update CB_TOOL_CHECK_MASTER fail.");
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
	 * 라우팅복사 pakage 등록
	 * 
	 * @param params - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> pkgRoutingItemCopy(Map<String, Object> params) throws Exception {
		System.out.println("pkgRoutingItemCopy >>>>>>>>>> " + params);
		LoginVO login = getLoginVO();
		int errcnt = 0;
		String orgid = String.valueOf(params.get("ORGID"));
		String companyid = String.valueOf(params.get("COMPANYID"));
		String itemcode = StringUtil.nullConvert(params.get("ITEMCODE"));
		String itemcodepost = StringUtil.nullConvert(params.get("ITEMCODEPOST"));
		
		params.put("ORGID", orgid);
		params.put("COMPANYID", companyid);
		params.put("ITEMCODE", itemcode);
		params.put("ITEMCODEPOST", itemcodepost);
		params.put("REGISTID", login.getId());
		params.put("RETURNRSTATUS", "");
		params.put("RETURNESTATUS", "");
		params.put("MSGDATA", "");
		System.out.println("라우팅복사 PROCEDURE 호출 Start. >>>>>>>> ");
		dao.list("routing.routingcopy.call.Procedure", params);
		System.out.println("라우팅복사 PROCEDURE 호출 End.  >>>>>>>> " + params);

		String rstatus = StringUtil.nullConvert(params.get("RETURNRSTATUS"));
		System.out.println("status.  >>>>>>>> " + rstatus);
		if ( !rstatus.equals("S") ) {
			errcnt++;
			throw new Exception("call CB_ROUTING_COPY.CB_ROUTING_CONTROL_COPY FAIL.");
		}else{
			System.out.println("설비복사 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("routing.equipmentcopy.call.Procedure", params);
			System.out.println("설비복사 PROCEDURE 호출 End.  >>>>>>>> " + params);
			String estatus = StringUtil.nullConvert(params.get("RETURNESTATUS"));
			System.out.println("status.  >>>>>>>> " + estatus);
			if ( !estatus.equals("S") ) {
				errcnt++;
				throw new Exception("call CB_ROUTING_COPY.CB_EQUIPMENT_MASTER_COPY FAIL.");
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
	 * 기준단가 // 목록 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectSalesPriceRoutingList(Map<String, Object> params) throws Exception {
		System.out.println("selectSalesPriceRoutingList >>>>>>>>>> " + params);

		return dao.list("master.routing.sales.price.select", params);
	}

	/**
	 * 기준단가 // 총 개수 조회
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectSalesPriceRoutingCount(Map<String, Object> params) throws Exception {
		System.out.println("selectSalesPriceRoutingCount >>>>>>>>>> " + params);

		List<?> count = dao.list("master.routing.sales.price.count", params);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 기준단가 등록 // 데이터 등록
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> insertSalesPriceRouting(Map<String, Object> params) throws Exception {
		System.out.println("insertRoutingRegister Start. >>>>>>>>>> " + params);
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

			int updateResult = dao.update("master.routing.price.insert", master);
			if (updateResult == 0) {
				// 저장 실패시 띄우는 예외처리
				errcnt += 1;
				throw new Exception("insert into CB_SALES_PRICE_ROUTING fail.");
			}
			dao.update("master.routing.price.update2", master);
			
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
	 * 기준단가 등록 // 데이터 변경
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> updateSalesPriceRouting(Map<String, Object> params) throws Exception {

		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		LoginVO login = getLoginVO();
		int errcnt = 0;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> master = (Map<String, Object>) list.get(i);

			master.put("UPDATEID", login.getId());
		}

		System.out.println("updateRoutingRegister >>>>>>>>>> " + list);
		boolean isSuccess = dao.updateListByIbatis("master.routing.price.update", list) > 0;
		return super.getExtGridResultMap(isSuccess, "update");
	}

	/**
	 * 기준단가 데이터 삭제
	 * 
	 * @param params
	 *            - 삭제할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> deleteSalesPriceRouting(Map<String, Object> params) throws Exception {
		List<Object> list = super.getGridData(params);
		if (list.size() == 0)
			return super.getExtGridResultMap(false);

		boolean isSuccess = dao.deleteListByIbatis("master.routing.price.delete", list) > 0;
		return super.getExtGridResultMap(isSuccess, "delete");
	}

}