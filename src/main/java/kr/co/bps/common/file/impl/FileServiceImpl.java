package kr.co.bps.common.file.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import kr.co.bps.common.file.service.FileService;
import kr.co.bps.common.file.impl.FileDAO;

/**
 * @Class Name : JobOrderServiceImpl.java
 * @Description : JobOrder Business Implement class
 * @Modification Information
 *
 * @author jslee
 * @since 2012-09-13
 * @version 1.0
 * @see
 *  
 *  Copyright (C)  All right reserved.
 */

@Service("FileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements  FileService {

    @Resource(name="FileDAO")
    private FileDAO FileDAO;    
   
    public String add(Object vo, String method) throws Exception {
    	FileDAO.add(vo, method);
    	//TODO 해당 테이블 정보에 맞게 수정    	
        return null;
    }
    
    public int del(Object vo, String method) throws Exception {    	
        return FileDAO.del(vo, method);
    }
    

    public Object getInfo(Object searchVO, String method) throws Exception {
        return FileDAO.getInfo(searchVO, method);
    }
    
    public List getList(Object obj, String method) throws Exception {
        return FileDAO.getList(obj, method);
    }
    
    public List getListV(Object obj, String method) throws Exception {
    	FileDAO.add(obj, "returnWarehouseDAO.alterSession");
    	
    	return FileDAO.getList(obj, method);
    }
    
    public int getListCnt(Object obj, String method) {
		return (Integer)FileDAO.getListCnt(obj, method);
	}
    
    
}
