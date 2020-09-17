<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="albummodel1.BoardDAO" %>
<%@ page import="albummodel1.BoardTO" %>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.File" %>

<%
	String uploadPath = "D:/eclipse-java-2020-06-R-win32-x86_64/ajax-workspace/AlbumMariaDBModel1Ex01/WebContent/upload/";
	int maxFileSize = 1024 * 1024 * 10;
	String encType = "utf-8";

	MultipartRequest multi = new MultipartRequest( request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy() );

	String cpage = multi.getParameter( "cpage" );
	String seq = multi.getParameter( "seq" );
	
	BoardTO to = new BoardTO();
	to.setSeq( multi.getParameter( "seq" ) );
	to.setPassword( multi.getParameter( "password" ) );
	to.setSubject( multi.getParameter( "subject" ) );
	to.setMail( "" );
	if( !multi.getParameter( "mail1" ).equals("") && !multi.getParameter( "mail2" ).equals( "" ) ) {
		to.setMail( multi.getParameter( "mail1" ) + "@" + multi.getParameter( "mail2" ) );	
	}
	to.setContent( multi.getParameter( "content" ) );
	
	to.setFilename( "" );
	if( multi.getFile( "upload" ) != null ) {
		to.setFilename( multi.getFilesystemName( "upload" ) );
		to.setFilesize( multi.getFile( "upload" ).length() );
	}
	
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardModifyOk( to );
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert('글수정에 성공했습니다.')" );
		out.println( "location.href='board_view1.jsp?cpage=" + cpage + "&seq=" + seq + "'" );
	} else if( flag == 1 ) {
		out.println( "alert('비밀번호가 틀립니다.')" );
		out.println( "history.back()" );
	} else {
		out.println( "alert('글수정에 실패했습니다.')" );
		out.println( "history.back()" );	
	}
	out.println( "</script>" );
%>    