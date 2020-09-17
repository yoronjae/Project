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
	System.out.println("write_json");
	request.setCharacterEncoding("utf-8");

	BoardTO to = new BoardTO();
	to.setSubject(request.getParameter("subject"));
	to.setWriter(request.getParameter("writer"));
	to.setMail(request.getParameter("mail"));
	to.setPassword(request.getParameter("password"));
	to.setContent(request.getParameter("content"));
	
	BoardDAO dao = new BoardDAO();
	int flag = dao.WriteOk(to);
	
	JSONObject result = new JSONObject();
	result.put("flag", flag);
	
	out.println(result);
%>