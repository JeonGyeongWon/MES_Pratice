function validate(evt) {
	var theEvent = evt || window.event;
	var key = theEvent.keyCode || theEvent.which;
	key = String.fromCharCode( key );
	var regex = /[0-9]|\./;
	if( !regex.test(key) ) {
		theEvent.returnValue = false;
		if(theEvent.preventDefault) theEvent.preventDefault();
	}
}

function fnChkPattern(evt) {
	var theEvent = evt || window.event;
	var key = theEvent.keyCode || theEvent.which;
	key = String.fromCharCode( key );
	var regex = /[`~!@#$%^&*|\\\'\";:\/?\[\]\{\}\+\-_=()]/gi;
	if( regex.test(key) ) {
		theEvent.returnValue = false;
		if(theEvent.preventDefault) theEvent.preventDefault();
	}
}

function crImeMode(obg) {
	obg.value = obg.value.replace(/[\ㄱ-ㅎ가-힣]/g, '');
}

function onlyNumberInput()
{
	var code = window.event.keyCode;

	if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) || code == 8 || code == 9 || code == 13 || code == 46)
	{
		window.event.returnValue = true;
		return;
	}
	window.event.returnValue = false;
}

function Validate_Email(strEmail)
{
	var r1 = new RegExp("(^[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z\.]+)*@[0-9a-zA-Z-]+(\.[0-9a-zA-Z-]+)*$)");
	if(!strEmail == '')
	{
		if(r1.test(strEmail))
		{
			if(!((strEmail.indexOf(".") > 2) && (strEmail.indexOf("@") > 0)))
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		else
		{
			return 1;
		}
	}
	else
	{
		return 1;
	}
	return 0;
}

function fnEmailDomain(obj)
{
	$('#pst_email3').val(obj.value);
}

function fnCancel()
{
	history.go(-1);
}

function fnWriteQNASubmit(f)
{
	fnRemoveClass();

	var checkVal = $("#pst_1").is(":checked");
	if (checkVal != true)
	{
		alert("개인정보 취급방침을 읽고 동의하여 주십시오.");
		$("#pst_1").focus();
		$("#agreeChk").addClass("agreeError");
		return false;
	}

	if ($.trim($("#ca_name option:selected").val()) == '')
	{
		alert('문의유형을 선택하세요');
		$('#ca_nameRow').addClass("error");
		$('#ca_name').focus();
		return false;
	}

	if ($.trim($("#ca_name option:selected").val()) == '제품')
	{
		if ($.trim($("#pst_3 option:selected").val()) == '')
		{
			alert('2차 문의유형을 선택하세요');
			$('#ca_nameRow').addClass("error");
			$('#pst_3').focus();
			return false;
		}
	}

	if ($.trim($('#pst_2').val()) == '')
	{
		alert('회사명을 입력하세요');
		$('#pst_2Row').addClass("error");
		$('#pst_2').focus();
		return false;
	}
	if ($.trim($('#pst_name').val()) == '')
	{
		alert('고객명을 입력하세요');
		$('#pst_nameRow').addClass("error");
		$('#pst_name').focus();
		return false;
	}

	var pst_ctel = '';
	var pst_mtel = '';

	pst_ctel = $.trim($('#pst_ctel1').val()) + '-' + $.trim($('#pst_ctel2').val()) + '-' + $.trim($('#pst_ctel3').val());
	pst_mtel = $.trim($('#pst_mtel1').val()) + '-' + $.trim($('#pst_mtel2').val()) + '-' + $.trim($('#pst_mtel3').val());

	if (pst_ctel == '--' && pst_mtel == '--')
	{
		alert('연락처 정보[회사/휴대폰] 중 하나를 입력하세요');
		$('#pst_telRow').addClass("error");
		$('#pst_ctel1').focus();
		return false;
	}
	if (pst_ctel != '--')
	{
		if ($.trim($('#pst_ctel1').val()).length < 2)
		{
			alert('연락처 지역 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel1').focus();
			return false;
		}
		if ($.trim($('#pst_ctel2').val()).length < 3)
		{
			alert('연락처 중간 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel2').focus();
			return false;
		}
		if ($.trim($('#pst_ctel3').val()).length < 4)
		{
			alert('연락처 뒷 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel3').focus();
			return false;
		}
	}
	if (pst_mtel != '--')
	{
		if ($.trim($('#pst_mtel1').val()).length < 3)
		{
			alert('휴대전화 앞 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel1').focus();
			return false;
		}
		if ($.trim($('#pst_mtel2').val()).length < 4)
		{
			alert('휴대전화 중간 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel2').focus();
			return false;
		}
		if ($.trim($('#pst_mtel3').val()).length < 4)
		{
			alert('휴대전화 뒷 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel3').focus();
			return false;
		}
	}

	if ($.trim($('#pst_email1').val()) == '')
	{
		alert('이메일 아이디를 입력하세요');
		$('#pst_emailRow').addClass("error");
		$('#pst_email1').focus();
		return false;
	}
	if ($.trim($('#pst_email3').val()) == '')
	{
		alert('이메일 도메인을 입력하세요');
		$('#pst_emailRow').addClass("error");
		$('#pst_email3').focus();
		return false;
	}
	var pst_email = $.trim($('#pst_email1').val()) + '@' + $.trim($('#pst_email3').val());
	if(Validate_Email(pst_email) == 1)
	{
		alert("이메일이 형식에 맞지 않습니다");
		$('#pst_emailRow').addClass("error");
		$('#pst_email1').focus();
		return false;
	}

	if ($.trim($('#pst_subject').val()) == '')
	{
		alert('제목을 입력하세요');
		$('#pst_subjectRow').addClass("error");
		$('#pst_subject').focus();
		return false;
	}

	if ($.trim($('#pst_content').val()) == '')
	{
		alert('문의내용을 입력하세요');
		$('#pst_contentRow').addClass("error");
		$('#pst_content').focus();
		return false;
	}

	$('#pst_email').val(pst_email);
	$('#pst_5').val(pst_ctel);
	$('#pst_6').val(pst_mtel);
	document.getElementById("btnSubmit").disabled = "disabled";

	return true;

}

function fnAddClass(element, className) {
    element.className += " " + className;
};
/**
function fnRemoveClass(element, className) {
    var check = new RegExp("(\\s|^)" + className + "(\\s|$)");
    element.className = element.className.replace(check, " ").trim();
};
**/
function fnWriteASSubmit(f)
{
	fnRemoveClass();

	var checkVal = $("#pst_1").is(":checked");
	if (checkVal != true)
	{
		alert("개인정보 취급방침을 읽고 동의하여 주십시오.");
		$("#pst_1").focus();
		$("#agreeChk").addClass("agreeError");
		return false;
	}

	if ($.trim($('#pst_2').val()) == '')
	{
		alert('회사명을 입력하세요');
		$("#pst_2Row").addClass("error");
		$('#pst_2').focus();
		return false;
	}
	if ($.trim($('#pst_name').val()) == '')
	{
		alert('고객명을 입력하세요');
		$('#pst_nameRow').addClass("error");
		fnAddClass($('#pst_nameRow'), "error");
		$('#pst_name').focus();
		return false;
	}

	var pst_ctel = '';
	var pst_mtel = '';

	pst_ctel = $.trim($('#pst_ctel1').val()) + '-' + $.trim($('#pst_ctel2').val()) + '-' + $.trim($('#pst_ctel3').val());
	pst_mtel = $.trim($('#pst_mtel1').val()) + '-' + $.trim($('#pst_mtel2').val()) + '-' + $.trim($('#pst_mtel3').val());

	if (pst_ctel == '--' && pst_mtel == '--')
	{
		alert('연락처 정보[회사/휴대폰] 중 하나를 입력하세요');
		$('#pst_telRow').addClass("error");
		$('#pst_ctel1').focus();
		return false;
	}
	if (pst_ctel != '--')
	{
		if ($.trim($('#pst_ctel1').val()).length < 2)
		{
			alert('연락처 지역 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel1').focus();
			return false;
		}
		if ($.trim($('#pst_ctel2').val()).length < 3)
		{
			alert('연락처 중간 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel2').focus();
			return false;
		}
		if ($.trim($('#pst_ctel3').val()).length < 4)
		{
			alert('연락처 뒷 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_ctel3').focus();
			return false;
		}
	}
	if (pst_mtel != '--')
	{
		if ($.trim($('#pst_mtel1').val()).length < 3)
		{
			alert('휴대전화 앞 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel1').focus();
			return false;
		}
		if ($.trim($('#pst_mtel2').val()).length < 4)
		{
			alert('휴대전화 중간 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel2').focus();
			return false;
		}
		if ($.trim($('#pst_mtel3').val()).length < 4)
		{
			alert('휴대전화 뒷 번호를 정확히 입력하세요');
			$('#pst_telRow').addClass("error");
			$('#pst_mtel3').focus();
			return false;
		}
	}

	if ($.trim($('#pst_email1').val()) == '')
	{
		alert('이메일 아이디를 입력하세요');
		$('#pst_emailRow').addClass("error");
		$('#pst_email1').focus();
		return false;
	}
	if ($.trim($('#pst_email3').val()) == '')
	{
		alert('이메일 도메인을 입력하세요');
		$('#pst_emailRow').addClass("error");
		$('#pst_email3').focus();
		return false;
	}
	var pst_email = $.trim($('#pst_email1').val()) + '@' + $.trim($('#pst_email3').val());
	if(Validate_Email(pst_email) == 1)
	{
		alert("이메일이 형식에 맞지 않습니다");
		$('#pst_emailRow').addClass("error");
		$('#pst_email1').focus();
		return false;
	}

	if ($.trim($("#ca_name option:selected").val()) == '')
	{
		alert('A/S 문의유형을 선택하세요');
		$('#ca_nameRow').addClass("error");
		$('#ca_name').focus();
		return false;
	}

	if ($.trim($('#pst_7').val()) == '')
	{
		alert('제품명을 입력하세요');
		$('#pst_7Row').addClass("error");
		$('#pst_7').focus();
		return false;
	}
	if ($.trim($('#pst_8').val()) == '')
	{
		alert('제품번호을 입력하세요');
		$('#pst_8Row').addClass("error");
		$('#pst_8').focus();
		return false;
	}
	if ($.trim($('#pst_9').val()) == '')
	{
		alert('구입년도을 입력하세요');
		$('#pst_9Row').addClass("error");
		$('#pst_9').focus();
		return false;
	}
	if ($.trim($('#pst_9').val()).length != 4)
	{
		alert('구입년도을 올바르게 입력하세요');
		$('#pst_9Row').addClass("error");
		$('#pst_9').focus();
		return false;
	}

	if ($.trim($('#pst_content').val()) == '')
	{
		alert('A/S 문의내용을 입력하세요');
		$('#pst_contentRow').addClass("error");
		$('#pst_content').focus();
		return false;
	}

	$('#pst_email').val(pst_email);
	$('#pst_5').val(pst_ctel);
	$('#pst_6').val(pst_mtel);
	document.getElementById("btnSubmit").disabled = "disabled";

	return true;
}

function fnWriteSubmit(f)
{
	fnRemoveClass();

	if ($.trim($('#pst_name').val()) == '')
	{
		alert('이름을 입력하세요');
		$('#pst_nameRow').addClass("error");
		$('#pst_name').focus();
		return false;
	}

	if ($.trim($('#pst_subject').val()) == '')
	{
		alert('제목을 입력하세요');
		$('#pst_subjectRow').addClass("error");
		$('#pst_subject').focus();
		return false;
	}

	if (!fnChkCont(f))
	{
		$('#pst_contentRow').addClass("error");
		return false;
	}

	if ($.trim($('#pst_password').val()) == '')
	{
		alert('비밀번호을 입력하세요');
		$('#pst_passwordRow').addClass("error");
		$('#pst_password').focus();
		return false;
	}

	if ($.trim($('#pst_password').val()).length > 4 || $.trim($('#pst_password').val()).length < 4)
	{
		alert('비밀번호는 4자리 숫자로 입력하세요');
		$('#pst_passwordRow').addClass("error");
		$('#pst_password').focus();
		return false;
	}

	document.getElementById("btnSubmit").disabled = "disabled";

	return true;
}

function fnDel(link)
{
    if(confirm("한번 삭제한 자료는 복구할 방법이 없습니다.\n\n정말 삭제하시겠습니까?")) {
        document.location.href = encodeURI(link);
    }
}

function fnRemoveClass()
{
	var obj = ['#agreeChk','#pst_2Row','#pst_nameRow','#pst_telRow','#pst_emailRow','#ca_nameRow','#pst_7Row','#pst_8Row','#pst_9Row','#pst_contentRow','#pst_subjectRow','#pst_passwordRow'];
	for (var i = 0; i < obj.length; i++)
	{
		if (typeof $(obj[i]) != "undefined")
		{
			if (obj[i] == '#agreeChk')
			{
				$(obj[i]).removeClass("agreeError");
			}
			else
			{
				$(obj[i]).removeClass("error");
			}
		}
	}
}

function fnChangeQnaPart(obj, txt, objName)
{
	if (obj.options[obj.selectedIndex].value == txt)
	{
		$('#'+objName).show();
	}
	else
	{
		$('#'+objName).hide();
	}
}