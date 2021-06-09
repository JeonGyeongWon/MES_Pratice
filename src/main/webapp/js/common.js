var selectVal = true; //  체크박스를 toggle시키기 위한 전역변수

function switchSelected(formObj) {
	toggleSelected(formObj.checks);
}

function toggleSelected(checkBoxObj) {
	if (eval(checkBoxObj) != null) {
		if (checkBoxObj.length == null) {
			checkBoxObj.checked = selectVal;
		} else {
			for (i = 0; i < checkBoxObj.length; i++) {
				checkBoxObj[i].checked = selectVal;
			}
		}
	} else
		alert("선택할 항목이 없습니다");
	selectVal = selectVal ? false : true;

}

function isCheckBoxSelected(checkBoxObj) {
	var isChecked = false;
	if (eval(checkBoxObj) != null) {
		if (eval(checkBoxObj.length) != null) {
			for (i = 0; i < checkBoxObj.length; i++) {
				if (checkBoxObj[i].checked) {
					isChecked = true;
					break;
				}
			}
		} else {
			if (checkBoxObj.checked)
				isChecked = true;
		}
	} else {
		alert("선택된 리스트가 없습니다");
		return false;
	}
	if (!isChecked)
		alert("선택하세요      ");
	return isChecked;
}

function Trim(new_name) {
	tmpName1 = LTrim(new_name);
	tmpName2 = RTrim(tmpName1);
	return tmpName2;
}

function LTrim(new_name) {
	i = 0;
	while (i < new_name.length) {
		if (new_name.charAt(i) != ' ')
			break;
		i++;
	}
	if (i == 0)
		return new_name;
	else
		return new_name.substr(i);
}

function RTrim(new_name) {
	i = new_name.length - 1;
	while (i >= 0) {
		if (new_name.charAt(i) != ' ')
			break;
		i--;
	}
	if (i == new_name.length - 1)
		return new_name;
	else
		return new_name.substring(0, i + 1);
}

//숫자만 입력가능
function keyCheckInt(e) {
	var n4 = (document.layers) ? true : false;
	var e4 = (document.all) ? true : false;

	if (n4)
		var keyValue = e.which;
	else if (e4)
		var keyValue = event.keyCode;

	// keyValue == 45 (-) delete by KJH
	if (((keyValue >= 48) && (keyValue <= 57)) || keyValue == 8 || keyValue == 46 || keyValue == 44)
		return true;
	else
		return false;
}

/**
 * Created by sungpilhyun on 15. 3. 5..
 */
function split(val) {
	return val.split(/,\s*/);
}

function extractLast(term) {
	return split(term).pop();
}

function extAlert(v) {
	if (Ext == null)
		alert(replaceAll(v, "<br>", "\n"));
	else
		Ext.MessageBox.alert(msgs.title.noti, replaceAll(v, "\n", "<br>"));
}

function extToast(v) {
	if (Ext == null)
		return;
	else {
		Ext.toast({
			html: "<strong>" + v + "</strong>",
			align: 't',
			closable: false,
			slideInDuration: 400,
			minWidth: 500,
		});
	}
}
/**
 * Created by ymha on 2016.03.30.
 */
function extWorkAlert(t, m, b) {
	if (Ext == null) {
		return;
	} else {
		Ext.MessageBox.show({
			maxWidth: 1300,
			msg: "<strong style='font-size: 40px; text-align: center; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + m + "</strong>",
			//            header: false,
			title: "<strong style='font-size: 42px; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + t + "</strong>",
			buttonText: {
				ok: "<strong style='font-size: 15px; font-weight: bold; color: rgb(255, 255, 255); '>" + b + "</strong>",
			}
		});
	}
}

function extToastView(v) {
	if (Ext == null)
		return;
	else {
		Ext.toast({
			html: "<h2 style='font-size: 35px; font-weight: bold; color: blue;'>" + v + "</h2>",
			align: 't',
			closable: false,
			slideInDuration: 100, // 메시지가 전부 올라오는 시간 0.1초
			timeout: 100, // 표시 시간
			hideDuration: 200,
			autoCloseDelay: 600,
			minWidth: 250,
		});
	}
}

function extAlertWihtRefesh(v, storenm) {
	if (Ext == null)
		return;
	Ext.Msg.alert(msgs.title.noti, v, function () {
		Ext.getStore(storenm).load();
	});
}

function setExtraParam(params, storenm) {
	if (Ext == null)
		return;
	$.each(params, function (n, v) {
		Ext.getStore(storenm).proxy.setExtraParam(n, v);
	});
}

/**
 * 그리드 조회 Function
 *
 * @param 파라미터 목록
 * @param 그리드 저장소 ID
 * @return 없음
 * @history 2018.05.10 Modify - 5.1.0 -> 5.1.3 버전 업그레이드 중 정렬기능 가져오는 부분 변경
 */
function extGridSearch(params, storenm) {
	if (Ext == null)
		return;
	setExtraParam(params, storenm);

	// 5.1.0 Version
	// Ext.getStore(storenm).sorters.clear();

	// 5.1.3 Version
	Ext.getStore(storenm).getSorters().clear();
	Ext.getStore(storenm).load();
}

/**
 * 스프레드시트 조회 Function
 *
 * @param 파라미터 목록
 * @param 그리드 저장소 ID
 * @return 없음
 * @history 2019.02.20 ADD 스프레드시트 조회시 드래그 초기화
 */
function extSpreadSearch(params, storenm, viewnm) {
	if (Ext == null)
		return;
	setExtraParam(params, storenm);

	Ext.getStore(storenm).getSorters().clear();
	Ext.getCmp(viewnm).view.refresh(); // 드래그 항목 초기화 기능 포함
	Ext.getStore(storenm).load();
}

/**
 * 집계 데이터 조회 Function
 *
 * @param 파라미터 목록
 * @param 그리드 저장소 ID
 * @return 없음
 * @history
 */
function extExtractValues(a, b) {
	return a.map(function (i) {
		return i.get(b);
	});
}

function extGridSave(storenm) {
	if (Ext == null)
		return;
	Ext.getStore(storenm).sync({
		success: function (batch, options) {
			extAlertWihtRefesh(msgs.noti.save, storenm);
		},
		failure: function (batch, options) {
			if (batch.proxy.reader.rawData.resultMessage.length > 0) {
				extAlert(batch.proxy.reader.rawData.resultMessage);
			} else {
				extAlert(batch.exceptions[0].error);
			}
		},
		callback: function (batch, options) {},
	});
}

function extGridDel(storenm, viewnm) {
	if (Ext == null)
		return;
	var store = Ext.getStore(storenm);
	var record = Ext.getCmp(viewnm).selModel.getSelection()[0]
		if (record == null)
			return;

		Ext.Msg.confirm(msgs.title.del, replaceAll(msgs.cfm.del, "\n", "<br>"), function (v, o1, o) {
			if (v === "yes") {
				store.remove(record);
				Ext.getStore(storenm).sync({
					success: function (batch, options) {
						extAlert(msgs.noti.del);
					},
					failure: function (batch, options) {
						extAlertWihtRefesh(batch.exceptions[0].error, storenm);
					},
					callback: function (batch, options) {},
				});
			}
		});
}

function extGridRefesh(storenm) {
	if (Ext == null)
		return;
	Ext.getStore(storenm).load();
}

function getCreateParams(params) {
	return $.extend({}, params);
}

function getSelectedRowData(classnm) {
	if (Ext == null)
		return null;
	var data = Ext.getStore(classnm + ".store").getById(Ext.getCmp(classnm + ".view").selModel.getSelection()[0].id);
	return data;
}

function getSelectedRowDataByStoreNView(classnm, viewnm) {
	var data = Ext.getStore(classnm).getById(Ext.getCmp(viewnm).selModel.getSelection()[0].id);
	return data;
}

function getRowDataByStore(storenm, fieldnm, val) {
	if (Ext == null)
		return null;
	var data = {};
	var store = Ext.getStore(storenm);
	var index = store.findExact(fieldnm, val);
	if (index > -1) {
		data = store.getAt(index);
	} else
		data = null;
	return data;
}

function renderer4combobox(v, d, record) {
	//	console.log(v);
	if (Ext == null)
		return;
	var combobox = d.column.getEditor(record);
	if (v && combobox && combobox.store && combobox.displayField) {
		var index = combobox.store.findExact(combobox.valueField, v);
		if (index > -1) {
			return combobox.store.getAt(index).get(combobox.displayField);
		}
	}
	return v;
}

function go_url(url) {
	if (url === "/")
		return;
	else
		location.href = url;
}

/*
 * 유효성체크
 */
function valid_chk(targetId) {
	if (targetId == null)
		return true;
	var bReturn = true;
	var ids = targetId.split(",");
	for (var i in ids) {
		var id = $.trim(ids[i]);
		if (bReturn) {
			bReturn = $("#" + id).validationEngine("validate");
		} else {
			$("#" + id).validationEngine("validate");
		}
	}
	return bReturn;
}

function replaceAll(text, arg1, arg2) {
	if (text == null || text == undefined) {
		text = "";
	}
	var tempStr = text;
	tempStr = tempStr.split(arg1).join(arg2);
	return tempStr;
}

function parseNumber(text) {
	var temp = text;
	var replace_temp = temp.replace(/[^0-9.]/g, '');
	var result = parseFloat(replace_temp);

	return isNaN(result) ? 0 : result;
}

//이미지파일 밸리데이션
function fileValidImg(files) {
	var isSuccess = true;
	$.each(files, function (i, file) {
		if (isMSIE()) {
			var extname = file.name.substring(file.name.lastIndexOf(".") + 1).toLowerCase();
			if (isSuccess && $.inArray(extname, fileVals.imgtype) === -1) {
				extAlert(msgs.valid.fail.img.type);
				isSuccess = false;
			}
		} else {
			if (isSuccess && $.inArray(file.type, fileVals.imgtype) === -1) {
				extAlert(msgs.valid.fail.img.type);
				isSuccess = false;
			}
		}
		if (isSuccess && file.size > fileVals.limitsize) {
			extAlert(msgs.valid.fail.img.limitsize);
			isSuccess = false;
		}
	});
	return isSuccess;
}

/*
 * 달력
 */
function calender(el, params) {
	if (params == null)
		params = {};
	$(el).datepicker($.extend(calenderOpt, params));
}

function calender2(el, params) {
	if (params == null)
		params = {};
	$(el).datepicker($.extend(calenderOpt2, params));
}

function getToDay(format) {
	return new Date().formater(format);
}
Date.prototype.formater = function (f) {
	if (!this.valueOf())
		return " ";

	var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
	var d = this;

	return f.replace(/(YYYY|yyyy|yy|MM|mm|dd|E|hh|mi|ss|msc|a\/p)/gi, function ($1) {
		switch ($1) {
		case "YYYY":
		case "yyyy":
			return d.getFullYear();
		case "yy":
			return (d.getFullYear() % 1000).zf(2);
		case "MM":
		case "mm":
			return (d.getMonth() + 1).zf(2);
		case "DD":
		case "dd":
			return d.getDate().zf(2);
		case "E":
			return weekName[d.getDay()];
		case "HH":
			return d.getHours().zf(2);
		case "hh":
			return ((h = d.getHours() % 12) ? h : 12).zf(2);
		case "mi":
			return d.getMinutes().zf(2);
		case "ss":
			return d.getSeconds().zf(2);
		case "a/p":
			return d.getHours() < 12 ? "오전" : "오후";
		case "msc":
			return d.getMilliseconds();
		default:
			return $1;
		}
	});
};

String.prototype.string = function (len) {
	var s = "",
	i = 0;
	while (i++ < len) {
		s += this;
	}
	return s;
};
String.prototype.zf = function (len) {
	return "0".string(len - this.length) + this;
};
Number.prototype.zf = function (len) {
	return this.toString().zf(len);
};

/*
 * Body Loading bar
 */
function setLoadingBar(b) {
	if (b == null || typeof b != "boolean")
		return;
	if (b) {
		$("#loadingBar").show();
	} else {
		$("#loadingBar").hide();
	}
}

/*
 * Ajax 에러 공통함수
 */
function ajaxError(xhr, status, err) {
	if (xhr.status == 0) {
		console.log("네트워크를 체크해주세요.");
	} else if (xhr.status == 404) {
		console.log("페이지를 찾을수없습니다.");
	} else if (xhr.status == 500) {
		console.log("서버에러 발생하였습니다.");
	} else if (err == "parsererror") {
		console.log("Error.\nParsing JSON Request failed.");
	} else if (err == "timeout") {
		console.log("시간을 초과하였습니다.");
	} else {
		console.log("알수없는 에러가 발생하였습니다.");
		console.log("xhr.status = " + xhr.status);
		//console.log("xhr.responseText = "+xhr.responseText);
	}
	setLoadingBar(false);
}

function isMSIE() {
	var ua = (window.navigator.userAgent).toLowerCase();
	var msie = ua.indexOf("msie ");
	if (msie === -1)
		msie = ua.indexOf("rv:11");
	return msie > -1;
}

/**
 * 두 날짜의 차이를 일자로 구한다.(조회 종료일 - 조회 시작일)
 *
 * @param val1 - 조회 시작일(날짜 ex.2002-01-01)
 * @param val2 - 조회 종료일(날짜 ex.2002-01-01)
 * @return 기간에 해당하는 일자
 */
function calDateRange(val1, val2) {
	var FORMAT = "-";

	// FORMAT을 포함한 길이 체크
	if (val1.length != 10 || val2.length != 10)
		return null;

	// FORMAT이 있는지 체크
	if (val1.indexOf(FORMAT) < 0 || val2.indexOf(FORMAT) < 0)
		return null;

	// 년도, 월, 일로 분리
	var start_dt = val1.split(FORMAT);
	var end_dt = val2.split(FORMAT);

	// 월 - 1(자바스크립트는 월이 0부터 시작하기 때문에...)
	// Number()를 이용하여 08, 09월을 10진수로 인식하게 함.
	start_dt[1] = (Number(start_dt[1]) - 1) + "";
	end_dt[1] = (Number(end_dt[1]) - 1) + "";

	var from_dt = new Date(start_dt[0], start_dt[1], start_dt[2]);
	var to_dt = new Date(end_dt[0], end_dt[1], end_dt[2]);

	return (to_dt.getTime() - from_dt.getTime()) / 1000 / 60 / 60 / 24;
}

/**
 * 두 날짜의 차이를 일자로 구한다.(calDateRange Func 경량화)
 *
 * @param val1 - 조회 시작일(날짜 ex.2002-01-01)
 * @param val2 - 조회 종료일(날짜 ex.2002-01-01)
 * @return 기간에 해당하는 일자
 */
function fn_calc_diff(val1, val2) {
	var result = 0;
	var pre_diff1 = new Date(val1);
	var pre_diff2 = new Date(val2);
	var pre_day = 1000 * 60 * 60 * 24;

	var diff = pre_diff2 - pre_diff1;
	result = parseInt(diff / pre_day);

	return result;
}

/**
 * 해당 날짜의 주차를 년도기준으로 구한다.
 *
 * 86400000 - 1일
 * 604800000 - 1주
 * @param val - 조회일(날짜 ex.2002-01-01)
 * @return 주차
 */
function fn_calc_week_year(val, n) {
	var result = 0;
	var today = new Date(val);
	var day_split = (today.getDay() + 7) % 7;
	today.setDate(today.getDate() - day_split + n);

	// 첫번째 요일 기준
	var firstday = today.valueOf();
	today.setMonth(0, 1);
	if (today.getDay() !== 1) {
		today.setMonth(0, 1 + ((1 - today.getDay()) + 7) % 7);
	}

	result = 1 + Math.ceil((firstday - today) / 604800000);

	return result;
}

/**
 * 해당 날짜의 년도 기준 주차를 구한다.
 *
 * @param val - 조회일(날짜 ex.2002-01-01)
 * @return 주차
 */
Date.prototype.getWeek = function (n) {
	return fn_calc_week_year(this.valueOf(), n);
}

/**
 * 해당 날짜의 월 기준 주차를 구한다.
 *
 * @return 년, 월, 월 기준 주차
 */
Date.prototype.getMonthOfWeek = function (n) {
	const startdate = new Date(this.getTime());

	// 기준 년, 월
	let year = startdate.getFullYear();
	let month = startdate.getMonth() + 1;

	// 월요일 기준 주차 구하기
	const fn_week_number = (standarddate) => {

		const year = standarddate.getFullYear();
		const month = standarddate.getMonth();
		const date = standarddate.getDate();

		// 기준 월의 첫 날과 마지막 날의 요일
		const firstDate = new Date(year, month, 1);
		const lastDate = new Date(year, month + 1, 0);
		const firstWeek = firstDate.getDay() === 0 ? 7 : firstDate.getDay();
		const lastWeek = lastDate.getDay();

		// 기준 월의 마지막 일
		const lastDay = lastDate.getDate();

		// 첫 날의 요일이 화, 수, 목, 금, 토, 일요일 이라면 true
		const firstWeekCheck = firstWeek === 2 || firstWeek === 3 || firstWeek === 4 || firstWeek === 5 || firstWeek === 6 || firstWeek === 7;
		// 마지막 날의 요일이 월요일 기준으로 하게 되면 조건이 성립되지 않음
		const lastWeekCheck = false; // lastWeek === 2 || lastWeek === 3 || lastWeek === 4;

		// 해당 달이 총 몇주까지 있는지
		const lastWeekNo = Math.ceil((firstWeek - 1 + lastDay) / 7);

		// 날짜 기준으로 몇주차 인지
		let standardWeek = Math.ceil((firstWeek - 1 + date) / 7);

		// 기준 날짜가 첫 주에 있고 첫 날이 화, 수, 목, 금, 토요일로 시작한다면 'prev'(전달 마지막 주)
		if (standardWeek === 1 && firstWeekCheck) {
			standardWeek = 'prev';
		}
		// 기준 날짜가 마지막 주에 있고 마지막 날이 일요일로 끝난다면 'next'(다음달 첫 주)
		else if (standardWeek === lastWeekNo && lastWeekCheck) {
			standardWeek = 'next';
		}
		// 기준 날짜의 첫 주는 아니지만 첫날이 일요일로 시작하면 -1;
		else if (firstWeekCheck) {
			standardWeek = standardWeek - 1;
		}

		return standardWeek;
	};

	// 기준일자의 월요일
	const fn_first_day = (standarddate) => {

		let day_split = (standarddate.getDay() + 7) % 7;
		standarddate.setDate(standarddate.getDate() - day_split + n);

		return standarddate;
	};

	// 월요일 기준의 주차
	let week = fn_week_number(startdate);

	// 이전달의 마지막 주차일 떄
	if (week === 'prev') {
		// 이전 달의 마지막날
		const afterDate = new Date(year, month - 1, 0);
		year = month === 1 ? year - 1 : year;
		month = month === 1 ? 12 : month - 1;
		week = fn_week_number(afterDate);
	}
	// 다음달의 첫 주차일 때
	if (week === 'next') {
		year = month === 12 ? year + 1 : year;
		month = month === 12 ? 1 : month + 1;
		week = 1;
	}

	// 기준일자의 월요일
	let monday = fn_first_day(startdate);
	let start = Ext.util.Format.date(monday, 'Y-m-d');
	let sunday = monday;
	sunday.setDate(sunday.getDate() + 6)
	let end = Ext.util.Format.date(sunday, 'Y-m-d');

	return {
		year,
		month,
		week,
		start,
		end
	};
}

/**
 * 해당 날짜의 년도를 구한다.
 *
 * @param n - 기준요일 ( 0 : 일요일, 1 : 월요일 ... )
 *            len - 표기할 자릿수
 * @return 년도
 */
Date.prototype.getWeekYear = function (n, len) {
	var length = len * 1;
	var date = new Date(this.getTime());
	date.setHours(0, 0, 0, 0);
	date.setDate(date.getDate() + n - (date.getDay() + 6) % 7);
	var result = date.getFullYear() + "";
	return result.substring(length);
}

/**
 * 해당 날짜의 월을 구한다.
 *
 * @param n - 기준요일 ( 0 : 일요일, 1 : 월요일 ... )
 * @return 월
 */
Date.prototype.getWeekMonth = function (n) {
	var date = new Date(this.getTime());
	date.setHours(0, 0, 0, 0);
	date.setDate(date.getDate() + n - (date.getDay() + 6) % 7);
	var result = "";
	var temp = (date.getMonth() * 1);

	if (temp < 9) {
		result = "0" + ((temp * 1) + 1);
	} else {
		result = ((temp * 1) + 1) + "";
	}
	return result;
}

/**
 * 해당 날짜의 요일을 구한다.
 *
 * @param val - 조회일(날짜 ex.2002-01-01)
 * @return 요일
 */
function fn_calc_day_name(val) {
	var week = new Array('일', '월', '화', '수', '목', '금', '토');

	var today = new Date(val).getDay();
	var result = week[today];

	return result;
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change(flag1, flag2, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='' selected>" + "전체" + "</option>");
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value='" + null + "'>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_a1(flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		ATTRIBUTE1: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='' selected>" + "전체" + "</option>");
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				//				$("#" + col + "").html("<option value='" + null + "'>" + '' + "</option>");
				$("#" + col + "").html("<option value='' selected>" + "전체" + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_r(flag1, flag2, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='" + value + "' selected>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_r1(flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		ATTRIBUTE1: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_r2(flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		ATTRIBUTE2: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_r3(flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		ATTRIBUTE3: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]사업장, 공장 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_r4(flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		ATTRIBUTE4: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='" + value + "'>" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [기준정보-소분류]필터 데이터 가져오기 Function
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 가져올 값
 * @return Array 배열 값으로 리턴
 */
function fn_option_filter_data(orgid, companyid, flag1, flag2, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? orgid : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? companyid : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		GUBUN: (col == "VALUE") ? "VALUE" : "",
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [기준정보-소분류]필터 데이터 가져오기 Function
 *
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 가져올 값
 * @param orderby - 정렬여부
 * @return Array 배열 값으로 리턴
 */
function fn_option_filter_data(orgid, companyid, flag1, flag2, col, orderby) {
	var orgid = ($('#searchOrgId').val() == undefined) ? orgid : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? companyid : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		BIGCD: flag1,
		MIDDLECD: flag2,
		GUBUN: (orderby != "") ? "VALUE" : "",
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallCodeListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;
					var attribute1 = dataList.ATTRIBUTE1;
					var attribute2 = dataList.ATTRIBUTE2;
					var attribute3 = dataList.ATTRIBUTE3;
					var attribute4 = dataList.ATTRIBUTE4;
					var attribute5 = dataList.ATTRIBUTE5;
					var attribute6 = dataList.ATTRIBUTE6;
					var attribute7 = dataList.ATTRIBUTE7;
					var attribute8 = dataList.ATTRIBUTE8;
					var attribute9 = dataList.ATTRIBUTE9;
					var attribute10 = dataList.ATTRIBUTE10;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {
						tempData.push(value);
					} else if (col == "ATTRIBUTE1") {
						tempData.push(attribute1);
					} else if (col == "ATTRIBUTE2") {
						tempData.push(attribute2);
					} else if (col == "ATTRIBUTE3") {
						tempData.push(attribute3);
					} else if (col == "ATTRIBUTE4") {
						tempData.push(attribute4);
					} else if (col == "ATTRIBUTE5") {
						tempData.push(attribute5);
					} else if (col == "ATTRIBUTE6") {
						tempData.push(attribute6);
					} else if (col == "ATTRIBUTE7") {
						tempData.push(attribute7);
					} else if (col == "ATTRIBUTE8") {
						tempData.push(attribute8);
					} else if (col == "ATTRIBUTE9") {
						tempData.push(attribute9);
					} else if (col == "ATTRIBUTE10") {
						tempData.push(attribute10);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [공정]필터 데이터 가져오기 Function
 *
 * @param itemcode - 제품, 반제품코드
 * @param searchdate - 날짜
 * @param col - 가져올 값
 * @param orderby - 정렬여부
 * @return Array 배열 값으로 리턴
 */
function fn_option_routing_data(orgid, companyid, itemcode, searchdate, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? orgid : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? companyid : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		ITEMCODE: itemcode,
		SEARCHDATE: searchdate,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchRoutingListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.RN;
					var label = dataList.ROUTINGNAME;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {
						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [기준정보-작업자]필터 데이터 가져오기 Function
 *
 * @param flag1 - 부서코드
 * @param flag2 - 직위
 * @param flag3 - 사원구분
 * @param flag4 - 작업반
 * @param col - 가져올 값
 * @return Array 배열 값으로 리턴
 */
function fn_worker_filter_data(orgid, companyid, flag1, flag2, flag3, flag4, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? orgid : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? companyid : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		DEPARTMENTCODE: flag1,
		POSITIONCODE: flag2,
		INSPECTORTYPE: flag3,
		WORKDEPT: flag4,
		GUBUN: "LABEL",
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchWorkerPCListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [기준정보-설비]필터 데이터 가져오기 Function
 *
 * @param flag1 - 작업반
 * @param flag2 - 설비코드
 * @param col - 가져올 값
 * @return Array 배열 값으로 리턴
 */
function fn_equipment_filter_data(orgid, companyid, flag1, flag2, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? orgid : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? companyid : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		WORKDEPT: flag1,
		keyword: flag2,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchWorkCenterLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * forms 기능을 사용하여 POST 방식으로 팝업창을 띄우기 위한 Func
 *
 * @param col - 값을 넘겨주고싶은 forms 명
 * @param url - 이동하고 싶은 경로 URL
 * @param target - 창을 띄우고 싶은 속성 선택
 *             				1. _top : 윈도우 최상위에 표시
 *             				2. _self : 현재창에 표시
 *             				3. _blank : 새창에 표시
 *             				4. _parent : 부모창에 표시
 *             				5. _search : 브라우저 검색창에 표시 ( IE 5.0부터 지원 )
 * @return 따로 리턴되진 않음
 */
function fn_popup_url(col, url, target) {
	var forms = document.getElementById(col);

	forms.action = url;
	forms.target = target;
	forms.method = "post";
	forms.submit();
}

/**
 * forms 기능을 사용할 때 특정키 이벤트 먹히지 않도록 하는 Func
 *
 * @param e - 이벤트 ( ex. 13 - Enter, 9 - Tab...등 자세한건 구글 검색 )
 * @param code - 제약을 걸고 싶은 KeyCode
 * @return 따로 리턴되진 않음
 */
function fn_key_break(e, code) {
	// Enter 키 누를 때 Form 입력 전송 기능 작동중지
	if (e.keyCode == 13 && e.srcElement.type != 'textarea')
		return false;
}

/**
 * input 태그에서 숫자만 입력되도록 제한하는 Func
 *
 * @param e - 이벤트 ( ex. 13 - Enter, 9 - Tab...등 자세한건 구글 검색 )
 * @return 숫자 및 수정시 필요한 키들 : true, 그 외 : false
 */
function fn_key_number(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ((keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 || keyID == 9)
		return;
	else
		return false;
}

/**
 * input 태그에서 숫자 외 입력된 값 제거하는 Func
 *
 * @param e - 이벤트 ( ex. 13 - Enter, 9 - Tab...등 자세한건 구글 검색 )
 * @return 제외 ( 8 - 백스페이스, 46 - Delete, 37 - 화살표 왼쪽, 39 - 화살표 오른쪽 )
 *            그 외 입력되었던 문자들 삭제
 */
function fn_remove_char(e) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if (keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39)
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9.]/g, "");
}

/**
 * 왼쪽 자리수만큼 채워주는 Func
 *
 * @param v - 입력한 문자
 *            ,l - 자릿수
 *            ,s - 채울 문자열
 * @return 자릿수만큼 채워진 문자열
 */
function fn_lpad(v, leng, s) {
	while (v.length < leng)
		v = s + v;
	return v;
}

/**
 * 오른쪽 자리수만큼 채워주는 Func
 *
 * @param v - 입력한 문자
 *            ,l - 자릿수
 *            ,s - 채울 문자열
 * @return 자릿수만큼 채워진 문자열
 */
function fn_rpad(v, leng, s) {
	while (v.length < leng)
		v += s;
	return v;
}

/**
 * 버튼 날짜 변경 Func
 *
 * @param fr - 적용하고자 하는 날짜 From 아이디
 *            ,to - 적용하고자 하는 날짜 To 아이디
 *            ,v1 - From에 들어갈 값
 *            ,v2 - To에 들어갈 값
 * @return 없음
 */
function fn_btn_change_date(fr, to, v1, v2) {
	$('#' + fr).val("");
	$('#' + to).val("");

	if (v1 != "" || v1 != undefined) {
		$('#' + fr).val(v1);
	}

	setTimeout(function () {
		if (v2 != "" || v2 != undefined) {
			$('#' + to).val(v2);
		}
	}, 200);
}

/**
 * 체크박스 선택 FUNC ( 1개만 체크 )
 *
 * @param storenm - 그리드 Store 명
 *            ,viewnm - 그리드 View 명
 *            ,index - 레코드 순번
 * @return 없음
 */
function fn_checkbox_selected(storenm, viewnm, index) {

	var grid_count = Ext.getStore(storenm).count();
	if (grid_count > 0) {
		for (var i = 0; i < grid_count; i++) {
			Ext.getStore(storenm).getById(Ext.getCmp(viewnm).getSelectionModel().select(i));
			var model1 = Ext.getCmp(viewnm).selModel.getSelection()[0];

			var chk = model1.data.CHK;
			if (chk) {
				model1.set("CHK", false);
			}
		}

		Ext.getStore(storenm).getById(Ext.getCmp(viewnm).getSelectionModel().select(index));
		var model2 = Ext.getCmp(viewnm).selModel.getSelection()[0];
		model2.set("CHK", true);
	}
}

/**
 * 단축키 설정 플러그인
 */
(function ($) {
	$.shortcut = function (options) {
		if (options) {
			$(document).keyup(function (e) {
				var el = e.srcElement ? e.srcElement : e.target;
				if (!(e.altKey || e.metaKey || e.shiftKey) & !$(el).is(":input")) {
					$.each(options, function (keycode, fnc) {
						if (e.which == keycode && fnc)
							fnc();
					});
				}
			});
		}
	};
})(jQuery);

/**
 * 그리드 컬럼 포커싱 FUNC
 *
 * @param arrownm - 키보드 방향키
 *       ,storenm - 그리드 Store 명
 *       ,viewnm  - 그리드 View 명
 *       ,rowindex - 현재 레코드 순번
 *       ,colindex - 현재 항목 순번
 * @return 없음
 */
function fn_grid_focus_move(arrownm, storenm, viewnm, rowindex, colindex) {
	var limit_min_count = 0,
	limit_max_count = 0,
	limit_left_count = 0,
	limit_right_count;
	var grid = Ext.getCmp(viewnm);
	var row_temp = 0;
	var col_temp = 0;
	var temp = 0;
	switch (arrownm) {
	case "UP":
		limit_min_count = 0;

		// 상한치 제어
		row_temp = ((rowindex == 0) ? 0 : (rowindex - 1));

		col_temp = colindex;
		if (rowindex >= limit_min_count) {
			grid.editingPlugin.startEdit(row_temp, col_temp);
		}
		break;
	case "DOWN":
		limit_max_count = Ext.getStore(storenm).count();

		// 하한치 제어
		row_temp = ((rowindex == (limit_max_count - 1)) ? (limit_max_count - 1) : (rowindex + 1));

		col_temp = colindex;
		if (rowindex < limit_max_count) {
			grid.editingPlugin.startEdit(row_temp, col_temp);
		}
		break;
	case "LEFT":
		limit_min_count = 0;
		limit_left_count = 0;

		// 현재 표기된 항목중 최대 Index 찾기
		for (var i = 0; i < temp; i++) {
			if (grid.columns[i].isLastVisible) {
				limit_right_count = grid.columns[i].fullColumnIndex;
			}
		}

		if (colindex == limit_left_count) {
			row_temp = ((rowindex == limit_min_count) ? limit_min_count : (rowindex - 1));
			col_temp = limit_right_count;
		} else {
			row_temp = rowindex;
			col_temp = colindex - 1;
		}

		if (col_temp >= limit_left_count) {
			grid.editingPlugin.startEdit(row_temp, col_temp);
		}
		break;
	case "RIGHT":
		limit_max_count = Ext.getStore(storenm).count();
		limit_left_count = 0;
		temp = grid.columns.length;

		// 현재 표기된 항목중 최대 Index 찾기
		for (var i = 0; i < temp; i++) {
			if (grid.columns[i].isLastVisible) {
				limit_right_count = grid.columns[i].fullColumnIndex;
			}
		}

		if (colindex == limit_right_count) {
			row_temp = ((rowindex == (limit_max_count - 1)) ? (limit_max_count - 1) : (rowindex + 1));
			col_temp = limit_left_count;
		} else {
			row_temp = rowindex;
			col_temp = colindex + 1;
		}

		if (col_temp < limit_right_count) {
			grid.editingPlugin.startEdit(row_temp, col_temp);
		}
		break;
	default:
		break;
	}
}

/**
 * [중분류]대분류 선택시 중분류 변경 Function (전체 항목 미표기)
 *
 * @param flag1 - 대분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_class_m(flag0, flag1, col) {
	var orgid = $('#searchOrgId').val();
	var companyid = $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		GROUPCODE: flag0,
		BIGCODE: flag1,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchMiddleClassListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='' selected>" + "" + "</option>");
						$("#" + col + "").append("<option value='" + value + "' >" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * [소분류]중분류 선택시 소분류 변경 Function (전체 항목 미표기)
 *
 * @param flag0 - GROUP코드
 * @param flag1 - 대분류코드
 * @param flag2 - 중분류코드
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_option_change_class_s(flag0, flag1, flag2, col) {
	var orgid = $('#searchOrgId').val();
	var companyid = $('#searchCompanyId').val();

	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		GROUPCODE: flag0,
		BIGCODE: flag1,
		MIDDLECODE: flag2,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSmallClassListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			//		done: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (i == 0) {
						$("#" + col + "").html("<option value='' selected>" + "" + "</option>");
						$("#" + col + "").append("<option value='" + value + "' >" + label + "</option>");
					} else {
						$("#" + col + "").append("<option value='" + value + "'>" + label + "</option>");
					}
				}
			} else {
				$("#" + col + "").html("<option value=''>" + '' + "</option>");
			}
		},
		error: ajaxError
	});
}

/**
 * 알람 기능을 관리하는 Func
 *
 * @param flag - START : 시작 , STOP : 중지
 * @return 따로 리턴되진 않음
 */
var audio_obj = new Audio("data:audio/wav;base64,UklGRvRoAABXQVZFZm10IBAAAAABAAEARKwAAIhYAQACABAAZGF0YdBoAAAFWvxZAloBWv1ZBVr6WQRa/1n/WQJa/1kAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAVr+WQJa/1kAWgBaAVr9WQVa+1kEWv1ZAVoAWgFa/lkDWvxZBFr9pQKm/qUCpv+lAKYApgCmAKYApgCmAKYApgGm/qUCpv+lAKYApgCmAab+pQKm/aUDpv+l/6UBpv+lAab/pQKm/aUCpgCm/qUDpv6lAab/pQGm/6UCpv6lAab/pQGmAab9WQRa/FkDWv9Z/1kCWv5ZAlr/WQBaAFoAWgBaAVr+WQJa/1n/WQNa/FkEWv1ZAlr/WQBaAFoBWv9ZAVr/WQBaAVr/WQFa/1kAWgFa/1kBWgBa/lkDWv1ZAloAWv9ZAab/pQGm/6UBpv+lAab/pQGm/6UApgGm/6UBpv+l/6UDpv2lA6b+pf+lA6b9pQOm/aUDpvylBab8pQKmAKb+pQKmAKb/pQGmAKb+pQOm/qUBpgCm/6UBpv+lAaYApv+lAlr8WQVa/FkDWv5ZAVr/WQFa/1kBWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVoAWv9ZAlr+WQFaAVr+WQJa/lkBWgFa/lkCWv5ZAVoAWv9ZAVoAWv9ZAVr/WQFaAFr/WQJa/aUDpv2lA6b+pQGm/6UBpv+lAab/pQCmAqb9pQOm/aUDpv2lBKb8pQOm/qUBpgCmAKYApv+lAab/pQGmAKb/pQCmAqb8pQWm+6UEpv6lAab/pQCmAKYBpv+lAab+pQJa/1kBWv5ZAlr/WQFa/1kAWgFa/1kBWv9ZAFoBWv9ZAVr/WQBaAFoBWv9ZAFoBWv9ZAFoBWv5ZA1r9WQNa/VkDWv1ZA1r9WQNa/VkDWv1ZA1r9WQJa/1kAWgFa/1kAWgGm/qUDpvylBKb9pQKm/6UApgGm/qUDpv2lAqb/pQCmAab/pQCmAKYBpv6lAqb+pQKmAKb+pQKm/6X/pQSm/KUCpgCm/qUEpvulBab8pQKmAab9pQOm/aUDpv2lA6b+WQBaAVr/WQFa/1kBWv9ZAVr/WQFa/lkDWv1ZA1r9WQFaAVr+WQNa/VkCWv5ZAlr/WQBaAlr8WQNa/1kAWgFa/1n/WQJa/1kAWgFa/1kAWgFa/1kAWgFa/1kAWgFa/lkCpv6lAqb+pQKm/6X/pQKm/6UApgGm/6UApgGm/qUCpv+lAab/pf+lAqb/pQCmAqb8pQSm/aUCpv+lAab+pQOm/aUCpv+lAKYApgGm/6UApgGm/qUCpv6lA6b8pQWm+6UDWv9ZAFoBWv9ZAFoAWgFa/1kAWgBa/1kDWv1ZAlr+WQFaAVr+WQJa/lkCWv5ZAlr+WQFaAFoAWv9ZAlr9WQNa/lkBWgBa/1kCWv1ZA1r+WQFaAFr/WQJa/VkDWv5ZAaYApgCm/6UBpgCm/6UCpv6lAaYApv+lAqb+pQKm/qUBpgCmAKYApgCmAKYApgCmAab+pQKm/qUCpv+lAKYApv+lA6b9pQKm/qUBpgCmAab+pQOm+6UGpvulBKb9pQGmAVr/WQFa/1kAWgFaAFr/WQJa/VkDWv5ZAVoAWv9ZAlr+WQFaAFr/WQJa/lkBWgBaAFr/WQJa/VkDWv5ZAVoAWgBa/lkDWv5ZAVoAWv9ZAVoAWv9ZAlr9WQRa/FkDWv+l/qUEpvylA6b+pQGmAKYApv+lAqb+pQKm/qUCpv6lAqb+pQKm/qUCpv6lAaYBpv2lBKb8pQOm/qUCpv2lBab6pQWm/aUBpgCmAKYBpv+lAKYApgCmAab/pQGm/qUDpv1ZA1r9WQJa/lkDWvxZBVr7WQNa/1n/WQNa/VkCWv9ZAFoBWv9ZAVr/WQFa/1kBWgBaAFr/WQFaAFoAWgBaAFoAWgBaAFr/WQNa/FkEWvxZA1r+WQJa/lkCWv5ZAlr+WQKm/aUFpvqlBqb6pQWm/aUCpv2lA6b+pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpv6lA6b+pQCmAqb8pQWm/KUCpgCm/6UBpv+lAab/pQGm/6UBpv+lAKYBpv6lA6b9WQJa/1n/WQJa/lkCWv5ZAVoAWv9ZAlr+WQBaAlr9WQNa/1n/WQJa/lkBWgBaAVr+WQJa/VkDWv9Z/1kCWv1ZBFr7WQVa/FkDWv9Z/1kBWgBa/1kCWv5ZAlr9WQRa/FkEpv2lAqb+pQOm/KUFpvqlB6b5pQam+6UDpgCm/qUDpv2lAqYApv+lAKYCpv2lBKb7pQSm/qUBpgCm/qUDpv6lAaYApv6lBKb7pQWm/aUApgKm/aUDpv6lAab/pQGmAFr/WQFa/1kBWv9ZAVr/WQFa/1kBWv5ZA1r9WQNa/lkBWv9ZAFoBWgBaAFoAWv9ZAFoDWvxZA1r+WQFaAFoBWv1ZBFr8WQRa/FkDWv9Z/1kDWvtZBVr9WQFaAVr9WQRa/KUDpv6lAaYApv+lAab/pQGm/6UApgGm/6UBpv+lAKYApgGm/6UApgGm/aUFpvulBKb9pQKm/qUCpv6lAqb/pf+lAaYApv+lAqb9pQOm/qUBpgCmAKYApgCmAKYApgCmAFoAWgBaAFoAWgBaAFr/WQJa/lkDWv1ZAlr/WQBaAVr/WQFa/1kAWgFa/1kBWv9ZAFoBWv9ZAVr/WQFa/1kAWgFa/1kBWv9ZAFoAWgFa/lkDWvxZBFr9WQJa/1kAWgCmAKYBpv+lAab+pQOm/aUCpv+lAKYCpv2lAqb/pQCmAab/pQGm/6UBpv6lA6b8pQWm/KUCpgCm/qUDpv2lA6b+pQGm/6UBpv+lAab/pQGmAKb+pQOm/aUDpv6lAab/pQFa/1kAWgJa/VkDWv1ZAloAWv5ZA1r9WQNa/lkAWgJa/VkDWv5ZAVoAWgBa/1kCWv1ZA1r+WQFaAFr/WQJa/VkEWvtZBVr8WQNa/lkBWgBa/1kBWgBa/1kCWv5ZAFoDpvulBqb5pQem+6UDpv6lAaYApgCmAab9pQOm/qUCpv6lAqb+pQGmAKb/pQKm/qUBpgCm/6UCpv2lA6b9pQOm/qUBpv+lAKYApgGmAKb+pQKm/qUCpv+l/6UCpv6lAqb+WQFaAFoAWgBaAFr/WQJa/lkBWgBa/1kBWgBaAFr/WQJa/FkFWv1ZAVoAWv9ZAVoAWgBa/1kBWv9ZAVr/WQFa/1kBWv9ZAFoBWv9ZAVr/WQFaAFr/WQFaAFr/WQFaAFr+pQOm/qUBpgCm/qUCpv+lAaYApv6lAqb+pQKm/6UApgCmAKYApgCmAKYBpv6lA6b9pQKmAKb+pQSm/KUDpv6lAaYApgCmAKb/pQKm/aUEpvylBKb8pQOm/6X/pQOm/VkCWv9ZAVr/WQFa/1kBWv9ZAVr/WQFaAFr+WQNa/VkDWv5ZAVr/WQJa/VkDWv1ZA1r9WQNa/VkCWv9ZAFoBWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVr+WQNa/VkDWv5ZAKYBpv+lAab/pQCmAab+pQKm/6UApgGm/qUCpv6lA6b+pQCmAab/pQCmAab/pQCmAqb8pQWm+6UEpv6lAKYBpv+lAab/pQGm/qUCpv+lAab/pQCmAKYBpv6lA6b8pQRa/VkBWgBaAFoAWgBaAFoAWgBaAFoAWgFa/lkDWv1ZAlr/WQBaAVr/WQFa/1kAWgFa/1kBWgBa/lkDWv1ZA1r+WQFa/1kBWv9ZAVr/WQFa/1kBWv5ZAlr/WQFa/1kAWgCmAab/pQGm/qUDpvylBKb9pQKm/6UApgCmAKYApgGm/6UBpv+l/6UDpv2lA6b9pQGmAKYBpv6lAqb/pf+lA6b9pQKm/6UBpv+lAab/pQGm/6UApgCmAab/pQCm/6UBpgFa/lkCWv5ZAVoAWgFa/lkCWv5ZAVoBWv5ZAlr+WQFaAVr9WQRa/VkBWgBaAFoAWgBaAFr/WQJa/1kAWgBaAFr/WQNa/VkBWgFa/lkCWv5ZAlr+WQNa/FkEWvxZBFr+pQCmAab+pQOm/qUBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv6lA6b9pQKm/qUCpv6lA6b8pQOm/6X/pQKm/qUCpv+lAKYApgGm/qUEpvulBKb+WQBaAlr9WQNa/FkFWvtZBVr7WQRa/VkCWv9ZAFoBWv9ZAVr+WQJa/1kBWv5ZA1r8WQRa/ln/WQNa/VkCWv9Z/1kDWv1ZAlr+WQJa/VkEWv1ZAlr+WQJa/VkEWv1ZAaYBpv6lAqb+pQKm/qUCpv6lAqb/pf+lAqb9pQSm/aUBpgCm/6UCpv6lAaYApv+lAqb9pQOm/qUApgGm/6UBpv+lAKYApgGm/6UBpv6lAqb/pQCmAab/pQCmAab+pQKm/1kAWgFa/1kBWv9ZAFoBWv9ZAVr/WQBaAVr/WQBaAFoBWv5ZA1r9WQFaAVr+WQJa/1kAWgFa/lkCWv5ZAloAWv5ZAlr/Wf9ZA1r8WQRa/FkDWv9ZAFoAWv9ZAVoAWgFa/aUEpvylA6b/pQCmAKYApgCmAKYApgGm/aUFpvqlBqb6pQam+6UEpvylBKb9pQKm/6X/pQOm/aUCpv+l/6UDpv2lAqYApv6lA6b9pQKm/6UBpv+lAab+pQKm/6UApgFa/lkCWv9ZAVr/WQFa/lkDWv5ZAlr9WQNa/lkCWv5ZAVoAWgBaAVr9WQRa/FkEWv1ZAVoBWv5ZAlr+WQJa/1kAWgBaAFoAWgFa/1kAWgBaAFoAWgBaAVr9WQVa+lkGWvulA6b/pQCmAab+pQOm/KUEpv2lAqb/pQCmAab+pQOm/aUCpv+lAab/pQGm/6UBpv+lAaYApv6lA6b+pQGmAKb/pQCmAab/pQGmAKb+pQOm/aUCpgCm/qUDpv2lAqb/WQBaAVr+WQJa/1n/WQNa/FkEWv1ZAVoAWgFa/lkCWv5ZAlr+WQJa/lkBWgBa/1kCWv1ZBFr7WQVa/VkAWgJa/lkBWgBa/1kBWgBa/1kCWv1ZA1r+WQFaAFr/WQJa/lkBpgCm/6UCpv6lAqb+pQKm/qUCpv6lA6b8pQSm/aUCpv6lA6b8pQSm/KUEpv2lAaYApv+lA6b9pQGm/6UCpv+lAKYApv+lAqb+pQKm/qUCpv6lAqb/pQCmAKYApgCmAKYBWv5ZAlr+WQJa/lkCWv9ZAFoBWv9Z/1kDWv1ZA1r+WQBaAVoAWgBa/1kCWv5ZAVoAWv9ZAlr+WQFaAFoAWv9ZAVr/WQNa/FkDWv5ZAVoBWv1ZA1r+WQFaAFoAWv9ZAaYApv+lAqb+pQGmAKb/pQGm/6UBpgCm/6UBpv+lAaYApv+lAab/pQCmAqb9pQOm/aUCpv+lAab/pQGm/6UBpv+lAab/pQGm/6UBpv+lAaYApv+lAab/pQCmAqb+pQGm/1kBWgBa/1kBWgBa/1kCWv1ZAlr/WQFa/1kAWgFa/lkDWv1ZA1r9WQJa/1kBWgBa/1kBWv9ZAlr+WQFa/1kBWgBaAFoAWv9ZAVr/WQFaAFr/WQFa/lkDWv1ZA1r9WQKm/6UBpv+lAab/pQCmAab/pQCmAab+pQKm/6UApgCmAKYBpv6lAqb+pQKm/qUDpvylA6b/pf+lA6b9pQGmAKYApgCmAKYApgCmAKYApgCmAKYBpv+lAKYApgGm/qUDpv1ZAloAWv5ZAloAWv9ZAVr+WQJa/1kCWv1ZAlr/WQBaAVr/WQFaAFr+WQNa/FkEWv5ZAFoBWv9ZAFoBWv9ZAVr/WQFa/lkDWv1ZAlr/WQBaAFoBWv5ZAlr+WQNa/VkCWv6lAqb/pQGm/6UApgGm/qUCpv6lA6b9pQKm/6X/pQOm/aUCpgCm/6UApgGm/6UCpv2lA6b9pQKmAKb/pQGmAKb+pQOm/qUBpgCm/6UBpgCmAKb/pQKm/aUEpvylA6b+WQFa/1kBWv9ZAlr8WQVa+1kFWvxZAlr/WQFaAFr/WQFa/1kBWv9ZAVr/WQFa/1kBWgBa/1kCWv1ZBFr8WQNa/1n/WQJa/lkBWgBa/1kBWgBa/1kBWv9ZAVoAWv9ZAVr/pQGm/6UCpvylBab8pQKmAKb+pQOm/qUBpv+lAaYApgCmAKb/pQGmAKYBpv6lAqb+pQGmAab+pQKm/6UApgGm/qUCpv+lAKYBpv2lBKb8pQSm/KUCpgGm/aUEpvylAloAWv9ZAVr/WQFa/1kBWv9ZAVr/WQBaAlr9WQRa+1kEWv5ZAVr/WQFa/lkDWv1ZAlr+WQJa/lkCWv5ZAVoAWgBa/1kCWv5ZAVoBWv1ZBFr8WQRa/VkCWv5ZAlr/WQBaAab+pQKm/qUCpv+lAKYBpv2lBKb9pQKm/6UApgCmAKYBpv6lAqb+pQGmAab9pQOm/qUBpgCm/6UApgKm/aUEpvulBab8pQOm/qUBpgCm/6UCpv6lAqb+pQKm/qUCpv6lAlr/WQBaAFoAWgBaAVr+WQJa/1kAWgFa/lkCWv9ZAFoBWv5ZAlr+WQJa/lkCWv5ZAlr+WQFaAFoAWgFa/lkCWv5ZAlr/WQBaAVr+WQJa/1kAWgFa/lkBWgBaAVr+WQKm/qUApgOm+6UFpv2lAKYCpv2lBKb8pQOm/qUApgKm/aUCpgCm/qUDpv2lAqYApv6lA6b+pQKm/qUBpv+lAqb+pQKm/qUCpv6lAqb+pQKm/6UApgCmAKYApgGm/qUCpv5ZAlr+WQJa/1kAWgFa/lkCWv9ZAFoBWv9ZAFoAWgFa/lkDWv1ZA1r9WQJa/1kBWgBa/1kBWv9ZAVr/WQFa/1kBWgBa/1kBWgBa/lkEWvtZBFr+WQBaAVr+WQNa/VkCpv6lAaYBpv+lAKYApgCmAKYBpv6lAqb/pQCmAab/pf+lA6b9pQKm/6UBpv+lAab/pQCmAqb+pQGm/6UBpv6lBKb7pQSm/aUCpv+lAab/pQCmAab/pQGm/6UBpv+lAab/WQFa/1kCWv1ZA1r+WQJa/lkCWv5ZAlr/WQBaAVr+WQJa/lkCWv9ZAFoAWgBa/1kDWv1ZAVoAWv9ZAlr/Wf9ZAVr/WQJa/lkBWgBa/1kCWv5ZAlr+WQJa/VkEWvxZA1r+pQGm/6UCpv2lBKb8pQOm/qUBpgCmAKYApgCm/6UCpv6lAqb+pQGmAKYApgGm/aUDpv2lBKb8pQOm/qUApgOm+6UFpv2lAKYCpv2lA6b+pQGm/6UBpgCm/6UBpv+lAVoAWgBa/1kCWvxZBlr6WQVa/VkAWgNa+1kFWvxZA1r/WQBaAFr/WQJa/lkCWv9ZAFoAWgBaAFoAWgBaAFr/WQJa/lkBWv9ZAVoAWv9ZAlr9WQNa/lkAWgJa/lkBWgBa/qUEpvulBab8pQOm/qUBpgCmAKYApv+lAqb+pQKm/qUBpv+lAqb9pQOm/qUApgKm/aUDpv2lA6b+pQGm/6UBpgCm/6UCpvylBab8pQOm/qUBpv+lAab/pQGm/6UBpv9ZAFoBWv9ZAFoBWv5ZA1r9WQNa/VkCWv9ZAFoCWv1ZA1r9WQJa/1kBWv9ZAVr/WQBaAVr/WQFa/1kBWv9ZAVr/WQFa/1kAWgFa/lkDWv1ZAVoBWv5ZAlr/WQBaAFoBWv6lA6b9pQKm/6UApgCmAab+pQKm/qUCpv2lBKb8pQSm/KUDpv6lAqb/pf+lAqb+pQOm/KUEpvylBKb9pQKm/6UApgGm/qUCpv+lAab/pQCmAab+pQKm/6UApgGm/6X/pQJa/lkBWgBa/1kCWv1ZAlr/WQFa/1kAWgBaAFoCWvxZA1r/Wf9ZA1r9WQFaAVr/WQFa/1kAWgBaAVoAWv9ZAVr+WQNa/VkDWv1ZAlr/WQBaAVr+WQJa/lkCWv9ZAFoApgCmAKYApgCmAab+pQKm/qUCpgCm/qUDpvylBKb+pQGm/6UApgCmAab/pQGm/aUEpv2lA6b9pQKm/qUCpgCm/6UBpv+lAKYCpv6lAaYApv+lAqb/pf+lAqb+pQKm/qUCWv5ZAlr/WQBaAFoBWv5ZA1r9WQJa/1kBWv9ZAVr/WQFa/1kBWgBa/1kBWv9ZAVoAWv9ZAVr/WQFaAFr/WQJa/lkBWgBa/1kCWv5ZAVr/WQJa/lkBWv9ZAFoCWv1ZAqYApv6lA6b9pQKm/6UBpv+lAKYBpv6lA6b+pQCmAab/pQGmAKYApv+lAaYApv+lA6b8pQOm/qUBpgCmAKb/pQGmAKb/pQKm/aUDpv2lAqYApv+lAab/pf+lA6b9pQKm/1kAWgFa/lkCWv9ZAFoAWgBa/1kCWv5ZAVr/WQFa/1kBWv9ZAVr/WQFa/1kBWgBa/1kBWv9ZAlr+WQFaAFr/WQJa/lkAWgJa/VkDWv1ZAlr/WQFa/1kAWgFa/1kBWv5ZA6b9pQOm/qX/pQOm/aUCpv+lAKYApgCmAKb/pQKm/qUBpgCm/6UBpgCm/6UCpv6lAab/pQKm/qUCpv6lAqb+pQKm/6UApgGm/qUDpv2lAqYApv+lAab/pQCmAaYApv9ZAVr/WQFa/1kBWgBa/lkDWv1ZAloAWv5ZA1r9WQJa/1kBWv9ZAVr/WQFa/1kAWgFa/1kBWv9ZAVr/WQJa/VkDWv5ZAlr/WQBaAFoAWgBaAFoAWgFa/lkBWgBa/1kBWgCm/6UCpv2lA6b9pQSm/KUDpv6lAqb+pQKm/qUBpgGm/aUEpvylA6b+pQGmAKb/pQKm/qUBpgCm/qUEpv2lAaYApv+lAaYApgCm/6UDpvylA6b/pf+lAqb+pQKm/6UAWgBaAFoAWgFa/1kAWgFa/lkDWv1ZAlr/WQBaAVr/WQBaAFoBWv9ZAlr8WQVa/FkDWv9Z/1kCWv5ZAlr+WQJa/1kAWgBaAFoAWgBaAFr/WQFaAFr/WQFa/1kAWgFa/1kBpgCm/qUDpv6lAaYApv+lAaYApv+lAqb9pQOm/qUBpgCm/6UBpv+lAaYApgCm/6UBpv+lAaYApgCm/6UBpv+lAaYApgCm/6UBpv+lAaYBpv6lAab/pQGmAKYApv+lAab/WQFaAFr/WQJa/VkDWv5ZAVoAWv9ZAlr9WQNa/lkAWgJa/FkEWv5ZAFoBWv5ZAlr+WQJa/1kAWgFa/1kAWgBaAFoBWv9ZAVr+WQFaAFoAWgBaAVr+WQFaAFoAWgFa/qUCpv6lAqb+pQGmAKb/pQKm/aUDpv2lA6b9pQOm/aUDpv6lAab/pQCmAab/pQKm/qUApgGm/6UBpgCmAKYApv+lAaYApv+lAqb+pQGmAKb/pQGmAKb/pQKm/aUDpv6lAFoBWgBa/lkDWv1ZAlr/WQFa/lkDWv1ZAlr/WQFa/1kAWgFa/1kAWgFa/1kBWv9ZAFoAWgFa/1kBWv9ZAVr+WQJa/1kBWv9ZAVr+WQJa/1kAWgBaAFoAWgFa/lkCWv2lBKb+pf+lA6b8pQOmAKb9pQSm/aUBpgGm/qUCpv6lAqb/pQCmAab+pQKm/6X/pQKm/6UApgCm/6UCpv6lAqb+pQGmAKb/pQGmAKb/pQGm/6UBpv+lAab/pQGmAKb/pQFa/1kBWgBa/1kBWv9ZAVoAWv9ZAVoAWgBa/1kBWv9ZAlr/Wf9ZAlr9WQNa/lkBWgBa/1kCWv1ZA1r9WQNa/VkDWv5ZAFoCWv1ZA1r+WQBaAlr9WQNa/lkBWv9ZAVr/WQGm/6UBpgCm/6UBpv6lAqb/pQGm/qUCpv6lAaYBpv6lAqb+pQGmAKYApgCmAKb/pQGmAKb/pQGmAKb/pQKm/qUApgKm/qUCpv6lAaYApgCmAKYApgCm/6UCpv6lAqb+WQFaAFoAWgBaAFr/WQJa/lkCWv9ZAFr/WQFaAFoAWgBa/1kCWv1ZBFr8WQJaAFr/WQFa/1kAWgFa/lkCWv9ZAFoAWgBaAFoAWgBaAFoBWv9ZAFoAWgBaAFoBWv9ZAFoApv+lAaYApv+lAab/pQGm/6UApgGm/6UCpv2lA6b9pQOm/qUBpgCm/6UCpv6lAaYApgCmAKYBpv2lBKb7pQam+6UDpv6lAaYApgCmAKb/pQKm/qUCpv6lAaYApv+lAlr9WQRa/FkDWv1ZA1r+WQJa/lkBWgBaAFoAWgBaAFoAWgFa/lkCWv5ZAVoCWvtZBlr6WQZa+1kDWv5ZAVoAWgBaAFoAWv9ZAVr/WQFaAFr/WQBaAVr/WQFaAFr+WQJaAKYApv+lAab+pQOm/qUApgGm/qUDpvylBKb9pQKm/6UApgCmAab+pQOm/aUCpgCm/6UApgKm/aUEpvulBab7pQWm/aUApgKm/aUCpgCm/6UBpv+lAab/pQCmAKYBpv+lAVr+WQFaAVr/WQBaAVr/WQFa/1kAWgFa/1kBWv9ZAFoBWv5ZAlr/WQBaAFoAWgBaAFoAWv9ZAlr+WQFaAFr/WQJa/lkBWgBa/1kBWgBa/1kBWv9ZAVr/WQFa/1kBWgCm/6UBpgCm/6UCpv2lA6b+pQGmAKb/pQGmAKb/pQKm/qUBpgCm/6UCpv6lAaYApv+lAab/pQGmAKb/pQGm/qUEpvulBKb+pQCmA6b8pQOm/aUDpv+lAKYBpv2lBKb9pQJa/1kAWgFa/1kAWgFa/1kBWv9ZAFoBWv9ZAVr/WQFa/1kBWv9ZAVr/WQFaAFr/WQJa/VkEWv1ZAVoAWv9ZAlr+WQJa/lkBWgBa/1kCWv5ZAVoBWv1ZBFr8WQNa/1kAWgCmAKYApgGm/qUCpv2lBab7pQSm/KUDpv+lAab/pQGm/6UApgGm/qUDpv2lAqb/pQCmAab+pQOm/aUDpv2lAqb/pQCmAKYApgCmAKYApgCm/6UDpvylBKb9pQGmAKYAWgBaAFr/WQJa/VkEWvxZA1r+WQJa/lkCWv5ZAlr+WQNa/FkDWv9ZAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWv9ZAlr+WQJa/1n/WQNa/FkEpv2lAqb/pQGm/6UBpv+lAab+pQOm/aUEpvulBKb+pQCmAqb+pQCmA6b7pQWm/KUDpv6lAqb+pQGm/6UCpv6lA6b8pQOm/qUCpv+lAKYApv+lA6b8pQSm/aUBpgCmAFoAWgFa/lkBWgBaAFoBWv9ZAFoBWv5ZA1r9WQNa/VkDWv5ZAVr/WQFa/1kBWgBa/1kAWgJa/VkDWv5ZAVoAWgBaAFoAWgBaAFoAWgBaAVr9WQNa/lkBWgBa/1kBWv9ZAab/pQGm/6UBpv+lAab/pQCmAab/pQGm/6UApgGm/6UBpv+lAaYApv+lAab/pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpv+lAKYBpv+lAab/pQCmAab/pQGm/6UBpv+lAVr/WQFa/1kBWv5ZA1r8WQVa+1kDWv9ZAFoBWv9ZAFoAWgFaAFr/WQFa/lkDWv5ZAVr/WQFa/1kCWv1ZA1r+WQFaAFr/WQFaAFr/WQJa/lkBWgBaAFr/WQJa/lkCWv+l/6UCpv+lAKYApgCmAKYBpv6lAqb+pQKm/qUBpgCm/6UCpv2lA6b9pQOm/aUDpv2lA6b+pQGm/6UCpv2lA6b+pQGmAKb/pQGmAKb/pQGm/6UBpgCm/6UBpv+lAaYApv9ZAVr/WQFa/1kBWv9ZAVr/WQFa/lkDWv5ZAVoAWv9ZAVoAWgBa/1kDWvtZBlr6WQVa/FkEWv1ZAVoAWv9ZAlr/Wf9ZAlr+WQFaAFoAWgBaAFoAWv9ZAlr+WQFaAFr/pQKm/aUDpv2lA6b+pQGm/6UBpv+lAab/pQGm/6UBpv+lAab/pQCmAqb8pQSm/aUBpgGm/qUCpv2lBKb9pQKm/6UApgCmAab/pQGm/6UApgCmAab/pQGm/qUCpgCm/6UCWvxZBVr8WQNa/1n+WQNa/lkBWgFa/VkDWv5ZAlr+WQFa/1kBWgBa/1kBWv9ZAVr/WQFaAFr/WQJa/VkDWv9Z/1kCWv5ZAlr+WQJa/lkCWv5ZAlr+WQJa/lkBWgBa/1kCpv6lAaYApv+lAqb9pQOm/qUCpv6lAKYBpv+lAqb+pQGm/6UBpv+lAaYApv+lAaYApv6lA6b9pQOm/aUDpv2lA6b9pQKm/6UBpv+lAKYApgGm/6UApgGm/qUDpv2lAVoCWvxZBVr7WQRa/lkAWgFa/lkDWv5ZAFoBWv5ZA1r9WQNa/VkCWv9ZAFoBWv9ZAVr/WQFa/lkDWv1ZA1r+WQBaAVr/WQBaAVr+WQNa/VkCWv9Z/1kDWv1ZAlr+WQJa/6UApgGm/qUDpv6lAab+pQOm/aUEpvylAqb/pQGm/6UBpv+lAab/pQGmAKb/pQGmAKb/pQKm/qUBpgGm/qUCpv2lBKb9pQKm/qUBpgCmAKYApv+lAqb+pQKm/qUCpv9ZAFoBWv5ZA1r+WQFaAFr+WQNa/lkBWgBa/1kBWv9ZAVr/WQJa/lkBWv9ZAVoAWgBa/1kCWv5ZAlr+WQFaAFoAWgFa/lkCWv5ZAlr+WQFaAFr/WQNa/FkEWvxZBFr9WQOm/qUApgKm/aUDpv6lAKYBpgCm/qUDpvylBKb+pQCmAKYApgCmAab+pQKm/aUFpvqlBab8pQOm/qUCpv6lAqb+pQGmAKYBpv+lAKb/pQKm/6UBpv6lAqb+pQOm/aUCpv9ZAFoBWv9ZAVr/WQBaAFoBWv9ZAVr/WQBaAVr/WQFa/1kBWv5ZA1r9WQJa/1n/WQJa/lkCWv5ZAlr+WQFaAFoAWgBaAFr/WQJa/1kAWgBaAFoBWv5ZAlr/WQFaAFr+pQKm/6UBpgCm/qUDpv2lAqb/pQCmAab/pQGm/qUCpv+lAab/pQGm/qUCpv+lAKYBpv6lAqb/pQCmAab+pQOm/aUCpv+lAab/pQGm/6UApgGm/6UApgGm/6UApgGm/qUDWvxZBVr7WQRa/ln/WQNa/VkCWv9ZAFoAWgBaAFoAWgBaAFr/WQJa/VkDWv5ZAVoAWgBa/1kBWgBa/1kCWv1ZA1r+WQFa/1kAWgFaAFr/WQFa/1kAWgJa/VkDWv5ZAKYBpgCm/qUEpvulBKb+pQGm/6UApgGm/qUDpv2lAaYBpv2lBKb8pQOm/qUCpv2lBKb8pQOm/6X/pQGmAKb/pQKm/qUBpv+lAab/pQGm/6UBpgCm/6UBpv+lAqb+pQGmAFr/WQNa/FkEWvxZBFr9WQFaAVr+WQJa/1n/WQNa/FkDWv5ZAlr+WQJa/lkCWv5ZAlr+WQJa/lkDWvxZBVr6WQZa+1kFWvxZAlr/WQFa/1kBWv9ZAVr/WQFa/1kBWv9ZAKYBpv+lAab/pQCmAab+pQOm/aUCpv+lAKYApgGm/qUCpv+l/6UDpvylBKb9pQKm/6X/pQOm/KUFpvulBKb9pQKm/6UApgGm/6UApgGm/aUEpv2lAaYBpv6lAaYApgBa/1kDWvxZBFr8WQRa/FkEWv1ZAlr/WQBaAFoBWv5ZAlr+WQJa/lkCWv1ZBFr8WQNa/lkBWgBa/1kBWgBaAFoAWgBaAFr/WQNa+1kGWvtZBFr9WQFaAFoAWgFa/1kAWgCmAab+pQOm/KUEpv2lAqb+pQKm/6X/pQOm/KUDpv+lAKYApgGm/aUEpv2lA6b9pQKm/qUCpv+lAab+pQKm/qUCpv6lAqb/pQCmAab+pQKm/6UBpv+lAKYBpv6lBKb7WQNa/1kAWgFa/1n/WQJa/lkCWv9ZAFoAWgBaAFoBWv9ZAFoBWv5ZA1r8WQVa+1kEWv5Z/1kEWvtZBVr8WQNa/VkDWv5ZAVoAWv9ZAVoAWv9ZAVoAWgBaAFr/WQJa/lkCpv6lAaYApv+lAqb9pQSm/KUDpv6lAaYApgCmAKb/pQKm/qUBpgCmAKYApgCmAKYApgGm/6UBpv6lA6b9pQKm/6UBpv+lAKYApgCmAKYApgCmAKYBpv6lAaYApgCmAKYAWgBa/1kCWv5ZAVoAWv9ZAVr/WQJa/VkEWvtZBFr+WQJa/lkBWgBa/1kCWv5ZAVoAWv9ZAlr+WQFaAFr/WQJa/lkBWgBaAFr/WQFaAFr/WQJa/VkDWv5ZAVoAWv9ZAab/pQGmAKb/pQGm/6UApgKm/aUDpv2lA6b+pQGm/6UBpv+lAqb9pQKmAKb/pQGm/6UApgGm/6UBpv+lAKYBpv+lAKYBpv6lA6b9pQOm/KUEpv2lAqb/pQCmAKYBpv+lAVr+WQJa/1kCWv5ZAFoAWgBaAVr/WQBaAVr9WQVa+lkGWvtZA1r/Wf9ZA1r8WQRa/VkBWgFa/VkEWvxZBFr9WQJa/lkBWgBaAFoAWgBa/1kCWv5ZAlr+WQJa/lkDWvylBab7pQOm/6UApgCmAab+pQKm/qUBpgCmAab+pQGmAKb/pQOm/KUDpv6lAaYApgCmAKYApgCm/6UCpv2lBKb9pQGmAKb/pQGmAab9pQSm/KUDpv+l/qUEpvylA6b+pQFaAFr/WQFa/1kCWv5ZAVoAWv9ZAlr+WQJa/lkBWgBa/1kDWvxZAloAWv9ZAlr+WQFa/1kBWv9ZAlr9WQNa/VkCWgBa/lkEWvtZBFr9WQNa/lkCWv1ZA1r9WQNa/lkCWv6lAab/pQGmAab+pQKm/qUBpgGm/qUCpv6lAaYApgCm/6UBpgCm/6UCpv2lA6b+pQKm/qUBpgCm/6UCpv6lAqb9pQOm/qUBpgCmAKYApgCm/6UBpgCm/6UCpv6lAab/WQJa/VkDWv9Z/1kDWvxZBFr9WQJa/1kAWgJa/VkDWv1ZAloAWgBa/1kCWv1ZA1r+WQJa/lkBWv9ZAlr+WQJa/VkCWgFa/lkCWv1ZA1r+WQJa/lkBWgBa/1kCWv5ZAlr+pQGmAKYApgCmAKYApgCmAKb/pQKm/6UApgCm/6UCpv6lAqb+pQKm/6X/pQKm/qUCpv+lAKYApgCmAKYBpv6lAqb+pQKm/qUDpvylBKb8pQOm/6UApgCmAKYApgGm/1kAWgBaAFoBWv9ZAFoAWv9ZAlr+WQJa/lkBWgBaAFoAWgFa/lkCWv9ZAFoBWv9ZAFoBWv5ZA1r8WQVa+1kEWv1ZAVoAWgFa/lkCWv1ZBFr8WQRa/VkBWgFa/lkCWv9ZAab+pQOm/KUFpvulBKb9pQOm/aUDpv2lA6b+pQGmAKb/pQGmAKYApgCmAKb/pQKm/qUCpv6lAaYApgCmAab9pQSm+6UFpv2lAaYApgCm/6UCpv2lA6b+pQGm/6UCpv2lAlr/WQFa/1kBWv5ZAlr/WQFa/lkCWv5ZAlr+WQNa/VkCWv9Z/1kDWv5ZAFoCWvxZBFr+WQBaAVr+WQJa/lkDWv1ZAVoAWgBaAVr/WQFa/VkFWvtZBFr9WQJa/lkCWv6lAaYApgCmAKYApv+lAqb+pQKm/6UApgCmAab9pQSm/KUDpv+lAKYApv+lAqb+pQOm/aUCpv+lAKYBpv+lAab/pQGm/qUDpv2lA6b9pQOm/aUEpvulBab7pQWm/KUDpv1ZAlr/WQBaAVr+WQNa/FkEWv1ZAlr/WQBaAFoBWv9ZAFoAWgBaAVr/WQBaAVr/WQFa/1kBWv9ZAVr/WQBaAVr/WQBaAVr+WQJa/lkCWv9ZAVr/WQBaAVr/WQJa/VkDpv2lA6b+pQGm/6UBpv+lAab/pQGm/qUDpv2lAqb/pQCmAKYBpv6lAqb+pQGmAab9pQSm/KUCpgGm/aUEpv2lAaYApgCm/6UDpvylA6b+pQGmAKYApv+lAqb9pQOm/qUBWgBaAFr/WQFaAFr/WQFaAFr/WQFa/1kBWgBa/1kBWv5ZA1r9WQJa/1kAWgFa/lkCWv5ZAlr/WQBaAVr/WQBaAVr/WQBaAVr/WQFaAFr+WQJa/1kBWv9ZAFoAWgBaAFoApgCmAKYApgCm/6UDpvylBKb9pQKm/6UApgCmAKYBpv+lAKYApv+lAqb+pQKm/qUCpv6lAqb9pQSm/KUEpvylBKb7pQWm+6UFpvylA6b9pQKmAKb/pQKm/qUBpgCmAFoAWgBa/1kCWv5ZAlr+WQFaAFoAWgBaAFoAWgBaAFoAWgBa/1kCWv9Z/1kDWvtZBlr6WQVa/VkBWgBa/1kBWgBa/lkDWv1ZA1r9WQJa/1kAWgFa/lkCWv5ZAlr+WQFaAKYApgCmAKb/pQKm/qUCpv6lAaYBpv6lAqb+pQKm/6UApgCmAKYApgGm/qUBpgCm/6UBpgGm/aUEpvulBab9pQGmAKb/pQGmAKb/pQGm/6UBpv+lAab/pQCmAaYApv9ZAVr/WQBaAlr9WQNa/VkDWv1ZA1r+WQBaAlr9WQNa/lkBWv9ZAlr9WQNa/lkCWv5ZAVr/WQFaAVr+WQFaAFr/WQJa/lkBWgFa/VkDWv5ZAVoAWv9ZAVr/WQFa/1kBWv+lAab/pQCmAqb9pQOm/aUCpv+lAaYApv+lAaYApv+lAqb+pQKm/qUCpv+lAKYBpv6lAaYBpv+lAKYBpv6lAqb/pQCmAab/pQCmAab+pQOm/aUCpv+lAKYBpv+lAKYApgBaAFoAWgBaAFoAWgBa/1kCWv5ZAlr/Wf9ZA1r8WQVa/FkCWv9ZAFoBWv9ZAVr/WQBaAVr+WQNa/FkFWvtZBFr+WQBaAVoAWv9ZAVr/WQJa/lkCWv5ZAFoCWv5ZAlr+pQGmAKb/pQKm/qUBpgCm/6UCpv6lAqb+pQGmAKb/pQOm/KUEpvylA6b+pQKm/qUDpvylA6b/pQCmAab+pQKm/qUCpv+l/6UCpv6lAaYApgCm/6UDpvulBab8pQOm/qUBWgBaAFoAWv9ZAlr+WQNa/VkCWv5ZA1r9WQNa/VkCWgBa/1kAWgFa/lkDWv1ZAlr/WQBaAVr/WQFa/lkDWvxZBVr8WQJa/1kAWgBaAVr+WQNa/FkEWv1ZAVoAWgBaAKYApgCm/6UCpv6lAqb+pQKm/qUCpv+l/6UCpv6lAqb+pQGmAKYApgCm/6UCpv2lBKb7pQWm/aUApgGm/6UBpgCmAKb/pQKm/qUBpgGm/aUEpv2lAqb/pQCmAKYApgGm/1kAWgFa/lkCWv9Z/1kCWv1ZA1r+WQFa/1kBWv5ZA1r+WQBaAlr9WQNa/VkCWv9ZAVoAWv5ZAlr/WQFa/1kBWv9ZAVr/WQFa/1kBWgBa/1kBWv9ZAVr/WQFa/1kBWv9ZAab/pQGm/6UBpv6lA6b+pQGmAKb+pQOm/qUBpv+lAab/pQKm/qUApgGm/6UCpv6lAaYApv+lAqb9pQOm/qUBpv+lAaYApv+lAKYBpv6lBKb7pQOmAKb+pQOm/KUEpv1ZA1r9WQJaAFr+WQNa/VkCWgBa/1kAWgFa/lkDWv1ZA1r9WQJa/1kBWv9ZAVr+WQJa/1kAWgFa/lkCWv5ZAlr/WQFa/1kAWgBaAVoAWv9ZAVr/WQBaAVoAWv9ZAVr/WQCmAqb9pQOm/aUCpgCmAKYApv+lAab/pQKm/qUBpgCmAKYApgCm/6UCpv6lAqb/pf+lA6b8pQOm/6UApgGm/qUCpv2lBKb8pQOm/qUBpv+lAab/pQKm/qUBpgCmAKYAWgBaAFoAWgFa/VkEWv1ZAlr/Wf9ZAlr/WQFa/lkCWv5ZAlr/Wf9ZAlr+WQJa/lkBWgBaAFoAWv9ZAVoAWv9ZAlr9WQNa/VkDWv1ZA1r+WQFaAFr/WQJa/lkDWvxZBFr8pQSm/aUCpv6lAqb+pQKm/qUCpv6lA6b9pQGmAKYApgCmAab+pQKm/qUBpgCmAKYApgCmAKYApgCmAKYApgCmAKb/pQKm/qUBpgCm/qUDpv2lA6b9pQOm/aUDpv6lAaYAWgBaAFoAWgFa/lkDWvxZBFr9WQJa/1kAWgFa/lkCWv5ZAlr/WQBaAVr+WQJa/lkDWvxZBVr6WQZa+1kEWvxZA1r/Wf9ZA1r8WQNa/1n/WQJa/VkDWv5ZAVoAWv9ZAab/pQGm/6UCpv6lAab/pQGmAKYApgCm/6UBpgCmAKYApgCm/6UBpgCm/6UDpvylA6b+pQGmAab+pQKm/qUBpgGm/qUCpv6lAqb+pQGmAab+pQKm/qUBpgGm/qUCpv6lAVoAWgBaAFr/WQJa/lkCWv9ZAFoAWgFa/1kAWgFa/1kAWgFa/1kAWgFa/lkDWv1ZAlr/WQBaAVr+WQJa/1kAWgFa/VkFWvpZBlr7WQRa/VkCWv5ZAlr+WQNa/FkDWv6lAaYBpv6lAqb9pQSm/aUBpgGm/qUBpgGm/aUEpv2lAKYDpvulBqb7pQOm/qUCpv6lAqb+pQKm/qUCpv6lAaYBpv6lAqb/pQCmAKYApgCmAab/pQCm/6UCpv+l/6UDpvtZBVr+Wf9ZAlr+WQJa/1kAWgBaAFoAWgBaAFoAWgBaAFr/WQJa/lkCWv9Z/1kCWv9ZAFoBWv5ZAlr/WQBaAVr+WQNa/VkCWv9ZAFoAWgFa/lkCWv9ZAFoAWgBaAFoBWv6lAqb/pQCmAab+pQKm/6UApgCmAKYApgCmAKb/pQKm/qUBpgCm/6UCpv6lAqb+pQKm/aUEpvylA6b/pf6lA6b9pQKmAKb/pQCmAab+pQOm/qUApgGm/6UApgKm/aUDWv1ZA1r+WQBaAlr9WQNa/1n+WQRa+1kEWv5ZAVr/WQBaAFoBWv9ZAFoAWgBaAVr/WQFa/lkDWv1ZA1r+WQBaAlr9WQNa/lkAWgJa/VkDWv5ZAVoAWv9ZAlr+WQJa/lkBpgGm/qUDpvulBqb7pQOmAKb9pQSm/KUEpv2lAqb/pQCmAKYApgGm/qUDpv2lAqb/pf+lAqb+pQKm/qUCpv2lA6b9pQOm/qUApgKm/aUCpgCm/qUDpv6lAKYBpv6lAloAWv5ZA1r8WQRa/VkCWv9ZAFoBWv9ZAVr+WQJa/1kBWgBa/lkDWv1ZAlr/WQBaAVr/WQFa/lkCWv9ZAFoBWv9ZAFoBWv9ZAVr+WQNa/VkDWv1ZAlr/WQFaAFr+WQJa/6UBpgCm/qUDpvylBab7pQSm/qUApgCmAab+pQOm/aUCpv+lAKYBpv6lAqb+pQKm/6UApv+lAqb+pQGmAab+pQKm/qUBpgCmAab+pQKm/qUBpgGm/aUEpvylA6b+pQGmAFoAWv9ZAlr9WQRa/FkDWv5ZAVoAWv9ZAVoAWv9ZAVr/WQFa/1kBWv5ZA1r9WQNa/VkCWv5ZA1r+WQFaAFr+WQNa/lkBWgBa/lkDWv1ZA1r9WQJa/1kAWgJa/VkDWv6lAaYApgCm/6UDpv2lAqb/pf+lA6b9pQKm/qUBpgGm/qUCpv2lA6b+pQKm/qUCpv6lAqb+pQKm/qUDpvylBKb9pQKm/6UApgCmAKYBpv6lAqb/pf+lA6b9pQKm/6UApgBaAVr/WQBaAVr/WQFa/1kAWgFa/1kBWgBa/1kBWv5ZA1r9WQNa/VkCWv9ZAFoAWgBaAVr/WQBaAFoAWgFa/1kBWv9ZAVr+WQNa/VkDWv1ZA1r9WQJa/1kAWgFa/1kApgCmAab+pQKm/qUCpv+lAab+pQGmAab+pQKm/6UApgGm/qUBpgGm/6UBpv+lAKYBpv+lAab/pQGm/6UBpgCm/qUDpv6lAab/pQCmAaYApgCm/6UApgGm/6UCpv2lA6b9WQJa/1kBWv9ZAVr+WQNa/VkDWv1ZAlr/WQBaAVr/WQFa/1kAWgBaAVr+WQJa/1kAWgBa/1kCWv9ZAFoAWgBaAFoCWvxZBFr9WQJa/1kAWv9ZA1r8WQRa/FkDWv9ZAFoApv+lAqb/pQCmAKb/pQKm/qUBpgCm/6UCpv6lAaYApv+lAqb+pQGmAKb/pQKm/qUBpgCmAKYApv+lAaYApgCmAKb/pQCmAab/pQGm/qUCpv+lAKYBpv6lAqb/pQCmAVr+WQJa/1kAWgFa/lkDWv1ZA1r9WQNa/lkCWv5ZAVoAWgBaAFr/WQFaAFr/WQJa/VkDWv5ZAVoAWgBaAFr/WQJa/1n/WQNa+1kGWvpZBlr7WQRa/VkCWv5ZAloAWv5ZA6b9pQGmAab+pQKm/6X/pQKm/qUBpgCmAKb/pQOm/KUDpv+lAKYApgGm/qUCpv6lAqb/pQCmAKb/pQKm/6X/pQKm/qUCpv6lAaYApgCmAab+pQGm/6UBpgCmAKYApv9ZAVr/WQFaAFr/WQFa/1kBWv9ZAVr/WQFa/1kBWv9ZAVoAWv9ZAVr/WQFa/1kBWv9ZAFoBWv9ZAFoBWv5ZAlr/WQBaAFoBWv5ZAlr+WQFaAFoAWgBa/1kBWgBa/1kCWv2lA6b9pQSm+6UEpv+l/qUEpvulBKb+pQGmAKb/pQGm/6UCpv6lAqb+pQCmAqb9pQSm/aUBpgCm/6UBpgCm/6UCpv6lAab/pQGmAKb/pQGm/6UBpgCmAKb+pQOm/qUBpgBa/1kBWgBa/1kBWv9ZAVr/WQFa/1kAWgFa/1kBWgBa/1kBWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFr/WQJa/lkCWv5ZAVr/WQFaAFoAWv9ZAVr/WQFaAFr/WQJa/lkBpgCmAKYBpv6lAaYBpv6lA6b8pQSm/aUCpv+lAKYApgGm/6UApgGm/qUCpv+lAKYApgGm/qUCpv6lAqb/pQCmAKYApgCmAab+pQKm/6X/pQOm/KUEpv2lAqb+pQKm/qUCWv9Z/1kCWv5ZAlr+WQFaAFr/WQNa/FkEWv1ZAVoAWgFa/1kBWv5ZAVoBWv5ZA1r8WQNa/1kAWgBaAFoAWgBaAFoAWgBaAFr/WQJa/lkCWv5ZAVoAWgBaAFoAWv9ZAab/pQGmAKb/pQCmAab/pQGm/6UApgGmAKb/pQGm/6UBpgCmAKb/pQGm/6UCpv+lAKYApv+lAqb+pQGmAKYApv+lAab/pQGm/6UBpv+lAqb+pQGm/6UBpgGm/qUBpv+lAVoAWgBa/1kBWgBa/1kCWv5ZAFoCWv1ZA1r+WQBaAVr/WQFa/1kBWv9ZAVoAWv9ZAVoAWv9ZAVoAWv9ZAlr9WQJa/1kCWv1ZA1r9WQJa/1kAWgBaAVr+WQNa/FkEWv1ZAaYBpv6lA6b9pQKm/qUCpv+lAKYBpv6lA6b9pQKm/6UApgKm/aUDpv6lAKYCpv6lAaYApv+lAqb+pQGm/6UBpgCm/6UBpv+lAKYBpv+lAab/pQGm/6UBpv+lAab/pQFa/1kAWgFa/1kAWgFa/1kAWgBaAVr/WQFa/1kAWgFaAFr+WQNa/FkEWv1ZAlr/Wf9ZA1r7WQZa+lkFWv1ZAVoAWv9ZAlr9WQNa/lkBWgBa/1kBWv9ZAlr9WQRa+1kFWvylAqYApv6lAqYApv6lA6b9pQKm/6UApgGm/6UBpv+lAKYBpv+lAKYBpv6lA6b9pQKm/6UBpv+lAab/pQGm/6UCpv6lAaYApv+lAab/pQKm/aUEpvulBKb+pQGmAKb+pQNa/lkBWgFa/VkCWgBa/lkEWvxZA1r9WQNa/FkFWvxZA1r9WQJa/1kBWv9ZAVr+WQNa/lkAWgFa/1kBWgBa/1kAWgFa/1kAWgFa/1kAWgFa/lkDWv1ZA1r9WQNa/VkDpv2lA6b+pQGmAKb+pQOm/aUEpvulBab7pQSm/aUCpv6lA6b8pQSm/aUBpgCmAKYApgCmAKb/pQKm/qUCpv6lAqb+pQKm/qUCpv+lAKYBpv6lAqb/pQCmAab/pQCmAab/WQFa/1kBWv5ZA1r+WQFaAFr+WQNa/VkDWv1ZAlr/WQBaAFoAWgFa/lkBWgFa/lkCWv9Z/1kDWv1ZAVoBWv9ZAFoBWv5ZAlr/WQBaAVr9WQNa/lkBWgBa/1kAWgJa/aUDpv6lAaYApv+lAqb9pQSm/KUDpv6lAab/pQGmAKb/pQGm/6UBpv+lAaYApv+lAaYApv+lAqb+pQGmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFr/WQFaAFr/WQJa/VkDWv1ZAloAWv5ZBFr6WQda+VkFWv1ZAVoBWv5ZAVoAWv9ZAlr+WQFaAFr/WQJa/lkBWgBaAKYApv+lAab/pQGmAKYApv6lA6b9pQKmAKb/pQGmAKb+pQOm/aUDpv6lAKYBpv+lAab/pQCmAab/pQGm/6UBpv6lBKb7pQSm/qUApgGm/6UApgCmAKYApgCmAab+pQFaAFoAWgFa/1kAWgBaAFoAWgFa/lkCWv9ZAFoBWv5ZAloAWv9ZAlr9WQNa/lkBWgBa/1kCWv5ZAVr/WQFaAFoAWgBa/1kBWgBaAFoAWv9ZAlr+WQJa/lkCWv5ZAlr/WQCmAab+pQOm/aUCpv+lAKYBpv+lAab+pQOm/KUFpvylAqb/pQGm/6UCpv2lA6b9pQOm/qUCpv6lAaYApgCmAab+pQGmAKYApgCmAKb/pQKm/qUCpv2lBKb8pQOm/6X/WQJa/VkEWvxZA1r+WQFaAFoAWv9ZAlr+WQFa/1kBWgBaAFr/WQBaAVoAWgBa/1kBWv9ZAlr+WQJa/lkBWgBaAFoAWgBaAFoAWgBaAFr/WQJa/1kAWv9ZAlr9WQRa/VkBpgCmAKb/pQKm/qUCpv+l/6UDpvylBKb9pQKmAKb+pQOm/aUDpv6lAab/pQKm/qUBpgCmAKYApgCmAKYApv+lA6b8pQSm/aUBpgGm/qUDpv2lAqb/pQCmAab/pQCmAab/WQFa/1kAWgBaAlr9WQNa/VkCWv9ZAVr/WQJa/VkDWv5ZAVoAWgBaAFoBWv5ZAlr+WQJa/1kAWgFa/1kAWgBaAVr+WQNa/VkCWgBa/1kAWgFa/1kBWv9ZAVr+WQNa/aUCpv+lAKYApgCmAab/pQCmAab+pQKm/6UApgGm/6UApgGm/6UApgKm/aUDpv6lAaYApv+lAaYApv+lAqb+pQCmAqb9pQOm/6X/pQGm/6UBpgGm/qUBpv+lAaYApgCm/1kBWv9ZAVr/WQFa/1kCWv1ZA1r9WQNa/lkCWv1ZA1r9WQNa/lkBWv9ZAVr+WQNa/lkBWv9ZAVr/WQJa/lkBWv9ZAlr+WQJa/lkBWgBaAFr/WQJa/VkDWv5ZAVoAWv+lAab/pQKm/qUBpgCm/6UCpv6lAaYBpv2lBab6pQWm/aUBpgGm/qUCpv6lAqb/pQGm/qUCpv+lAab/pQCmAKYBpv+lAKYApgCmAKYApgGm/qUCpv6lAqb/pQCmAab/pQBaAVr+WQNa/VkDWvxZBFr9WQJa/1kAWgFa/lkDWvxZBFr9WQJa/1kAWgFa/VkFWvpZBVr9WQFaAFr/WQJa/lkBWgBa/lkEWvxZBFr8WQNa/lkCWv5ZAlr+WQFaAVr9WQSm/aUBpgCm/6UCpv6lAqb+pQGmAKb/pQKm/qUBpv+lAaYApv+lAqb9pQSm+6UGpvqlBab9pQCmAqb+pQGmAKb/pQGmAKb/pQGmAKb/pQKm/qUBpgCm/6UCpv6lAqb9WQNa/lkBWgBa/lkDWv1ZA1r9WQJa/1kAWgFa/1kBWv9ZAFoBWv9ZAVoAWv9ZAVoAWv9ZAVoAWv9ZAlr+WQFaAFoAWgBaAFoAWgBaAFoBWv5ZA1r8WQVa+1kFWvtZBFr+pQGm/6UBpv6lA6b+pQCmAqb9pQOm/qUApgKm/qUBpgCm/qUDpv6lAaYApv6lA6b+pQGmAKb/pQGm/6UBpv+lAab/pQGm/6UBpgCm/6UCpv6lAqb+pQKm/qUCpv+lAFoAWv9ZAlr/WQFa/lkBWgBaAVr+WQNa/FkEWv1ZAloAWv5ZAlr+WQNa/VkCWv9ZAFoBWv5ZAlr/WQFa/1kBWv9ZAVr/WQFaAFr/WQJa/VkCWgBaAFoAWv9ZAVoAWgBaAKYApgCmAKYApgCmAKYApgCmAKYBpv6lAaYBpv6lA6b9pQGmAab+pQOm/KUEpv2lAqb/pQGm/qUDpvylBKb+pQCmAKYBpv2lBab7pQOm/6UApgCmAKYApgCmAab+pQKm/lkDWvxZBVr7WQRa/lkAWgFa/1kBWv9ZAFoBWv5ZA1r8WQRa/VkCWv9ZAFoAWgFa/1kAWgFa/1kBWv9ZAFoAWgFaAFr/WQFa/lkDWv5ZAlr+WQFa/1kBWgBa/1kCWv2lA6b9pQOm/aUDpv6lAKYBpv+lAab/pQGm/qUDpv2lAqb/pQCmAKYApgCmAab+pQKm/qUCpgCm/qUDpv2lA6b9pQKm/6UBpgCm/qUDpvylBab7pQWm/KUDpv6lAab/pQJa/lkCWv5ZAlr+WQJa/1n/WQNa/FkEWv1ZAlr/WQBaAFoAWgBaAFoAWgBa/1kBWgBa/1kCWv1ZAloBWv1ZBFr8WQJaAVr+WQJa/1n/WQJa/1kAWgFa/lkCWv9ZAFoBpv+lAKYBpv6lA6b9pQKm/6UApgGm/qUDpvylBKb+pQCmAab+pQKmAKb/pQGm/qUDpv6lAab/pQGmAKYApv+lAab/pQKm/qUBpgCm/6UCpv6lAaYApv+lAqb+pQGmAKb+WQNa/lkBWv9ZAFoBWv9ZAVr/WQBaAVr/WQFa/lkDWv1ZA1r+WQBaAVr+WQNa/VkDWv1ZAlr+WQJa/1kAWgBaAFoAWgBaAFoAWgBaAFoAWgBaAFoAWgFa/lkCWv5ZAlr/pQCmAKYBpv6lA6b8pQSm/aUCpv+lAKYApgCmAKYApgCmAKYApgCmAKYBpv6lAqb/pf+lA6b9pQKm/6UApgCmAKYApgGm/qUCpv6lAqb/pQCmAKYBpv+lAab+pQOm/VkDWv1ZA1r+WQFa/lkDWv1ZA1r9WQJaAFr/WQBaAFoAWgFa/1kBWv5ZAlr+WQJa/lkCWv5ZAlr+WQFa/1kBWgBaAFr/WQFa/1kBWgBaAFr/WQFa/1kBWgBa/1kBWv9ZAab/pQGm/6UCpv2lA6b+pQCmAqb8pQWm+6UFpvylAaYBpv2lBab8pQGmAKYBpv6lA6b8pQOm/6UApgCmAab9pQSm/aUBpgCm/6UCpv+lAKb/pQKm/qUCpv6lAqb+pQNa/FkDWv9ZAFoAWgFa/lkDWv1ZAlr+WQNa/VkDWvxZBFr9WQJa/1kAWgBaAFoBWv5ZA1r9WQJa/1kBWv9ZAVr/WQBaAVr/WQBaAFoBWv5ZAlr+WQFaAFoAWgBaAFr/WQGmAKYApv+lAqb9pQOm/6X+pQSm+6UFpvylA6b+pQGmAKYApgCmAKYApgCmAKYApgCmAKYApgCmAKb/pQKm/qYCp/6mAacApwCn/6YCp/6mAqf+pgGnAaf+pgKn/qYCp/5YAln+WANZ/FgEWftYBln7WARZ/VgBWQBZ/1gDWfxYBFn8WAJZAVn9WANZ/lgBWQBZ/1gBWf9YAVn/WABZAVkAWf5YA1n9WAJZAFn/WABZAln9WANZ/lgAWQFZ/1gBpwCn/6YBpwCn/6YCp/6mAacBp/6mAacBp/2mBKf8pgKnAKf/pgCnAqf8pgWn+6YEp/6mAKcBp/+mAKcCp/ymBKf9pgKn/6YBp/+mAKcBp/+mAacAp/+mAacAp/+mAaf/WAFZAFn/WAFZ/1gBWf9YAVn/WAFZ/1gBWQBZ/1gBWf9YAVkAWf9YAln+WAJZ/VgEWf1YAln/WP9YA1n9WAJZ/1gAWQFZ/1gBWf9YAVn+WAJZAFn+WANZ/VgCWQBZ/qYCp/+mAKcBp/+mAKcBp/6mA6f9pgKn/6YBp/+mAqf9pgOn/aYDp/6mAaf/pgKn/aYEp/ymA6f/pgCnAKcApwCnAKcApwGn/qYCp/6mAacBp/2mBKf8pgOn/qYApwKn/VgDWf5YAFkCWf1YA1n+WAFZAFn/WAJZ/lgCWf1YBFn9WAJZ/lgBWQBZAFn/WAJZ/VgDWf1YAlkAWf9YAVn+WANZ/VgCWQBZ/lgEWftYBVn8WAJZ/1gBWf9YAln9WANZ/aYCpwCn/6YBp/+mAaf/pgKn/aYCp/+mAacApwCn/6YBp/+mAqf+pgKn/qYBpwCnAKcApwCn/6YCp/6mAacBp/2mBKf8pgKnAaf9pgSn+6YFp/ymBKf9pgCnAqf+pgJZ/1gAWQBZAFkAWQBZAVn+WAJZ/lgCWf9YAFkAWQBZAFkAWQBZAFkAWQBZAFn/WAFZAFn/WAJZ/VgDWf5YAln+WAFZAFn/WAJZ/1gAWQBZ/1gBWQBZAFkAWQBZ/1gCWf2mBaf6pgWn/KYDp/+mAKcAp/+mAacApwCnAaf+pgGnAKf/pgOn/KYDp/+m/6YCp/6mAacApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKcApwCnAKcAWQBZAVn9WARZ/VgCWQBZ/lgCWf9YAFkBWQBZ/1gBWf5YA1n+WAFZAFn+WARZ+1gFWftYBFn+WABZAVn+WAJZ/lgCWf9YAVn+WAJZ/lgDWf1YA1n9WAJZAFn+WANZ/VgDp/2mAqf/pgCnAaf+pgKn/qYCp/6mAqf/pv+mAqf+pgKn/qYCp/6mAqf+pgKn/qYCp/+mAKcBp/6mA6f9pgOn/aYCp/+mAaf/pgCnAaf/pgGn/6YApwGnAKf/pgKn/aYDWf5YAVkAWQBZ/1gCWf1YBFn8WANZ/lgBWQBZAFn/WAJZ/lgBWf9YAVkAWQBZAFn/WAFZ/1gCWf5YAln+WAFZAFkAWQBZAFkAWQFZ/lgCWf5YAVkBWf5YAln9WANZ/aYEp/ymA6f9pgKnAKcAp/+mAqf9pgOn/qYBpwCnAKf/pgGn/6YCp/6mAaf/pgGnAKcApwCn/6YBpwCnAKf/pgGn/6YCp/6mAaf/pgGnAKcAp/+mAqf+pgGnAKf/pgKn/lgBWf9YAVkBWf1YBFn8WANZ/1gAWQBZAVn+WAJZ/1gAWQFZ/1j/WANZ/FgFWftYA1n+WAJZ/lgBWQBZ/1gCWf1YA1n9WANZ/lgAWQFZ/lgCWf9YAFkAWf9YA1n8WASn/KYEp/2mA6f9pgKn/6YBp/6mAqf/pgCnAaf9pgOn/6YApwCnAKcApwCnAKf/pgKn/qYBpwCn/6YBp/+mAaf/pgKn/qYBpwCn/6YBpwCnAKcApwCn/6YBp/+mAqf+pgFZ/1gAWQFZ/1gAWQFZ/lgCWf5YA1n8WARZ/FgDWf9YAFkAWQBZAFkAWQBZAFkBWf9YAVn+WANZ/VgDWf1YA1n9WANZ/VgDWf1YA1n9WAJZAFn/WAFZAFn+WAJZAFn+WASn+6YDpwCn/qYCp/+m/6YDp/2mAqf/pgCnAaf+pgOn/aYCp/+mAaf+pgOn/aYBpwKn/aYCpwCn/6YBp/+mAaf/pgKn/qYApwGnAKf/pgKn/aYDp/6mAacAp/+mAqf+WAFZAFkAWQBZ/1gCWf1YBFn8WAJZAFn/WAFZAFn+WARZ/FgDWf5YAFkCWf9Y/1gCWf5YAVkBWf5YAVkBWf5YAln/WABZAFkBWf5YAln/WABZAVn+WAJZ/1gBWf9YAFkBp/+mAaf/pgGn/qYDp/ymBKf9pgGnAaf+pgOn/aYCp/+mAaf/pgGn/qYDp/2mAqf/pgCnAKcBp/+mAaf/pgGn/6YBpwCn/6YBpwCn/6YBpwCn/6YCp/6mAaf/pgGn/1gBWQBZ/1gBWf9YAFkBWQBZ/1gCWf1YAlkAWf9YAVn/WAFZ/1gBWf9YAVkAWf9YAVn/WAJZ/lgBWf9YAln+WAJZ/lgBWQBZAFkBWf9YAFkBWf5YA1n9WANZ/lgAWQFZ/qYCpwCn/qYCp/6mAqf/pgCnAaf9pgWn+qYGp/ymAacBp/6mAqcAp/6mA6f9pgKn/6YApwCnAaf/pgCnAaf+pgKn/6YApwGn/6YApwGn/qYCp/+mAKcBp/6mA6f9pgKn/1gAWQFZAFn+WANZ/VgDWf1YA1n9WAJZ/1gAWQJZ/VgCWf5YAln/WABZAVn9WAVZ+lgFWf1YAVkAWQBZ/1gCWf9Y/lgEWfxYBFn9WAJZ/lgCWf9YAFkBWf5YAln+WAKn/qYCp/6mAacApwCnAKcBp/6mAqf/pgCnAaf/pgGn/6YBp/+mAKcCp/2mA6f9pgKnAKf/pgGn/6YBp/+mAaf+pgOn/qYBp/+mAKcBp/+mAaf/pgGn/6YBp/+mAKcCp/1YA1n+WAFZ/1gBWQBZAFkAWf9YAVkAWQBZAFn/WAFZAFn/WAJZ/lgBWQBZ/1gBWQBZ/1gCWf5YAVn/WAFZAFkAWf9YAVn/WAJZ/VgEWftYBVn8WAJZAFkAWf9YAVn/pgGnAKf/pgCnAaf/pgKn/aYDp/ymBqf6pgWn/KYCp/+mAqf9pgKnAKf/pgGnAKf+pgSn+6YFp/ymA6f+pgGn/6YCp/2mA6f9pgOn/aYDp/2mA6f9pgKn/6YBp/+mAaf/WABZAln9WANZ/VgCWQBZ/lgDWfxYBFn+WABZAFkAWQBZAVn+WAJZ/lgCWf9Y/1gCWf9YAFkAWQBZAFkBWf9YAFkBWf5YA1n9WAJZ/1gAWQBZAVn+WANZ/FgEWfxYBFn9pgKn/6YApwCnAaf/pgGn/6YApwGn/6YBpwCn/6YBpwCn/qYDp/6mAqf+pgGnAKf/pgKn/aYEp/2mAqf+pgGnAKcApwGn/qYCp/2mA6f/pgCnAKcAp/+mAqf+pgKn/VgEWfxYBFn9WAFZAFkAWQBZAFkAWQBZAFkAWQBZ/1gCWf5YAln+WAJZ/VgDWf9Y/1gDWftYBVn9WAJZ/lgCWf5YAln/WABZAVn+WAJZ/lgDWf1YAln+WAJZ/1gBWf5YAqf/pgGn/6YApwGn/6YCp/ymBKf9pgOn/qYApwCnAaf+pgOn/aYCp/6mA6f8pgSn/aYBpwGn/6YApwCnAKcApwGn/qYCp/2mBaf6pgWn/aYBpwGn/qYCp/6mAqf+pgNZ/VgCWf5YAVkAWQFZ/lgCWf5YAVkAWQFZ/lgCWf5YA1n9WANZ/FgEWf5YAFkBWf5YAln+WAJZ/lgCWf5YAVkAWQBZAVn+WAJZ/lgCWf9YAFkAWQBZAFn/WAJZ/VgDWf6mAaf/pgGn/6YBpwCn/6YCp/6mAaf/pgGnAKcApwCn/6YCp/2mA6f+pgGnAKf/pgGn/6YCp/2mAqf/pgGn/6YBp/6mAqf/pgCnAKcBp/6mA6f8pgSn/aYCp/+mAKcApwFZ/VgFWfpYBln7WARZ/VgCWf9YAFkBWf9YAFkCWf1YAlkAWf9YAVkAWf9YAln+WAFZAFn/WAFZAFn/WAJZ/lgAWQJZ/VgDWf5YAVn/WAFZ/1gBWf9YAVn+WANZ/VgDp/2mAqf/pgCnAqf8pgSn/aYCp/+mAKcApwGn/qYCp/+mAaf/pgCnAaf+pgSn+qYHp/mmB6f6pgSn/aYDp/2mA6f+pgCnAqf8pgSn/aYCp/+mAKcBp/6mAqf/pgCnAaf/WAFZ/1gBWf9YAFkBWf9YAFkBWf5YAln/WABZAVn+WANZ/FgEWf1YAln/WABZAFkAWQFZ/lgCWf9YAFkBWf5YAln/WABZAVn/WABZAVn/WAFZ/1gBWf9YAVkAWf9YAKcCp/2mBKf8pgOn/qYBpwGn/qYCp/+m/6YDp/ymBKf9pgGnAaf+pgKn/qYCp/+mAKcBp/6mAqf/pgCnAaf+pgKn/6YApwGn/6YApwCnAaf/pgGn/qYCp/+mAaf/pv+mAln/WAFZ/lgCWf5YAln/WP9YAln+WAFZAVn+WAFZ/1gBWQBZAFn/WAJZ/VgDWf1YA1n+WAFZ/1gBWf9YAVn/WAFZAFn+WARZ/FgCWQFZ/VgEWfxYA1n+WAJZ/lgBWQBZAKcApwCn/6YBpwGn/qYCp/2mA6f9pgOn/qYBp/+mAaf+pgSn/KYDp/2mA6f+pgKn/qYCp/6mAqf+pgGnAaf/pgGn/qYCp/6mAqf/pgGn/6YApwCnAaf/pgGn/qYCpwBZ/1gAWQFZ/1gBWf9YAVn+WANZ/VgDWf5YAFkBWf5YA1n+WABZAln8WAVZ+1gFWfxYA1n9WAJZ/1gBWQBZ/1gAWQFZ/lgDWf5YAFkCWf1YAlkAWf9YAVkAWf9YAVn/WAGn/6YBp/+mAaf/pgGn/6YBp/+mAaf+pgOn/aYCp/+m/6YCp/6mAqf+pgGn/6YCp/2mBKf7pgWn/KYDp/6mAKcBp/+mAaf/pgCnAKcBp/+mAKcApwCnAaf+pgOn/KYEWf1YAln/WABZAFkBWf5YA1n9WAJZ/1gAWQBZAVn/WABZAVn+WANZ/VgCWf9YAVn/WABZAFkBWf5YA1n8WARZ/FgDWf9YAFkBWf5YAln/WABZAVn/WAFZAFn/WAFZAFkAp/+mA6f7pgan+6YCpwGn/aYEp/ymA6f+pgGn/6YBpwCnAKf/pgGn/6YBpwCn/6YBp/+mAKcBp/+mAKcBp/6mAqf/pgCnAKcApwCnAKcApwCn/6YCp/6mAqf+pgGnAKcAWQBZAVn9WARZ/VgBWQFZ/lgCWf9YAFkAWQFZ/lgDWfxYBFn9WAJZ/1gBWf5YA1n8WARZ/lgBWf9YAVn+WANZ/lgBWf9YAVn/WAFZAFn+WARZ+1gFWfxYAlkBWf1YBKf7pgWn/KYDp/6mAacAp/+mAacAp/+mAacAp/+mAacAp/+mAaf/pgGnAKf/pgGn/qYDp/6mAaf/pgCnAacAp/+mAaf/pgGnAKf/pgCnAaf/pgGn/6YBp/+mAKcBp/6mA1n9WAJZ/1gAWQBZAFkAWQBZAVn+WAJZ/lgBWQFZ/VgEWfxYA1n/WP9YAln9WANZ/1gAWQFZ/VgDWf5YA1n8WARZ/FgDWf9YAFn/WAJZ/lgBWQFZ/VgEWfxYA1n/WP+mAqf+pgGnAaf+pgGnAKcApwCnAKcApwCnAKcBp/2mBKf8pgSn/aYBpwCn/6YCp/+m/6YCp/6mAacBp/6mAacApwCnAKcApwCn/6YCp/6mAacAp/+mAacAp/6mBKf8pgNZ/lgBWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAFkAWQBZAVn9WANZ/lgBWQJZ/FgDWf5YAVkAWQBZAFkAWQBZ/1gCWf5YAVkAWf9YAln+WAFZAFn/WAFZAFn/WAKn/aYDp/6mAacAp/6mA6f+pgGnAKf+pgKn/6YBp/+mAaf+pgKn/qYCp/+mAKcBp/6mAqf/pgCnAKcBp/6mAqf/pgCnAaf+pgGnAaf+pgKn/6b/pgOn/KYDp/+mAKcBWf5YAln+WANZ/VgDWfxYBFn9WANZ/VgCWf9YAVn/WAFZ/lgDWf5YAVn/WAFZ/lgDWf1YAlkAWf5YA1n9WANZ/VgDWf1YA1n+WAFZ/1gCWf1YA1n9WAJZAFn/WABZAVn+pgOn/aYCp/+mAaf+pgOn/aYCp/+mAKcApwGn/qYCp/+mAaf+pgKn/6YApwGn/6YApwGn/6YApwKn/KYFp/ymAqcAp/6mA6f+pgCnAaf+pgOn/aYCp/6mAqf/pgCnAFkAWf9YAln+WAFZAVn+WAFZAFn/WAJZ/1j/WANZ+1gGWfpYBVn9WAJZ/1j/WAJZ/lgCWf9Y/1gCWf5YAln+WAFZAFkAWQBZ/1gBWQBZAFkAWf9YAln+WAJZ/lgBWQFZ/qYBpwCn/6YCp/2mA6f+pgGnAKf/pgKn/qYCp/6mAqf/pv+mA6f8pgSn/aYBpwGn/qYCp/+mAKcBp/6mAqf/pgCnAaf+pgKn/6b/pgOn/KYFp/umBKf9pgKn/6YApwGn/1gBWf9YAVn/WAFZAFn/WAFZ/1gBWf9YAln8WARZ/VgCWf9YAVn+WANZ/FgFWftYBFn9WAJZ/1gAWQFZ/lgCWf9Y/1gDWfxYBFn9WAJZ/lgCWf5YA1n9WAJZ/1gAWQGn/qYDp/ymBaf7pgSn/aYBpwGn/6YBp/+mAKcApwGn/6YBp/+mAKcBp/+mAaf/pgGn/6YBp/+mAaf/pgGn/6YApwGn/6YBp/6mA6f9pgOn/aYBpwKn/aYDp/2mA6f9pgJZ/1gAWQJZ/VgCWf9YAVn+WANZ/VgDWf5YAFkAWQFZ/1gBWf9YAVn/WAFZ/lgDWf1YA1n9WAJZ/1gAWQBZAFkAWQFZ/VgEWfxYA1n/WABZAFkAWf9YA1n9WANZ/FgDWf+mAKcBp/6mAqf+pgKn/qYCp/6mAqf+pgKn/qYDp/2mAacAp/+mAqf/pv+mAaf/pgKn/qYCp/6mAacBp/+m/6YCp/6mAqf+pgKn/aYEp/ymA6f/pv+mAacAp/+mAqf9WANZ/VgDWf1YAln/WABZAVn+WAJZ/lgCWf5YAln+WAFZAFkAWQBZAFkAWQBZAFkAWf9YAln+WAFZAFn/WAFZAFn/WAFZ/1gBWQBZ/1gBWf5YA1n9WANZ/VgCWf9YAFkBp/6mA6f9pgOn/KYEp/2mA6f9pgKn/qYCp/+mAKcBp/+mAKcBp/6mBKf8pgOn/aYDp/2mA6f9pgOn/aYCp/+mAKcBp/+mAaf/pgGn/6YBp/+mAaf/pgGnAKf+pgOn/VgDWf9Y/lgCWf9YAFkCWf1YAln/WAFZ/1gAWQFZ/1gBWQBZ/1gAWQJZ/FgFWfxYAlkAWf9YAFkBWf5YA1n9WAJZAFn+WAJZ/lgCWQBZ/lgCWf5YAln/WABZAFkBWf5YA6f9pgKn/6YBp/+mAaf/pgCnAaf/pgCnAaf/pgGn/6YApwGn/qYDp/2mAqf/pgCnAKcApwGn/qYCp/+mAKcBp/6mAqf+pgOn/aYCp/6mAqf+pgOn/KYEp/2mAqf/pgCnAVn/WAFZ/1gAWQFZ/lgDWf1YAln/WABZAFkAWQFZ/1gAWQBZAFkBWf9YAFkAWQBZAVn+WAJZ/1gAWQBZAFkAWQFZ/lgCWf5YA1n9WAFZAFn/WANZ/VgCWf5YAln/WACnAKcApwCnAKcAp/+mAqf+pgGnAKf/pgKn/qYBpwCn/6YBp/+mAacAp/+mAaf+pgOn/qYCp/6mAacAp/+mAqf+pgKn/qYCp/6mAacAp/+mAqf+pgKn/qYCp/6mAacApwFZ/lgCWf5YAln/WABZAFkAWQBZAFkBWf9YAFkAWQBZAVn/WAFZ/1gBWf9YAVn/WAJZ/lgBWf9YAVkAWQBZ/1gBWf9YAVkAWf9YAVn/WAFZ/1gBWf9YAVkAWf5YA1n9pgOn/qYBp/+mAacAp/6mA6f9pgOn/qYApwCnAaf/pgGn/6YBp/+mAaf+pgKn/6YBp/+mAaf+pgKn/6YApwKn/aYCp/+mAKcApwGn/qYDp/ymBKf9pgKn/6YApwGn/6YAWQFZ/1gBWf9YAFkBWf9YAFkBWf5YA1n9WAJZ/1gBWQBZ/lgDWf5YAln+WAFZ/1gCWf1YBFn8WANZ/lgBWQBZAVn9WARZ/FgEWf1YAVn/WAJZ/lgCWf5YAVkAWf9YAVn/pgKn/aYDp/2mA6f9pgKnAKf/pgKn/aYCpwCn/6YCp/6mAacAp/+mAqf/pv+mAqf+pgGnAaf9pgOn/qYCp/6mAqf9pgOn/qYCp/+m/6YBpwCn/6YBpwCn/6YCp/2mAlkAWf9YAln9WANZ/lgBWQBZ/1gCWf1YA1n+WAFZAFn/WAFZ/1gCWf1YA1n+WAFZ/1gCWf1YA1n9WANZ/VgDWf5YAFkBWf9YAVkAWf9YAFkBWf9YAVn/WAFZ/lgDWf1YAqcAp/6mA6f9pgKnAKf/pgGn/6YBp/+mAqf9pgOn/aYDp/6mAKcCp/2mA6f+pgCnAqf9pgOn/qYBp/+mAaf+pgSn/KYCpwCn/qYDp/6mAaf/pgGn/6YBpwCn/6YApwFZ/1gBWf9YAVn+WANZ/VgCWf9YAFkAWQFZ/lgCWf5YAln/WP9YAln/WABZAFkAWf9YA1n8WANZ/1j/WANZ/FgEWf1YAVkBWf5YA1n9WAFZAVn+WAJZ/1gAWQBZAFkAWACoAKgAqACoAKgAqACoAKgAqACoAaj+pwOo/KcDqP+nAKgBqP+nAKgAqAGo/6cBqACo/6cBqACo/6cCqP+n/6cCqP6nAagBqP6nAqj/pwCoAKgAqP+nAqj+pwKo/qcBqABYAFj/VwJY/lcCWP9X/1cBWABYAFj/VwJY/lcBWABY/1cBWABY/1cBWABY/1cCWP5XAVgAWP9XA1j8VwRY/FcEWPxXBFj8VwRY/VcBWABYAFgAWABYAFgAWABYAFgAqACoAKgBqP2nBKj8pwOo/6f/pwKo/qcCqP6nAqj+pwOo/KcEqPynBKj9pwKo/6f/pwOo/acCqP+nAaj/pwGo/6cAqAGo/6cBqP6nAqj+pwKo/6f/pwKo/acEqP2nAqj/VwBYAFgCWP1XA1j+VwBYAlj+VwFYAFj/VwBYAlj9VwRY+1cEWP5XAVgAWABY/1cCWP5XAlj+VwJY/lcCWP5XAlj+VwJY/lcBWABYAFj/VwFY/1cBWABY/lcDWP1XA6j9pwKo/6cAqAGo/qcDqP2nAqj/pwCoAKgBqP+nAaj/pwCoAKgBqP6nA6j9pwKo/6cAqAGo/6cBqACo/qcCqP+nAKgCqP2nAqj+pwKo/qcDqPynBKj8pwOo/qcCqP+nAFgAWP9XAlj+VwFYAFgAWP9XAlj+VwFYAFj/VwJY/lcDWPxXBFj9VwFYAVj+VwNY/lcAWAFY/lcDWP5XAFgBWP9XAVj/VwBYAVj/VwJY/FcFWPtXBVj8VwNY/lcAWAJY/acDqP6nAKgCqP2nA6j+pwGo/6cBqACoAKgAqP+nAqj+pwGoAKj/pwKo/qcBqP+nAaj/pwGoAKgAqP+nAqj9pwSo/acBqAGo/qcCqP+nAKgAqACoAKgBqP6nA6j7pwZY/FcCWP9XAFgAWAFY/lcDWP1XAlj/VwBYAVj/VwFY/1cBWP5XA1j9VwJY/1cBWP5XA1j8VwRY/lf/VwNY/FcEWP1XAlj/VwBYAFgAWABYAVj/VwBYAFj/VwJY/1cAWACoAKj/pwKo/qcCqP+nAKgAqACoAKgAqACoAKgAqACo/6cBqP+nAagAqP+nAaj/pwGo/6cCqP2nBKj7pwWo+6cFqPynA6j9pwKoAKj/pwGo/6cBqP+nAqj+pwCoAaj/VwJY/VcDWP1XA1j+VwBYAVgAWABY/1cBWP9XAVgAWP9XAVj/VwFY/1cBWABY/1cBWP9XAVj/VwFY/1cAWAJY/FcFWPtXBFj9VwNY/FcGWPhXCFj6VwRY/VcCWP5XAlj/pwCoAKgAqACoAKgAqACoAKgAqAGo/qcCqP6nAqj/pwCoAaj+pwOo/KcEqP2nA6j9pwKo/6cBqP+nAaj/pwCoAqj9pwOo/acCqP+nAaj/pwGo/qcDqP2nAqj/pwCoAaj/VwBYAVj+VwJY/1cAWAFY/lcCWP5XAlj/VwFY/1cAWABYAFgBWP9XAFgBWP5XAlj/VwBYAVj+VwNY/VcCWP9XAFgBWP9XAVj+VwNY/FcEWP1XA1j9VwJY/1cAWAFY/6cAqAGo/qcDqP6nAKgBqP6nA6j9pwOo/acDqP6nAaj/pwGo/6cBqACo/6cBqP+nAaj/pwGo/6cBqP+nAaj/pwGoAKj+pwOo/qcBqP+nAaj/pwGoAKj+pwOo/acCqP+nAFgAWABYAFgAWABYAFj/VwFYAFgAWABYAFj/VwJY/1cAWABYAFgAWAFY/1cAWABYAFgAWAFY/lcDWPxXBFj9VwJY/1cBWP9XAFgAWAFY/1cBWP9XAFgBWP9XAVj/VwGo/6cBqP+nAaj/pwGo/6cBqP+nAaj/pwCoAqj9pwOo/qcAqAGo/6cCqP2nBKj7pwSo/qcAqAKo/acCqP+nAKgBqACo/qcDqP2nA6j9pwOo/qcBqP+nAaj+pwSo+6cEqP1XA1j9VwJY/1cAWAJY/VcCWP5XAlj/VwFY/lcCWP1XBVj6VwZY+1cCWAFY/VcEWP1XAVgAWABY/1cCWP5XAVgBWP5XAVgBWP5XAlj/V/9XAlj+VwJY/lcCWP1XA1j+VwGoAKj/pwGo/6cCqP2nBKj7pwWo/KcDqf6pAasAq/+rAq3+rACuAa//rgKw/rAAsgGy/7IBtP+zAbX/tQG3/7YBuP+4Abn+uQS7+7sFvPu8BL7+vQG/AMD/wALB/cEEPfw8BDz9OgE6ADoAOQE4/jcCN/41Ajb/NAA0ADMBM/4xAjH+MAIw/y4BLv4tAi3/KwAsAiv9KQIp/ygBKP8mASf/JQAlAST/IwAjASL+IQIh/x8AHwEf/h0CHf4cAhz+5ALl/+X/5gLo/ucB6QDqAOoA6wDsAO3/7APu++4G7/vvA/H/8QDyAPMA9AD0APUB9v72Avf+9wL5//gA+gD7APwA/AD9AP7//QH/AAA=");
function fn_alarm_manage(flag) {
	switch (flag) {
	case "START":
		console.log("알람을 시작합니다");
		audio_obj.currentTime = 0;
		audio_obj.play();

		break;
	case "STOP":
		console.log("알람을 중지합니다");
		audio_obj.pause();
		break;
	default:
		break;
	}
}

/**
 * 알람 기능을 사용할 때 종료하는 Func
 *
 * @param e - 이벤트 ( ex. 13 - Enter, 9 - Tab...등 자세한건 구글 검색 )
 * @param code - 제약을 걸고 싶은 KeyCode
 * @return 따로 리턴되진 않음
 */
function fn_alarm_break(e, code) {
	// Enter 키 누를 때 Form 입력 전송 기능 작동중지
	if (e.keyCode == 27 && e.srcElement.type != 'textarea') {
		fn_alarm_manage("STOP");
	}
}


/**
 * [일별기종별생산실적]매출그룹, 공정별 기종 Function (전체 항목 미표기)
 *
 * @param flag0 - 날짜 (년도)
 * @param flag1 - 매출그룹
 * @param flag2 - 공정그룹
 * @param flag3 - 기종
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_group_year_model_filter_data(flag0, flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		SEARCHYEAR: flag0,
		LABEL: flag1,
		ROUTINGGROUP: flag2,
		MODEL: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchGroupYearModelListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.MODEL;
					var label = dataList.MODELNAME;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [일별기종별생산실적]매출그룹, 공정별 기종 Function (전체 항목 미표기)
 *
 * @param flag0 - 날짜 (년월)
 * @param flag1 - 매출그룹
 * @param flag2 - 공정그룹
 * @param flag3 - 기종
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_group_model_filter_data(flag0, flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		SEARCHMONTH: flag0,
		LABEL: flag1,
		ROUTINGGROUP: flag2,
		MODEL: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchGroupModelListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.MODEL;
					var label = dataList.MODELNAME;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [일별기종별생산실적]매출그룹, 공정별, 기종별 타입 Function (전체 항목 미표기)
 *
 * @param flag0 - 날짜 (년월)
 * @param flag1 - 매출그룹
 * @param flag2 - 공정그룹
 * @param flag3 - 기종
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_group_itemdetail_filter_data(flag0, flag1, flag2, flag3, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		SEARCHMONTH: flag0,
		LABEL: flag1,
		ROUTINGGROUP: flag2,
		MODEL: flag3,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchGroupItemDetailListLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.ITEMSTANDARDDETAIL;
					var label = dataList.ITEMSTANDARDDETAIL;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [품목별 매출 실적현황]매출 년도별 거래처 가져오기 Function
 *
 * @param flag0 - 날짜 (년도)
 * @param col - 적용할 컬럼 ID
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_sales_customer_filter_data(flag0, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		SEARCHYEAR: flag0,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchSalesCustomerLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var value = dataList.VALUE;
					var label = dataList.LABEL;

					if (col == "LABEL") {
						tempData.push(label);
					} else if (col == "VALUE") {

						tempData.push(value);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

/**
 * [마감관리]마감 정보 가져오기 Function
 *
 * @param flag0 - 날짜 (년도, 년월, 년월일)
 * @param col - 사용할 컬럼정보
 * @return 따로 리턴되진 않고, <option> 태그의 개체를 변경
 */
function fn_monthly_close_filter_data(flag0, col) {
	var orgid = ($('#searchOrgId').val() == undefined) ? 1 : $('#searchOrgId').val();
	var companyid = ($('#searchCompanyId').val() == undefined) ? 1 : $('#searchCompanyId').val();

	var tempData = [];
	var sparams = {
		ORGID: orgid,
		COMPANYID: companyid,
		SEARCHDATE: flag0,
	};

	var part = location.pathname.split("/");
	var url = "/" + part[1] + '/searchMonthlyCloseLov.do';

	$.ajax({
		url: url,
		type: "post",
		dataType: "json",
		async: false,
		data: sparams,
		success: function (data) {
			var count = data.totcnt * 1;

			if (count > 0) {
				for (var i = 0; i < count; i++) {
					var dataList = data.data[i];

					var omclose = dataList.OMCLOSE;
					var pmclose = dataList.PMCLOSE;
					var mfgclose = dataList.MFGCLOSE;
					var opclose = dataList.OPCLOSE;

					if (col == "OM") {
						tempData.push(omclose);
					} else if (col == "MAT") {
						tempData.push(pmclose);
					} else if (col == "MFG") {
						tempData.push(mfgclose);
					} else if (col == "SCM") {
						tempData.push(opclose);
					}
				}
			}
		},
		error: ajaxError
	});

	return tempData;
}

function fn_mobile_check() {
    // 모바일 여부
    var isMobile = false;

    isMobile = (/iphone|ipad|ipod|android/i.test(navigator.userAgent.toLowerCase()));
    return isMobile;
}