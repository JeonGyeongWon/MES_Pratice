package kr.co.bps.scs.base.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
/**
 * @ClassName : BaseDAO.java
 * @Description : BaseDAO class
 * @Modification Information
 *
 * Copyright (C)SBIT All right reserved.
 * @author ymha
 * @since 2015. 11. 
 * @version 1.0
 * @see
 *  Hibernate & iBatis 사용 가능 클래스
 *
 */
@Repository("BaseDAO")
public class BaseDAO  extends EgovAbstractDAO {
	
	protected final Logger LOGGER = LoggerFactory.getLogger(getClass());

	@Autowired
	@Resource(name="sessionFactoryHibernate")
    protected SessionFactory sessionFactory;

    public Session getSessionByHibernate(){
        return sessionFactory.getCurrentSession();
    }
    
    protected Session getCurrentSession(){
        return sessionFactory.getCurrentSession();
    }
    
    public Criteria getCriteria(Class<?> persistentClass) {
    	return getCriteria(persistentClass, persistentClass.getSimpleName());
	}
    
    public Criteria getCriteria(String entityName) {
    	return getSessionByHibernate().createCriteria(entityName);
    }
    
    public Criteria getCriteria(Class<?> persistentClass, String alias) {
    	return getSessionByHibernate().createCriteria(persistentClass, alias);
    }
    
    public Criteria getCriteria(String entityName, String alias) {
    	return getSessionByHibernate().createCriteria(entityName, alias);
    }
    
    public Object insertByIbatis(String queryId) {
    	return super.insert(queryId);
    }
    
    public Object insertByIbatis(String queryId, Object params) {
    	return super.insert(queryId, params);
    }
    
    public List<Object> insertListByIbatis(String queryId, List<Object> list) {
    	List<Object> result = new ArrayList<Object>();
    	for(Object params: list){
    		Object ret = super.insert(queryId, params);
    		result.add(ret != null ? ret:"success");
    	}
    	return result;
    }
    
    public int updateByIbatis(String queryId) {
    	return super.update(queryId);
    }
    
    public int updateByIbatis(String queryId, Object params) {
    	return super.update(queryId, params);
    }
    
    public int updateListByIbatis(String queryId, List<Object> list) {
    	int cnt = 0;
    	for(Object params: list){
    		cnt += super.update(queryId, params);
    	}
    	return cnt;
    }
    
    public void updateByIbatis(String queryId, Object params, int requiredRowsAffected) {
    	super.update(queryId, params, requiredRowsAffected);
    }
    
    public int deleteByIbatis(String queryId) {
    	return super.delete(queryId);
    }
    
    public int deleteByIbatis(String queryId, Object params) {
    	return super.delete(queryId, params);
    }
        
    public int deleteListByIbatis(String queryId, List<Object> list) {
    	int cnt = 0;
    	for(Object params: list){
    		cnt += super.delete(queryId, params);
    	}
    	return cnt;
    }
    
    public void deleteByIbatis(String queryId, Object params, int requiredRowsAffected) {
    	super.delete(queryId, params, requiredRowsAffected);
    }
    
    public Object selectByIbatis(String queryId) {
    	return super.select(queryId);
    }
    
    public Object selectByIbatis(String queryId, Object params) {
        return super.select(queryId, params);
    }
    
    public Object selectByIbatis(String queryId, Object params, final Object resultObject) {
    	return super.select(queryId, params, resultObject);
    }
    
    public List<?> selectListByIbatis(String queryId) {
    	return super.list(queryId);
    }
    
    public List<?> selectListByIbatis(String queryId, Object params) {
    	return super.list(queryId, params);
    }
    
    public List<?> selectListByIbatis(String queryId, int skipResults, int maxResults) {
    	return super.list(queryId, skipResults, maxResults);
    }
    
    public List<?> selectListByIbatis(String queryId, final Object params, int skipResults, int maxResults) {
    	return super.list(queryId, params, skipResults, maxResults);
    }
    
    public List<?> selectListWithPaging(String queryId, Object params, int pageIndex, int pageSize) {
    	return super.listWithPaging(queryId, params, pageIndex, pageSize);
    }
    
    public Map<?,?> selectMap(final String queryId, final Object params) {
    	return (Map<?,?>)selectByIbatis(queryId, params);
    }
    
    public Map<?,?> selectMap(final String queryId, final Object params, final String keyProperty) {
    	return super.map(queryId, params, keyProperty);
    }
    
    public Map<?,?> selectMap(final String queryId, final Object params, final String keyProperty, final String valueProperty) {
    	return super.map(queryId, params, keyProperty, valueProperty);
    }   
}