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
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setValues_Popup();
	  setExtGrid_Popup();

	  $("#gridPopup1Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();

	  setLovList();

	});

	function setInitial() {
	  gridnms["app"] = "master";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_bom();
	  setValues_master();
	}

	function setValues_bom() {
	  gridnms["models.bom"] = [];
	  gridnms["stores.bom"] = [];
	  gridnms["views.bom"] = [];
	  gridnms["controllers.bom"] = [];

	  gridnms["grid.1"] = "BomRegister";
	  //    gridnms["grid.3"] = "itemnameLov";
	  gridnms["grid.4"] = "uomLov";
	  gridnms["grid.5"] = "warehousingLov";
	  gridnms["grid.6"] = "routing";
	  gridnms["grid.7"] = "routing_gubunLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.bom"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.bom"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  //    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];
	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
	  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
	  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
	  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  //    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];
	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
	  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
	  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
	  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];

	  gridnms["models.bom"].push(gridnms["model.1"]);
	  //    gridnms["models.bom"].push(gridnms["model.3"]);
	  gridnms["models.bom"].push(gridnms["model.4"]);
	  gridnms["models.bom"].push(gridnms["model.5"]);
	  gridnms["models.bom"].push(gridnms["model.6"]);
	  gridnms["models.bom"].push(gridnms["model.7"]);

	  gridnms["stores.bom"].push(gridnms["store.1"]);
	  //    gridnms["stores.bom"].push(gridnms["store.3"]);
	  gridnms["stores.bom"].push(gridnms["store.4"]);
	  gridnms["stores.bom"].push(gridnms["store.5"]);
	  gridnms["stores.bom"].push(gridnms["store.6"]);
	  gridnms["stores.bom"].push(gridnms["store.7"]);

	  fields["model.1"] = [{
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'string',
	      name: 'UPPERITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'WAREHOUSING',
	    }, {
	      type: 'string',
	      name: 'WAREHOUSINGNAME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGUBUN',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGUBUNNAME',
	    }, {
	      type: 'number',
	      name: 'SORTORDER',
	    }, {
	      type: 'number',
	      name: 'LEV',
	    }, {
	      type: 'number',
	      name: 'YEILDRATE',
	    }, {
	      type: 'string',
	      name: 'UOM'
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'QTY',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVESTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVEENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'ABAIL',
	    }, ];

	  //    fields["model.3"] = [{
	  //        type: 'string',
	  //        name: 'VALUE'
	  //      }, {
	  //        type: 'string',
	  //        name: 'LABEL'
	  //      }
	  //    ];

	  fields["model.4"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["model.5"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["model.6"] = [{
	      type: 'string',
	      name: 'ROUTINGNO'
	    }, {
	      type: 'string',
	      name: 'ROUTINDCODE'
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME'
	    }, {
	      type: 'string',
	      name: 'SORTORDER'
	    }
	  ];

	  fields["model.7"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["columns.1"] = [
	    // Display columns
	    {
	      dataIndex: 'SORTORDER',
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
	      editor: {
	        xtype: "textfield",
	        minValue: 1,
	        format: "0,000",
	        enforceMaxLength: true,
	        allowBlank: true,
	        maxLength: '4',
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	      },
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 300,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      //        editor: {
	      //          xtype: 'combobox',
	      //          store: gridnms["store.3"],
	      //          valueField: "ITEMNAME",
	      //          displayField: "ITEMNAME",
	      //          matchFieldWidth: false,
	      //          editable: false,
	      //          queryParam: 'keyword',
	      //          queryMode: 'local', // 'local',
	      //          allowBlank: true,
	      //          typeAhead: true,
	      //          transform: 'stateSelect',
	      //          forceSelection: false,
	      //          listeners: {
	      //            select: function (value, record, eOpts) {
	      //              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.bom"]).selModel.getSelection()[0].id);
	      //              var code = record.data.ITEMCODE;
	      //              var order = record.data.ORDERNAME;
	      //              var uom = record.data.UOM;
	      //              var uomname = record.data.UOMNAME;
	      //              var itemtype = record.data.ITEMTYPE;
	      //              var itemtypename = record.data.ITEMTYPENAME;
	      //              var itemstandard = record.data.ITEMSTANDARD;
	      //              var materialtype = record.data.MATERIALTYPE;

	      //              model.set("ITEMCODE", code);
	      //              model.set("ORDERNAME", order);
	      //              model.set("UOM", uom);
	      //              model.set("UOMNAME", uomname);
	      //              model.set("UOM", uom);
	      //              model.set("UOMNAME", uomname);
	      //              model.set("ITEMTYPE", itemtype);
	      //              model.set("ITEMTYPENAME", itemtypename);
	      //              model.set("ITEMSTANDARD", itemstandard);
	      //              model.set("MATERIALTYPE", materialtype);
	      //            },
	      //          },
	      //          listConfig: {
	      //            loadingText: '검색 중...',
	      //            emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	      //            width: 700,
	      //            getInnerTpl: function () {
	      //              return '<div>'
	      //               + '<table >'
	      //               + '<colgroup>'
	      //               + '<col width="400px">'
	      //               + '<col width="120px">'
	      //               + '<col width="100px">'
	      //               + '<col width="130px">'
	      //               + '<col width="130px">'
	      //               + '</colgroup>'
	      //               + '<tr>'
	      //               + '<td style="height: 25px; font-size: 13px; font-weight: bold;">{ITEMNAME}</td>'
	      //               + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
	      //               + '<td style="height: 25px; font-size: 13px; ">{ITEMTYPENAME}</td>'
	      //               + '<td style="height: 25px; font-size: 13px; ">{ITEMSTANDARD}</td>'
	      //               + '<td style="height: 25px; font-size: 13px; ">{MATERIALTYPE}</td>'
	      //               + '</tr>'
	      //               + '</table>'
	      //            }
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        //          meta.style = "background-color:rgb(253, 218, 255)";
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'MATERIALTYPE',
	      text: '재질',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMTYPENAME',
	      text: '유형',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.4"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: false,
	        queryParam: 'keyword',
	        queryMode: 'remote', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.bom"]).selModel.getSelection()[0].id);

	            model.set("UOM", record.data.VALUE);
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
	    }, {
	      dataIndex: 'QTY',
	      text: '소요량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
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
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 280,
	      //        flex: 1,
	      hidden: false,
	      sortable: false,
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
	      dataIndex: 'UPPERITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LEV',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WAREHOUSING',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/bom/BomRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/bom/BomRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/bom/BomRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/bom/BomRegister.do' />"
	  });

	  items["btns.1"] = [];
	  //    items["btns.1"].push({
	  //      xtype: "button",
	  //      text: "추가",
	  //      itemId: "btnAdd1",
	  //    });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav1",
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1",
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef1",
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "자재 / 반가공품 불러오기",
	    itemId: "btnSel1",
	  });

	  items["btns.ctr.1"] = {};
	  //    $.extend(items["btns.ctr.1"], {
	  //      "#btnAdd1": {
	  //        click: 'btnAdd1'
	  //      }
	  //    });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSel1": {
	      click: 'btnSel1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#bomClick": {
	      itemclick: 'bomClick'
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

	//  function btnAdd1(o, e) {
//	          var orgid = $('#searchOrgId').val();
//	          var companyid = $('#searchCompanyId').val();
//	          var itemcode = $('#searchItemcd').val();

//	          if (!fn_validation()) {
//	            return;
//	          }

//	          var model = Ext.create(gridnms["model.1"]);
//	          var store = this.getStore(gridnms["store.1"]);

//	          var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
//	          model.set("SORTORDER", sortorder);
//	          model.set("ORGID", orgid);
//	          model.set("COMPANYID", companyid);
//	          model.set("UPPERITEMCODE", itemcode);
//	          model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
//	          model.set("EFFECTIVEENDDATE", "4999-12-31");

//	          store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	//  }

	function btnSav1(o, e) {
	  Ext.getStore(gridnms["store.1"]).sync({
	    success: function (batch, options) {
	      //        extAlert(msgs.noti.save, gridnms["store.1"]);
	      var reader = batch.proxy.getReader();
	      extAlert(reader.rawData.msg, gridnms["store.1"]);

	      //        fn_search();
	      Ext.getStore(gridnms["store.1"]).load();
	    },
	    failure: function (batch, options) {
	      //        extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	      var reader = batch.proxy.getReader();
	      extAlert(reader.rawData.msg, gridnms["store.1"]);
	    },
	    callback: function (batch, options) {},
	  });
	};

	function btnDel1(o, e) {
	  extGridDel(gridnms["store.1"], gridnms["panel.1"]);
	}

	function btnRef1(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	var popcount = 0, popupclick = 0;
	function btnSel1(btn) {
	  var itemcode = $('#searchItemcd').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (itemcode === "") {
	    header.push("품번/품명");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미선택]<br/>" + header + " 항목을 선택해주세요.");
	    return false;
	  }

	  var width = 1250; // 가로
	  var height = 640; // 500; // 세로
	  var title = "자재 / 반가공품 불러오기 Popup";
	  popupclick = 0;

	  // 완료 외 상태에서만 팝업 표시하도록 처리
	  $('#popupOrgId').val($('#searchOrgId option:selected').val());
	  $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	  $('#popupItemCode').val("");
	  $('#popupItemName').val("");
	  $('#popupOrderName').val("");
	  $('#popupItemType').val("");
	  $('#popupItemTypeName').val("");
	  Ext.getStore(gridnms['store.10']).removeAll();

	  win11 = Ext.create('Ext.window.Window', {
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
	          itemId: gridnms["panel.10"],
	          id: gridnms["panel.10"],
	          store: gridnms["store.10"],
	          height: '100%',
	          border: 2,
	          scrollable: true,
	          frameHeader: true,
	          columns: fields["columns.10"],
	          viewConfig: {
	            itemId: 'onMypopClick'
	          },
	          plugins: 'bufferedrenderer',
	          dockedItems: items["docked.10"],
	        }
	      ],
	      tbar: [
	        '품번', {
	          xtype: 'textfield',
	          name: 'searchOrderName1',
	          clearOnReset: true,
	          hideLabel: true,
	          width: 150,
	          editable: true,
	          allowBlank: true,
	          listeners: {
	            scope: this,
	            buffer: 50,
	            change: function (value, nv, ov, e) {
	              value.setValue(nv.toUpperCase());
	              var result = value.getValue();

	              $('#popupOrderName').val(result);
	            },
	          },
	        },
	        '품명', {
	          xtype: 'textfield',
	          name: 'searchItemName1',
	          clearOnReset: true,
	          hideLabel: true,
	          width: 220,
	          editable: true,
	          allowBlank: true,
	          listeners: {
	            scope: this,
	            buffer: 50,
	            change: function (value, nv, ov, e) {
	              value.setValue(nv.toUpperCase());
	              var result = value.getValue();

	              $('#popupItemName').val(result);
	            },
	          },
	        },
	        '유형', {
	          xtype: 'combo',
	          name: 'searchItemTypeName',
	          clearOnReset: true,
	          hideLabel: true,
	          width: 120,
	          store: gridnms["store.11"],
	          valueField: "LABEL",
	          displayField: "LABEL",
	          matchFieldWidth: true,
	          editable: true,
	          queryParam: 'keyword',
	          queryMode: 'local', // 'remote',
	          allowBlank: true,
	          typeAhead: false,
	          triggerAction: 'all',
	          selectOnFocus: false,
	          applyTo: 'local-states',
	          forceSelection: false,
	          listeners: {
	            scope: this,
	            buffer: 50,
	            select: function (value, record) {
	              $('#popupItemType').val(record.data.VALUE);
	              $('#popupItemTypeName').val(record.data.LABEL);

	              //                  var sparams11 = {
	              //                    ORGID: $('#popupOrgId').val(),
	              //                    COMPANYID: $('#popupCompanyId').val(),
	              //                    BIGCD: 'CMM',
	              //                    MIDDLECD: 'ITEM_TYPE',
	              //                    GUBUN: 'ITEM_TYPE',
	              //                    BOMGUBUN: "Y",
	              //                  };

	              //                  extGridSearch(sparams11, gridnms["store.11"]);
	            },
	            change: function (value, nv, ov, e) {
	              var result = value.getValue();

	              if (ov != nv) {
	                if (!isNaN(result)) {
	                  $('#popupItemType').val("");
	                  $('#popupItemTypeName').val("");
	                }
	              }
	            },
	          }
	        },
	        '->', {
	          text: '조회',
	          scope: this,
	          handler: function () {
	            var sparams10 = {
	              ORGID: $('#popupOrgId').val(),
	              COMPANYID: $('#popupCompanyId').val(),
	              ITEMNAME: $('#popupItemName').val(),
	              ORDERNAME: $('#popupOrderName').val(),
	              ITEMTYPE: $('#popupItemType').val(),
	              BOMGUBUN: "Y",
	            };

	            extGridSearch(sparams10, gridnms["store.10"]);
	          }
	        }, {
	          text: '전체선택/해제',
	          scope: this,
	          handler: function () {
	            // 전체등록 Pop up 전체선택 버튼 핸들러
	            var count10 = Ext.getStore(gridnms["store.10"]).count();
	            var checkTrue = 0,
	            checkFalse = 0;

	            if (popupclick == 0) {
	              popupclick = 1;
	            } else {
	              popupclick = 0;
	            }
	            for (var i = 0; i < count10; i++) {
	              Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	              var model10 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

	              var chk = model10.data.CHK;

	              if (popupclick == 1) {
	                model10.set("CHK", true);
	                checkFalse++;
	              } else {
	                model10.set("CHK", false);
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
	            var count = Ext.getStore(gridnms["store.1"]).count();
	            var count10 = Ext.getStore(gridnms["store.10"]).count();
	            var checknum = 0,
	            checkqty = 0,
	            checktemp = 0;
	            var qtytemp = [];

	            for (var i = 0; i < count10; i++) {
	              Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	              var model10 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	              var chk = model10.data.CHK;
	              if (chk == true) {
	                checknum++;
	              }
	            }
	            console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	            if (checknum == 0) {
	              var itemtypename = $('#popupItemTypeName').val();
	              extAlert("선택 된 " + itemtypename + " 정보가 없습니다.<br/>다시 한번 확인해주십시오.");
	              return false;
	            }

	            if (count10 == 0) {
	              var itemtypename = $('#popupItemTypeName').val();
	              console.log("[적용] " + itemtypename + " 정보가 없습니다.");
	            } else {
	              for (var j = 0; j < count10; j++) {
	                Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
	                var model10 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                var chk = model10.data.CHK;
	                if (chk === true) {
	                  var model = Ext.create(gridnms["model.1"]);
	                  var store = Ext.getStore(gridnms["store.1"]);

	                  // 순번
	                  var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
	                  model.set("SORTORDER", sortorder);
	                  var upperitemcode = $('#searchItemcd').val();
	                  model.set("ORGID", model10.data.ORGID);
	                  model.set("COMPANYID", model10.data.COMPANYID);
	                  model.set("UPPERITEMCODE", upperitemcode);
	                  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
	                  model.set("EFFECTIVEENDDATE", "4999-12-31");

	                  // 팝업창의 체크된 항목 이동
	                  model.set("ITEMCODE", model10.data.ITEMCODE);
	                  model.set("ORDERNAME", model10.data.ORDERNAME);
	                  model.set("ITEMNAME", model10.data.ITEMNAME);
	                  model.set("UOM", model10.data.UOM);
	                  model.set("UOMNAME", model10.data.UOMNAME);
	                  model.set("ITEMTYPE", model10.data.ITEMTYPE);
	                  model.set("ITEMTYPENAME", model10.data.ITEMTYPENAME);
	                  model.set("ITEMSTANDARD", model10.data.ITEMSTANDARD);
	                  model.set("MODEL", model10.data.MODEL);
	                  model.set("MODELNAME", model10.data.MODELNAME);
	                  model.set("MATERIALTYPE", model10.data.MATERIALTYPE);

	                  // 그리드 적용 방식
	                  store.add(model);

	                  checktemp++;
	                  popcount++;
	                };
	              }

	              Ext.getCmp(gridnms["panel.1"]).getView().refresh();

	            }

	            if (checktemp > 0) {
	              popcount = 0;
	              win11.close();

	              $("#gridPopup1Area").hide("blind", {
	                direction: "up"
	              }, "fast");
	            }
	          }
	        }
	      ]
	    });
	  win11.show();
	}

	function bomClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var upperitemcode = record.data.UPPERITEMCODE;

	  //    var sparams1 = {
	  //      ORGID: orgid,
	  //      COMPANYID: companyid,
	  //    };

	  //    extGridSearch(sparams1, gridnms["store.3"]);

	  var sparams2 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    BIGCD: 'CMM',
	    MIDDLECD: 'UOM',
	    GUBUN: 'UOM',
	  };

	  extGridSearch(sparams2, gridnms["store.4"]);

	  var sparams5 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    BIGCD: 'CMM',
	    MIDDLECD: 'WAREHOUSING',
	    GUBUN: 'WAREHOUSING',
	  };

	  extGridSearch(sparams5, gridnms["store.5"]);

	  var sparams6 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ITEMCODE: upperitemcode,
	  };

	  extGridSearch(sparams6, gridnms["store.6"]);
	}

	function setValues_master() {
	  gridnms["models.master"] = [];
	  gridnms["stores.master"] = [];
	  gridnms["views.master"] = [];
	  gridnms["controllers.master"] = [];

	  gridnms["grid.2"] = "ItemMaster";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.master"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.master"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.master"].push(gridnms["model.2"]);

	  gridnms["stores.master"].push(gridnms["store.2"]);

	  fields["model.2"] = [{
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
	      name: 'ORDERNAME'
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO'
	    }, {
	      type: 'string',
	      name: 'ITEMTYPE'
	    }, {
	      type: 'string',
	      name: 'ITEMTYPENAME'
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE'
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME'
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
	      type: 'date',
	      name: 'EFFECTIVESTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVEENDDATE',
	      dateFormat: 'Y-m-d',
	    },
	  ];

	  fields["columns.2"] = [
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
	      //          width: 160,
	      flex: 1,
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
	    }, ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/checkmaster/CheckMaster.do' />"
	  });

	  items["btns.2"] = [];

	  items["btns.ctr.2"] = {};

	  $.extend(items["btns.ctr.2"], {
	    "#itemMasterListClick": {
	      itemclick: 'itemMasterListClick'
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
	}

	function itemMasterListClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var itemcode = record.data.ITEMCODE;
	  $('#searchItemcd').val(itemcode);

	  if (itemcode === "") {
	    Ext.getStore(gridnms["store.1"]).removeAll();
	  } else {
	    var sparams = {
	      ORGID: orgid,
	      COMPANYID: companyid,
	      ITEMCODE: itemcode,
	    };

	    extGridSearch(sparams, gridnms["store.1"]);
	  }
	}

	var gridarea1, gridarea2;
	function setExtGrid() {
	  setExtGrid_bom();
	  setExtGrid_master();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea1.updateLayout();
	    gridarea2.updateLayout();
	  });
	}

	function setExtGrid_bom() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });

	  //    Ext.define(gridnms["model.3"], {
	  //      extend: Ext.data.Model,
	  //      fields: fields["model.3"]
	  //    });

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
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	                ITEMTYPE: "A", // 유형
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true,
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  //    Ext.define(gridnms["store.3"], {
	  //      extend: Ext.data.Store,
	  //      constructor: function (cfg) {
	  //        var me = this;
	  //        cfg = cfg || {};
	  //        me.callParent([Ext.apply({
	  //              storeId: gridnms["store.3"],
	  //              model: gridnms["model.3"],
	  //              autoLoad: true,
	  //              pageSize: gridVals.pageSize,
	  //              proxy: {
	  //                type: 'ajax',
	  //                url: "<c:url value='/searchItemNameLov.do' />",
	  //                extraParams: {
	  //                  ORGID: $('#searchOrgId').val(),
	  //                  COMPANYID: $('#searchCompanyId').val(),
	  //                  BOMGUBUN: "Y",
	  //                },
	  //                reader: gridVals.reader,
	  //              }
	  //            }, cfg)]);
	  //      },
	  //    });

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
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'CMM',
	                MIDDLECD: 'UOM',
	                GUBUN: 'UOM',
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
	              type: 'ajax',
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'CMM',
	                MIDDLECD: 'WAREHOUSING',
	                GUBUN: 'WAREHOUSING',
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
	                BIGCD: 'MFG',
	                MIDDLECD: 'ROUTING_GUBUN',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      bomClick: '#bomClick',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    //      btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    btnDel1: btnDel1,
	    btnRef1: btnRef1,
	    btnSel1: btnSel1,
	    bomClick: bomClick,
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
	        height: 429,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'bomClick',
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 300) {
	                    column.width = 300;
	                  }
	                }
	                if (column.dataIndex.indexOf('MATERIALTYPE') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 120) {
	                    column.width = 120;
	                  }
	                }
	                if (column.dataIndex.indexOf('ITEMTYPENAME') >= 0) {
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
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var params = {};
	                var editDisableCols = [];

	                if (data.data.AV !== "") {
	                  editDisableCols.push("ITEMNAME");
	                  editDisableCols.push("UOMNAME");

	                  var isNew = ctx.record.phantom || false;
	                  if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
	                    return false;
	                  else {
	                    return true;
	                  }
	                }
	              },
	            }
	          }
	        ],
	        dockedItems: items["docked.1"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.bom"],
	    stores: gridnms["stores.bom"],
	    views: gridnms["views.bom"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.bom"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });
	}

	function setExtGrid_master() {
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
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: 'ajax',
	              api: items["api.2"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                ALLITEMTYPE: "Y", // 유형
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true,
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      itemMasterListClick: '#itemMasterListClick',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

	    itemMasterListClick: itemMasterListClick,
	  });

	  Ext.define(gridnms["panel.2"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.2"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.2"],
	        id: gridnms["panel.2"],
	        store: gridnms["store.2"],
	        height: 168,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        defaults: gridVals.defaultField,
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'itemMasterListClick',
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
	          }
	        ],
	        dockedItems: items["docked.2"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.master"],
	    stores: gridnms["stores.master"],
	    views: gridnms["views.master"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridarea2 = Ext.create(gridnms["views.master"], {
	          renderTo: 'gridArea2'
	        });
	    },
	  });
	}

	function setValues_Popup() {
	  gridnms["models.popup1"] = [];
	  gridnms["stores.popup1"] = [];
	  gridnms["views.popup1"] = [];
	  gridnms["controllers.popup1"] = [];

	  gridnms["grid.10"] = "Popup1";
	  gridnms["grid.11"] = "popupLov";

	  gridnms["panel.10"] = gridnms["app"] + ".view." + gridnms["grid.10"];
	  gridnms["views.popup1"].push(gridnms["panel.10"]);

	  gridnms["controller.10"] = gridnms["app"] + ".controller." + gridnms["grid.10"];
	  gridnms["controllers.popup1"].push(gridnms["controller.10"]);

	  gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];

	  gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

	  gridnms["models.popup1"].push(gridnms["model.10"]);
	  gridnms["models.popup1"].push(gridnms["model.11"]);

	  gridnms["stores.popup1"].push(gridnms["store.10"]);
	  gridnms["stores.popup1"].push(gridnms["store.11"]);

	  fields["model.10"] = [{
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
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPE',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPENAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
	    }, ];

	  fields["model.11"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["columns.10"] = [{
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'rownumberer',
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
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MATERIALTYPE',
	      text: '재질',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
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
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, ];

	  items["api.10"] = {};
	  $.extend(items["api.10"], {
	    read: "<c:url value='/searchItemNameLov.do'/>"
	  });

	  items["btns.10"] = [];

	  items["btns.ctr.10"] = {};

	  items["dock.paging.10"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.5"],
	  };

	  items["dock.btn.10"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.10"],
	    items: items["btns.10"],
	  };

	  items["docked.10"] = [];
	}

	var gridpopup1;
	function setExtGrid_Popup() {
	  Ext.define(gridnms["model.10"], {
	    extend: Ext.data.Model,
	    fields: fields["model.10"],
	  });

	  Ext.define(gridnms["model.11"], {
	    extend: Ext.data.Model,
	    fields: fields["model.11"],
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.10"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                BOMGUBUN: "Y",
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
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'CMM',
	                MIDDLECD: 'ITEM_TYPE',
	                GUBUN: 'ITEM_TYPE',
	                BOMGUBUN: "Y",
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.10"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup1: '#btnPopup1',
	    },
	    stores: [gridnms["store.10"]],
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
	        //                 bufferedRenderer: false,
	        columns: fields["columns.10"],
	        viewConfig: {
	          itemId: 'btnPopup1',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.10"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup1"],
	    stores: gridnms["stores.popup1"],
	    views: gridnms["views.popup1"],
	    controllers: gridnms["controller.10"],

	    launch: function () {
	      gridpopup1 = Ext.create(gridnms["views.popup1"], {
	          renderTo: 'gridPopup1Area'
	        });
	    },
	  });
	}

	function fn_validation() {
	  var result = true;
	  var itemcode = $('#searchItemcd').val();
	  var header = [],
	  count = 0;

	  //    if (itemcode === "") {
	  //      header.push("품번 / 품명");
	  //      count++;
	  //    }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  $('#searchItemcd').val("");

	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    ITEMCODE: $('#searchItemcd').val(),
	    ORDERNAME: $('#searchOrdernm').val(), // 품번
	    ITEMNAME: $('#searchItemnm').val(), // 품명
	    ITEMTYPE: 'A',
	    BIGCODE: $('#searchBigcd').val(),

	    orgid: $('#searchOrgId').val(),
	    companyid: $('#searchCompanyId').val(),
	    itemcode: $('#searchItemcd').val(),
	    ordername: $('#searchOrdernm').val(), // 품번
	    itemname: $('#searchItemnm').val(), // 품명
	  };

	  extGridSearch(sparams, gridnms["store.2"]);
	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.1"]);
	  }, 400);
	}

	function fn_excel() {
	  if (!fn_validation()) {
	    return;
	  }

	  go_url("<c:url value='/bom/BomRegisterExcel.do?ORGID='/>" + $('#searchOrgId option:selected').val() + ""
	     + "&COMPANYID=" + $('#searchCompanyId option:selected').val() + ""
	     + "&ITEMCODE=" + $('#searchItemcd').val() + ""
	     + "&BIGCODE=" + $('#searchBigcd').val() + "");
	}

	function setLovList() {
	  // 대분류 Lov
	  $("#searchBignm")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchBigcd").val("");
	      //          $("#searchBignm").val("");

	      var itemcd = $('#searchItemcd').val();
	      if (itemcd != "") {
	        $("#searchItemcd").val("");
	        $("#searchItemnm").val("");
	        $("#searchOrdernm").val("");
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
	      $.getJSON("<c:url value='/searchBigClassListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.LABEL,
	              value: m.VALUE,
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
	      $("#searchBigcd").val(o.item.value);
	      $("#searchBignm").val(o.item.label);

	      var itemcd = $('#searchItemcd').val();
	      if (itemcd != "") {
	        $("#searchItemcd").val("");
	        $("#searchItemnm").val("");
	        $("#searchOrdernm").val("");
	      }

	      return false;
	    }
	  });

	  // 품번 Lov
	  //    $("#searchOrdernm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemcd").val("");
	  //        $("#searchItemnm").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          BIGCODE: $('#searchBigcd').val(),
	  //          GUBUN: 'ORDERNAME', // 제품, 반제품 조회
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ORDERNAME + ', ' + m.ITEMNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemcd").val(o.item.value);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        return false;
	  //      }
	  //    });

	  // 품명 Lov
	  //    $("#searchItemnm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemcd").val("");
	  //        $("#searchOrdernm").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          BIGCODE: $('#searchBigcd').val(),
	  //          GUBUN: 'ITEMNAME', // 제품, 반제품 조회
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ITEMNAME + ', ' + m.ORDERNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemcd").val(o.item.value);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        return false;
	  //      }
	  //    });
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
                <div id="search_field">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <fieldset>
                        <legend>조건정보 영역</legend>
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupItemCode" name="popupItemCode" /> 
                        <input type="hidden" id="popupItemName" name="popupItemName" /> 
                        <input type="hidden" id="popupOrderName" name="popupOrderName" /> 
                        <input type="hidden" id="popupItemType" name="popupItemType" />
                        <input type="hidden" id="popupItemTypeName" name="popupItemTypeName" />
                        <form id="master" name="master" action="" method="post">
                        <input type="hidden" id="searchGroupCode" name="searchGroupCode" value="A" />
                        <div>
                            <table class="tbl_type_view" border="1">
                                <colgroup>
				                            <col width="120px">
				                            <col>
				                            <col width="120px">
				                            <col>
                                    <col width="120px">
                                    <col>
                                </colgroup>
                                    <tr style="height: 34px;">
                                        <td colspan="6">
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                                   조회
                                                </a>
<!--                                                 <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel();"> -->
<!--                                                    엑셀 -->
<!--                                                 </a> -->
                                            </div>
                                        </td>
                                    </tr>
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
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">대분류</th>
                                    <td>
                                          <input type="text" id="searchBignm" name="searchBignm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                          <input type="hidden" id="searchBigcd" name="searchBigcd" />
                                    </td>
                                    <th class="required_text">품번</th>
                                    <td>
                                          <input type="text" id="searchOrdernm" name="searchOrdernm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                          <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                    </td>
                                    <th class="required_text">품명</th>
                                    <td>
                                          <input type="text" id="searchItemnm" name="searchItemnm"  class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                    </td>
                                </tr>
                            </table>
                        </div>
                      </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">품목 마스터</div></td>
                    </tr>
                </table>
                <div id="gridArea2" style="width: 100%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">BOM List 정보</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1241px; padding-top: 0px; float: left;"></div>
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>