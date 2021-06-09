<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
down
</body>
</html>
<%-- 
<%@ page contentType="application;" %><%@ page import="java.util.*,java.io.*,java.sql.*,java.text.*"%><% 
String filename = java.net.URLDecoder.decode(request.getParameter("file")); 
String filename2 = new String(filename.getBytes("euc-kr"),"8859_1"); 
File file = new File("c:/jsphome/"+filename); // 절대경로입니다. 
byte b[] = new byte[(int)file.length()]; 
response.setHeader("Content-Disposition", "attachment;filename=" + filename2 + ";"); 
if (file.isFile()) 
{ 
BufferedInputStream fin = new BufferedInputStream(new FileInputStream(file)); 
BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream()); 
int read = 0; 
while ((read = fin.read(b)) != -1){ 
outs.write(b,0,read); 
} 
outs.close(); 
fin.close(); 
} 
%>  --%>