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

	  $("#gridPopup3Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  calender($('#searchShipFrom, #searchShipTo,#searchConfirmFrom, #searchConfirmTo'));

	  $('#searchShipFrom, #searchShipTo,#searchConfirmFrom, #searchConfirmTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchShipFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchShipTo").val(getToDay("${searchVO.dateTo}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	     <%--상태 option 변경--%>
	    fn_option_change('OM', 'SHIP_GUBUN', 'searchShipGubun');

	  });

	  gridnms["app"] = "order";

	}

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  setValues_Master();
	  setValues_Detail();
	  setValues_popup3(); // 입고제품 불러오기
	}

	function setValues_Master() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["grid.1"] = "ShipPlanRegist";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.viewer"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.viewer"].push(gridnms["model.1"]);

	  gridnms["stores.viewer"].push(gridnms["store.1"]);

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
	      name: 'SHIPNO',
	    }, {
	      type: 'string',
	      name: 'CONFIRMYN',
	    }, {
	      type: 'string',
	      name: 'CONFIRMYNNAME',
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
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'number',
	      name: 'SUMQTY',
	    }, {
	      type: 'number',
	      name: 'TRIPQTY',
	    }, {
	      type: 'number',
	      name: 'PLT',
	    }, {
	      type: 'date',
	      name: 'SHIPDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'CONFIRMDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUN',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      menuDisabled: true,
	      sortable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      text: '',
	      width: 70,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "완료",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var id = record.get("CONFIRMYN");
	          if (id != "N") {
	            extAlert("이미 완료처리가 되어 있습니다. 데이터를 확인 하세요.");
	            return;
	          }
	          fn_appr(record.data);
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
	        }
	      }
	    }, {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 45,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'SHIPNO',
	      text: '출하계획번호',
	      xtype: 'gridcolumn',
	      width: 105,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      align: "left",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하계획수량',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SUMQTY',
	      text: '출하수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TRIPQTY',
	      text: '부족수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var trip = value;
	        if (trip < 0) {
	          trip = 0;
	        }
	        return Ext.util.Format.number(trip, '0,000');
	      },
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하계획일',
	      xtype: 'datecolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'CONFIRMDATE',
	      text: '완료일',
	      xtype: 'datecolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      //      }, {
	      //        menuDisabled: true,
	      //        sortable: false,
	      //        xtype: 'widgetcolumn',
	      //        stopSelection: true,
	      //        text: '',
	      //        width: 70,
	      //        style: 'text-align:center',
	      //        align: "center",
	      //        widget: {
	      //          xtype: 'button',
	      //          _btnText: "이월",
	      //          defaultBindProperty: null, //important
	      //          handler: function (widgetColumn) {
	      //            var record = widgetColumn.getWidgetRecord();
	      //            fn_nextval(record.data);
	      //          },
	      //          listeners: {
	      //            beforerender: function (widgetColumn) {
	      //              var record = widgetColumn.getWidgetRecord();
	      //              widgetColumn.setText(widgetColumn._btnText);
	      //            }
	      //          }
	      //        }
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CONFIRMYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/order/ship/ShipOrderRegist.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#MasterList": {
	      itemclick: 'onShippingClick'
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
	}

	function onShippingClick(dataview, record, item, index, e, eOpts) {
	  $("#itemcode").val(record.data.ITEMCODE);
	  $("#shipno").val(record.data.SHIPNO);
	  $("#confirmyn").val(record.data.CONFIRMYN);

	  var orgid = $('#searchOrgId').val();
	  var companyid = $('#searchCompanyId').val();
	  var shipno = $("#shipno").val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SHIPNO: shipno,
	  };

	  extGridSearch(sparams, gridnms["store.2"]);
	}

	function setValues_Detail() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "ShipPlanRegistDetail";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.detail"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.detail"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.detail"].push(gridnms["store.2"]);

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
	      name: 'SHIPNO',
	    }, {
	      type: 'string',
	      name: 'SHIPSEQ',
	    }, {
	      type: 'string',
	      name: 'SHIPTYPE',
	    }, {
	      type: 'string',
	      name: 'SHIPTYPENAME',
	    }, {
	      type: 'date',
	      name: 'SHIPDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'SAVEYN',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'LOTNO',
	    }, {
	      type: 'number',
	      name: 'LOTCNT',
	    }, ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 40,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 45,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'SHIPNO',
	      text: '출하계획번호',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하일자',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: true,
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
	      dataIndex: 'SHIPQTY',
	      text: '출하수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      resizable: false,
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
	        maxLength: '9',
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'LOTNO',
	      text: '생산 LOT',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'LOTCNT',
	      text: 'PLT',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
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
	        maxLength: '9',
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	      },
	      renderer: function (value, meta, record) {
	        //                 meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	    }, {
	      menuDisabled: true,
	      sortable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      text: '',
	      width: 120,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "출하검사등록",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var saveyn = record.data.SAVEYN;
	          if (saveyn != "N") {
	            var seq = record.data.SHIPSEQ;
	            $('#shipseq').val(seq);

	            var column = 'master';
	            var url = "<c:url value='/order/ship/ShipInspectionRegist.do'/>";
	            var target = '_self';

	            fn_popup_url(column, url, target);
	          } else {
	            extAlert("등록되지 않은 출하 내역입니다.<br/>저장 후 다시 확인해주세요.");
	            return;
	          }
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
	        }
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
	      dataIndex: 'SHIPSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SAVEYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/order/ship/ShipOrderDetail.do' />"
	  });
	  $.extend(items["api.2"], {
	    create: "<c:url value='/insert/order/ship/ShipOrderRegist.do' />"
	  });
	  $.extend(items["api.2"], {
	    update: "<c:url value='/update/order/ship/ShipOrderRegist.do' />"
	  });
	  $.extend(items["api.2"], {
	    destroy: "<c:url value='/delete/order/ship/ShipOrderRegist.do' />"
	  });

	  items["btns.2"] = [];
	  items["btns.2"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef2"
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "입고제품 불러오기",
	    itemId: "btnSel2"
	  });

	  items["btns.ctr.2"] = {};
	  $.extend(items["btns.ctr.2"], {
	    "#btnSav2": {
	      click: 'btnSav2'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnDel2": {
	      click: 'btnDel2'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnRef2": {
	      click: 'btnRef2'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnSel2": {
	      click: 'btnSel2'
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
	}

	function btnRef2(o, e) {
	  Ext.getStore(gridnms["store.2"]).load();
	};

	function btnSav2(o, e) {
	  // 저장시 필수값 체크
	  var count1 = Ext.getStore(gridnms["store.2"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
	      var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	      var shipdate = model2.data.SHIPDATE;
	      var shiptype = model2.data.SHIPTYPE;
	      var shipqty = model2.data.SHIPQTY;

	      if (shipdate == "" || shipdate == undefined) {
	        header.push("출하일자");
	        count++;
	      }

	      if (shiptype == "" || shiptype == undefined) {
	        header.push("구분");
	        count++;
	      }

	      if (shipqty == "" || shipqty == undefined) {
	        header.push("출하수량");
	        count++;
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    }
	  } else {
	    extAlert("[저장] 출하지시 투입 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  } else {
	    Ext.getStore(gridnms["store.2"]).sync({
	      success: function (batch, options) {
	        extAlert(msgs.noti.save, gridnms["store.2"]);
	        Ext.getStore(gridnms["store.1"]).load();
	        setTimeout(function () {
	          Ext.getStore(gridnms["store.2"]).load();
	        }, 200);
	      },
	      failure: function (batch, options) {
	        extAlert(batch.exceptions[0].error, gridnms["store.2"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel2(o, e) {
	  var store = this.getStore(gridnms["store.2"]);
	  var record = Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0];
	  var count = 0;

	  var confirmyn = $("#confirmyn").val();

	  if (confirmyn == "Y") {
	    Ext.Msg.alert('실패', '완료상태의 지시에 대해서는 삭제가 불가능 합니다.');
	    return;
	  }

	  if (record === undefined) {
	    return;
	  }

	   <%--제약조건 추가 - 상태 값이 'N' 일 경우에만 삭제 가능--%>
	  if (count == 0) {
	    Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        store.remove(record);
	        Ext.getStore(gridnms["store.2"]).sync();

	        Ext.getStore(gridnms["store.1"]).load();
	        setTimeout(function () {
	          Ext.getStore(gridnms["store.2"]).load();
	        }, 200);
	      }
	    });
	  }
	};

	var popcount2 = 0, popupclick2 = 0;
	function btnSel2(btn) {

	  var clickcheck = $("#shipno").val();
	  if (clickcheck === "") {
	    Ext.Msg.alert('실패', '출하계획을 먼저 선택 해 주십시오.');
	    return;
	  }

	  var confirmyn = $("#confirmyn").val();
	  if (confirmyn == "Y") {
	    Ext.Msg.alert('실패', '완료상태의 지시에 대해서는 입력이 불가능 합니다.');
	    return;
	  }

	  // 입고제품 불러오기 팝업
	  var width = 808; // 가로
	  var height = 640; // 세로
	  var title = "입고제품 불러오기 Pop up";

	  var check = true;
	  popupclick2 = 0;

	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupWarehousingtFrom').val("");
	    $('#popupWarehousingTo').val("");
	    Ext.getStore(gridnms["store.14"]).removeAll();

	    win3 = Ext.create('Ext.window.Window', {
	        width: width,
	        height: height,
	        title: title,
	        layout: 'fit',
	        header: true,
	        draggable: true,
	        resizable: false,
	        maximizable: false,
	        closeAction: 'hide',
	        modal: true,
	        closable: true,
	        buttonAlign: 'center',
	        items: [{
	            xtype: 'gridpanel',
	            selType: 'cellmodel',
	            itemId: gridnms["panel.14"],
	            id: gridnms["panel.14"],
	            store: gridnms["store.14"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.14"],
	            viewConfig: {
	              itemId: 'WarehousingPopup',
	              trackOver: true,
	              loadMask: true,
	            },
	            plugins: [{
	                ptype: 'bufferedrenderer',
	                trailingBufferZone: 20, // #1
	                leadingBufferZone: 20, // #2
	                synchronousRender: false,
	                numFromEdge: 19,
	              }
	            ],
	            dockedItems: items["docked.14"],
	          }
	        ],
	        tbar: [
	          '입고일자', {
	            xtype: 'datefield',
	            name: 'searchWarehousingFrom',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            width: 120,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupWarehousingFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupWarehousingFrom').val("");
	                  } else {
	                    var popupWarehousingFrom = Ext.Date.format(result, 'Y-m-d');
	                    var popupWarehousingTo = $('#popupWarehousingTo').val();

	                    if (popupWarehousingTo === "") {
	                      $('#popupWarehousingFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupWarehousingFrom, popupWarehousingTo);
	                      if (diff < 0) {
	                        extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupWarehousingFrom').val("");
	                        return;
	                      } else {
	                        $('#popupWarehousingFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          }, ' ~ ', {
	            xtype: 'datefield',
	            name: 'searchWarehousingTo',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            width: 120,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupWarehousingTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupWarehousingTo').val("");
	                  } else {
	                    var popupWarehousingFrom = $('#popupWarehousingFrom').val();
	                    var popupWarehousingTo = Ext.Date.format(result, 'Y-m-d');

	                    if (popupWarehousingFrom === "") {
	                      $('#popupWarehousingTo').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupWarehousingFrom, popupWarehousingTo);
	                      if (diff < 0) {
	                        extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupWarehousingTo').val("");
	                        return;
	                      } else {
	                        $('#popupWarehousingTo').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          },
	          '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                WAREFROM: $('#popupWarehousingFrom').val(),
	                WARETO: $('#popupWarehousingTo').val(),
	                ITEMCODE: $('#itemcode').val(),
	              };

	              extGridSearch(sparams3, gridnms["store.14"]);
	            }
	          }, {
	            text: '전체선택/해제',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 전체선택 버튼 핸들러
	              var count4 = Ext.getStore(gridnms["store.14"]).count();
	              var checkTrue = 0,
	              checkFalse = 0;

	              if (popupclick2 == 0) {
	                popupclick2 = 1;
	              } else {
	                popupclick2 = 0;
	              }
	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.14"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];

	                var chk = model4.data.CHK;

	                if (popupclick2 == 1) {
	                  // 체크 상태로
	                  model4.set("CHK", true);
	                  checkFalse++;
	                } else {
	                  model4.set("CHK", false);
	                  checkTrue++;
	                }

	              }
	              if (checkTrue > 0) {
	                console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
	              }
	              if (checkFalse > 0) {
	                console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
	              }
	            }
	          }, {
	            text: '적용',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 적용 버튼 핸들러
	              var count4 = Ext.getStore(gridnms["store.14"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.14"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
	                var chk = model4.get("CHK");

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("제품을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count4 == 0) {
	                console.log("[적용] 제품 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count4; j++) {
	                  Ext.getStore(gridnms["store.14"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(j));
	                  var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.2"]);
	                    var store = Ext.getStore(gridnms["store.2"]);

	                    // 순번
	                    model.set("SHIPNO", $("#shipno").val());
	                    model.set("SHIPSEQ", Ext.getStore(gridnms["store.2"]).count() + 1);

	                    model.set("RN", Ext.getStore(gridnms["store.2"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ORGID", model4.data.ORGID);
	                    model.set("COMPANYID", model4.data.COMPANYID);
	                    model.set("WORKORDERID", model4.data.WORKORDERID);
	                    model.set("WORKORDERSEQ", model4.data.WORKORDERSEQ);
	                    model.set("LOTNO", model4.data.WORKORDERID);
	                    model.set("SHIPQTY", model4.data.WAREHOUSINGQTY);
	                    model.set("SHIPDATE", "${searchVO.dateSys}");
	                    model.set("LOTCNT", 1);

	                    // 오늘날짜 구하기
	                    var date = new Date();
	                    var year = date.getFullYear();
	                    var month = new String(date.getMonth() + 1);
	                    var day = new String(date.getDate());

	                    // 한자리수일 경우 0을 채워준다.
	                    if (month.length == 1) {
	                      month = "0" + month;
	                    }
	                    if (day.length == 1) {
	                      day = "0" + day;
	                    }
	                    // 오늘 날짜 구하기 끝

	                    model.set("SHIPDATE", year + "-" + month + "-" + day);
	                    model.set("SHIPTYPENAME", '정상');
	                    model.set("SHIPTYPE", '01');
	                    model.set("SAVEYN", 'N');

	                    // 그리드 적용 방식
	                    store.add(model);

	                    checktemp++;
	                    popcount2++;
	                  };
	                }

	                Ext.getCmp(gridnms["panel.2"]).getView().refresh();

	              }

	              if (checktemp > 0) {
	                popcount2 = 0;
	                win3.close();

	                $("#gridPopup3Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win3.show();

	    $('#popupWarehousingFrom').val("${searchVO.dateFrom}");
	    $('#popupWarehousingTo').val("${searchVO.dateSys}");
	    var popfrom = $('#popupWarehousingFrom').val();
	    var popto = $('#popupWarehousingTo').val();
	    $('input[name=searchWarehousingFrom]').val(popfrom);
	    $('input[name=searchWarehousingTo]').val(popto);
	  } else {
	    extAlert("생산LOT 등록 하실 경우에만 입고제품 불러오기가 가능합니다.");
	    return;
	  }
	}

	function setValues_popup3() {
	  gridnms["models.popup3"] = [];
	  gridnms["stores.popup3"] = [];
	  gridnms["views.popup3"] = [];
	  gridnms["controllers.popup3"] = [];

	  gridnms["grid.14"] = "WarehousingPopup";

	  gridnms["panel.14"] = gridnms["app"] + ".view." + gridnms["grid.14"];
	  gridnms["views.popup3"].push(gridnms["panel.14"]);

	  gridnms["controller.14"] = gridnms["app"] + ".controller." + gridnms["grid.14"];
	  gridnms["controllers.popup3"].push(gridnms["controller.14"]);

	  gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

	  gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

	  gridnms["models.popup3"].push(gridnms["model.14"]);

	  gridnms["stores.popup3"].push(gridnms["store.14"]);

	  fields["model.14"] = [{
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'string',
	      name: 'WAREHOUSINGNO',
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
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'date',
	      name: 'WAREHOUSINGDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'WAREHOUSINGQTY',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["columns.14"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 45,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      align: "left",
	    }, {
	      dataIndex: 'WORKORDERID',
	      text: '생산LOT',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      align: "center",
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      align: "center",
	    }, {
	      dataIndex: 'WAREHOUSINGQTY',
	      text: '수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 40,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WAREHOUSINGNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WAREHOUSINGDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'REMARKS',
	      xtype: 'hidden',
	    }, ];

	  items["api.14"] = {};
	  $.extend(items["api.14"], {
	    read: "<c:url value='/searchWarehousingListLov.do' />"
	  });

	  items["btns.14"] = [];

	  items["btns.ctr.14"] = {};

	  items["dock.paging.14"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.14"],
	  };

	  items["dock.btn.14"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.14"],
	    items: items["btns.14"],
	  };

	  items["docked.14"] = [];
	}

	function fn_appr(val) {
	  console.log("확정 메서드 시작 : " + val);
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var url = "",
	  url1 = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (gridcount == 0) {
	    extAlert("[확정]<br/> 확정 지시가 선택 되지 않았습니다.");
	    return false;
	  }

	  url = "<c:url value='/appr/order/ship/ShipOrderRegist.do' />";

	  var chk = val;
	  var chkyn = chk.CONFIRMYN;
	  var chkyn1 = chk.SHIPNO;
	  if (chkyn1.length == 0) {
	    Ext.Msg.alert('완료', '저장되지 않은 데이터 입니다. 저장 후 다시 처리 하세요.');
	    return;
	  }
	  if (chkyn != "N") {
	    Ext.Msg.alert('완료', '미확정 상태의 지시에 대해서만 완료 처리가 가능합니다.');
	    return;
	  }
	  if (chkyn == "N") {

	    Ext.MessageBox.confirm('완료 ', '완료 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        btnbreak = true;

	        if (statuschk == true) {

	          var params = [];
	          $.ajax({
	            url: url,
	            type: "post",
	            dataType: "json",
	            data: val,
	            success: function (data) {
	              var apprid = data.SHIPNO;

	              if (apprid.length == 0) {}
	              else {
	                var success = data.success;
	                if (success == false) {
	                  extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
	                  return;
	                } else {
	                  msg = "완료 처리 되었습니다.";
	                  extAlert(msg);
	                }
	                if (success == false) {}
	              }
	              fn_search();
	            },
	            error: ajaxError
	          });

	        } else {
	          extAlert(msg);
	          return;
	        }
	        return;
	      } else {
	        Ext.Msg.alert('완료', '완료 처리가 취소되었습니다.');
	        return;
	      }
	    });
	  } else {
	    Ext.Msg.alert('완료', '미완료상태의 지시에 대해서만 완료 처리가 가능합니다.');
	    return;
	  }
	}

	function fn_nextval(val) {
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  var sumqty = val.SUMQTY;
	  var shipqty = val.SHIPQTY;

	  if (shipqty >= sumqty) {
	    extAlert("출하수량이 출하계획수량보다 많아야 이월이 가능합니다.");
	    return;
	  }

	  var url = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (gridcount == 0) {
	    extAlert("이월처리 할 데이터가 없습니다.");
	    return false;
	  }
	  url = "<c:url value='/insert/order/ship/ShipOrderPkgStart.do' />";

	  Ext.MessageBox.confirm('이월 ', '이월처리를 하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      btnbreak = true;
	      /* 확인 버튼 클릭시 투입확정 진행 */
	      if (statuschk == true) {

	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: val,
	          success: function (data) {

	            var rscode = data.RETURNSTATUS;
	            var errmsg = data.MSGDATA;

	            if (rscode == "S") {
	              msg = "이월 처리되었습니다.";
	              extAlert(msg);
	              Ext.getStore(gridnms["store.1"]).load();
	              setTimeout(function () {
	                Ext.getStore(gridnms["store.2"]).load();
	              }, 200);
	            } else {
	              extAlert(errmsg);
	            }
	          },
	          error: ajaxError
	        });

	      } else {
	        extAlert(msg);
	        return;
	      }
	      return;
	    } else {
	      Ext.Msg.alert('이월', '이월 처리가 취소되었습니다.');
	      return;
	    }
	  });
	}

	var gridarea1, gridarea2, gridarea5;
	function setExtGrid() {
	  setExtGrid_master();
	  setExtGrid_detail();
	  setExtGrid_popup3(); // 입고제품 불러오기

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea1.updateLayout();
	    gridarea2.updateLayout();
	  });

	}

	function setExtGrid_master() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
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
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SHIPFROM: $('#searchShipFrom').val(),
	                SHIPTO: $('#searchShipTo').val(),
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
	      MasterList: '#MasterList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],
	    onShippingClick: onShippingClick,
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
	        height: 304, // 270,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'MasterList',
	          striptRows: true,
	          forceFit: true,
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
	    models: gridnms["models.viewer"],
	    stores: gridnms["stores.viewer"],
	    views: gridnms["views.viewer"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.viewer"], {
	          renderTo: 'gridViewArea'
	        });
	    },
	  });

	}

	function setExtGrid_detail() {
	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"],
	  });

	  Ext.define(gridnms["store.2"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.2"],
	            model: gridnms["model.2"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.2"],
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SHIPFROM: $('#searchShipFrom').val(),
	                SHIPTO: $('#searchShipTo').val(),
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
	      btnList: '#btnList',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

	    btnSav2: btnSav2,
	    btnDel2: btnDel2,
	    btnRef2: btnRef2,
	    btnSel2: btnSel2,
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
	        height: 184, // 199,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'btnList',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.autoResizeWidth)
	                  column.autoSize();
	              });
	            },
	          }
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

	                var editDisableCols = [];
	                var status = data.data.CONFIRMYN;
	                if (status != "N") {
	                  //                        editDisableCols.push("SHIPDATE");
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
	        dockedItems: items["docked.2"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridarea2 = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridViewDetailArea'
	        });
	    },
	  });

	}

	function setExtGrid_popup3() {
	  Ext.define(gridnms["model.14"], {
	    extend: Ext.data.Model,
	    fields: fields["model.14"],
	  });

	  Ext.define(gridnms["store.14"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.14"],
	            model: gridnms["model.14"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.14"],
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.14"], {
	    extend: Ext.app.Controller,
	    refs: {
	      WarehousingPopup: '#WarehousingPopup',
	    },
	    stores: [gridnms["store.14"]],
	  });

	  Ext.define(gridnms["panel.14"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.14"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.14"],
	        id: gridnms["panel.14"],
	        store: gridnms["store.14"],
	        height: 565,
	        border: 2,
	        scrollable: true,
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        columns: fields["columns.14"],
	        viewConfig: {
	          itemId: 'WarehousingPopup',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.14"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup3"],
	    stores: gridnms["stores.popup3"],
	    views: gridnms["views.popup3"],
	    controllers: gridnms["controller.14"],

	    launch: function () {
	      gridarea5 = Ext.create(gridnms["views.popup3"], {
	          renderTo: 'gridPopup3Area'
	        });
	    },
	  });
	}

	function fn_search() {
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var shipfrom = $('#searchShipFrom').val();
	  var shipto = $('#searchShipTo').val();
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
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    SHIPFROM: $('#searchShipFrom').val(),
	    SHIPTO: $('#searchShipTo').val(),
	    CONFIRMFROM: $('#searchConfirmFrom').val(),
	    CONFIRMTO: $('#searchConfirmTo').val(),
	    CONFIRMYN: $('#searchConfirmYn option:selected').val(),
	    SHIPGUBUN: $('#searchShipGubun option:selected').val(),
	    SHIPNO: $('#searchShipNo').val(),
	    CUSTOMERCODE: $('#searchCustomerCode').val(),
	    ITEMCODE: $('#searchItemCode').val(),
	    ITEMNAME: $('#searchItemName').val(),
	    ORDERNAME: $('#searchOrderName').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	  
	  setTimeout ( function () {
		    extGridSearch(sparams, gridnms["store.2"]);
	  }, 200);
	  
	  $('#shipno').val("");
	}

	function fn_print(val) {
	  switch (val) {
	  case "1":
	    var count = Ext.getStore(gridnms["store.2"]).count();
	    var chk_count = 0;
	    var j = 0;

	    for (var i = 0; i < count; i++) {
	      Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	      var chk = model.data.CHK;

	      if (chk == true) {
	        chk_count++;
	        j = i;
	      }
	    }

	    if (chk_count == 0) {
	      extAlert("선택된 항목이 없습니다.");
	    } else if (chk_count > 1) {
	      extAlert("하나의 항목만 선택해주세요.");
	    } else {
	      Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(j));
	      var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	      var shipno = model.data.SHIPNO;
	      $('#shipno').val(shipno);
	      var shipseq = model.data.SHIPSEQ;
	      $('#shipseq').val(shipseq);
	      var lotcnt = model.data.LOTCNT;
	      $('#lotcnt').val(lotcnt);

	      var column = 'master';
	      var url = "<c:url value='/report/ShipLotReport.pdf'/>";
	      var target = '_blank';

	      fn_popup_url(column, url, target);
	    }
	    break;
	  case "2":
	    // 출하검사성적서
	    fn_ready();
	    break;
	  default:
	    break;
	  }
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 출하계획번호 Lov
	  $("#searchShipNo").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchWorkNo").val("");
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
	      $.getJSON("<c:url value='/order/ship/searchShipNoListLov.do' />", {
	        keyword: extractLast(request.term),
	        SHIPFROM: $('#searchShipFrom').val(),
	        SHIPTO: $('#searchShipTo').val(),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.SHIPNO,
	              label: m.SHIPNO,
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
	      $("#searchShipNo").val(o.item.value);

	      return false;
	    }
	  });

	  // 거래처명 Lov
	  $("#searchCustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchCustomerName").val("");
	      $("#searchCustomerCode").val("");
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
	      $.getJSON("<c:url value='/searchCustomernameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        CUSTOMERTYPE: 'A',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
	              NAME: m.LABEL,
	              ADDRESS: m.ADDRESS,
	              FREIGHT: m.FREIGHT,
	              PHONENUMBER: m.PHONENUMBER,
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
	      $("#searchCustomerCode").val(o.item.value);
	      $("#searchCustomerName").val(o.item.NAME);

	      return false;
	    }
	  });
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
                                <li>출하관리</li>
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
		                    <input type="hidden" id="confirmyn" />
                        <input type="hidden" id="searchGroupCode" name="searchGroupCode" value="A" />
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupCustomerCode" name="popupCustomerCode" />
                        <input type="hidden" id="popupItemName" name="popupItemName" />
                        <input type="hidden" id="popupOrderName" name="popupOrderName" />
                        <input type="hidden" id="popupWarehousingFrom" name="popupWarehousingFrom" />
                        <input type="hidden" id="popupWarehousingTo" name="popupWarehousingTo" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
		                        <input type="hidden" id="shipno" name="shipno" />
		                        <input type="hidden" id="shipseq" name="shipseq" />
                            <input type="hidden" id="lotcnt" name="lotcnt" />
                            <input type="hidden" id="itemcode" name="itemcode" />
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
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
                                                <a id="btnChk2" class="btn_print" href="#" onclick="javascript:fn_print('1');">
                                                   출하바코드
                                                </a>
                                                <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print('2');">
                                                   출하검사관리대장
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">출하계획일</th>
                                        <td >
                                            <input type="text" id="searchShipFrom" name="searchShipFrom" class="input_validation input_center validate[custom[date],past[#searchShipTo]]" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchShipTo" name="searchShipTo" class="input_validation input_center validate[custom[date],future[#searchShipFrom]]" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">출하계획번호</th>
                                        <td>
                                            <input type="text" id="searchShipNo" name="searchShipNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">완료여부</th>
                                        <td>
                                            <select id="searchConfirmYn" name="searchConfirmYn" class="input_left validate[required]" style="width: 97%;">
                                                    <option value="" label="전체" />
                                                    <option value="Y" label="완료" />
                                                    <option value="N" label="미완료" />
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">거래처</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" class=""  />                                           
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName" class="input_left"  style="width: 97%;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridViewArea" style="width: 100%; margin-bottom: 15px; float: left;"></div>
                    <div id="gridViewDetailArea" style="width: 60%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup3Area" style="width: 800px; padding-top: 0px; float: left;"></div>
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>