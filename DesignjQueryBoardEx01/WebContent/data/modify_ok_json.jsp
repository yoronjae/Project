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
	request.setCharacterEncoding("utf-8");
	System.out.println("modify_ok_json");
	System.out.println(request.getParameter("writer"));
	
	BoardTO to = new BoardTO();
	to.setSeq(request.getParameter("seq"));
	to.setSubject(request.getParameter("subject"));
	to.setWriter(request.getParameter("writer"));
	to.setMail(request.getParameter("mail"));
	to.setPassword(request.getParameter("password"));
	to.setContent(request.getParameter("content"));
	
	/*
	to.setSeq("4");
	to.setSubject("제목2");
	to.setWriter("글쓴이2");
	to.setMail("test2@test.com");
	to.setPassword("123");
	to.setContent("내용2");
	*/
	
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardModifyOk(to);

	JSONObject result = new JSONObject();
	
	result.put("flag", flag);
	
	out.println(result);
%>