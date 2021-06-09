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
    line-height: 110%;
    font-weight: bold;
    background-color: #5B9BD5;
    color: white;
    padding-left: 0px;
    padding-right: 0px;
}

.FML .x-grid-cell-inner {
  padding-left : 0px;
  padding-right : 0px;
}

.x-grid-cell-inner {
position: relative;
text-overflow: ellipsis;
padding-top: 10px;
padding-left : 10px;
height: 45px;
font-size: 18px !important;
font-weight: bold;
}


.x-btn {
margin-top : 2px;
height: 39px;
}

.x-btn-inner {
font-size : 14px !important;
}


#gridArea .x-form-field {
    font-size: 18px; 
    font-weight: bold;
}

#gridArea1 .x-form-field {
    font-size: 18px; 
    font-weight: bold;
}

#gridArea2 .x-form-field {
    font-size: 18px; 
    font-weight: bold;
}

#gridArea3 .x-form-field {
    font-size: 18px; 
    font-weight: bold;
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
	font-size: 20px;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	border-bottom: 1px solid white;
}

.ResultTable td {
	font-size: 20px;
	color: black;
	text-align: center;
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

    // 최초 실행시 첫번째 탭 활성화
    setTimeout(function () {
        //      fn_tab('1');
        //      fn_search();
    }, 200);
});

function setInitial() {
    gridnms["app"] = "process";

    //실적화면 공정lot 스캔 기능 ->// 화면 list up 형태로 변경에 따른 주석 처리
    $('#routingLot').bind("mousedown", function (e) {
        fn_find_check();
    });
    $('#routingLot').bind("keyup", function (e) {
        if (e.keyCode == 13) {
            fn_find_check();
        }
    });

    // 입고검사등록 버튼 숨기기
    var workdept = $("#workdept").val();
    if (workdept == "B" || workdept == "C") {
        $('#inspbtn').hide();
    } else {
        $('#inspbtn').hide();
    }
    if (workdept != "D") {
        $("#barcodebutton").hide();
        $("#barcodebutton2").hide();
    }
}

function fn_find_check() {
    var routingLot = $('#routingLot').val();

    if (routingLot === "") {
        // 자재 LOT 를 입력하지 않았을 경우
    } else {
        // 자재 LOT 를 입력했을 때 레코드 추가 및 자동 저장 처리

        // 한줄 추가/ lotno 입력
        fn_btn_item_input();
    }
}

function fn_btn_item_input() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var workorderid = $('#workorderid').val();
    var workorderseq = $('#workorderseq').val();
    var routingLot = $('#routingLot').val();
    var routingcode = $('#routingcode').val();
    var equipmentcode = $('#equipmentcode').val();

    if (workorderid == "") {
        extToastView("작업지시가 선택되지 않았습니다.<br/>다시 한번 확인해주십시요.");
        return;
    }

    if (equipmentcode == "") {
        extToastView("작업지시가 선택되지 않았습니다.<br/>다시 한번 확인해주십시요.");
        return;
    }

    if (routingLot == "") {
        extToastView("자재LOT가 선택되지 않았습니다.<br/>다시 한번 확인해주십시요.");
        return;
    }

    var model = Ext.create(gridnms["model.3"]);
    var store = Ext.getStore(gridnms["store.3"]);

    model.set("RN", Ext.getStore(gridnms["store.3"]).count() + 1);
    model.set("ORGID", orgid);
    model.set("COMPANYID", companyid);
    model.set("WORKORDERID", workorderid);
    model.set("WORKORDERSEQ", workorderseq);
    model.set("LOTNO", routingLot);

    //     lot 선택
    var result = {};
    var url = '<c:url value="/searchWorkOrderLotList.do"/>'; // 발주,작지 JOIN한 VIEW

    if (routingLot !== "") {
        var params = {
            ORGID: orgid,
            COMPANYID: companyid,
            LOTNO: routingLot,
            ROUTINGID: routingcode,
            EQUIPMENTCODE: equipmentcode,
        };

        $.ajax({
            url: url,
            type: 'post',
            async: false,
            data: params,
            success: function (data) {
                //비동기화 호출 순서로 인하여 success 펑션 사용안함.(done 펑션으로 대체)
            }
        }).done(function (data) {
            //호출 성공시
            var rscode = data.RETURNSTATUS;
            var errmsg = data.MSGDATA;
            var itemcode = data.ITEMCODE;
            var itemname = data.ITEMNAME;
            var ordername = data.ORDERNAME;
            var uom = data.UOM;
            var uomname = data.UOMNAME;
            var model = data.MODEL;
            var modelname = data.MODELNAME;
            var lotno = data.LOTNO;
            var lotqty = data.LOTQTY;
            var bomqty = data.BOMQTY;
            var bomrate = data.BOMRATE;
            var managecode = data.MANAGECODE;
            var managename = data.MANAGENAME;

            if (rscode === "N" || rscode === "E") {
                extToastView("[확인]" + errmsg);
                return;
            } else {
                result.ORGID = orgid;
                result.COMPANYID = companyid;
                result.WORKORDERID = workorderid;
                result.WORKORDERSEQ = workorderseq;
                result.ITEMCODE = itemcode;
                result.ITEMNAME = itemname;
                result.ORDERNAME = ordername;
                result.UOM = uom;
                result.UOMNAME = uomname;
                result.LOTNO = lotno;
                result.LOTQTY = lotqty;
                result.BOMQTY = bomqty;
                result.BOMRATE = bomrate;
                result.MANAGECODE = managecode;
                result.MANAGENAME = managename;
                result.RSCODE = rscode;
            }

        });
    } else {
        result = null;
    }

    if (result.RSCODE === "Y") {
        model.set("ORGID", result.ORGID);
        model.set("COMPANYID", result.COMPANYID);
        model.set("WORKORDERID", result.WORKORDERID);
        model.set("WORKORDERSEQ", result.WORKORDERSEQ);
        model.set("ITEMCODE", result.ITEMCODE);
        model.set("ITEMNAME", result.ITEMNAME);
        model.set("ORDERNAME", result.ORDERNAME);
        model.set("UOMNAME", result.UOMNAME);
        model.set("QTY", result.LOTQTY);
        model.set("LOTNO", result.LOTNO);
        model.set("BOMQTY", result.BOMQTY);
        model.set("BOMRATE", result.BOMRATE);
        model.set("MANAGENAME", result.MANAGENAME);
        store.insert(Ext.getStore(gridnms["store.3"]).count() + 1, model);
    }
    $('#routingLot').val("");
}

function setValues() {
    setValues_list();
    setValues_result();
    setValues_fault();
    setValues_operate();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkOrderList";

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
            type: 'string',
            name: 'RK',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'WORKTYPE',
        }, {
            type: 'string',
            name: 'WORKTYPENAME',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'WORKSTATUSNAME',
        }, {
            type: 'string',
            name: 'GROUPCODE',
        }, {
            type: 'string',
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGOP',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'EQUIPMENTCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'number',
            name: 'WORKORDERQTY',
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
            name: 'ITEMSTANDARD',
        }, {
            type: 'number',
            name: 'BOXCNT',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'number',
            name: 'WORKORDERQTY',
        }, {
            type: 'number',
            name: 'PRODUCEDQTY',
        }, {
            type: 'number',
            name: 'IMPORTQTY',
        }, {
            type: 'number',
            name: 'DEFECTEDQTY',
        }, {
            type: 'date',
            name: 'WORKPLANSTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKPLANENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKSTARTDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'WORKENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'PREWORKQTY',
        }, {
            type: 'number',
            name: 'CYCLEQTY',
        }, {
            type: 'string',
            name: 'DAYIMPORTQTY',
        }, {
            type: 'string',
            name: 'DAYFAULTQTY',
        }, {
            type: 'string',
            name: 'WORKER',
        }, {
            type: 'string',
            name: 'WORKERNAME2',
        }, {
            type: 'string',
            name: 'WORKERNAME',
        }, ];

    fields["columns.1"] = [{
            dataIndex: 'RN',
            text: '순<br/>번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 260,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'CARTYPENAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '타입',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            resizable: false,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비<br/>번호',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKERNAME',
            text: '작업자',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'FMLYN',
            text: '자주검사<BR/>여부',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'DAYIMPORTQTY',
            text: '일일양품<br/>수량',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DAYFAULTQTY',
            text: '일일불량<br/>수량',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ROUTINGOP',
            text: '공정<br/>순번',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKORDERQTY',
            text: '작지<br/>수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'IMPORTQTY',
            text: '양품<br/>수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DEFECTEDQTY',
            text: '불량<br/>수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKSTATUSNAME',
            text: '상태',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            resizable: false,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
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
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTYPENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQUIPMENTCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQUIPMENTNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUSNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'IMPORTQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'DEFECTEDQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKPLANSTARTDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTARTDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKENDDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SNP',
            xtype: 'hidden',
        }, {
            dataIndex: 'RK',
            xtype: 'hidden',
        }, {
            dataIndex: 'PREWORKQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'CYCLEQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKER',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKER2NAME',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/process/selectWorkOrderRegist.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/insert/prod/process/selectWorkOrderRegist.do' />"
    });

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
    if (e != null) {
        rowIdx = e.position.rowIdx;
        colIdx = e.position.colIdx;
    }

    // 작업항목 선택시
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var workorderid_old = $('#workorderid').val();
    var workorderid = record.data.WORKORDERID;
    var workorderseq = record.data.WORKORDERSEQ;
    var itemcode = record.data.ITEMCODE;
    var routingcode = record.data.ROUTINGCODE;
    var lotno = record.data.LOTNO;
    var workstatus = record.data.WORKSTATUS;
    var equipmentcode = record.data.EQUIPMENTCODE;
    var equipmentname = record.data.EQUIPMENTNAME;
    var workcentercode = record.data.WORKCENTERCODE;
    var workcentername = record.data.WORKCENTERNAME;
    var worker = record.data.WORKER;
    var workername = record.data.WORKER2NAME;
    var snp = record.data.SNP;
    var capacityequip = record.data.CAPACITYEQUIP;
    var wastage = record.data.WASTAGE; // 소요량
    var workorderqty = record.data.WORKORDERQTY; // 작지수량
    var importqty = record.data.IMPORTQTY; // 양품수량
    var rank = record.data.RK; // 마지막공정확인
    var unitpercnt = record.data.UNITPERCNT; // 설비 수량구분
    var workcentercodeif = record.data.WORKCENTERCODEIF; // 설비 수량구분
    var preworkqty = record.data.PREWORKQTY; // 이전공정의 양품수량
    var cycleqty = record.data.CYCLEQTY; // 검사주기수량
    clickindex2 = record.data.RN;
    g_count = 0;

    $("#orgid").val(orgid);
    $("#companyid").val(companyid);
    $("#workorderid").val(workorderid);
    $("#workorderseq").val(workorderseq);
    $("#itemcode").val(itemcode);
    $("#routingcode").val(routingcode);
    $("#equipmentcode").val(equipmentcode);
    $("#equipmentname").val(equipmentname);
    $("#workcentercode").val(workcentercode);
    $("#workcentername").val(workcentername);
    $("#lotno").val(lotno);
    $("#workstatus").val(workstatus);
    $("#worker").val(worker);
    $("#workername").val(workername);
    $("#snp").val(snp);
    $("#capacityequip").val(capacityequip);
    $("#wastage").val(wastage);
    $("#workorderqty").val(workorderqty);
    $("#importqty").val(importqty);
    $("#rank").val(rank);
    $("#unitpercnt").val(unitpercnt);
    $("#workcentercodeif").val(workcentercodeif);
    $("#preworkqty").val(preworkqty);
    $("#cycleqty").val(cycleqty);

    fn_tab($('#tabclick').val());
};

function setValues_result() {
    gridnms["models.result"] = [];
    gridnms["stores.result"] = [];
    gridnms["views.result"] = [];
    gridnms["controllers.result"] = [];

    gridnms["grid.2"] = "WorkResultList";
    gridnms["grid.21"] = "workdivLov"; // 주야구분 LOV
    gridnms["grid.22"] = "WorkerResultLov"; // 작업자 LOV
    gridnms["grid.23"] = "workcenterResultLov"; // 설비명 LOV
    gridnms["grid.24"] = "cavityLov"; // OK/NG LOV

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.result"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.result"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
    gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];
    gridnms["model.22"] = gridnms["app"] + ".model." + gridnms["grid.22"];
    gridnms["model.23"] = gridnms["app"] + ".model." + gridnms["grid.23"];
    gridnms["model.24"] = gridnms["app"] + ".model." + gridnms["grid.24"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
    gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];
    gridnms["store.22"] = gridnms["app"] + ".store." + gridnms["grid.22"];
    gridnms["store.23"] = gridnms["app"] + ".store." + gridnms["grid.23"];
    gridnms["store.24"] = gridnms["app"] + ".store." + gridnms["grid.24"];

    gridnms["models.result"].push(gridnms["model.2"]);
    gridnms["models.result"].push(gridnms["model.21"]);
    gridnms["models.result"].push(gridnms["model.22"]);
    gridnms["models.result"].push(gridnms["model.23"]);
    gridnms["models.result"].push(gridnms["model.24"]);

    gridnms["stores.result"].push(gridnms["store.2"]);
    gridnms["stores.result"].push(gridnms["store.21"]);
    gridnms["stores.result"].push(gridnms["store.22"]);
    gridnms["stores.result"].push(gridnms["store.23"]);
    gridnms["stores.result"].push(gridnms["store.24"]);

    fields["model.2"] = [{
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
            type: 'string',
            name: 'WORKER',
        }, {
            type: 'string',
            name: 'WORKERNAME',
        }, {
            type: 'number',
            name: 'SEQNO',
        }, {
            type: 'string',
            name: 'WORKTIME',
        }, {
            type: 'number',
            name: 'QTY',
        }, {
            type: 'number',
            name: 'PLANQTY',
        }, {
            type: 'number',
            name: 'HAPQTY',
        }, {
            type: 'number',
            name: 'PREQTY',
        }, {
            type: 'number',
            name: 'CYCLEQTY',
        }, {
            type: 'number',
            name: 'CHECKQTY',
        }, {
            type: 'string',
            name: 'LOTNO',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'OUTTRANSNO',
        }, {
            type: 'number',
            name: 'OUTTRANSSEQ',
        }, {
            type: 'string',
            name: 'WORKHOUR',
        }, {
            type: 'string',
            name: 'WORKTIEM',
        }, {
            type: 'number',
            name: 'WORKTIMEMIN',
        }, {
            type: 'string',
            name: 'WORKER5NAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'EQUIPMENTIF',
        }, {
            type: 'date',
            name: 'STARTTIME',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'ENDTIME',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'string',
            name: 'RN',
        }, {
            type: 'string',
            name: 'ATTAINMENTRATE',
        }, {
            type: 'string',
            name: 'WORKDIV',
        }, {
            type: 'string',
            name: 'WORKDIVNAME',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'FMLID',
        },
    ];

    fields["model.21"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.22"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.23"] = [{
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'CAPA',
        }, ];

    fields["model.24"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.2"] = [{
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
            renderer: function (value, meta, record) {

                return value;
            },
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '시작시간<br/>적용',
            width: 100,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "시작시간",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var today = new Date();
                    var pre_time = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 07, 00, 0);
                    var post_time = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 19, 00, 0);

                    var preCheck = ((today.getTime() > pre_time.getTime()) && (today.getTime() < post_time.getTime())) ? "주간" : "야간";

                    if (preCheck == "주간") {
                        record.set("WORKDIV", "01");
                        record.set("WORKDIVNAME", "주간");
                    } else {
                        record.set("WORKDIV", "02");
                        record.set("WORKDIVNAME", "야간");
                    }

                    /////////////////////////////////////////////////////////////////////////// 작업시간(시간) 계산
                    var start = Ext.util.Format.date(today, 'Y-m-d H:i');
                    var time = Ext.util.Format.date(today, 'H');
                    record.set("STARTTIME", start);
                    var workhours = 0;

                    if (record.data.STARTTIME != "" && record.data.STARTTIME != null && record.data.ENDTIME != "" && record.data.ENDTIME != null) {
                        var workstart = new Date(start);
                        var startdate = workstart.getDate();
                        var starthours = workstart.getHours();

                        var workend = new Date(record.data.ENDTIME);
                        var enddate = workend.getDate();
                        var endhours = workend.getHours();

                        if (workend != workstart) {
                            workhours = ((enddate - startdate) * 24) + endhours - starthours
                        } else {
                            workhours = endhours - starthours; // 종료일의 시간 - 시작일의 시간
                        }

                        record.set("WORKTIME", workhours);
                    }
                    /////////////////////////////////////////////////////////////////////////// 작업시간(시간) 계산

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'STARTTIME',
            text: '시작시간',
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
                altFormats: 'Y-m-d H:i|YmdHi|Y m d H i|Ymd Hi|Y-m-d Hi|Y-m-dHi',
                height: 45,
                triggerCls: 'trigger-datefield-custom',
                listeners: {
                    select: function (field, record) {
                        var selectedRow = Ext.getCmp(gridnms["views.result"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

                        var temp = Ext.Date.format(field.getValue(), 'Y-m-d');
                        var startdate = new Date(temp);
                        var date = startdate.getDate();
                        var today = new Date();
                        var hours = today.getHours();
                        var minutes = today.getMinutes();

                        startdate.setHours(hours);
                        startdate.setMinutes(minutes);

                        var start = Ext.util.Format.date(startdate, 'Y-m-d H:i');
                        field.setValue(start);

                        //////////////////////////////////////////////////////작업시간 계산
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

                        var pre_time = new Date(startdate.getFullYear(), startdate.getMonth(), startdate.getDate(), 07, 00, 0);
                        var post_time = new Date(startdate.getFullYear(), startdate.getMonth(), startdate.getDate(), 19, 00, 0);

                        var preCheck = ((startdate.getTime() > pre_time.getTime()) && (startdate.getTime() < post_time.getTime())) ? "주간" : "야간";

                        if (preCheck == "주간") {
                            model.set("WORKDIV", "01");
                            model.set("WORKDIVNAME", "주간");
                        } else {
                            model.set("WORKDIV", "02");
                            model.set("WORKDIVNAME", "야간");
                        }

                        if (model.data.ENDTIME != "" && model.data.ENDTIME != null) {
                            var workend = new Date(model.data.ENDTIME);
                            var endtemp = Ext.Date.format(workend, 'Y-m-d H:i');
                            var enddate = workend.getDate();
                            var endhours = workend.getHours();
                            var endmin = workend.getMinutes();
                            var workhours = 0;

                            if (date != enddate) {
                                workhours = ((enddate - date) * 24) + endhours - hours
                            } else {
                                workhours = endhours - hours; // 종료일의 시간 - 시작일의 시간
                            }

                            model.set("WORKTIME", workhours);
                        }
                        ////////////////////////////////////////////////////// 작업시간 계산끝

                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);
                        var workhours = 0;
                        var workstart = new Date(value.getValue());

                        var pre_time = new Date(workstart.getFullYear(), workstart.getMonth(), workstart.getDate(), 07, 00, 0);
                        var post_time = new Date(workstart.getFullYear(), workstart.getMonth(), workstart.getDate(), 19, 00, 0);

                        var preCheck = ((workstart.getTime() > pre_time.getTime()) && (workstart.getTime() < post_time.getTime())) ? "주간" : "야간";

                        if (preCheck == "주간") {
                            model.set("WORKDIV", "01");
                            model.set("WORKDIVNAME", "주간");
                        } else {
                            model.set("WORKDIV", "02");
                            model.set("WORKDIVNAME", "야간");
                        }

                        if (model.data.STARTTIME != "" && model.data.STARTTIME != null && model.data.ENDTIME != "" && model.data.ENDTIME != null) {
                            var startdate = workstart.getDate();
                            var starthours = workstart.getHours();

                            var workend = new Date(model.data.ENDTIME);
                            var enddate = workend.getDate();
                            var endhours = workend.getHours();

                            if (workend != workstart) {
                                workhours = ((enddate - startdate) * 24) + endhours - starthours
                            } else {
                                workhours = endhours - starthours; // 종료일의 시간 - 시작일의 시간
                            }
                        }

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKTIME", workhours);
                            }
                        }
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
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '종료시간<br/>적용',
            width: 100,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "종료시간",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var today = new Date();

                    var start = Ext.util.Format.date(today, 'Y-m-d H:i');
                    record.set("ENDTIME", start);

                    /////////////////////////////////////////////////////////////////////////// 작업시간(시간) 계산
                    var workhours = 0;

                    if (record.data.STARTTIME != "" && record.data.STARTTIME != null && record.data.ENDTIME != "" && record.data.ENDTIME != null) {
                        var workstart = new Date(record.data.STARTTIME);
                        var startdate = workstart.getDate();
                        var starthours = workstart.getHours();

                        var workend = new Date(start);
                        var enddate = workend.getDate();
                        var endhours = workend.getHours();

                        if (workend != workstart) {
                            workhours = ((enddate - startdate) * 24) + endhours - starthours
                        } else {
                            workhours = endhours - starthours; // 종료일의 시간 - 시작일의 시간
                        }

                        record.set("WORKTIME", workhours);
                    }
                    /////////////////////////////////////////////////////////////////////////// 작업시간(시간) 계산

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'ENDTIME',
            text: '종료시간',
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
                altFormats: 'Y-m-d H:i|YmdHi|Y m d H i|Ymd Hi|Y-m-d Hi|Y-m-dHi',
                height: 45,
                triggerCls: 'trigger-datefield-custom',
                listeners: {
                    select: function (field, record) {
                        var selectedRow = Ext.getCmp(gridnms["views.result"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

                        var temp = Ext.Date.format(field.getValue(), 'Y-m-d');
                        var enddate = new Date(temp);
                        var date = enddate.getDate();
                        var today = new Date();
                        var hours = today.getHours();
                        var min = today.getMinutes();

                        enddate.setHours(hours);
                        enddate.setMinutes(min);

                        var end = Ext.util.Format.date(enddate, 'Y-m-d H:i');
                        field.setValue(end);

                        //////////////////////////////////////////////////////작업시간 계산
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

                        if (model.data.STARTTIME != "" && model.data.STARTTIME != null) {
                            var workstart = new Date(model.data.STARTTIME);
                            var starttemp = Ext.Date.format(workstart, 'Y-m-d H:i');
                            var startdate = workstart.getDate();
                            var starthours = workstart.getHours();
                            var startmin = workstart.getMinutes();
                            var workhours = 0;

                            if (date != startdate) {
                                workhours = ((date - startdate) * 24) + hours - starthours
                            } else {
                                workhours = hours - starthours; // 종료일의 시간 - 시작일의 시간
                            }

                            model.set("WORKTIME", workhours);
                        }
                        ////////////////////////////////////////////////////// 작업시간 계산끝

                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);
                        var workhours = 0;

                        if (model.data.STARTTIME != "" && model.data.STARTTIME != null && model.data.ENDTIME != "" && model.data.ENDTIME != null) {
                            var workstart = new Date(model.data.STARTTIME);
                            var startdate = workstart.getDate();
                            var starthours = workstart.getHours();

                            var workend = new Date(value.getValue());
                            var enddate = workend.getDate();
                            var endhours = workend.getHours();

                            if (workend != workstart) {
                                workhours = ((enddate - startdate) * 24) + endhours - starthours
                            } else {
                                workhours = endhours - starthours; // 종료일의 시간 - 시작일의 시간
                            }
                        }

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKTIME", workhours);
                            }
                        }
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
        }, {
            dataIndex: 'WORKDIVNAME',
            text: '주야구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.21"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);
                        var code = record.data.VALUE;

                        model.set("WORKDIV", code);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKDIV", "");
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
            dataIndex: 'WORKERNAME',
            text: '작업자',
            xtype: 'gridcolumn',
            width: 300,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.22"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);
                        var code = record.data.VALUE;

                        model.set("WORKER", code);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

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
            dataIndex: 'QTY',
            text: '양품수량<br/>(write)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'QTY',
            text: '양품수량<br/>(select)',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.24"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                height: 45,
                maskRe: /[0-9]/,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

                        var preworkqty = ($("#preworkqty").val() * 1); // 전공정 양품수량이 현공정 전체 체크할 것(추가하는거랑 양품수량에 체크박스 선택부분에 넣을 것)
                        var precount = Ext.getStore(gridnms["store.2"]).count();
                        var tempqty = (value.lastValue * 1);
                        if (precount > 0) {
                            for (var i = 0; i < precount; i++) {
                                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(i));
                                var preModel = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

                                var hapqty = (preModel.data.HAPQTY * 1);
                                tempqty += hapqty;
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                    width: 200,
                    maxHeight: 520,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'HAPQTY',
            text: '누계수량',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            format: "0,000",
            renderer: function (value, meta) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                    width: 200,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
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
            style: 'text-align:center',
            align: "center",
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/prod/process/FmlRegist.do?type=' />" + 10
                     + "&gubun=" + record.data.WORKDEPT
                     + "&code=" + record.data.WORKCENTERCODE
                     + "&workorder=" + record.data.WORKORDERID
                     + "&seq=" + record.data.WORKORDERSEQ
                     + "&org=" + record.data.ORGID
                     + "&company=" + record.data.COMPANYID
                     + "&id=" + record.data.FMLID;

                return Ext.String.format(result, url, value);
            },
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'RN',
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
            dataIndex: 'WORKER',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'REMARKS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTTRANSNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTTRANSSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTIME',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTIMEMIN',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'PREQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKER',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMWEIGHT',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDIV',
            xtype: 'hidden',
        }, {
            dataIndex: 'SNP',
            xtype: 'hidden',
        }, {
            dataIndex: 'PRINTCNT',
            xtype: 'hidden',
        }, {
            dataIndex: 'CYCLEQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDEPT',
            xtype: 'hidden',
        }, {
            dataIndex: 'FMLID',
            xtype: 'hidden',
        },
    ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        create: "<c:url value='/insert/prod/process/WorkFaultListH.do' />"
    });
    $.extend(items["api.2"], {
        read: "<c:url value='/select/prod/process/WorkOrderResultHeader.do' />"
    });
    $.extend(items["api.2"], {
        update: "<c:url value='/update/prod/process/WorkFaultListH.do' />"
    });
    $.extend(items["api.2"], {
        destroy: "<c:url value='/delete/prod/process/WorkFaultListH.do' />"
    });

    items["btns.2"] = [];

    items["btns.ctr.2"] = {};
    $.extend(items["btns.ctr.2"], {
        "WorkResultSelectList": {
            itemclick: "onResultClick"
        }
    });

    // 페이징
    items["dock.paging.2"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.2"],
    };

    // 버튼 컨트롤
    items["dock.btn.2"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.2"],
        items: items["btns.2"],
    };

    items["docked.2"] = [];
}

var rowIdx_2 = 0, colIdx_2 = 0;
function onResultClick(dataview, record, item, index, e, eOpts) {
    rowIdx_2 = e.position.rowIdx;
    colIdx_2 = e.position.colIdx;
    var columnIndex = e.position.column.dataIndex;

    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var itemcode = $("#itemcode").val();
    var routingid = $("#routingcode").val();
    var workcentercode = record.data.WORKCENTERCODE;

    if (columnIndex.indexOf("WORKDIVNAME") >= 0) {
        // 주야구분
    } else if (columnIndex.indexOf("WORKERNAME") >= 0) {
        // 작업자
        var sparams7 = {
            ORGID: orgid,
            COMPANYID: companyid,
            WORKCENTERCODE: workcentercode,
            WORKDEPT: "${searchVO.gubun}",
        };
        extGridSearch(sparams7, gridnms["store.22"]);
    } else if (columnIndex == "QTY") {
        // 양품수량
        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
            ROUTINGID: routingid,
        };
        extGridSearch(sparams, gridnms["store.24"]);
        if (colIdx_2 == 7) {
            popup_flag = "NUM";
            var remarks = "";
            fn_global_keypad_popup(columnIndex, record.get(columnIndex), popup_flag, remarks, rowIdx_3, colIdx_3, gridnms["store.2"], gridnms["views.result"]);
            global_keypad_win.setPosition(320, 119, false);
        }

    } else if (columnIndex.indexOf("WORKCENTERNAME") >= 0) {
        // 설비번호
        var sparams10 = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
            ROUTINGID: routingid,
        };
        extGridSearch(sparams10, gridnms["store.23"]);
    }
};

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
            WORKCENTERCODE: workcentercode,
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
        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
            ROUTINGID: routingid,
        };
        extGridSearch(sparams, gridnms["store.33"]);

        popup_flag = "NUM";
        var remarks = "";
        fn_global_keypad_popup(columnIndex, record.get(columnIndex), popup_flag, remarks, rowIdx_3, colIdx_3, gridnms["store.3"], gridnms["views.fault"]);
        global_keypad_win.setPosition(320, 119, false);
        selected_columnIndex = columnIndex;
    }
};

function setValues_operate() {
    gridnms["models.operate"] = [];
    gridnms["stores.operate"] = [];
    gridnms["views.operate"] = [];
    gridnms["controllers.operate"] = [];

    gridnms["grid.4"] = "operatetList";
    gridnms["grid.40"] = "operatetGubunLov";
    gridnms["grid.41"] = "operatetLov";
    gridnms["grid.42"] = "workcenterOperateLov";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.operate"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.operate"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
    gridnms["model.40"] = gridnms["app"] + ".model." + gridnms["grid.40"];
    gridnms["model.41"] = gridnms["app"] + ".model." + gridnms["grid.41"];
    gridnms["model.42"] = gridnms["app"] + ".model." + gridnms["grid.42"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
    gridnms["store.40"] = gridnms["app"] + ".store." + gridnms["grid.40"];
    gridnms["store.41"] = gridnms["app"] + ".store." + gridnms["grid.41"];
    gridnms["store.42"] = gridnms["app"] + ".store." + gridnms["grid.42"];

    gridnms["models.operate"].push(gridnms["model.4"]);
    gridnms["models.operate"].push(gridnms["model.40"]);
    gridnms["models.operate"].push(gridnms["model.41"]);
    gridnms["models.operate"].push(gridnms["model.42"]);

    gridnms["stores.operate"].push(gridnms["store.4"]);
    gridnms["stores.operate"].push(gridnms["store.40"]);
    gridnms["stores.operate"].push(gridnms["store.41"]);
    gridnms["stores.operate"].push(gridnms["store.42"]);

    fields["model.4"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
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
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'EMPLOYEESEQ',
        }, {
            type: 'string',
            name: 'OPERATETYPE',
        }, {
            type: 'string',
            name: 'OPERATETYPENAME',
        }, {
            type: 'string',
            name: 'OPERATETYPEDETAIL',
        }, {
            type: 'string',
            name: 'OPERATETYPEDETAILNAME',
        }, {
            type: 'date',
            name: 'STARTDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'string',
            name: 'OLDCHANGEEQUIP',
        }, {
            type: 'string',
            name: 'CHANGEEQUIP',
        }, {
            type: 'string',
            name: 'CHANGEEQUIPNAME',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["model.40"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.41"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.42"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.4"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 65,
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
            dataIndex: 'WORKCENTERNAME',
            text: '설비명',
            xtype: 'gridcolumn',
            width: 300,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.42"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.operate"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.operate"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                    width: 200,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '비가동시작<br/>적용',
            width: 100,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "시작시간",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var today = new Date();
                    var start = Ext.util.Format.date(today, 'Y-m-d H:i');
                    record.set("STARTDATE", start);

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'STARTDATE',
            text: '비가동시작',
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
                altFormats: 'Y-m-d H:i|YmdHi|Y m d H i|Ymd Hi|Y-m-d Hi|Y-m-dHi',
                height: 45,
                triggerCls: 'trigger-datefield-custom',
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d H:i');
            },
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '비가동종료<br/>적용',
            width: 100,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "종료시간",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var today = new Date();
                    var end = Ext.util.Format.date(today, 'Y-m-d H:i');
                    record.set("ENDDATE", end);

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'ENDDATE',
            text: '비가동종료',
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
                altFormats: 'Y-m-d H:i|YmdHi|Y m d H i|Ymd Hi|Y-m-d Hi|Y-m-dHi',
                height: 45,
                triggerCls: 'trigger-datefield-custom',
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d H:i');
            },
        }, {
            dataIndex: 'OPERATETYPENAME',
            text: '비가동구분',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.40"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'local',
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.operate"]).selModel.getSelection()[0].id);

                        model.set("OPERATETYPE", record.data.VALUE);

                        var emptyValue = "";
                        var reason = model.data.OPERATETYPEDETAIL;
                        if (reason != "") {
                            model.set("OPERATETYPEDETAIL", emptyValue);
                            model.set("OPERATETYPEDETAILNAME", emptyValue);
                        }
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
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
        }, {
            dataIndex: 'OPERATETYPEDETAILNAME',
            text: '비가동유형',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.41"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'local',
                height: 45,
                triggerCls: 'trigger-combobox-custom', //콤보박스용
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.operate"]).selModel.getSelection()[0].id);

                        model.set("OPERATETYPEDETAIL", record.data.VALUE);

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
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
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
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'EMPLOYEESEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'FAULTTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHANGEEQUIP',
            xtype: 'hidden',
        }, {
            dataIndex: 'OLDCHANGEEQUIP',
            xtype: 'hidden',
        }, {
            dataIndex: 'OPERATETYPEDETAIL',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        create: "<c:url value='/insert/prod/process/WorkOrderOperateList.do' />"
    });
    $.extend(items["api.4"], {
        read: "<c:url value='/select/prod/process/WorkOrderOperateList.do' />"
    });
    $.extend(items["api.4"], {
        update: "<c:url value='/update/prod/process/WorkOrderOperateList.do' />"
    });
    $.extend(items["api.4"], {
        destroy: "<c:url value='/delete/prod/process/WorkOrderOperateList.do' />"
    });

    items["btns.4"] = [];

    items["btns.ctr.4"] = {};
    $.extend(items["btns.ctr.4"], {
        "WorkOperateSelectList": {
            itemclick: "onOperateClick"
        }
    });

    // 페이징
    items["dock.paging.4"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.4"],
    };

    // 버튼 컨트롤
    items["dock.btn.4"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.4"],
        items: items["btns.4"],
    };

    items["docked.4"] = [];
}

function onOperateClick(dataview, record, item, index, e, eOpts) {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var itemcode = $("#itemcode").val();
    var routingid = $("#routingcode").val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        ITEMCODE: itemcode,
        ROUTINGID: routingid,
    };
    extGridSearch(sparams, gridnms["store.42"]);

    var columnIndex = e.position.column.dataIndex;

    if (columnIndex.indexOf("OPERATETYPEDETAILNAME") >= 0) {
        // 현상
        var reasongubun = record.data.OPERATETYPE;
        if (reasongubun != "") {
            var sparams1 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: 'EQ',
                MIDDLECD: 'NONOPER_TYPE_DETAIL',
                ATTRIBUTE1: reasongubun,
            };
            extGridSearch(sparams1, gridnms["store.41"]);
        } else {
            Ext.getStore(gridnms["store.41"]).removeAll();
        }

    }
};

var gridarea, gridarea1, gridarea2, gridarea3;
function setExtGrid() {
    setExtGrid_list();
    setExtGrid_result(); // 생산실적등록
    setExtGrid_fault(); // 불량유형등록
    setExtGrid_operate(); // 비가동

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea1.updateLayout();
        gridarea2.updateLayout();
        gridarea3.updateLayout();
    });
}

function setExtGrid_list() {
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
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: '${searchVO.ORGID}',
                                COMPANYID: '${searchVO.COMPANYID}',
                                WORKDEPT: '${searchVO.gubun}'
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                if (rows.length > 0) {
                                    WorkSelectClick(null, rows[0], null, 0, null, null);
                                } else {
                                    var sparams = {
                                        WORKDEPT: '@',
                                    };
                                    extGridSearch(sparams, gridnms["store.1"]);

                                }
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
                height: 608,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'WorkSelect',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('WORKERNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 100) {
                                        column.width = 100;
                                    }
                                }
                            });
                        }
                    },
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
            gridarea = Ext.create(gridnms["views.list"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function setExtGrid_result() {

    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
    });

    Ext.define(gridnms["model.21"], {
        extend: Ext.data.Model,
        fields: fields["model.21"],
    });

    Ext.define(gridnms["model.22"], {
        extend: Ext.data.Model,
        fields: fields["model.22"],
    });

    Ext.define(gridnms["model.23"], {
        extend: Ext.data.Model,
        fields: fields["model.23"],
    });

    Ext.define(gridnms["model.24"], {
        extend: Ext.data.Model,
        fields: fields["model.24"],
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.2"],
                        model: gridnms["model.2"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize, // 20,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: '${searchVO.orgid}',
                                COMPANYID: '${searchVO.companyid}',
                                WORKORDERID: '${searchVO.workorderid}',
                                WORKORDERSEQ: '${searchVO.workorderseq}',
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.21"], { // (공정검사 불량유형 등록) 불량유형 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.21"],
                        model: gridnms["model.21"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'WORK_DIV',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.22"], { // 작업자 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.22"],
                        model: gridnms["model.22"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchWorkerEquipLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                WORKDEPT: "${searchVO.gubun}",
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.23"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.23"],
                        model: gridnms["model.23"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchEquipmentLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.24"], { // (공정검사 불량유형 등록) 불량유형 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.24"],
                        model: gridnms["model.24"],
                        autoLoad: true,
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

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
            WorkResultSelectList: '#WorkResultSelectList',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],

        onResultClick: onResultClick,
    });

    Ext.define(gridnms["panel.2"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.2"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.2"],
                id: gridnms["panel.2"],
                store: gridnms["store.2"],
                height: 195,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                defaults: fields["defaults"],
                viewConfig: {
                    itemId: 'WorkResultSelectList',
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var editDisableCols = [];
                                editDisableCols.push("WORKERNAME");

                                switch (groupid) {
                                case "ROLE_WORK":
                                    editDisableCols.push("STARTTIME");
                                    editDisableCols.push("ENDTIME");
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
                dockedItems: items["docked.2"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.result"],
        stores: gridnms["stores.result"],
        views: gridnms["views.result"],
        controllers: gridnms["controller.2"],

        launch: function () {
            gridarea1 = Ext.create(gridnms["views.result"], {
                renderTo: 'gridArea1'
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
                        autoLoad: true,
                        pageSize: gridVals.pageSize, // 20,
                        proxy: {
                            type: 'ajax',
                            api: items["api.3"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: '${searchVO.orgid}',
                                COMPANYID: '${searchVO.companyid}',
                                WORKORDERID: '${searchVO.workorderid}',
                                WORKORDERSEQ: '${searchVO.workorderseq}',
                            },
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
                        autoLoad: true,
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
                height: 195,
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

function setExtGrid_operate() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["model.40"], {
        extend: Ext.data.Model,
        fields: fields["model.40"],
    });

    Ext.define(gridnms["model.41"], {
        extend: Ext.data.Model,
        fields: fields["model.41"],
    });

    Ext.define(gridnms["model.42"], {
        extend: Ext.data.Model,
        fields: fields["model.42"],
    });

    Ext.define(gridnms["store.4"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.4"],
                        model: gridnms["model.4"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize, // 20,
                        proxy: {
                            type: 'ajax',
                            api: items["api.4"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                WORKPLANDATE: $('#searchPlanDate').val(),
                                WORKSTATUS: $('#searchStatus').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.40"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.40"],
                        model: gridnms["model.40"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'EQ',
                                MIDDLECD: 'NONOPER_TYPE'
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.41"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.41"],
                        model: gridnms["model.41"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'EQ',
                                MIDDLECD: 'NONOPER_TYPE_DETAIL'
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.42"], { // 설비 LOV
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.42"],
                        model: gridnms["model.42"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchEquipmentLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.4"], {
        extend: Ext.app.Controller,
        refs: {
            WorkOperateSelectList: '#WorkOperateSelectList',
        },
        stores: [gridnms["store.4"]],
        control: items["btns.ctr.4"],

        onOperateClick: onOperateClick,
    });

    Ext.define(gridnms["panel.4"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.4"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.4"],
                id: gridnms["panel.4"],
                store: gridnms["store.4"],
                height: 195,
                border: 2,
                scrollable: true,
                columns: fields["columns.4"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'WorkOperateSelectList',
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                    }
                ],
                dockedItems: items["docked.4"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.operate"],
        stores: gridnms["stores.operate"],
        views: gridnms["views.operate"],
        controllers: gridnms["controller.4"],

        launch: function () {
            gridarea3 = Ext.create(gridnms["views.operate"], {
                renderTo: 'gridArea3'
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

function fn_validation() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var workorderid = $('#workorderid').val();
    var workorderseq = $('#workorderseq').val();
    var seqno = $('#seqno').val();
    var result = true;
    var count = 0;

    if (orgid == "") {
        count++;
    }

    if (companyid == "") {
        count++;
    }

    if (workorderid == "") {
        count++;
    }

    if (count > 0) {
        extToastView("작업항목이 선택되지 않았습니다.<br/>다시 한번 확인해주십시요.");
        result = false;
    }

    return result;
}

function fn_search() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var workid = $('#workorderid').val();
    var workseq = $('#workorderseq').val();
    var workdept = $('#workdept').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    var sparams = {
        ORGID: '${searchVO.ORGID}',
        COMPANYID: '${searchVO.COMPANYID}',
        WORKDEPT: '${searchVO.gubun}'
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_ready() {
    extToastView("준비중입니다...");
    return;
}

function setLovList() {
    //
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}

function fn_tab(flag) {
    $("#tab1, #tab2, #tab4").removeClass("active");

    $('#tabclick').val(flag);

    switch (flag) {
    case "1":
        // 생산실적등록
        $("#tab1").addClass("active");

        $('#field_fault').hide();
        Ext.getCmp(gridnms["views.fault"]).hide();
        $('#field_operate').hide();
        Ext.getCmp(gridnms["views.operate"]).hide();
        $('#field_result').show();
        Ext.getCmp(gridnms["views.result"]).show();
        $('#btn_tab_add').show();
        $('#btn_tab_sav').show();
        $('#btn_tab_del').show(500);
        break;
    case "2":
        // 불량유형등록
        $("#tab2").addClass("active");

        $('#field_result').hide();
        Ext.getCmp(gridnms["views.result"]).hide();
        $('#field_operate').hide();
        Ext.getCmp(gridnms["views.operate"]).hide();
        $('#field_fault').show();
        Ext.getCmp(gridnms["views.fault"]).show();
        $('#btn_tab_add').show();
        $('#btn_tab_sav').show();
        $('#btn_tab_del').hide(500);
        break;
    case "4":
        // 비가동유형
        $("#tab4").addClass("active");

        $('#field_result').hide();
        Ext.getCmp(gridnms["views.result"]).hide();
        $('#field_fault').hide();
        Ext.getCmp(gridnms["views.fault"]).hide();
        $('#field_operate').show();
        Ext.getCmp(gridnms["views.operate"]).show();
        $('#btn_tab_add').show();
        $('#btn_tab_sav').show();
        $('#btn_tab_del').hide(500);
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
    var workcentercode = $("#workcentercode").val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        WORKORDERID: workorderid,
        WORKORDERSEQ: workorderseq,
        WORKCENTERCODE: workcentercode,
    };

    switch (flag) {
    case "1":
        // 생산실적등록
        extGridSearch(sparams, gridnms["store.2"]);

        var sparams6 = {
            ORGID: orgid,
            COMPANYID: companyid,
            WORKCENTERCODE: workcentercode,
            WORKDEPT: "${searchVO.gubun}",
        };
        extGridSearch(sparams6, gridnms["store.22"]);

        var sparams9 = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
            ROUTINGID: routingid,
        };
        extGridSearch(sparams9, gridnms["store.23"]);

        break;
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
    case "4":
        // 비가동유형
        extGridSearch(sparams, gridnms["store.4"]);

        // 설비명
        var sparams1 = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
            ROUTINGID: routingid,
        };
        extGridSearch(sparams1, gridnms["store.42"]);

        break;
    default:
        break;
    }
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_btn_add() {
    var flag = $('#tabclick').val();
    switch (flag) {
    case "1":
        // 생산실적등록

        var preworkqty = ($("#preworkqty").val() * 1); // 전공정 양품수량이 현공정 전체 체크할 것(추가하는거랑 양품수량에 체크박스 선택부분에 넣을 것)
        var precount = Ext.getStore(gridnms["store.2"]).count();
        var tempqty = 0;
        if (precount > 0) {
            for (var i = 0; i < precount; i++) {
                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(i));
                var preModel = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

                var hapqty = (preModel.data.HAPQTY * 1);
                tempqty += hapqty;
            }

            //     if (preworkqty <= tempqty) {
            //       extToastView("작지수량 또는 전 공정 수량을 초과할 수 없습니다.");
            //       return;
            //     }
        }

        var model = Ext.create(gridnms["model.2"]);
        var store = Ext.getStore(gridnms["store.2"]);
        var orgid = $("#orgid").val();
        var companyid = $("#companyid").val();
        var workorderseq = $("#workorderseq").val();
        var workorderid = $("#workorderid").val();
        var workdept = $("#workdept").val();
        var workcentercode = $("#workcentercode").val();
        var check = "";

        if (workorderseq == "" || workorderseq == undefined) {
            extToastView("작업지시 항목을 선택 후 추가 해주세요.");
            return;
        }

        var listcount = Ext.getStore(gridnms["store.2"]).count();
        for (var i = 0; i < listcount; i++) {
            Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(i));
            var dummy = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

            dummy.set("CHKSEQ", (dummy.data.CHKSEQ * 1) + 1);
        }

        model.set("SEQNO", 0);
        model.set("CHKSEQ", 1);
        model.set("RN", listcount + 1);
        model.set("ORGID", $("#orgid").val());
        model.set("COMPANYID", $("#companyid").val());
        model.set("WORKORDERID", $("#workorderid").val());
        model.set("WORKORDERSEQ", $("#workorderseq").val());
        model.set("EQUIPMENTCODE", $("#equipmentcode").val());
        model.set("EQUIPMENTNAME", $("#equipmentname").val());
        model.set("WORKCENTERCODE", $("#workcentercode").val());
        model.set("WORKCENTERNAME", $("#workcentername").val());
        model.set("WORKCENTERCODEIF", $("#workcentercodeif").val());
        model.set("ITEMCODE", $('#itemcode').val());

        store.insert(0, model);
        fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.result"], 0, 6);

        break;
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
    case "4":
        // 비가동유형
        var orgid = $('#orgid').val();
        var companyid = $('#companyid').val();
        var workorderid = $('#workorderid').val();
        var workorderseq = $('#workorderseq').val();
        var workcentercode = $("#workcentercode").val();
        var workcentername = $("#workcentername").val();

        if (workorderid == "") {
            extToastView("작업지시 항목이 선택되지 않았습니다.<br/>다시 한번 확인해주십시요.");
            return;
        }

        var model = Ext.create(gridnms["model.4"]);
        var store = Ext.getStore(gridnms["store.4"]);

        model.set("RN", Ext.getStore(gridnms["store.4"]).count() + 1);
        model.set("ORGID", orgid);
        model.set("COMPANYID", companyid);
        model.set("WORKORDERID", workorderid);
        model.set("WORKORDERSEQ", workorderseq);
        model.set("WORKCENTERCODE", workcentercode);
        model.set("WORKCENTERNAME", workcentername);
        model.set("GUBUN", "REGIST");

        store.insert(0, model);
        fn_grid_focus_move("UP", gridnms["store.4"], gridnms["views.operate"], 0, 3);

        break;
    default:
        break;
    }
}

function fn_btn_save() {
    var flag = $('#tabclick').val();
    var rowindex = rowIdx;

    switch (flag) {
    case "1":
        // 생산실적등록
        var count100 = Ext.getStore(gridnms["store.2"]).count();
        var header = [],
        count = 0;

        if (count100 > 0) {
            for (i = 0; i < count100; i++) {
                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.result"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.result"]).selModel.getSelection()[0];

                var starttime = model1.data.STARTTIME;
                var workdiv = model1.data.WORKDIV;
                var worker = model1.data.WORKER;
                var qty = model1.data.QTY;

                if (starttime == "" || starttime == undefined) {
                    header.push("시작시간");
                    count++;
                }

                if (workdiv == "" || workdiv == undefined) {
                    header.push("주야구분");
                    count++;
                }

                if (worker == "" || worker == undefined) {
                    header.push("작업자");
                    count++;
                }

                if (count > 0) {
                    extAlert("[생산실적등록 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                    return;
                }
            }
        }

        Ext.getStore(gridnms["store.2"]).sync({
            success: function (batch, options) {
                msg = "[생산실적등록] " + msgs.noti.save;

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
                //                 Ext.getStore(gridnms['store.2']).load();
                fn_tab_load();
            },
            failure: function (batch, options) {
                extToastView(batch.exceptions[0].error);
            },
            callback: function (batch, options) {},
        });

        break;
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

                //                 setTimeout(function () {
                //                     Ext.getStore(gridnms['store.3']).load();
                //                 }, 200);
                fn_tab_load();
            },
            failure: function (batch, options) {
                extToastView(batch.exceptions[0].error);
            },
            callback: function (batch, options) {},
        });

        break;
    case "4":
        // 비가동유형
        var count1 = Ext.getStore(gridnms["store.4"]).count();
        var header = [],
        count = 0;

        if (count1 > 0) {
            for (i = 0; i < count1; i++) {
                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.operate"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.operate"]).selModel.getSelection()[0];

                var workcentercode = model1.data.WORKCENTERCODE;
                var startdate = model1.data.STARTDATE;
                var enddate = model1.data.ENDDATE;
                var operatetypename = model1.data.OPERATETYPENAME;
                var operatetypedetailname = model1.data.OPERATETYPEDETAILNAME;

                if (workcentercode == "" || workcentercode == undefined) {
                    header.push("설비명");
                    count++;
                }

                if (startdate == "" || startdate == undefined) {
                    header.push("시작시간");
                    count++;
                }

                if (operatetypename == "" || operatetypename == undefined) {
                    header.push("비가동구분");
                    count++;
                }

                if (operatetypedetailname == "" || operatetypedetailname == undefined) {
                    header.push("비가동유형");
                    count++;
                }

                if (count > 0) {
                    extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                    return;
                }
            }
        } else {
            extAlert("[저장] 비가동유형 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
            return;
        }

        if (count > 0) {
            extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
            return;
        } else {
            Ext.getStore(gridnms["store.4"]).sync({
                success: function (batch, options) {
                    msg = "[비가동유형등록] " + msgs.noti.save;

                    //                     Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                    //                     Ext.getCmp(gridnms["views.list"]).doLayout();

                    extToastView(msg);

                    //                     Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                    //                         row: rowIdx,
                    //                         column: colIdx,
                    //                         animate: false
                    //                     });
                    Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                        Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx)
                        Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                    });

                    //                     setTimeout(function () {
                    //                         Ext.getStore(gridnms['store.4']).load();
                    //                     }, 200);
                    fn_tab_load();
                },
                failure: function (batch, options) {
                    extToastView(batch.exceptions[0].error);
                },
                callback: function (batch, options) {},
            });
        }

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
    var workorderid_old = $('#workorderid').val();
    var workorderid = restore.WORKORDERID;
    var workorderseq = restore.WORKORDERSEQ;
    var itemcode = restore.ITEMCODE;
    var routingcode = restore.ROUTINGCODE;
    var lotno = restore.LOTNO;
    var workstatus = restore.WORKSTATUS;
    var equipmentcode = restore.EQUIPMENTCODE;
    var equipmentname = restore.EQUIPMENTNAME;
    var workcentercode = restore.WORKCENTERCODE;
    var workcentername = restore.WORKCENTERNAME;
    var worker = restore.WORKER;
    var workername = restore.WORKER2NAME;
    var snp = restore.SNP;
    var capacityequip = restore.CAPACITYEQUIP;
    var wastage = restore.WASTAGE; // 소요량
    var workorderqty = restore.WORKORDERQTY; // 작지수량
    var importqty = restore.IMPORTQTY; // 양품수량
    var rank = restore.RK; // 마지막공정확인
    var unitpercnt = restore.UNITPERCNT; // 설비 수량구분
    var workcentercodeif = restore.WORKCENTERCODEIF; // 설비 수량구분
    var preworkqty = restore.PREWORKQTY; // 이전공정의 양품수량
    var cycleqty = restore.CYCLEQTY; // 검사주기수량
    clickindex2 = restore.RN;
    g_count = 0;

    $("#orgid").val(orgid);
    $("#companyid").val(companyid);
    $("#workorderid").val(workorderid);
    $("#workorderseq").val(workorderseq);
    $("#itemcode").val(itemcode);
    $("#routingcode").val(routingcode);
    $("#equipmentcode").val(equipmentcode);
    $("#equipmentname").val(equipmentname);
    $("#workcentercode").val(workcentercode);
    $("#workcentername").val(workcentername);
    $("#lotno").val(lotno);
    $("#workstatus").val(workstatus);
    $("#worker").val(worker);
    $("#workername").val(workername);
    $("#snp").val(snp);
    $("#capacityequip").val(capacityequip);
    $("#wastage").val(wastage);
    $("#workorderqty").val(workorderqty);
    $("#importqty").val(importqty);
    $("#rank").val(rank);
    $("#unitpercnt").val(unitpercnt);
    $("#workcentercodeif").val(workcentercodeif);
    $("#preworkqty").val(preworkqty);
    $("#cycleqty").val(cycleqty);

    fn_tab($('#tabclick').val());
}

function fn_btn_delete() {
    var flag = $('#tabclick').val();
    var rowindex = Ext.getStore(gridnms["store.1"]).indexOf(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0]);

    switch (flag) {
    case "1":
        // 생산실적등록
        var store = Ext.getStore(gridnms["store.2"]);
        var record = Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0];

        var num = record.data.RN;
        var fqty = record.data.PREQTY;
        if (num != 0 && fqty != 0) {
            extToastView('[생산실적등록 삭제]<br>양품수량이 있는 데이터는 삭제할 수 없습니다');
            return;
        }
        Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                store.remove(record);
                Ext.getStore(gridnms["store.2"]).sync({
                    success: function (batch, options) {
                        msg = "[생산실적등록] " + msgs.noti.del;

                        Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                        Ext.getCmp(gridnms["views.list"]).doLayout();

                        extToastView(msg);

                        Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                            row: rowIdx,
                            column: colIdx,
                            animate: false
                        });
                        //                         setTimeout(function () {
                        //                             Ext.getStore(gridnms['store.2']).load();
                        //                         }, 200);
                        fn_tab_load();
                    },
                    failure: function (batch, options) {
                        extToastView(batch.exceptions[0].error);
                    },
                    callback: function (batch, options) {},
                });
                setTimeout(function () {
                    Ext.getStore(gridnms["store.2"]).load();
                }, 200);
            }
        });

        break;
    case "2":
        // 불량유형등록
        break;
    case "4":
        // 비가동유형
        break;
    default:
        break;
    }
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div id="" style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)" >
                    <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="workdept" name="workdept" value="${searchVO.WORKDEPT}" />
                    <input type="hidden" id="workdeptname" name="workdeptname" value="${pageTitle}" />
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <input type="hidden" id="workorderid" name="workorderid" />
                    <input type="hidden" id="workorderseq" name="workorderseq" />
                    <input type="hidden" id="seqno" name="seqno" />
                    <input type="hidden" id="itemcode" name="itemcode" />
                    <input type="hidden" id="lotitemcode" name="lotitemcode" />
                    <input type="hidden" id="routingcode" name="routingcode" />
                    <input type="hidden" id="lotno" name="lotno" />
                    <input type="hidden" id="workstatus" name="workstatus" />
                    <input type="hidden" id="equipmentcode" name="equipmentcode" value="${EQUIPMENTCODE}"/>
                    <input type="hidden" id="equipmentname" name="equipmentname" value="${EQUIPMENTNAME}" />
                    <input type="hidden" id="workcentercode" name="workcentercode" />
                    <input type="hidden" id="workcentername" name="workcentername" />
                    <input type="hidden" id="worker" name="worker" value="${WORKER}" />
                    <input type="hidden" id="workername" name="workername" value="${WORKERNAME}" />
                    <input type="hidden" id="reporttype" name="reporttype" />
                    <input type="hidden" id="itemtype" name="itemtype" />
                    <input type="hidden" id="barcode" name="barcode" />
                    <input type="hidden" id="snp" name="snp" />
                    <input type="hidden" id="capacityequip" name="capacityequip" />
                    <input type="hidden" id="wastage" name="wastage" />
                    <input type="hidden" id="workorderqty" name="workorderqty" />
                    <input type="hidden" id="importqty" name="importqty" />
                    <input type="hidden" id="rank" name="rank" />
                    <input type="hidden" id="firstrouting" name="firstrouting" />
                    <input type="hidden" id="groupitem" name="groupitem" />
                    <input type="hidden" id="groupqty" name="groupqty" />
                    <input type="hidden" id="workcentercodeif" name="workcentercodeif" />
                    <input type="hidden" id="interfaceqty" name="interfaceqty" />
                    <input type="hidden" id="unitpercnt" name="unitpercnt" />
                    <input type="hidden" id="preworkqty" name="preworkqty" />
                    <input type="hidden" id="cycleqty" name="cycleqty" />
                    <input type="hidden" id="tabclick" name="tabclick" value="1"/>
										<c:choose>
												<c:when test="${searchVO.work == 'Y'}">
														<div style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!-- 		                            <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!-- 		                                    생산실적<br/>( TOUCH ) -->
<!-- 		                            </button> -->
																<button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
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
														<div style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
																<button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
																				나가기<br/>( LOGOUT )
																</button>
														</div>
												</c:when>
												<c:otherwise>
														<div style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
																<button type="button" class="btn_work_home blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">HOME</button>
																<button type="button" class="btn_work_prev blue3 h " onclick="fn_goPrevPage( );" style="width: 8%; height: 63px; float: left';">
																				이전화면<br/>( BACK )
																</button>
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
		                            <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
		                                    생산실적<br/>( TOUCH )
		                            </button>
																<button type="button" class="white_selected h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
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
                    
                    <div id="gridArea" style="width: 100%; margin-top: 0px; margin-bottom: 15px; float: left;"></div>
                    <table style="width: 100%; margin-top: 15px;">
                            <tr style="height: 28px;">
                                    <td style="width: 100%;">
		                                    <div class="tab line" style="width: calc(100% - 65%); height: 39px; padding-bottom: 0px; float: left;">
		                                            <ul>
		                                                    <li id="tab1"><a href="#" onclick="javascript:fn_tab('1');" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">생산실적등록</span></a></li>
		                                                    <li id="tab2"><a href="#" onclick="javascript:fn_tab('2');" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">불량유형등록</span></a></li>
		                                                    <li id="tab4"><a href="#" onclick="javascript:fn_tab('4');" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">비가동유형등록</span></a></li>
		                                            </ul>
		                                    </div>
		                                    <div style="width: calc(100% - 35%); height: 39px; border-bottom: 1px solid #0074bd; float: right;">
		                                            <button type="button" id="btn_tab_add" class="blue2 r shadow" onclick="fn_btn_add();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">추가 (Add)</button>
                                                <button type="button" id="btn_tab_sav" class="blue2 r shadow" onclick="fn_btn_save();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">저장 (Save)</button>
                                                <button type="button" id="btn_tab_del" class="blue2 r shadow" onclick="fn_btn_delete();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">삭제 (Del)</button>
		                                    </div>
                                    </td>
                            </tr>
                    </table>

										<div id="field_result">
														<div id="gridArea1" style="width: 100%; margin-top: 0px; margin-bottom: 10px; margin-left: 0px; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
										</div>

										<div id="field_fault" style="display: none">
														<div id="gridArea2" style="width: 100%; margin-top: 0px; margin-bottom: 10px; margin-left: 0px; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
										</div>

										<div id="field_operate" style="display: none">
														<div id="gridArea3" style="width: 100%; margin-top: 0px; margin-bottom: 10px; margin-left: 0px; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
										</div>
								</form>
            </div>
        </div>
        <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>