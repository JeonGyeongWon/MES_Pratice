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

<style>
.ui-autocomplete {
    max-height: 420px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
}

* html .ui-autocomplete {
    /* IE 6.0 */
    height: 420px;
}

.ERPQTY  .x-column-header-text {
    margin-right: 0px;
}
.gridStyle table td {
  height : 27px;
  font-size : 13px;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  calender($('#searchFrom, #searchTo'));

	  $('#searchFrom, #searchTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchFrom").val(getToDay("${searchVO.DATEFROM}") + "");
	  $("#searchTo").val(getToDay("${searchVO.DATETO}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.manage"] = [];
	  gridnms["stores.manage"] = [];
	  gridnms["views.manage"] = [];
	  gridnms["controllers.manage"] = [];

	  gridnms["grid.1"] = "ProdToolChangeManage";
	  gridnms["grid.2"] = "ToolNameLov";
	  gridnms["grid.3"] = "WorkerLov";
	  gridnms["grid.4"] = "ChangeReasonLov";
	  gridnms["grid.5"] = "Check1Lov";
	  gridnms["grid.6"] = "Check2Lov";
	  gridnms["grid.7"] = "Check3Lov";
	  gridnms["grid.8"] = "Check4Lov";
	  gridnms["grid.9"] = "ManageCheckLov";
	  gridnms["grid.10"] = "RoutingItemNameLov";
	  gridnms["grid.11"] = "RoutingNameLov";
	  gridnms["grid.12"] = "ItemNameLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.manage"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.manage"].push(gridnms["controller.1"]);

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
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
	  gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

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
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
	  gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

	  gridnms["models.manage"].push(gridnms["model.1"]);
	  gridnms["models.manage"].push(gridnms["model.2"]);
	  gridnms["models.manage"].push(gridnms["model.3"]);
	  gridnms["models.manage"].push(gridnms["model.4"]);
	  gridnms["models.manage"].push(gridnms["model.5"]);
	  gridnms["models.manage"].push(gridnms["model.6"]);
	  gridnms["models.manage"].push(gridnms["model.7"]);
	  gridnms["models.manage"].push(gridnms["model.8"]);
	  gridnms["models.manage"].push(gridnms["model.9"]);
	  gridnms["models.manage"].push(gridnms["model.10"]);
	  gridnms["models.manage"].push(gridnms["model.11"]);
	  gridnms["models.manage"].push(gridnms["model.12"]);

	  gridnms["stores.manage"].push(gridnms["store.1"]);
	  gridnms["stores.manage"].push(gridnms["store.2"]);
	  gridnms["stores.manage"].push(gridnms["store.3"]);
	  gridnms["stores.manage"].push(gridnms["store.4"]);
	  gridnms["stores.manage"].push(gridnms["store.5"]);
	  gridnms["stores.manage"].push(gridnms["store.6"]);
	  gridnms["stores.manage"].push(gridnms["store.7"]);
	  gridnms["stores.manage"].push(gridnms["store.8"]);
	  gridnms["stores.manage"].push(gridnms["store.9"]);
	  gridnms["stores.manage"].push(gridnms["store.10"]);
	  gridnms["stores.manage"].push(gridnms["store.11"]);
	  gridnms["stores.manage"].push(gridnms["store.12"]);

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
	      type: 'string',
	      name: 'WORKCENTERCODE',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGITEMNAME',
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
	      name: 'CARTYPENAME',
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
	      name: 'CHECKMETHODNAME1',
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
	      name: 'CHECKMETHODNAME2',
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
	      name: 'CHECKMETHODNAME3',
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
	      name: 'CHECKMETHODNAME4',
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
	      name: 'DRAWINGNO',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
      }, {
	      type: 'string',
	      name: 'CARTYPENAME',
	    }, ];

	  fields["model.11"] = [{
	      type: 'string',
	      name: 'ROUTINGCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGOP',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, ];

	  fields["model.12"] = [{
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'TOOLLIFE',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
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
	      dataIndex: 'ROUTINGITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      tdCls: 'changerow',
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.10"],
	        valueField: "ITEMNAME",
	        displayField: "ITEMNAME",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	            model.set("ROUTINGITEMCODE", record.data.ITEMCODE);
	            model.set("CARTYPENAME", record.data.CARTYPENAME);

	            var item = record.data.ITEMNAME;
	            if (item == "") {
	              model.set("ROUTINGITEMCODE", "");
	            }

	            model.set("ROUTINGID", "");
	            model.set("ROUTINGNO", "");
	            model.set("ROUTINGNAME", "");
	            model.set("ITEMCODE", "");
	            model.set("ITEMNAME", "");
	            model.set("WORKCENTERCODE", "");
	            model.set("WORKCENTERNAME", "");
	            model.set("EQUIPMENTCODE", "");
	            model.set("EQUIPMENTNAME", "");

	            model.set("CHECKSEQ", "");
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

	            var checkstandard1 = "";
	            var checkstandard2 = "";
	            var checkstandard3 = "";
	            var checkstandard4 = "";
	            var checkname1 = "";
	            var checkname2 = "";
	            var checkname3 = "";
	            var checkname4 = "";

	            // 클릭시 검사명에 따라 LOV 값 표시 변경
	            fn_lov_chk_change(checkname1, gridnms["store.5"]);
	            fn_lov_chk_change(checkname2, gridnms["store.6"]);
	            fn_lov_chk_change(checkname3, gridnms["store.7"]);
	            fn_lov_chk_change(checkname4, gridnms["store.8"]);

	            // 클릭 시 검사명, 검사내용 등을 따로 표기
	            $('#CheckName1 span').text(checkname1);
	            $('#CheckName2 span').text(checkname2);
	            $('#CheckName3 span').text(checkname3);
	            $('#CheckName4 span').text(checkname4);

	            $('#CheckStandard1 span').text(checkstandard1);
	            $('#CheckStandard2 span').text(checkstandard2);
	            $('#CheckStandard3 span').text(checkstandard3);
	            $('#CheckStandard4 span').text(checkstandard4);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var result = field.getValue();
	            if (ov != nv) {
	              if (!isNaN(result)) {
	            	  model.set("CARTYPENAME", "");
	                model.set("ROUTINGITEMCODE", "");
	                model.set("ROUTINGID", "");
	                model.set("ROUTINGNO", "");
	                model.set("ROUTINGNAME", "");
	                model.set("ITEMCODE", "");
	                model.set("ITEMNAME", "");
	                model.set("WORKCENTERCODE", "");
	                model.set("WORKCENTERNAME", "");
	                model.set("EQUIPMENTCODE", "");
	                model.set("EQUIPMENTNAME", "");

	                model.set("CHECKSEQ", "");
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

	                var checkstandard1 = "";
	                var checkstandard2 = "";
	                var checkstandard3 = "";
	                var checkstandard4 = "";
	                var checkname1 = "";
	                var checkname2 = "";
	                var checkname3 = "";
	                var checkname4 = "";

	                // 클릭시 검사명에 따라 LOV 값 표시 변경
	                fn_lov_chk_change(checkname1, gridnms["store.5"]);
	                fn_lov_chk_change(checkname2, gridnms["store.6"]);
	                fn_lov_chk_change(checkname3, gridnms["store.7"]);
	                fn_lov_chk_change(checkname4, gridnms["store.8"]);

	                // 클릭 시 검사명, 검사내용 등을 따로 표기
	                $('#CheckName1 span').text(checkname1);
	                $('#CheckName2 span').text(checkname2);
	                $('#CheckName3 span').text(checkname3);
	                $('#CheckName4 span').text(checkname4);

	                $('#CheckStandard1 span').text(checkstandard1);
	                $('#CheckStandard2 span').text(checkstandard2);
	                $('#CheckStandard3 span').text(checkstandard3);
	                $('#CheckStandard4 span').text(checkstandard4);
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 500,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="350px">'
	             + '<col width="150px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ITEMNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{CARTYPENAME}</td>'
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
	        return value;
	      },
      }, {
	      dataIndex: 'CARTYPENAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 100,
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
	      },
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      tdCls: 'changerow',
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.11"],
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
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	            model.set("ROUTINGID", record.data.ROUTINGCODE);
	            model.set("ROUTINGNO", record.data.ROUTINGNO);

	            var item = record.data.ROUTINGNAME;

	            model.set("ITEMCODE", "");
	            model.set("ITEMNAME", "");
	            model.set("WORKCENTERCODE", "");
	            model.set("WORKCENTERNAME", "");
	            model.set("EQUIPMENTCODE", "");
	            model.set("EQUIPMENTNAME", "");

	            model.set("CHECKSEQ", "");
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
	            if (item == "") {
	              model.set("ROUTINGID", "");
	              model.set("ROUTINGNO", "");
	            }
	            var checkstandard1 = "";
	            var checkstandard2 = "";
	            var checkstandard3 = "";
	            var checkstandard4 = "";
	            var checkname1 = "";
	            var checkname2 = "";
	            var checkname3 = "";
	            var checkname4 = "";

	            // 클릭시 검사명에 따라 LOV 값 표시 변경
	            fn_lov_chk_change(checkname1, gridnms["store.5"]);
	            fn_lov_chk_change(checkname2, gridnms["store.6"]);
	            fn_lov_chk_change(checkname3, gridnms["store.7"]);
	            fn_lov_chk_change(checkname4, gridnms["store.8"]);

	            // 클릭 시 검사명, 검사내용 등을 따로 표기
	            $('#CheckName1 span').text(checkname1);
	            $('#CheckName2 span').text(checkname2);
	            $('#CheckName3 span').text(checkname3);
	            $('#CheckName4 span').text(checkname4);

	            $('#CheckStandard1 span').text(checkstandard1);
	            $('#CheckStandard2 span').text(checkstandard2);
	            $('#CheckStandard3 span').text(checkstandard3);
	            $('#CheckStandard4 span').text(checkstandard4);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                model.set("ROUTINGID", "");
	                model.set("ROUTINGNO", "");
	                model.set("ITEMCODE", "");
	                model.set("ITEMNAME", "");
	                model.set("WORKCENTERCODE", "");
	                model.set("WORKCENTERNAME", "");
	                model.set("EQUIPMENTCODE", "");
	                model.set("EQUIPMENTNAME", "");

	                model.set("CHECKSEQ", "");
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

	                var checkstandard1 = "";
	                var checkstandard2 = "";
	                var checkstandard3 = "";
	                var checkstandard4 = "";
	                var checkname1 = "";
	                var checkname2 = "";
	                var checkname3 = "";
	                var checkname4 = "";

	                // 클릭시 검사명에 따라 LOV 값 표시 변경
	                fn_lov_chk_change(checkname1, gridnms["store.5"]);
	                fn_lov_chk_change(checkname2, gridnms["store.6"]);
	                fn_lov_chk_change(checkname3, gridnms["store.7"]);
	                fn_lov_chk_change(checkname4, gridnms["store.8"]);

	                // 클릭 시 검사명, 검사내용 등을 따로 표기
	                $('#CheckName1 span').text(checkname1);
	                $('#CheckName2 span').text(checkname2);
	                $('#CheckName3 span').text(checkname3);
	                $('#CheckName4 span').text(checkname4);

	                $('#CheckStandard1 span').text(checkstandard1);
	                $('#CheckStandard2 span').text(checkstandard2);
	                $('#CheckStandard3 span').text(checkstandard3);
	                $('#CheckStandard4 span').text(checkstandard4);
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 290,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="120px">'
	             + '<col width="170px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ROUTINGOP}</td>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ROUTINGNAME}</td>'
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
	        return value;
	      },
	    }, {
	      dataIndex: 'WORKCENTERNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      tdCls: 'changerow',
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "WORKCENTERNAME",
	        displayField: "WORKCENTERNAME",
	        matchFieldWidth: false,
	        editable: false,
	        allowBlank: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var equipmentcode = record.data.EQUIPMENTCODE;
	            var equipmentname = record.data.EQUIPMENTNAME;
	            var value = record.data.WORKCENTERCODE;

	            model.set("EQUIPMENTCODE", equipmentcode);
	            model.set("EQUIPMENTNAME", equipmentname);
	            model.set("WORKCENTERCODE", value);

	            var employeenumber = model.data.EMPLOYEENUMBER;
	            if (employeenumber != "") {
	              model.set("EMPLOYEENUMBER", "");
	              model.set("KRNAME", "");
	            }
	          },
	          change: function (value, nv, ov, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	            if (nv != ov) {
	              if (!isNaN(value.getValue())) {

	                model.set("EQUIPMENTCODE", "");
	                model.set("EQUIPMENTNAME", "");
	                model.set("WORKCENTERCODE", "");
	                model.set("EMPLOYEENUMBER", "");
	                model.set("KRNAME", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 300,
	          getInnerTpl: function () {
	            return '<div>'
	             + '<table>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{WORKCENTERNAME}</td>'
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
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '공구명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      tdCls: 'changerow',
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.12"],
	        valueField: "ITEMNAME",
	        displayField: "ITEMNAME",
	        matchFieldWidth: false,
	        editable: false,
	        queryParam: 'keyword',
	        queryMode: 'remote', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
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
	            model.set("PRODQTY", toollife);
	            model.set("TOOLLIFE", toollife);
	            model.set("TOOLLIFECHECK", "N");

	            model.set("CHECKCODE1", checkcode1);
	            model.set("CHECKNAME1", checkname1);
	            model.set("CHECKSTANDARD1", checkstandard1);
	            model.set("CHECKCODE2", checkcode2);
	            model.set("CHECKNAME2", checkname2);
	            model.set("CHECKSTANDARD2", checkstandard2);
	            model.set("CHECKCODE3", checkcode3);
	            model.set("CHECKNAME3", checkname3);
	            model.set("CHECKSTANDARD3", checkstandard3);
	            model.set("CHECKCODE4", checkcode4);
	            model.set("CHECKNAME4", checkname4);
	            model.set("CHECKSTANDARD4", checkstandard4);

	            // 클릭시 검사명에 따라 LOV 값 표시 변경
	            fn_lov_chk_change(checkname1, gridnms["store.5"]);
	            fn_lov_chk_change(checkname2, gridnms["store.6"]);
	            fn_lov_chk_change(checkname3, gridnms["store.7"]);
	            fn_lov_chk_change(checkname4, gridnms["store.8"]);

	            // 클릭 시 검사명, 검사내용 등을 따로 표기
	            $('#CheckName1 span').text(checkname1);
	            $('#CheckName2 span').text(checkname2);
	            $('#CheckName3 span').text(checkname3);
	            $('#CheckName4 span').text(checkname4);

	            $('#CheckStandard1 span').text(checkstandard1);
	            $('#CheckStandard2 span').text(checkstandard2);
	            $('#CheckStandard3 span').text(checkstandard3);
	            $('#CheckStandard4 span').text(checkstandard4);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
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

	                var checkstandard1 = "";
	                var checkstandard2 = "";
	                var checkstandard3 = "";
	                var checkstandard4 = "";
	                var checkname1 = "";
	                var checkname2 = "";
	                var checkname3 = "";
	                var checkname4 = "";

	                // 클릭시 검사명에 따라 LOV 값 표시 변경
	                fn_lov_chk_change(checkname1, gridnms["store.5"]);
	                fn_lov_chk_change(checkname2, gridnms["store.6"]);
	                fn_lov_chk_change(checkname3, gridnms["store.7"]);
	                fn_lov_chk_change(checkname4, gridnms["store.8"]);

	                // 클릭 시 검사명, 검사내용 등을 따로 표기
	                $('#CheckName1 span').text(checkname1);
	                $('#CheckName2 span').text(checkname2);
	                $('#CheckName3 span').text(checkname3);
	                $('#CheckName4 span').text(checkname4);

	                $('#CheckStandard1 span').text(checkstandard1);
	                $('#CheckStandard2 span').text(checkstandard2);
	                $('#CheckStandard3 span').text(checkstandard3);
	                $('#CheckStandard4 span').text(checkstandard4);
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 480,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="180px">'
	             + '<col width="180px">'
	             + '<col width="120px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ITEMNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ITEMSTANDARD}</td>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold; ">{TOOLLIFE}</td>'
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
	        return value;
	      },
	    }, {
	      dataIndex: 'CHANGEDATE',
	      text: '일자',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	        listeners: {
	          select: function (value, record) {
	            var selectedRow = Ext.getCmp(gridnms["views.manage"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0];

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
	        meta.style = "background-color:rgb(253, 218, 255); ";

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
	      dataIndex: 'KRNAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var code = record.data.VALUE;

	            model.set("EMPLOYEENUMBER", code);
	          },
	          change: function (value, nv, ov, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	            if (nv != ov) {
	              if (!isNaN(value.getValue())) {

	                model.set("EMPLOYEENUMBER", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 150,
	          getInnerTpl: function () {
	            return '<div>'
	             + '<table>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
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
	        return value;
	      },
	    }, {
	      dataIndex: 'TOOLLIFE',
	      text: 'TOOL LIFE<br/>(EA)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	      text: '작업수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var qty = newValue;
	            var toollife = model.data.TOOLLIFE;

	            if (toollife < qty) {
	              model.set("TOOLLIFECHECK", "Y");
	            } else {
	              model.set("TOOLLIFECHECK", "N");
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
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.4"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: false,
	        allowBlank: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
	            var code = record.data.VALUE;

	            model.set("CHANGETYPE", code);
	          },
	          change: function (value, nv, ov, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	            if (nv != ov) {
	              if (!isNaN(value.getValue())) {

	                model.set("CHANGETYPE", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;등록된 데이터가 없습니다.&nbsp;관리자에게 문의하십시오.</span>',
	          width: 170,
	          getInnerTpl: function () {
	            return '<div>'
	             + '<table>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return value;
	      },
// 	    }, {
// 	      dataIndex: 'BACKQTY',
// 	      text: '역추적현황',
// 	      xtype: 'gridcolumn',
// 	      width: 120,
// 	      hidden: false,
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      align: "right",
// 	      cls: 'ERPQTY',
// 	      format: "0,000",
// 	      editor: {
// 	        xtype: "textfield",
// 	        minValue: 1,
// 	        format: "0,000",
// 	        enforceMaxLength: true,
// 	        allowBlank: true,
// 	        maxLength: '20',
// 	        maskRe: /[0-9]/,
// 	        selectOnFocus: true,
// 	      },
// 	      renderer: Ext.util.Format.numberRenderer('0,000'),
// 	    }, {
// 	      dataIndex: 'NCRQTY',
// 	      text: '부적합품<br/>처리현황',
// 	      xtype: 'gridcolumn',
// 	      width: 120,
// 	      hidden: false,
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      align: "right",
// 	      cls: 'ERPQTY',
// 	      format: "0,000",
// 	      editor: {
// 	        xtype: "textfield",
// 	        minValue: 1,
// 	        format: "0,000",
// 	        enforceMaxLength: true,
// 	        allowBlank: true,
// 	        maxLength: '20',
// 	        maskRe: /[0-9]/,
// 	        selectOnFocus: true,
// 	      },
// 	      renderer: Ext.util.Format.numberRenderer('0,000'),
// 	    }, {
// 	      text: '검사항목1',
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      columns: [{
// 	          dataIndex: 'PRECHECK1',
// 	          text: '변경전',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.5"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                   var code = record.data.VALUE;

// 	                //                   model.set("PRECHECK1", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                           model.set("PRECHECK1", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
	        }, {
// 	          dataIndex: 'POSTCHECK1',
// 	          text: '변경후',
            dataIndex: 'MANAGECHECK',
            text: '확인결과',
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
	            store: gridnms["store.5"],
	            valueField: "LABEL",
	            displayField: "LABEL",
	            matchFieldWidth: false,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                                      var code = record.data.VALUE;

// 	                                      model.set("MANAGECHECK", code);
	              },
	              change: function (value, nv, ov, eOpts) {
	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

	                if (nv != ov) {
	                  if (!isNaN(value.getValue())) {

// 	                                                  model.set("MANAGECHECK", "");
	                  }
	                }
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
	              width: 150,
	              getInnerTpl: function () {
	                return '<div>'
	                 + '<table>'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
	                 + '</tr>'
	                 + '</table>'
	                 + '</div>';
	              }
	            },
	          },
// 	        }, ],
// 	    }, {
// 	      text: '검사항목2',
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      columns: [{
// 	          dataIndex: 'PRECHECK2',
// 	          text: '변경전',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.6"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                   var code = record.data.VALUE;

// 	                //                   model.set("PRECHECK2", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                           model.set("PRECHECK2", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, {
// 	          dataIndex: 'POSTCHECK2',
// 	          text: '변경후',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.6"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                       var code = record.data.VALUE;

// 	                //                       model.set("POSTCHECK2", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                               model.set("POSTCHECK2", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, ],
// 	    }, {
// 	      text: '검사항목3',
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      columns: [{
// 	          dataIndex: 'PRECHECK3',
// 	          text: '변경전',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.7"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                   var code = record.data.VALUE;

// 	                //                   model.set("PRECHECK3", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                           model.set("PRECHECK3", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, {
// 	          dataIndex: 'POSTCHECK3',
// 	          text: '변경후',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.7"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                       var code = record.data.VALUE;

// 	                //                       model.set("POSTCHECK3", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                               model.set("POSTCHECK3", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, ],
// 	    }, {
// 	      text: '검사항목4',
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      columns: [{
// 	          dataIndex: 'PRECHECK4',
// 	          text: '변경전',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.8"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                   var code = record.data.VALUE;

// 	                //                   model.set("PRECHECK4", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                           model.set("PRECHECK4", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, {
// 	          dataIndex: 'POSTCHECK4',
// 	          text: '변경후',
// 	          xtype: 'gridcolumn',
// 	          width: 120,
// 	          hidden: false,
// 	          sortable: false,
// 	          resizable: false,
// 	          menuDisabled: true,
// 	          style: 'text-align:center;',
// 	          align: "center",
// 	          editor: {
// 	            xtype: 'combobox',
// 	            store: gridnms["store.8"],
// 	            valueField: "LABEL",
// 	            displayField: "LABEL",
// 	            matchFieldWidth: false,
// 	            editable: true,
// 	            allowBlank: true,
// 	            listeners: {
// 	              select: function (value, record, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	                //                       var code = record.data.VALUE;

// 	                //                       model.set("POSTCHECK4", code);
// 	              },
// 	              change: function (value, nv, ov, eOpts) {
// 	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	                if (nv != ov) {
// 	                  if (!isNaN(value.getValue())) {

// 	                    //                               model.set("POSTCHECK4", "");
// 	                  }
// 	                }
// 	              },
// 	            },
// 	            listConfig: {
// 	              loadingText: '검색 중...',
// 	              emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
// 	              width: 150,
// 	              getInnerTpl: function () {
// 	                return '<div>'
// 	                 + '<table>'
// 	                 + '<tr>'
// 	                 + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	                 + '</tr>'
// 	                 + '</table>'
// 	                 + '</div>';
// 	              }
// 	            },
// 	          },
// 	        }, ],
// 	    }, {
// 	      dataIndex: 'MANAGECHECKNAME',
// 	      text: '관리자확인',
// 	      xtype: 'gridcolumn',
// 	      width: 120,
// 	      hidden: false,
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center;',
// 	      align: "center",
// 	      editor: {
// 	        xtype: 'combobox',
// 	        store: gridnms["store.9"],
// 	        valueField: "LABEL",
// 	        displayField: "LABEL",
// 	        matchFieldWidth: false,
// 	        editable: true,
// 	        allowBlank: true,
// 	        listeners: {
// 	          select: function (value, record, eOpts) {
// 	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);
// 	            var code = record.data.VALUE;

// 	            model.set("MANAGECHECK", code);
// 	          },
// 	          change: function (value, nv, ov, eOpts) {
// 	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0].id);

// 	            if (nv != ov) {
// 	              if (!isNaN(value.getValue())) {

// 	                model.set("MANAGECHECK", "");
// 	              }
// 	            }
// 	          },
// 	        },
// 	        listConfig: {
// 	          loadingText: '검색 중...',
// 	          emptyText: '<span style="height: 25px; font-size: 13px; font-weight: bold;">&nbsp;관리자에게 문의해주세요.</span>',
// 	          width: 150,
// 	          getInnerTpl: function () {
// 	            return '<div>'
// 	             + '<table>'
// 	             + '<tr>'
// 	             + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{LABEL}</td>'
// 	             + '</tr>'
// 	             + '</table>'
// 	             + '</div>';
// 	          }
// 	        },
// 	      },
	    },
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
	      dataIndex: 'WORKCENTERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGITEMCODE',
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
	      dataIndex: 'ITEMNAME',
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
	      //      }, {
	      //        dataIndex: 'TOOLLIFE',
	      //        xtype: 'hidden',
	    }, {
	      dataIndex: 'TOOLLIFECHECK',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/prod/process/selectToolChangeRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdToolChangeManage.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/prod/process/selectToolChangeRegist.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnAdd1": {
	      click: 'btnAdd1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#ToolChangeManage": {
	      itemclick: 'ToolSelectClick'
	    }
	  });

	  items["dock.paging.1"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.1"],
	  };

	  items["dock.btn.1"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.1"],
	    items: items["btns.1"],
	  };

	  items["docked.1"] = [];
	  items["docked.1"].push(items["dock.btn.1"]);
	}

	function btnAdd1(o, e) {
	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	  var searchProdCode = $('#searchProdCode').val();
	  var searchRoutingId = $('#searchRoutingId').val();
	  var searchItemCode = $('#searchItemCode').val();

	  //    if (searchProdCode == "" || searchProdCode == undefined) {
	  //      extAlert("품명을 입력/선택하여 주십시오.");
	  //      return;
	  //    }

	  //    if (searchRoutingId == "" || searchRoutingId == undefined) {
	  //      extAlert("공정명을 입력/선택하여 주십시오.");
	  //      return;
	  //    }

	  //    if (searchItemCode == "" || searchItemCode == undefined) {
	  //      extAlert("공구명을 입력/선택하여 주십시오.");
	  //      return;
	  //    }

    //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
    var sortorder = 0;
    var listcount = Ext.getStore(gridnms["store.1"]).count();
    for (var i = 0; i < listcount; i++) {
      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).getSelectionModel().select(i));
      var dummy = Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0];

      var dummy_sort = dummy.data.RN * 1;
      if (sortorder < dummy_sort) {
        sortorder = dummy_sort;
      }
    }
    sortorder++;

    model.set("RN", sortorder);

	  model.set("ORGID", $("#searchOrgId").val());
	  model.set("COMPANYID", $("#searchCompanyId").val());
	  model.set("ROUTINGITEMCODE", $('#searchProdCode').val());
	  model.set("ROUTINGITEMNAME", $('#searchProdName').val());
	  model.set("ROUTINGID", $('#searchRoutingId').val());
	  model.set("ROUTINGNAME", $('#searchRoutingName').val());
	  model.set("ITEMCODE", $('#searchItemCode').val());
	  model.set("ITEMNAME", $('#searchItemName').val());

	  var today = Ext.util.Format.date(new Date(), 'Y-m-d H:i');
	  model.set("CHANGEDATE", today);

	    //   store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	    var view = Ext.getCmp(gridnms['panel.1']).getView();
	    var startPoint = 0;

	    store.insert(startPoint, model);
	    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.manage"], startPoint, 1);
	};

	function btnSav1(o, e) {
	  // 저장시 필수값 체크
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.manage"]).getSelectionModel().select(i));
	      var model1 = Ext.getCmp(gridnms["views.manage"]).selModel.getSelection()[0];

	      var routingitemcode = model1.data.ROUTINGITEMCODE;
	      var routingid = model1.data.ROUTINGID;
	      var itemcode = model1.data.ITEMCODE;
	      var equipmentname = model1.data.EQUIPMENTCODE;
	      var channgedate = model1.data.CHANGEDATE;
	      var employeenumber = model1.data.EMPLOYEENUMBER;
	      var prodqty = model1.data.PRODQTY;
	      var changetype = model1.data.CHANGETYPE;

	      if (routingitemcode == "" || routingitemcode == undefined) {
	        header.push("품명");
	        count++;
	      }

	      if (routingid == "" || routingid == undefined) {
	        header.push("공정명");
	        count++;
	      }

	      if (itemcode == "" || itemcode == undefined) {
	        header.push("공구명");
	        count++;
	      }

	      if (equipmentname == "" || equipmentname == undefined) {
	        header.push("설비명");
	        count++;
	      }

	      if (channgedate == "" || channgedate == undefined) {
	        header.push("일자");
	        count++;
	      }

	      if (employeenumber == "" || employeenumber == undefined) {
	        header.push("작업자");
	        count++;
	      }

	      if (prodqty == "" || prodqty == undefined) {
	        header.push("작업수량");
	        count++;
	      }

	      if (changetype == "" || changetype == undefined) {
	        header.push("교환사유");
	        count++;
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    }
	  } else {
	    extAlert("[저장] 공구변경 현황 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  } else {
	    Ext.getStore(gridnms["store.1"]).sync({
	      success: function (batch, options) {
	        var reader = batch.proxy.getReader();

	        msg = reader.rawData.msg;
	        extAlert(msg);
	      },
	      failure: function (batch, options) {
	        msg = batch.operations[0].error;
	        extAlert(msg);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	  setTimeout(function () {
	    Ext.getStore(gridnms["store.1"]).load();
	  }, 200);
	};

	function btnRef1(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	function ToolSelectClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var routingitemcode = record.data.ROUTINGITEMCODE;
	  var routingid = record.data.ROUTINGID;
	  var itemcode = record.data.ITEMCODE;
	  var workcentercode = record.data.WORKCENTERCODE;
	  $('#orgid').val(orgid);
	  $('#companyid').val(companyid);
	  $('#routingitemcode').val(routingitemcode);
	  $('#routingid').val(routingid);
	  $('#itemcode').val(itemcode);

	  var checkname1 = record.data.CHECKNAME1;
	  var checkname2 = record.data.CHECKNAME2;
	  var checkname3 = record.data.CHECKNAME3;
	  var checkname4 = record.data.CHECKNAME4;

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ITEMCODE: routingitemcode,
	    GUBUN: 'ROUTINGNAME',
	    SEARCHGUBUN: 'TOOLCHANGE',
	    SEARCHTO: $('#searchTo').val(),
	  };

	  extGridSearch(sparams, gridnms["store.11"]);

	  var sparams1 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ROUTINGID: routingid,
	    GUBUN: 'ITEMNAME',
	  };

	  extGridSearch(sparams1, gridnms["store.12"]);

	  var sparams2 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ROUTINGID: routingid,
	    ITEMCODE: routingitemcode,
	    GUBUN: 'MANAGE',
	  };

	  extGridSearch(sparams2, gridnms["store.2"]);

	  setTimeout(function () {
	    if (workcentercode != "") {

	      var sparams3 = {
	        ORGID: orgid,
	        COMPANYID: companyid,
	        WORKCENTERCODE: workcentercode,
	        INSPECTORTYPE: '20',
	      };

	      extGridSearch(sparams3, gridnms["store.3"]);

	    }
	  }, 200);

	  // 클릭시 검사명에 따라 LOV 값 표시 변경
	  fn_lov_chk_change(checkname1, gridnms["store.5"]);
	  fn_lov_chk_change(checkname2, gridnms["store.6"]);
	  fn_lov_chk_change(checkname3, gridnms["store.7"]);
	  fn_lov_chk_change(checkname4, gridnms["store.8"]);

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

	var gridarea;
	function setExtGrid() {
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

	  Ext.define(gridnms["model.11"], {
	    extend: Ext.data.Model,
	    fields: fields["model.11"],
	  });

	  Ext.define(gridnms["model.12"], {
	    extend: Ext.data.Model,
	    fields: fields["model.12"],
	  });

	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.1"],
	            model: gridnms["model.1"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SEARCHFROM: $('#searchFrom').val(),
	                SEARCHTO: $('#searchTo').val(),
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
	              url: "<c:url value='/searchEquipmentLov.do' />",
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
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
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                //                     WORKCENTERCODE: '${EQUIPMENTCODE}',
	                //                  INSPECTORTYPE: '20',
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
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'CHANGE_TYPE',
	                WORKSTATUS: 'CHANGE_TYPE',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

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
	              //                  url: "<c:url value='/searchItemNameLov.do' />",
	              url: "<c:url value='/searchItemCodeOrderLov.do' />",
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                GROUPCODE: $('#searchGroupCode1').val(),
	                GUBUN: 'ITEMNAME',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.11"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.11"],
	            model: gridnms["model.11"],
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: "ajax",
	              url: "<c:url value='/searchRoutingItemLov.do' />",
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.12"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.12"],
	            model: gridnms["model.12"],
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: "ajax",
	              url: "<c:url value='/searchToolChangeNameListLov.do' />",
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ToolChangeManage: '#ToolChangeManage',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    btnRef1: btnRef1,
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
	        height: 643,//510,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'ToolChangeManage',
	          trackOver: true,
	          loadMask: true,
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var editDisableCols = [];

	                var changeseq = data.data.CHANGESEQ;
	                if (changeseq != "") {
	                  editDisableCols.push("ROUTINGITEMNAME");
	                  editDisableCols.push("ROUTINGNAME");
	                  editDisableCols.push("ITEMNAME");
	                  editDisableCols.push("WORKCENTERNAME");
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
	                c.cascade(function (field) {
	                  var xtypeChains = field.xtypesChain;

	                  var isField = Ext.Array.findBy(xtypeChains, function (item) {

	                      if (item == 'displayfield') {
	                        return false;
	                      }

	                      if (item == 'field') {
	                        return true;
	                      }
	                    });
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

	                    if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) {
	                      this.nextField.focus();
	                      e.stopEvent();
	                    } else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
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
	    models: gridnms["models.manage"],
	    stores: gridnms["stores.manage"],
	    views: gridnms["views.manage"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.manage"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
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

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchprodcode = $('#searchProdCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
	  var searchitemcode = $('#searchItemCode').val();
	  var header = [],
	  count = 0;

	  if (isNaN(orgid)) {
	    header.push("사업장");
	    count++;
	  }

	  if (isNaN(companyid)) {
	    header.push("공장");
	    count++;
	  }

	  if (searchfrom == "") {
	    header.push("일자 From");
	    count++;
	  }

	  if (searchto == "") {
	    header.push("일자 To");
	    count++;
	  }

	  //    if (searchprodcode == "") {
	  //      header.push("품명");
	  //      count++;
	  //    }

	  //    if (searchroutingid == "") {
	  //      header.push("공정명");
	  //      count++;
	  //    }

	  //    if (searchitemcode == "") {
	  //      header.push("공구명");
	  //      count++;
	  //    }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchprodcode = $('#searchProdCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
	  var searchitemcode = $('#searchItemCode').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHFROM: searchfrom,
	    SEARCHTO: searchto,
	    ROUTINGITEMCODE: searchprodcode,
	    ROUTINGID: searchroutingid,
	    ITEMCODE: searchitemcode,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  $('#orgid').val(orgid);
	  $('#companyid').val(companyid);
	  $('#routingitemcode').val((searchprodcode == "") ? "" : searchprodcode);
	  $('#routingid').val((searchroutingid == "") ? "" : searchroutingid);
	  $('#itemcode').val((searchitemcode == "") ? "" : searchitemcode);
	}

	function fn_print() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#orgid').val();
	  var companyid = $('#companyid').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchprodcode = $('#routingitemcode').val();
	  var searchroutingid = $('#routingid').val();
	  var searchitemcode = $('#itemcode').val();
	  var header = [],
	  count = 0;

	  if (searchprodcode == "") {
	    header.push("품명");
	    count++;
	  }

	  if (searchroutingid == "") {
	    header.push("공정명");
	    count++;
	  }

	  if (searchitemcode == "") {
	    header.push("공구명");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return false;
	  }

	  var column = 'master';
	  var url = "<c:url value='/report/ToolChangeReport.pdf'/>";
	  var target = '_blank';

	  fn_popup_url(column, url, target);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setReadOnly() {
	  $("[readonly]").addClass("ui-state-disabled");
	}

	function setLovList() {
	  // 품명 Lov
	  $("#searchProdName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchProdName").val("");
	      $("#searchProdCode").val("");

	      var routingid = $('#searchRoutingId').val();

	      if (routingid != "") {
	        $("#searchRoutingId").val("");
	        $("#searchRoutingName").val("");
	      }

	      var itemcode = $('#searchItemCode').val();

	      if (itemcode != "") {
	        $("#searchItemCode").val("");
	        $("#searchItemName").val("");
	        $("#searchItemStandard").val("");
	        $("#searchToolLife").val("");
	      }

	      $('#routingitemcode').val("");
	      $('#routingid').val("");
	      $('#itemcode').val("");

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchItemCodeOrderLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode1').val(),
	        GUBUN: 'ITEMNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.ITEMCODE,
	              label: m.MODELNAME + ', ' + m.ITEMNAME + ", " + m.ORDERNAME,
	              ITEMNAME: m.ITEMNAME,
	              ORDERNAME: m.ORDERNAME,
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
	      $("#searchProdCode").val(o.item.value);
	      $("#searchProdName").val(o.item.ITEMNAME);

	      $('#routingitemcode').val(o.item.value);
	      var routingid = $('#searchRoutingId').val();

	      if (routingid != "") {
	        $("#searchRoutingId").val("");
	        $("#searchRoutingName").val("");
	        $('#routingid').val("");
	      }

	      var itemcode = $('#searchItemCode').val();

	      if (itemcode != "") {
	        $("#searchItemCode").val("");
	        $("#searchItemName").val("");
	        $("#searchItemStandard").val("");
	        $("#searchToolLife").val("");
	        $('#itemcode').val("");
	      }

	      return false;
	    }
	  });

	  // 공정명 Lov
	  $("#searchRoutingName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchRoutingName").val("");
	      $("#searchRoutingId").val("");

	      var itemcode = $('#searchItemCode').val();

	      if (itemcode != "") {
	        $("#searchItemCode").val("");
	        $("#searchItemName").val("");
	        $("#searchItemStandard").val("");
	        $("#searchToolLife").val("");
	      }

	      $('#routingid').val("");
	      $('#itemcode').val("");

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchRoutingItemLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        ITEMCODE: $('#searchProdCode').val(),
	        GUBUN: 'ROUTINGNAME',
	        SEARCHGUBUN: 'TOOLCHANGE',
	        SEARCHTO: $('#searchTo').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.ROUTINGCODE,
	              label: m.ROUTINGOP + ", " + m.ROUTINGNAME,
	              ROUTINGNAME: m.ROUTINGNAME,
	              ROUTINGOP: m.ROUTINGOP,
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
	      $("#searchRoutingId").val(o.item.value);
	      $("#searchRoutingName").val(o.item.ROUTINGNAME);

	      $('#routingid').val(o.item.value);
	      var itemcode = $('#searchItemCode').val();

	      if (itemcode != "") {
	        $("#searchItemCode").val("");
	        $("#searchItemName").val("");
	        $("#searchItemStandard").val("");
	        $("#searchToolLife").val("");
	        $('#itemcode').val("");
	      }

	      return false;
	    }
	  });

	  // 공구명 Lov
	  $("#searchItemName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchItemName").val("");
	      $("#searchItemCode").val("");
	      $("#searchItemStandard").val("");
	      $("#searchToolLife").val("");

	      $('#itemcode').val("");

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchToolChangeNameListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        ROUTINGID: $('#searchRoutingId').val(),
	        GUBUN: 'ITEMNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.ITEMCODE,
	              label: m.ITEMNAME + ", " + m.ITEMSTANDARD + ", " + m.TOOLLIFE,
	              ITEMNAME: m.ITEMNAME,
	              ITEMSTANDARD: m.ITEMSTANDARD,
	              TOOLLIFE: m.TOOLLIFE,
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
	      $("#searchItemCode").val(o.item.value);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchItemStandard").val(o.item.ITEMSTANDARD);
	      $("#searchToolLife").val(o.item.TOOLLIFE);
	      $('#itemcode').val(o.item.value);

	      return false;
	    }
	  });
	}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;">
  <!-- 전체 레이어 시작 -->
    <div id="wrap">
        <!-- header 시작 -->
        <div id="header">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
        </div>
        <div id="topnavi">
            <c:import url="/sym/mms/EgovMainMenuHead.do" />
        </div>
        <!-- //header 끝 -->
        <!-- container 시작 -->
        <div id="container">
            <!-- 좌측메뉴 시작 -->
            <div id="leftmenu">
                <c:import url="/sym/mms/EgovMainMenuLeft.do" />
            </div>
            <!-- //좌측메뉴 끝 -->
            <!-- 현재위치 네비게이션 시작 -->
            <div id="content">
                    <div id="cur_loc">
                        <div id="cur_loc_align">
                            <ul>
                                <li>HOME</li>
                                <li>&gt;</li>
                                <li>공구관리</li>
                                <li>&gt;</li>
                                <li><strong>${pageTitle}</strong></li>
                            </ul>
                        </div>
                    </div>
                    <!-- 검색 필드 박스 시작 -->
                    <div id="search_field">
                        <div id="search_field_loc">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                        <input type="hidden" id="searchGroupCode1" name="searchGroupCode1" value="A" />
                        <input type="hidden" id="searchGroupCode2" name="searchGroupCode2" value="T" />
                        <input type="hidden" id="orgid" name="orgid" />
                        <input type="hidden" id="companyid" name="companyid" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                        <input type="hidden" id="searchProdCode" name="searchProdCode" />
                        <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
                        <input type="hidden" id="routingitemcode" name="routingitemcode" />
                        <input type="hidden" id="routingid" name="routingid" />
                        <input type="hidden" id="itemcode" name="itemcode" />
                            <div>
                                <table class="tbl_type_view" border="0">
                                    <colgroup>
                                        <col width="23%">
                                        <col width="23%">
                                        <col width="43%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <td>
                                            <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 50%;">
                                                <c:forEach var="item" items="${labelBox.findByOrgId}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.ORGID}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
                                                <c:forEach var="item" items="${labelBox.findByCompanyId}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.COMPANYID}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td >
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                                   조회
                                                </a>
                                                <!-- <a id="btnChk2" class="btn_print" href="#" onclick="javascript:fn_print();">
                                                   Check Sheet
                                                </a> -->
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td >
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchProdName" name="searchProdName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">공정명</th>
                                        <td >
                                            <input type="text" id="searchRoutingName" name="searchRoutingName" class=" input_center " style="width: 97%; " />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">공구명</th>
                                        <td>
                                            <input type="text" id="searchItemName" name="searchItemName" class=" input_left"  style="width: 97%;" />
                                        </td>         
                                        <th class="required_text">사양</th>
                                        <td >
                                            <input type="text" id="searchItemStandard" name="searchItemStandard" class="input_center"  style="width: 97%;" readonly />
                                        </td>                                        
                                        <th class="required_text">TOOL LIFE</th>
                                        <td >
                                            <input type="text" id="searchToolLife" name="searchToolLife" class="input_center"  style="width: 97%;" readonly />
                                        </td>
                                        <!-- <td></td>
                                        <td></td> -->
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; margin-bottom: 15px; float: left;"></div>
                </div>
<!--                 <div class="subConTit2"> -->
<!--                   공구 상세 내역 -->
<!--                 </div> -->
<!--                 <table class="tbl_type_view" style="width: 98%; margin-left: 0px; margin-top: 0px; padding-top: 0px; padding-bottom: 0px; margin-bottom: 5px; "> -->
<%--                 <colgroup> --%>
<%--                   <col> --%>
<%--                   <col> --%>
<%--                   <col> --%>
<%--                   <col> --%>
<%--                   <col> --%>
<%--                 </colgroup> --%>
<!--                 <tbody> -->
<!--                   <tr style="height: 35px;"> -->
<!--                     <th style="font-size: 15px; border-right-style: solid; border-right-width: 1px; border-right-color: white;"></th> -->
<!--                     <th style="font-size: 15px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목1</th> -->
<!--                     <th style="font-size: 15px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목2</th> -->
<!--                     <th style="font-size: 15px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">검사항목3</th> -->
<!--                     <th style="font-size: 15px;">검사항목4</th> -->
<!--                   </tr> -->
<!--                   <tr style="height: 35px;"> -->
<!--                     <th style="font-size: 15px;">검사명</th> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                         <label id="CheckName1" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                           <span></span> -->
<!--                         </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckName2" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckName3" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckName4" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                   </tr> -->
<!--                   <tr style="height: 35px;"> -->
<!--                     <th style="font-size: 15px;">검사내용</th> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckStandard1" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckStandard2" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckStandard3" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                     <td> -->
<%--                       <center> --%>
<!--                       <label id="CheckStandard4" style="font-size: 15px; color: black; font-weight: bold;" > -->
<!--                         <span></span> -->
<!--                       </label> -->
<%--                       </center> --%>
<!--                     </td> -->
<!--                   </tr> -->
<!--                 </tbody> -->
<!--                 </table> -->
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>