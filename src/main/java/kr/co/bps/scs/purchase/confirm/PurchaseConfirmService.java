package kr.co.bps.scs.purchase.confirm;

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
 * @ClassName : PurchaseConfirmService.java
 * @Description : PurchaseConfirm Service class
 * @Modification Information
 * 
 *               Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2018. 02.
 * @version 1.0
 * @see
 * 
 * 
 */
@Transactional
@Service
public class PurchaseConfirmService extends BaseService {

	/**
	 * 매입확정 항목을 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return List<?> 목록
	 * @exception Exception
	 */
	public List<?> selectPurchaseConfirmList(Map<String, Object> params) throws Exception {

		return dao.list("purchase.confirm.list.select", params);
	}

	/**
	 * 매입확정 항목 총 갯수를 조회한다.
	 * 
	 * @param params
	 *            - 조회할 정보
	 * @return int 총 갯수
	 * @exception Exception
	 */
	public int selectPurchaseConfirmCount(HashMap<String, Object> reqMap) {
		List<?> count = dao.list("purchase.confirm.list.count", reqMap);

		int result = (Integer) count.get(0);
		return result;
	}

	/**
	 * 매입확정 (확정 / 취소) 처리
	 * 
	 * @param params
	 *            - 등록할 정보
	 * @return Map<String, Object> 성공여부
	 * @exception Exception
	 */
	public Map<String, Object> apprPurchaseConfirm(HashMap<String, Object> params) throws Exception {

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

			String orgid = StringUtil.nullConvert(master.get("ORGID"));
			String companyid = StringUtil.nullConvert(master.get("COMPANYID"));
			String transno = StringUtil.nullConvert(master.get("TRANSNO"));
			String transseq = StringUtil.nullConvert(master.get("TRANSSEQ"));
			Integer seq = NumberUtil.getInteger(master.get("SEQ"));
			String confirmdate = StringUtil.nullConvert(master.get("CONFIRMDATE"));
			Integer confirmqty = NumberUtil.getInteger(master.get("CONFIRMQTY"));
			Integer unitprice = NumberUtil.getInteger(master.get("UNITPRICE"));
			Integer supplyprice = NumberUtil.getInteger(master.get("SUPPLYPRICE"));
			Integer additionaltax = NumberUtil.getInteger(master.get("ADDITIONALTAX"));
			String gubun = StringUtil.nullConvert(master.get("SAVETYPE"));

			master.put("ORGID", orgid);
			master.put("COMPANYID", companyid);
			master.put("TRANSNO", transno);
			master.put("TRANSSEQ", transseq);
			master.put("SEQ", seq);
			master.put("CONFIRMDATE", confirmdate);
			master.put("CONFIRMQTY", confirmqty);
			master.put("UNITPRICE", unitprice);
			master.put("SUPPLYPRICE", supplyprice);
			master.put("ADDITIONALTAX", additionaltax);
			master.put("GUBUN", gubun);

			master.put("REGISTID", loginVO.getId());

			master.put("RETURNSTATUS", "");
			master.put("MSGDATA", "");
			System.out.println("매입 확정/취소 처리 PROCEDURE 호출 Start. >>>>>>>> ");
			dao.list("purchase.confirm.call.Procedure", master);
			System.out.println("매입 확정/취소 처리 PROCEDURE 호출 End.  >>>>>>>> " + master);

			String status = StringUtil.nullConvert(master.get("RETURNSTATUS"));
			if (!status.equals("S")) {
				errcnt++;
				throw new Exception("call CB_PURCHASE_PKG.CB_TRANS_CONFIRM_PROC FAIL.");
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