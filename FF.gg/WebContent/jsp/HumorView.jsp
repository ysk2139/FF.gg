<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../css/community.css">
<script src="https://code.jquery.com/jquery-2.2.4.js"></script>
<script src='https://kit.fontawesome.com/a076d05399.js'></script>

<script type="text/javascript">
   $(document).ready(
         function() {
            $('#up').click(function() {
               var result = confirm("추천 하시겠습니까?");
               if (result) { //예 눌렀을 경우
                  var num = '${humorboard.num}';
                  $.ajax({
                     type : "POST",
                     url : "Humor_upcheck.do",
                     data : "num=" + num,
                     dataType : "text",
                     success : function(data) {
                        if (data == "true") {
                           location.href = 'Humor_Up.do?num=' + num;
                        } else {
                           alert("게시글 하나당 한번의 추천만 가능합니다.");
                        }
                     },
                     error : function() {
                        alert("실패");
                     }

                  })
               }
            });

            var turn = 1;
            var num = '';
            $(document).on("click", ".cocommentBtn", function() {
               num = $(this).attr('id')
               if (turn == 1) {
            	   $('#ValueInput').val(num)
                  $('.' + num).show()
                  turn = 0;
               } else if (turn == 0) {
                  $('.' + num).hide()
                  turn = 1;
               }

            })

            $('#DelBtn').click(
                  function() {
                     var pwd = $('#DelInput').val();
                     var num = '${humorboard.num}'
                     $.ajax({
                        type : "POST",
                        url : "HashpwdCheck.do",
                        data : "pwd=" + pwd,
                        dataType : "text",
                        success : function(data) {
                           if (data == "true") {

                              location.href = 'Humor_delete.do?num='
                                    + num + '&password=' + pwd
                           } else {
                              alert("비밀번호가 일치하지 않습니다.")
                           }
                        },
                        error : function() {
                           alert("실패");
                        }

                     })
                  })
               $('#adminUpBtn').click(function(){
            	  var num = '${humorboard.num}';
            	  locaiton.href='adminHumorBoardUpdateForm.do?='+num
              })
              
              $('.commentbtn').click(function() {
					if ($('.comment').val().length === 0)
						alert('댓글을 입력해주세요.');
					
					else if ($('.comment').val().length > 200)
						alert('200자를 넘기실 수 없습니다.');
					
					else {
						$('#comment_form').submit();
					}
	          })
	          
	          $(document).on("click", ".cocobtn", function(){
				if ($(this).parent().parent().find('textarea').val().length === 0){
					alert('댓글을 입력해주세요.');					
				}
				else if($(this).parent().parent().find('textarea').val().length > 200){
					alert('200자를 넘기실 수 없습니다.');					
				}
				else {
					$('#cocomment_form'+num).submit();
				}
				})

         });
</script>

<style>
.wrap {
	margin-top: 100px;
}

#centerwrapper {
    float: right;
    margin-bottom: 100px;
}
</style>

</head>

<body class="default">
   <div id="wrapper" class="sub">
      <header id="header" class="after_1102">
         <jsp:include page="header.jsp" />
      </header>
      <main id="middle" class="sub">
      <div class="wrap">
         <div class="leftdiv">
            <div id="logindiv">
               <c:if test="${result == 2}">
                  <jsp:include page="NotLogin.jsp"></jsp:include>
               </c:if>
               <c:if test="${result == 1}">
                  <jsp:include page="Login.jsp"></jsp:include>
               </c:if>
            </div>
            <div id="categorydiv">
               <div class="CategoryDiv" onclick="location.href='Humor_Main.do'">-
                  유머 게시판</div>
               <br>
               <div class="CategoryDiv" onclick="location.href='Tip_Main.do'">-
                  팁 게시판</div>
               <br>
               <div class="CategoryDiv" onclick="location.href='Report_Main.do'">-
                  신고 게시판</div>
               <br>
               <div class="CategoryDiv" onclick="location.href='Chat.do'">-
                  나랑 할사람</div>
            </div>
         </div>
         <div id="centerwrapper">
            <table id=humorviewtab>
               <tr>
                  <td id="humorviewtabTitletd" style="height:37px;">${humorboard.title }</td>
               </tr>
               <tr>
                  <td style="float: left;">${humorboard.name}&nbsp;|&nbsp;</td>
                  <td style="float: left;"><fmt:formatDate
                        value="${humorboard.writedate }" pattern="yyyy-MM-dd" />
                     &nbsp;|&nbsp;</td>
                  <td style="float: left;">유머게시판</td>

                  <td style="float: right;">조회수:${humorboard.readCount }&nbsp;</td>
                  <td style="float: right;">번 호:${humorboard.num }&nbsp;|&nbsp;</td>
                  <td style="float: right;">추천수:${humorboard.up }&nbsp;|&nbsp;</td>
               </tr>
               <tr>
                  <td id="humorviewtabContentTd" style="height: 800px; font-size: 20px;">
                     ${humorboard.content }</td>
               </tr>
               <tr>
                  <td align="center" colspan="7" style="float: right;">
                     <div class="choice">
                    	<h6>글 추천하기</h6><i class="fas fa-thumbs-up" id="up" style="font-size:36px; cursor:pointer;" aria-hidden="true"></i>
                     </div>
                  </td>
               </tr>
            </table>
            <div id="select">
               <div class="replyview">
                  <table id="hcommentTable">
                     <c:forEach items="${hcomment }" var="h">
                     
                     
                        <form action="Humor_cocomment.do" id="cocomment_form${h.num }">
                           <tr id="${h.id }">
                              <td>${h.id }:</td>
                              <td style="width: 900px">${h.content }</td>
                              <td width="30px"></td>
                              <c:if test="${h.id == userid or userid == 'admin'}">
                                 <td><div class="replybtn"
                                       onclick="location.href='Humor_commentdel.do?num=${h.num }&boardnum=${humorboard.num }'">삭제</div></td>
                              </c:if>
                              <td width="10px"></td>
                              <td><div class="cocommentBtn" id="${h.num }">답글</div></td>
                           </tr>
                           
                           <tr style="display: none;" class="${h.num }">
                              <td colspan="2"><textarea name="content" id="cocoText"></textarea></td>
                              <td colspan="2"><input class="cocobtn" type="button" id="cocomment_form" value="확인"></td>
                           </tr>

                           <c:forEach items="${hcocomment }" var="hc">
                              <c:if test="${hc.humorboardNum == h.boardnum}">
                                 <c:if test="${hc.commentNum == h.num }">
                                    <tr style="width: 30px"></tr>
                                    <tr>
                                       <td>&nbsp;&nbsp;&nbsp;└${hc.userid}: </td>
                                       <td>${hc.content }</td>

                                       <c:if test="${hc.userid == userid or userid == 'admin'}">
                                          <td colspan="2"><div
                                               class="cocommentBtn" onclick="location.href='Humor_cocommentdelete.do?num=${hc.cocommentNum }&boardnum=${humorboard.num }'">삭제</div></td>

                                       </c:if>
                                    </tr>

                                 </c:if>
                              </c:if>
                           </c:forEach>
                           <tr height="3px"></tr>
                           <input type="hidden" name="humorboardNum" value="${humorboard.num}">
                           <input id="ValueInput" type="hidden" name="commentNum" value="${h.num}">
                        </form>
                        
                        
                        
                     </c:forEach>
                  </table>
               </div>
               <div class="reply">
                  <form id="comment_form" action="Humor_comment.do?num=${humorboard.num }" method="post" >
                     <textarea class="comment" name="text" placeholder="댓글 입력"></textarea>
                     <input type="button" value="댓글" class="commentbtn"
                        style="float: right">
                  </form>
               </div>


               <c:if test="${humorboard.name == userid && userid != 'admin'}">
                  <table class="choicetab" id="choiceTable">
                     <tr>
                        <td><input type="button" value="수정" class="choicebtn"
                           onclick="location.href='Humor_updateForm.do?num=${humorboard.num}'">
                           &nbsp;|&nbsp;</td>
                        <td><input type="button" value="목록보기"
                           onclick="location.href='Humor_Main.do'" class="choicebtn">
                           &nbsp;|&nbsp;</td>
                        <td><c:if test="${num == 1}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Main.do'" class="choicebtn">
                           </c:if> <c:if test="${num == 2}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Community_main.do'" class="choicebtn">
                           </c:if> <c:if test="${num == 3}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Humor_Main.do${hstring}'"
                                 class="choicebtn">
                           </c:if></td>
                     </tr>
                  </table>
                  <div align="center">
						비밀번호 : 
						<input id="DelInput" style="border: 1px black solid;" type="password" name="password" class="choicebtn">
						<input id="DelBtn" type="submit" value="삭제 " class="choicebtn">
					</div>
               </c:if>
               
               <c:if test="${userid == 'admin' }">
                  <table style="margin-left: auto; margin-right: auto;"
                     class="choicetab" id="choiceTable">
                     <tr>
                     	<td><input type="button" value="삭제" class="choicebtn"
                           onclick="location.href='adminHumorBoardDelete.do?num=${humorboard.num}'">
                           &nbsp;|&nbsp;</td>
                        <td><input type="button" value="수정" class="choicebtn"
                           onclick="location.href='adminHumorBoardUpdateForm.do?num=${humorboard.num}'">
                           &nbsp;|&nbsp;</td>
                        <td><input type="button" value="목록보기"
                           onclick="location.href='Humor_Main.do'" class="choicebtn">
                           &nbsp;|&nbsp;</td>
                        <td><c:if test="${num == 1}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Main.do'" class="choicebtn">
                           </c:if> <c:if test="${num == 2}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Community_main.do'" class="choicebtn">
                           </c:if> <c:if test="${num == 3}">
                              <input type="button" value="뒤로가기"
                                 onclick="location.href='Humor_Main.do${hstring}'"
                                 class="choicebtn">
                           </c:if></td>
                     </tr>
                  </table>
               </c:if>

               <c:if test="${humorboard.name != userid && userid != 'admin'}">

                  <div class="choice1">
                     <input type="button" value="목록보기"
                        onclick="location.href='Humor_Main.do'" class="choicebtn">
                     &nbsp; &nbsp; 
                     <c:if test="${num == 1}">
                        <input type="button" value="뒤로가기"
                           onclick="location.href='Main.do'" class="choicebtn">
                     </c:if>
                     <c:if test="${num == 2}">
                        <input type="button" value="뒤로가기"
                           onclick="location.href='Community_main.do'" class="choicebtn">
                     </c:if>
                     <c:if test="${num == 3}">
                        <input type="button" value="뒤로가기"
                           onclick="location.href='Humor_Main.do${hstring}'"
                           class="choicebtn">
                     </c:if>
                  </div>
               </c:if>
            </div>
         </div>
      </div>
      </main>
      <footer id="footer" role="contentinfo">
         <jsp:include page="footer.jsp" />
      </footer>
   </div>
</body>
</html>