<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Content-Language" content="ko">
<%-- <meta charset="UTF-8"> --%>
<meta content="width=device-width, initial-scale=0.8, minimum-scale=0, maximum-scale=10, user-scalable=yes" name='viewport'>
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="X-UA-Compatible" content="IE=8">

<link rel="icon" href='<c:url value="/images/favicon.png"></c:url>' sizes="128x128">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/bootstrap.min.css'/>" />
<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/css/font-awesome.min.css'/>" /> --%>
<%-- <link type="text/css" rel="stylesheet" href="<c:url value='/css/ionicons.min.css'/>" /> --%>
<!-- Theme style -->
<link type="text/css" rel="stylesheet" href="<c:url value='/css/main.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/layout.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/footer.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/jquery-ui.css'/>">

<!-- KeyPad css -->
<link type="text/css" rel="stylesheet" href="<c:url value='/css/jquery-numpad.css'/>" />

<!-- Validation -->
<link type="text/css" rel="stylesheet" href="<c:url value='/js/jQuery-Validation-Engine-master/css/validationEngine.jquery.css'/>" />
<!-- bootstrap-datepicker -->
<link type="text/css" rel="stylesheet" href="<c:url value='/js/bootstrap-datepicker/css/bootstrap-datepicker.css'/>" />

<link type="text/css" rel="stylesheet" href="<c:url value='/css/layout/css/common.css'/>" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/common.css'/>" />

<%-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries --%>
<%-- WARNING: Respond.js doesn't work if you view the page via file:// --%>
<%--[if lt IE 9]>
<script src="<c:url value='/js/html5shiv.js'/>"></script>
<script src="<c:url value='/js/respond.min.js'/>"></script>
<![endif]--%>

<script type="text/javascript" src="<c:url value='/js/jquery.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery-ui.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jquery.price_format.2.0.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/globalValue.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/moment.js'/>"></script>
<!-- Validation -->
<script type="text/javascript" src="<c:url value='/js/jQuery-Validation-Engine-master/js/jquery.validationEngine.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-Validation-Engine-master/js/languages/jquery.validationEngine-kr.js'/>"></script>
<!-- bootstrap-datepicker -->
<script type="text/javascript" src="<c:url value='/js/bootstrap-datepicker/js/bootstrap-datepicker.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap-datepicker/js/bootstrap-datepicker.kr.js'/>"></script>

<script type="text/javascript" src="<c:url value='/js/layout/util.js'/>"></script>

<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/extjs/packages/ext-theme-neptune/build/resources/ext-theme-neptune-all.css' />"> --%>
<link rel="stylesheet" type="text/css" href="<c:url value='/extjs/packages/ext-theme-neptune/build/resources/ext-theme-neptune-all-debug.css' />">
<script type="text/javascript" src="<c:url value='/extjs/ext-all.js' />"></script>
<script type="text/javascript" src="<c:url value='/extjs/packages/ext-theme-neptune/build/ext-theme-neptune.js' />"></script>
<script type="text/javascript" src="<c:url value='/extjs/packages/ext-locale/build/ext-locale-ko.js' />"></script>

<!-- KeyPad -->
<script type="text/javascript" src="<c:url value='/js/jquery-numpad.js'/>"></script>

<style>
.KeypadTable th {
  font-size: 40px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid black;
}

.KeypadTable td {
  font-size: 22px;
  color: black;
  text-align: center;
}

.pad_display {
  background-color: rgb(234, 234, 234);
}

.pad_ok {
  background-color: #5B9BD5;
  color: blue;
  font-size: 150px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  text-shadow: 4px 4px 4px black;
}

.pad_ok:HOVER {
  background-color: highlight;
}

.pad_ng {
  background-color: #5B9BD5;
  color: red;
  font-size: 150px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  text-shadow: 4px 4px 4px black;
}

.pad_ng:HOVER {
  background-color: highlight;
}

.pad_number {
  background-color: #8C8C8C;
  color: white;
  font-size: 70px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  line-height: 1.3;
  text-shadow: 4px 4px 4px black;
}

.pad_number:HOVER {
  background-color: #BDBDBD;
}

.pad_number span {
  line-height: 50%;
}

.pad_button {
  width: 100%;
  height: 100%;
  display: inline-block;
  background-color: #5D5D5D;
  color: white;
  font-size: 75px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  line-height: normal;
  text-shadow: 4px 4px 4px black;
}

.pad_button:HOVER {
  background-color: #8C8C8C;
}

.pad_button span {
  line-height: 50%;
}

.pad_clear {
  background-color: #5D5D5D;
  color: white;
  font-size: 40px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  line-height: 45px;
  text-shadow: 4px 4px 4px black;
}

.pad_clear:HOVER {
  background-color: #8C8C8C;
}

.pad_enter {
  background-color: #0054FF;
  color: white;
  font-size: 50px;
  font-weight: bold;
  padding: 0px;
  font-weight: bold;
  line-height: 55px;
  text-shadow: 4px 4px 4px black;
}

.pad_enter:HOVER {
  background-color: highlight;
}

.pad_shadow {
  -webkit-box-shadow: 4px 4px 5px 0px rgba(0, 0, 0, 0.75);
  -moz-box-shadow: 4px 4px 5px 0px rgba(0, 0, 0, 0.75);
  box-shadow: 4px 4px 5px 0px rgba(0, 0, 0, 0.75);
}

.pad_r {
  border-radius: 8px 8px 8px 8px;
  -moz-border-radius: 4px 4px 4px 4px;
  -webkit-border-radius: 4px 4px 4px 4px;
  border: 0px solid #000000;
}

.pad_comment {
  height: 0px;
  position: relative;
  top: 5px;
  left: 10px;
  float: left;
  color: red;
}

.pad_remarks {
  font-size: 55px;
  vertical-align: middle;
  color: black;
}
</style>
<script type="text/javaScript">
var searchFlag = "";
$(document).ready(function() {
	<%-- //ExtJS 5.1버전 ( 등 특수문자 입력 안되는 현상 수정 패치 --%>
	Ext.define('Ext.patch.EXTJS16166', {
	    override: 'Ext.view.View',
	    compatibility: '5.1.0.107',
	    handleEvent: function (e) {
	        var me = this,
	        isKeyEvent = me.keyEventRe.test(e.type),
	        nm = me.getNavigationModel();
	        e.view = me;

	        if (isKeyEvent) {
	            e.item = nm.getItem();
	            e.record = nm.getRecord();
	        }

	        if (!e.item) {
	            e.item = e.getTarget(me.itemSelector);
	        }

	        if (e.item && !e.record) {
	            e.record = me.getRecord(e.item);
	        }

	        if (me.processUIEvent(e) !== false) {
	            me.processSpecialEvent(e);
	        }

	        if (isKeyEvent && !Ext.fly(e.target).isInputField()) {
	            if (e.getKey() === e.SPACE || e.isNavKeyPress(true)) {
	                e.preventDefault();
	            }
	        }
	    }
	});

	gridVals.groupingFeature = Ext.create('Ext.grid.feature.Grouping', {
	    ftype: 'groupingsummary',
	    id: 'groupingFeature',
	    groupHeaderTpl: [
	        '{name:this.formatName} ({rows.length})', {
	            formatName: function (name) {
	                var sName = (name == "") ? "미정 " : name;
	                return sName;
	            }
	        }
	    ],
	    enableNoGroups: true,
	    hideGroupedHeader: false,
	    startCollapsed: false,
	    expandTip: '확대하려면 클릭하십시오.',
	    collapseTip: '축소하려면 클릭하십시오.',
	    //         emptyGroupText: '그룹핑 항목이 없습니다.',
	    //         displayEmptyFields: true,
	});

	Ext.define('Ext.grid.column.CheckColumn', {
	    extend: 'Ext.grid.column.Check',
	    alias: 'widget.checkcolumn',

	    constructor: function (config) {
	        var me = this;

	        Ext.apply(config, {
	            stopSelection: true,
	            sortable: false,
	            draggable: false,
	            resizable: false,
	            menuDisabled: true,
	            hideable: false,
	            tdCls: 'no-tip',
	            defaultRenderer: me.defaultRenderer,
	            checked: false
	        });

	        me.callParent([config]);

	        me.on('headerclick', me.onHeaderClick);
	        me.on('selectall', me.onSelectAll);

	    },

	    onHeaderClick: function (headerCt, header, e, el) {
	        var me = this,
	        grid = headerCt.grid;

	        if (!me.checked) {
	            me.fireEvent('selectall', grid.getStore(), header, true);
	            //             header.getEl().down('img').addCls(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            $("#" + header.headertext).addClass(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            me.checked = true;
	        } else {
	            me.fireEvent('selectall', grid.getStore(), header, false);
	            //             header.getEl().down('img').removeCls(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            $("#" + header.headertext).removeClass(Ext.baseCSSPrefix + 'grid-checkcolumn-checked');
	            me.checked = false;
	        }
	    },

	    onSelectAll: function (store, column, checked) {
	        var dataIndex = column.dataIndex;
	        for (var i = 0; i < store.getCount(); i++) {
	            var record = store.getAt(i);
	            if (checked) {
	                record.set(dataIndex, true);
	            } else {
	                record.set(dataIndex, false);
	            }
	        }
	    }
	});

	$('form#master').keydown(function (e) {
	    if (searchFlag == "LIST") {
	        if (e.keyCode == 9 || e.keyCode == 13) {
	            fn_search();
	        }
	    }
	});
});
	
var global_keypad_win = "";
function fn_global_keypad_popup(colnm, value, flag, msg, rowidx, colidx, storenm, viewnm) {

    var width = 750;
    var height = 750;
    var title = "KEYPAD (현장용)";

    var html_code = "";
    html_code = '<table class="KeypadTable" cellpadding="0" cellspacing="0" border="1" width="100%" style="height: 100%; padding-top:0px;  float: left; ">' +
        '<colgroup>' +
        '<col>' +
        '<col>' +
        '<col>' +
        '<col>' +
        '</colgroup>' +
        '<tbody>';
    var comment = "";
    switch (flag) {
    case "OK/NG":
        // OK / NG 입력 키패드
        comment = "※ OK / NG 중에 하나를 선택하시고, <strong>확인</strong> 버튼을 눌러주세요.";

        break;
    case "NUM":
        // 숫자 입력 키패드
        comment = "※ 숫자 버튼을 눌러주시고, <strong>확인</strong> 버튼을 눌러주세요.";

        break;
    default:
        break;
    }

    html_code +=
    '<tr style="height: 50px; ">' +
    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; text-align: left; background-color: #5B9BD5;">' +
    '<center class="input_center ">' + "특이사항" + '</center>' +
    '</th>' +
    '<td colspan="3" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; text-align: left; background-color: rgb(234, 234, 234);">' +
    '<strong class="input_left pad_remarks">' + msg + '</strong>' +
    '</td>' +
    '</tr>' +
    '<tr>' +
    '<td colspan="4" style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
    '<span class="pad_comment">' + comment + '</span>' +
    '<input type="text" id="GLOBAL_DISPLAY_FIELD" name="GLOBAL_DISPLAY_FIELD" class="input_right pad_display" style="width: 100%; height: calc(100% - 0px); font-size: 70px; font-weight: bold; color: blue; padding-top: 30px; margin-top: 0px;" readonly />' +
    '</td>' +
    '</tr>';

    switch (flag) {
    case "OK/NG":
        // OK / NG 입력 키패드
        html_code +=
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td rowspan="2" colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "CLEAR" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_clear pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "초기화<br/>(Clear)" + '</span>' +
        '</button>' +
        '</td>' +
        '<td rowspan="2" colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "ENTER" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_enter pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "확인<br/>(Enter)" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td rowspan="3" colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "OK" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_ok pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "OK" + '</span>' +
        '</button>' +
        '</td>' +
        '<td rowspan="3" colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "NG" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_ng pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "NG" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '</tr>' +
        '</tbody>' +
        '</table>';

        break;
    case "NUM":
        // 숫자 입력 키패드

        html_code +=
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "CLEAR" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_clear pad_r pad_shadow" style="width: 99%; height: 98%; ">' +
        '<span>' + "초기화<br/>(Clear)" + '</span>' +
        '</button>' +
        '</td>' +
        '<td colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "BACK" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_clear pad_r pad_shadow" style="width: 99%; height: 98%; ">' +
        '<span>' + "←<br/>(Backspace)" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "7" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "7" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "8" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "8" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "9" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "9" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "MINUS" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_button pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span style="middle">' + "-" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "4" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "4" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "5" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "5" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "6" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "6" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "PLUS" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_button pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span style="middle">' + "+" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "1" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "1" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "2" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "2" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "3" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "3" + '</span>' +
        '</button>' +
        '</td>' +
        '<td rowspan="2" >' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "ENTER" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_enter pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "확인<br/>(Enter)" + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '<tr style=" background-color: rgb(234, 234, 234);">' +
        '<td colspan="2">' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "0" + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_number pad_r pad_shadow" style="width: 99%; height: 98%; ">' +
        '<span>' + "0" + '</span>' +
        '</button>' +
        '</td>' +
        '<td>' +
        '<button type="button" onclick="fn_global_btn_manage(\'' + "." + "\', \'" + colnm + "\', " + rowidx + ", \'" + storenm + "\', \'" + viewnm + '\');" class="pad_button  pad_r pad_shadow" style="width: 98%; height: 98%; ">' +
        '<span>' + "." + '</span>' +
        '</button>' +
        '</td>' +
        '</tr>' +
        '</tbody>' +
        '</table>';
        break;
    default:
        break;
    }

    if ( global_keypad_win != "" ) {
        $('#GLOBAL_DISPLAY_FIELD').val(emptyValue);
        global_keypad_win.destroy();
    }
    
    global_keypad_win = Ext.create('Ext.window.Window', {
        autoShow: true,
        width: width,
        height: height,
        title: title,
        html: html_code,
        header: false,
        draggable: true,
        resizable: false,
        maximizable: false,
        closeAction: 'destroy',
        modal: true,
    });

    // 팝업 위치 설정
//     var top = (($(window).height() / 2) - ((height / 2) - 34)) * 1;
//     global_keypad_win.setPosition(34, top, false);

    var emptyValue = "";
    var init_value = value;
    $('#GLOBAL_DISPLAY_FIELD').val(init_value);
}

function fn_global_btn_manage(flag, columnnm, rowindex, storename, viewname) {
    var emptyValue = "";
    switch (flag) {
    case "CLEAR":
        $('#GLOBAL_DISPLAY_FIELD').val(emptyValue);
        break;
    case "OK":
    case "NG":
        // OK / NG
        $('#GLOBAL_DISPLAY_FIELD').val(flag);
        break;
    case "BACK":
        var value = $('#GLOBAL_DISPLAY_FIELD').val();
        var startpoint = 0;
        var endpoint = (value.length - 1);
        var temp = value.substring(startpoint, endpoint);
        $('#GLOBAL_DISPLAY_FIELD').val(temp);
        break;
    case "1":
    case "2":
    case "3":
    case "4":
    case "5":
    case "6":
    case "7":
    case "8":
    case "9":
        // 숫자
        var value = $('#GLOBAL_DISPLAY_FIELD').val() + "";
        value = value + flag;
        var temp = parseNumber(value);
        $('#GLOBAL_DISPLAY_FIELD').val(temp);
        break;
    case "0":
    case ".":
        var value = $('#GLOBAL_DISPLAY_FIELD').val() + "";
        temp = value + flag;
        $('#GLOBAL_DISPLAY_FIELD').val(temp);
        break;
    case "PLUS":
        // +
        var value = Math.abs($('#GLOBAL_DISPLAY_FIELD').val());
        $('#GLOBAL_DISPLAY_FIELD').val(value);
        break;
    case "MINUS":
        // -
        var value = Math.abs($('#GLOBAL_DISPLAY_FIELD').val()) * -1.0;
        $('#GLOBAL_DISPLAY_FIELD').val(value);
        break;
    case "ENTER":
        // 확인
        var value = $('#GLOBAL_DISPLAY_FIELD').val();
        if (storename == null || storename == undefined) {
            $('#' + columnnm).val(value);
        } else {
            Ext.getStore(storename).getById(Ext.getCmp(viewname).getSelectionModel().select(rowindex));
            var model1 = Ext.getCmp(viewname).selModel.getSelection()[0];

            model1.set("" + columnnm + "", value);
        }

        $('#GLOBAL_DISPLAY_FIELD').val(emptyValue);
        global_keypad_win.destroy();
        break;
    default:
        break;
    }
}
</script>