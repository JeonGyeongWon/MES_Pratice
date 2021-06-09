<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@page import="org.apache.ibatis.annotations.Param"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%
  LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
  String authCode = loginVO.getAuthCode();
  
  /* Image Path 설정 */
  String imagePath_icon   = "/images/egovframework/sym/mpm/icon/";
  String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<html>
<head>
<title>${pageTitle}</title>

<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">
<style>
.x-column-header-inner {
  font-size: 18px;
  line-height: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  padding-left: 0px;
  padding-right: 0px;
}

.FML .x-grid-cell-inner {
  padding-left: 0px;
  padding-right: 0px;
}

.x-grid-cell-inner {
  position: relative;
  text-overflow: ellipsis;
  padding-top: 10px;
  padding-left: 10px;
  height: 45px;
  font-size: 18px !important;
  font-weight: bold;
}

.x-btn {
  margin-top: 2px;
  height: 39px;
}

.x-btn-inner {
  font-size: 14px !important;
}

#gridArea .x-form-field {
  font-size: 18px;
  font-weight: bold;
}

#gridArea2 .x-form-field {
    font-size: 18px; 
    font-weight: bold;
}

.x-window-item {
  text-align: center;
  background-color: rgb(79, 79, 79);
  color: rgb(255, 255, 255);
}

.x-toolbar {
  background-color: rgb(79, 79, 79);
}
</style>
<style>
.shadow {
  -webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
  -moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
  box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
  background-color: highlight;
}

.blue {
  background-color: #003399;
  color: white;
}

.blue2:HOVER {
  background-color: highlight;
  font-size: 18px;
  font-weight: bold;
}

.blue2 {
  background-color: #5B9BD5;
  color: white;
  font-size: 18px;
  font-weight: bold;
}


.btn_selected {
    background-color: #FFBB00;
    color: blue;
}

.btn_selected:HOVER {
    background-color: #FFE08C; 
    color: white;
}

.blue3:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #003399;
}

.blue3 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #003399 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.gray:HOVER {
  background-color: #EAEAEA;
}

.gray {
  background-color: #BDBDBD;
  color: black;
}

.black:HOVER {
  background-color: #EAEAEA;
}

.black {
  background-color: #BDBDBD;
  color: black !important;
}

.white:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white2:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white2 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 16px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  border-bottom: 4px solid #5B9BD5;
  margin-top: 0px;
  margin-bottom: 0px;
}

.yellow:hover {
  background-color: #FFFFFF;
  color: yellow !important;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  border-bottom: 4px solid yellow;
}

.yellow {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.yellow_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid yellow;
}

.yellow_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: yellow !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  cursor: pointer;
  border-bottom: 4px solid yellow;
  cursor: pointer;
}

.red:HOVER {
  background-color: #FFD8D8;
}

.red {
  background-color: #FFA7A7;
  color: black;
}

.green:HOVER {
  background-color: #CEFBC9;
}

.green {
  background-color: #B7F0B1;
  color: black;
}

.r {
  border-radius: 4px 4px 4px 4px;
  -moz-border-radius: 4px 4px 4px 4px;
  -webkit-border-radius: 4px 4px 4px 4px;
  border: 0px solid #000000;
}

.ui-autocomplete {
  font-size: 33px;
  font-weight: bold;
  max-height: 400px;
  overflow-y: auto;
  /* prevent horizontal scrollbar */
  overflow-x: hidden;
}

* html .ui-autocomplete {
  /* IE 6.0 */
  height: 400px;
  font-size: 33px;
  font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

*::-webkit-input-placeholder {
  color: blue;
}

*:-moz-placeholder {
  /* FF 4-18 */
  color: blue;
}

*::-moz-placeholder {
  /* FF 19+ */
  color: blue;
}

*:-ms-input-placeholder {
  /* IE 10+ */
  color: blue;
}

.ResultTable th {
  font-size: 25px;
  height: 45px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid white;
}

.ResultTable td {
  font-size: 25px;
  height: 45px;
  color: black;
  text-align: left;
}

</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var clickindex = 0;
var clickindex2 = 0;
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();

    setTimeout(function () {
        fn_tab('2');
    }, 200);
});

var worker_value, worker_label;
var wc_value, wc_label;
function setInitial() {
    gridnms["app"] = "process";

    var emptyValue = "";
    var filter_params = {
        ORGID: $('#orgid').val(),
        COMPANYID: $('#companyid').val(),
        DEPTCODE: "A009",
        POSITIONCODE: "",
        INSPECTIONTYPE: "20",
        WORKDEPT: $('#gubun').val(),
    };
    worker_value = fn_worker_filter_data(filter_params.ORGID, filter_params.COMPANYID, filter_params.DEPTCODE, filter_params.POSITIONCODE, filter_params.INSPECTIONTYPE, filter_params.WORKDEPT, "VALUE");
    worker_label = fn_worker_filter_data(filter_params.ORGID, filter_params.COMPANYID, filter_params.DEPTCODE, filter_params.POSITIONCODE, filter_params.INSPECTIONTYPE, filter_params.WORKDEPT, "LABEL");

    var workdept = $('#gubun').val();
    wc_value = fn_equipment_filter_data(filter_params.ORGID, filter_params.COMPANYID, workdept, emptyValue, "VALUE");
    wc_label = fn_equipment_filter_data(filter_params.ORGID, filter_params.COMPANYID, workdept, emptyValue, "LABEL");

    fn_calc_grid_height();

    for (var w = 0; w < wc_value.length; w++) {
        var nm = (w + 1);
        var value = wc_value[w];
        var label = wc_label[w];
        var btn_style = " width: 105px; height: 45px; font-size: 22px; font-weight: bold; color: #fff; margin-left: 5px; margin-right: 5px; margin-bottom: 10px; disabled ";
        var btn_css = fn_html_create("btn_wc", "btnEquipment" + nm, value, label, btn_style);

        $('#equipmentbuttons').append(btn_css);
    }

    global_work_center_code = wc_value[0];
    global_work_div = "01";

    fn_btn_selected("WORK_CENTER_CODE");
    fn_btn_selected("WORK_DIV");

    for (var i = 0; i < worker_value.length; i++) {
        var nm = (i + 1);
        var value = worker_value[i];
        var label = worker_label[i];
        var btn_style = " width: 105px; height: 45px; font-size: 22px; font-weight: bold; color: #fff; margin-left: 5px; margin-right: 5px; margin-bottom: 10px; disabled ";
        var btn_css = fn_html_create("btn", "btnWorker" + nm, value, label, btn_style);

        $('#workerbuttons').append(btn_css);
    }
}

var btn_height = 0, base_height = 55, menu_height = 0, area_height = 930, grid_height = 0, grid_height1 = 0; ;
function fn_calc_grid_height() {
    var btnRowCnt = Math.round((worker_value.length / 8));
    menu_height = $("#menuArea").outerHeight(true);
    btn_height = menu_height + (base_height * btnRowCnt) + 55;
    var temp_height = (area_height - btn_height) - (39 + 15);
    grid_height = Math.round(temp_height * 0.6);
    grid_height1 = temp_height - grid_height;
}

function fn_html_create(flag_type, flag_id, flag_val, flag_label, flag_css) {
    var result = "";
    switch (flag_type) {
    case "hidden":
        // 숨김
        result = '<input type="hidden" id="' + flag_id + '" name="' + flag_id + '" value="' + flag_val + '" />';
        break;
    case "img":
        // 이미지
        result = '<img alt="" src="' + flag_val + '" style="' + flag_css + '" />';
        break;
    case "no_img":
        // 이미지 X
        result = '<img alt="" src="' + '<c:url value="/" />' + 'images/noimage.png" style="' + flag_css + '" />';
        break;
    case "select":
        // option
        result = '<select id="' + flag_id + '" name="' + flag_id + '" class=" input_center" style="' + flag_css + '">'
             + '<option style="color: blue; font-weight: bold; height: 50px;" value="OK" ' + ((flag_val == "OK") ? "selected" : "") + '>OK</option>'
             + '<option style="color: red; font-weight: bold; height: 50px;" value="NG" ' + ((flag_val == "NG") ? "selected" : "") + '>NG</option>'
             + '</select>';
        break;
    case "input":
        // 입력
        result = '<input type="text" id="' + flag_id + '" name="' + flag_id + '" class="input_left " value="' + flag_val + '" style="' + flag_css + '" />';
        break;
    case "no_input":
        // 입력 X
        result = '<input type="text" id="' + flag_id + '" name="' + flag_id + '" class="input_left " value="" style="' + flag_css + '" />';
        break;
    case "btn":
        // 버튼
        result = '<button type="button" id="' + flag_id + '" name="' + flag_id + '" onclick="javascript:fn_worker_click(\'' + flag_val + '\', \'' + flag_label + '\');"class="black h r shadow " value="" style="' + flag_css + '" >' +
            flag_label +
            '</button>';
        break;
    case "btn_wc":
        // 버튼
        result = '<button type="button" id="WORKCENTERCODE_' + flag_val + '" name="' + flag_val + '" onclick="javascript:fn_btn_click(\'' + 'WORK_CENTER_CODE' + '\', \'' + flag_val + '\');"class="blue2 h r shadow " value="" style="' + flag_css + '" >' +
            flag_label +
            '</button>';
        break;
    default:
        result = "";
        break;
    }
    return result;
}

function fn_btn_selected(flag) {

    switch (flag) {
    case "WORK_CENTER_CODE":

        $('#equipmentbuttons button').removeClass("btn_selected");
        $('#equipmentbuttons button').addClass("blue2");

        $('#WORKCENTERCODE_' + global_work_center_code).removeClass('blue2');
        $('#WORKCENTERCODE_' + global_work_center_code).addClass('btn_selected');

        break;
    case "WORK_DIV":

        $('#workdivbuttons button').removeClass("btn_selected");
        $('#workdivbuttons button').addClass("blue2");

        $('#WORKDIV_' + global_work_div).removeClass('blue2');
        $('#WORKDIV_' + global_work_div).addClass('btn_selected');

        break;
    }
}

var global_work_center_code = "", global_work_div = "";
function fn_btn_click(flag, val) {
    switch (flag) {
    case "WORK_CENTER_CODE":
        global_work_center_code = val;

        break;
    case "WORK_DIV":
        global_work_div = val;

        break;
    }
    fn_btn_selected(flag);
    fn_search();
}

function fn_search() {

    var sparams = {
        ORGID: $('#orgid').val(),
        COMPANYID: $('#companyid').val(),
        WORKDEPT: '${searchVO.gubun}',
        WORKCENTERCODE: global_work_center_code,
        WORKDIV: global_work_div,
        CARTYPE: $('#searchCarType').val(),
        CARTYPENAME: $('#searchCarTypeName').val(),
        ITEMSTANDARDDETAIL: $('#searchItemStandardDetail').val(),
    };

    setValues_work();
    Ext.suspendLayouts();
    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
    Ext.resumeLayouts(true);
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_work_create() {
    // 작업지시 추가
    var searchItemCode = $('#searchItemCode').val();
    var searchRoutingId = $('#searchRoutingId').val();

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (searchItemCode === "") {
        header.push("제품");
        count++;
    }

    if (searchRoutingId === "") {
        header.push("공정");
        count++;
    }

    if (count > 0) {
        extToastView("[필수항목 미입력]<br/>" + header + " 항목을 입력/선택해주세요.");
        return false;
    }

    // PKG 호출
    var url = "<c:url value='/pre/prod/process/WorkOrderCreate.do' />"; // 유무 확인
    var url1 = "<c:url value='/pkg/prod/process/WorkOrderCreate.do' />"; // 생성

    var params = {
        ORGID: $('#orgid').val(),
        COMPANYID: $('#companyid').val(),
        ITEMCODE: $('#searchItemCode').val(),
        ROUTINGID: $('#searchRoutingId').val(),
        WORKCENTERCODE: global_work_center_code,
    };

    var msgtype = null,
    msgcnt = 0;

    if (msgcnt == 0) {
        $.ajax({
            url: url,
            type: "post",
            dataType: "json",
            data: params,
            success: function (data) {
                var rscode = data.RETURNSTATUS;
                var errmsg = data.MSGDATA;

                if (rscode === "Y") {
                    var cartypename = $('#searchCarTypeName').val();
                    var itemname = $('#searchItemName').val();
                    var msg = "[이미 등록됨]<br/>" + cartypename + ", " + itemname + " 은 이미 생성되어 있습니다.<br/>다시 한번 확인해주세요.";
                    extToastView(msg);

                    return;
                } else if (rscode === "N") {
                    $.ajax({
                        url: url1,
                        type: "post",
                        dataType: "json",
                        data: params,
                        success: function (data) {
                            var rscode = data.MSGDATA;
                            var errmsg = data.RETURNSTATUS;

                            if (rscode === "E") {
                                // 실패
                                var msg = "관리자에게 문의하십시오.<br/>" + errmsg;
                                extToastView(msg);

                                return;
                            } else if (rscode === "S") {
                                // 성공
                                var msg = "[작업지시 생성]<br/>생성이 완료되었습니다.";
                                extToastView(msg);

                                fn_search();

                            } else {
                                // 값을 못 넘겨 받았을 경우
                                extToastView(errmsg);

                                return;
                            }
                        },
                        error: ajaxError
                    });
                }
            },
            error: ajaxError
        });
    }
}

function fn_worker_click(value, label) {
    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {
        var workorderid = $('#workorderid').val();
        if (workorderid == "") {
            extToastView("작업지시 내역이 선택되지 않았습니다.<br/>작업지시 내역을 선택해주세요.");
            return false;
        }

        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx));
        var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        model.set("WORKER", value);
        model.set("WORKERNAME", label);
    } else {
        extToastView("작업지시 내역이 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }
}

function setValues() {
    setValues_work();
    setValues_fault();
}

function setValues_work() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkOrderBtnList";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.list"].push(gridnms["model.1"]);

    gridnms["stores.list"].push(gridnms["store.1"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'number',
            name: 'WORKRN',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'number',
            name: 'LEV',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'WORKDIV',
        }, {
            type: 'string',
            name: 'WORKDIVNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'CARTYPE',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARDDETAIL',
        }, {
            type: 'string',
            name: 'WORKER',
        }, {
            type: 'string',
            name: 'WORKERNAME',
        }, {
            type: 'string',
            name: 'ROUTINGID',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'number',
            name: 'MONTHLYQTY01',
        }, {
            type: 'number',
            name: 'MONTHLYQTY02',
        }, {
            type: 'number',
            name: 'MONTHLYQTY',
        }, {
            type: 'number',
            name: 'DAILYQTY',
        }, {
            type: 'number',
            name: 'MONTHLYFAULTQTY',
        }, {
            type: 'number',
            name: 'DAILYFAULTQTY',
        }, {
            type: 'number',
            name: 'DAILYGOALQTY',
        }, {
            type: 'number',
            name: 'INPUTQTY',
        }, {
            type: 'string',
            name: 'FMLYN',
        }, {
            type: 'number',
            name: 'WORKRATE',
        }, ];

    fields["columns.1"] = [{
            dataIndex: 'RN',
            text: '순<br/>번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            align: "center",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비<br/>번호',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 1) {
                    return value;
                } else {
                    if (rn == 2) {
                        meta.style = "border-bottom: 1px solid blue;";
                    }
                    return "";
                }
            },
        }, {
            dataIndex: 'XBUTTON',
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '작업<br/>완료',
            width: 80,
            style: 'text-align:center; ',
            align: "center",
            locked: true,
            lockable: false,
            widget: {
                xtype: 'button',
                defaultBindProperty: null,
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var rec_row = rowIdx;
                    var rec_col = colIdx;
                    fn_work_result_fnc(record.data, rec_row, rec_col, "END");
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        var workdivname = (global_work_div == "01") ? "주간" : "야간"; // record.data.WORKDIVNAME;
                        //               widgetColumn.setText(widgetColumn._btnText);
                        widgetColumn.setText(workdivname + "");
                    }
                }
            },
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
            },
            //     }, {
            //       dataIndex: 'WORKDIVNAME',
            //       text: '주야<br/>구분',
            //       xtype: 'gridcolumn',
            //       width: 75,
            //       hidden: false,
            //       sortable: false,
            //       menuDisabled: true,
            //       style: 'text-align:center',
            //       align: "center",
            //       locked: true,
            //       lockable: false,
            //       renderer: function (value, meta, record) {
            //         var rn = record.data.WORKRN;
            //         if (rn == 2) {
            //           meta.style = "border-bottom: 1px solid blue;";
            //         }
            //         return value;
            //       },
        }, {
            dataIndex: 'WORKERNAME',
            text: '작업자',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return value;
            },
        }, {
            dataIndex: 'CARTYPENAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 1) {
                    return value;
                } else {
                    if (rn == 2) {
                        meta.style = "border-bottom: 1px solid blue;";
                    }
                    return "";
                }
            },
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 1) {
                    return value;
                } else {
                    if (rn == 2) {
                        meta.style = "border-bottom: 1px solid blue;";
                    }
                    return "";
                }
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            locked: true,
            lockable: false,
            renderer: function (value, meta, record) {
                var rn = record.data.WORKRN;
                if (rn == 1) {
                    return value;
                } else {
                    if (rn == 2) {
                        meta.style = "border-bottom: 1px solid blue;";
                    }
                    return "";
                }
            },
        }, {
            text: '생산량',
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            locked: true,
            lockable: false,
            columns: [{
                    dataIndex: 'MONTHLYQTY01',
                    text: '주간',
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    locked: true,
                    lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 1) {
                            return Ext.util.Format.number(value, '0,000');
                        } else {
                            if (rn == 2) {
                                meta.style = "border-bottom: 1px solid blue;";
                            }
                            return "";
                        }
                    },
                }, {
                    dataIndex: 'MONTHLYQTY02',
                    text: '야간',
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    locked: true,
                    lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 1) {
                            return Ext.util.Format.number(value, '0,000');
                        } else {
                            if (rn == 2) {
                                meta.style = "border-bottom: 1px solid blue;";
                            }
                            return "";
                        }
                    },
                }, ],
        }, {
            text: '양품수량',
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            locked: true,
            lockable: false,
            columns: [{
                    dataIndex: 'MONTHLYQTY',
                    text: '월누계',
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    locked: true,
                    lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 1) {
                            return Ext.util.Format.number(value, '0,000');
                        } else {
                            if (rn == 2) {
                                meta.style = "border-bottom: 1px solid blue;";
                            }
                            return "";
                        }
                    },
                }, {
                    dataIndex: 'DAILYQTY',
                    text: '일누계',
                    xtype: 'gridcolumn',
                    width: 75,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    locked: true,
                    lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 2) {
                            meta.style = "border-bottom: 1px solid blue;";
                        }
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ],
        }, {
            text: '불량수량',
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            //             locked: true,
            //             lockable: false,
            columns: [{
                    dataIndex: 'MONTHLYFAULTQTY',
                    text: '월누계',
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    //                     locked: true,
                    //                     lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 1) {
                            return Ext.util.Format.number(value, '0,000');
                        } else {
                            if (rn == 2) {
                                meta.style = "border-bottom: 1px solid blue;";
                            }
                            return "";
                        }
                    },
                }, {
                    dataIndex: 'DAILYFAULTQTY',
                    text: '일누계',
                    xtype: 'gridcolumn',
                    width: 75,
                    hidden: false,
                    sortable: false,
                    resizable: true,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    cls: 'ERPQTY',
                    format: "0,000",
                    //                     locked: true,
                    //                     lockable: false,
                    renderer: function (value, meta, record) {
                        var rn = record.data.WORKRN;
                        if (rn == 2) {
                            meta.style = "border-bottom: 1px solid blue;";
                        }
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ],
        },
        // Hidden Columns
        {
            dataIndex: 'WORKRN',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'LEV',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDIV',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDIVNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKER',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKRATE',
            xtype: 'hidden',
        }, ];

    fields["columns.1"].push({
        dataIndex: 'DAILYGOALQTY',
        text: '일목표',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return Ext.util.Format.number(value, '0,000');
            } else {
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'INPUTQTY',
        text: '양품수량',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, record) {
            meta.style = " background-color: rgb(253, 218, 255); ";
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return Ext.util.Format.number(value, '0,000');
            } else {
                if (rn == 2) {
                    meta.style += " border-bottom: 1px solid blue; ";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'VBUTTON',
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        xtype: 'widgetcolumn',
        stopSelection: true,
        text: '수량<br/>확정',
        width: 80,
        style: 'text-align:center; ',
        align: "center",
        widget: {
            xtype: 'button',
            _btnText: "확정",
            defaultBindProperty: null,
            handler: function (widgetColumn) {
                var record = widgetColumn.getWidgetRecord();

                var rec_row = rowIdx;
                var rec_col = colIdx;
                fn_work_result_fnc(record.data, rec_row, rec_col, "START");
            },
            listeners: {
                beforerender: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();
                    widgetColumn.setText(widgetColumn._btnText);
                }
            }
        },
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 2) {
                meta.style = "border-bottom: 1px solid blue;";
            }
        },
    }, {
        text: '진행율',
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        columns: [{
                dataIndex: 'XXXXXXRATE',
                text: '%',
                xtype: 'gridcolumn',
                width: 75,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center;',
                align: "center",
                cls: 'ERPQTY',
                format: "0,000%",
                renderer: function (value, meta, record) {
                    var rn = record.data.WORKRN;
                    var dailyqty = record.data.DAILYQTY * 1;
                    var goalqty = record.data.DAILYGOALQTY * 1;
                    var result = 0;

                    if (goalqty > 0) {
                        result = Math.round((dailyqty / goalqty) * 100);
                    } else {
                        result = 0;
                    }
                    if (rn == 1) {
                        return Ext.util.Format.number(result, '0,000 %');
                    } else {
                        if (rn == 2) {
                            meta.style = "border-bottom: 1px solid blue;";
                        }
                        return "";
                    }
                },
            }, {
                dataIndex: 'XDISPLAYRATE',
                text: '&nbsp;',
                xtype: 'gridcolumn',
                width: 320,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ',
                align: "center",
                renderer: function (value, meta, record) {
                    meta.style = " padding: 0px; ";
                    var rn = record.data.WORKRN;
                    if (rn == 2) {
                        meta.style += " border-bottom: 1px solid blue; ";
                    }
                    var dailyqty = record.data.DAILYQTY * 1;
                    var goalqty = record.data.DAILYGOALQTY * 1;
                    var rate = (goalqty == 0) ? 0 : Math.round(((dailyqty / goalqty) * 100));
                    var base_count = 10;
                    var table_width = [];
                    var table_color = [];
                    var yes_color = "red";
                    var no_color = "white";
                    var border_color = "black";
                    var colorList = fn_option_filter_data(record.data.ORGID, record.data.COMPANYID, 'MFG', 'RATE_COLOR', 'ATTRIBUTE1', 'VALUE');
                    for (var c = 0; c < colorList.length; c++) {
                        switch (c) {
                        case 0:
                            var colot_temp = "";
                            if (rate > 70) {
                                colot_temp = colorList[c];
                            } else {
                                if (rate > 50) {
                                    colot_temp = "yellow";
                                } else {
                                    colot_temp = "red";
                                }
                            }
                            yes_color = colot_temp;
                            break;
                        case 1:
                            no_color = colorList[c];
                            break;
                        case 2:
                            border_color = colorList[c];
                            break;
                        default:
                            break;
                        }
                    }

                    for (var i = 0; i < base_count; i++) {
                        var base = (i * 10) + 10;
                        if (rate >= base) {
                            // 진행율이 기준점을 넘어설 경우
                            table_width.push(10);
                            table_color.push(yes_color);
                        } else {
                            // 진행율이 기준점을 넘지 못할 경우
                            var white_line = base - rate;
                            if (white_line >= 10) {
                                table_width.push(10);
                                table_color.push(no_color);
                            } else {
                                var red_line = 10 - white_line;
                                table_width.push(red_line);
                                table_color.push(yes_color);

                                if (white_line > 0) {
                                    table_width.push(white_line);
                                    table_color.push(no_color);
                                }
                            }
                        }
                    }

                    var table_header = "<table style='width: 100%; height: 100%; border: 0px groove " + border_color + ";'>" +
                        "<colgroup>";

                    var loop_col = "";
                    for (var j = 0; j < table_color.length; j++) {
                        loop_col += "<col width='" + table_width[j] + "%'>";
                    }

                    var body_header = "</colgroup>" +
                        "<tbody>" +
                        "<tr>";

                    var loop_body = "";
                    for (var k = 0; k < table_color.length; k++) {
                        var end_length = table_color.length - 1;
                        if (k == end_length) {
                            // 마지막 라인
                            loop_body += "<td style='width: 100%; height: 17px; background-color: " + table_color[k] + "; '></td>";
                        } else {
                            var width = table_width[k];
                            var color = table_color[k];
                            if (width >= 10) {
                                loop_body += "<td style='width: 100%; height: 17px; background-color: " + table_color[k] + "; border-right: 1px dotted " + border_color + ";'></td>";
                            } else {
                                var post_color = table_color[k + 1];
                                if (post_color == no_color) {
                                    if (color == post_color) {
                                        loop_body += "<td style='width: 100%; height: 17px; background-color: " + table_color[k] + "; border-right: 1px dotted " + border_color + ";'></td>";
                                    } else {
                                        loop_body += "<td style='width: 100%; height: 17px; background-color: " + table_color[k] + "; '></td>";
                                    }
                                } else {
                                    loop_body += "<td style='width: 100%; height: 17px; background-color: " + table_color[k] + "; border-right: 1px dotted " + border_color + ";'></td>";
                                }
                            }
                        }
                    }

                    var table_end = "</tr>" +
                        "</tbody>" +
                        "</table>";

                    var result = table_header + loop_col + body_header + loop_body + table_end;

                    temp = "";

                    return Ext.String.format(result, temp, value);
                },
            }, ],
    }, {
        dataIndex: 'ITEMNAME',
        text: '품명',
        xtype: 'gridcolumn',
        width: 260,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return value;
            } else {
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'ORDERNAME',
        text: '품번',
        xtype: 'gridcolumn',
        width: 140,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return value;
            } else {
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'WORKSTATUSNAME',
        text: '상태',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        resizable: false,
        style: 'text-align:center',
        align: "center",
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return value;
            } else {
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'XXXXXXXXXX',
        text: '작업지시번호',
        xtype: 'gridcolumn',
        width: 140,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
            var workorderid = record.data.WORKORDERID;
            var rn = record.data.WORKRN;
            if (rn == 1) {
                return workorderid;
            } else {
                if (rn == 2) {
                    meta.style = "border-bottom: 1px solid blue;";
                }
                return "";
            }
        },
    }, {
        dataIndex: 'FMLYN',
        text: '자주검사<BR/>여부',
        xtype: 'gridcolumn',
        width: 80,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 2) {
                meta.style = "border-bottom: 1px solid blue;";
            }
            return value;
        },
    });

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/process/WorkOrderBtnList.do' />"
    });
    //   $.extend(items["api.1"], {
    //     update: "<c:url value='/update/prod/process/WorkOrderBtnList.do' />"
    //   });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#WorkSelect": {
            itemclick: 'WorkSelectClick'
        }
    });

    // 페이징
    items["dock.paging.1"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.1"],
    };

    // 버튼 컨트롤
    items["dock.btn.1"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.1"],
        items: items["btns.1"],
    };

    items["docked.1"] = [];
}

var rowIdx = 0, colIdx = 0;
function WorkSelectClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var columnIndex = e.position.column.dataIndex;

    // 작업항목 선택시
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var workorderid = record.data.WORKORDERID;
    var workorderseq = record.data.WORKORDERSEQ;
    var itemcode = record.data.ITEMCODE;
    var routingcode = record.data.ROUTINGID;
    var worker = record.data.WORKER;
    var workername = record.data.WORKERNAME;

    $("#orgid").val(orgid);
    $("#companyid").val(companyid);
    $("#workorderid").val(workorderid);
    $("#workorderseq").val(workorderseq);
    $("#itemcode").val(itemcode);
    $("#routingcode").val(routingcode);
    $("#worker").val(worker);
    $("#workername").val(workername);

    if (columnIndex.indexOf("INPUTQTY") >= 0) {
        // 양품수량
        popup_flag = "NUM";
        var remarks = "";
        fn_global_keypad_popup(columnIndex, record.get(columnIndex), popup_flag, remarks, rowIdx, colIdx, gridnms["store.1"], gridnms["views.list"]);
        global_keypad_win.setPosition(320, 119, false);
        selected_columnIndex = columnIndex;
        selected_value = ""; // record.get(columnIndex);
        selected_rowIdx = rowIdx;
        selected_colIdx = colIdx;
        selected_storenm = gridnms["store.1"];
        selected_viewnm = gridnms["views.list"];
    }

    fn_tab($('#tabclick').val());
};

function fn_work_result_fnc(rec, ri, ci, flag) {
    var flag_name = (flag == "END") ? "완료" : "등록";

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extToastView("[작업실적 " + flag_name + "]<br/>데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var select_record = rec;
    if (flag == "END") {
        // 주야별 작업마감
        console.log("[주야별 작업마감] 영역입니다.");
    } else {
        // 주야별 작업자 실적 등록
        console.log("[주야별 작업등록] 영역입니다.");

        var dailygoalqty = select_record.DAILYGOALQTY * 1;
        var inputqty = select_record.INPUTQTY * 1;
        //         if (dailygoalqty < inputqty) {
        //             extToastView("[작업실적 " + flag_name + "]<br/>입력하신 양품수량이 일목표 기준을 초과하였습니다.<br/>다시 한번 확인해주세요.");
        //             return false;
        //         }
        console.log("수량 >>>>>>>>>> " + select_record.INPUTQTY);
    }

    var url = "<c:url value='/update/prod/process/WorkOrderBtnList.do' />";
    select_record.WORKFLAG = flag;
    var qty = select_record.INPUTQTY;

    if (qty > 0) {

        $.ajax({
            url: url,
            type: "post",
            dataType: "json",
            data: select_record,
            success: function (data) {
                var success = data.success;
                var msg = data.msg;
                if (!success) {
                    extToastView("관리자에게 문의하십시오.<br/>" + msg);
                    return;
                } else {
                    //                  Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                    //                  Ext.getCmp(gridnms["views.list"]).doLayout();

                    extToastView(msg);

                    //                  Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                    //                      row: rowIdx,
                    //                      column: colIdx,
                    //                      animate: false
                    //                  });
                    Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                        Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx)
                        Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                    });
                    //                     fn_search();
                    fn_tab_load();

                    //                     setTimeout(function () {
                    //                         Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                    //                         Ext.getCmp(gridnms["views.list"]).doLayout();

                    //                     }, 1 * 0.5 * 1000);

                    //                     Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                    //                         row: ri,
                    //                         column: colIdx,
                    //                         animate: ci
                    //                     });
                }
            },
            error: ajaxError
        });
    } else {
        var msgFlagName = (qty < 0) ? "등록취소" : flag_name;
        var msgTitle = '작업실적 ' + msgFlagName;
        var msgTitle_css = "<strong style='font-size: 42px; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + msgTitle + "</strong>";

        var msgData = msgFlagName + ' 처리하시겠습니까?';
        var msgData_css = "<strong style='font-size: 40px; text-align: center; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + msgData + "</strong>";
        Ext.MessageBox.confirm(msgTitle_css, msgData_css, function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: select_record,
                    success: function (data) {
                        var success = data.success;
                        var msg = data.msg;
                        if (!success) {
                            extToastView("관리자에게 문의하십시오.<br/>" + msg);
                            return;
                        } else {
                            //                          Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                            //                          Ext.getCmp(gridnms["views.list"]).doLayout();

                            extToastView(msg);

                            //                          Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                            //                              row: rowIdx,
                            //                              column: colIdx,
                            //                              animate: false
                            //                          });
                            Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                                Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx)
                                Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                            });

                            //                             fn_search();
                            fn_tab_load();
                        }
                    },
                    error: ajaxError
                });

            } else {
                var msgFlagName = (qty < 0) ? "등록취소" : flag_name;
                var msgData = msgFlagName + ' 처리가 취소되었습니다.';
                var msgbtn = "확인되었음<br/>[Confirmed]";
                extWorkAlert(msgTitle, msgData, msgbtn);
                //         Ext.Msg.alert('작업실적 ' + flag_name, flag_name + ' 처리가 취소되었습니다.');
                return false;
            }
        });
    }
}

function setValues_fault() {
    gridnms["models.fault"] = [];
    gridnms["stores.fault"] = [];
    gridnms["views.fault"] = [];
    gridnms["controllers.fault"] = [];

    gridnms["grid.3"] = "WorkFaultList";
    gridnms["grid.31"] = "workerFaultLov"; // 작업자 Lov
    gridnms["grid.32"] = "faultTypeLov"; // 불량유형 Lov
    gridnms["grid.33"] = "faultCavityLov";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.fault"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.fault"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];
    gridnms["model.31"] = gridnms["app"] + ".model." + gridnms["grid.31"];
    gridnms["model.32"] = gridnms["app"] + ".model." + gridnms["grid.32"];
    gridnms["model.33"] = gridnms["app"] + ".model." + gridnms["grid.33"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];
    gridnms["store.31"] = gridnms["app"] + ".store." + gridnms["grid.31"];
    gridnms["store.32"] = gridnms["app"] + ".store." + gridnms["grid.32"];
    gridnms["store.33"] = gridnms["app"] + ".store." + gridnms["grid.33"];

    gridnms["models.fault"].push(gridnms["model.3"]);
    gridnms["models.fault"].push(gridnms["model.31"]);
    gridnms["models.fault"].push(gridnms["model.32"]);
    gridnms["models.fault"].push(gridnms["model.33"]);

    gridnms["stores.fault"].push(gridnms["store.3"]);
    gridnms["stores.fault"].push(gridnms["store.31"]);
    gridnms["stores.fault"].push(gridnms["store.32"]);
    gridnms["stores.fault"].push(gridnms["store.33"]);

    fields["model.3"] = [{
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'number',
            name: 'SEQNO',
        }, {
            type: 'number',
            name: 'CHKSEQ',
        }, {
            type: 'string',
            name: 'WORKER',
        }, {
            type: 'string',
            name: 'WORKERNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'date',
            name: 'FAULTDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'string',
            name: 'FAULTTYPE',
        }, {
            type: 'string',
            name: 'FAULTTYPENAME',
        }, {
            type: 'number',
            name: 'FAULTQTY',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        },
    ];

    fields["model.31"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.32"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, {
            type: 'string',
            name: 'CHECKSTANDARD',
        }, {
            type: 'string',
            name: 'CHECKSEQ',
        }, ];

    fields["model.33"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.3"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'WORKERNAME',
            text: '담당자',
            xtype: 'gridcolumn',
            width: 300,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.31"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0].id);
                        var code = record.data.VALUE;

                        model.set("WORKER", code);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKER", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                    width: 200,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '작업일시<br/>적용',
            width: 110,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "작업일시",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var selectedRow = Ext.getCmp(gridnms["views.fault"]).getSelectionModel().getCurrentPosition().row;

                    Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).getSelectionModel().select(selectedRow));
                    var store = Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0];

                    var model = Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0].id);

                    var today = new Date();

                    var start = Ext.util.Format.date(today, 'Y-m-d H:i');
                    model.set("FAULTDATE", start);

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'FAULTDATE',
            text: '작업일시',
            xtype: 'datecolumn',
            width: 215,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d H:i',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 16,
                allowBlank: true,
                editable: true,
                format: 'Y-m-d H:i',
                height: 45,
                triggerCls: 'trigger-datefield-custom', //날짜용
                listeners: {
                    select: function (value, record) {
                        var selectedRow = Ext.getCmp(gridnms["views.fault"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0];

                        var temp = Ext.Date.format(value.getValue(), 'Y-m-d');
                        var startdate = new Date(temp);
                        var today = new Date();
                        startdate.setHours(today.getHours());
                        startdate.setMinutes(today.getMinutes());

                        var start = Ext.util.Format.date(startdate, 'Y-m-d H:i');
                        value.setValue(start);

                    },
                },
            },
            renderer: function (value, meta, record) {
                switch (groupid) {
                case "ROLE_WORK":
                    meta.style = "background-color:rgb(234, 234, 234); ";
                    break;
                default:
                    //
                    break;
                }
                return Ext.util.Format.date(value, 'Y-m-d H:i');
            },

        },

        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKER',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'FAULTITEMCODE',
            xtype: 'hidden',
        }, ];

    fields["columns.3"].push({
        dataIndex: 'FAULTTYPENAME',
        text: '불량유형',
        xtype: 'gridcolumn',
        width: 400,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
        editor: {
            xtype: 'combobox',
            store: gridnms["store.32"],
            valueField: "LABEL",
            displayField: "LABEL",
            matchFieldWidth: false,
            editable: false,
            queryParam: 'keyword',
            queryMode: 'local', // 'local',
            //allowBlank: true,
            //forceSelection: false,
            height: 45,
            triggerCls: 'trigger-combobox-custom', //콤보박스용
            listeners: {
                select: function (value, record, eOpts) {
                    var model = Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0].id);

                    model.set("FAULTTYPE", record.data.VALUE);

                },
            },
            listConfig: {
                loadingText: '검색 중...',
                emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                width: 600,
                getInnerTpl: function () {
                    return '<div>'
                     + '<table>'
                     + '<colgroup>'
                     + '<col>'
                     + '</colgroup>'
                     + '<tr>'
                     + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{FAULTTYPENAME}</td>'
                     + '</tr>'
                     + '</table>'
                     + '</div>';
                }
            },
        },
    }, {
        dataIndex: 'FAULTQTY',
        text: '불량갯수',
        xtype: 'gridcolumn',
        width: 100,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center',
        align: "center",
        width: 120,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        //         editor: {
        //             xtype: 'combobox',
        //             store: gridnms["store.33"],
        //             valueField: "LABEL",
        //             displayField: "LABEL",
        //             matchFieldWidth: true,
        //             editable: false,
        //             queryParam: 'keyword',
        //             queryMode: 'remote', // 'local',
        //             allowBlank: true,
        //             typeAhead: true,
        //             transform: 'stateSelect',
        //             forceSelection: false,
        //             height: 45,
        //             triggerCls: 'trigger-combobox-custom', //콤보박스용
        //             listeners: {
        //                 select: function (value, record, eOpts) {
        //                     var model = Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0].id);

        //                 },
        //             },
        //             listConfig: {
        //                 loadingText: '검색 중...',
        //                 emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
        //                 width: 200,
        //                 getInnerTpl: function () {
        //                     return '<div >'
        //                      + '<table >'
        //                      + '<colgroup>'
        //                      + '<col width="120px">'
        //                      + '</colgroup>'
        //                      + '<tr>'
        //                      + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
        //                      + '</tr>'
        //                      + '</table>'
        //                      + '</div>';
        //                 }
        //             },
        //         },
        renderer: function (value, meta, record) {
            return value;
        },
    }, {
        dataIndex: 'REMARKS',
        text: '비고',
        xtype: 'gridcolumn',
        flex: 1,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
        editor: {
            xtype: 'textfield',
            allowBlank: true,
            height: 45,
        },
    });

    items["api.3"] = {};
    $.extend(items["api.3"], {
        create: "<c:url value='/insert/prod/process/WorkOrderResultDetail.do' />"
    });
    $.extend(items["api.3"], {
        read: "<c:url value='/select/prod/process/WorkOrderResultDetail.do' />"
    });
    $.extend(items["api.3"], {
        update: "<c:url value='/insert/prod/process/WorkOrderResultDetail.do' />"
    });

    items["btns.3"] = [];

    items["btns.ctr.3"] = {};
    $.extend(items["btns.ctr.3"], {
        "WorkFaultSelectList": {
            itemclick: "onFaultClick"
        }
    });

    // 페이징
    items["dock.paging.3"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.3"],
    };

    // 버튼 컨트롤
    items["dock.btn.3"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.3"],
        items: items["btns.3"],
    };

    items["docked.3"] = [];
}

var rowIdx_3 = 0, colIdx_3 = 0;
function onFaultClick(dataview, record, item, index, e, eOpts) {
    rowIdx_3 = e.position.rowIdx;
    colIdx_3 = e.position.colIdx;
    var columnIndex = e.position.column.dataIndex;

    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var itemcode = $('#itemcode').val();
    var routingid = $('#routingcode').val();
    var routinggroup = $('#routinggroup').val();

    if (columnIndex.indexOf("WORKERNAME") >= 0) {
        // 담당자
        var sparams1 = {
            ORGID: orgid,
            COMPANYID: companyid,
            WORKCENTERCODE: global_work_center_code,
            WORKDEPT: "${searchVO.gubun}",
        };
        extGridSearch(sparams1, gridnms["store.31"]);
    } else if (columnIndex.indexOf("FAULTTYPENAME") >= 0) {
        // 불량유형
        var faultgroup = routinggroup;
        if (faultgroup != "") {
            var sparams5 = {
                ORGID: orgid,
                COMPANYID: companyid,
                BIGCD: 'MFG',
                MIDDLECD: 'FAULT_TYPE',
                ATTRIBUTE1: faultgroup,
            };
            extGridSearch(sparams5, gridnms["store.32"]);
        } else {
            Ext.getStore(gridnms["store.32"]).removeAll();
        }

    } else if (columnIndex.indexOf("FAULTQTY") >= 0) {
        // 불량갯수
        popup_flag = "NUM";
        var remarks = "";
        fn_global_keypad_popup(columnIndex, record.get(columnIndex), popup_flag, remarks, rowIdx_3, colIdx_3, gridnms["store.3"], gridnms["views.fault"]);
        global_keypad_win.setPosition(320, 119, false);
        selected_columnIndex = columnIndex;
        selected_value = ""; // record.get(columnIndex);
        selected_rowIdx = rowIdx_3;
        selected_colIdx = colIdx_3;
        selected_storenm = gridnms["store.3"];
        selected_viewnm = gridnms["views.fault"];
    }
};

var gridarea1, gridarea2;
function setExtGrid() {
    setExtGrid_work();
    setExtGrid_fault(); // 불량유형등록

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea1.updateLayout();
        gridarea2.updateLayout();
    });
}

function setExtGrid_work() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["store.1"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.1"],
                        model: gridnms["model.1"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            extraParams: {
                                ORGID: '${searchVO.ORGID}',
                                COMPANYID: '${searchVO.COMPANYID}',
                                WORKDEPT: '${searchVO.gubun}',
                                WORKCENTERCODE: global_work_center_code,
                                WORKDIV: global_work_div,
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                var cnt = rows.length;
                                if (cnt > 0) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                                    var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                                    var orgid = model1.data.ORGID;
                                    var companyid = model1.data.COMPANYID;
                                    var workorderid = model1.data.WORKORDERID;
                                    var workorderseq = model1.data.WORKORDERSEQ;
                                    var itemcode = model1.data.ITEMCODE;
                                    var routingcode = model1.data.ROUTINGID;
                                    var worker = model1.data.WORKER;
                                    var workername = model1.data.WORKERNAME;

                                    $("#orgid").val(orgid);
                                    $("#companyid").val(companyid);
                                    $("#workorderid").val(workorderid);
                                    $("#workorderseq").val(workorderseq);
                                    $("#itemcode").val(itemcode);
                                    $("#routingcode").val(routingcode);
                                    $("#worker").val(worker);
                                    $("#workername").val(workername);

                                } else {
                                    var emptyValue = "";
                                    //                                     $("#orgid").val(orgid);
                                    //                                     $("#companyid").val(companyid);
                                    $("#workorderid").val(emptyValue);
                                    $("#workorderseq").val(emptyValue);
                                    $("#itemcode").val(emptyValue);
                                    $("#routingcode").val(emptyValue);
                                    $("#worker").val(emptyValue);
                                    $("#workername").val(emptyValue);

                                }
                                fn_tab($('#tabclick').val());
                            },
                            scope: this
                        },
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            WorkSelect: '#WorkSelect',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        WorkSelectClick: WorkSelectClick,
    });

    Ext.define(gridnms["panel.1"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.1"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.1"],
                id: gridnms["panel.1"],
                store: gridnms["store.1"],
                height: grid_height, // 630,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'WorkSelect',
                    //           listeners: {
                    //             refresh: function (dataView) {
                    //               Ext.each(dataView.panel.columns, function (column) {
                    //                 if (column.dataIndex.indexOf('WORKERNAME') >= 0 || column.dataIndex.indexOf('CARTYPENAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                    //                   column.autoSize();
                    //                   column.width += 5;
                    //                   if (column.width < 100) {
                    //                     column.width = 100;
                    //                   }
                    //                 }
                    //                 if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
                    //                   column.autoSize();
                    //                   column.width += 5;
                    //                   if (column.width < 150) {
                    //                     column.width = 150;
                    //                   }
                    //                 }
                    //               });
                    //             }
                    //           },
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                    }
                ],
                dockedItems: items["docked.1"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.list"],
        stores: gridnms["stores.list"],
        views: gridnms["views.list"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea1 = Ext.create(gridnms["views.list"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function setExtGrid_fault() {

    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"],
    });

    Ext.define(gridnms["model.31"], {
        extend: Ext.data.Model,
        fields: fields["model.31"],
    });

    Ext.define(gridnms["model.32"], {
        extend: Ext.data.Model,
        fields: fields["model.32"],
    });

    Ext.define(gridnms["model.33"], {
        extend: Ext.data.Model,
        fields: fields["model.33"],
    });

    Ext.define(gridnms["store.3"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.3"],
                        model: gridnms["model.3"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize, // 20,
                        proxy: {
                            type: 'ajax',
                            api: items["api.3"],
                            timeout: gridVals.timeout,
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.31"], { // (공정검사 불량유형 등록) 작업자 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.31"],
                        model: gridnms["model.31"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchWorkerEquipLov.do' />",
                            timeout: gridVals.timeout,
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.32"], { // (공정검사 불량유형 등록) 불량유형 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.32"],
                        model: gridnms["model.32"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'FAULT_TYPE',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.33"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.33"],
                        model: gridnms["model.33"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchWorkOrderProdQtyCavityLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                ITEMCODE: $("#itemcode").val(),
                                ROUTINGID: $("#routingcode").val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.3"], {
        extend: Ext.app.Controller,
        refs: {
            WorkFaultSelectList: '#WorkFaultSelectList',
        },
        stores: [gridnms["store.3"]],
        control: items["btns.ctr.3"],

        onFaultClick: onFaultClick,
    });

    Ext.define(gridnms["panel.3"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.3"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.3"],
                id: gridnms["panel.3"],
                store: gridnms["store.3"],
                height: grid_height1, // 195,
                border: 2,
                scrollable: true,
                columns: fields["columns.3"],
                defaults: fields["defaults"],
                viewConfig: {
                    itemId: 'WorkFaultSelectList',
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var editDisableCols = [];

                                switch (groupid) {
                                case "ROLE_WORK":
                                    editDisableCols.push("FAULTDATE");
                                    break;
                                default:
                                    //
                                    break;
                                }

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
                                }
                            }
                        },
                    }
                ],
                dockedItems: items["docked.3"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.fault"],
        stores: gridnms["stores.fault"],
        views: gridnms["views.fault"],
        controllers: gridnms["controller.3"],

        launch: function () {
            gridarea2 = Ext.create(gridnms["views.fault"], {
                renderTo: 'gridArea2'
            });
        },
    });
}

function fn_goHome() {
     <%--작업시작 처음 화면으로 넘어감.--%>
    go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goPrevPage() {
    go_url('<c:url value="/prod/process/selectWorkDeptList.do?type=" />' + "${searchVO.type}");
}

function fn_goMovePage(flag) {
    if (flag === 8) {
        go_url('<c:url value="/prod/process/WarehousingRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 10) {
        go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + flag + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 11) {
        go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 12) {
        go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val());
    } else if (flag === 13) {
        go_url('<c:url value="/prod/process/WorkOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else {
        go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
    }
}

function fn_ready() {
    extToastView("준비중입니다...");
    return;
}

function setLovList() {
    // 기종 Lov
    $("#searchCarTypeName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            var emptyValue = "";
            //        $("#searchCarTypeName").val(emptyValue);
            $("#searchCarType").val(emptyValue);

            var itemcode = $("#searchItemCode").val();
            if (itemcode != "") {
                $("#searchItemCode").val(emptyValue);
                $("#searchItemName").val(emptyValue);
            }

            var itemstandarddetail = $("#searchItemStandardDetail").val();
            if (itemstandarddetail != "") {
                $("#searchItemStandardDetail").val(emptyValue);
            }

            var routingid = $("#searchRoutingId").val();
            if (routingid != "") {
                $("#searchRoutingId").val(emptyValue);
                $("#searchRoutingNo").val(emptyValue);
                $("#searchRoutingName").val(emptyValue);
            }
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .bind("keyup", function (e) {
        if (this.value === "")
            $(this).autocomplete("search", "%");
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .click(function (e) {
        $(this).autocomplete("search", "%");
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchWorkModelList.do' />", {
                keyword: $("#searchCarTypeName").val(), // extractLast(request.term),
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                WORKCENTERCODE: global_work_center_code,
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.LABEL + ", " + m.ITEMNAME,
                            value: m.VALUE,
                            CARTYPE: m.VALUE,
                            CARTYPENAME: m.LABEL,
                            ITEMCODE: m.ITEMCODE,
                            ITEMNAME: m.ITEMNAME,
                        });
                    }));
            });
        },
        search: function () {
            if (this.value === "")
                return;

            var term = extractLast(this.value);
            if (term.length < 1) {
                return false;
            }
        },
        focus: function () {
            return false;
        },
        select: function (e, o) {
            $("#searchCarType").val(o.item.CARTYPE);
            $("#searchCarTypeName").val(o.item.CARTYPENAME);
            $("#searchItemCode").val(o.item.ITEMCODE);
            $("#searchItemName").val(o.item.ITEMNAME);

            var itemstandarddetail = $("#searchItemStandardDetail").val();
            if (itemstandarddetail != "") {
                $("#searchItemStandardDetail").val(emptyValue);
            }

            var routingid = $("#searchRoutingId").val();
            if (routingid != "") {
                $("#searchRoutingId").val(emptyValue);
                $("#searchRoutingNo").val(emptyValue);
                $("#searchRoutingName").val(emptyValue);
            }

            fn_search();

            return false;
        }
    });

    // 타입 Lov
    $("#searchItemStandardDetail").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            var emptyValue = "";
            //        $("#searchItemStandardDetail").val(emptyValue);

            var routingid = $("#searchRoutingId").val();
            if (routingid != "") {
                $("#searchRoutingId").val(emptyValue);
                $("#searchRoutingNo").val(emptyValue);
                $("#searchRoutingName").val(emptyValue);
            }
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .bind("keyup", function (e) {
        if (this.value === "")
            $(this).autocomplete("search", "%");
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .click(function (e) {
        $(this).autocomplete("search", "%");
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchWorkItemStandardDList.do' />", {
                keyword: $("#searchItemStandardDetail").val(), // extractLast(request.term),
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                WORKCENTERCODE: global_work_center_code,
                MODEL: $('#searchCarType').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: ((m.ITEMSTANDARDDETAIL == null) ? "없음" : m.ITEMSTANDARDDETAIL) + ", " + m.ITEMNAME,
                            value: m.ITEMSTANDARDDETAIL,
                            ITEMSTANDARDDETAIL: m.ITEMSTANDARDDETAIL,
                            ITEMCODE: m.ITEMCODE,
                            ITEMNAME: m.ITEMNAME,
                        });
                    }));
            });
        },
        search: function () {
            if (this.value === "")
                return;

            var term = extractLast(this.value);
            if (term.length < 1) {
                return false;
            }
        },
        focus: function () {
            return false;
        },
        select: function (e, o) {
            $("#searchItemStandardDetail").val(o.item.ITEMSTANDARDDETAIL);
            $("#searchItemCode").val(o.item.ITEMCODE);
            $("#searchItemName").val(o.item.ITEMNAME);

            var routingid = $("#searchRoutingId").val();
            if (routingid != "") {
                $("#searchRoutingId").val(emptyValue);
                $("#searchRoutingNo").val(emptyValue);
                $("#searchRoutingName").val(emptyValue);
            }

            fn_search();

            return false;
        }
    });

    // 공정 Lov
    $("#searchRoutingName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            var emptyValue = "";
            //        $("#searchRoutingName").val(emptyValue);
            $("#searchRoutingId").val(emptyValue);
            $("#searchRoutingNo").val(emptyValue);

            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .bind("keyup", function (e) {
        if (this.value === "")
            $(this).autocomplete("search", "%");
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .click(function (e) {
        $(this).autocomplete("search", "%");
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchRoutingItemLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                ITEMCODE: $('#searchItemCode').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.ROUTINGNAME,
                            value: m.ROUTINGNAME,
                            ROUTINGCODE: m.ROUTINGCODE,
                            ROUTINGNO: m.ROUTINGNO,
                            ROUTINGNAME: m.ROUTINGNAME,
                        });
                    }));
            });
        },
        search: function () {
            if (this.value === "")
                return;

            var term = extractLast(this.value);
            if (term.length < 1) {
                return false;
            }
        },
        focus: function () {
            return false;
        },
        select: function (e, o) {
            $("#searchRoutingId").val(o.item.ROUTINGCODE);
            $("#searchRoutingNo").val(o.item.ROUTINGNO);
            $("#searchRoutingName").val(o.item.ROUTINGNAME);

            return false;
        }
    });
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_tab(flag) {
    $("#tab2").removeClass("active");

    $('#tabclick').val(flag);

    switch (flag) {
    case "2":
        // 불량유형등록
        $("#tab2").addClass("active");

        //         $('#field_fault').show();
        //         Ext.getCmp(gridnms["views.fault"]).show();
        $('#btn_tab_add').show();
        $('#btn_tab_sav').show();
        //         $('#btn_tab_del').hide(500);
        break;
    default:
        break;
    }

    fn_tab_search(flag);
}

function fn_tab_search(flag) {

    var orgid = $("#orgid").val();
    var companyid = $("#companyid").val();
    var workorderid = $("#workorderid").val();
    var workorderseq = $("#workorderseq").val();
    var itemcode = $("#itemcode").val();
    var routingid = $("#routingcode").val();
    var workcentercode = global_work_center_code;

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        WORKORDERID: workorderid,
        WORKORDERSEQ: workorderseq,
        WORKCENTERCODE: workcentercode,
        SEARCHGUBUN: 'TODAY',
    };

    switch (flag) {
    case "2":
        // 불량유형등록
        extGridSearch(sparams, gridnms["store.3"]);

        // 작업자
        var sparams1 = {
            ORGID: orgid,
            COMPANYID: companyid,
            WORKCENTERCODE: workcentercode,
            WORKDEPT: "${searchVO.gubun}",
        };
        extGridSearch(sparams1, gridnms["store.31"]);

        break;
    default:
        break;
    }
}

function fn_btn_add() {
    var flag = $('#tabclick').val();
    switch (flag) {
    case "2":
        // 불량유형등록
        var model = Ext.create(gridnms["model.3"]);
        var store = Ext.getStore(gridnms["store.3"]);

        var workorderseq = $("#workorderseq").val();
        var work = $("#worker").val();
        if (workorderseq == null || workorderseq == "") {
            extToastView("작업지시 항목을 선택해주세요.");
            return;
        }
        if (work == null || work == "") {
            extToastView("작업중인 작업자가 없습니다. </BR> 실적을 입력해주세요.");
            return;
        }

        model.set("SEQNO", Ext.getStore(gridnms["store.3"]).count() + 1);
        model.set("RN", Ext.getStore(gridnms["store.3"]).count() + 1);
        model.set("ORGID", $("#orgid").val());
        model.set("COMPANYID", $("#companyid").val());
        model.set("WORKORDERID", $("#workorderid").val());
        model.set("WORKORDERSEQ", $("#workorderseq").val());
        model.set("ITEMCODE", $("#itemcode").val());
        model.set("WORKER", $("#worker").val());
        model.set("WORKERNAME", $("#workername").val());
        model.set("WORKCENTERCODE", $("#workcentercode").val());

        var today = new Date();

        var start = Ext.util.Format.date(today, 'Y-m-d H:i');
        model.set("FAULTDATE", start);

        store.insert(0, model);

        fn_grid_focus_move("UP", gridnms["store.3"], gridnms["views.fault"], 0, 4);

        break;
    default:
        break;
    }
}

function fn_btn_save() {
    var flag = $('#tabclick').val();
    var rowindex = rowIdx;

    switch (flag) {
    case "2":
        // 불량유형등록
        var count1 = Ext.getStore(gridnms["store.3"]).count();
        var header = [],
        count = 0;

        if (count1 > 0) {
            for (i = 0; i < count1; i++) {
                Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.fault"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.fault"]).selModel.getSelection()[0];

                var worker = model1.data.WORKER;
                var faultdate = model1.data.FAULTDATE;
                var faulttype = model1.data.FAULTTYPE;
                var faultqty = model1.data.FAULTQTY;

                if (worker == "" || worker == undefined) {
                    header.push("담당자");
                    count++;
                }
                if (faultdate == "" || faultdate == undefined) {
                    header.push("일시");
                    count++;
                }

                if (faulttype == "" || faulttype == undefined) {
                    header.push("불량유형");
                    count++;
                }

                if (!(faultqty > 0)) {
                    header.push("불량갯수");
                    count++;
                }

                if (count > 0) {
                    extAlert("[공정검사 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                    return;
                }
            }
        }

        Ext.getStore(gridnms["store.3"]).sync({
            success: function (batch, options) {
                msg = "[불량등록] " + msgs.noti.save;

                //              Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                //              Ext.getCmp(gridnms["views.list"]).doLayout();

                extToastView(msg);

                //              Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                //                  row: rowIdx,
                //                  column: colIdx,
                //                  animate: false
                //              });
                Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                    Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx)
                    Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                });
                fn_tab_load();
            },
            failure: function (batch, options) {
                extToastView(batch.exceptions[0].error);
            },
            callback: function (batch, options) {},
        });

        break;
    default:
        break;
    }
}

function fn_tab_load() {
    var restore = Ext.getCmp(gridnms["views.list"]).getSelectionModel().selected.items[0].data;
    // 작업항목 선택시
    var orgid = restore.ORGID;
    var companyid = restore.COMPANYID;
    var workorderid = restore.WORKORDERID;
    var workorderseq = restore.WORKORDERSEQ;
    var itemcode = restore.ITEMCODE;
    var routingcode = restore.ROUTINGID;
    var worker = restore.WORKER;
    var workername = restore.WORKERNAME;

    $("#orgid").val(orgid);
    $("#companyid").val(companyid);
    $("#workorderid").val(workorderid);
    $("#workorderseq").val(workorderseq);
    $("#itemcode").val(itemcode);
    $("#routingcode").val(routingcode);
    $("#worker").val(worker);
    $("#workername").val(workername);

    fn_tab($('#tabclick').val());
}

function fn_btn_delete() {
    var flag = $('#tabclick').val();
    var rowindex = Ext.getStore(gridnms["store.1"]).indexOf(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0]);

    switch (flag) {
    case "2":
        // 불량유형등록
        break;
    default:
        break;
    }
}

var selected_columnIndex = "", selected_value = "", selected_rowIdx = 0, selected_colIdx = 0, selected_storenm = "", selected_viewnm = "";
function fn_keypad_open() {
    popup_flag = "NUM";
    var remarks = "";
    fn_global_keypad_popup(selected_columnIndex, selected_value, popup_flag, remarks, selected_rowIdx, selected_colIdx, selected_storenm, selected_viewnm);

    global_keypad_win.setPosition(320, 119, false);
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
    <!-- 현재위치 네비게이션 시작 -->
    <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
        <div style="width: 100%; padding-left: 0px;">
            <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)">
                <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                <input type="hidden" id="workorderid" name="workorderid" />
                <input type="hidden" id="workorderseq" name="workorderseq" />
                <input type="hidden" id="itemcode" name="itemcode" />
                <input type="hidden" id="routingcode" name="routingcode" />
                <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                <input type="hidden" id="workcentercode" name="workcentercode" />
                <input type="hidden" id="workcentername" name="workcentername" />
                <input type="hidden" id="worker" name="worker" value="${WORKER}" />
                <input type="hidden" id="workername" name="workername" value="${WORKERNAME}" />
                <input type="hidden" id="tabclick" name="tabclick" />
                <c:choose>
                    <c:when test="${searchVO.work == 'Y'}">
                        <div id="menuArea" style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                             <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                     생산실적<br/>( TOUCH ) -->
<!--                             </button> -->
                            <button type="button" class="white_selected h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                    생산실적<br/>( TOUCH )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                    래핑/연마입력<br/>( RESULT )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                    자주검사<br/>( CHECK SHEET )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                    공구변경<br/>( TOOL CHANGE )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                    외주발주<br/>( ORDER )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                    외주입고<br/>( REGISTER )
                            </button>
                            <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                    반입반출<br/>( STORED & RELEASED )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                    설비변경<br/>( FACILITIES )
                            </button>
                        </div>
                        <div id="logoutArea" style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
                            <button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
                                    나가기<br/>( LOGOUT )
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div id="menuArea" style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
                            <button type="button" class="btn_work_home blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">
                                    HOME
                            </button>
                            <button type="button" class="btn_work_prev blue3 h " onclick="fn_goPrevPage( );" style="width: 8%; height: 63px; float: left';">
                                    이전화면<br/>( BACK )
                            </button>
<!--                             <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                     생산실적<br/>( TOUCH ) -->
<!--                             </button> -->
                            <button type="button" class="white_selected h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                    생산실적<br/>( TOUCH )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                    래핑/연마입력<br/>( RESULT )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                    자주검사<br/>( CHECK SHEET )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                    공구변경<br/>( TOOL CHANGE )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                    외주발주<br/>( ORDER )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                    외주입고<br/>( REGISTER )
                            </button>
                            <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                    반입반출<br/>( STORED & RELEASED )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                    설비변경<br/>( FACILITIES )
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
                <table style="width: 100%; height: auto; ">
                    <colgroup>
                        <col>
                        <col>
                    </colgroup>
                    <tbody>
                        <tr>
                            <td colspan="2">
                                <div id="equipmentbuttons" style="width: 100%; padding-left: 10px; margin-bottom: 5px;"></div>
                            </td>
                        </tr>
                        <tr>
                            <td valign="top" style="padding-right: 15px;">
                                <div id="workdivbuttons" >
                                    <button type="button" id="WORKDIV_01" class="blue2 h r shadow " onclick="fn_btn_click('WORK_DIV', '01' );" style="width: 105px; height: 45px; font-size: 22px; font-weight: bold; color: #fff; margin-left: 15px; margin-bottom: 10px; disabled">
                                            주간
                                    </button>
                                    <button type="button" id="WORKDIV_02" class="blue2 h r shadow " onclick="fn_btn_click('WORK_DIV', '02' );" style="width: 105px; height: 45px; font-size: 22px; font-weight: bold; color: #fff; margin-left: 5px; margin-right: 5px; margin-bottom: 10px; disabled">
                                            야간
                                    </button>
                                </div>
                                <table class="ResultTable" style="width: 100%; height: 100px; margin-left: 15px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; ">
                                    <colgroup>
                                        <col width="140px;">
                                        <col>
                                        <col width="140px;">
                                        <col>
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>기종</th>
                                            <td>
                                                <input id="searchCarTypeName" name="searchCarTypeName" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 100%; height: 100%; margin: 0px; " />
                                                <input type="hidden" id="searchCarType" name="searchCarType" /> 
                                            </td>
                                            <th>제품</th>
                                            <td>
                                                <input id="searchItemName" name="searchItemName" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 100%; height: 100%; margin: 0px; " readonly />
                                                <input type="hidden" id="searchItemCode" name="searchItemCode" /> 
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="height: 10px;"></td>
                                        </tr>
                                        <tr>
                                            <th>타입</th>
                                            <td>
                                                <input id="searchItemStandardDetail" name="searchItemStandardDetail" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 100%; height: 100%; margin: 0px; " />
                                            </td>
                                            <th>공정</th>
                                            <td>
                                                <input id="searchRoutingName" name="searchRoutingName" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 100%; height: 100%; margin: 0px; " />
                                                <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
                                                <input type="hidden" id="searchRoutingNo" name="searchRoutingNo" />  
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="4" style="height: 10px;"></td>
                                        </tr>
                                        <tr>
                                            <td colspan=4>
                                                <button type="button" class="blue2 h r shadow " onclick="fn_search();" style="width: 45%; height: 90px; font-size: 40px; font-weight: bold; color: #fff; margin-left: 0px; margin-right: 1%; margin-bottom: 10px; float: left; disabled">
                                                        조 회 ( SEARCH )
                                                </button>
                                                <button type="button" class="blue2 h r shadow " onclick="fn_work_create();" style="width: 53%; height: 90px; font-size: 40px; font-weight: bold; color: #fff; margin-left: 1%; margin-right: 0px; margin-bottom: 10px; float: left; disabled">
                                                        작업지시 추가 ( CREATE )
                                                </button>
<!--                                                 <button type="button" class="blue h r shadow " onclick="fn_keypad_open();" style="width: 33%; height: 90px; font-size: 40px; font-weight: bold; color: #fff; margin-left: 1%; margin-right: 5px; margin-bottom: 10px; float: left; disabled"> -->
<!--                                                         KEYPAD -->
<!--                                                 </button> -->
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td>
                                <center id="workerbuttons" style="width: 100%; margin-bottom: 5px;"></center>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <div id="gridArea" style="width: 100%; margin-top: 0px; margin-bottom: 15px; float: left;"></div>
                
                <table style="width: 100%; margin-top: 15px;">
                        <tr style="height: 28px;">
                                <td style="width: 100%;">
                                    <div class="tab line" style="width: calc(100% - 85%); height: 39px; padding-bottom: 0px; float: left;">
                                            <ul>
                                                    <li id="tab2"><a href="#" onclick="javascript:fn_tab('2');" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">불량유형등록</span></a></li>
                                            </ul>
                                    </div>
                                    <div style="width: calc(100% - 15%); height: 39px; border-bottom: 1px solid #0074bd; float: right;">
                                            <button type="button" id="btn_tab_add" class="blue2 r shadow" onclick="fn_btn_add();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">추가 (Add)</button>
                                            <button type="button" id="btn_tab_sav" class="blue2 r shadow" onclick="fn_btn_save();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">저장 (Save)</button>
<!--                                             <button type="button" id="btn_tab_del" class="blue2 r shadow" onclick="fn_btn_delete();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">삭제 (Del)</button> -->
                                    </div>
                                </td>
                        </tr>
                </table>
                <div id="field_fault">
                        <div id="gridArea2" style="width: 100%; margin-top: 0px; margin-bottom: 10px; margin-left: 0px; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
                </div>
            </form>
        </div>
    </div>
    <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
    <div id="loadingBar" style="display: none;">
        <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading" />
    </div>
</body>
</html>