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

<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload-ui.css'/>">

<!-- jQuery-File-Upload-9.9.3 -->
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/load-image.all.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-process.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-image.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/app.js'/>"></script>

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
</style>
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setLovList();

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	    //
	  });
	});

	function setInitial() {
	  gridnms["app"] = "base";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_Item();
	  setValues_detail();
	}

	function setValues_Item() {
	  gridnms["models.item"] = [];
	  gridnms["stores.item"] = [];
	  gridnms["views.item"] = [];
	  gridnms["controllers.item"] = [];

	  gridnms["grid.4"] = "itemMaster";

	  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
	  gridnms["views.item"].push(gridnms["panel.4"]);

	  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
	  gridnms["controllers.item"].push(gridnms["controller.4"]);

	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

	  gridnms["models.item"].push(gridnms["model.4"]);

	  gridnms["stores.item"].push(gridnms["store.4"]);

	  fields["model.4"] = [{
	      type: 'number',
	      name: 'RNUM'
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }, {
	      type: 'string',
	      name: 'GROUPCODE'
	    }, {
	      type: 'string',
	      name: 'BIGCODE',
	    }, {
	      type: 'string',
	      name: 'BIGNAME',
	    }, {
	      type: 'string',
	      name: 'MIDDLECODE'
	    }, {
	      type: 'string',
	      name: 'SMALLCODE'
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME'
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO'
	    }, {
	      type: 'string',
	      name: 'ORDERNAME'
	    }, {
	      type: 'string',
	      name: 'ITEMTYPE'
	    }, {
	      type: 'string',
	      name: 'ITEMTYPENAME'
	    }, {
	      type: 'string',
	      name: 'UOM'
	    }, {
	      type: 'string',
	      name: 'UOMNAME'
	    }, {
	      type: 'string',
	      name: 'MODELNAME'
	    }, {
	      type: 'string',
	      name: 'REMARKS'
	    }, {
	      type: 'string',
	      name: 'USEYN'
	    }, {
	      type: 'date',
	      name: 'EFFECTIVESTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVEENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'INVENTORYMANAGEYN'
	    }, {
	      type: 'string',
	      name: 'LOTYN'
	    }, {
	      type: 'string',
	      name: 'ITEMCHECK'
	    }, {
	      type: 'string',
	      name: 'FIRSTCHECKBIG'
	    }, {
	      type: 'string',
	      name: 'FIRSTROUTINGID'
	    },
	  ];

	  fields["columns.4"] = [
	    // Display Columns
	    {
	      dataIndex: 'RNUM',
	      text: '순번',
	      xtype: 'rownumberer',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'BIGNAME',
	      text: '대분류',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 300,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMTYPENAME',
	      text: '유형',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효시작일자',
	      xtype: 'datecolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      text: '유효종료일자',
	      xtype: 'datecolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'GROUPCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'BIGCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MIDDLECODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SMALLCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCHECK',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FIRSTCHECKBIG',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FIRSTROUTINGID',
	      xtype: 'hidden',
	    }, ];

	  items["api.4"] = {};
	  $.extend(items["api.4"], {
	    read: "<c:url value='/select/checkmaster/CheckMaster.do' />"
	  });

	  items["btns.4"] = [];
	  items["btns.ctr.4"] = {};
	  $.extend(items["btns.ctr.4"], {
	    "#itemGrid": {
	      itemclick: 'onItemClick'
	    }
	  });

	  items["dock.btn.4"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.4"],
	    items: items["btns.4"],
	  };

	  items["docked.4"] = [];
	}

	function onItemClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var itemcode = record.data.ITEMCODE;
	  $('#orgid').val(orgid);
	  $('#companyid').val(companyid);
	  $('#itemcode').val(itemcode);

	  var params1 = {
	    orgid: orgid,
	    companyid: companyid,
	    itemcode: itemcode,
	  };
	  extGridSearch(params1, gridnms["store.10"]);
	};

	function setValues_detail() {
	  gridnms["models.check"] = [];
	  gridnms["stores.check"] = [];
	  gridnms["views.check"] = [];
	  gridnms["controllers.check"] = [];

	  gridnms["grid.10"] = "CheckHistoryManage";
	  gridnms["grid.11"] = "checkbigLov";
	  gridnms["grid.12"] = "routingLov";

	  gridnms["panel.10"] = gridnms["app"] + ".view." + gridnms["grid.10"];
	  gridnms["views.check"].push(gridnms["panel.10"]);

	  gridnms["controller.10"] = gridnms["app"] + ".controller." + gridnms["grid.10"];
	  gridnms["controllers.check"].push(gridnms["controller.10"]);

	  gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
	  gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

	  gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
	  gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

	  gridnms["models.check"].push(gridnms["model.10"]);
	  gridnms["models.check"].push(gridnms["model.11"]);
	  gridnms["models.check"].push(gridnms["model.12"]);

	  gridnms["stores.check"].push(gridnms["store.10"]);
	  gridnms["stores.check"].push(gridnms["store.11"]);
	  gridnms["stores.check"].push(gridnms["store.12"]);

	  fields["model.10"] = [{
	      type: 'number',
	      name: 'RNUM',
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'number',
	      name: 'HISTORYID',
	    }, {
	      type: 'string',
	      name: 'CHECKBIG',
	    }, {
	      type: 'string',
	      name: 'CHECKBIGNAME',
	    }, {
	      type: 'number',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'MARK',
	    }, {
	      type: 'string',
	      name: 'CHANGEDISCRIPTION',
	    }, {
	      type: 'string',
	      name: 'CHANGEPERSON',
	    }, {
	      type: 'string',
	      name: 'APPROVALPERSON',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVESTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVEENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["model.11"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.12"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["columns.10"] = [
	    // Display Columns
	    {
	      dataIndex: 'RNUM',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'CHECKBIGNAME',
	      text: '검사구분',
	      xtype: 'gridcolumn',
	      width: 135, // 100,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.11"],
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
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

	            model.set("CHECKBIG", record.data.VALUE);

	            var item = record.data.LABEL;

	            if (item == "") {
	              model.set("CHECKBIG", "");

	            } else {
	              model.set("ROUTINGID", "");
	              model.set("ROUTINGNAME", "");

	              var params1 = {
	                ORGID: record.data.ORGID,
	                COMPANYID: record.data.COMPANYID,
	                ITEMCODE: record.data.ITEMCODE,
	              };

	              extGridSearch(params1, gridnms["store.12"]);

	            }
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                model.set("CHECKBIG", "");
	                model.set("ROUTINGID", "");
	                model.set("ROUTINGNAME", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 330,
	          getInnerTpl: function () {
	            return '<div>'
	             + '<table>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
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
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 185,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.12"],
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
	            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

	            model.set("ROUTINGID", record.data.ROUTINGCODE);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                model.set("ROUTINGID", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 330,
	          getInnerTpl: function () {
	            return '<div>'
	             + '<table>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px;">{ROUTINGNAME}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
	          }
	        },
	      },
	    }, {
	      dataIndex: 'MARK',
	      text: '부호',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: "0,000",
	      editor: {
	        xtype: "textfield",
	        format: "0,000",
	        enforceMaxLength: true,
	        allowBlank: true,
	        maxLength: '7',
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	      },
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '변경일자',
	      xtype: 'datecolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	      editor: {
	        xtype: 'datefield',
	        enforceMaxLength: true,
	        maxLength: 10,
	        allowBlank: true,
	        format: 'Y-m-d',
	        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'CHANGEDISCRIPTION',
	      text: '변경내용',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'CHANGEPERSON',
	      text: '담당',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'APPROVALPERSON',
	      text: '승인',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'HISTORYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKBIG',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'REMARKS',
	      xtype: 'hidden',
	    }, ];

	  items["api.10"] = {};
	  $.extend(items["api.10"], {
	    create: "<c:url value='/insert/checkhistory/CheckHistoryManage.do' />"
	  });
	  $.extend(items["api.10"], {
	    read: "<c:url value='/select/checkhistory/CheckHistoryManage.do' />"
	  });
	  $.extend(items["api.10"], {
	    update: "<c:url value='/update/checkhistory/CheckHistoryManage.do' />"
	  });
	  $.extend(items["api.10"], {
	    destroy: "<c:url value='/delete/checkhistory/CheckHistoryManage.do' />"
	  });

	  items["btns.10"] = [];
	  items["btns.10"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd10"
	  });
	  items["btns.10"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel10"
	  });
	  items["btns.10"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav10"
	  });
	  items["btns.10"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef10"
	  });

	  items["btns.ctr.10"] = {};
	  $.extend(items["btns.ctr.10"], {
	    "#btnAdd10": {
	      click: 'btnAdd10'
	    }
	  });
	  $.extend(items["btns.ctr.10"], {
	    "#btnDel10": {
	      click: 'btnDel10'
	    }
	  });
	  $.extend(items["btns.ctr.10"], {
	    "#btnSav10": {
	      click: 'btnSav10'
	    }
	  });
	  $.extend(items["btns.ctr.10"], {
	    "#btnRef10": {
	      click: 'btnRef10'
	    }
	  });
	  $.extend(items["btns.ctr.10"], {
	    "#DetailGrid": {
	      itemclick: 'onDetailClick'
	    }
	  });

	  items["dock.btn.10"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.10"],
	    items: items["btns.10"],
	  };

	  items["docked.10"] = [];
	  items["docked.10"].push(items["dock.btn.10"]);
	}

	function btnAdd10(o, e) {
	  var orgid = $('#orgid').val();
	  var companyid = $('#companyid').val();
	  var itemcode = $('#itemcode').val();
	  if (itemcode == "") {
	    extAlert("품명을 먼저 선택하여 주십시오.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  var model = Ext.create(gridnms["model.10"]);
	  var store = this.getStore(gridnms["store.10"]);

	  //      var sortorder = Ext.getStore(gridnms["store.10"]).count() + 1;
	  var sortorder = 0;
	  var listcount = Ext.getStore(gridnms["store.10"]).count();
	  for (var i = 0; i < listcount; i++) {
	    Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).getSelectionModel().select(i));
	    var dummy = Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0];

	    var dummy_sort = dummy.data.RNUM * 1;
	    if (sortorder < dummy_sort) {
	      sortorder = dummy_sort;
	    }
	  }
	  sortorder++;

	  model.set("RNUM", sortorder);

	  model.set("ORGID", orgid);
	  model.set("COMPANYID", companyid);
	  model.set("ITEMCODE", itemcode);
	  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
	  model.set("EFFECTIVEENDDATE", "4999-12-31");

	  //   store.insert(Ext.getStore(gridnms["store.10"]).count() + 1, model);
	  var view = Ext.getCmp(gridnms['panel.10']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.10"], gridnms["views.check"], startPoint, 1);
	};

	function btnSav10(o, e) {
	  var count1 = Ext.getStore(gridnms["store.10"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).getSelectionModel().select(i));
	      var model10 = Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0];

	      var checkbig = model10.data.CHECKBIG;
	      var startdate = model10.data.EFFECTIVESTARTDATE;

	      if (checkbig == "" || checkbig == undefined) {
	        header.push("검사구분");
	        count++;
	      }

	      if (startdate == "" || startdate == undefined) {
	        header.push("변경일자");
	        count++;
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    }
	  } else {
	    extAlert("[저장] 저장 할 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  // 저장
	  if (count == 0) {
	    Ext.getStore(gridnms["store.10"]).sync({
	      success: function (batch, options) {
	        var reader = batch.proxy.getReader();

	        msg = reader.rawData.msg;
	        extAlert(msg);

	        Ext.getStore(gridnms["store.10"]).load();
	      },
	      failure: function (batch, options) {
	        msg = batch.operations[0].error;
	        extAlert(msg);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel10(o, e) {
	  extGridDel(gridnms["store.10"], gridnms["views.check"]);
	};

	function btnRef10(o, e) {
	  Ext.getStore(gridnms["store.10"]).load();
	};

	var gridarea1, gridarea2;
	function setExtGrid() {
	  setExtGrid_Item();
	  setExtGrid_detail();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea1.updateLayout();
	    gridarea2.updateLayout();
	  });
	}

	function onDetailClick(dataview, record, item, index, e, eOpts) {

	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var itemcode = record.data.ITEMCODE;
	  $('#orgid').val(orgid);
	  $('#companyid').val(companyid);
	  $('#itemcode').val(itemcode);

	  var params1 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	  };
	  extGridSearch(params1, gridnms["store.11"]);

	  var params2 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ITEMCODE: itemcode,
	  };
	  extGridSearch(params2, gridnms["store.12"]);
	};

	function setExtGrid_Item() {
	  Ext.define(gridnms["model.4"], {
	    extend: Ext.data.Model,
	    fields: fields["model.4"]
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
	              type: 'ajax',
	              api: items["api.4"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	                ITEMTYPE: 'A',
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            },
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.4"], {
	    extend: Ext.app.Controller,
	    refs: {
	      itemGrid: '#itemGrid',
	    },
	    stores: [gridnms["store.4"]],
	    control: items["btns.ctr.4"],

	    onItemClick: onItemClick,
	  });

	  Ext.define(gridnms["panel.4"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.4"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        mode: 'SINGLE',
	        ignoreRightMouseSelection: false,
	        allowDeselect: false,
	        toggleOnClick: false,
	        itemId: gridnms["panel.4"],
	        id: gridnms["panel.4"],
	        store: gridnms["store.4"],
	        height: 431,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.4"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'itemGrid',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('DRAWINGNO') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }
	                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 120) {
	                    column.width = 120;
	                  }
	                }
	              });
	            }
	          },
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	          }, {
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: true,
	            numFromEdge: 19,
	          }
	        ],
	        dockedItems: items["docked.4"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.item"],
	    stores: gridnms["stores.item"],
	    views: gridnms["panel.4"],
	    controllers: gridnms["controller.4"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["panel.4"], {
	          renderTo: 'gridArea1'
	        });
	    },
	  });

	}

	function setExtGrid_detail() {
	  Ext.define(gridnms["model.10"], {
	    extend: Ext.data.Model,
	    fields: fields["model.10"]
	  });

	  Ext.define(gridnms["model.11"], {
	    extend: Ext.data.Model,
	    fields: fields["model.11"],
	  });

	  Ext.define(gridnms["model.12"], {
	    extend: Ext.data.Model,
	    fields: fields["model.12"],
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
	              type: 'ajax',
	              api: items["api.10"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            },
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
	              url: "<c:url value='/searchCheckBigCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                HISTORYCHECK: 'Y',
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

	  Ext.define(gridnms["controller.10"], {
	    extend: Ext.app.Controller,
	    refs: {
	      DetailGrid: '#DetailGrid',
	    },
	    stores: [gridnms["store.10"]],
	    control: items["btns.ctr.10"],

	    btnAdd10: btnAdd10,
	    btnSav10: btnSav10,
	    btnDel10: btnDel10,
	    btnRef10: btnRef10,
	    onDetailClick: onDetailClick

	  });

	  Ext.define(gridnms["panel.10"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.10"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.10"],
	        id: gridnms["panel.10"],
	        store: gridnms["store.10"],
	        height: 200,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.10"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'DetailGrid',
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var editDisableCols = [];

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
	        dockedItems: items["docked.10"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.check"],
	    stores: gridnms["stores.check"],
	    views: gridnms["panel.10"],
	    controllers: gridnms["controller.10"],

	    launch: function () {
	      gridarea2 = Ext.create(gridnms["views.check"], {
	          renderTo: 'gridArea2'
	        });
	    },
	  });
	}

	function fn_search() {
	  var orgid = $("#searchOrgId option:selected").val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var itemcode = $("#searchItemCode").val();
	  var itemname = $("#searchItemName").val();
	  var ordername = $("#searchOrderName").val();
	  var itemtype = $("#searchItemType").val();
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

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    orgid: orgid,
	    companyid: companyid,
	    itemcode: itemcode,
	    itemname: itemname,
	    ordername: ordername,
	    HISTORYCHK: $('#searchItemCheck option:selected').val(),
	    ITEMTYPE: itemtype,
	  };

	  extGridSearch(sparams, gridnms["store.4"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.10"]);
	  }, 200);
	}

	function setLovList() {
	  //
	}

	function setReadOnly() {
	  $("[readonly]").addClass("ui-state-disabled");
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
                            <li>기준정보</li>
                            <li>&gt;</li>
                            <li><strong>${pageTitle}</strong></li>
                        </ul>
                    </div>
                </div>
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field" style="margin-bottom: 0px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <input type="hidden" id="orgid" name="orgid" />
                    <input type="hidden" id="companyid" name="companyid" />
                    <input type="hidden" id="itemcode" name="itemcode" />
                    <input type="hidden" id="routingid" name="routingid" />
                    <input type="hidden" id="searchItemType" name="searchItemType" value="A"/>
                    <input type="hidden" id="searchItemCode" name="searchItemCode" />
                    <fieldset>
                        <legend>조건정보 영역</legend>
                        <div>
                            <table class="tbl_type_view" border="1">
                                <colgroup>
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col>
                                </colgroup>
                                <tr>
                                    <th class="required_text">사업장</th>
                                    <td>
                                    <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 97%;">
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
                                    <th class="required_text">공장</th>
                                    <td>
                                    <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 97%;">
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
                                    <th class="required_text">등록여부</th>
                                    <td>
                                    <select id="searchItemCheck" name="searchItemCheck" class="input_left validate[required]" style="width: 97%;">
                                        <c:if test="${empty searchVO.STATUS}">
                                            <option value="">전체</option>
                                            <option value="Y">변경이력 등록</option>
                                            <option value="N">변경이력 미등록</option>
                                        </c:if>
                                    </select>
                                    </td>
                                    <td>
                                        <div class="buttons" style="float: right; margin-top: 3px;">
                                            <div class="buttons" style="float: right;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">품번</th>
                                    <td>
                                    <input type="text" id="searchOrderName" name="searchOrderName" class="input_left" style="width: 97%;" /></td>
                                    <th class="required_text">품명</th>
                                    <td>
                                    <input type="text" id="searchItemName" name="searchItemName" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">품목마스터</div></td>
                        </tr>
                    </table>
                    <div id="gridArea1" style="width: 100%; padding-bottom: 0px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;">
				                        <div class="subConTit3" style="margin-top: 15px; float: left;">변경이력관리</div>
				                    </td>
                        </tr>
                    </table>
                    <div id="gridArea2" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
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