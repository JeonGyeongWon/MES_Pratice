package kr.co.bps.common.file.service;

import java.util.List;
/**
 * @Class Name : JobOrderService.java
 * @Description : JobOrder Business class
 * @Modification Information
 *
 * @author jslee
 * @since 2012-09-13
 * @version 1.0
 * @see
 *  
 *  Copyright (C)  All right reserved.
 */
public interface FileService {
	
    String add(Object vo, String method) throws Exception;
    
    Object getInfo(Object obj, String method) throws Exception;
    
    List getList(Object obj, String method) throws Exception;
    
    List getListV(Object obj, String method) throws Exception;
    
    int getListCnt(Object obj, String method);
    
    int del(Object vo, String method) throws Exception;
    
}
