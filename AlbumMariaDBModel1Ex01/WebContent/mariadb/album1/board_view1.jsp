<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="albummodel1.BoardDAO" %>
<%@ page import="albummodel1.BoardTO" %>
<%@ page import="albummodel1.CommentDAO" %>
<%@ page import="albummodel1.CommentTO" %>

<%@ page import="java.util.ArrayList" %>
<%
	request.setCharacterEncoding( "utf-8" );

	String cpage = request.getParameter( "cpage" );
	
	BoardTO to = new BoardTO();
	to.setSeq( request.getParameter( "seq" ) );
	
	BoardDAO dao = new BoardDAO();
	to = dao.boardView( to );
	
	String seq = to.getSeq();
	String subject = to.getSubject();
	String writer = to.getWriter();
	String mail = to.getMail();
	String wip = to.getWip();
	String wdate = to.getWdate();
	String hit = to.getHit();
	String content = to.getContent();
	String filename = to.getFilename();
	
	CommentTO commentTo = new CommentTO();
	commentTo.setPseq(request.getParameter("seq"));
	
	CommentDAO cdao = new CommentDAO();
	ArrayList<CommentTO> commentLists = cdao.commentList( commentTo );
	
	StringBuffer sbHtml = new StringBuffer();
	
	sbHtml.append("<table>");
	for( CommentTO cto : commentLists ) {
		String cseq = cto.getSeq();
		String cwriter = cto.getWriter();
		String ccontent = cto.getContent();
		String cwdate = cto.getWdate();
			
		sbHtml.append( "<tr>" );
		sbHtml.append( "<td class='coment_re'>" );
		sbHtml.append( "	<strong>" + cwriter + "</strong> (" + cwdate + ")" );
		sbHtml.append( "	<div class='coment_re_txt'>" );
		sbHtml.append( ccontent );
		sbHtml.append( "	</div>" );
		sbHtml.append( "</td>" );
		sbHtml.append( "</tr>" );
	}
	sbHtml.append("</table>");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/board_view.css">
<script type="text/javascript">
	window.onload = function() {
		document.getElementById('commentsubmit').onclick = function() {
			if(document.commentfrm.writer.value.trim() == "") {
				alert('이름을 입력하셔야 합니다.');
				return false;				
			}
			if(document.commentfrm.password.value.trim() == "") {
				alert('비밀번호를 입력하셔야 합니다.');
				return false;				
			}
			if(document.commentfrm.content.value.trim() == "") {
				alert('내용을 입력하셔야 합니다.');
				return false;				
			}
			
			// 댓글 쓰기
			writeServer(
					document.commentfrm.writer.value.trim(),
					document.commentfrm.password.value.trim(),
					document.commentfrm.content.value.trim()
					);
		};
		
		var readServer = function(){
			var request = new XMLHttpRequest();
	
            request.onreadystatechange=function(){              	
            	if(request.readyState==4){                
            		if(request.status == 200){ 
            			var data = request.responseText.trim();
            			var json = eval('('+data+')');
            			
            			console.log(json);
            			
            			var result ='<table>';
        				for(var i = 0; i<json.length; i++){
        					result += '<tr>';
        					result += '<td class="coment_re">';
        					result += '	<strong>'+json[i].cwriter+'</strong> ('+json[i].cwdate+')';
        					result += '	<div class="coment_re_txt">';
        					result += json[i].ccontent;
        					result += '	</div>';
        					result += '</td>';
        					result += '</tr>';
        					
        				}
        				result += '</table>';
        				console.log(result);
        				
        				document.getElementById('result').innerHTML = result;
        				
        				document.commentfrm.writer.value = '';
    					document.commentfrm.password.value = '';
    					document.commentfrm.content.value = '';
	   
            		}else{                     
            			alert('페이지를 찾을 수 없습니다.');                
            		}           
            	}              	
            };
            	var url = './comment_list1_ok_json.jsp?pseq=<%=seq%>';                     
                request.open('get', url ,true);
                request.send(); 
		};
		
		var writeServer = function(writer, password, content){
			var request = new XMLHttpRequest();	
						
            request.onreadystatechange=function(){              	
            	if(request.readyState==4){                
            		if(request.status == 200){ 
            			var data = request.responseText.trim();
            			var json = eval('('+data+')');          			
            			            			
            			if(json.flag == 0){
            				alert('댓글 입력을 성공했습니다.');	
            				
            				// 다시 리스트 읽기
            				readServer();
            			} else {
            				alert('댓글 입력을 실패했습니다.');
            			}
            		}
            		else{                     
            			alert('페이지를 찾을 수 없습니다.');                
            		}               		        
            	}              	
            };
            	
            var url = './comment_write1_ok_json.jsp?pseq=<%=seq%>';                
            url += '&writer='+encodeURIComponent(writer);                
            url += '&password='+ password;                
            url += '&content='+encodeURIComponent(content);               
                
            request.open('get', url ,true);               
            request.send();       
		};		
	};
</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="contents1"> 
	<div class="con_title"> 
		<p style="margin: 0px; text-align: right">
			<img style="vertical-align: middle" alt="" src="../../images/home_icon.gif" /> &gt; 커뮤니티 &gt; <strong>여행지리뷰</strong>
		</p>
	</div>

	<div class="contents_sub">	
	<!--게시판-->
		<div class="board_view">
			<table>
			<tr>
				<th width="10%">제목</th>
				<td width="60%"><%=subject %></td>
				<th width="10%">등록일</th>
				<td width="20%"><%=wdate %></td>
			</tr>
			<tr>
				<th>글쓴이</th>
				<td><%=writer %></td>
				<th>조회</th>
				<td><%=hit %></td>
			</tr>
			<tr>
				<td colspan="4" height="200" valign="top" style="padding:20px; line-height:160%">
					<div id="bbs_file_wrap">
						<div>
							<img src="../../upload/<%=filename %>" width="900" onerror="" /><br />
						</div>
					</div>
					<%=content %>
				</td>
			</tr>			
			</table>
			
			<div id='result'><%=sbHtml %></div>
			
		<form action="comment_write1_ok.jsp" method="post" name="commentfrm">				
			<table>
			<tr>
				<td width="94%" class="coment_re">
					글쓴이 <input type="text" name="writer" maxlength="5" class="coment_input" />&nbsp;&nbsp;
					비밀번호 <input type="password" name="password" class="coment_input pR10" />&nbsp;&nbsp;
				</td>
				<td width="6%" class="bg01"></td>
			</tr>
			<tr>
				<td class="bg01">
					<textarea name="content" cols="" rows="" class="coment_input_text"></textarea>
				</td>
				<td align="right" class="bg01">
					<input type="button" value="댓글등록" id="commentsubmit" class="btn_comment_write btn_txt01" />
				</td>
			</tr>
			</table>
		</form>
	</div>

		<div class="btn_area">
			<div class="align_left">			
				<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp?cpage=<%=cpage %>'" />
			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_modify1.jsp?cpage=<%=cpage %>&seq=<%=seq %>'" />
				<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_delete1.jsp?cpage=<%=cpage %>&seq=<%=seq %>'" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp?cpage=<%=cpage %>'" />
			</div>	
		</div>
			<!--//게시판-->
	</div>
	<!-- 하단 디자인 -->
</div>
</body>
</html>