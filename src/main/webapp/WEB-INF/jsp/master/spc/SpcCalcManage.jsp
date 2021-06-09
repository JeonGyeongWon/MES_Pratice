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
	  calender($('#searchRefDate'));

	  $('#searchRefDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchRefDate").val(getToDay("${searchVO.dateSys}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	     <%--상태 option 변경--%>
	  });

	  gridnms["app"] = "spc";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "SpcCalcManage";
	  gridnms["grid.11"] = "CalcDivLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.list"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.list"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

	  gridnms["models.list"].push(gridnms["model.1"]);
	  gridnms["models.list"].push(gridnms["model.11"]);

	  gridnms["stores.list"].push(gridnms["store.1"]);
	  gridnms["stores.list"].push(gridnms["store.11"]);

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
	      name: 'SEQ',
	    }, {
	      type: 'string',
	      name: 'CALCDIV',
	    }, {
	      type: 'string',
	      name: 'CALCDIVNAME',
	    }, {
	      type: 'number',
	      name: 'CALCNUMBER',
	    }, {
	      type: 'number',
	      name: 'SPCCALC',
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
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'CALCDIVNAME',
	      text: '구분',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.11"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: false,
	        queryParam: 'keyword',
	        queryMode: 'local', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

	            model.set("CALCDIV", record.get("VALUE"));
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
	      dataIndex: 'CALCNUMBER',
	      text: 'N',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: true,
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
	        maxLength: '9',
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'SPCCALC',
	      text: '계수',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.000",
	      editor: {
	        xtype: "textfield",
	        //           minValue: 1,
	        format: "0,000.000",
	        enforceMaxLength: true,
	        allowBlank: true,
	        maxLength: '9',
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000.000'),
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효시작일자',
	      xtype: 'datecolumn',
	      width: 130,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	      style: 'text-align:center;',
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
	      //        width: 160,
	      flex: 1,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	      dataIndex: 'SEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CALCDIV',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/spc/SpcCalcManage.do' />"
	  });
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/spc/SpcCalcManage.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/spc/SpcCalcManage.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/spc/SpcCalcManage.do' />"
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
	  //    items["btns.1"].push({
	  //      xtype: "button",
	  //      text: "삭제",
	  //      itemId: "btnDel1"
	  //    });
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
	    "#btnDel1": {
	      click: 'btnDel1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
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

	  model.set("ORGID", $("#searchOrgId").val());
	  model.set("COMPANYID", $("#searchCompanyId").val());

	  //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
	  var sortorder = 0;
	  var listcount = Ext.getStore(gridnms["store.1"]).count();
	  for (var i = 0; i < listcount; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	    var dummy = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	    var dummy_sort = dummy.data.RN * 1;
	    if (sortorder < dummy_sort) {
	      sortorder = dummy_sort;
	    }
	  }
	  sortorder++;

	  model.set("RN", sortorder);

	  model.set("SEQ", Ext.getStore(gridnms["store.1"]).count() + 1);
	  var startdate = Ext.util.Format.date("${searchVO.TODAY}", 'Y-m-d');
	  var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
	  model.set("EFFECTIVESTARTDATE", startdate);
	  model.set("EFFECTIVEENDDATE", enddate);

	  //   store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	  var view = Ext.getCmp(gridnms['panel.1']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 1);
	};

	function btnRef1(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	function btnSav1(o, e) {
	  // 저장시 필수값 체크
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	      var calcdiv = model.data.CALCDIV;
	      var effectivestartdate = model.data.EFFECTIVESTARTDATE;
	      var effectiveenddate = model.data.EFFECTIVEENDDATE;

	      if (calcdiv == "" || calcdiv == undefined) {
	        header.push("구분");
	        count++;
	      }

	      if (effectivestartdate == "" || effectivestartdate == undefined) {
	        header.push("유효시작일자");
	        count++;
	      }

	      if (effectiveenddate == "" || effectiveenddate == undefined) {
	        header.push("유효종료일자");
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

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  } else {
	    Ext.getStore(gridnms["store.1"]).sync({
	      success: function (batch, options) {
	        extAlert(msgs.noti.save, gridnms["store.1"]);
	        Ext.getStore(gridnms["store.1"]).load();
	      },
	      failure: function (batch, options) {
	        extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel1(o, e) {
	  extGridDel(gridnms["store.1"], gridnms["panel.1"]);
	};

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["model.11"], {
	    extend: Ext.data.Model,
	    fields: fields["model.11"],
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
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                REFDATE: $('#searchRefDate').val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
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
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'CALC_DIV'
	              },
	              reader: gridVals.reader,
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
	    btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    btnDel1: btnDel1,
	    btnRef1: btnRef1,
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
	        height: 687,
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
	                var data = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

	                var editDisableCols = [];
	                //                    editDisableCols.push("REMARKS");

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
	      gridarea = Ext.create(gridnms["views.list"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_search() {
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var refdate = $('#searchRefDate').val();
	  var calcdiv = $('#searchCalcDiv').val();
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
	    ORGID: orgid,
	    COMPANYID: companyid,
	    REFDATE: refdate,
	    CALCDIV: calcdiv,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
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
                    <div id="search_field">
                        <div id="search_field_loc">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
		                    <input type="hidden" id="SHIPNO" />
		                    <input type="hidden" id="ORGID" />
		                    <input type="hidden" id="COMPANYID" />
                        <input type="hidden" id="maxdate" value="${searchVO.dateMax}" />
                        <input type="hidden" id="popupDueFrom" />
                        <input type="hidden" id="popupDueTo" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
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
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
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
                                        <th class="required_text">기준일</th>
                                        <td >
                                            <input type="text" id="searchRefDate" name="searchDateFrom" class="input_validation input_center" style="width: 74%; " maxlength="10" />
                                        </td>
		                                    <th class="required_text">구분</th>
		                                    <td>
		                                        <select id="searchCalcDiv" name="searchCalcDiv" class="input_left validate[required]" style="width: 74%;">
		                                            <c:if test="${empty searchVO.CALCDIV}">
		                                                <option value="" >전체</option>
		                                            </c:if>
		                                            <c:forEach var="item" items="${labelBox.findByCalcDivType}" varStatus="status">
		                                                <c:choose>
		                                                    <c:when test="${item.VALUE==searchVO.CALCDIV}">
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
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
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