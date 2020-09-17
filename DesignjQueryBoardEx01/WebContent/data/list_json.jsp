<%@page import="java.util.ArrayList"%>
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
	System.out.println("list_json");

	BoardDAO dao = new BoardDAO();
	ArrayList<BoardTO> lists = dao.BoardList();
	
	JSONArray jsonArray = new JSONArray();
	for(BoardTO to : lists){
		String seq = to.getSeq();
		String subject = to.getSubject();
		String writer = to.getWriter();
		String mail = to.getMail();
		String content = to.getContent();
		
		JSONObject obj = new JSONObject();
		obj.put("seq", seq);
		obj.put("subject", subject);
		obj.put("writer", writer);
		obj.put("mail", mail);
		obj.put("content", content);
		
		jsonArray.add(obj);
	}
	
	out.println(jsonArray);

%>