package kr.co.bps.common;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.naming.InitialContext;


public class JDBCInputSource 
{
    private static JDBCInputSource m_source = new JDBCInputSource();
    
    private boolean m_init;
    private String m_connectionURL;
    private String m_userName;
    private String m_passwd;
    private boolean lookup;
    private javax.sql.DataSource ds;
    
    int connCount = 0;
    int poolConnCount = 0;

    private JDBCInputSource() 
    {
    	init();
    }

    private void init()
    {
    	if (!m_init) {
	        try {
	            lookup = true;
	
	            //String driver = "";
	            if (lookup) {
	            	
	                InitialContext ctx = new InitialContext();
	                
	                ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/CBHRW");
//	                ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/THINT");
//	                ds = (javax.sql.DataSource) ctx.lookup("java:comp/env/jdbc/CBPOS");

	                ctx.close();
	                //driver = "java:comp/env/jdbc/nms";
	            } else {
	            	//driver = Property.get("db.driver");
	                //Class.forName(driver).newInstance();
	                //m_connectionURL = Property.get("db.url");
	                //m_userName = Property.get("db.user");
	                //m_passwd = Property.get("db.password");
	            }
	            m_init = true;
	            
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }
    	}
    }

    /**
    * 생성자에 입력된 정보를 바탕으로 데이터베이스에 대한 Connection 리턴한다. (Connection Pool 사용시 )
    *
    * @return 생성자에서 입력된정보를 바탕으로한 Connection
    * @exception SQLException JDBC Driver와 <code>DriverManager</code>에서
    * Connection을 얻는과정에서 발생하는 오류
    */
    private Connection getGeneralConnection() throws SQLException {
    	
        return DriverManager.getConnection(m_connectionURL, m_userName, m_passwd);
    }

    private Connection getPoolConnection() throws SQLException {
    	
    	if (ds != null) 
        {
            return ds.getConnection();
        }
        
        throw new SQLException("Datasource not initialized");
    }
    
    public Connection getConnection() throws SQLException 
	{
        if (!m_init) 
        {
            throw new SQLException("not initialized");
        }
        
        
        Connection con = null;
        if (lookup) {
            con = getPoolConnection();
        } else {
            con = getGeneralConnection();
        }
        
        //return new ConnectionWrapper(con);
        return con;
    }

    public static JDBCInputSource getInstance() 
    {
    	
    	return m_source;
    }
}
