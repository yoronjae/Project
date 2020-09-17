<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    
<%@ page import="albummodel1.CommentDAO" %>
<%@ page import="albummodel1.CommentTO" %>

<%@ page import="java.util.ArrayList" %>

<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>

<%
	request.setCharacterEncoding( "utf-8" );
	System.out.println("list");
	
	CommentTO commentTo = new CommentTO();
	commentTo.setPseq(request.getParameter( "pseq" ));
	
	CommentDAO cdao = new CommentDAO();
	ArrayList<CommentTO> commentLists = cdao.commentList( commentTo );
	
	
	JSONArray jsonArray = new JSONArray();
	for(CommentTO to: commentLists){
		// 전처리 
		String cseq = to.getSeq();
		String cwriter = to.getWriter();
		String ccontent = to.getContent();
		String cwdate = to.getWdate();
		
		JSONObject obj = new JSONObject();
		obj.put("cseq", cseq);
		obj.put("cwriter", cwriter);
		obj.put("ccontent", ccontent);
		obj.put("cwdate", cwdate);
		
		jsonArray.add(obj);
	}
	
	out.println(jsonArray);
%>