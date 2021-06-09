package kr.co.bps.common.file.impl;

import java.util.List;


import org.springframework.stereotype.Repository;

import com.ibatis.sqlmap.client.SqlMapClient;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;


/**
 * @Class Name : FileDAO.java
 * @Description : Inventory DAO Class
 * @Modification Information
 *
 * @author jslee
 * @since 2012-09-13
 * @version 1.0
 * @see
 *  
 *  Copyright (C)  All right reserved.
 */

@Repository("FileDAO")
public class FileDAO extends EgovAbstractDAO {

	/**
	 * CBOSP_JOP_ORDER_V을 등록한다.
	 * @param vo - 등록할 정보가 담긴 StockSearchVO
	 * @return 등록 결과
	 * @exception Exception
	 */
    public String add(Object obj, String method) throws Exception {
        return (String)insert(method, obj);
    }

    
    public Object getInfo(Object obj, String method) throws Exception {
    	 return (Object) select(method, obj);
    }
    
    public List getList(Object obj, String method) throws Exception {
   	 return list(method, obj);
   }

    public int getListCnt(Object obj, String method) {
        return (Integer) select(method, obj);
    }
    
    public int del(Object obj, String method) throws Exception {
        return delete(method, obj);
    }
    
}
