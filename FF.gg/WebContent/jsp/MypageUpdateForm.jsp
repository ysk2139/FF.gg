<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="../css/community.css">

<script src="https://code.jquery.com/jquery-2.2.4.js"
	integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI="
	crossorigin="anonymous"></script>
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<link rel="stylesheet" href="../css/community.css">
<script src="https://code.jquery.com/jquery-2.2.4.js"></script>

<link
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"
	rel="stylesheet" type="text/css" />
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/jquery-validation@1.17.0/dist/jquery.validate.min.js"></script>

<style>
input.form-control {
	display: block !important;
	width: 100% !important;
	height: calc(1.5em + .75rem + 2px) !important;
	padding: .375rem .75rem !important;
	font-size: 1rem !important;
	font-weight: 400 !important;
	line-height: 1.5 !important;
	color: #495057 !important;
	background-color: #fff !important;
	background-clip: padding-box !important;
	border: 1px solid #ced4da !important;
	border-radius: .25rem !important;
	transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out !important;
	position: relative !important;
	-ms-flex: 1 1 auto !important;
	flex: 1 1 auto !important;
	width: 1% !important;
	margin-bottom: 0 !important;
	border-top-right-radius: 0 !important;
	border-bottom-right-radius: 0 !important;
	-webkit-box-sizing: border-box !important;
}

.login-text {
	margin-top: -6px;
	margin-left: -6px
}

.pointer-events {
	pointer-events: auto
}

.input-field>.material-icons {
	padding-top: 10px;
}

/* 여기서부터 새로 함 */

.login-form {
	width: 500px;
	margin: auto;
}

div#centerwrapper {
    margin-top: 100px;
}

.row .col.s12 {
	width: 500px;
}

.input-field.col.s12.center h4 {
	font-size: 40px;
	font-weight: 600;
}

</style>

<script type="text/javascript">
	$(document).ready(function() {
		var userName = "${member.name}"
		var userId = "${member.id}"
		var userPoint = '${member.point}'
		var userEmail = '${member.email}'

		$('#name').val(userName)
		$('#id').val(userId).attr("readonly", true)
		$('#point').val(userPoint).attr("readonly", true)
		$('#email').val(userEmail)
		
		var check = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/; //이메일 형식 체크
		var pwdcheck = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,}$/; // 비밀번호 조건문 : 영문,숫자,특문포함, 6글자 이상
		var id = $('#id');
		var pwd = $('#pwd');
		var pwd_check = $('#pwd_check');
		var getauth = $('#getauth'); //인증 번호 받기 버튼
		var email = $('#email');
		var name = $('#name');
		var idCheck = false;
        var pwdCheck = false;
        var emailCheck = false;
        var emailAuth = false;
        var userauthnum = $('#userauthnum'); //인증 번호 text
        var authnum;
        
        $('#pwd_check').blur(function() { //비번 확인용
	         $.ajax({
	            type : "POST",
	            url : "Pwdcheck.do",
	            data : "pwd=" + pwd.val() + '&pwd_check=' + pwd_check.val(),
	            dataType : "text",
	            success : function(data) {
	               if (pwd.val() != ""  && data == "true") {
	                  if(pwdcheck.test(pwd.val())){
	                     $('#pwdok').html("비밀번호 일치");
	                     pwdCheck = true;                     
	                  }else{
	                     $('#pwdok').html("영문,숫자,특문포함, 6글자 이상 입력하세요");
	                  }
	               }else if(pwd.val() == "" || pwd_check.val() == ""){
	                  $('#pwdok').html("");
	               }
	               else {
	                  $('#pwdok').html("비밀번호 불일치");
	                   pwdCheck = false;
	               }
	            },
	            error : function(xhrReq, status, error) {
	               console.log(xhrReq + " ," + status + " ," + error);
	            }
	
	         })
	      });
		
		
		$('#email').blur(function() { //이메일 확인용
	        $.ajax({
	           type : "POST",
	             url : "Emailcheck.do",
	             data : "email=" + email.val(),
	             dataType : "text",
	             success : function(data) {
	                if (data == "true") {
	                   
	                   if(check.test(email.val())){ //이메일 형식 맞을 시
	                     $('#emailok').html("이메일 사용가능");
	                   	 if(userEmail == email.val()){
	                   		 emailAuth = true;
	                   	 }
	                     emailCheck = true;
	                   }
	                   else{ //이메일 형식 아닐 시 
	                      
	                         $('#emailok').html("잘못된 이메일 형식");
	                         emailCheck = false;    
	                   }
	                }
	                else{
	                   $('#emailok').html("이메일 중복");
	                   emailCheck = false;
	                }
	             },
	             error : function(xhrReq, status, error) {
	                alert(xhrReq + " ," + status + " ," + error);
	             }
	        })
	        
	      });
		
		$('#getauth').click(function() { //인증번호 받기
			if (emailCheck) { //이메일 형식 맞을 시
				$.ajax({
					type : "POST",
					url : "Getauth.do",
					data : "email=" + email.val(),
					dataType : "text",
					success : function(data) {
						alert("인증번호 발송 완료");
						$('#authcheck').show();
						authnum = data; //받아온 인증 번호 저장
					},
					error : function(xhrReq, status, error) {
						alert(xhrReq + " ," + status + " ," + error);
					}
				})
			} else { //이메일 형식 아닐 시 
				alert("잘못된 이메일 형식")
				$('#emailok').html("잘못된 이메일 형식");
				$('#email').focus();
			}
		});
		$('#auth').click(function() { //인증 버튼
			$.ajax({
				type : "POST",
				url : "AuthnumCheck.do",
				data : "authnum=" + authnum + "&userauthnum="+userauthnum.val(),
				dataType : "text",
				success : function(data) {
					if (data == "false") {
						$('#resultview').text("인증번호가 일치하지 않습니다.");
					} else {
						$('#resultview').text("인증되었습니다.");
						emailAuth = true;
					}
				},
				error : function(xhrReq, status, error) {
					alert(xhrReq + " ," + status + " ," + error);
				}
			})
		});
		
		$('#udtBtn').click(function(){
	         if(id.val() == "" || pwd.val() == "" || pwd_check.val() == "" ||
	          email.val() == "" || name.val() == ""){
	            alert("공백을 확인해 주세요")
	            
	         }else if(pwdCheck == false){
	            alert("패스워드 형식 또는 중복여부  확인")
	         }else if(emailCheck == false){
	            alert("이메일 형식 확인")
	         }else if($('#name').val() == null){
	            alert("이름을 입력해주세요")
	         }else if(emailAuth == false){
	        	 alert("이메일 인증을 받아주세요");
	         }
	         else{
	            
	             id = $('#id').val();
	                pwd = $('#pwd').val();
	                pwd_check = $('#pwd_check').val();
	                email = $('#email').val();
	                name = $('#name').val();
	                point = $('#point').val();
	            alert("정보 수정이 완료되었습니다.");    
	            location.href='MypageUpdate.do?name='+name+'&id='+id+'&pwd='+pwd+'&email='+email+'&point='+point;
	
	         }
	      })
		
	});
</script>
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
					<div id="login-page" class="row">
					<div class="col s12 z-depth-4 card-panel">
						<div class="login-form">
							<div class="row">
								<div class="input-field col s12 center">
									<h4>정보 수정</h4>
								</div>
							</div>
		
							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-social-person-outline prefix"></i> <i
										class="material-icons prefix">account_circle</i> 
										<input
										id="name" name="name" type="text" /> <label for="name">이름</label>
								</div>
							</div>
		
							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-social-person-outline prefix"></i> <i
										class="material-icons prefix">account_circle</i> <input
										id="id" name="id" type="text" /> <label for="id">ID</label><span
										id="idok"></span>
								</div>
							</div>

							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-social-person-outline prefix"></i> <i
										class="material-icons prefix">email</i> <input id="email"
										name="email" type="text" style="cursor: auto;" />
										<label for="email">example@gmail.com</label>
										<input type="button" value="인증받기" id="getauth">
										<div id="authcheck">
											<div class="input-group mb-3">
												<input type="text" class="form-control" id="userauthnum"
													name="userauthnum" placeholder="인증번호">
												<div class="input-group-append">
													<input type="button" class="btn btn-primary" value="인증"
														id="auth" name="auth">
												</div>
												<br>
												<div>
													<h5 id="resultview"></h5>
												</div>
											</div>
										</div>
										<span id="emailok"></span>
									</div>
							</div>

							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-action-lock-outline prefix"></i> <i
										class="material-icons prefix">vpn_key</i> <input id="pwd"
										name="pwd" type="password" /> <label for="pwd">비밀번호</label>
								</div>
							</div>

							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-action-lock-outline prefix"></i> <i
										class="material-icons prefix">vpn_key</i> <input
										id="pwd_check" name="pwd_check" type="password" /> <label
										for="pwd_check">비밀번호 확인</label><span id="pwdok"></span>
								</div>
							</div>
							<div class="row margin">
								<div class="input-field col s12">
									<i class="mdi-social-person-outline prefix"></i> <i
										class="material-icons prefix">account_circle</i> 
										<input
										id="point" name="point" type="text" /> <label for="name">포인트</label>
								</div>
							</div>

							<div class="row">
								<div class="input-field col s12">
									<button class="btn waves-effect waves-light col s12" id="udtBtn">수정하기</button>
								</div>
								
								<div class="input-field col s12">
									<button type="button" class="btn waves-effect waves-light col s12" onclick="location.href='Mypage.do'">뒤로가기</button>
								</div>
								
							</div>
								<div>
							</div>
						</div>
					</div>
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