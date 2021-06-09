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
</style>

<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setLovList();
  $('#searchOrgId, #searchCompanyId').change(function (event) {});
});

function setInitial() {
  gridnms["app"] = "base";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {

  // 1. 대분류
  setValues_Big();

  // 2. 중분류
  setValues_Middle();

  // 3. 소분류
  setValues_Small();

  // 4. 품목
  setValues_Item();

  // 5. 단가
  setValues_Price();
}

function setValues_Big() {
  gridnms["models.bigclass"] = [];
  gridnms["stores.bigclass"] = [];
  gridnms["views.bigclass"] = [];
  gridnms["controllers.bigclass"] = [];

  gridnms["grid.1"] = "itemBigclass";

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
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'GROUPCODE',
    }, {
      type: 'string',
      name: 'BIGCODE',
    }, {
      type: 'string',
      name: 'BIGNAME',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, {
      type: 'string',
      name: 'USEYN',
    }, {
      type: 'string',
      name: 'REGISTID',
    }, {
      type: 'date',
      name: 'REGISTDT',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'UPDATEID',
    }, {
      type: 'date',
      name: 'UPDATEDT',
      dateFormat: 'Y-m-d',
    }
  ];

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
      align: "center",
    }, {
      dataIndex: 'BIGCODE',
      text: '대분류코드',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'BIGNAME',
      text: '대분류명',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: false,
      resizable: false,
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
      dataIndex: 'REGISTID',
      xtype: 'hidden',
    }, {
      dataIndex: 'REGISTDT',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEID',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEDT',
      xtype: 'hidden',
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    create: "<c:url value='/insert/item/Bigclass.do' />"
  });
  $.extend(items["api.1"], {
    read: "<c:url value='/select/item/Bigclass.do' />"
  });
  $.extend(items["api.1"], {
    update: "<c:url value='/update/item/Bigclass.do' />"
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
      click: 'btnAdd1Click'
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
    "#BigclassGrid": {
      itemclick: 'onBigclassClick'
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

function btnAdd1Click(o, e) {
  var model = Ext.create(gridnms["model.1"]);
  var store = this.getStore(gridnms["store.1"]);

  //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.1"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.bigclass"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.bigclass"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RN * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RN", sortorder);

  var groupcode = $('#GroupcodeVal').val();
  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("GROUPCODE", groupcode);
  model.set("USEYN", "Y");

  //   store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.1']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.bigclass"], startPoint, 1);
};

function btnSav1Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount1 = Ext.getStore(gridnms["store.1"]).count();

  for (var i = 0; i < mcount1; i++) {
    var model = Ext.getStore(gridnms["store.1"]).data.items[i].data;
    var header = [],
    gubun = null; ;
    var bigcode = model.BIGCODE + "";
    if (bigcode.length == 0) {
      header.push("대분류코드");
      count++;
    }

    var bigname = model.BIGNAME + "";
    if (bigname.length == 0) {
      header.push("대분류명");
      count++;
    }

    var useyn = model.USEYN + "";
    if (useyn.length == 0) {
      header.push("사용여부");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    Ext.getStore(gridnms["store.1"]).sync({
      success: function (batch, options) {
        var reader = batch.proxy.getReader();

        msg = reader.rawData.msg;
        extAlert(msg);

        Ext.getStore(gridnms["store.1"]).load();
      },
      failure: function (batch, options) {
        msg = batch.operations[0].error;
        extAlert(msg);
      },
      callback: function (batch, options) {},
    });
  } else {
    extAlert(msg + " 입력하세요.");
    return;
  }
};

function btnRef1Click(button, e, eOpts) {
  Ext.getStore(gridnms["store.1"]).load();
};

function onBigclassClick(dataview, record, item, index, e, eOpts) {

  $("#BigcodeVal").val(record.data.BIGCODE);
  $("#MiddlecodeVal").val("");
  $("#SmallcodeVal").val("");
  $("#ItemCodeVal").val("");

  var orgid = $('#searchOrgId').val();
  var companyid = $('#searchCompanyId').val();
  var GroupcodeVal = $('#GroupcodeVal').val();
  var BigcodeVal = $('#BigcodeVal').val();
  var MiddlecodeVal = $('#MiddlecodeVal').val();
  var SmallcodeVal = $('#SmallcodeVal').val();
  var ItemCodeVal = $('#ItemCodeVal').val();

  var sparams = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
  };

  extGridSearch(sparams, gridnms["store.2"]);

  var sparams1 = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
  };

  setTimeout(function () {
    extGridSearch(sparams1, gridnms["store.3"]);
  }, 300);

  var sparams2 = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
    smallcode: SmallcodeVal,
  };

  setTimeout(function () {
    extGridSearch(sparams2, gridnms["store.4"]);
  }, 600);

  var sparams3 = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
    smallcode: SmallcodeVal,
    ITEMCODE: "",
  };

  setTimeout(function () {
    extGridSearch(sparams3, gridnms["store.40"]);
  }, 900);
}

function setValues_Middle() {
  gridnms["models.middleclass"] = [];
  gridnms["stores.middleclass"] = [];
  gridnms["views.middleclass"] = [];
  gridnms["controllers.middleclass"] = [];

  gridnms["grid.2"] = "itemMiddleclass";

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
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'GROUPCODE',
    }, {
      type: 'string',
      name: 'BIGCODE',
    }, {
      type: 'string',
      name: 'MIDDLECODE',
    }, {
      type: 'string',
      name: 'MIDDLENAME',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, {
      type: 'string',
      name: 'USEYN',
    }, {
      type: 'string',
      name: 'REGISTID',
    }, {
      type: 'date',
      name: 'REGISTDT',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'UPDATEID',
    }, {
      type: 'date',
      name: 'UPDATEDT',
      dateFormat: 'Y-m-d',
    }
  ];

  fields["columns.2"] = [
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
      align: "center",
    }, {
      dataIndex: 'MIDDLECODE',
      text: '중분류코드',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'MIDDLENAME',
      text: '중분류명',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: false,
      resizable: false,
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
      dataIndex: 'REGISTID',
      xtype: 'hidden',
    }, {
      dataIndex: 'REGISTDT',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEID',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEDT',
      xtype: 'hidden',
    }, ];

  items["api.2"] = {};
  $.extend(items["api.2"], {
    create: "<c:url value='/insert/item/Middleclass.do' />"
  });
  $.extend(items["api.2"], {
    read: "<c:url value='/select/item/Middleclass.do' />"
  });
  $.extend(items["api.2"], {
    update: "<c:url value='/update/item/Middleclass.do' />"
  });

  items["btns.2"] = [];
  items["btns.2"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd2"
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
    "#MiddleclassGrid": {
      itemclick: 'onMiddleclassClick'
    }
  });

  items["dock.btn.2"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.2"],
    items: items["btns.2"],
  };

  items["docked.2"] = [];
  items["docked.2"].push(items["dock.btn.2"]);
}

function btnAdd2Click(o, e) {
  var model = Ext.create(gridnms["model.2"]);
  var store = this.getStore(gridnms["store.2"]);

  var groupcode = $('#GroupcodeVal').val();
  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("GROUPCODE", groupcode);

  var bigcode = $('#BigcodeVal').val();
  if (bigcode.length == 0) {
    extAlert("대분류를 선택하여 주십시오.");
    return;
  }
  model.set("BIGCODE", bigcode);

  //      var sortorder = Ext.getStore(gridnms["store.2"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.2"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.middleclass"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.middleclass"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RN * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RN", sortorder);

  model.set("USEYN", "Y");

  //   store.insert(Ext.getStore(gridnms["store.2"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.2']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.middleclass"], startPoint, 1);
};

function btnSav2Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount2 = Ext.getStore(gridnms["store.2"]).count();

  for (var j = 0; j < mcount2; j++) {
    var model = Ext.getStore(gridnms["store.2"]).data.items[j].data;
    var header = [],
    gubun = null;

    var middlecode = model.MIDDLECODE + "";
    if (middlecode.length == 0) {
      header.push("중분류코드");
      count++;
    }

    var middlename = model.MIDDLENAME + "";
    if (middlename.length == 0) {
      header.push("중분류명");
      count++;
    }

    var useyn = model.USEYN + "";
    if (useyn.length == 0) {
      header.push("사용여부");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (j + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    Ext.getStore(gridnms["store.2"]).sync({
      success: function (batch, options) {
        var reader = batch.proxy.getReader();

        msg = reader.rawData.msg;
        extAlert(msg);

        Ext.getStore(gridnms["store.2"]).load();
      },
      failure: function (batch, options) {
        extAlert(batch.exceptions[0].error, gridnms["store.2"]);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnRef2Click(button, e, eOpts) {
  msg = batch.operations[0].error;
  extAlert(msg);
};

function onMiddleclassClick(dataview, record, item, index, e, eOpts) {

  $("#BigcodeVal").val(record.data.BIGCODE);
  $("#MiddlecodeVal").val(record.data.MIDDLECODE);
  $("#ItemCodeVal").val("");
  $("#SmallcodeVal").val("");

  var orgid = $('#searchOrgId').val();
  var companyid = $('#searchCompanyId').val();
  var GroupcodeVal = $('#GroupcodeVal').val();
  var BigcodeVal = $('#BigcodeVal').val();
  var MiddlecodeVal = $('#MiddlecodeVal').val();
  var SmallcodeVal = $('#SmallcodeVal').val();
  var ItemCodeVal = $('#ItemCodeVal').val();

  var sparams = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
  };

  extGridSearch(sparams, gridnms["store.3"]);

  var sparams1 = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
    smallcode: SmallcodeVal,
  };

  setTimeout(function () {
    extGridSearch(sparams1, gridnms["store.4"]);
  }, 300);

  var sparams2 = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
    smallcode: SmallcodeVal,
    ITEMCODE: ItemCodeVal,
  };

  setTimeout(function () {
    extGridSearch(sparams2, gridnms["store.40"]);
  }, 600);
}

function setValues_Small() {
  gridnms["models.smallclass"] = [];
  gridnms["stores.smallclass"] = [];
  gridnms["views.smallclass"] = [];
  gridnms["controllers.smallclass"] = [];

  gridnms["grid.3"] = "itemSmallclass";

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
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'GROUPCODE'
    }, {
      type: 'string',
      name: 'BIGCODE'
    }, {
      type: 'string',
      name: 'MIDDLECODE'
    }, {
      type: 'string',
      name: 'SMALLCODE'
    }, {
      type: 'string',
      name: 'SMALLNAME',
    }, {
      type: 'string',
      name: 'REMARKS'
    }, {
      type: 'string',
      name: 'USEYN'
    }, {
      type: 'string',
      name: 'REGISTID',
    }, {
      type: 'date',
      name: 'REGISTDT',
      dateFormat: 'Y-m-d'
    }, {
      type: 'string',
      name: 'UPDATEID'
    }, {
      type: 'date',
      name: 'UPDATEDT',
      dateFormat: 'Y-m-d'
    }
  ];

  fields["columns.3"] = [
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
      align: "center",
    }, {
      dataIndex: 'SMALLCODE',
      text: '소분류코드',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'SMALLNAME',
      text: '소분류명',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      }
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: false,
      resizable: false,
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
      dataIndex: 'REGISTID',
      xtype: 'hidden',
    }, {
      dataIndex: 'REGISTDT',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEID',
      xtype: 'hidden',
    }, {
      dataIndex: 'UPDATEDT',
      xtype: 'hidden',
    }, ];

  items["api.3"] = {};
  $.extend(items["api.3"], {
    create: "<c:url value='/insert/item/Smallclass.do' />"
  });
  $.extend(items["api.3"], {
    read: "<c:url value='/select/item/Smallclass.do' />"
  });
  $.extend(items["api.3"], {
    update: "<c:url value='/update/item/Smallclass.do' />"
  });

  items["btns.3"] = [];
  items["btns.3"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd3"
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
    "#btnSav3": {
      click: 'btnSav3Click'
    }
  });
  $.extend(items["btns.ctr.3"], {
    "#btnRef3": {
      click: 'btnRef3Click'
    }
  });
  $.extend(items["btns.ctr.3"], {
    "#SmallclassGrid": {
      itemclick: 'onSmallclassClick'
    }
  });

  items["dock.btn.3"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.3"],
    items: items["btns.3"],
  };

  items["docked.3"] = [];
  items["docked.3"].push(items["dock.btn.3"]);
}

function btnAdd3Click(o, e) {
  var model = Ext.create(gridnms["model.3"]);
  var store = this.getStore(gridnms["store.3"]);

  var groupcode = $('#GroupcodeVal').val();
  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("GROUPCODE", groupcode);

  var bigcode = $('#BigcodeVal').val();
  if (bigcode.length == 0) {
    extAlert("대분류를 선택하여 주십시오.");
    return;
  }
  model.set("BIGCODE", bigcode);

  var middlecode = $('#MiddlecodeVal').val();
  if (middlecode.length == 0) {
    extAlert("중분류를 선택하여 주십시오.");
    return;
  }
  model.set("MIDDLECODE", middlecode);

  //      var sortorder = Ext.getStore(gridnms["store.3"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.3"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.smallclass"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.smallclass"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RN * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RN", sortorder);

  model.set("USEYN", "Y");

  //   store.insert(Ext.getStore(gridnms["store.3"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.3']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.3"], gridnms["views.smallclass"], startPoint, 1);
};

function btnSav3Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount3 = Ext.getStore(gridnms["store.3"]).count();

  for (var k = 0; k < mcount3; k++) {
    var model = Ext.getStore(gridnms["store.3"]).data.items[k].data;
    var header = [],
    gubun = null;

    var smallcode = model.SMALLCODE + "";
    if (smallcode.length == 0) {
      header.push("소분류코드");
      count++;
    }

    var smallname = model.SMALLNAME + "";
    if (smallname.length == 0) {
      header.push("소분류명");
      count++;
    }

    var useyn = model.USEYN + "";
    if (useyn.length == 0) {
      header.push("사용여부");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    Ext.getStore(gridnms["store.3"]).sync({
      success: function (batch, options) {
        var reader = batch.proxy.getReader();

        msg = reader.rawData.msg;
        extAlert(msg);

        Ext.getStore(gridnms["store.3"]).load();
      },
      failure: function (batch, options) {
        msg = batch.operations[0].error;
        extAlert(msg);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnRef3Click(button, e, eOpts) {
  Ext.getStore(gridnms["store.3"]).load();
};

function onSmallclassClick(dataview, record, item, index, e, eOpts) {
  $("#BigcodeVal").val(record.data.BIGCODE);
  $("#MiddlecodeVal").val(record.data.MIDDLECODE);
  $("#SmallcodeVal").val(record.data.SMALLCODE);
  $("#ItemCodeVal").val("");

  var orgid = $('#searchOrgId').val();
  var companyid = $('#searchCompanyId').val();
  var GroupcodeVal = $('#GroupcodeVal').val();
  var BigcodeVal = $('#BigcodeVal').val();
  var MiddlecodeVal = $('#MiddlecodeVal').val();
  var SmallcodeVal = $('#SmallcodeVal').val();
  var ItemCodeVal = $('#ItemCodeVal').val();

  var sparams = {
    orgid: orgid,
    companyid: companyid,
    groupcode: GroupcodeVal,
    bigcode: BigcodeVal,
    middlecode: MiddlecodeVal,
    smallcode: SmallcodeVal,
  };

  extGridSearch(sparams, gridnms["store.4"]);

  setTimeout(function () {
    var sparams1 = {
      orgid: orgid,
      companyid: companyid,
      groupcode: GroupcodeVal,
      bigcode: BigcodeVal,
      middlecode: MiddlecodeVal,
      smallcode: SmallcodeVal,
      ITEMCODE: "",
    };

    extGridSearch(sparams1, gridnms["store.40"]);
  }, 300);
}

function setValues_Item() {
  gridnms["models.item"] = [];
  gridnms["stores.item"] = [];
  gridnms["views.item"] = [];
  gridnms["controllers.item"] = [];

  gridnms["grid.4"] = "ItemToolList";
  gridnms["grid.5"] = "uomLov";
  gridnms["grid.6"] = "customerLov";
  gridnms["grid.7"] = "itemtypeLov";

  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
  gridnms["views.item"].push(gridnms["panel.4"]);

  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
  gridnms["controllers.item"].push(gridnms["controller.4"]);

  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];

  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];

  gridnms["models.item"].push(gridnms["model.4"]);
  gridnms["models.item"].push(gridnms["model.5"]);
  gridnms["models.item"].push(gridnms["model.6"]);
  gridnms["models.item"].push(gridnms["model.7"]);

  gridnms["stores.item"].push(gridnms["store.4"]);
  gridnms["stores.item"].push(gridnms["store.5"]);
  gridnms["stores.item"].push(gridnms["store.6"]);
  gridnms["stores.item"].push(gridnms["store.7"]);

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
      name: 'ITEMTYPE',
    }, {
      type: 'string',
      name: 'ITEMTYPENAME',
    }, {
      type: 'string',
      name: 'GROUPCODE',
    }, {
      type: 'string',
      name: 'BIGCODE',
    }, {
      type: 'string',
      name: 'MIDDLECODE',
    }, {
      type: 'string',
      name: 'SMALLCODE',
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
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'string',
      name: 'ORDERINSPECTIONYN',
    }, {
      type: 'string',
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
    }, {
      type: 'string',
      name: 'INVENTORYMANAGEYN',
    }, {
      type: 'number',
      name: 'SAFETYINVENTORY',
    }, {
      type: 'string',
      name: 'REMARKS',
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
      name: 'USEYN',
    }
  ];

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

  fields["columns.4"] = [
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
      align: "center",
      renderer: function (value, meta, record) {
        var itemcode = record.data.ITEMCODE;

        if (itemcode != "") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        return value;
      },
    }, {
	    dataIndex: 'ORDERNAME',
	    text: '품번',
	    xtype: 'gridcolumn',
	    width: 120,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    style: 'text-align:center;',
	    align: "center",
	    editor: {
	      xtype: 'textfield',
	      allowBlank: true,
	    },
	  },{
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 235,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
    }, {
      dataIndex: 'ITEMSTANDARD',
      text: '규격',
      xtype: 'gridcolumn',
      width: 235,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
    }, {
      dataIndex: 'UOMNAME',
      text: '단위',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.5"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("UOM", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
      editor: {
        xtype: 'combobox',
        store: gridnms["store.7"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("ITEMTYPE", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.6"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        queryParam: 'keyword',
        queryMode: 'local', // 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        forceSelection: false,
        anyMatch: true,
        hideTrigger: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("CUSTOMERCODE", record.data.VALUE);
          },
          change: function (value, nv, ov, e) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);
            var result = value.getValue();
            if (nv != ov) {

              if (result == "" || result == null) {
                model.set("CUSTOMERCODE", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">({CUSTOMERTYPENAME})&nbsp;{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
    }, {
      dataIndex: 'ORDERINSPECTIONYN',
      text: '수입검사<br/>유무',
      xtype: 'gridcolumn',
      width: 75,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combo',
        store: ['Y', 'N'],
        editable: false,
      },
    }, {
      dataIndex: 'INVENTORYMANAGEYN',
      text: '재고관리<br/>유무',
      xtype: 'gridcolumn',
      width: 75,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combo',
        store: ['Y', 'N'],
        editable: false,
      },
    }, {
      dataIndex: 'SAFETYINVENTORY',
      text: '적정재고',
      xtype: 'gridcolumn',
      width: 85,
      hidden: false,
      sortable: false,
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
      },
      renderer: Ext.util.Format.numberRenderer('0,000'),
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효<br/>시작일자',
      xtype: 'datecolumn',
      width: 130,
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
    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효<br/>종료일자',
      xtype: 'datecolumn',
      width: 130,
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
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
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
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'UNITCOST',
      xtype: 'hidden',
    }, {
      dataIndex: 'USEYN',
      xtype: 'hidden',
    }, ];

  items["api.4"] = {};
  $.extend(items["api.4"], {
    create: "<c:url value='/insert/item/itemList.do' />"
  });
  $.extend(items["api.4"], {
    read: "<c:url value='/select/item/itemList.do' />"
  });
  $.extend(items["api.4"], {
    update: "<c:url value='/update/item/itemList.do' />"
  });

  items["btns.4"] = [];
  items["btns.4"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd4"
  });
  items["btns.4"].push({
    xtype: "button",
    text: "저장",
    itemId: "btnSav4"
  });
  items["btns.4"].push({
    xtype: "button",
    text: "새로고침",
    itemId: "btnRef4"
  });

  items["btns.ctr.4"] = {};
  $.extend(items["btns.ctr.4"], {
    "#btnAdd4": {
      click: 'btnAdd4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#btnSav4": {
      click: 'btnSav4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#btnRef4": {
      click: 'btnRef4Click'
    }
  });
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
  items["docked.4"].push(items["dock.btn.4"]);
}

function btnAdd4Click(o, e) {
  var model = Ext.create(gridnms["model.4"]);
  var store = this.getStore(gridnms["store.4"]);

  var groupcode = $('#GroupcodeVal').val();
  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  //   model.set("ITEMTYPE", groupcode);
  model.set("GROUPCODE", groupcode);

  var bigcode = $('#BigcodeVal').val();
  if (bigcode.length == 0) {
    extAlert("대분류를 선택하여 주십시오.");
    return;
  }
  model.set("BIGCODE", bigcode);

  var middlecode = $('#MiddlecodeVal').val();
  if (middlecode.length == 0) {
    extAlert("중분류를 선택하여 주십시오.");
    return;
  }
  model.set("MIDDLECODE", middlecode);

  var smallcode = $('#SmallcodeVal').val();
  if (smallcode.length == 0) {
    extAlert("소분류를 선택하여 주십시오.");
    return;
  }
  model.set("SMALLCODE", smallcode);

  //      var sortorder = Ext.getStore(gridnms["store.4"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.4"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RN * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RN", sortorder);

  model.set("ORDERINSPECTIONYN", "N");
  model.set("INVENTORYMANAGEYN", "Y");
  model.set("USEYN", "Y");

  var startdate = Ext.util.Format.date("${searchVO.TODAY}", 'Y-m-d');
  var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
  model.set("EFFECTIVESTARTDATE", startdate);
  model.set("EFFECTIVEENDDATE", enddate);

  //   store.insert(Ext.getStore(gridnms["store.4"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.4']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.4"], gridnms["views.item"], startPoint, 1);
};

function btnSav4Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount3 = Ext.getStore(gridnms["store.4"]).count();

  for (var k = 0; k < mcount3; k++) {
    var model = Ext.getStore(gridnms["store.4"]).data.items[k].data;
    var header = [],
    gubun = null;

    var itemname = model.ITEMNAME + "";
    if (itemname.length == 0) {
      header.push("품명");
      count++;
    }

    var uom = model.UOM + "";
    if (uom.length == 0) {
      header.push("단위");
      count++;
    }

    var type = model.ITEMTYPE + "";
    if (type.length == 0) {
      header.push("유형");
      count++;
    }

    var startdate = model.EFFECTIVESTARTDATE + "";
    if (startdate.length == 0) {
      header.push("시작일자");
      count++;
    }

    var enddate = model.EFFECTIVEENDDATE + "";
    if (enddate.length == 0) {
      header.push("종료일자");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    Ext.getStore(gridnms["store.4"]).sync({
      success: function (batch, options) {
        var reader = batch.proxy.getReader();

        msg = reader.rawData.msg;
        extAlert(msg);

        Ext.getStore(gridnms["store.4"]).load();
      },
      failure: function (batch, options) {
        msg = batch.operations[0].error;
        extAlert(msg);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnRef4Click(button, e, eOpts) {
  Ext.getStore(gridnms["store.4"]).load();
};

function onItemClick(dataview, record, item, index, e, eOpts) {
  $("#BigcodeVal").val(record.data.BIGCODE);
  $("#MiddlecodeVal").val(record.data.MIDDLECODE);
  $("#SmallcodeVal").val(record.data.SMALLCODE);
  $("#ItemCodeVal").val(record.data.ITEMCODE);

  var orgid = $('#searchOrgId').val();
  var companyid = $('#searchCompanyId').val();
  var uom = record.data.UOM;
  var customercode = record.data.CUSTOMERCODE;
  var ItemCodeVal = $('#ItemCodeVal').val();

  var sparams1 = {
    ORGID: orgid,
    COMPANYID: companyid,
    BIGCD: 'CMM',
    MIDDLECD: 'UOM',
    //         keyword : uom,
  };
  extGridSearch(sparams1, gridnms["store.5"]);

  var sparams2 = {
    ORGID: orgid,
    COMPANYID: companyid,
    //         keyword : customercode,
  };
  extGridSearch(sparams2, gridnms["store.6"]);

  if (ItemCodeVal === "") {
    Ext.getStore(gridnms["store.40"]).removeAll();
  } else {
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('ITEMCODE', ItemCodeVal);
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('ORGID', orgid);
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('COMPANYID', companyid);
    Ext.getStore(gridnms["store.40"]).load();
  }
};

function setValues_Price() {
  gridnms["models.price"] = [];
  gridnms["stores.price"] = [];
  gridnms["views.price"] = [];
  gridnms["controllers.price"] = [];

  gridnms["grid.40"] = "priceMaster";

  gridnms["panel.40"] = gridnms["app"] + ".view." + gridnms["grid.40"];
  gridnms["views.price"].push(gridnms["panel.40"]);

  gridnms["controller.40"] = gridnms["app"] + ".controller." + gridnms["grid.40"];
  gridnms["controllers.price"].push(gridnms["controller.40"]);

  gridnms["model.40"] = gridnms["app"] + ".model." + gridnms["grid.40"];

  gridnms["store.40"] = gridnms["app"] + ".store." + gridnms["grid.40"];

  gridnms["models.price"].push(gridnms["model.40"]);

  gridnms["stores.price"].push(gridnms["store.40"]);

  fields["model.40"] = [{
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
      name: 'PRICESEQ',
    }, {
      type: 'string',
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
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
      name: 'UOM'
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'number',
      name: 'UNITPRICEA',
    }, {
      type: 'string',
      name: 'CURRENCYCODE'
    }, {
      type: 'string',
      name: 'CURRENCYCODENAME',
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

  fields["columns.40"] = [
    // Display columns
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
      cls: 'ERPQTY',
      format: "0,000",
    }, {
      dataIndex: 'UNITPRICEA',
      text: '단가',
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
        xtype: 'textfield',
        minValue: 1,
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: 10,
        maskRe: /[0-9.]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
        var seq = record.data.PRICESEQ;

        if (seq != "") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효<br/>시작일자',
      xtype: 'datecolumn',
      width: 105,
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
    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효<br/>종료일자',
      xtype: 'datecolumn',
      width: 105,
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
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 180,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        allowBlank: true,
        xtype: "textfield",
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
      dataIndex: 'PRICESEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'UNITPRICEB',
      xtype: 'hidden',
    }, {
      dataIndex: 'UNITPRICEC',
      xtype: 'hidden',
    }, ];

  items["api.40"] = {};
  $.extend(items["api.40"], {
    create: "<c:url value='/insert/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    read: "<c:url value='/select/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    update: "<c:url value='/update/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    destroy: "<c:url value='/delete/item/ItemMasterPrice.do' />"
  });

  items["btns.40"] = [];
  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    items["btns.40"].push({
      xtype: "button",
      text: "추가",
      itemId: "btnAdd40"
    });
    //   items["btns.40"].push({
    //     xtype: "button",
    //     text: "삭제",
    //     itemId: "btnDel40"
    //   });
    items["btns.40"].push({
      xtype: "button",
      text: "저장",
      itemId: "btnSav40"
    });
    items["btns.40"].push({
      xtype: "button",
      text: "새로고침",
      itemId: "btnRef40"
    });

    break;
  default:
    break;
  }

  items["btns.ctr.40"] = {};
  $.extend(items["btns.ctr.40"], {
    "#btnAdd40": {
      click: 'btnAdd40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnDel40": {
      click: 'btnDel40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnSav40": {
      click: 'btnSav40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnRef40": {
      click: 'btnRef40Click'
    }
  });

  items["dock.btn.40"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.40"],
    items: items["btns.40"],
  };

  items["docked.40"] = [];
  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    items["docked.40"].push(items["dock.btn.40"]);

    break;
  default:
    break;
  }
}

function btnAdd40Click(o, e) {
  var model = Ext.create(gridnms["model.40"]);
  var store = this.getStore(gridnms["store.40"]);

  var bigcode = $('#BigcodeVal').val();
  if (bigcode.length == 0) {
    extAlert("대분류를 선택하여 주십시오.");
    return;
  }

  var middlecode = $('#MiddlecodeVal').val();
  if (middlecode.length == 0) {
    extAlert("중분류를 선택하여 주십시오.");
    return;
  }

  var smallcode = $('#SmallcodeVal').val();
  if (smallcode.length == 0) {
    extAlert("소분류를 선택하여 주십시오.");
    return;
  }

  var itemcode = $('#ItemCodeVal').val();
  if (itemcode.length == 0) {
    extAlert("품목을 선택하여 주십시오.");
    return;
  }

  //      var sortorder = Ext.getStore(gridnms["store.40"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.40"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.40"]).getById(Ext.getCmp(gridnms["views.price"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.price"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RN * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RN", sortorder);

  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("ITEMCODE", $('#ItemCodeVal').val());
  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
  model.set("EFFECTIVEENDDATE", "4999-12-31");

  //   store.insert(Ext.getStore(gridnms["store.40"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.40']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.40"], gridnms["views.price"], startPoint, 1);
};

function btnSav40Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount3 = Ext.getStore(gridnms["store.40"]).count();

  for (var k = 0; k < mcount3; k++) {
    var model = Ext.getStore(gridnms["store.40"]).data.items[k].data;
    var header = [],
    gubun = null;

    var itemcode = model.UNITPRICEA + "";
    if (itemcode.length == 0) {
      header.push("단가");
      count++;
    }

    var itemname = model.EFFECTIVESTARTDATE + "";
    if (itemname.length == 0) {
      header.push("시작일자");
      count++;
    }

    var useyn = model.EFFECTIVEENDDATE + "";
    if (useyn.length == 0) {
      header.push("종료일자");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    Ext.getStore(gridnms["store.40"]).sync({
      success: function (batch, options) {
        var reader = batch.proxy.getReader();

        msg = reader.rawData.msg;
        extAlert(msg);

        Ext.getStore(gridnms["store.40"]).load();
      },
      failure: function (batch, options) {
        msg = batch.operations[0].error;
        extAlert(msg);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnRef40Click(button, e, eOpts) {
  Ext.getStore(gridnms["store.40"]).load();
};

function btnDel40Click(o, e) {
  extGridDel(gridnms["store.40"], gridnms["panel.40"]);
};

var gridBigarea, gridMiddlearea, gridSmallarea, gridItemarea, gridItemPricearea;
function setExtGrid() {
  // 1. 대분류
  setExtGrid_Big();

  // 2. 중분류
  //   setTimeout(function () {
  setExtGrid_Middle();
  //   }, 300);

  // 3. 소분류
  //   setTimeout(function () {
  setExtGrid_Small();
  //   }, 600);

  // 4. 품목
  //   setTimeout(function () {
  setExtGrid_Item();
  //   }, 900);

  //   setTimeout(function () {
  setExtGrid_Price();
  //   }, 1200);

  Ext.EventManager.onWindowResize(function (w, h) {
    gridBigarea.updateLayout();
    //     setTimeout(function () {
    gridMiddlearea.updateLayout();
    //     }, 300);

    //     setTimeout(function () {
    gridSmallarea.updateLayout();
    //     }, 600);

    //     setTimeout(function () {
    gridItemarea.updateLayout();
    //     }, 900);

    //     setTimeout(function () {
    gridItemPricearea.updateLayout();
    //     }, 1200);
  });
}

function setExtGrid_Big() {
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
            pageSize: 999999, // gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.1"],
              timeout: gridVals.timeout,
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
                groupcode: "${searchVO.GROUPCODE}",
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
      BigclassGrid: '#BigclassGrid',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    btnAdd1Click: btnAdd1Click,
    btnSav1Click: btnSav1Click,
    btnRef1Click: btnRef1Click,
    onBigclassClick: onBigclassClick,
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
        height: 222,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'BigclassGrid',
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
                var editDisableCols = ["BIGCODE"];
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

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.bigclass"],
    stores: gridnms["stores.bigclass"],
    views: gridnms["panel.1"],
    controllers: gridnms["controller.1"],

    launch: function () {
      gridBigarea = Ext.create(gridnms["panel.1"], {
          renderTo: 'gridBigArea'
        });
    },
  });
}

function setExtGrid_Middle() {
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
            pageSize: 999999, // gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.2"],
              timeout: gridVals.timeout,
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
                groupcode: "${searchVO.GROUPCODE}",
                bigcode: "${searchVO.BIGCODE}",
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
      MiddleclassGrid: '#MiddleclassGrid',
    },
    stores: [gridnms["store.2"]],
    control: items["btns.ctr.2"],

    btnAdd2Click: btnAdd2Click,
    btnSav2Click: btnSav2Click,
    btnRef2Click: btnRef2Click,
    onMiddleclassClick: onMiddleclassClick
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
        height: 222,
        border: 2,
        scrollable: true,
        columns: fields["columns.2"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'MiddleclassGrid',
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
                var editDisableCols = ["MIDDLECODE"];
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
      gridMiddlearea = Ext.create(gridnms["panel.2"], {
          renderTo: 'gridMiddleArea'
        });
    },
  });
}

function setExtGrid_Small() {
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
            pageSize: 999999, // gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.3"],
              timeout: gridVals.timeout,
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
                groupcode: "${searchVO.GROUPCODE}",
                bigcode: "${searchVO.BIGCODE}",
                middlecode: "${searchVO.MIDDLECODE}",
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
      SmallclassGrid: '#SmallclassGrid',
    },
    stores: [gridnms["store.3"]],
    control: items["btns.ctr.3"],

    btnAdd3Click: btnAdd3Click,
    btnSav3Click: btnSav3Click,
    btnRef3Click: btnRef3Click,
    onSmallclassClick: onSmallclassClick
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
        height: 222,
        border: 2,
        scrollable: true,
        columns: fields["columns.3"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'SmallclassGrid',
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
                var editDisableCols = ["SMALLCODE"];
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
      gridSmallarea = Ext.create(gridnms["panel.3"], {
          renderTo: 'gridSmallArea'
        });
    },
  });
}

function setExtGrid_Item() {
  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"]
  });

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"]
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"]
  });

  Ext.define(gridnms["model.7"], {
    extend: Ext.data.Model,
    fields: fields["model.7"]
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
                groupcode: "${searchVO.GROUPCODE}",
                bigcode: "${searchVO.BIGCODE}",
                middlecode: "${searchVO.MIDDLECODE}",
                smallcode: "${searchVO.SMALLCODE}",
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
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
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'UOM',
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
              type: 'ajax',
              url: "<c:url value='/searchCustomernameLov.do' />",
              timeout: gridVals.timeout,
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                USEYN: 'Y',
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
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'ITEM_TYPE',
                GROUPCD: '${searchVO.GROUPCODE}',
                ITEMTYPE: '${searchVO.GROUPCODE}',
              },
              reader: gridVals.reader,
            }
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

    btnAdd4Click: btnAdd4Click,
    btnSav4Click: btnSav4Click,
    btnRef4Click: btnRef4Click,
    onItemClick: onItemClick,
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
        height: 384,
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
                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 150) {
                    column.width = 150;
                  }
                }

                if (column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 120) {
                    column.width = 120;
                  }
                }

                if (column.dataIndex.indexOf('REMARKS') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 160) {
                    column.width = 160;
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
                var editDisableCols = ["RN"];
                var isNew = ctx.record.phantom || false;
                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                  return false;
                else {
                  return true;
                }
              }
            },
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
      gridItemarea = Ext.create(gridnms["panel.4"], {
          renderTo: 'gridItemArea'
        });
    },
  });
}

function setExtGrid_Price() {
  Ext.define(gridnms["model.40"], {
    extend: Ext.data.Model,
    fields: fields["model.40"]
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
              type: 'ajax',
              api: items["api.40"],
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
                groupcode: "${searchVO.GROUPCODE}",
                bigcode: "${searchVO.BIGCODE}",
                middlecode: "${searchVO.MIDDLECODE}",
                smallcode: "${searchVO.SMALLCODE}",
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.40"], {
    extend: Ext.app.Controller,
    refs: {
      priceGrid: '#priceGrid',
    },
    stores: [gridnms["store.40"]],
    control: items["btns.ctr.40"],

    btnAdd40Click: btnAdd40Click,
    btnDel40Click: btnDel40Click,
    btnSav40Click: btnSav40Click,
    btnRef40Click: btnRef40Click,
  });

  Ext.define(gridnms["panel.40"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.40"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.40"],
        id: gridnms["panel.40"],
        store: gridnms["store.40"],
        height: 384,
        border: 2,
        scrollable: true,
        columns: fields["columns.40"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'priceGrid',
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = ctx.record;
                var editDisableCols = [];
                editDisableCols.push("UNITPRICEA");

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
        dockedItems: items["docked.40"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.price"],
    stores: gridnms["stores.price"],
    views: gridnms["panel.40"],
    controllers: gridnms["controller.40"],

    launch: function () {
      gridItemPricearea = Ext.create(gridnms["panel.40"], {
          renderTo: 'gridItemPriceArea'
        });
    },
  });
}

function fn_search() {
  var sparams = {
    orgid: $("#searchOrgId").val(),
    companyid: $("#searchCompanyId").val(),
    groupcode: "${searchVO.GROUPCODE}",
    bigcode: "${searchVO.BIGCODE}",
    middlecode: "${searchVO.MIDDLECODE}",
    smallcode: "${searchVO.SMALLCODE}",
    itemcode: $("#searchItemcd").val(),
  };

  extGridSearch(sparams, gridnms["store.1"]);
  setTimeout(function () {
    extGridSearch(sparams, gridnms["store.2"]);
  }, 300);

  setTimeout(function () {
    extGridSearch(sparams, gridnms["store.3"]);
  }, 600);

  setTimeout(function () {
    extGridSearch(sparams, gridnms["store.4"]);
  }, 900);

  setTimeout(function () {
    extGridSearch(sparams, gridnms["store.40"]);
  }, 1200);
}

function fn_excel_download() {
  var orgid = $('#searchOrgId option:selected').val();
  var companyid = $('#searchCompanyId option:selected').val();
  var itemcode = $("#searchItemcd").val();
  var title = "품목관리_치공구";

  go_url("<c:url value='/item/tool/ExcelDownload.do?ORGID='/>" + orgid + ""
     + "&COMPANYID=" + companyid + ""
     + "&ITEMCODE=" + itemcode + ""
     + "&GROUPCODE=" + "${searchVO.GROUPCODE}" + ""
     + "&TITLE=" + title + "");
}

function setLovList() {
  //품명 LOV
  $("#searchItemnm")
  .bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      $("#searchOrdernm").val("");
      $("#searchItemcd").val("");
      //        $("#searchItemnm").val("");
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
      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        TOOLGUBUN: 'ITEMNAME',
        //           ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.ITEMNAME + ', ' + m.ORDERNAME,
              value: m.ITEMCODE,
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
      $("#searchItemcd").val(o.item.ITEMCODE);
      $("#searchItemnm").val(o.item.ITEMNAME);
      $("#searchOrdernm").val(o.item.ORDERNAME);
      return false;
    }
  });

  //품번 LOV
  $("#searchOrdernm")
  .bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      //          $("#searchOrdernm").val("");
      $("#searchItemcd").val("");
      $("#searchItemnm").val("");
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
      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        TOOLGUBUN: 'ORDERNAME',
        //           ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.ORDERNAME + ', ' + m.ITEMNAME,
              value: m.ITEMCODE,
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
      $("#searchItemcd").val(o.item.ITEMCODE);
      $("#searchItemnm").val(o.item.ITEMNAME);
      $("#searchOrdernm").val(o.item.ORDERNAME);
      return false;
    }
  });
}

function Upper(e, r) {
  r.value = r.value.toUpperCase();
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
                <input type="hidden" id="GroupcodeVal" value="${searchVO.GROUPCODE}" />
                <input type="hidden" id="BigcodeVal" value="${searchVO.BIGCODE}" />
                <input type="hidden" id="MiddlecodeVal" value="${searchVO.MIDDLECODE}" />
                <input type="hidden" id="SmallcodeVal" value="${searchVO.SMALLCODE}" />
                <input type="hidden" id="ItemCodeVal" />
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field" style="margin-bottom: 5px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <div>
                    <table class="tbl_type_view" border="1" style="margin-top: 10px;">
                        <colgroup>
                            <col width="120px">
                            <col>
                            <col width="120px">
                            <col>
                        </colgroup>
                        <tr style="height: 34px;">
                            <td colspan="4">
                                <div class="buttons" style="float: right; margin-top: 3px;">
                                    <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                    <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
                                </div>
                            </td>
                        </tr>
                        <tr style="height: 34px;">
                            <th class="required_text">사업장</th>
                            <td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 80%;">
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
                            </select></td>
                            <th class="required_text">공장</th>
                            <td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 80%;">
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
                            </select></td>
                        </tr>
                        <tr style="height: 34px;">
                                <th class="required_text">품번</th>
                                <td>
                                      <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 80%;" />
                                      <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                </td>
                                <th class="required_text">품명</th>
                                <td>
                                      <input type="text" id="searchItemnm" name="searchItemnm" class="input_center" onkeyup="Upper(event,this)" style="width: 80%;">
                                </td>
                        </tr>
                </table>

                <table style="width: 100%; margin-top: 15px;">
                    <tr>
                        <td style="width: 34%;"><div class="subConTit3">대분류</div></td>
                        <td style="width: 33%;"><div class="subConTit3">중분류</div></td>
                        <td style="width: 33%;"><div class="subConTit3">소분류</div></td>
                    </tr>
                </table>
                <div id="gridBigArea" style="width: 33%; margin-right: 1%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
                <div id="gridMiddleArea" style="width: 32%; margin-right: 1%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
                <div id="gridSmallArea" style="width: 33%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>

                <div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 67%;"><div class="subConTit3" style="margin-top: 10px;">품목</div></td>
                            <td style="width: 33%;"><div class="subConTit3" style="margin-top: 10px;">단가List관리</div></td>
                        </tr>
                    </table>
                    <div id="gridItemArea" style="width: 66%; margin-right: 1%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                    <div id="gridItemPriceArea" style="width: 33%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                </div>
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