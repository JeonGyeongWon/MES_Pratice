package kr.co.bps.scs.pda;

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
 * @ClassName : PdaService.java
 * @Description : Pda Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2021. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class PdaService extends BaseService {

	/**
	 * PDA 외주공정 입고등록에 사용할 LOT 중복여부 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> searchOutTransBarcodeCheckList(Map<String, Object> params) throws Exception {

		return dao.list("pda.outtrans.lot.check.select", params);
	}

	/**
	 * PDA 외주공정 입고등록에 사용할 LOT 중복여부 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int searchOutTransBarcodeChecktotCnt(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("pda.outtrans.lot.check.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * PDA 외주공정 입고등록에 사용할 LOT 중복여부 조회
	 * 
	 * @param params - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectPdaOutTransDetailList(Map<String, Object> params) throws Exception {

		return dao.list("pda.outtrans.lot.detail.list.select", params);
	}

	/**
	 * PDA 외주공정 입고등록에 사용할 LOT 중복여부 총 개수 조회
	 * 
	 * @param params - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectPdaOutTransDetailListCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("pda.outtrans.lot.detail.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}
	
	/**
	 * 입고등록 그리드 데이터 insert
	 * 
	 * @param params - 등록할 정보
	 * 
	 * @return RequestPurchaseService 성공여부
	 * 
	 * @exception Exception
	 */
	public Map<String, Object> insertPdaOutTransDetailList(HashMap<String, Object> params) throws Exception {

		System.out.println("insertPdaOutTransDetailList Start. >>>>>>>>>> ");
		try {
			System.out.println("insertPdaOutTransDetailList 1. >>>>>>>>>> " + params.get("data"));
			// 디테일 등록
			int errcnt = 0;
			List<?> list = (List<?>) params.get("data");
			
			System.out.println("insertPdaOutTransDetailList 3. >>>>>>>>>> " + list.size());
			LoginVO loginVO = getLoginVO();
			Map<String, Object> master = (Map<String, Object>) list.get(0);
			
			List ordernoList = dao.selectListByIbatis("pda.new.outtransno.select", master);
			Map<String, Object> current = (Map<String, Object>) ordernoList.get(0);
			
			String transno = (String) current.get("OUTTRANSNO");
			

			master.put("REGISTID", loginVO.getId());
			master.put("OUTTRANSNO", transno);
			dao.update("pda.outprocess.header.insert", master);
			
			
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> detail = (Map<String, Object>) list.get(i);

				detail.put("REGISTID", loginVO.getId());
				detail.put("OUTTRANSNO", transno);
				

				int updateResult = dao.update("pda.outprocess.detail.insert", detail);
				if (updateResult == 0) {
					// 저장 실패시 띄우는 예외처리
					errcnt += 1;
					throw new Exception("insert into CB_OUT_TRANS_D fail.");
				}else {
						// 저장 성공시 생산수량 생성 PKG 호출
						Integer orgid = NumberUtil.getInteger(detail.get("ORGID"));
						Integer companyid = NumberUtil.getInteger(detail.get("COMPANYID"));
						String outtransno = StringUtil.nullConvert(detail.get("OUTTRANSNO"));
						Integer outtransseq = NumberUtil.getInteger(detail.get("OUTTRANSSEQ"));
						String gubun = "I";

						detail.put("ORGID", orgid);
						detail.put("COMPANYID", companyid);
						detail.put("OUTTRANSNO", outtransno);
						detail.put("OUTTRANSSEQ", outtransseq);
						detail.put("GUBUN", gubun);

						detail.put("P_LOGIN", loginVO.getId());
						detail.put("RS_CODE", "");
						detail.put("RS_STATUS", "");
						System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 Start. >>>>>>>> ");
						dao.list("prodWorkOrderCreate.call.Procedure", detail);
						System.out.println("작업지시 생산수량 생성 PROCEDURE 호출 End.  >>>>>>>> " + detail);

						String status = StringUtil.nullConvert(detail.get("RS_STATUS"));
						String rscode = StringUtil.nullConvert(detail.get("RS_CODE"));
						if (!rscode.equals("S")) {
							errcnt += 1;
							throw new Exception("call CB_OUTSIDE_ORDER_PKG.CB_WORK_ORDER_CREATE fail. >>>>>>>>>>>>   " + status);
						}
						// 생산수량 생성 PKG 호출 끝
				}
		
			}

			// 저장시 ajax 성공유무 여부 호출
			boolean isSuccess = false;
			if (errcnt > 0) {
				isSuccess = false;
			} else {
				isSuccess = true;
			}
			params.putAll(super.getExtGridResultMap(isSuccess, "insert"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return params;
	}
}