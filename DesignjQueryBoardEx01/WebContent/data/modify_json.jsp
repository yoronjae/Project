<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ page import="javax.naming.InitialContext" %>
<%@page import="javax.naming.Context"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%
	System.out.println("modify_json");

	request.setCharacterEncoding("utf-8");
	
	BoardTO bto = new BoardTO();
	bto.setSeq(request.getParameter("seq"));
	//bto.setSeq("4");
	
	BoardDAO dao = new BoardDAO();
	BoardTO to = dao.boardModify(bto);
	
	JSONObject result = new JSONObject();
	result.put("subject", to.getSubject());
	result.put("writer", to.getWriter());
	result.put("mail", to.getMail());
	result.put("password", to.getPassword());
	result.put("content", to.getContent());
		
	out.println(result);
%>