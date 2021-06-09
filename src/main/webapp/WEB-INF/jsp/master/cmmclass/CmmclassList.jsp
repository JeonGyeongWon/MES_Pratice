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
	  setInitial();

	  setValues();
	  setExtGrid();
	  
	  setLovList();
    setReadOnly();
	});

	function setInitial() {
	  gridnms["app"] = "base";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_big();
	  setValues_middle();
	  setValues_small();
	}

	function setValues_big() {
	  gridnms["models.bigclass"] = [];
	  gridnms["stores.bigclass"] = [];
	  gridnms["views.bigclass"] = [];
	  gridnms["controllers.bigclass"] = [];

	  gridnms["grid.1"] = "CmmBigclass";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.bigclass"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.bigclass"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.bigclass"].push(gridnms["model.1"]);

	  gridnms["stores.bigclass"].push(gridnms["store.1"]);

	  fields["model.1"] = [{
	      type: 'number',
	      name: 'RNUM', // 변수 명
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'string',
	      name: 'BIGCD',
	    }, {
	      type: 'string',
	      name: 'BIGCDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES',
	    }, {
	      type: 'string',
	      name: 'USEYN',
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'BIGCD',
	      text: '대분류코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: true,
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
	      width: 160,
	      hidden: false,
	      sortable: true,
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
	      flex: 1,
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
	        matchFieldWidth: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
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
	    }
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/cmmclass/CmmbigclassList.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/cmmclass/CmmbigclassList.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/cmmclass/CmmbigclassList.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/cmmclass/CmmbigclassList.do' />"
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
	    "#BigGrid": {
	      itemclick: 'onBigClick'
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
	  //             items["docked.1"].push(items["dock.paging.1"]);
	}

	function btnAdd1Click(o, e) {
	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	    //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
	    var sortorder = 0;
	    var listcount = Ext.getStore(gridnms["store.1"]).count();
	    for (var i = 0; i < listcount; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.bigclass"]).getSelectionModel().select(i));
	      var dummy = Ext.getCmp(gridnms["views.bigclass"]).selModel.getSelection()[0];

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
	  
// 	  store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	    var view = Ext.getCmp(gridnms['panel.1']).getView();
	    var startPoint = 0;

	    store.insert(startPoint, model);
	    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.bigclass"], startPoint, 1);
	};

	function btnSav1Click(o, e) {
	  var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
	  var count = 0;

	  // 미입력 사항 체크
	  var check = model.data.BIGCD + "";
	  if (check.length == 0) {
	    extAlert("대분류 코드를 입력하세요.");
	    count++;
	  }

	  var check1 = model.data.BIGCDNM + "";
	  if (check1.length == 0) {
	    extAlert("대분류명을 입력하세요.");
	    count++;
	  }

	  var check2 = model.data.USEYN + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
	    count++;
	  }

	  // 저장
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

	function onBigClick(dataview, record, item, index, e, eOpts) {
	  $("#OrgidVal").val(record.data.ORGID);
	  $("#CompanyidVal").val(record.data.COMPANYID);
	  $("#BigcdVal").val(record.data.BIGCD);
	  $("#BignmVal").val(record.data.BIGCDNM);
	  $("#MiddlecdVal").val(""); ;
	  $("#MiddlenmVal").val("");
	  var OrgidVal = $('#OrgidVal').val();
	  var CompanyidVal = $('#CompanyidVal').val();
	  var BigcdVal = $('#BigcdVal').val();
	  var BignmVal = $('#BignmVal').val();
	  var MiddlecdVal = $('#MiddlecdVal').val();
	  var MiddlenmVal = $('#MiddlenmVal').val();

	  var sparams = {
	    orgid: OrgidVal,
	    companyid: CompanyidVal,
	    bigcd: BigcdVal,
	    bignm: BignmVal,
	    middlecd: MiddlecdVal,
	    middlenm: MiddlenmVal,
	  };
	  extGridSearch(sparams, gridnms["store.2"]);

	  var sparams1 = {
	    orgid: OrgidVal,
	    companyid: CompanyidVal,
	    bigcd: BigcdVal,
	    bignm: BignmVal,
	    middlecd: MiddlecdVal,
	    middlenm: MiddlenmVal,
	  };
	  // 대분류 list 클릭시 0.4초 늦게 load
	  setTimeout(function () {
	    extGridSearch(sparams1, gridnms["store.3"]);
	  }, 400);
	};

	function setValues_middle() {
	  gridnms["models.middleclass"] = [];
	  gridnms["stores.middleclass"] = [];
	  gridnms["views.middleclass"] = [];
	  gridnms["controllers.middleclass"] = [];

	  gridnms["grid.2"] = "CmmMiddleclass";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.middleclass"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.middleclass"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.middleclass"].push(gridnms["model.2"]);

	  gridnms["stores.middleclass"].push(gridnms["store.2"]);

	  fields["model.2"] = [{
	      type: 'number',
	      name: 'RNUM',
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'string',
	      name: 'BIGCD',
	    }, {
	      type: 'string',
	      name: 'MIDDLECD',
	    }, {
	      type: 'string',
	      name: 'MIDDLECDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES',
	    }, {
	      type: 'string',
	      name: 'USEYN',
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'MIDDLECD',
	      text: '중분류코드',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
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
	      sortable: true,
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
	      flex: 1,
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
	        matchFieldWidth: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
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
	      dataIndex: 'BIGCD',
	      xtype: 'hidden',
	    }
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    create: "<c:url value='/insert/cmmclass/CmmmiddleclassList.do' />"
	  });
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/cmmclass/CmmmiddleclassList.do' />"
	  });
	  $.extend(items["api.2"], {
	    update: "<c:url value='/update/cmmclass/CmmmiddleclassList.do' />"
	  });
	  $.extend(items["api.2"], {
	    destroy: "<c:url value='/delete/cmmclass/CmmmiddleclassList.do' />"
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
	    "#MiddleGrid": {
	      itemclick: 'onMiddleClick'
	    }
	  });

	  items["dock.paging.2"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.2"],
	  };

	  items["dock.btn.2"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.2"],
	    items: items["btns.2"],
	  };

	  items["docked.2"] = [];
	  items["docked.2"].push(items["dock.btn.2"]);
	  //           items["docked.2"].push(items["dock.paging.2"]);
	}

	function btnAdd2Click(o, e) {
	  var model = Ext.create(gridnms["model.2"]);
	  var store = this.getStore(gridnms["store.2"]);

	  var bigcode = $('#BigcdVal').val();
	  if (bigcode.length == 0) {
	    extAlert("대분류를 선택하여 주십시오.");
	    return;
	  }

	    //      var sortorder = Ext.getStore(gridnms["store.2"]).count() + 1;
	    var sortorder = 0;
	    var listcount = Ext.getStore(gridnms["store.2"]).count();
	    for (var i = 0; i < listcount; i++) {
	      Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.middleclass"]).getSelectionModel().select(i));
	      var dummy = Ext.getCmp(gridnms["views.middleclass"]).selModel.getSelection()[0];

	      var dummy_sort = dummy.data.RNUM * 1;
	      if (sortorder < dummy_sort) {
	        sortorder = dummy_sort;
	      }
	    }
	    sortorder++;

	    model.set("RNUM", sortorder);

	  model.set("ORGID", $('#OrgidVal').val());
	  model.set("COMPANYID", $('#CompanyidVal').val());
	  model.set("BIGCD", bigcode);
	  model.set("USEYN", "Y");
	  
// 	  store.insert(Ext.getStore(gridnms["store.2"]).count() + 1, model);
	    var view = Ext.getCmp(gridnms['panel.2']).getView();
	    var startPoint = 0;

	    store.insert(startPoint, model);
	    fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.middleclass"], startPoint, 1);
	};

	function btnSav2Click(o, e) {
	  var model = Ext.getStore(gridnms['store.2']).getById(Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0].id);
	  var count = 0;

	  var check = model.data.MIDDLECD + "";
	  if (check.length == 0) {
	    extAlert("중분류 코드를 입력하세요.");
	    count++;
	  }

	  var check1 = model.data.MIDDLECDNM + "";
	  if (check1.length == 0) {
	    extAlert("중분류명을 입력하세요.");
	    count++;
	  }

	  var check2 = model.data.USEYN + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
	    count++;
	  }

	  if (count == 0) {
	    Ext.getStore(gridnms["store.2"]).sync({
	      success: function (batch, options) {
	          var reader = batch.proxy.getReader();
	          extAlert(reader.rawData.msg, gridnms["store.2"]);

	          Ext.getStore(gridnms["store.2"]).load();

	          setTimeout(function () {
	            var sparams1 = {
	              orgid: model.data.ORGID,
	              companyid: model.data.COMPANYID,
	              bigcd: model.data.BIGCD,
	              bignm: "",
	              middlecd: model.data.MIDDLECD,
	              middlenm: model.data.MIDDLECDNM,
	            };
	            extGridSearch(sparams1, gridnms["store.3"]);
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

	function onMiddleClick(dataview, record, item, index, e, eOpts) {
	  $("#OrgidVal").val(record.data.ORGID);
	  $("#CompanyidVal").val(record.data.COMPANYID);
	  $("#BigcdVal").val(record.data.BIGCD);
	  $("#MiddlecdVal").val(record.data.MIDDLECD);
	  $("#MiddlenmVal").val(record.data.MIDDLECDNM);
	  var OrgidVal = $('#OrgidVal').val();
	  var CompanyidVal = $('#CompanyidVal').val();
	  var BigcdVal = $('#BigcdVal').val();
	  var BignmVal = $('#BignmVal').val();
	  var MiddlecdVal = $('#MiddlecdVal').val();
	  var MiddlenmVal = $('#MiddlenmVal').val();

	  var sparams1 = {
	    orgid: OrgidVal,
	    companyid: CompanyidVal,
	    bigcd: BigcdVal,
	    bignm: BignmVal,
	    middlecd: MiddlecdVal,
	    middlenm: MiddlenmVal,
	  };
	  extGridSearch(sparams1, gridnms["store.3"]);
	};

	function setValues_small() {
	  gridnms["models.smallclass"] = [];
	  gridnms["stores.smallclass"] = [];
	  gridnms["views.smallclass"] = [];
	  gridnms["controllers.smallclass"] = [];

	  gridnms["grid.3"] = "CmmSmallclass";

	  gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
	  gridnms["views.smallclass"].push(gridnms["panel.3"]);

	  gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
	  gridnms["controllers.smallclass"].push(gridnms["controller.3"]);

	  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	  gridnms["models.smallclass"].push(gridnms["model.3"]);

	  gridnms["stores.smallclass"].push(gridnms["store.3"]);

	  fields["model.3"] = [{
	      type: 'number',
	      name: 'RNUM',
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }, {
	      type: 'string',
	      name: 'BIGCD',
	    }, {
	      type: 'string',
	      name: 'MIDDLECD',
	    }, {
	      type: 'string',
	      name: 'SMALLCD',
	    }, {
	      type: 'string',
	      name: 'SMALLCDNM',
	    }, {
	      type: 'string',
	      name: 'NOTES',
	    }, {
	      type: 'string',
	      name: 'USEYN',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE1',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE2',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE3',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE4',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE5',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE6',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE7',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE8',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE9',
	    }, {
	      type: 'string',
	      name: 'ATTRIBUTE10',
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'SMALLCD',
	      text: '소분류코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: true,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'SMALLCDNM',
	      text: '소분류명',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: true,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE1',
	      text: '관련1',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE2',
	      text: '관련2',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE3',
	      text: '관련3',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE4',
	      text: '관련4',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE5',
	      text: '관련5',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE6',
	      text: '관련6',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE7',
	      text: '관련7',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE8',
	      text: '관련8',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE9',
	      text: '관련9',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'ATTRIBUTE10',
	      text: '관련10',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
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
	        matchFieldWidth: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
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
	      dataIndex: 'BIGCD',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MIDDLECD',
	      xtype: 'hidden',
	    }
	  ];

	  items["api.3"] = {};
	  $.extend(items["api.3"], {
	    create: "<c:url value='/insert/cmmclass/CmmsmallclassList.do' />"
	  });
	  $.extend(items["api.3"], {
	    read: "<c:url value='/select/cmmclass/CmmsmallclassList.do' />"
	  });
	  $.extend(items["api.3"], {
	    update: "<c:url value='/update/cmmclass/CmmsmallclassList.do' />"
	  });
	  $.extend(items["api.3"], {
	    destroy: "<c:url value='/delete/cmmclass/CmmsmallclassList.do' />"
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

	  items["dock.paging.3"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.3"],
	  };

	  items["dock.btn.3"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.3"],
	    items: items["btns.3"],
	  };

	  items["docked.3"] = [];
	  items["docked.3"].push(items["dock.btn.3"]);
	  //           items["docked.3"].push(items["dock.paging.3"]);
	}

	function btnAdd3Click(o, e) {
	  var model = Ext.create(gridnms["model.3"]);
	  var store = this.getStore(gridnms["store.3"]);

	  var bigcode = $('#BigcdVal').val();
	  if (bigcode.length == 0) {
	    extAlert("대분류를 선택하여 주십시오.");
	    return;
	  }

	  var middlecode = $('#MiddlecdVal').val();
	  if (middlecode.length == 0) {
	    extAlert("중분류를 선택하여 주십시오.");
	    return;
	  }

	    //      var sortorder = Ext.getStore(gridnms["store.3"]).count() + 1;
	    var sortorder = 0;
	    var listcount = Ext.getStore(gridnms["store.3"]).count();
	    for (var i = 0; i < listcount; i++) {
	      Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.smallclass"]).getSelectionModel().select(i));
	      var dummy = Ext.getCmp(gridnms["views.smallclass"]).selModel.getSelection()[0];

	      var dummy_sort = dummy.data.RNUM * 1;
	      if (sortorder < dummy_sort) {
	        sortorder = dummy_sort;
	      }
	    }
	    sortorder++;

	    model.set("RNUM", sortorder);

	  model.set("ORGID", $('#OrgidVal').val());
	  model.set("COMPANYID", $('#CompanyidVal').val());
	  model.set("BIGCD", bigcode);
	  model.set("MIDDLECD", middlecode);
	  model.set("USEYN", "Y");

// 	  store.insert(Ext.getStore(gridnms["store.3"]).count() + 1, model);
	    var view = Ext.getCmp(gridnms['panel.3']).getView();
	    var startPoint = 0;

	    store.insert(startPoint, model);
	    fn_grid_focus_move("UP", gridnms["store.3"], gridnms["views.smallclass"], startPoint, 1);
	};

	function btnSav3Click(o, e) {
	  var model = Ext.getStore(gridnms['store.3']).getById(Ext.getCmp(gridnms["panel.3"]).selModel.getSelection()[0].id);
	  var count = 0;

	  var check = model.data.SMALLCD + "";
	  if (check.length == 0) {
	    extAlert("소분류 코드를 입력하세요.");
	    count++;
	  }

	  var check1 = model.data.SMALLCDNM + "";
	  if (check1.length == 0) {
	    extAlert("소분류명을 입력하세요.");
	    count++;
	  }

	  var check2 = model.data.USEYN + "";
	  if (check2.length == 0) {
	    extAlert("사용여부를 입력하세요.");
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

	var bigLayout, middleLayout, smallLayout;
	function setExtGrid() {
	  setExtGrid_big();
	  setExtGrid_middle();
	  setExtGrid_small();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    bigLayout.updateLayout();
	    middleLayout.updateLayout();
	    smallLayout.updateLayout();
	  });
	}

	function setExtGrid_big() {
	  // 모델 정의 부분
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	    //idProperty : fields["model.1.key"],   // Key를 사용하면 중복된 데이터가 표시되지 않는다.
	  });

	  // 스토어 정의 부분
	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.1"],
	            model: gridnms["model.1"],
	            autoLoad: true,
	            pageSize: 999999, // gridVals.pageSize, // 페이지 개수... 20,
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

	  // 버튼 컨트롤러
	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      BigGrid: '#BigGrid', // itemclick과 같은 컨트롤러를 사용하려면 컨트롤러에 있는 grid 명이 panel에 있는 grid 명이랑 일치해야 작동된다.
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    // 버튼 등의 기능을 정의하는 부분
	    btnAdd1Click: btnAdd1Click,
	    btnSav1Click: btnSav1Click,
	    btnDel1Click: btnDel1Click,
	    btnRef1Click: btnRef1Click,
	    onBigClick: onBigClick,
	  });

	  // 화면에 보여지는 부분
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
	        height: 250, // 그리드의 높이... 700은 700px이다,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'BigGrid', // Controller의 grid와 일치해야 itemclick 기능이 작동된다.
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

	  // Model -> Store -> Controller -> Panel 까지 선언을 다하고나면
	  // 최종적으로 renderTo로 해당 <div id="아이디"... 에 뿌려준다.
	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.bigclass"],
	    stores: gridnms["stores.bigclass"],
	    views: gridnms["panel.1"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      bigLayout = Ext.create(gridnms["panel.1"], {
	          renderTo: 'gridCmmbigclassListArea'
	        });
	    },
	  });

	}

	function setExtGrid_middle() {
	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"]
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
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      MiddleGrid: '#MiddleGrid',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

	    btnAdd2Click: btnAdd2Click,
	    btnSav2Click: btnSav2Click,
	    btnDel2Click: btnDel2Click,
	    btnRef2Click: btnRef2Click,
	    onMiddleClick: onMiddleClick
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
	        height: 390,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'MiddleGrid',
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

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.middleclass"],
	    stores: gridnms["stores.middleclass"],
	    views: gridnms["panel.2"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      middleLayout = Ext.create(gridnms["panel.2"], {
	          renderTo: 'gridCmmmiddleclassListArea'
	        });
	    },
	  });

	}

	function setExtGrid_small() {
	  Ext.define(gridnms["model.3"], {
	    extend: Ext.data.Model,
	    fields: fields["model.3"]
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
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.3"], {
	    extend: Ext.app.Controller,
	    refs: {
	      SmallGrid: '#SmallGrid',
	    },
	    stores: [gridnms["store.3"]],
	    control: items["btns.ctr.3"],

	    btnAdd3Click: btnAdd3Click,
	    btnSav3Click: btnSav3Click,
	    btnDel3Click: btnDel3Click,
	    btnRef3Click: btnRef3Click,
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
	        height: 676,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.3"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'SmallGrid',
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
	    models: gridnms["models.smallclass"],
	    stores: gridnms["stores.smallclass"],
	    views: gridnms["panel.3"],
	    controllers: gridnms["controller.3"],

	    launch: function () {
	      smallLayout = Ext.create(gridnms["panel.3"], {
	          renderTo: 'gridCmmsmallclassListArea'
	        });
	    },
	  });

	}

	function fn_search() {
	  // 조회 파라미터 (개수가 많아지면 , 를 붙여서 계속 적어주세요)
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var bigcode = $("#searchBigCode").val();
	  var bigname = $("#searchBigName").val();
	  var middlecode = $("#searchMiddleCode").val();
	  var middlename = $("#searchMiddleName").val();

	  var sparams = {
	    orgid: orgid,
	    companyid: companyid,
	    bigcd: bigcode,
	    bignm: bigname,
	    middlecd: middlecode,
	    middlenm: middlename,
	  };
	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 300);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.3"]);
	  }, 600);
	  //    Ext.getStore(gridnms["store.2"]).removeAll();
	  //    Ext.getStore(gridnms["store.3"]).removeAll();
	}

	function setLovList() {
	  // 대분류 Lov
	  $("#searchBigName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchBigCode").val("");

	      var searchMiddleCode = $("#searchMiddleCode").val();
	      if (searchMiddleCode != "") {
	        $("#searchMiddleCode").val("");
	        $("#searchMiddleName").val("");
	      }
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this)
	      .autocomplete("search", "%");
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
	      $.getJSON("<c:url value='/searchBigCodeListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val()
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
	      $("#searchBigCode").val(o.item.value);
	      $("#searchBigName").val(o.item.label);

	      var searchMiddleCode = $("#searchMiddleCode").val();
	      if (searchMiddleCode != "") {
	        $("#searchMiddleCode").val("");
	        $("#searchMiddleName").val("");
	      }
	      return false;
	    }
	  });

	  // 중분류 Lov
	  $("#searchMiddleName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchMiddleCode").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this)
	      .autocomplete("search", "%");
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
	      $.getJSON("<c:url value='/searchMiddleCodeListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        BIGCD: $('#searchBigCode').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.LABEL + ", " + m.BIGNAME,
	              value: m.VALUE,
	              BIGCODE: m.BIGCODE,
	              BIGNAME: m.BIGNAME,
	              MIDDLECODE: m.VALUE,
	              MIDDLENAME: m.LABEL,
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
	      $("#searchBigCode").val(o.item.BIGCODE);
	      $("#searchBigName").val(o.item.BIGNAME);
	      $("#searchMiddleCode").val(o.item.MIDDLECODE);
	      $("#searchMiddleName").val(o.item.MIDDLENAME);
	      return false;
	    }
	  });
	}

	//태그에 readonly 되어있는 속성들 클래스 적용
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
            <div id="content" >
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
                <div id="search_field" style="margin-bottom: 5px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <input type="hidden" id="OrgidVal" />
                    <input type="hidden" id="CompanyidVal" />
                    <input type="hidden" id="BigcdVal" />
                    <input type="hidden" id="BignmVal" />
                    <input type="hidden" id="MiddlecdVal" />
                    <input type="hidden" id="MiddlenmVal" />
                    <table class="tbl_type_view" border="1" style="margin-bottom: 15px;">
                        <colgroup>
                            <col width="120px">
                            <col>
                            <col width="120px">
                                <col>
                            <col width="120px">
                            <col>
                            <col>
                        </colgroup>
                        <tr style="height: 34px;">
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
                            <td></td>
                            <td></td>
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
                        <tr style="height: 34px;">
                            <th class="required_text">대분류</th>
                            <td>
                               <input type="text" id="searchBigName" name="searchBigName"  class="imetype input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 80%;" />
                                <input type="hidden" id="searchBigCode" name="searchBigCode" />
                            </td>
                            <th class="required_text">중분류</th>
                            <td>
                               <input type="text" id="searchMiddleName" name="searchMiddleName"  class="imetype input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 80%;" />
                                <input type="hidden" id="searchMiddleCode" name="searchMiddleCode" />
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                        </tr>
                    </table>
                            
                    <table style="width: 100%; ">
                        <tr>
			                      <td style="width: 49%;"><div class="subConTit3">대분류</div></td>
			                      <td style="width: 2%;"></td>
			                      <td style="width: 49%;"><div class="subConTit3">소분류</div></td>
                        </tr>
                        <tr>
                            <td>
                                <div id="gridCmmbigclassListArea" style="width: 100%; padding-bottom: 0px; float: left;"></div>
                            </td>
                            <td>
                            </td>
                            <td rowspan="2">
                                <div id="gridCmmsmallclassListArea" style="width: 100%; padding-bottom: 0px; float: left;"></div>
                            </td>
                        </tr>
                        <tr>
                        <td>
			                      <table style="width: 100%; margin-top: 15px;">
			                          <tr>
			                              <td style="width: 100%;"><div class="subConTit3">중분류</div></td>
			                          </tr>
			                      </table>
			                      <div id="gridCmmmiddleclassListArea" style="width: 100%; padding-bottom: 0px; float: left;"></div>
                        </td>
                        <td></td>
                        </tr>
                    </table>
                </div>
            </div>
            <!-- //검색 필드 박스 끝 -->
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