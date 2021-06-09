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

	  $("#gridPopup3Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  gridnms["app"] = "routing";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_routing();
	  setValues_detail();
	  setValues_master();
	  setValues_tool();
	  setValues_popup3(); // 공구 불러오기
	}

	function setValues_routing() {
	  gridnms["models.routing"] = [];
	  gridnms["stores.routing"] = [];
	  gridnms["views.routing"] = [];
	  gridnms["controllers.routing"] = [];

	  gridnms["grid.1"] = "RoutingRegister";
	  gridnms["grid.11"] = "routingnameLov";
	  gridnms["grid.12"] = "customernameLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.routing"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.routing"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
	  gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
	  gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

	  gridnms["models.routing"].push(gridnms["model.1"]);
	  gridnms["models.routing"].push(gridnms["model.11"]);
	  gridnms["models.routing"].push(gridnms["model.12"]);

	  gridnms["stores.routing"].push(gridnms["store.1"]);
	  gridnms["stores.routing"].push(gridnms["store.11"]);
	  gridnms["stores.routing"].push(gridnms["store.12"]);

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
	      name: 'SORTORDER',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGOP',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'number',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNO',
	    }, {
	      type: 'number',
	      name: 'SETUPTIME',
	    }, {
	      type: 'number',
	      name: 'CYCLETIME',
	    }, {
	      type: 'number',
	      name: 'CAVITY'
	    }, {
	      type: 'number',
	      name: 'PRODTIME'
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
	      name: 'CONVERSIONCOST',
	    }, {
	      type: 'number',
	      name: 'MATERIALCOST',
	    }, {
	      type: 'number',
	      name: 'ACCCONVERSIONCOST',
	    }, {
	      type: 'string',
	      name: 'OUTSIDEORDERGUBUN',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODEOUT',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAMEOUT',
	    }, ];

	  fields["model.11"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["model.12"] = [{
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
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	    }, {
	      dataIndex: 'ROUTINGOP',
	      text: '공정순번',
	      xtype: 'gridcolumn',
	      width: 80,
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
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 170,
	      hidden: false,
	      sortable: false,
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
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            model.set("ROUTINGNO", record.data.VALUE);
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
	      dataIndex: 'SETUPTIME',
	      text: '로딩시간',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
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
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var selectedRow = Ext.getCmp(gridnms["views.routing"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0];

	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            var setuptime = field.getValue(); // 로딩시간
	            if (setuptime == "" || setuptime == undefined) {
	              setuptime = 0;
	            }
	            var cycletime = store.data.CYCLETIME; //가동시간
	            if (cycletime == "" || cycletime == undefined) {
	              cycletime = 0;
	            }
	            var cavity = store.data.CAVITY; //CAVITY
	            if (cavity == "" || cavity == undefined) {
	              cavity = 1;
	            }

	            var pdtime = 3600 / ((setuptime + cycletime) * cavity);

	            if (pdtime == Infinity) {}
	            else {
	              model.set("PRODTIME", pdtime);
	            }
	          },
	        },
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CYCLETIME',
	      text: 'CT<br/>(초)',
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
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var selectedRow = Ext.getCmp(gridnms["views.routing"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0];

	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            var setuptime = store.data.SETUPTIME; // 로딩시간
	            if (setuptime == "" || setuptime == undefined) {
	              setuptime = 0;
	            }
	            var cycletime = field.getValue(); //가동시간
	            if (cycletime == "" || cycletime == undefined) {
	              cycletime = 0;
	            }
	            var cavity = store.data.CAVITY; //CAVITY
	            if (cavity == "" || cavity == undefined) {
	              cavity = 1;
	            }

	            var pdtime = 3600 / ((setuptime + cycletime) * cavity);

	            if (pdtime == Infinity) {}
	            else {
	              model.set("PRODTIME", pdtime);
	            }

	            //             model.set("ROUTINGNO", setuptime);
	          },
	        },
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CAVITY',
	      text: 'CAVITY',
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
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var selectedRow = Ext.getCmp(gridnms["views.routing"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0];

	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            var setuptime = store.data.SETUPTIME; // 로딩시간
	            if (setuptime == "" || setuptime == undefined) {
	              setuptime = 0;
	            }
	            var cycletime = store.data.CYCLETIME; //가동시간
	            if (cycletime == "" || cycletime == undefined) {
	              cycletime = 0;
	            }
	            var cavity = field.getValue(); //CAVITY
	            if (cavity == "" || cavity == undefined) {
	              cavity = 1;
	            }

	            var pdtime = 3600 / ((setuptime + cycletime) * cavity);

	            if (pdtime == Infinity) {}
	            else {
	              model.set("PRODTIME", pdtime);
	            }
	          },
	        },
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'PRODTIME',
	      text: '시간당<br/>생산량',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.00",
	      renderer: function (value, meta, eOpts) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000.00');
	      },
	    }, {
	      dataIndex: 'CONVERSIONCOST',
	      text: '가공비<br/>(원)',
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
	      //        }, {
	      //            dataIndex: 'ACCCONVERSIONCOST',
	      //            text: '누적가공비<br/>(원)',
	      //            xtype: 'gridcolumn',
	      //            width: 85,
	      //            hidden: false,
	      //            sortable: false,
	      //            style: 'text-align:center',
	      //            align: "right",
	      //            cls: 'ERPQTY',
	      //            format: "0,000",
	      //            editor: {
	      //              xtype: "textfield",
	      //              minValue: 1,
	      //              format: "0,000",
	      //              enforceMaxLength: true,
	      //              allowBlank: true,
	      //              maxLength: '20',
	      //              maskRe: /[0-9]/,
	      //              selectOnFocus: true,
	      //            },
	      //            renderer: Ext.util.Format.numberRenderer('0,000'),
	      //      }, {
	      //        dataIndex: 'MATERIALCOST',
	      //        text: '소재비<br/>(원)',
	      //        xtype: 'gridcolumn',
	      //        width: 85,
	      //        hidden: false,
	      //        sortable: false,
	      //        style: 'text-align:center',
	      //        align: "right",
	      //        cls: 'ERPQTY',
	      //        format: "0,000",
	      //        editor: {
	      //          xtype: "textfield",
	      //          minValue: 1,
	      //          format: "0,000",
	      //          enforceMaxLength: true,
	      //          allowBlank: true,
	      //          maxLength: '20',
	      //          maskRe: /[0-9]/,
	      //          selectOnFocus: true,
	      //        },
	      //        renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'OUTSIDEORDERGUBUN',
	      text: '외주<br>구분',
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
	        allowBlank: true,
	        typeAhead: true,
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            var result = value.getValue();

	            if (result != "Y") {
	              var customercodeout = model.data.CUSTOMERCODEOUT;
	              if (customercodeout != "") {
	                model.set("CUSTOMERCODEOUT", "");
	                model.set("CUSTOMERNAMEOUT", "");
	              }
	            }
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (result == "N") {
	                model.set("CUSTOMERCODEOUT", "");
	                model.set("CUSTOMERNAMEOUT", "");
	              }
	            }
	          },
	        },
	      },
	    }, {
	      dataIndex: 'CUSTOMERNAMEOUT',
	      text: '외주거래처',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.12"],
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
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	            model.set("CUSTOMERCODEOUT", record.data.VALUE);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                model.set("CUSTOMERCODEOUT", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 120,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="250px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        var gubun = record.data.OUTSIDEORDERGUBUN;
	        if (gubun != "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효시작일자',
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
	      text: '유효종료일자',
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
	      dataIndex: 'ROUTINGNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ACCCONVERSIONCOST',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MATERIALCOST',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/routing/RoutingRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/routing/RoutingRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/routing/RoutingRegister.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/routing/RoutingRegister.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1",
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav1",
	  });
	  //    items["btns.1"].push({
	  //      xtype: "button",
	  //      text: "삭제",
	  //      itemId: "btnDel1",
	  //    });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef1",
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
	  //    $.extend(items["btns.ctr.1"], {
	  //      "#btnDel1": {
	  //        click: 'btnDel1'
	  //      }
	  //    });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#routingClick": {
	      itemclick: 'routingClick'
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
	  var orgid = $('#searchOrgId').val();
	  var companyid = $('#searchCompanyId').val();
	  var itemcode = $('#searchItemcd').val();

	  if (!fn_validation()) {
	    return;
	  }

	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	  model.set("ORGID", orgid);
	  model.set("COMPANYID", companyid);
	  model.set("ITEMCODE", itemcode);

	  model.set("OUTSIDEORDERGUBUN", "N");
	  model.set("CAVITY", 1);
	  var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
	  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
	  model.set("EFFECTIVEENDDATE", enddate);

	  model.set("SORTORDER", (Ext.getStore(gridnms["store.1"]).count() + 1));

	  store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	};

	function btnSav1(o, e) {
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  count = 0;

	  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).getSelectionModel().select((count1 - 1)));
	  var getmodel = Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0];

	  var getsortorder = getmodel.data.SORTORDER;
	  var getroutingop = getmodel.data.ROUTINGOP;
	  var sameCount = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0];

	      var sortorder = model.data.SORTORDER;
	      var routingno = model.data.ROUTINGNO;
	      var routingop = model.data.ROUTINGOP;

	      if (count1 > 0) {
	        if (i < (count1 - 1)) {
	          if (getsortorder == sortorder && getroutingop == routingop) {
	            sameCount++;
	          }

	          if (sameCount > 0) {
	            model.set("SORTORDER", (sortorder * 1) + 1);
	            model.set("ROUTINGOP", "OP" + ((routingop.replace("OP", "") * 1) + 10));
	          }
	        }
	      }

	      if (sortorder == "" || sortorder == undefined) {
	        header.push("정렬순서");
	        count++;
	      }
	      if (routingno == "" || routingno == undefined) {
	        header.push("공정명");
	        count++;
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    };
	  }
	  Ext.getStore(gridnms["store.1"]).sync({
	    success: function (batch, options) {
// 	      extAlert(msgs.noti.save, gridnms["store.1"]);
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.1"]);

	      fn_search();
	    },
	    failure: function (batch, options) {
// 	      extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	        var reader = batch.proxy.getReader();
	        extAlert(reader.rawData.msg, gridnms["store.1"]);
	    },
	    callback: function (batch, options) {},
	  });
	}

	function btnDel1(o, e) {
	    extGridDel(gridnms["store.1"], gridnms["panel.1"]);
	}

	function btnRef1(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	function routingClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var routingid = record.data.ROUTINGID;
	  var routingno = record.data.ROUTINGNO;
	  $('#routingid').val(routingid);
	  $('#routingno').val(routingno);
	  $('#equipmentcode').val("");
	  var equipmentcode = $('#equipmentcode').val();

	  if (routingid === "") {
	    Ext.getStore(gridnms["store.2"]).removeAll();
	  } else {
	    var sparams = {
	      orgid: orgid,
	      companyid: companyid,
	      routingid: routingid,
	      routingno: routingno,
	      itemcode: $('#searchItemcd').val(),
	      equipmentcode: equipmentcode,
	      ORGID: orgid,
	      COMPANYID: companyid,
	      ITEMCODE: $('#searchItemcd').val(),
	    };

	    extGridSearch(sparams, gridnms["store.2"]);

	    setTimeout(function () {
	      extGridSearch(sparams, gridnms["store.4"]);
	    }, 400);
	  }
	}

	function setValues_detail() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "RoutingDetail";

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
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
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
	      type: 'string',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGCODE',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'CHK',
	    }, ];

	  fields["columns.2"] = [
	    // Display columns
	    {
	      dataIndex: 'WORKCENTERCODE',
	      text: '설비코드',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'WORKCENTERNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'MODELSTANDARD',
	      text: '모델 및 규격',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'CHK',
	      text: '연결<br/>여부',
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
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	             width: 280,
// 	      flex: 1,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      align: "center",
	      editor: {
	        allowBlank: true,
	        xtype: "textfield",
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
	      dataIndex: 'EQUIPMENTCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/routing/RoutingDetail.do' />"
	  });
	  $.extend(items["api.2"], {
	    update: "<c:url value='/update/routing/RoutingDetail.do' />"
	  });

	  items["btns.2"] = [];
	  items["btns.2"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav2",
	  });
	  items["btns.2"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef2",
	  });

	  items["btns.ctr.2"] = {};
	  $.extend(items["btns.ctr.2"], {
	    "#btnSav2": {
	      click: 'btnSav2'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#btnRef2": {
	      click: 'btnRef2'
	    }
	  });
	  $.extend(items["btns.ctr.2"], {
	    "#equipmentClick": {
	      itemclick: 'equipmentClick'
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

	function btnSav2(o, e) {
	  extGridSave(gridnms["store.2"]);
	};

	function btnRef2(o, e) {
	  Ext.getStore(gridnms["store.2"]).load();
	};

	function equipmentClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var routingid = record.data.ROUTINGID;
	  var routingno = record.data.ROUTINGCODE;
	  var equipmentcode = record.data.EQUIPMENTCODE;
	  $('#routingid').val(routingid);
	  $('#routingno').val(routingno);
	  $('#equipmentcode').val(equipmentcode);

	  if (routingid != "" && equipmentcode != "") {
	    var sparams1 = {
	      orgid: orgid,
	      companyid: companyid,
	      routingid: routingid,
	      equipmentcode: equipmentcode,
	    };
	    extGridSearch(sparams1, gridnms["store.4"]);
	  } else {
	    Ext.getStore(gridnms["store.4"]).removeAll();
	  }
	}

	function setValues_master() {
	  gridnms["models.master"] = [];
	  gridnms["stores.master"] = [];
	  gridnms["views.master"] = [];
	  gridnms["controllers.master"] = [];

	  gridnms["grid.3"] = "ItemMaster";

	  gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
	  gridnms["views.master"].push(gridnms["panel.3"]);

	  gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
	  gridnms["controllers.master"].push(gridnms["controller.3"]);

	  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	  gridnms["models.master"].push(gridnms["model.3"]);

	  gridnms["stores.master"].push(gridnms["store.3"]);

	  fields["model.3"] = [{
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

	  fields["columns.3"] = [
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

	  items["api.3"] = {};
	  $.extend(items["api.3"], {
	    read: "<c:url value='/select/checkmaster/CheckMaster.do' />"
	  });

	  items["btns.3"] = [];

	  items["btns.ctr.3"] = {};

	  $.extend(items["btns.ctr.3"], {
	    "#itemMasterListClick": {
	      itemclick: 'itemMasterListClick'
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
	}

	function itemMasterListClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var itemcode = record.data.ITEMCODE;
	  $('#searchItemcd').val(itemcode);
	  $('#equipmentcode').val("");
	  $('#routingid').val("");
	  $('#routingno').val("");

	  var equipmentcode = $('#equipmentcode').val();

	  if (itemcode === "") {
	    Ext.getStore(gridnms["store.1"]).removeAll();
	    Ext.getStore(gridnms["store.2"]).removeAll();
	    Ext.getStore(gridnms["store.4"]).removeAll();
	  } else {
	    var sparams = {
	      orgid: orgid,
	      companyid: companyid,
	      itemcode: $('#searchItemcd').val(),
	      equipmentcode: equipmentcode,
	      ORGID: orgid,
	      COMPANYID: companyid,
	      ITEMCODE: $('#searchItemcd').val(),
	      routingid: '',
	    };

	    extGridSearch(sparams, gridnms["store.1"]);

	    setTimeout(function () {
	      extGridSearch(sparams, gridnms["store.2"]);
	    }, 400);

	    setTimeout(function () {
	      extGridSearch(sparams, gridnms["store.4"]);
	    }, 800);

	  }
	}

	function btnSelect3(btn) {
	  var count = Ext.getStore(gridnms["store.3"]).count();
	  var checkTrue = 0,
	  checkFalse = 0;

	  if (popupclick == 0) {
	    popupclick = 1;
	  } else {
	    popupclick = 0;
	  }
	  for (var i = 0; i < count; i++) {
	    Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.master"]).getSelectionModel().select(i));
	    var model3 = Ext.getCmp(gridnms["views.master"]).selModel.getSelection()[0];

	    var check = model3.data.ROUTINGCHECK;
	    var chk = model3.data.CHK;

	    if (check == "N") {
	      if (popupclick == 1) {
	        // 체크 상태로
	        model3.set("CHK", true);
	        checkFalse++;
	      } else {
	        model3.set("CHK", false);
	        checkTrue++;
	      }
	    } else {}

	  }
	  if (checkTrue > 0) {
	    console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
	  }
	  if (checkFalse > 0) {
	    console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
	  }
	}

	function setValues_tool() {
	  gridnms["models.tool"] = [];
	  gridnms["stores.tool"] = [];
	  gridnms["views.tool"] = [];
	  gridnms["controllers.tool"] = [];

	  gridnms["grid.4"] = "ToolCheckMaster";
	  gridnms["grid.41"] = "checkCodeLov";
	  gridnms["grid.42"] = "checkMethodLov";

	  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
	  gridnms["views.tool"].push(gridnms["panel.4"]);

	  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
	  gridnms["controllers.tool"].push(gridnms["controller.4"]);

	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
	  gridnms["model.41"] = gridnms["app"] + ".model." + gridnms["grid.41"];
	  gridnms["model.42"] = gridnms["app"] + ".model." + gridnms["grid.42"];

	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
	  gridnms["store.41"] = gridnms["app"] + ".store." + gridnms["grid.41"];
	  gridnms["store.42"] = gridnms["app"] + ".store." + gridnms["grid.42"];

	  gridnms["models.tool"].push(gridnms["model.4"]);
	  gridnms["models.tool"].push(gridnms["model.41"]);
	  gridnms["models.tool"].push(gridnms["model.42"]);

	  gridnms["stores.tool"].push(gridnms["store.4"]);
	  gridnms["stores.tool"].push(gridnms["store.41"]);
	  gridnms["stores.tool"].push(gridnms["store.42"]);

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
	      type: 'number',
	      name: 'CHECKSEQ',
	    }, {
	      type: 'number',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNO',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTCODE',
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
	      type: 'number',
	      name: 'TOOLLIFE',
	    }, {
	      type: 'number',
	      name: 'PAGEQTY',
	    }, {
	      type: 'number',
	      name: 'EQUIPQTY',
	    }, {
	      type: 'number',
	      name: 'MONTHLYPRODQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKCODE1',
	    }, {
	      type: 'string',
	      name: 'CHECKNAME1',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD1',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE1',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE1',
	    }, {
	      type: 'number',
	      name: 'MINVALUE1',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODTYPE1',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODNAME1',
	    }, {
	      type: 'string',
	      name: 'CHECKCODE2',
	    }, {
	      type: 'string',
	      name: 'CHECKNAME2',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD2',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE2',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE2',
	    }, {
	      type: 'number',
	      name: 'MINVALUE2',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODTYPE2',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODNAME2',
	    }, {
	      type: 'string',
	      name: 'CHECKCODE3',
	    }, {
	      type: 'string',
	      name: 'CHECKNAME3',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD3',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE3',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE3',
	    }, {
	      type: 'number',
	      name: 'MINVALUE3',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODTYPE3',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODNAME3',
	    }, {
	      type: 'string',
	      name: 'CHECKCODE4',
	    }, {
	      type: 'string',
	      name: 'CHECKNAME4',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD4',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE4',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE4',
	    }, {
	      type: 'number',
	      name: 'MINVALUE4',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODTYPE4',
	    }, {
	      type: 'string',
	      name: 'CHECKMETHODNAME4',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVESTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'EFFECTIVEENDDATE',
	      dateFormat: 'Y-m-d',
	    }, ];

	  fields["model.41"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["model.42"] = [{
	      type: 'string',
	      name: 'VALUE'
	    }, {
	      type: 'string',
	      name: 'LABEL'
	    }
	  ];

	  fields["columns.4"] = [
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
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '공구명',
	      xtype: 'gridcolumn',
	      width: 230,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '사양',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'TOOLLIFE',
	      text: 'TOOL LIFE<br/>( EA )',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
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
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'PAGEQTY',
	      text: '면수',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
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
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'EQUIPQTY',
	      text: '장착수',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
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
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHLYPRODQTY',
	      text: '월생산<br/>기준',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
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
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      text: '검사항목1',
	      menuDisabled: true,
	      columns: [{
	          dataIndex: 'CHECKNAME1',
	          text: '검사명',
	          xtype: 'gridcolumn',
	          width: 135, // 100,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.41"],
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
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKCODE1", record.data.VALUE);

	                var name = record.data.LABEL;

	                if (name == "") {
	                  model.set("CHECKCODE1", "");

	                } else {
	                  model.set("CHECKSTANDARD1", "");
	                  model.set("STANDARDVALUE1", "");
	                  model.set("MAXVALUE1", "");
	                  model.set("MINVALUE1", "");
	                  model.set("CHECKMETHODTYPE1", "");
	                  model.set("CHECKMETHODNAME1", "");
	                }
	              },
	              change: function (field, ov, nv, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);
	                var result = field.getValue();

	                if (ov != nv) {
	                  if (!isNaN(result)) {
	                    model.set("CHECKSTANDARD1", "");
	                    model.set("STANDARDVALUE1", "");
	                    model.set("MAXVALUE1", "");
	                    model.set("MINVALUE1", "");
	                    model.set("CHECKMETHODTYPE1", "");
	                    model.set("CHECKMETHODNAME1", "");
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
	          dataIndex: 'CHECKSTANDARD1',
	          text: '검사내용',
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
	          },
	        }, {
	          dataIndex: 'CHECKMETHODNAME1',
	          text: '검사장비',
	          xtype: 'gridcolumn',
	          width: 150,
	          hidden: false,
	          sortable: false,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.42"],
	            valueField: "LABEL",
	            displayField: "LABEL",
	            matchFieldWidth: true,
	            editable: false,
	            queryParam: 'keyword',
	            queryMode: 'local', // 'local',
	            allowBlank: true,
	            typeAhead: true,
	            transform: 'stateSelect',
	            forceSelection: false,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKMETHODTYPE1", record.data.VALUE);
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	              width: 330,
	              getInnerTpl: function () {
	                return '<div>'
	                 + '<table >'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
	                 + '</tr>'
	                 + '</table>'
	              }
	            },
	          },
	        }, {
	          dataIndex: 'STANDARDVALUE1',
	          text: '기준값',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'textfield',
	            allowBlank: true,
	          }
	        }, {
	          dataIndex: 'MINVALUE1',
	          text: '하한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          }
	        }, {
	          dataIndex: 'MAXVALUE1',
	          text: '상한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          },
	        }, ]
	    }, {
	      text: '검사항목2',
	      menuDisabled: true,
	      columns: [{
	          dataIndex: 'CHECKNAME2',
	          text: '검사명',
	          xtype: 'gridcolumn',
	          width: 135, // 100,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.41"],
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
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKCODE2", record.data.VALUE);

	                var name = record.data.LABEL;

	                if (name == "") {
	                  model.set("CHECKCODE2", "");

	                } else {
	                  model.set("CHECKSTANDARD2", "");
	                  model.set("STANDARDVALUE2", "");
	                  model.set("MAXVALUE2", "");
	                  model.set("MINVALUE2", "");
	                  model.set("CHECKMETHODTYPE2", "");
	                  model.set("CHECKMETHODNAME2", "");
	                }
	              },
	              change: function (field, ov, nv, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);
	                var result = field.getValue();

	                if (ov != nv) {
	                  if (!isNaN(result)) {
	                    model.set("CHECKSTANDARD2", "");
	                    model.set("STANDARDVALUE2", "");
	                    model.set("MAXVALUE2", "");
	                    model.set("MINVALUE2", "");
	                    model.set("CHECKMETHODTYPE2", "");
	                    model.set("CHECKMETHODNAME2", "");
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
	          //            renderer: function (value, meta, record) {
	          //              meta.style = "background-color:rgb(253, 218, 255)";
	          //              return value;
	          //            },
	        }, {
	          dataIndex: 'CHECKSTANDARD2',
	          text: '검사내용',
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
	          },
	        }, {
	          dataIndex: 'CHECKMETHODNAME2',
	          text: '검사장비',
	          xtype: 'gridcolumn',
	          width: 150,
	          hidden: false,
	          sortable: false,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.42"],
	            valueField: "LABEL",
	            displayField: "LABEL",
	            matchFieldWidth: true,
	            editable: false,
	            queryParam: 'keyword',
	            queryMode: 'local', // 'local',
	            allowBlank: true,
	            typeAhead: true,
	            transform: 'stateSelect',
	            forceSelection: false,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKMETHODTYPE2", record.data.VALUE);
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	              width: 330,
	              getInnerTpl: function () {
	                return '<div>'
	                 + '<table >'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
	                 + '</tr>'
	                 + '</table>'
	              }
	            },
	          },
	        }, {
	          dataIndex: 'STANDARDVALUE2',
	          text: '기준값',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'textfield',
	            allowBlank: true,
	          }
	        }, {
	          dataIndex: 'MINVALUE2',
	          text: '하한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          }
	        }, {
	          dataIndex: 'MAXVALUE2',
	          text: '상한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          },
	        }, ]
	    }, {
	      text: '검사항목3',
	      menuDisabled: true,
	      columns: [{
	          dataIndex: 'CHECKNAME3',
	          text: '검사명',
	          xtype: 'gridcolumn',
	          width: 135, // 100,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.41"],
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
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKCODE3", record.data.VALUE);

	                var name = record.data.LABEL;

	                if (name == "") {
	                  model.set("CHECKCODE3", "");

	                } else {
	                  model.set("CHECKSTANDARD3", "");
	                  model.set("STANDARDVALUE3", "");
	                  model.set("MAXVALUE3", "");
	                  model.set("MINVALUE3", "");
	                  model.set("CHECKMETHODTYPE3", "");
	                  model.set("CHECKMETHODNAME3", "");
	                }
	              },
	              change: function (field, ov, nv, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);
	                var result = field.getValue();

	                if (ov != nv) {
	                  if (!isNaN(result)) {
	                    model.set("CHECKSTANDARD3", "");
	                    model.set("STANDARDVALUE3", "");
	                    model.set("MAXVALUE3", "");
	                    model.set("MINVALUE3", "");
	                    model.set("CHECKMETHODTYPE3", "");
	                    model.set("CHECKMETHODNAME3", "");
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
	          //            renderer: function (value, meta, record) {
	          //              meta.style = "background-color:rgb(253, 218, 255)";
	          //              return value;
	          //            },
	        }, {
	          dataIndex: 'CHECKSTANDARD3',
	          text: '검사내용',
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
	          },
	        }, {
	          dataIndex: 'CHECKMETHODNAME3',
	          text: '검사장비',
	          xtype: 'gridcolumn',
	          width: 150,
	          hidden: false,
	          sortable: false,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.42"],
	            valueField: "LABEL",
	            displayField: "LABEL",
	            matchFieldWidth: true,
	            editable: false,
	            queryParam: 'keyword',
	            queryMode: 'local', // 'local',
	            allowBlank: true,
	            typeAhead: true,
	            transform: 'stateSelect',
	            forceSelection: false,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKMETHODTYPE3", record.data.VALUE);
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	              width: 330,
	              getInnerTpl: function () {
	                return '<div>'
	                 + '<table >'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
	                 + '</tr>'
	                 + '</table>'
	              }
	            },
	          },
	        }, {
	          dataIndex: 'STANDARDVALUE3',
	          text: '기준값',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'textfield',
	            allowBlank: true,
	          }
	        }, {
	          dataIndex: 'MINVALUE3',
	          text: '하한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          }
	        }, {
	          dataIndex: 'MAXVALUE3',
	          text: '상한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          },
	        }, ]
	    }, {
	      text: '검사항목4',
	      menuDisabled: true,
	      columns: [{
	          dataIndex: 'CHECKNAME4',
	          text: '검사명',
	          xtype: 'gridcolumn',
	          width: 135, // 100,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.41"],
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
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKCODE4", record.data.VALUE);

	                var name = record.data.LABEL;

	                if (name == "") {
	                  model.set("CHECKCODE4", "");

	                } else {
	                  model.set("CHECKSTANDARD4", "");
	                  model.set("STANDARDVALUE4", "");
	                  model.set("MAXVALUE4", "");
	                  model.set("MINVALUE4", "");
	                  model.set("CHECKMETHODTYPE4", "");
	                  model.set("CHECKMETHODNAME4", "");
	                }
	              },
	              change: function (field, ov, nv, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);
	                var result = field.getValue();

	                if (ov != nv) {
	                  if (!isNaN(result)) {
	                    model.set("CHECKSTANDARD4", "");
	                    model.set("STANDARDVALUE4", "");
	                    model.set("MAXVALUE4", "");
	                    model.set("MINVALUE4", "");
	                    model.set("CHECKMETHODTYPE4", "");
	                    model.set("CHECKMETHODNAME4", "");
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
	          //            renderer: function (value, meta, record) {
	          //              meta.style = "background-color:rgb(253, 218, 255)";
	          //              return value;
	          //            },
	        }, {
	          dataIndex: 'CHECKSTANDARD4',
	          text: '검사내용',
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
	          },
	        }, {
	          dataIndex: 'CHECKMETHODNAME4',
	          text: '검사장비',
	          xtype: 'gridcolumn',
	          width: 150,
	          hidden: false,
	          sortable: false,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.42"],
	            valueField: "LABEL",
	            displayField: "LABEL",
	            matchFieldWidth: true,
	            editable: false,
	            queryParam: 'keyword',
	            queryMode: 'local', // 'local',
	            allowBlank: true,
	            typeAhead: true,
	            transform: 'stateSelect',
	            forceSelection: false,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                model.set("CHECKMETHODTYPE4", record.data.VALUE);
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	              width: 330,
	              getInnerTpl: function () {
	                return '<div>'
	                 + '<table >'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
	                 + '</tr>'
	                 + '</table>'
	              }
	            },
	          },
	        }, {
	          dataIndex: 'STANDARDVALUE4',
	          text: '기준값',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          align: "center",
	          editor: {
	            xtype: 'textfield',
	            allowBlank: true,
	          }
	        }, {
	          dataIndex: 'MINVALUE4',
	          text: '하한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          }
	        }, {
	          dataIndex: 'MAXVALUE4',
	          text: '상한',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          editor: {
	            xtype: "textfield",
	            minValue: 0,
	            format: "0,000",
	            enforceMaxLength: true,
	            allowBlank: true,
	            maxLength: '7',
	            maskRe: /[0-9.]/,
	            selectOnFocus: true,
	          },
	        }, ]
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효시작일자',
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      text: '유효종료일자',
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
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
	      dataIndex: 'CHECKSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EQUIPMENTCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCODE1',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMETHODTYPE1',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCODE2',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMETHODTYPE2',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCODE3',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMETHODTYPE3',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCODE4',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMETHODTYPE4',
	      xtype: 'hidden',
	    }, ];

	  items["api.4"] = {};
	  $.extend(items["api.4"], {
	    create: "<c:url value='/insert/routing/ToolCheckList.do' />"
	  });
	  $.extend(items["api.4"], {
	    read: "<c:url value='/select/routing/ToolCheckList.do' />"
	  });
	  $.extend(items["api.4"], {
	    update: "<c:url value='/update/routing/ToolCheckList.do' />"
	  });

	  items["btns.4"] = [];
	  items["btns.4"].push({
	    xtype: "button",
	    text: "공구 불러오기",
	    itemId: "btnSel4",
	  });
	  items["btns.4"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav4",
	  });
	  items["btns.4"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef4",
	  });

	  items["btns.ctr.4"] = {};
	  $.extend(items["btns.ctr.4"], {
	    "#btnSel4": {
	      click: 'btnSel4'
	    }
	  });
	  $.extend(items["btns.ctr.4"], {
	    "#btnSav4": {
	      click: 'btnSav4'
	    }
	  });
	  $.extend(items["btns.ctr.4"], {
	    "#btnRef4": {
	      click: 'btnRef4'
	    }
	  });

	  items["dock.paging.4"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.4"],
	  };

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

	var popcount = 0, popupclick = 0;
	function btnSel4(btn) {
	  var routingid = $('#routingid').val();
	  var equipmentcode = $('#equipmentcode').val();
	  var searchItemcd = $('#searchItemcd').val();

	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (searchItemcd === "") {
	    header.push("품번 / 품명");
	    count++;
	  }

	  if (routingid === "") {
	    header.push("공정명");
	    count++;
	  }

	  if (equipmentcode === "") {
	    header.push("설비명");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("먼저, " + header + " 항목을 선택해주세요.");
	    return false;
	  }

	  // 공구 불러오기 팝업
	  var width = 1058; // 가로
	  var height = 640; // 세로
	  var title = "공구 불러오기 Popup";

	  var check = true;
	  popupclick = 0;

	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupItemName').val("");
	    $('#popupItemStandard').val("");
	    Ext.getStore(gridnms['store.50']).removeAll();

	    win50 = Ext.create('Ext.window.Window', {
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
	            itemId: gridnms["panel.50"],
	            id: gridnms["panel.50"],
	            store: gridnms["store.50"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.50"],
	            viewConfig: {
	              itemId: 'ToolPopup',
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
	            dockedItems: items["docked.50"],
	          }
	        ],
	        tbar: [
	          '공구명', {
	            xtype: 'textfield',
	            name: 'searchItemName',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 200,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                $('#popupItemName').val(result);
	              },
	            },
	          },
	          '사양', {
	            xtype: 'textfield',
	            name: 'searchItemStandard',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 250,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              //                buffer: 50,
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                $('#popupItemStandard').val(result);
	              },
	            },
	          },
	          '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                GROUPCODE: $('#searchGroupCode').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ITEMSTANDARD: $('#popupItemStandard').val(),
	              };

	              extGridSearch(sparams3, gridnms["store.50"]);
	            }
	          }, {
	            text: '전체선택/해제',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 전체선택 버튼 핸들러
	              var count4 = Ext.getStore(gridnms["store.50"]).count();
	              var checkTrue = 0,
	              checkFalse = 0;

	              if (popupclick == 0) {
	                popupclick = 1;
	              } else {
	                popupclick = 0;
	              }
	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.50"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];

	                var chk = model4.data.CHK;

	                if (popupclick == 1) {
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
	              var count = Ext.getStore(gridnms["store.4"]).count();
	              var count4 = Ext.getStore(gridnms["store.50"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.50"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
	                var chk = model4.get("CHK");

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("자재를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count4 == 0) {
	                console.log("[적용] 공구 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count4; j++) {
	                  Ext.getStore(gridnms["store.50"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(j));
	                  var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.4"]);
	                    var store = Ext.getStore(gridnms["store.4"]);

	                    // 순번
	                    model.set("RN", Ext.getStore(gridnms["store.4"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ITEMCODE", model4.data.ITEMCODE);
	                    model.set("ITEMNAME", model4.data.ITEMNAME);
	                    model.set("ITEMSTANDARD", model4.data.ITEMSTANDARD);

	                    var orgid = $('#searchOrgId').val();
	                    var companyid = $('#searchCompanyId').val();

	                    model.set("ORGID", orgid);
	                    model.set("COMPANYID", companyid);

	                    var routingid = $('#routingid').val();
	                    var routingno = $('#routingno').val();

	                    model.set("ROUTINGID", routingid);
	                    model.set("ROUTINGNO", routingno);

	                    var equipmentcode = $('#equipmentcode').val();

	                    model.set("EQUIPMENTCODE", equipmentcode);

	                    var startdate = Ext.util.Format.date("${searchVO.datefrom}", 'Y-m-d');
	                    var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
	                    model.set("EFFECTIVESTARTDATE", startdate);
	                    model.set("EFFECTIVEENDDATE", enddate);

	                    // 그리드 적용 방식
	                    store.add(model);

	                    checktemp++;
	                    popcount++;
	                  };
	                }

	                Ext.getCmp(gridnms["panel.4"]).getView().refresh();

	              }

	              if (checktemp > 0) {
	                popcount = 0;
	                win50.close();

	                $("#gridPopup3Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win50.show();
	  } else {
	    extAlert("공구 등록 하실 경우에만 공구 불러오기가 가능합니다.");
	    return;
	  }
	}

	function btnSav4(o, e) {
	  var count = 0,
	  msg = null;
	  var mcount4 = Ext.getStore(gridnms["store.4"]).count();

	  for (var k = 0; k < mcount4; k++) {
	    var model = Ext.getStore(gridnms["store.4"]).data.items[k].data;
	    var header = [],
	    gubun = null;

	    var name1 = model.CHECKNAME1 + "";
	    if (name1.length == 0) {
	      header.push("검사명1");
	      count++;
	    }

	    var startdate = model.EFFECTIVESTARTDATE + "";
	    if (startdate.length == 0) {
	      header.push("유효시작일자");
	      count++;
	    }

	    var enddate = model.EFFECTIVEENDDATE + "";
	    if (enddate.length == 0) {
	      header.push("유효종료일자");
	      count++;
	    }

	    if (count > 0) {
	      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
	      return;
	    }
	  }

	  if (count == 0) {
	    extGridSave(gridnms["store.4"]);
	  }
	};

	function btnRef4(o, e) {
	  Ext.getStore(gridnms["store.4"]).load();
	};

	function setValues_popup3() {
	  gridnms["models.popup3"] = [];
	  gridnms["stores.popup3"] = [];
	  gridnms["views.popup3"] = [];
	  gridnms["controllers.popup3"] = [];

	  gridnms["grid.50"] = "ToolPopup";

	  gridnms["panel.50"] = gridnms["app"] + ".view." + gridnms["grid.50"];
	  gridnms["views.popup3"].push(gridnms["panel.50"]);

	  gridnms["controller.50"] = gridnms["app"] + ".controller." + gridnms["grid.50"];
	  gridnms["controllers.popup3"].push(gridnms["controller.50"]);

	  gridnms["model.50"] = gridnms["app"] + ".model." + gridnms["grid.50"];

	  gridnms["store.50"] = gridnms["app"] + ".store." + gridnms["grid.50"];

	  gridnms["models.popup3"].push(gridnms["model.50"]);

	  gridnms["stores.popup3"].push(gridnms["store.50"]);

	  fields["model.50"] = [{
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
	      name: 'GROUPCODE',
	    }, {
	      type: 'string',
	      name: 'BIGCODE',
	    }, {
	      type: 'string',
	      name: 'BIGNAME',
	    }, {
	      type: 'string',
	      name: 'MIDDLECODE',
	    }, {
	      type: 'string',
	      name: 'MIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'SMALLCODE',
	    }, {
	      type: 'string',
	      name: 'SMALLNAME',
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
	      type: 'number',
	      name: 'SALESPRICE',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
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
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
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
	    }, {
	      type: 'string',
	      name: 'ORDERINSPECTIONYN',
	    }, {
	      type: 'string',
	      name: 'INVENTORYMANAGEYN',
	    }, {
	      type: 'number',
	      name: 'SAFETYINVENTORY',
	    }, {
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'number',
	      name: 'TOOLLIFE',
	    }, ];

	  fields["columns.50"] = [
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
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'BIGNAME',
	      text: '대분류',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'MIDDLENAME',
	      text: '중분류',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SMALLNAME',
	      text: '소분류',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '공구명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격 ( 사양 )',
	      xtype: 'gridcolumn',
	      width: 240,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
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
	      dataIndex: 'ORDERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SALESPRICE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOMNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODELNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'REMARKS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERINSPECTIONYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'INVENTORYMANAGEYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SAFETYINVENTORY',
	      xtype: 'hidden',
	    }, ];

	  items["api.50"] = {};
	  $.extend(items["api.50"], {
	    read: "<c:url value='/searchItemCodeOrderLov.do' />"
	  });

	  items["btns.50"] = [];

	  items["btns.ctr.50"] = {};

	  items["dock.paging.50"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.50"],
	  };

	  items["dock.btn.50"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.50"],
	    items: items["btns.50"],
	  };

	  items["docked.50"] = [];
	}

	var gridarea1, gridarea2, gridarea3, gridarea4, gridarea5;
	function setExtGrid() {
	  setExtGrid_routing();
	  setExtGrid_detail();
	  setExtGrid_master();
	  setExtGrid_tool();
	  setExtGrid_popup3(); // 공구 불러오기

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea1.updateLayout();
	    gridarea2.updateLayout();
	    gridarea3.updateLayout();
	    gridarea4.updateLayout();
	    gridarea5.updateLayout();
	  });
	}

	function setExtGrid_routing() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });

	  Ext.define(gridnms["model.11"], {
	    extend: Ext.data.Model,
	    fields: fields["model.11"]
	  });

	  Ext.define(gridnms["model.12"], {
	    extend: Ext.data.Model,
	    fields: fields["model.12"]
	  });

	  Ext.define(gridnms["model.13"], {
	    extend: Ext.data.Model,
	    fields: fields["model.13"]
	  });

	  Ext.define(gridnms["model.14"], {
	    extend: Ext.data.Model,
	    fields: fields["model.14"]
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
	              type: 'ajax',
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'ROUTING_NAME',
	                GUBUN: 'ROUTING_NAME',
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
	              type: 'ajax',
	              url: "<c:url value='/searchCustomernameLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                CUSTOMERTYPE2: 'O',
	                USEYN: 'Y',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.13"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.13"],
	            model: gridnms["model.13"],
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: 'ajax',
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'ROUTING_GROUP',
	                GUBUN: 'ROUTING_GROUP',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
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
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: 'ajax',
	              url: "<c:url value='/searchWorkerLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                DEPTCODE: 'A100',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      routingClick: '#routingClick',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    //     btnDel1 : btnDel1,
	    btnRef1: btnRef1,
	    routingClick: routingClick,
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
	        height: 230, //235, // 205, // 155,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'routingClick',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ROUTINGOP') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }

	                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
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
	                //                  var data = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.routing"]).selModel.getSelection()[0].id);

	                var params = {};
	                var editDisableCols = [];

	                var gubun = data.data.OUTSIDEORDERGUBUN;
	                if (gubun != "Y") {
	                  editDisableCols.push("CUSTOMERNAMEOUT");
	                }

	                var isNew = ctx.record.phantom || false;
	                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
	                  return false;
	                else {
	                  return true;
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
	    models: gridnms["models.routing"],
	    stores: gridnms["stores.routing"],
	    views: gridnms["views.routing"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.routing"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });
	}

	function setExtGrid_detail() {
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

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      equipmentClick: '#equipmentClick',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

	    btnSav2: btnSav2,
	    btnRef2: btnRef2,
	    equipmentClick: equipmentClick,
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
	        height: 230, //235, // 205, // 250,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'equipmentClick',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('WORKCENTERCODE') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 100) {
	                    column.width = 100;
	                  }
	                }

	                if (column.dataIndex.indexOf('WORKCENTERNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
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
	          renderTo: 'gridDetailArea'
	        });
	    },
	  });
	}

	function setExtGrid_master() {
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
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: 'ajax',
	              api: items["api.3"],
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
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

	  Ext.define(gridnms["controller.3"], {
	    extend: Ext.app.Controller,
	    refs: {
	      itemMasterListClick: '#itemMasterListClick',
	    },
	    stores: [gridnms["store.3"]],
	    control: items["btns.ctr.3"],

	    itemMasterListClick: itemMasterListClick,
	  });

	  Ext.define(gridnms["panel.3"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.3"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.3"],
	        id: gridnms["panel.3"],
	        store: gridnms["store.3"],
	        height: 150,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.3"],
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
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0) {
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
	        dockedItems: items["docked.3"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.master"],
	    stores: gridnms["stores.master"],
	    views: gridnms["views.master"],
	    controllers: gridnms["controller.3"],

	    launch: function () {
	      gridarea3 = Ext.create(gridnms["views.master"], {
	          renderTo: 'gridArea2'
	        });
	    },
	  });
	}

	function setExtGrid_tool() {
	  Ext.define(gridnms["model.4"], {
	    extend: Ext.data.Model,
	    fields: fields["model.4"]
	  });

	  Ext.define(gridnms["model.41"], {
	    extend: Ext.data.Model,
	    fields: fields["model.41"]
	  });

	  Ext.define(gridnms["model.42"], {
	    extend: Ext.data.Model,
	    fields: fields["model.42"]
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
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true,
	              }),
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
	              type: 'ajax',
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'TOOL_CHECK_CODE',
	                GUBUN: 'TOOL_CHECK_CODE',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.42"], {
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
	              type: 'ajax',
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'QM',
	                MIDDLECD: 'CHECK_METHOD_TYPE',
	                GUBUN: 'CHECK_METHOD_TYPE',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.4"], {
	    extend: Ext.app.Controller,
	    refs: {
	      toolCheckList: '#toolCheckList',
	    },
	    stores: [gridnms["store.4"]],
	    control: items["btns.ctr.4"],

	    btnSel4: btnSel4,
	    btnSav4: btnSav4,
	    btnRef4: btnRef4,
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
	        height: 215, // 155,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.4"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'toolCheckList',
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.autoResizeWidth)
	                  column.autoSize();
	              });
	            }
	          }
	        },
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;
	                //                      var data = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.tool"]).selModel.getSelection()[0].id);

	                var params = {};
	                var editDisableCols = [];

	                if (data.data.ROUTINGID !== "") {
	                  //                                       editDisableCols.push("ROUTINGNAME");

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
	        dockedItems: items["docked.4"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.tool"],
	    stores: gridnms["stores.tool"],
	    views: gridnms["views.tool"],
	    controllers: gridnms["controller.4"],

	    launch: function () {
	      gridarea4 = Ext.create(gridnms["views.tool"], {
	          renderTo: 'gridArea4'
	        });
	    },
	  });
	}

	function setExtGrid_popup3() {
	  Ext.define(gridnms["model.50"], {
	    extend: Ext.data.Model,
	    fields: fields["model.50"],
	  });

	  Ext.define(gridnms["store.50"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.50"],
	            model: gridnms["model.50"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.50"],
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.50"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ToolPopup: '#ToolPopup',
	    },
	    stores: [gridnms["store.50"]],
	  });

	  Ext.define(gridnms["panel.50"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.50"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.50"],
	        id: gridnms["panel.50"],
	        store: gridnms["store.50"],
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
	        columns: fields["columns.50"],
	        viewConfig: {
	          itemId: 'ToolPopup',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.50"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup3"],
	    stores: gridnms["stores.popup3"],
	    views: gridnms["views.popup3"],
	    controllers: gridnms["controller.50"],

	    launch: function () {
	      gridarea5 = Ext.create(gridnms["views.popup3"], {
	          renderTo: 'gridPopup3Area'
	        });
	    },
	  });
	}

	  //라우팅복사 팝업
	  function setValues_Popup() {
	    gridnms["models.popup1"] = [];
	    gridnms["stores.popup1"] = [];
	    gridnms["views.popup1"] = [];
	    gridnms["controllers.popup1"] = [];

	    gridnms["grid.40"] = "Popup1";

	    gridnms["panel.40"] = gridnms["app"] + ".view." + gridnms["grid.40"];
	    gridnms["views.popup1"].push(gridnms["panel.40"]);

	    gridnms["controller.40"] = gridnms["app"] + ".controller." + gridnms["grid.40"];
	    gridnms["controllers.popup1"].push(gridnms["controller.40"]);

	    gridnms["model.40"] = gridnms["app"] + ".model." + gridnms["grid.40"];

	    gridnms["store.40"] = gridnms["app"] + ".store." + gridnms["grid.40"];

	    gridnms["models.popup1"].push(gridnms["model.40"]);

	    gridnms["stores.popup1"].push(gridnms["store.40"]);

	    fields["model.40"] = [{
	        type: 'number',
	        name: 'RN',
	      }, {
	        type: 'string',
	        name: 'ORGID',
	      }, {
	        type: 'string',
	        name: 'COMAPNYID',
	      }, {
	        type: 'string',
	        name: 'ITEMCODE',
	      }, {
	        type: 'string',
	        name: 'DRAWINGNO',
	      }, {
	        type: 'string',
	        name: 'ITEMNAME',
	      }, {
	        type: 'string',
	        name: 'ITEMTYPE',
	      }, {
	        type: 'string',
	        name: 'UOM',
	      }, {
	        type: 'string',
	        name: 'UOMNAME',
	      }, {
	        type: 'string',
	        name: 'MODEL',
	      }, {
	        type: 'string',
	        name: 'MODELNAME',
	      }, {
	        type: 'string',
	        name: 'CUSTOMERGUBUN',
	      }, {
	        type: 'string',
	        name: 'CUSTOMERGUBUNNAME',
	      }, ];

	    fields["columns.40"] = [{
	        dataIndex: 'RN',
	        text: '순번',
	        xtype: 'gridcolumn',
	        width: 55,
	        hidden: false,
	        sortable: false,
	        resizable: false,
	        align: "center",
	      }, {
	        dataIndex: 'ORDERNAME',
	        text: '품번',
	        xtype: 'gridcolumn',
	        width: 130,
	        hidden: false,
	        sortable: false,
	        resizable: false,
	        style: 'text-align:center;',
	        align: "center",
	      }, {
	        dataIndex: 'DRAWINGNO',
	        text: '도번',
	        xtype: 'gridcolumn',
	        width: 130,
	        hidden: false,
	        sortable: false,
	        resizable: false,
	        style: 'text-align:center;',
	        align: "center",
	      }, {
	        dataIndex: 'ITEMNAME',
	        text: '품명',
	        xtype: 'gridcolumn',
	        width: 230,
	        hidden: false,
	        sortable: false,
	        resizable: false,
	        style: 'text-align:center;',
	        align: "left",
	      }, {
	        dataIndex: 'CUSTOMERGUBUNNAME',
	        text: '거래처',
	        xtype: 'gridcolumn',
	        width: 120,
	        hidden: false,
	        sortable: false,
	        resizable: false,
	        style: 'text-align:center;',
	        align: "center",
	      }, {
	        menuDisabled: true,
	        sortable: false,
	        xtype: 'widgetcolumn',
	        stopSelection: true,
	        width: 70,
	        text: '적용',
	        style: 'text-align:center',
	        align: "center",
	        widget: {
	          xtype: 'button',
	          _btnText: "적용",
	          defaultBindProperty: null, //important
	          handler: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();

	            var orgid = record.data.ORGID;
	            var companyid = record.data.COMPANYID;
	            var itemcode = record.data.ITEMCODE;
	            var itemcodepost = $('#searchItemcd').val();

	            var url = "<c:url value='/pkg/routing/RoutingCopyRegister.do' />";

	            var params = {
	              ORGID: orgid,
	              COMPANYID: companyid,
	              ITEMCODE: itemcode,
	              ITEMCODEPOST: itemcodepost,
	            };

	            $.ajax({
	              url: url,
	              type: "post",
	              dataType: "json",
	              data: params,
	              success: function (data) {
	                var dataList = data;
	                var rscode = data.RETURNESTATUS;
	                var errmsg = data.MSGDATA;

	                if (rscode === "E") {
	                  // 실패
	                  var msg = "관리자에게 문의하십시오.<br/>" + errmsg;
	                  extAlert(msg);
	                  return;
	                } else if (rscode === "S") {
	                  // 성공
	                  var msg = "[성공] 정상적으로 복사되었습니다";
	                  extAlert(msg);
	                }
	                //win1.close();
	                //extAlert("정상적으로 복사되었습니다.");
	                var sparams = {
	                  ORGID: $('#searchOrgId').val(),
	                  COMPANYID: $('#searchCompanyId').val(),
	                  ITEMCODE: $('#searchItemcd').val(),
	                };
	                extGridSearch(sparams, gridnms["store.1"]);
	                setTimeout(function () {
	                  extGridSearch(sparams, gridnms["store.2"]);
	                }, 200);
	                setTimeout(function () {
	                  extGridSearch(sparams, gridnms["store.3"]);
	                }, 400);
	              },
	            });
	          },
	          listeners: {
	            beforerender: function (widgetColumn) {
	              var record = widgetColumn.getWidgetRecord();
	              widgetColumn.setText(widgetColumn._btnText); // _btnText 문구를 위젯컬럼에서 선언해주는 기능
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
	        dataIndex: 'UOM',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'ITEMTYPE',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'ORDERNAME',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'CUSTOMERCODE',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'CUSTOMERNAME',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'ITEMCODE',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'UOM',
	        xtype: 'hidden',
	      }, {
	        dataIndex: 'UOMNAME',
	        xtype: 'hidden',
	      }, ];

	    items["api.40"] = {};
	    $.extend(items["api.40"], {
	      read: "<c:url value='/searchRoutingCopyListLov.do' />"
	    });

	    items["btns.40"] = [];

	    items["btns.ctr.40"] = {};

	    items["dock.paging.40"] = {
	      xtype: 'pagingtoolbar',
	      dock: 'bottom',
	      displayInfo: true,
	      store: gridnms["store.40"],
	    };

	    items["dock.btn.40"] = {
	      xtype: 'toolbar',
	      dock: 'top',
	      displayInfo: true,
	      store: gridnms["store.40"],
	      items: items["btns.40"],
	    };

	    items["docked.40"] = [];
	  }

	  var gridpopup1;
	  function setExtGrid_Popup() {

	    Ext.define(gridnms["model.40"], {
	      extend: Ext.data.Model,
	      fields: fields["model.40"],
	    });

	    Ext.define(gridnms["store.40"], {
	      extend: Ext.data.Store,
	      constructor: function (cfg) {
	        var me = this;
	        cfg = cfg || {};
	        me.callParent([Ext.apply({
	              storeId: gridnms["store.40"],
	              model: gridnms["model.40"],
	              autoLoad: false,
	              pageSize: 999999,
	              proxy: {
	                type: 'ajax',
	                api: items["api.40"],
	                extraParams: {
	                  ORGID: $('#popupOrgId').val(),
	                  COMPANYID: $('#popupCompanyId').val(),
	                },
	                reader: gridVals.reader,
	              }
	            }, cfg)]);
	      },
	    });

	    Ext.define(gridnms["controller.40"], {
	      extend: Ext.app.Controller,
	      refs: {
	        btnPopup1: '#btnPopup1',
	      },
	      stores: [gridnms["store.40"]],
	      control: items["btns.ctr.40"],
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
	          height: 400,
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
	          columns: fields["columns.40"],
	          defaults: gridVals.defaultField,
	          viewConfig: {
	            itemId: 'btnPopup1',
	            trackOver: true,
	            loadMask: true,
	          },
	          dockedItems: items["docked.40"],
	        }
	      ],
	    });

	    Ext.application({
	      name: gridnms["app"],
	      models: gridnms["models.popup1"],
	      stores: gridnms["stores.popup1"],
	      views: gridnms["views.popup1"],
	      controllers: gridnms["controller.40"],

	      launch: function () {
	        gridpopup1 = Ext.create(gridnms["views.popup1"], {
	            renderTo: 'gridPopup1Area'
	          });
	      },
	    });
	  }

	  var popcount = 0, popupclick = 0;
	  function fn_copy() {
	    var header = [],
	    count = 0;
	    var dataSuccess = 0;
	    var result = null;

	    // 라우팅복사 팝업
	    var width = 908; // 가로
	    var height = 475; // 500; // 세로
	    var title = "제조공정 복사 Pop Up";

	    var check = true;

	    var url = "<c:url value='/select/routing/RoutingRegister.do' />";

	    var params = {
	      ORGID: $('#searchOrgId').val(),
	      COMPANYID: $('#searchCompanyId').val(),
	      ITEMCODE: $('#searchItemcd').val(),
	    };

	    $.ajax({
	      url: url,
	      type: "post",
	      dataType: "json",
	      data: params,
	      success: function (data) {
	        var dataCount = data.totcnt;

	        var itemcode = $('#searchItemcd').val();

	        if (itemcode == "") {
	          extAlert("생성시킬 제품을 먼저 선택 해 주십시오.");
	          return;
	        }

	        if (dataCount > 0) {
	          extAlert("해당 제품의 데이터가 없는 상태에서만 복사가 가능합니다.");
	          check = false;
	          return;
	        } else {
	          popupclick = 0;
	          if (check == true) {
	            // 데이터가 없는 상태에서만 팝업 표시하도록 처리
	            $('#popupOrgId').val($('#searchOrgId option:selected').val());
	            $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	            $('#popupItemName').val(""),
	            $('#popupOrderName').val(""),
	            $('#popupCustomerName').val(""),
	            $('#popupCarTypeName').val(""),
	            Ext.getStore(gridnms['store.40']).removeAll();

	            var sparams = {
	              ORGID: $('#popupOrgId').val(),
	              COMPANYID: $('#popupCompanyId').val(),
	            };

	            extGridSearch(sparams, gridnms["store.40"]);

	            win1 = Ext.create('Ext.window.Window', {
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
	                    itemId: gridnms["panel.40"],
	                    id: gridnms["panel.40"],
	                    store: gridnms["store.40"],
	                    height: '100%',
	                    border: 2,
	                    scrollable: true,
	                    frameHeader: true,
	                    columns: fields["columns.40"],
	                    defaults: gridVals.defaultField,
	                    viewConfig: {
	                      itemId: 'btnPopup1'
	                    },
	                    plugins: 'bufferedrenderer',
	                    dockedItems: items["docked.40"],
	                  }
	                ],
	                tbar: [
	                  '품번', {
	                    xtype: 'textfield',
	                    name: 'searchOrderName',
	                    clearOnReset: true,
	                    hideLabel: true,
	                    width: 100,
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
	                    name: 'searchItemName',
	                    clearOnReset: true,
	                    hideLabel: true,
	                    width: 120,
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
	                  '거래처', {
	                    xtype: 'textfield',
	                    name: 'searchCustomerName',
	                    clearOnReset: true,
	                    hideLabel: true,
	                    width: 100,
	                    editable: true,
	                    allowBlank: true,
	                    listeners: {
	                      scope: this,
	                      buffer: 50,
	                      change: function (value, nv, ov, e) {
	                        value.setValue(nv.toUpperCase());
	                        var result = value.getValue();

	                        $('#popupCustomerName').val(result);
	                      },
	                    },
	                  }, {
	                    text: '조회',
	                    scope: this,
	                    handler: function () {
	                      var sparams = {
	                        ORGID: $('#popupOrgId').val(),
	                        COMPANYID: $('#popupCompanyId').val(),
	                        ITEMNAME: $('#popupItemName').val(),
	                        ORDERNAME: $('#popupOrderName').val(),
	                        CUSTOMERNAME: $('#popupCustomerName').val(),
	                        CARTYPENAME: $('#popupCarTypeName').val(),
	                      };

	                      extGridSearch(sparams, gridnms["store.40"]);
	                    }
	                  },
	                ]
	              });

	            win1.show();
	          }
	        }
	      },
	      error: ajaxError
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
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 선택해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  $('#searchItemcd').val("");
	  $('#routingid').val("");
	  $('#routingno').val("");
	  $('#equipmentcode').val("");

	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    ITEMCODE: $('#searchItemcd').val(),
	    ORDERNAME: $('#searchOrdernm').val(), // 품번
	    ITEMNAME: $('#searchItemnm').val(), // 품명
	    ITEMTYPE: "A", // 유형
	    ROUTINGCHECK: $('#searchItemCheck').val(), // 등록여부
	    BIGCODE: $('#searchBigcd').val(),

	    orgid: $('#searchOrgId').val(),
	    companyid: $('#searchCompanyId').val(),
	    itemcode: $('#searchItemcd').val(),
	    ordername: $('#searchOrdernm').val(), // 품번
	    itemname: $('#searchItemnm').val(), // 품명
	    routingcheck: $('#searchItemCheck').val(), // 등록여부
	    routingid: "",
	    equipmentcode: "",
	  };

	  extGridSearch(sparams, gridnms["store.3"]); // 품목 마스터

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.1"]); // Routing List 정보
	  }, 200);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]); // 설비 연결 정보
	  }, 400);

	  $('#routingid').val("");
	  $('#routingno').val("");
	  $('#equipmentcode').val("");
	}

	function fn_excel_download() {
	  //    if (!fn_validation()) {
	  //      return;
	  //    }

	  var orgid = $('#searchOrgId').val();
	  var companyid = $('#searchCompanyId').val();
	  var itemcode = $('#searchItemcd').val();
	  var ordername = $('#searchOrdernm').val();
	  var bigcd = $('#searchBigcd').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/routing/ExcelDownload.do?GUBUN='/>" + "ROUTING"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&ITEMCODE=" + itemcode + ""
	     + "&ORDERNAME=" + ordername + ""
	     + "&BIGCODE=" + bigcd + ""
	     + "&TITLE=" + title + "");
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
	        GROUPCODE: $('#searchGroupCode1').val(),
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

	  //      // 품번 Lov
	  //      $("#searchOrdernm")
	  //      .bind("keydown", function (e) {
	  //        switch (e.keyCode) {
	  //        case $.ui.keyCode.TAB:
	  //          if ($(this).autocomplete("instance").menu.active) {
	  //            e.preventDefault();
	  //          }
	  //          break;
	  //        case $.ui.keyCode.BACKSPACE:
	  //        case $.ui.keyCode.DELETE:
	  //          $("#searchItemcd").val("");
	  //          $("#searchItemnm").val("");
	  //          break;
	  //        case $.ui.keyCode.ENTER:
	  //          $(this).autocomplete("search", "%");
	  //          break;

	  //        default:
	  //          break;
	  //        }
	  //      })
	  //      .bind("keyup", function (e) {
	  //        if (this.value === "")
	  //          $(this).autocomplete("search", "%");
	  //      })
	  //      .focus(function (e) {
	  //        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //      })
	  //      .click(function (e) {
	  //        $(this).autocomplete("search", "%");
	  //      })
	  //      .autocomplete({
	  //        source: function (request, response) {
	  //          $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //            keyword: extractLast(request.term),
	  //            ORGID: $('#searchOrgId option:selected').val(),
	  //            COMPANYID: $('#searchCompanyId option:selected').val(),
	  //            BIGCODE: $('#searchBigcd').val(),
	  //            GUBUN: 'ORDERNAME', // 제품, 반제품 조회
	  //          }, function (data) {
	  //            response($.map(data.data, function (m, i) {
	  //                return $.extend(m, {
	  //                  label: m.ORDERNAME + ', ' + m.ITEMNAME,
	  //                  value: m.ITEMCODE,
	  //                  ITEMNAME: m.ITEMNAME,
	  //                  ORDERNAME: m.ORDERNAME,
	  //                });
	  //              }));
	  //          });
	  //        },
	  //        search: function () {
	  //          if (this.value === "")
	  //            return;

	  //          var term = extractLast(this.value);
	  //          if (term.length < 1) {
	  //            return false;
	  //          }
	  //        },
	  //        focus: function () {
	  //          return false;
	  //        },
	  //        select: function (e, o) {
	  //          $("#searchItemcd").val(o.item.value);
	  //          $("#searchItemnm").val(o.item.ITEMNAME);
	  //          $("#searchOrdernm").val(o.item.ORDERNAME);
	  //          return false;
	  //        }
	  //      });

	  //      // 품명 Lov
	  //      $("#searchItemnm")
	  //      .bind("keydown", function (e) {
	  //        switch (e.keyCode) {
	  //        case $.ui.keyCode.TAB:
	  //          if ($(this).autocomplete("instance").menu.active) {
	  //            e.preventDefault();
	  //          }
	  //          break;
	  //        case $.ui.keyCode.BACKSPACE:
	  //        case $.ui.keyCode.DELETE:
	  //          $("#searchItemcd").val("");
	  //          $("#searchOrdernm").val("");
	  //          break;
	  //        case $.ui.keyCode.ENTER:
	  //          $(this).autocomplete("search", "%");
	  //          break;

	  //        default:
	  //          break;
	  //        }
	  //      })
	  //      .bind("keyup", function (e) {
	  //        if (this.value === "")
	  //          $(this).autocomplete("search", "%");
	  //      })
	  //      .focus(function (e) {
	  //        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //      })
	  //      .click(function (e) {
	  //        $(this).autocomplete("search", "%");
	  //      })
	  //      .autocomplete({
	  //        source: function (request, response) {
	  //          $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //            keyword: extractLast(request.term),
	  //            ORGID: $('#searchOrgId option:selected').val(),
	  //            COMPANYID: $('#searchCompanyId option:selected').val(),
	  //            BIGCODE: $('#searchBigcd').val(),
	  //            GUBUN: 'ITEMNAME', // 제품, 반제품 조회
	  //          }, function (data) {
	  //            response($.map(data.data, function (m, i) {
	  //                return $.extend(m, {
	  //                  label: m.ITEMNAME + ', ' + m.ORDERNAME,
	  //                  value: m.ITEMCODE,
	  //                  ITEMNAME: m.ITEMNAME,
	  //                  ORDERNAME: m.ORDERNAME,
	  //                });
	  //              }));
	  //          });
	  //        },
	  //        search: function () {
	  //          if (this.value === "")
	  //            return;

	  //          var term = extractLast(this.value);
	  //          if (term.length < 1) {
	  //            return false;
	  //          }
	  //        },
	  //        focus: function () {
	  //          return false;
	  //        },
	  //        select: function (e, o) {
	  //          $("#searchItemcd").val(o.item.value);
	  //          $("#searchItemnm").val(o.item.ITEMNAME);
	  //          $("#searchOrdernm").val(o.item.ORDERNAME);
	  //          return false;
	  //        }
	  //      });
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
                <input type="hidden" id="routingid" name="routingid" />
                <input type="hidden" id="routingno" name="routingno" />
                <input type="hidden" id="equipmentcode" name="equipmentcode" />
                <input type="hidden" id="searchGroupCode" name="searchGroupCode" value="T" />
                <input type="hidden" id="popupOrgId" name="popupOrgId" />
                <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                <input type="hidden" id="popupItemName" name="popupItemName" />
                <input type="hidden" id="popupItemStandard" name="popupItemStandard" />
                <input type="hidden" id="popupOrderName" name="popupOrderName" />
                <input type="hidden" id="popupCarTypeName" name="popupCarTypeName" />
                <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
                <div id="search_field" style="margin-bottom: 0px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <fieldset>
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <input type="hidden" id="searchGroupCode1" name="searchGroupCode1" value="A" />
		                        <div>
		                            <table class="tbl_type_view" border="1">
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
	                                                <option value="" >전체</option>
	                                                <option value="Y" >Routing 등록</option>
	                                                <option value="N" >Routing 미등록</option>
	                                            </c:if>
	                                        </select>
	                                      </td>
                                        <td>
	                                        <div class="buttons" style="float: right; margin-top: 3px;">
	                                            <a id="btnChk2" class="btn_add" href="#" onclick="javascript:fn_copy();">
	                                               복사
	                                            </a>
	                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
	                                               조회
	                                            </a>
	                                        </div>
                                        </td>
		                                </tr>
		                                <tr style="height: 34px;">
		                                    <th class="required_text">대분류</th>
		                                    <td>
		                                          <input type="text" id="searchBignm" name="searchBignm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
		                                          <input type="hidden" id="searchBigcd" name="searchBigcd" />
		                                    </td>
		                                    <th class="required_text">품번</th>
		                                    <td>
                                              <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
		                                          <input type="hidden" id="searchItemcd" name="searchItemcd" />
		                                    </td>
		                                    <th class="required_text">품명</th>
		                                    <td>
                                               <input type="text" id="searchItemnm" name="searchItemnm"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
		                                    </td>
                                        <td></td>
		                                </tr>
		                            </table>
		                        </div>
                        </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">품목 마스터</div></td>
                    </tr>
                </table>
                <div id="gridArea2" style="width: 100%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 60%;"><div class="subConTit3" style="margin-top: 10px;">ROUTING List 정보</div></td>
                        <td style="width: 39%;"><div class="subConTit3" style="margin-top: 10px;">설비 연결 정보</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 60%; margin-right: 1%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                <div id="gridDetailArea" style="width: 39%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">공구 List 정보</div></td>
                    </tr>
                </table>
                <div id="gridArea4" style="width: 100%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>
            </div>
            <!-- //content 끝 -->
        <div id="gridPopup3Area" style="width: 1050px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup1Area" style="width: 900px; padding-top: 0px; float: left;"></div>
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