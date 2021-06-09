package kr.co.bps.scs.base.vo;

import java.util.List;

import kr.co.bps.scs.base.BaseLogger;

/**
 * @ClassName : ExtGridVO.java
 * @Description : ExtGridVO class
 * @Modification Information
 *
 * Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 11. 
 * @version 1.0
 * @see
 *  그리드 호출 시 페이징에 사용되는 Count, 그리드에 뿌려주는 Data 등을 관리하는 VO
 *
 */
public class ExtGridVO extends BaseLogger {

	private int totcnt;
	private List<?> data;
	
	public void setTotcnt(int totcnt) {
		this.totcnt = totcnt;
	}

	public int getTotcnt() {
		return this.totcnt;
	}

	public List<?> getData() {
		return data;
	}

	public void setData(List<?> list) {
		this.data = list;
	}
}