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
<title>${EQUIPMENTNAME} - ${pageTitle}</title>

<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">
<style>
.x-column-header-inner {
  font-size: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  padding-left: 0px;
  padding-right: 0px;
}

.x-column-header-text {
  padding-top: 5px;
  padding-bottom: 5px;
}

.x-grid-cell-inner {
  position: relative;
  text-overflow: ellipsis;
  padding-top: 15px;
  padding-left: 10px;
  height: 60px;
  font-size: 22px !important;
  font-weight: bold;
}

.specialcheckname  .x-column-header-inner {
  color: red;
}

.ERPQTY  .x-column-header-text {
  margin-right: 0px;
}

.FML .x-grid-cell-inner {
  padding-left: 0px;
  padding-right: 0px;
}

.x-btn {
  margin-top: 10px;
  height: 40px;
}

.x-btn-inner {
  font-size: 16px !important;
}

#gridArea .x-form-field {
  font-size: 21px;
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

.gray:HOVER {
	background-color: #d8d8d8;
}

.gray {
	background-color: #e1e1e1;
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
	font-size: 22px;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	border-bottom: 1px solid white;
}

.ResultTable td {
	font-size: 22px;
	color: black;
	text-align: center;
}

.nmpd-display {
	border: 2px solid white !important;
	font-size: 25px !important;
	font-weight: bold !important;
	background-color: #B2CCFF !important;
	color: black !important;
	width: 384px !important;
	height: 60px !important;
	border-radius: .3125em;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var btnCnt = true;
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setReadOnly();

  setLovList();
});

function setInitial() {
  gridnms["app"] = "process";

  setTimeout(function () {
    fn_tab("1");
  }, 100);
}

function setValues() {
  setValues_list();
}

var comboboxEmpty1 = '<div style="height: auto; overflow: auto; display:block;">'
   + '<ul>'
   + '<li style="height: 30px; font-size: 16px; font-weight: bold; padding-top: 10px; padding-left: 5px;">'
   + '데이터가 없습니다.'
   + '</li><li style="height: 30px; font-size: 16px; font-weight: bold; padding-top: 5px; padding-left: 5px;">'
   + '관리자에게 문의하십시오.'
   + '</li>' + '</ul>' + '</div>';
var comboboxOption1 = '<div>'
   + '<table>'
   + '<colgroup>'
   + '<col width="450px;">'
   + '<col width="200px;">'
   + '</colgroup>'
   + '<tr>'
   + '<td style="height: 40px; font-size: 25px; font-weight: bold;">{ITEMNAME}</td>'
   + '<td style="height: 40px; font-size: 25px; font-weight: bold;">{ROUTINGNAME}</td>'
   + '</tr>'
   + '</table>' + '</div>';
var comboboxOption2 = '<div>'
   + '<table>'
   + '<colgroup>'
   + '<col width="350px;">'
   + '<col width="400px;">'
   + '<col width="150px;">'
   + '<colgroup>'
   + '<tr>'
   + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{ITEMNAME}</td>'
   + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{ITEMSTANDARD}</td>'
   + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{TOOLLIFE}</td>'
   + '</tr>' + '</table>' + '</div>';
function setValues_list() {

  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "ToolChangeRegist";
  gridnms["grid.2"] = "ToolNameLov";
  gridnms["grid.3"] = "WorkerLov";
  gridnms["grid.4"] = "ChangeReasonLov";
  gridnms["grid.5"] = "Check1Lov";
  gridnms["grid.6"] = "Check2Lov";
  gridnms["grid.7"] = "Check3Lov";
  gridnms["grid.8"] = "Check4Lov";
  gridnms["grid.9"] = "ManageCheckLov";
  gridnms["grid.10"] = "RoutingNameLov";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.list"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.list"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];
  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
  gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];
  gridnms["model.9"] = gridnms["app"] + ".model." + gridnms["grid.9"];
  gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];
  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
  gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];
  gridnms["store.9"] = gridnms["app"] + ".store." + gridnms["grid.9"];
  gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];

  gridnms["models.list"].push(gridnms["model.1"]);
  gridnms["models.list"].push(gridnms["model.2"]);
  gridnms["models.list"].push(gridnms["model.3"]);
  gridnms["models.list"].push(gridnms["model.4"]);
  gridnms["models.list"].push(gridnms["model.5"]);
  gridnms["models.list"].push(gridnms["model.6"]);
  gridnms["models.list"].push(gridnms["model.7"]);
  gridnms["models.list"].push(gridnms["model.8"]);
  gridnms["models.list"].push(gridnms["model.9"]);
  gridnms["models.list"].push(gridnms["model.10"]);

  gridnms["stores.list"].push(gridnms["store.1"]);
  gridnms["stores.list"].push(gridnms["store.2"]);
  gridnms["stores.list"].push(gridnms["store.3"]);
  gridnms["stores.list"].push(gridnms["store.4"]);
  gridnms["stores.list"].push(gridnms["store.5"]);
  gridnms["stores.list"].push(gridnms["store.6"]);
  gridnms["stores.list"].push(gridnms["store.7"]);
  gridnms["stores.list"].push(gridnms["store.8"]);
  gridnms["stores.list"].push(gridnms["store.9"]);
  gridnms["stores.list"].push(gridnms["store.10"]);

  fields["model.1"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'number',
      name: 'CHANGESEQ',
    }, {
      type: 'number',
      name: 'CHECKSEQ',
    }, {
      type: 'string',
      name: 'EQUIPMENTCODE',
    }, {
      type: 'string',
      name: 'EQUIPMENTNAME',
    }, {
      type: 'number',
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGNO',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'ITEMNAME',
    }, {
      type: 'string',
      name: 'ITEMSTANDARD',
    }, {
      type: 'date',
      name: 'CHANGEDATE',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'number',
      name: 'TOOLLIFE',
    }, {
      type: 'number',
      name: 'PRODQTY',
    }, {
      type: 'string',
      name: 'TOOLLIFECHECK',
    }, {
      type: 'string',
      name: 'EMPLOYEENUMBER',
    }, {
      type: 'string',
      name: 'KRNAME',
    }, {
      type: 'string',
      name: 'CHANGETYPE',
    }, {
      type: 'string',
      name: 'CHANGETYPENAME',
    }, {
      type: 'number',
      name: 'BACKQTY',
    }, {
      type: 'number',
      name: 'NCRQTY',
    }, {
      type: 'string',
      name: 'CHECKNAME1',
    }, {
      type: 'string',
      name: 'CHECKSTANDARD1',
    }, {
      type: 'string',
      name: 'PRECHECK1',
    }, {
      type: 'string',
      name: 'POSTCHECK1',
    }, {
      type: 'string',
      name: 'CHECKNAME2',
    }, {
      type: 'string',
      name: 'CHECKSTANDARD2',
    }, {
      type: 'string',
      name: 'PRECHECK2',
    }, {
      type: 'string',
      name: 'POSTCHECK2',
    }, {
      type: 'string',
      name: 'CHECKNAME3',
    }, {
      type: 'string',
      name: 'CHECKSTANDARD3',
    }, {
      type: 'string',
      name: 'PRECHECK3',
    }, {
      type: 'string',
      name: 'POSTCHECK3',
    }, {
      type: 'string',
      name: 'CHECKNAME4',
    }, {
      type: 'string',
      name: 'CHECKSTANDARD4',
    }, {
      type: 'string',
      name: 'PRECHECK4',
    }, {
      type: 'string',
      name: 'POSTCHECK4',
    }, {
      type: 'string',
      name: 'MANAGECHECK',
    }, {
      type: 'string',
      name: 'MANAGECHECKNAME',
    }, ];

  fields["model.2"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.3"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.4"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.5"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.6"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.7"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.8"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.9"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.10"] = [{
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'ITEMNAME',
    }, {
      type: 'string',
      name: 'ORDERNAME',
    }, {
      type: 'number',
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGNO',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'WORKCENTERCODE',
    }, {
      type: 'string',
      name: 'WORKCENTERNAME',
    }, {
      type: 'string',
      name: 'EMPLOYEENUMBER',
    }, {
      type: 'string',
      name: 'KRNAME',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순<br/><br/>번',
      xtype: 'gridcolumn',
      width: 50,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'CHANGEDATE',
      text: '일자',
      xtype: 'datecolumn',
      width: 200,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      format: 'Y-m-d H:i',
      tdCls: 'changerow',
      editor: {
        xtype: 'datefield',
        enforceMaxLength: true,
        maxLength: 16,
        allowBlank: true,
        editable: true,
        format: 'Y-m-d H:i',
        altFormats: 'Y-m-d H:i|YmdHi|Y m d H i|Ymd Hi|Y-m-d Hi|Y-m-dHi',
        height: 60,
        triggerCls: 'trigger-datefield-custom',
        listeners: {
          select: function (value, record) {
            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
            var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

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
        if (record.data.CHANGESEQ != "") {
          meta.style = "background-color:rgb(234, 234, 234); ";
        } else {
          meta.style = "background-color:rgb(253, 218, 255); ";
        }

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return Ext.util.Format.date(value, 'Y-m-d H:i');
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return Ext.util.Format.date(value, 'Y-m-d H:i');
        }
      },
    }, {
      dataIndex: 'ROUTINGITEMNAME',
      text: '제품명',
      xtype: 'gridcolumn',
      width: 450,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "left",
      tdCls: 'changerow',
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234); ";

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
        return value;
      },
    }, {
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      tdCls: 'changerow',
      editor: {
        xtype: 'combobox',
        store: gridnms["store.10"],
        valueField: "ROUTINGNAME",
        displayField: "ROUTINGNAME",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            model.set("ROUTINGITEMCODE", record.data.ITEMCODE);
            model.set("ROUTINGITEMNAME", record.data.ITEMNAME);
            model.set("ROUTINGID", record.data.ROUTINGID);
            model.set("ROUTINGNO", record.data.ROUTINGNO);
            model.set("EQUIPMENTCODE", record.data.EQUIPMENTCODE);
            model.set("EQUIPMENTNAME", record.data.EQUIPMENTNAME);
            model.set("WORKCENTERCODE", record.data.WORKCENTERCODE);
            model.set("WORKCENTERNAME", record.data.WORKCENTERNAME);
            model.set("EMPLOYEENUMBER", record.data.EMPLOYEENUMBER);
            model.set("KRNAME", record.data.KRNAME);

            var item = record.data.ROUTINGNAME;
            if (item == "") {
              model.set("ROUTINGITEMCODE", "");
              model.set("ROUTINGITEMNAME", "");
              model.set("ROUTINGID", "");
              model.set("ROUTINGNO", "");
              model.set("EQUIPMENTCODE", "");
              model.set("EQUIPMENTNAME", "");
              model.set("WORKCENTERCODE", "");
              model.set("WORKCENTERNAME", "");
              model.set("EMPLOYEENUMBER", "");
              model.set("KRNAME", "");
            }

            model.set("ITEMCODE", "");
            model.set("ITEMNAME", "");

            model.set("CHECKSEQ", "");
            model.set("ITEMSTANDARD", "");
            model.set("PRODQTY", "");
            model.set("TOOLLIFE", "");
            model.set("TOOLLIFECHECK", "");

//             model.set("CHECKCODE1", "");
//             model.set("CHECKNAME1", "");
//             model.set("CHECKSTANDARD1", "");
//             model.set("CHECKCODE2", "");
//             model.set("CHECKNAME2", "");
//             model.set("CHECKSTANDARD2", "");
//             model.set("CHECKCODE3", "");
//             model.set("CHECKNAME3", "");
//             model.set("CHECKSTANDARD3", "");
//             model.set("CHECKCODE4", "");
//             model.set("CHECKNAME4", "");
//             model.set("CHECKSTANDARD4", "");

//             var checkstandard1 = "";
//             var checkstandard2 = "";
//             var checkstandard3 = "";
//             var checkstandard4 = "";
//             var checkname1 = "";
//             var checkname2 = "";
//             var checkname3 = "";
//             var checkname4 = "";

//             // 클릭시 검사명에 따라 LOV 값 표시 변경
//             fn_lov_chk_change(checkname1, gridnms["store.5"]);
//             fn_lov_chk_change(checkname2, gridnms["store.6"]);
//             fn_lov_chk_change(checkname3, gridnms["store.7"]);
//             fn_lov_chk_change(checkname4, gridnms["store.8"]);

//             // 클릭 시 검사명, 검사내용 등을 따로 표기
//             $('#CheckName1 span').text(checkname1);
//             $('#CheckName2 span').text(checkname2);
//             $('#CheckName3 span').text(checkname3);
//             $('#CheckName4 span').text(checkname4);

//             $('#CheckStandard1 span').text(checkstandard1);
//             $('#CheckStandard2 span').text(checkstandard2);
//             $('#CheckStandard3 span').text(checkstandard3);
//             $('#CheckStandard4 span').text(checkstandard4);
           },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("ROUTINGITEMCODE", "");
                model.set("ROUTINGITEMNAME", "");
                model.set("ROUTINGID", "");
                model.set("ROUTINGNO", "");
                model.set("EQUIPMENTCODE", "");
                model.set("EQUIPMENTNAME", "");
                model.set("WORKCENTERCODE", "");
                model.set("WORKCENTERNAME", "");
                model.set("EMPLOYEENUMBER", "");
                model.set("KRNAME", "");

                model.set("ITEMCODE", "");
                model.set("ITEMNAME", "");

                model.set("CHECKSEQ", "");
                model.set("ITEMSTANDARD", "");
                model.set("PRODQTY", "");
                model.set("TOOLLIFE", "");
                model.set("TOOLLIFECHECK", "");

//                 model.set("CHECKCODE1", "");
//                 model.set("CHECKNAME1", "");
//                 model.set("CHECKSTANDARD1", "");
//                 model.set("CHECKCODE2", "");
//                 model.set("CHECKNAME2", "");
//                 model.set("CHECKSTANDARD2", "");
//                 model.set("CHECKCODE3", "");
//                 model.set("CHECKNAME3", "");
//                 model.set("CHECKSTANDARD3", "");
//                 model.set("CHECKCODE4", "");
//                 model.set("CHECKNAME4", "");
//                 model.set("CHECKSTANDARD4", "");

//                 var checkstandard1 = "";
//                 var checkstandard2 = "";
//                 var checkstandard3 = "";
//                 var checkstandard4 = "";
//                 var checkname1 = "";
//                 var checkname2 = "";
//                 var checkname3 = "";
//                 var checkname4 = "";

//                 // 클릭시 검사명에 따라 LOV 값 표시 변경
//                 fn_lov_chk_change(checkname1, gridnms["store.5"]);
//                 fn_lov_chk_change(checkname2, gridnms["store.6"]);
//                 fn_lov_chk_change(checkname3, gridnms["store.7"]);
//                 fn_lov_chk_change(checkname4, gridnms["store.8"]);

//                 // 클릭 시 검사명, 검사내용 등을 따로 표기
//                 $('#CheckName1 span').text(checkname1);
//                 $('#CheckName2 span').text(checkname2);
//                 $('#CheckName3 span').text(checkname3);
//                 $('#CheckName4 span').text(checkname4);

//                 $('#CheckStandard1 span').text(checkstandard1);
//                 $('#CheckStandard2 span').text(checkstandard2);
//                 $('#CheckStandard3 span').text(checkstandard3);
//                 $('#CheckStandard4 span').text(checkstandard4);
              }
            }
          },
        },
        //         listConfig: {
        //           loadingText: '검색 중...',
        //           emptyText: comboboxEmpty1,
        //           width: 650,
        //           getInnerTpl: function () {
        //             return comboboxOption1;
        //           }
        //         },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty1,
          width: 900,
          getInnerTpl: function () {
            return '<div>'
             + '<table >'
             + '<colgroup>'
             + '<col width="220px">'
             + '<col width="350px">'
             + '<col width="200px">'
             + '<col width="200px">'
             + '<col width="180px">'
             + '</colgroup>'
             + '<tr>'
             + '<td style="height: 50px; font-size: 29px; font-weight: bold;">{ORDERNAME}</td>'
             + '<td style="height: 50px; font-size: 29px; font-weight: bold;">{ITEMNAME}</td>'
             + '<td style="height: 50px; font-size: 29px; font-weight: bold;">{ROUTINGNAME}</td>'
             + '<td style="height: 50px; font-size: 29px; font-weight: bold;">{WORKCENTERNAME}</td>'
             + '<td style="height: 50px; font-size: 29px; font-weight: bold;">{KRNAME}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
        if (record.data.CHANGESEQ != "") {
          meta.style = "background-color:rgb(234, 234, 234); ";
        } else {
          meta.style = "background-color:rgb(253, 218, 255); ";
        }

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
      },
    }, {
      dataIndex: 'WORKCENTERNAME',
      text: '설비명',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      tdCls: 'changerow',
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234); ";

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
        return value;
      },
    }, {
      dataIndex: 'ITEMNAME',
      text: '공구명',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 250,
      align: "center",
      tdCls: 'changerow',
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "ITEMNAME",
        displayField: "ITEMNAME",
        matchFieldWidth: false,
        editable: false,
        allowBlank: true,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
            var checkseq = record.data.CHECKSEQ;
            var code = record.data.ITEMCODE;
            var itemstandard = record.data.ITEMSTANDARD;
            var toollife = record.data.TOOLLIFE;

            var checkcode1 = record.data.CHECKCODE1;
            var checkname1 = record.data.CHECKNAME1;
            var checkstandard1 = record.data.CHECKSTANDARD1;
            var checkcode2 = record.data.CHECKCODE2;
            var checkname2 = record.data.CHECKNAME2;
            var checkstandard2 = record.data.CHECKSTANDARD2;
            var checkcode3 = record.data.CHECKCODE3;
            var checkname3 = record.data.CHECKNAME3;
            var checkstandard3 = record.data.CHECKSTANDARD3;
            var checkcode4 = record.data.CHECKCODE4;
            var checkname4 = record.data.CHECKNAME4;
            var checkstandard4 = record.data.CHECKSTANDARD4;

            model.set("CHECKSEQ", checkseq);
            model.set("ITEMCODE", code);
            model.set("ITEMSTANDARD", itemstandard);
            //             model.set("PRODQTY", toollife);
            model.set("PRODQTY", 0);
            model.set("TOOLLIFE", toollife);
            model.set("TOOLLIFECHECK", "N");

//             model.set("CHECKCODE1", checkcode1);
//             model.set("CHECKNAME1", checkname1);
//             model.set("CHECKSTANDARD1", checkstandard1);
//             model.set("CHECKCODE2", checkcode2);
//             model.set("CHECKNAME2", checkname2);
//             model.set("CHECKSTANDARD2", checkstandard2);
//             model.set("CHECKCODE3", checkcode3);
//             model.set("CHECKNAME3", checkname3);
//             model.set("CHECKSTANDARD3", checkstandard3);
//             model.set("CHECKCODE4", checkcode4);
//             model.set("CHECKNAME4", checkname4);
//             model.set("CHECKSTANDARD4", checkstandard4);

//             // 클릭시 검사명에 따라 LOV 값 표시 변경
//             fn_lov_chk_change(checkname1, gridnms["store.5"]);
//             fn_lov_chk_change(checkname2, gridnms["store.6"]);
//             fn_lov_chk_change(checkname3, gridnms["store.7"]);
//             fn_lov_chk_change(checkname4, gridnms["store.8"]);

//             // 클릭 시 검사명, 검사내용 등을 따로 표기
//             $('#CheckName1 span').text(checkname1);
//             $('#CheckName2 span').text(checkname2);
//             $('#CheckName3 span').text(checkname3);
//             $('#CheckName4 span').text(checkname4);

//             $('#CheckStandard1 span').text(checkstandard1);
//             $('#CheckStandard2 span').text(checkstandard2);
//             $('#CheckStandard3 span').text(checkstandard3);
//             $('#CheckStandard4 span').text(checkstandard4);
          },
          change: function (field, nv, ov, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("CHECKSEQ", "");
                model.set("ITEMCODE", "");
                model.set("ITEMSTANDARD", "");
                model.set("PRODQTY", "");

                model.set("CHECKCODE1", "");
                model.set("CHECKNAME1", "");
                model.set("CHECKSTANDARD1", "");
                model.set("CHECKCODE2", "");
                model.set("CHECKNAME2", "");
                model.set("CHECKSTANDARD2", "");
                model.set("CHECKCODE3", "");
                model.set("CHECKNAME3", "");
                model.set("CHECKSTANDARD3", "");
                model.set("CHECKCODE4", "");
                model.set("CHECKNAME4", "");
                model.set("CHECKSTANDARD4", "");
                model.set("TOOLLIFE", "");
                model.set("TOOLLIFECHECK", "");

//                 var checkstandard1 = "";
//                 var checkstandard2 = "";
//                 var checkstandard3 = "";
//                 var checkstandard4 = "";
//                 var checkname1 = "";
//                 var checkname2 = "";
//                 var checkname3 = "";
//                 var checkname4 = "";

//                 // 클릭시 검사명에 따라 LOV 값 표시 변경
//                 fn_lov_chk_change(checkname1, gridnms["store.5"]);
//                 fn_lov_chk_change(checkname2, gridnms["store.6"]);
//                 fn_lov_chk_change(checkname3, gridnms["store.7"]);
//                 fn_lov_chk_change(checkname4, gridnms["store.8"]);

//                 // 클릭 시 검사명, 검사내용 등을 따로 표기
//                 $('#CheckName1 span').text(checkname1);
//                 $('#CheckName2 span').text(checkname2);
//                 $('#CheckName3 span').text(checkname3);
//                 $('#CheckName4 span').text(checkname4);

//                 $('#CheckStandard1 span').text(checkstandard1);
//                 $('#CheckStandard2 span').text(checkstandard2);
//                 $('#CheckStandard3 span').text(checkstandard3);
//                 $('#CheckStandard4 span').text(checkstandard4);
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty1,
          width: 900,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        if (record.data.CHANGESEQ != "") {
          meta.style = "background-color:rgb(234, 234, 234); ";
        } else {
          meta.style = "background-color:rgb(253, 218, 255); ";
        }

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
      },
    }, {
      dataIndex: 'ITEMSTANDARD',
      text: '사양',
      xtype: 'gridcolumn',
      width: 450,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      tdCls: 'changerow',
      renderer: function (value, meta, record) {
        meta.style += " background-color:rgb(234, 234, 234); ";
        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
      },
    }, {
      dataIndex: 'KRNAME',
      text: '작업자',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 220,
      align: "center",
      tdCls: 'changerow',
      editor: {
        xtype: 'combobox',
        store: gridnms["store.3"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        allowBlank: true,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
            var code = record.data.VALUE;

            model.set("EMPLOYEENUMBER", code);
          },
          change: function (value, nv, ov, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            if (nv != ov) {
              if (!isNaN(value.getValue())) {

                model.set("EMPLOYEENUMBER", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 500,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
             + '</tr>' + '</table>' + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255); ";

        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return value;
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return value;
        }
      },
    }, {
      dataIndex: 'TOOLLIFE',
      text: 'TOOL LIFE<br/><br/>(EA)',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      tdCls: 'changerow',
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234); ";
        var toolcheck = record.data.TOOLLIFECHECK;
        if (toolcheck == "Y") {
          if (interval1 == null) {
            setcolor('changerow');
          }
          return Ext.util.Format.number(value, '0,000');
        } else {
          meta.style += " color: rgb(102, 102, 102);";
          return Ext.util.Format.number(value, '0,000');
        }
      },
    }, {
      dataIndex: 'PRODQTY',
      text: '작업<br/><br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: true,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      editor: {
        xtype: "textfield",
        minValue: 1,
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '20',
        maskRe: /[0-9]/,
        selectOnFocus: true,
        height: 60,
        listeners: {
          change: function (field, newValue, oldValue, eOpts) {
            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
            var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
            var qty = newValue;
            var toollife = store.data.TOOLLIFE;

            if (toollife < qty) {
              store.set("TOOLLIFECHECK", "Y");
            } else {
              store.set("TOOLLIFECHECK", "N");
            }

          },
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255); ";
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'CHANGETYPENAME',
      text: '교환사유',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 170,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.4"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        allowBlank: true,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
            var code = record.data.VALUE;

            model.set("CHANGETYPE", code);
          },
          change: function (value, nv, ov, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            if (nv != ov) {
              if (!isNaN(value.getValue())) {

                model.set("CHANGETYPE", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 170,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
             + '</tr>' + '</table>' + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255)";
        return value;
      },
    },{
// 	     dataIndex: 'POSTCHECK1',
	     dataIndex: 'MANAGECHECKNAME',
	     text: '확인결과',
	     xtype: 'gridcolumn',
	     hidden: false,
	     sortable: false,
	     resizable: false,
	     menuDisabled: true,
	     width: 170,
	     align: "center",
	     editor: {
	       xtype: 'combobox',
	       store: gridnms["store.5"],
	       valueField: "LABEL",
	       displayField: "LABEL",
	       matchFieldWidth: false,
	       editable: true,
	       allowBlank: true,
	       height: 60,
	       triggerCls: 'trigger-combobox-custom',
	       listeners: {
	         select: function (value, record, eOpts) {
	           var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
	           var code = record.data.VALUE;

	            model.set("MANAGECHECK", code);
	         },
	         change: function (value, nv, ov, eOpts) {
	           var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
	
	           if (nv != ov) {
	             if (!isNaN(value.getValue())) {

	                 model.set("MANAGECHECK", code);
	             }
	           }
	         },
	       },
	       listConfig: {
	         loadingText: '검색 중...',
	         emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
	         width: 300,
	         getInnerTpl: function () {
	           return '<div>'
	            + '<table>'
	            + '<tr>'
	            + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
	            + '</tr>' + '</table>'
	            + '</div>';
	         }
	       },
	     },
	   },
    
//     {
//       dataIndex: 'BACKQTY',
//       text: '역추적현황',
//       xtype: 'gridcolumn',
//       width: 150,
//       hidden: false,
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       style: 'text-align:center',
//       align: "right",
//       cls: 'ERPQTY',
//       format: "0,000",
//       editor: {
//         xtype: "textfield",
//         minValue: 1,
//         format: "0,000",
//         enforceMaxLength: true,
//         allowBlank: true,
//         maxLength: '20',
//         maskRe: /[0-9]/,
//         selectOnFocus: true,
//         height: 60,
//       },
//       renderer: Ext.util.Format.numberRenderer('0,000'),
//     }, {
//       dataIndex: 'NCRQTY',
//       text: '부적합품<br/><br/>처리현황',
//       xtype: 'gridcolumn',
//       width: 150,
//       hidden: false,
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       style: 'text-align:center',
//       align: "right",
//       cls: 'ERPQTY',
//       format: "0,000",
//       editor: {
//         xtype: "textfield",
//         minValue: 1,
//         format: "0,000",
//         enforceMaxLength: true,
//         allowBlank: true,
//         maxLength: '20',
//         maskRe: /[0-9]/,
//         selectOnFocus: true,
//         height: 60,
//       },
//       renderer: Ext.util.Format.numberRenderer('0,000'),
//     }, {
//       text: '검사항목1',
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       columns: [{
//           dataIndex: 'PRECHECK1',
//           text: '변경전',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.5"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                   var code = record.data.VALUE;

//                 //                   model.set("PRECHECK1", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                           model.set("PRECHECK1", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, {
//           dataIndex: 'POSTCHECK1',
//           text: '변경후',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.5"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                       var code = record.data.VALUE;

//                 //                       model.set("POSTCHECK1", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                               model.set("POSTCHECK1", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, ],
//     }, {
//       text: '검사항목2',
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       columns: [{
//           dataIndex: 'PRECHECK2',
//           text: '변경전',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.6"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                   var code = record.data.VALUE;

//                 //                   model.set("PRECHECK2", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                           model.set("PRECHECK2", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, {
//           dataIndex: 'POSTCHECK2',
//           text: '변경후',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.6"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                       var code = record.data.VALUE;

//                 //                       model.set("POSTCHECK2", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                               model.set("POSTCHECK2", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, ],
//     }, {
//       text: '검사항목3',
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       columns: [{
//           dataIndex: 'PRECHECK3',
//           text: '변경전',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.7"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                   var code = record.data.VALUE;

//                 //                   model.set("PRECHECK3", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                           model.set("PRECHECK3", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, {
//           dataIndex: 'POSTCHECK3',
//           text: '변경후',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.7"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                       var code = record.data.VALUE;

//                 //                       model.set("POSTCHECK3", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                               model.set("POSTCHECK3", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, ],
//     }, {
//       text: '검사항목4',
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       columns: [{
//           dataIndex: 'PRECHECK4',
//           text: '변경전',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.8"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                   var code = record.data.VALUE;

//                 //                   model.set("PRECHECK4", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                           model.set("PRECHECK4", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, {
//           dataIndex: 'POSTCHECK4',
//           text: '변경후',
//           xtype: 'gridcolumn',
//           hidden: false,
//           sortable: false,
//           resizable: false,
//           menuDisabled: true,
//           width: 170,
//           align: "center",
//           editor: {
//             xtype: 'combobox',
//             store: gridnms["store.8"],
//             valueField: "LABEL",
//             displayField: "LABEL",
//             matchFieldWidth: false,
//             editable: true,
//             allowBlank: true,
//             height: 60,
//             triggerCls: 'trigger-combobox-custom',
//             listeners: {
//               select: function (value, record, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//                 //                       var code = record.data.VALUE;

//                 //                       model.set("POSTCHECK4", code);
//               },
//               change: function (value, nv, ov, eOpts) {
//                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//                 if (nv != ov) {
//                   if (!isNaN(value.getValue())) {

//                     //                               model.set("POSTCHECK4", "");
//                   }
//                 }
//               },
//             },
//             listConfig: {
//               loadingText: '검색 중...',
//               emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//               width: 300,
//               getInnerTpl: function () {
//                 return '<div>'
//                  + '<table>'
//                  + '<tr>'
//                  + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//                  + '</tr>' + '</table>'
//                  + '</div>';
//               }
//             },
//           },
//         }, ],
//     }, {
//       dataIndex: 'MANAGECHECKNAME',
//       text: '관리자확인',
//       xtype: 'gridcolumn',
//       hidden: false,
//       sortable: false,
//       resizable: false,
//       menuDisabled: true,
//       width: 170,
//       align: "center",
//       editor: {
//         xtype: 'combobox',
//         store: gridnms["store.9"],
//         valueField: "LABEL",
//         displayField: "LABEL",
//         matchFieldWidth: false,
//         editable: true,
//         allowBlank: true,
//         height: 60,
//         triggerCls: 'trigger-combobox-custom',
//         listeners: {
//           select: function (value, record, eOpts) {
//             var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
//             var code = record.data.VALUE;

//             model.set("MANAGECHECK", code);
//           },
//           change: function (value, nv, ov, eOpts) {
//             var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

//             if (nv != ov) {
//               if (!isNaN(value.getValue())) {

//                 model.set("MANAGECHECK", "");
//               }
//             }
//           },
//         },
//         listConfig: {
//           loadingText: '검색 중...',
//           emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
//           width: 170,
//           getInnerTpl: function () {
//             return '<div>'
//              + '<table>'
//              + '<tr>'
//              + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
//              + '</tr>' + '</table>' + '</div>';
//           }
//         },
//       },
//     },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHANGESEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'EQUIPMENTCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'EQUIPMENTNAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGNO',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'EMPLOYEENUMBER',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHANGETYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKNAME1',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSTANDARD1',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKNAME2',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSTANDARD2',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKNAME3',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSTANDARD3',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKNAME4',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSTANDARD4',
      xtype: 'hidden',
    }, {
      dataIndex: 'MANAGECHECK',
      xtype: 'hidden',
      //     }, {
      //       dataIndex: 'TOOLLIFE',
      //       xtype: 'hidden',
    }, {
      dataIndex: 'TOOLLIFECHECK',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKCENTERCODE',
      xtype: 'hidden',
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    create: "<c:url value='/insert/prod/process/selectToolChangeRegist.do' />"
  });
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/selectToolChangeRegist.do' />"
  });
  $.extend(items["api.1"], {
    update: "<c:url value='/update/prod/process/selectToolChangeRegist.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
    "#ToolSelect": {
      itemclick: 'ToolSelectClick'
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

function ToolSelectClick(dataview, record, item, index, e, eOpts) {
  var orgid = record.data.ORGID;
  var companyid = record.data.COMPANYID;
  var routingitemcode = record.data.ROUTINGITEMCODE;
  var routingid = record.data.ROUTINGID;
  var workcentercode = record.data.WORKCENTERCODE;
  var checkname1 = record.data.CHECKNAME1;
  var checkname2 = record.data.CHECKNAME2;
  var checkname3 = record.data.CHECKNAME3;
  var checkname4 = record.data.CHECKNAME4;

  var sparams1 = {
    ORGID: orgid,
    COMPANYID: companyid,
    ROUTINGID: routingid,
    GUBUN: 'ITEMNAME',
  };

  extGridSearch(sparams1, gridnms["store.2"]);

//   // 클릭시 검사명에 따라 LOV 값 표시 변경
//   fn_lov_chk_change(checkname1, gridnms["store.5"]);
//   fn_lov_chk_change(checkname2, gridnms["store.6"]);
//   fn_lov_chk_change(checkname3, gridnms["store.7"]);
//   fn_lov_chk_change(checkname4, gridnms["store.8"]);

  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('WORKCENTERCODE', workcentercode);
  Ext.getStore(gridnms["store.3"]).load();

  // 클릭 시 검사명, 검사내용 등을 따로 표기
  $('#CheckName1 span').text(checkname1);
  $('#CheckName2 span').text(checkname2);
  $('#CheckName3 span').text(checkname3);
  $('#CheckName4 span').text(checkname4);

  var checkstandard1 = record.data.CHECKSTANDARD1;
  var checkstandard2 = record.data.CHECKSTANDARD2;
  var checkstandard3 = record.data.CHECKSTANDARD3;
  var checkstandard4 = record.data.CHECKSTANDARD4;
  $('#CheckStandard1 span').text(checkstandard1);
  $('#CheckStandard2 span').text(checkstandard2);
  $('#CheckStandard3 span').text(checkstandard3);
  $('#CheckStandard4 span').text(checkstandard4);
};

function fn_lov_chk_change(name, storename) {
  var sparams = {};

  if (name === "외관") {
    // 검사명이 외관일 경우 OK / NG 표시 될 수 있도록 변경
    sparams = {
      "BIGCD": "APP" + "",
      "MIDDLECD": "유해한 결함 없을 것" + "",
    };
  } else if (name === "" || name === undefined) {
    sparams = {
      "BIGCD": "APP" + "",
      "MIDDLECD": "유해한 결함 없을 것" + "",
    };
  } else {
    sparams = {
      "BIGCD": "APP" + "",
      "MIDDLECD": "!@#$%" + "",
    };
  }

  extGridSearch(sparams, storename);
}

var gridarea1;
function setExtGrid() {
  setExtGrid_list();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function setExtGrid_list() {

  Ext.define(gridnms["model.1"], {
    extend: Ext.data.Model,
    fields: fields["model.1"],
  });

  Ext.define(gridnms["model.2"], {
    extend: Ext.data.Model,
    fields: fields["model.2"],
  });

  Ext.define(gridnms["model.3"], {
    extend: Ext.data.Model,
    fields: fields["model.3"],
  });

  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"],
  });

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"],
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"],
  });

  Ext.define(gridnms["model.7"], {
    extend: Ext.data.Model,
    fields: fields["model.7"],
  });

  Ext.define(gridnms["model.8"], {
    extend: Ext.data.Model,
    fields: fields["model.8"],
  });

  Ext.define(gridnms["model.9"], {
    extend: Ext.data.Model,
    fields: fields["model.9"],
  });

  Ext.define(gridnms["model.10"], {
    extend: Ext.data.Model,
    fields: fields["model.10"],
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
                //                 WORKCENTERCODE: '${searchVO.gubun}',
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.2"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.2"],
            model: gridnms["model.2"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchToolChangeNameListLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                WORKDEPT: '${searchVO.gubun}',
                GUBUN: 'ITEMNAME',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
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
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              //                   url: "<c:url value='/searchWorkerLov.do' />",
              url: "<c:url value='/searchWorkerEquipLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                //                 WORKCENTERCODE: '${EQUIPMENTCODE}',
                //                 INSPECTORTYPE: '20',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.4"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.4"],
            model: gridnms["model.4"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                BIGCD: 'MFG',
                MIDDLECD: 'CHANGE_TYPE',
                WORKSTATUS: 'CHANGE_TYPE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

//   Ext.define(gridnms["store.5"], {
//     extend: Ext.data.Store,
//     constructor: function (cfg) {
//       var me = this;
//       cfg = cfg || {};
//       me.callParent([Ext.apply({
//             storeId: gridnms["store.5"],
//             model: gridnms["model.5"],
//             autoLoad: true,
//             pageSize: gridVals.pageSize,
//             proxy: {
//               type: "ajax",
//               url: "<c:url value='/searchDummyOKNGLov.do' />",
//               extraParams: {
//                 BIGCD: "APP" + "",
//                 MIDDLECD: "유해한 결함 없을 것" + "",
//               },
//               reader: gridVals.reader,
//             }
//           }, cfg)]);
//     },
//   });

  Ext.define(gridnms["store.5"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.5"],
            model: gridnms["model.5"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNG2Lov.do' />",
              extraParams: {
            	  ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                PARAM1: "OK",
                PARAM2: "NG", 
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.6"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.6"],
            model: gridnms["model.6"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              extraParams: {
                BIGCD: "APP" + "",
                MIDDLECD: "유해한 결함 없을 것" + "",
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.7"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.7"],
            model: gridnms["model.7"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              extraParams: {
                BIGCD: "APP" + "",
                MIDDLECD: "유해한 결함 없을 것" + "",
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.8"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.8"],
            model: gridnms["model.8"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              extraParams: {
                BIGCD: "APP" + "",
                MIDDLECD: "유해한 결함 없을 것" + "",
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.9"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.9"],
            model: gridnms["model.9"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchDummyYNLov.do' />",
              extraParams: {
                PARAM1: 'OK',
                // PARAM2: '',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.10"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.10"],
            model: gridnms["model.10"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchToolRoutingItemNameListLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                WORKDEPT: '${searchVO.gubun}',
                WORKCENTERCODE: '${searchVO.code}',
                SEARCHGUBUN: 'TOOLCHANGE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      ToolSelect: '#ToolSelect',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    ToolSelectClick: ToolSelectClick,
  });

  Ext.define(gridnms["panel.1"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.1"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.1"],
        id: gridnms["panel.1"],
        store: gridnms["store.1"],
        height: 818,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'ToolSelect',
          trackOver: true,
          loadMask: true,
          striptRows: true,
          forceFit: true,
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 250) {
                    column.width = 250;
                  }
                }
              });
            }
          },
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = ctx.record;

                var params = {};
                var editDisableCols = [];

                var itemcode = data.data.ITEMCODE;
                if (itemcode != "") {
                  editDisableCols.push("ROUTINGNAME");
                  editDisableCols.push("ITEMNAME");
                }

                var isNew = ctx.record.phantom || false;
                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                  return false;
                else {
                  return true;
                }
              },
              beforerender: function (c) {
                var formFields = [];
                //컴포넌트를 탐색하면서 field인것만 검
                c.cascade(function (field) {
                  var xtypeChains = field.xtypesChain;

                  var isField = Ext.Array.findBy(xtypeChains, function (item) {

                      // DisplayField는 이벤트 대상에서 제외
                      if (item == 'displayfield') {
                        return false;
                      }

                      // Ext.form.field.Base를 상속받는 모든객체
                      if (item == 'field') {
                        return true;
                      }
                    });
                  //keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
                  if (isField) {
                    field.enableKeyEvents = true;
                    field.isShiftKeyPressed = false;
                    formFields.push(field);

                  }

                });

                for (var i = 0; i < formFields.length - 1; i++) {
                  var beforeField = (i == 0) ? null : formFields[i - 1];
                  var field = formFields[i];
                  var nextField = formFields[i + 1];

                  field.addListener('keyup', function (thisField, e) {
                    //Shift Key 처리방법
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = false;
                      return;
                    }
                  });

                  field.addListener('keydown', function (thisField, e) {
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = true;
                      return;
                    }

                    // Shift키 안누르고 ENTER키 또는 TAB키 누를때 다음필드로 이동
                    if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                      this.nextField.focus();
                      e.stopEvent();

                    }
                    // Shift키 누른상태에서 TAB키 누를때 이전필드로 이동
                    else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
                      if (this.beforeField != null) {
                        this.beforeField.focus();
                        e.stopEvent();
                      }
                    }

                  }, {
                    nextField: nextField,
                    beforeField: beforeField
                  });
                }
              }
            },
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

var interval1;
var font_check = false;
function setcolor(x) {
  // 글자 깜빡임 스크립터
  if (x == 'changerow') {
    interval1 = setInterval(function () {
        font_change(x);
      }, 400);
  }
}

function font_change(csnm) {

  if (font_check) {
    $('.' + csnm).css("color", "rgb(255,0,0)");
  } else {
    $('.' + csnm).css("color", "rgb(0, 0, 255)");
  }
  font_check = !font_check;
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
    go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 13) {
    go_url('<c:url value="/prod/process/WrokOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else {
    go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
  }
}

function fn_tab(flag) {
  $("#tab1, #tab11").removeClass("active");

  $('#tabclick').val(flag);

  switch (flag) {
  case "1":
    // 변경공구등록
    $("#tab1").addClass("active");
    $("#tab11").addClass("active");

    $('#btn_tab_add').show();
    $('#btn_tab_sav').show();
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
    var model = Ext.create(gridnms["model.1"]);
    var store = Ext.getStore(gridnms["store.1"]);
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var workcentercode = $('#workcentercode').val();

    var listcount = Ext.getStore(gridnms["store.1"]).count();
    for (var i = 0; i < listcount; i++) {
      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
      var dummy = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

      dummy.set("RN", (dummy.get("RN") * 1) + 1);
    }

    model.set("RN", 1);
    model.set("ORGID", orgid);
    model.set("COMPANYID", companyid);
    model.set("WORKCENTERCODE", workcentercode);

    var today = Ext.util.Format.date(new Date(), 'Y-m-d H:i');
    model.set("CHANGEDATE", today);

    store.insert(0, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], 0, 3);

    break;
  default:
    break;
  }
}

function fn_btn_save() {
  var flag = $('#tabclick').val();
  switch (flag) {
  case "1":
    // 생산실적등록
    var count100 = Ext.getStore(gridnms["store.1"]).count();
    var header = [],
    count = 0;

    if (count100 > 0) {
      for (i = 0; i < count100; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var CHANGEDATE = model1.data.CHANGEDATE;
        var ROUTINGID = model1.data.ROUTINGID;
        var ITEMCODE = model1.data.ITEMCODE;
        var EMPLOYEENUMBER = model1.data.EMPLOYEENUMBER;
        var PRODQTY = model1.data.PRODQTY;
        var CHANGETYPE = model1.data.CHANGETYPE;

        if (CHANGEDATE == "" || CHANGEDATE == undefined) {
          header.push("일자");
          count++;
        }
        if (ROUTINGID == "" || ROUTINGID == undefined) {
          header.push("공정명");
          count++;
        }
        if (ITEMCODE == "" || ITEMCODE == undefined) {
          header.push("공구명");
          count++;
        }
        if (EMPLOYEENUMBER == "" || EMPLOYEENUMBER == undefined) {
          header.push("작업자");
          count++;
        }
//         if (PRODQTY == "" || PRODQTY == undefined) {
//           header.push("작업수량");
//           count++;
//         }
        if (CHANGETYPE == "" || CHANGETYPE == undefined) {
          header.push("교환사유");
          count++;
        }

        if (count > 0) {
          extToastView("[변경공구등록 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
          return false;
        }
      }
    }

    Ext.getStore(gridnms["store.1"]).sync({
      success: function (batch, options) {
        msg = "[공구 등록 / 변경] " + msgs.noti.save;
        extToastView(msg);

        Ext.getStore(gridnms["store.1"]).load();
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
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post">
                    <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="status" name="status" value="${STATUS}" />
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="workcentercode" name="workcentercode" value="${EQUIPMENTCODE}"/>
                    <input type="hidden" id="workcentername" name="workcentername" value="${EQUIPMENTNAME}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <input type="hidden" id="tabclick" name="tabclick" />
                    <c:choose>
                        <c:when test="${searchVO.work == 'Y'}">
                            <div style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
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
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
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
                    <table style="width: 100%; margin-top: 15px;">
                            <tr style="height: 28px;">
                                    <td style="width: 100%;">
                                        <div class="tab line" style="width: calc(100% - 87%); height: 39px; padding-bottom: 0px; float: left;">
                                                <ul>
                                                        <li id="tab1"><a href="#" onclick="javascript:fn_tab('1');" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">변경공구등록</span></a></li>
                                                </ul>
                                        </div>
                                        <div style="width: calc(100% - 13%); height: 39px; border-bottom: 1px solid #0074bd; float: right;">
                                                <button type="button" id="btn_tab_add" class="blue2 r shadow" onclick="fn_btn_add();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">추가 (Add)</button>
                                                <button type="button" id="btn_tab_sav" class="blue2 r shadow" onclick="fn_btn_save();" style="width: 130px; height: 33px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">저장 (Save)</button>
                                        </div>
                                    </td>
                            </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; padding-top: 0px; margin-bottom: 15px; float: left;"></div>
                    
                    <div style="display: none; ">
	                    <table style="width: 100%; margin-top: 15px;">
	                            <tr style="height: 28px;">
	                                    <td style="width: 100%;">
	                                        <div class="tab line" style="width: calc(100% - 0%); height: 39px; padding-bottom: 0px; float: left;">
	                                                <ul>
	                                                        <li id="tab11"><a href="#" select><span id="tabLabel" style="width: 100%; font-size:20pt; border-width: 3px; line-height:1em">공구상세내역</span></a></li>
	                                                </ul>
	                                        </div>
	                                    </td>
	                            </tr>
	                    </table>
		                  <table class="ResultTable" style="width: 100%; margin-left: 0px; margin-top: 0px; padding-top: 0px;">
		                  <colgroup>
		                    <col width="250px">
		                    <col>
		                    <col>
	                      <col>
	                      <col>
		                  </colgroup>
		                  <tbody>
		                    <tr style="height: 45px;">
		                      <th style="font-size: 18px; border-right-style: solid; border-right-width: 1px; border-right-color: white;"></th>
		                      <th style="font-size: 22px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목1</th>
	                        <th style="font-size: 22px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목2</th>
	                        <th style="font-size: 22px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목3</th>
	                        <th style="font-size: 22px;">검사항목4</th>
	                      </tr>
	                      <tr style="height: 45px;">
	                        <th style="font-size: 22px;">검 사 명</th>
	                        <td>
	                          <label id="CheckName1" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckName2" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckName3" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckName4" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                      </tr>
	                      <tr style="height: 45px;">
	                        <th style="font-size: 22px;">검사내용</th>
	                        <td>
	                          <label id="CheckStandard1" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckStandard2" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckStandard3" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
	                        <td>
	                          <label id="CheckStandard4" style="font-size: 22px; color: black; font-weight: bold;" >
	                            <span></span>
	                          </label>
	                        </td>
		                    </tr>
		                  </tbody>
		                  </table>
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