<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="albummodel1.CommentDAO" %>
<%@ page import="albummodel1.CommentTO" %>
<%
	request.setCharacterEncoding( "utf-8" );
	
	String cpage = request.getParameter( "cpage" );
	String pseq =  request.getParameter( "pseq" );
	
	CommentTO cto = new CommentTO();
	cto.setPseq( request.getParameter( "pseq" ) );		
	cto.setWriter( request.getParameter( "writer" ) );
	cto.setPassword( request.getParameter( "password" ) );
	cto.setContent( request.getParameter( "content" ) );
	CommentDAO cdao = new CommentDAO();
	int flag = cdao.commentWriteOk( cto );
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('댓글쓰기에 성공했습니다.')" );
		out.println( "location.href='board_view1.jsp?cpage=" + cpage + "&seq=" + pseq + "'" );
	} else {
		out.println( "alert('댓글쓰기에 실패했습니다.')" );
		out.println( "history.back()" );
	}
	out.println( "</script>" );
%>