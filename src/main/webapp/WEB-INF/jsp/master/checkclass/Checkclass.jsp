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
  max-height: 400px;
  overflow-y: auto;
  /* prevent horizontal scrollbar */
  overflow-x: hidden;
}

* html .ui-autocomplete {
  /* IE 6.0 */
  height: 400px;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  //대분류용
	  gridnms["models.checkbigclass"] = [];
	  gridnms["stores.checkbigclass"] = [];
	  gridnms["views.checkbigclass"] = [];
	  gridnms["controllers.checkbigclass"] = [];

	  // 중분류용
	  gridnms["models.checkmiddleclass"] = [];
	  gridnms["stores.checkmiddleclass"] = [];
	  gridnms["views.checkmiddleclass"] = [];
	  gridnms["controllers.checkmiddleclass"] = [];

	  // 소분류용
	  gridnms["models.checksmallclass"] = [];
	  gridnms["stores.checksmallclass"] = [];
	  gridnms["views.checksmallclass"] = [];
	  gridnms["controllers.checksmallclass"] = [];

	  gridnms["app"] = "base";
	  gridnms["grid.1"] = "CheckBigclass";
	  gridnms["grid.2"] = "CheckMiddleclass";
	  gridnms["grid.3"] = "CheckSmallclass";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.checkbigclass"].push(gridnms["panel.1"]);

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.checkmiddleclass"].push(gridnms["panel.2"]);

	  gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
	  gridnms["views.checksmallclass"].push(gridnms["panel.3"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.checkbigclass"].push(gridnms["controller.1"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.checkmiddleclass"].push(gridnms["controller.2"]);

	  gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
	  gridnms["controllers.checksmallclass"].push(gridnms["controller.3"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
	  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
	  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	  gridnms["models.checkbigclass"].push(gridnms["model.1"]);
	  gridnms["models.checkmiddleclass"].push(gridnms["model.2"]);
	  gridnms["models.checksmallclass"].push(gridnms["model.3"]);

	  gridnms["stores.checkbigclass"].push(gridnms["store.1"]);
	  gridnms["stores.checkmiddleclass"].push(gridnms["store.2"]);
	  gridnms["stores.checksmallclass"].push(gridnms["store.3"]);

	  fields["model.1"] = [{
	      type: 'number',
	      name: 'RNUM'
	    }, {
	      type: 'string',
	      name: 'BIGCD'
	    }, {
	      type: 'string',
	      name: 'BIGCDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES'
	    }, {
	      type: 'string',
	      name: 'USEYN'
	    }, {
	      type: 'string',
	      name: 'CRBY',
	    }, {
	      type: 'date',
	      name: 'CRDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'string',
	      name: 'LUBY'
	    }, {
	      type: 'date',
	      name: 'LUDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }
	  ];

	  fields["model.2"] = [{
	      type: 'number',
	      name: 'RNUM'
	    }, {
	      type: 'string',
	      name: 'BIGCD'
	    }, {
	      type: 'string',
	      name: 'MIDDLECD'
	    }, {
	      type: 'string',
	      name: 'MIDDLECDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES'
	    }, {
	      type: 'string',
	      name: 'USEYN'
	    }, {
	      type: 'string',
	      name: 'CRBY',
	    }, {
	      type: 'date',
	      name: 'CRDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'string',
	      name: 'LUBY'
	    }, {
	      type: 'date',
	      name: 'LUDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }
	  ];

	  fields["model.3"] = [{
	      type: 'number',
	      name: 'RNUM'
	    }, {
	      type: 'string',
	      name: 'BIGCD'
	    }, {
	      type: 'string',
	      name: 'MIDDLECD'
	    }, {
	      type: 'string',
	      name: 'SMALLCD'
	    }, {
	      type: 'string',
	      name: 'SMALLCDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES'
	    }, {
	      type: 'string',
	      name: 'USEYN'
	    }, {
	      type: 'string',
	      name: 'CRBY',
	    }, {
	      type: 'date',
	      name: 'CRDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'string',
	      name: 'LUBY'
	    }, {
	      type: 'date',
	      name: 'LUDATE',
	      dateFormat: 'Y-m-d'
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }
	  ];

	  fields["columns.1"] = [{
	      dataIndex: 'RNUM',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'BIGCD',
	      text: '대분류코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'BIGCDNM',
	      text: '대분류명',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'NOTES',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'USEYN',
	      text: '사용<br>여부',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combo',
	        store: ['Y', 'N'],
	        editable: false,
	      }
	    }, {
	      dataIndex: 'CRBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CRDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }
	  ];

	  fields["columns.2"] = [{
	      dataIndex: 'RNUM',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'MIDDLECD',
	      text: '중분류코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'MIDDLECDNM',
	      text: '중분류명',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'NOTES',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'USEYN',
	      text: '사용<br>여부',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combo',
	        store: ['Y', 'N'],
	        editable: false,
	      }
	    }, {
	      dataIndex: 'CRBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CRDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'BIGCD',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }
	  ];

	  fields["columns.3"] = [{
	      dataIndex: 'RNUM',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SMALLCD',
	      text: '소분류코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'SMALLCDNM',
	      text: '소분류명',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'NOTES',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      }
	    }, {
	      dataIndex: 'USEYN',
	      text: '사용<br>여부',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combo',
	        store: ['Y', 'N'],
	        editable: false,
	      }
	    }, {
	      dataIndex: 'CRBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CRDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUBY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LUDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'BIGCD',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MIDDLECD',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/checkclass/Checkbigclass.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/checkclass/Checkbigclass.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/checkclass/Checkbigclass.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/checkclass/Checkbigclass.do' />"
	  });

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    create: "<c:url value='/insert/checkclass/Checkmiddleclass.do' />"
	  });
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/checkclass/Checkmiddleclass.do' />"
	  });
	  $.extend(items["api.2"], {
	    update: "<c:url value='/update/checkclass/Checkmiddleclass.do' />"
	  });
	  $.extend(items["api.2"], {
	    destroy: "<c:url value='/delete/checkclass/Checkmiddleclass.do' />"
	  });

	  items["api.3"] = {};
	  $.extend(items["api.3"], {
	    create: "<c:url value='/insert/checkclass/Checksmallclass.do' />"
	  });
	  $.extend(items["api.3"], {
	    read: "<c:url value='/select/checkclass/Checksmallclass.do' />"
	  });
	  $.extend(items["api.3"], {
	    update: "<c:url value='/update/checkclass/Checksmallclass.do' />"
	  });
	  $.extend(items["api.3"], {
	    destroy: "<c:url value='/delete/checkclass/Checksmallclass.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1"
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

	  items["btns.2"] = [];
	  items["btns.2"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef2"
	  });

	  items["btns.3"] = [];
	  items["btns.3"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd3"
	  });
	  items["btns.3"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel3"
	  });
	  items["btns.3"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav3"
	  });
	  items["btns.3"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef3"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnAdd1": {
	      click: 'btnAdd1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#BigclassListGrid": {
	      itemclick: 'onMyviewBigclasslistClick'
	    }
	  });

	  items["btns.ctr.2"] = {};
	  $.extend(items["btns.ctr.2"], {
	    "#btnAdd2": {
	      click: 'btnAdd2Click'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnDel2": {
	      click: 'btnDel2Click'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnSav2": {
	      click: 'btnSav2Click'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnRef2": {
	      click: 'btnRef2Click'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#MiddleclassListGrid": {
	      itemclick: 'onMyviewMiddleclasslistClick'
	    }
	  });

	  items["btns.ctr.3"] = {};
	  $.extend(items["btns.ctr.3"], {
	    "#btnAdd3": {
	      click: 'btnAdd3Click'
	    }
	  });
	  $.extend(items["btns.ctr.3"], {
	    "#btnDel3": {
	      click: 'btnDel3Click'
	    }
	  });
	  $.extend(items["btns.ctr.3"], {
	    "#btnSav3": {
	      click: 'btnSav3Click'
	    }
	  });
	  $.extend(items["btns.ctr.3"], {
	    "#btnRef3": {
	      click: 'btnRef3Click'
	    }
	  });

	  items["dock.paging.1"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.1"],
	  };

	  items["dock.paging.2"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.2"],
	  };

	  items["dock.paging.3"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.3"],
	  };

	  items["dock.btn.1"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.1"],
	    items: items["btns.1"],
	  };

	  items["dock.btn.2"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.2"],
	    items: items["btns.2"],
	  };

	  items["dock.btn.3"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.3"],
	    items: items["btns.3"],
	  };

	  items["docked.1"] = [];
	  items["docked.1"].push(items["dock.btn.1"]);
	  //     items["docked.1"].push(items["dock.paging.1"]);

	  items["docked.2"] = [];
	  items["docked.2"].push(items["dock.btn.2"]);
	  //     items["docked.2"].push(items["dock.paging.2"]);

	  items["docked.3"] = [];
	  items["docked.3"].push(items["dock.btn.3"]);
	  //     items["docked.3"].push(items["dock.paging.3"]);
	}

	function onMyviewBigclasslistClick(dataview, record, item, index, e, eOpts) {
	  $("#OrgidVal").val(record.get("ORGID"));
	  $("#CompanyidVal").val(record.get("COMPANYID"));
	  $("#BigcdVal").val(record.get("BIGCD"));
	  $("#MiddlecdVal").val("");
	  var OrgidVal = $('#OrgidVal').val();
	  var CompanyidVal = $('#CompanyidVal').val();
	  var BigcdVal = $('#BigcdVal').val();
	  var MiddlecdVal = $('#MiddlecdVal').val();
	  Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('bigcd', BigcdVal);
	  Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('orgid', OrgidVal);
	  Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('companyid', CompanyidVal);
	  Ext.getStore(gridnms["store.2"]).load();

	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('bigcd', BigcdVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('middlecd', MiddlecdVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('orgid', OrgidVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('companyid', CompanyidVal);

	  setTimeout(function () {
	    Ext.getStore(gridnms["store.3"]).load();
	  }, 400)
	};

	function onMyviewMiddleclasslistClick(dataview, record, item, index, e, eOpts) {
	  $("#OrgidVal").val(record.get("ORGID"));
	  $("#CompanyidVal").val(record.get("COMPANYID"));
	  $("#BigcdVal").val(record.get("BIGCD"));
	  $("#MiddlecdVal").val(record.get("MIDDLECD"));
	  var OrgidVal = $('#OrgidVal').val();
	  var CompanyidVal = $('#CompanyidVal').val();
	  var BigcdVal = $('#BigcdVal').val();
	  var MiddlecdVal = $('#MiddlecdVal').val();
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('orgid', OrgidVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('companyid', CompanyidVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('bigcd', BigcdVal);
	  Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('middlecd', MiddlecdVal);
	  Ext.getStore(gridnms["store.3"]).load();
	};

	var bigLayout;
	var middleLayout;
	var smallLayout;

	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });
	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"]
	  });
	  Ext.define(gridnms["model.3"], {
	    extend: Ext.data.Model,
	    fields: fields["model.3"]
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.2"],
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	                bigcd: $("#BigcdVal").val(),
	                middlecd: $("#MiddlecdVal").val()
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.3"],
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	                bigcd: $("#BigcdVal").val(),
	                middlecd: $("#MiddlecdVal").val()
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      BigclassListGrid: '#BigclassListGrid',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnAdd1Click: btnAdd1Click,
	    btnSav1Click: btnSav1Click,
	    btnDel1Click: btnDel1Click,
	    btnRef1Click: btnRef1Click,
	    onMyviewBigclasslistClick: onMyviewBigclasslistClick,
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      MiddleclassListGrid: '#MiddleclassListGrid',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

	    btnAdd2Click: btnAdd2Click,
	    btnSav2Click: btnSav2Click,
	    btnDel2Click: btnDel2Click,
	    btnRef2Click: btnRef2Click,
	    onMyviewMiddleclasslistClick: onMyviewMiddleclasslistClick
	  });

	  Ext.define(gridnms["controller.3"], {
	    extend: Ext.app.Controller,
	    refs: {
	      SmallclassListGrid: '#SmallclassListGrid',
	    },
	    stores: [gridnms["store.3"]],
	    control: items["btns.ctr.3"],

	    btnAdd3Click: btnAdd3Click,
	    btnSav3Click: btnSav3Click,
	    btnDel3Click: btnDel3Click,
	    btnRef3Click: btnRef3Click,
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
	        height: 701,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'BigclassListGrid',
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('BIG') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
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

	                var editDisableCols = ["BIGCD"];
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
	        dockedItems: items["docked.1"],
	      }
	    ],
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
	        height: 701,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'MiddleclassListGrid',
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('MIDDLE') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
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

	                var editDisableCols = ["MIDDLECD"];
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
	        height: 701,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.3"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'SmallclassListGrid',
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('SMALL') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
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

	                var editDisableCols = ["SMALLCD"];
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
	    models: gridnms["models.checkbigclass"],
	    stores: gridnms["stores.checkbigclass"],
	    views: gridnms["panel.1"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      bigLayout = Ext.create(gridnms["panel.1"], {
	          renderTo: 'gridCheckbigclassListArea'
	        });
	    },
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.checkmiddleclass"],
	    stores: gridnms["stores.checkmiddleclass"],
	    views: gridnms["panel.2"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      middleLayout = Ext.create(gridnms["panel.2"], {
	          renderTo: 'gridCheckmiddleclassListArea'
	        });
	    },
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.checksmallclass"],
	    stores: gridnms["stores.checksmallclass"],
	    views: gridnms["panel.3"],
	    controllers: gridnms["controller.3"],

	    launch: function () {
	      smallLayout = Ext.create(gridnms["panel.3"], {
	          renderTo: 'gridChecksmallclassListArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    bigLayout.updateLayout();
	    middleLayout.updateLayout();
	    smallLayout.updateLayout();
	  });
	}

	function btnAdd1Click(o, e) {
	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	  //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
	  var sortorder = 0;
	  var listcount = Ext.getStore(gridnms["store.1"]).count();
	  for (var i = 0; i < listcount; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.checkbigclass"]).getSelectionModel().select(i));
	    var dummy = Ext.getCmp(gridnms["views.checkbigclass"]).selModel.getSelection()[0];

	    var dummy_sort = dummy.data.RNUM * 1;
	    if (sortorder < dummy_sort) {
	      sortorder = dummy_sort;
	    }
	  }
	  sortorder++;

	  model.set("RNUM", sortorder);

	  model.set("ORGID", $('#searchOrgId').val());
	  model.set("COMPANYID", $('#searchOrgId').val());
	  model.set("USEYN", "Y");

	  var view = Ext.getCmp(gridnms['panel.1']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.checkbigclass"], startPoint, 1);
	};

	function btnSav1Click(o, e) {
	  var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
	  var count = 0;

	  var check2 = model.get("USEYN") + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
	    count++;
	  }

	  var check1 = model.get("BIGCDNM") + "";
	  if (check1.length == 0) {
	    extAlert("대분류명을 입력하세요.");
	    count++;
	  }

	  var check = model.get("BIGCD") + "";
	  if (check.length == 0) {
	    extAlert("대분류 코드를 입력하세요.");
	    count++;
	  }

	  if (count == 0) {
	    Ext.getStore(gridnms["store.1"]).sync({
	      success: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.1"]);

	        Ext.getStore(gridnms["store.1"]).load();

	        setTimeout(function () {
	          Ext.getStore(gridnms["store.2"]).load();
	        }, 200);

	        setTimeout(function () {
	          Ext.getStore(gridnms["store.3"]).load();
	        }, 400);
	      },
	      failure: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.1"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel1Click(o, e) {
	  extGridDel(gridnms["store.1"], gridnms["panel.1"]);
	};

	function btnRef1Click(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	//중분류 버튼
	function btnAdd2Click(o, e) {
	  var model = Ext.create(gridnms["model.2"]);
	  var store = this.getStore(gridnms["store.2"]);

	  var bigcode = $('#BigcdVal').val();
	  if (bigcode.length == 0) {
	    extAlert("대분류를 선택하여 주십시오.");
	    return;
	  }

	  model.set("BIGCD", $('#BigcdVal').val());

	  //      var sortorder = Ext.getStore(gridnms["store.2"]).count() + 1;
	  var sortorder = 0;
	  var listcount = Ext.getStore(gridnms["store.2"]).count();
	  for (var i = 0; i < listcount; i++) {
	    Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.checkmiddleclass"]).getSelectionModel().select(i));
	    var dummy = Ext.getCmp(gridnms["views.checkmiddleclass"]).selModel.getSelection()[0];

	    var dummy_sort = dummy.data.RNUM * 1;
	    if (sortorder < dummy_sort) {
	      sortorder = dummy_sort;
	    }
	  }
	  sortorder++;

	  model.set("RNUM", sortorder);

	  model.set("ORGID", $('#OrgidVal').val());
	  model.set("COMPANYID", $('#CompanyidVal').val());
	  model.set("USEYN", "Y");

	  var view = Ext.getCmp(gridnms['panel.2']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.checkmiddleclass"], startPoint, 1);
	};

	function btnSav2Click(o, e) {
	  var model = Ext.getStore(gridnms['store.2']).getById(Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0].id);
	  var count = 0;

	  var check2 = model.get("USEYN") + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
	    count++;
	  }

	  var check1 = model.get("MIDDLECDNM") + "";
	  if (check1.length == 0) {
	    extAlert("중분류명을 입력하세요.");
	    count++;
	  }

	  var check = model.get("MIDDLECD") + "";
	  if (check.length == 0) {
	    extAlert("중분류 코드를 입력하세요.");
	    count++;
	  }

	  // 저장
	  if (count == 0) {
	    Ext.getStore(gridnms["store.2"]).sync({
	      success: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.2"]);

	        Ext.getStore(gridnms["store.2"]).load();

	        setTimeout(function () {
	          Ext.getStore(gridnms["store.3"]).load();
	        }, 200);
	      },
	      failure: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.2"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel2Click(o, e) {
	  extGridDel(gridnms["store.2"], gridnms["panel.2"]);
	};

	function btnRef2Click(o, e) {
	  Ext.getStore(gridnms["store.2"]).load();
	};

	//소분류 버튼
	function btnAdd3Click(o, e) {
	  var model = Ext.create(gridnms["model.3"]);
	  var store = this.getStore(gridnms["store.3"]);

	  var bigcode = $('#BigcdVal').val();
	  if (bigcode.length == 0) {
	    extAlert("대분류를 선택하여 주십시오.");
	    return;
	  }

	  model.set("BIGCD", $('#BigcdVal').val());

	  var middlecode = $('#MiddlecdVal').val();
	  if (middlecode.length == 0) {
	    extAlert("중분류를 선택하여 주십시오.");
	    return;
	  }

	  model.set("MIDDLECD", $('#MiddlecdVal').val());

	  //      var sortorder = Ext.getStore(gridnms["store.3"]).count() + 1;
	  var sortorder = 0;
	  var listcount = Ext.getStore(gridnms["store.3"]).count();
	  for (var i = 0; i < listcount; i++) {
	    Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.checksmallclass"]).getSelectionModel().select(i));
	    var dummy = Ext.getCmp(gridnms["views.checksmallclass"]).selModel.getSelection()[0];

	    var dummy_sort = dummy.data.RNUM * 1;
	    if (sortorder < dummy_sort) {
	      sortorder = dummy_sort;
	    }
	  }
	  sortorder++;

	  model.set("RNUM", sortorder);

	  model.set("ORGID", $('#OrgidVal').val());
	  model.set("COMPANYID", $('#CompanyidVal').val());
	  store.insert(Ext.getStore(gridnms["store.3"]).count() + 1, model);

	  model.set("USEYN", "Y");

	  var view = Ext.getCmp(gridnms['panel.3']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.3"], gridnms["views.checksmallclass"], startPoint, 1);
	};

	function btnSav3Click(o, e) {
	  var model = Ext.getStore(gridnms['store.3']).getById(Ext.getCmp(gridnms["panel.3"]).selModel.getSelection()[0].id);
	  var count = 0;

	  var check2 = model.get("USEYN") + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
	    count++;
	  }

	  var check1 = model.get("SMALLCDNM") + "";
	  if (check1.length == 0) {
	    extAlert("소분류명을 입력하세요.");
	    count++;
	  }

	  var check = model.get("SMALLCD") + "";
	  if (check.length == 0) {
	    extAlert("소분류 코드를 입력하세요.");
	    count++;
	  }

	  if (count == 0) {
	    Ext.getStore(gridnms["store.3"]).sync({
	      success: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.3"]);

	        Ext.getStore(gridnms["store.3"]).load();
	      },
	      failure: function (batch, options) {
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.3"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel3Click(o, e) {
	  extGridDel(gridnms["store.3"], gridnms["panel.3"]);
	};

	function btnRef3Click(o, e) {
	  Ext.getStore(gridnms["store.3"]).load();
	};

	function fn_search() {
	  if (!valid_chk("search"))
	    return;
	  var sparams = {
	    "searchParam1": $("#searchParam1").val() + "",
	    "searchParam2": $("#searchParam2").val() + "",
	    "orgid": $("#searchOrgId").val() + "",
	    "companyid": $("#searchCompanyId").val() + ""
	  };
	  extGridSearch(sparams, gridnms["store.1"]);
	  Ext.getStore(gridnms["store.2"]).removeAll();
	  Ext.getStore(gridnms["store.3"]).removeAll();
	}

	function setLovList() {
	  $("#searchParam1")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchParam1").val("");
	      $("#searchParam2").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })

	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/checkclass/searchlov.do' />", {
	        keyword: extractLast(request.term),
	        orgid: $('#searchOrgId option:selected').val(),
	        companyid: $('#searchCompanyId option:selected').val()
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.LABEL,
	              value: m.VALUE
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
	      $("#searchParam2").val(o.item.value);
	      $("#searchParam1").val(o.item.label);
	      return false;
	    }
	  });
	}

	function setReadOnly() {
	  if ($("#temp1").val() !== "")
	    $("#temp1").prop("readonly", true);

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
        <div id="search_field" style="margin-bottom: 10px;">
          <div id="search_field_loc">
            <h2>
              <strong>${pageTitle}</strong>
            </h2>
          </div>
          <input type="hidden" id="OrgidVal" value="<c:out value='${OrgidVal}'/>" />
          <input type="hidden" id="CompanyidVal" value="<c:out value='${CompanyidVal}'/>" />
          <input type="hidden" id="BigcdVal" value="<c:out value='${BigcdVal}'/>" />
          <input type="hidden" id="MiddlecdVal" value="<c:out value='${MiddlecdVal}'/>" />
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
                          <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 80%;">
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
                          <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 80%;">
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
                      <th class="required_text">대분류</th>
                      <td><input type="text" id="searchParam1" name="searchParam1"  class="imetype input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                            <input type="hidden" id="searchParam2" name="searchParam2" />
                      </td>
                      <td>
                          <div class="buttons" style="float: right; margin-top: 3px;">
                              <div class="buttons" style="float: right;">
                                  <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                     조회
                                  </a>
                              </div>
                          </div>
                      </td>
                   </tr>
              </table>
            </div>
          </fieldset>
        </div>
        <div>
          <table style="width: 100%">
            <tr>
              <td style="width: 32%;"><div class="subConTit3">대분류</div></td>
              <td style="width: 1%;"></td>
              <td style="width: 33%;"><div class="subConTit3">중분류</div></td>
              <td style="width: 1%;"></td>
              <td style="width: 33%;"><div class="subConTit3">소분류</div></td>
            </tr>
          </table>
          <div id="gridCheckbigclassListArea" style="width: 32%; padding-bottom: 5px; float: left;"></div>
          <div  style="width: 1%; padding-bottom: 5px; float: left;"></div>
          <div id="gridCheckmiddleclassListArea" style="width: 33%; padding-bottom: 5px; float: left;"></div>
          <div  style="width: 1%; padding-bottom: 5px; float: left;"></div>
          <div id="gridChecksmallclassListArea" style="width: 33%; padding-bottom: 5px; float: left;"></div>
        </div>
      </div>
      <!-- //검색 필드 박스 끝 -->
      <br />
    </div>
  </div>
  </div>
  <!-- //container 끝 -->
  <!-- footer 시작 -->
  <div id="footer" style="clear: both;">
    <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
  </div>
  <!-- //footer 끝 -->
  </div>
  <!-- //전체 레이어 끝 -->
</body>
</html>