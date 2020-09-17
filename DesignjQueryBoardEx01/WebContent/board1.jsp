<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="./css/base/jquery-ui.css" />
<style type="text/css">
    body { font-size: 70%; }
     #accordion-resizer {
          margin: 0 60px;
          max-width: 1500px;
     }
     #btngroup1 {
          text-align: right;
     }
     label.header {
          font-size: 10pt;
          margin-right: 5px;
     }

     input.text {
          width: 80%;
          margin-bottom: 12px;
          padding: .4em;
     }

     fieldset {
          margin-left: 15px;
          margin-top: 15px;
          border: 0;
     }
</style>
<script type="text/javascript" src="./js/jquery-3.5.1.js"></script>
<script type="text/javascript" src="./js/jquery-ui.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $('#accordion').accordion({
            heightStyle: 'content'
        });

        $("#writeDialog").css('display', 'none');
        $("#modifyDialog").css('display', 'none');
        $("#deleteDialog").css('display', 'none');

        // 1
        
        $('.action:button').button().on('click', function() {
            if($(this).attr('action') == 'write') {
                $('#writeDialog').dialog({
                    width: 700,
                    height: 500,
                    modal: true,
                    buttons: {
                         "글쓰기": function() {
                        	 var w_subject = $('#w_subject').val();
                        	 var w_writer = $('#w_writer').val();
                        	 var w_mail = $('#w_mail').val();
                        	 var w_password = $('#w_password').val();
                        	 var w_content= $('#w_content').val();
                        	 
                        	 writeServer(w_subject, w_writer, w_mail, w_password, w_content);
                        	 
                        	 $('#w_subject').val('');
                        	 $('#w_writer').val('');
                        	 $('#w_mail').val('');
                        	 $('#w_password').val('');
                        	 $('#w_content').val('');
                        	 
                        	 $(this).dialog('close');
                             
                         },
                         "취소": function() {
                             $(this).dialog('close');
                         }
                    }
                });
            } 
        });
        
        listServer();
    });
    
    // 함수 시작
    var listServer = function(){
    	$.ajax({
    		url:'./data/list_json.jsp',
    		type:'get',
    		dataType:'json',
    		success: function(json) {
				listData(json);
			},
			error: function(error) {
				console.log('[에러]'+error.status);
				console.log('[에러]'+error.responseText);
			}
    	});
    };
    
    var listData = function(data) {
    	// 중복 방지를 위해 empty()
    	$('#accordion').empty();
    	
    	$.each(data, function(index, item) {
			var html = '';
			
			
			// html 엮는 문장
			html += '<h3>'+(index+1)+' '+item.subject+'</h3>';
			html += '<div>';
			html += '	<div style="width: 80%; float: left;">'+item.content+'</div>';
			html += '	<div style="text-align:right; vertical-align:bottom;">';
			html += '		<button idx="'+index+'" seq="'+item.seq+'" action="modify" class="action" >수정</button>';
			html += '		<button idx="'+index+'" seq="'+item.seq+'" action="delete" class="action">삭제</button>';
			html += '	</div>';
			html += '</div>';
			
			$('#accordion').append(html);
			$('#accordion').accordion('refresh');
			
			$('button.action').button().on('click', function() {
				var row = $(this).attr('idx');
				var seq = $(this).attr('seq');
				
				if($(this).attr('action') == 'modify') {
					modifyServer(seq);
					
					$('#modifyDialog').dialog({	                
						width: 700,	                    
						height: 500,	                    
						modal: true,      	                    
						buttons: {	                    
							"글수정": function() {
								
								var m_subject = $('#m_subject').val();
	                        	var m_writer = $('#m_writer').val();
	                        	var m_mail = $('#m_mail').val();
	                        	var m_password = $('#m_password').val();
	                        	var m_content= $('#m_content').val();
								
	                        	modifyData(seq, m_subject, m_writer, m_mail, m_password, m_content);
								
	                        	$(this).dialog('close');
							},
	                        
							"취소": function() {	                        
								$(this).dialog('close');	                           
							}	                    
						}	                
					});
	             
				} else if($(this).attr('action') == 'delete') {	  
					deleteServer(seq);
					
					$('#deleteDialog').dialog({	                
						width: 700,	                    
						height: 200,	                    
						modal: true,	                    
						buttons: {	                      
							"글삭제": function() {	 
								var d_password = $('#d_password').val();
								
								deleteData(seq, d_password);
								
								$('#d_subject').val('');
								$('#d_password').val('');
								
								$(this).dialog('close');	                           
							},
	                           
							"취소": function() {	                        
								$(this).dialog('close');	                           
							}	                    
						}	                
					});	            
				} 	    
			});
	          		
			
		
			
			
			console.log(html);
			
		});
	}
    
    var writeServer = function(w_subject, w_writer, w_mail, w_password, w_content){
    	$.ajax({
            url:'./data/write_json.jsp',
            data: {
            	subject: w_subject,
            	writer: w_writer,
            	mail: w_mail,
            	password: w_password,
            	content: w_content
            },
            type:'get',
            dataType:'json',
            success: function(json) {
              if(json.flag == 0){
            	  
            	  // 성공
            	  alert('글쓰기 성공');
            	  
            	  listServer();
              }
           },
           error: function(error) {
              console.log('[에러]'+error.status);
              console.log('[에러]'+error.responseText);
           }
         });
    }
    
    var deleteServer = function(seq){
    	$.ajax({
			url:'./data/delete_json.jsp?seq='+seq,
			type:'get',
			dataType:'json',
			success: function(json) {
				$('#d_subject').val(json.subject);
			},
			error: function(error) {
				console.log('[에러]'+error.status);
				console.log('[에러]'+error.responseText);b
			}
		});
    }
    
    var deleteData = function(seq, d_password){
    	$.ajax({
    		url:'./data/delete_ok_json.jsp',
    		data:{
    			seq: seq,
    			password: d_password
    		},
			type:'get',
			dataType:'json',
			success: function(json) {
				if(json.flag==0){
					alert('삭제 성공');
					listServer();
				}else{
					alert('삭제 실패');
				}
			},
			error: function(error) {
				console.log('[에러]'+error.status);
				console.log('[에러]'+error.responseText);b
			}
    	});
    };
    
    var modifyServer = function(seq) {
		$.ajax({
			url:'./data/modify_json.jsp',
			data:{
				seq: encodeURIComponent(seq)		
			},
			type:'get',
			dataType:'json',
			success: function(json) {
				var m_subject= json.subject;
				var m_writer= json.writer;
				var m_mail= json.mail;
				var m_password= json.password;
				var m_content= json.content;
				
				$('#m_subject').val(m_subject);
				$('#m_writer').val(m_writer);
				$('#m_mail').val(m_mail);
				$('#m_password').val(m_password);
				$('#m_content').val(m_content);
				
				
			},
			error: function(error) {
				console.log('[에러]'+error.status);
				console.log('[에러]'+error.responseText);b
			}
		});
		
	};
	
	var modifyData= function(seq, m_subject, m_writer, m_mail, m_password, m_content){
		$.ajax({
			url:'./data/modify_ok_json.jsp',
			data:{
				seq: seq,
				subject: m_subject,
				writer: m_writer,
				mail: m_mail,
				password: m_password,
				content: m_content
			},
			type:'get',
			dataType:'json',
			success: function(json){
				if(json.flag==0){
					alert('수정성공');
					listServer();
				}else{
					alert('수정실패');
				}
			},
			error: function(error){
				console.log('[에러]'+error.status);
				console.log('[에러]'+error.responseText);b
			}
		});
	};
</script>
</head>
<body>

<div id="accordion-resizer">
    <div id="btngroup1">
        <button action="write" class="action">글쓰기</button>
    </div>
    <br /><hr /><br />
    <div id="accordion">
    
    <!-- 
        <h3>1 제목 1</h3>
        <div>
            <div style="width: 80%; float: left;">내용</div>
            <div style="text-align:right; vertical-align:bottom;">
                <button seq="1" action="modify" class="action">수정</button>
                <button idx="1" action="delete" class="action">삭제</button>
            </div>
        </div>
        <h3>2 제목 2</h3>
        <div>
            <div style="width: 80%; float: left;">내용</div>
            <div style="text-align:right; vertical-align:bottom;">
                <button seq="2" action="modify" class="action">수정</button>
                <button idx="2" action="delete" class="action">삭제</button>
            </div>
        </div>
    -->
    </div>
</div>

<!-- 글쓰기 -->
<div id="writeDialog" title="글쓰기"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="w_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="w_writer" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="w_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="w_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br />
               <textarea rows="15" cols="100" id="w_content" class="text ui-widget-content ui-corner-all">               </textarea>
          </div>
     </fieldset>
</div>

<div id="modifyDialog" title="글수정"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="m_subject" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="writer" class="header">이&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;름</label>
               <input type="text" id="m_writer" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="mail" class="header">메&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;일</label>
               <input type="text" id="m_mail" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="m_password" class="text ui-widget-content ui-corner-all"/>
          </div>
          <div>
               <label for="content" class="header">본&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;문</label>
               <br/>
               <textarea rows="15" cols="100" id="m_content" class="text ui-widget-content ui-corner-all"></textarea>
          </div>
     </fieldset>
</div>

<div id="deleteDialog" title="글삭제"> 
     <fieldset>
          <div>
               <label for="subject" class="header">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</label>
               <input type="text" id="d_subject" class="text ui-widget-content ui-corner-all" readonly="readonly"/>
          </div>
          <div>
               <label for="password" class="header">비밀&nbsp;번호</label>
               <input type="password" id="d_password" class="text ui-widget-content ui-corner-all"/>
          </div>
     </fieldset>
</div>

</body>
</html>
