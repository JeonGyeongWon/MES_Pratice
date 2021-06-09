/**
 * Created by sungpilhyun on 15. 9.25
 */
var msgs = {};

msgs.noti = {};
msgs.noti.save = "저장 되었습니다.";
msgs.noti.create = "생성 되었습니다.";
msgs.noti.recreate = "재생성 되었습니다.";
msgs.noti.add = "추가 되었습니다.";
msgs.noti.insert = "등록 되었습니다.";
msgs.noti.read = "조회 되었습니다.";
msgs.noti.edit = "수정 되었습니다.";
msgs.noti.del = "삭제 되었습니다.";
msgs.noti.fail = "실패 되었습니다.";

msgs.cfm = {};
msgs.cfm.save = "저장 하시겠습니까?";
msgs.cfm.create = "생성 하시겠습니까?";
msgs.cfm.add = "추가 하시겠습니까?";
msgs.cfm.insert = "등록 하시겠습니까?";
msgs.cfm.read = "조회 하시겠습니까?";
msgs.cfm.edit = "수정 하시겠습니까?";
msgs.cfm.del = "삭제 하시겠습니까?\n\n*데이터는 즉시 삭제되며 복구할수 없습니다.";

msgs.title = {};
msgs.title.noti = "확인";
msgs.title.save = "저장 확인";
msgs.title.create = "생성 확인";
msgs.title.add = "추가 확인";
msgs.title.insert = "등록 확인";
msgs.title.read = "조회 확인";
msgs.title.edit = "수정 확인";
msgs.title.del = "삭제 확인";

msgs.valid = {};
msgs.valid.fail = {};
msgs.valid.fail.save = "저장할 수 없습니다.";
msgs.valid.fail.create = "생성할 수 없습니다.";
msgs.valid.fail.add = "추가할 수 없습니다.";
msgs.valid.fail.insert = "등록할 수 없습니다.";
msgs.valid.fail.read = "조회할 수 없습니다.";
msgs.valid.fail.edit = "수정할 수 없습니다.";
msgs.valid.fail.del = "삭제할 수 없습니다.";
msgs.valid.fail.img = {};
msgs.valid.fail.img.limitcnt = "파일등록은 1개를 초과할 수 없습니다.";
//msgs.valid.fail.img.limitsize = "파일등록은 3Mb를 초과할 수 없습니다.";
msgs.valid.fail.img.limitsize = "파일등록은 20MB를 초과할 수 없습니다.";
msgs.valid.fail.img.type = "이미지 파일만 등록 가능합니다.";

var gridVals = {};
gridVals.pageSize = 20;
gridVals.actionMethods = {
	read : "POST",
	create : "POST",
	update : "POST",
	destroy : "POST",
};
gridVals.reader = {
	type : "json",
	rootProperty : "data",
	totalProperty : "totcnt",
	messageProperty : "msg"
};
gridVals.writer = {
	type : "json",
	rootProperty : "data",
	encode : true,
	writeAllFields : false,
	allowSingle : false,
	allDataOptions : true,
};
gridVals.defaultField = {
	sortable : true,
	align : "center",
	width : '100%',
	menuDisabled : true,
};

gridVals.emptyText = "선택하세요.";

gridVals.timeout = (1000 * 60) * 60;

var calenderOpt = {
	format : "yyyy-mm-dd",
	startView: 0,
	language : "kr",
	pickTime : false,
	defalutDate : getToDay("yyyy-MM-dd"),
	orientation: "top auto",
	keyboardNavigation: true,
	forceParse: false,
	todayHighlight: true,
	autoclose: true,
};

var calenderOpt2 = {
	format : "yyyy-mm",
	startView: 0,
	language : "kr",
	pickTime : false,
	defalutDate : getToDay("yyyy-MM"),
	orientation: "top auto",
	keyboardNavigation: true,
	forceParse: false,
	todayHighlight: true,
	autoclose: true,
};

//var calenderOpt = {
//	  format: "yyyy-mm-dd",
//	  startView: 0,
//	  todayBtn:"linked",
//	  language: "kr",
//	  pickTime : false,
//	  defalutDate : getToDay("yyyy-MM-dd"),
//	  orientation: "top auto",
//	  keyboardNavigation: false,
//	  forceParse: false,
//	  autoclose: true,
//	  todayHighlight: true
//};

var fileVals = {};
//fileVals.limitsize = 3145728;
fileVals.limitsize = 20971520;
fileVals.imgtype = ["image/jpeg","jpg","image/png","png","image/gif","gif"];


var keypadVals = {};
keypadVals.winopen = false;
keypadVals.windows;