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
	  calender($('#searchPlanDate, #searchDate'));

	  $('#searchPlanDate, #searchDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchPlanDate").val(getToDay("${searchVO.dateSys}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	     <%--상태 option 변경--%>
	    fn_option_change('MFG', 'STATUS', 'searchStatus');

	     <%--생산구분 option 변경--%>
	    fn_option_change('MFG', 'WORK_TYPE', 'searchWorkType');
	  });

	  gridnms["app"] = "prod";
	}

	var colIdx = 0, rowIdx = 0;
	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_master();
	  setValues_detail();
	}

	function setValues_master() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["grid.1"] = "WorkOrderEnd";

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
	      name: 'WORKORDERID',
	    }, {
	      type: 'string',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'WORKSTATUS',
	    }, {
	      type: 'string',
	      name: 'WORKSTATUSNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'CARTYPE',
	    }, {
	      type: 'string',
	      name: 'CARTYPENAME',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'number',
	      name: 'WORKORDERQTY',
	    }, {
	      type: 'string',
	      name: 'MOLDCODE',
	    }, {
	      type: 'string',
	      name: 'MOLDNAME',
	    }, {
	      type: 'date',
	      name: 'WORKPLANSTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKPLANENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKSTARTDATE',
	      dateFormat: 'Y-m-d H:i',
	    }, {
	      type: 'date',
	      name: 'WORKENDDATE',
	      dateFormat: 'Y-m-d H:i',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'EXCESSQTYYN',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 35,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'checkbox',
	      },
	      renderer: function (value, meta, record, row, col) {
	        var status = record.data.WORKSTATUS;
	        if (status == "CANCEL" || status == "COMPLETE") {
	          meta['tdCls'] = 'x-item-disabled';
	          meta.style += " background-color: rgb(71, 200, 62);";
	        } else {
	          meta['tdCls'] = '';
	        }
	        return new Ext.ux.CheckColumn().renderer(value);
	      },
	      listeners: {
	        beforecheckchange: function (options, row, value, event) {

	          var record = Ext.getCmp(gridnms["views.viewer"]).selModel.store.data.items[row].data;
	          if (value) {
	            var status = record.WORKSTATUS;
	            var statusname = record.WORKSTATUSNAME;
	            if (status == "CANCEL" || status == "COMPLETE") {
	              extAlert(statusname + " 상태에서는 완료 처리가 불가능합니다.");
	              return false;
	            }

	          }
	        }
	      }
	    }, {
	      menuDisabled: true,
	      sortable: false,
	      resizable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      dataIndex: 'XXXXXXXXXX',
	      text: '',
	      width: 65,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "완료",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var status = record.data.WORKSTATUS;
	          var statusname = record.data.WORKSTATUSNAME;
	          if (status == "CANCEL" || status == "COMPLETE") {
	            extAlert(statusname + " 상태에서는 완료 처리가 불가능합니다.");
	            return;
	          }

	          fn_status_change(record.data, 'COMPLETE');
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
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'WORKORDERID',
	      text: '작업지시번호',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'textfield',
	        editable: false,
	        enableKeyEvents: true,
	        selectOnFocus: true,
	        listeners: {
	          specialkey: function (field, e) {
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'WORKSTATUSNAME',
	      text: '상태',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
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
	        editable: false,
	        enableKeyEvents: true,
	        selectOnFocus: true,
	        listeners: {
	          specialkey: function (field, e) {
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        editable: false,
	        enableKeyEvents: true,
	        selectOnFocus: true,
	        listeners: {
	          specialkey: function (field, e) {
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.viewer"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.viewer"], rowIdx, colIdx);
	            }
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'CARTYPENAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	      //      }, {
	      //        dataIndex: 'MATERIALTYPE',
	      //        text: '재질',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //         hidden: false,
	      //         sortable: false,
	      //         resizable: false,
	      //         menuDisabled: true,
	      //        align: "center",
	    },{
        dataIndex: 'ITEMSTANDARDDETAIL',
        text: '타입',
        xtype: 'gridcolumn',
        width: 110,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
          var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
          if (check) {
            meta.style = " background-color:rgb(255, 0, 0); ";
            meta.style += "color:white; ";
            meta.style += "font-weight: bold; ";
          }

          return value;
        },
        //      }, {
        //        dataIndex: 'MATERIALTYPE',
        //        text: '재질',
        //        xtype: 'gridcolumn',
        //        width: 120,
        //         hidden: false,
        //         sortable: false,
        //         resizable: false,
        //         menuDisabled: true,
        //        align: "center",
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
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    },{
	      dataIndex: 'WORKORDERQTY',
	      text: '작업지시수량',
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
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	      //      }, {
	      //          dataIndex: 'PRODUCEDQTY',
	      //          text: '작업완료수량',
	      //          xtype: 'gridcolumn',
	      //          width: 100,
	      //          hidden: false,
	      //          sortable: false,
	      //          style: 'text-align:center',
	      //          align: "right",
	      //          cls: 'ERPQTY',
	      //          format: "0,000",
	      //          renderer: Ext.util.Format.numberRenderer('0,000'),
	    },{
        dataIndex: 'IMPORTQTY',
        text: '생산수량',
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
        renderer: function (value, meta, record) {
          var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
          if (check) {
            meta.style = " background-color:rgb(255, 0, 0); ";
            meta.style += "color:white; ";
            meta.style += "font-weight: bold; ";
          }

          return Ext.util.Format.number(value, '0,000');
        },
        //      }, {
        //          dataIndex: 'PRODUCEDQTY',
        //          text: '작업완료수량',
        //          xtype: 'gridcolumn',
        //          width: 100,
        //          hidden: false,
        //          sortable: false,
        //          style: 'text-align:center',
        //          align: "right",
        //          cls: 'ERPQTY',
        //          format: "0,000",
        //          renderer: Ext.util.Format.numberRenderer('0,000'),
      }, {
	      dataIndex: 'WORKSTARTDATE',
	      text: '작업시작일시',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d H:i',
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.date(value, 'Y-m-d H:i');
	      },
	    }, {
	      dataIndex: 'WORKENDDATE',
	      text: '작업종료일시',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d H:i',
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.date(value, 'Y-m-d H:i');
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
	    },
	  ];
	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/work/WorkOrderEnd.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "전체선택/해제",
	    itemId: "btnChkd1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "일괄완료",
	    itemId: "btnComp1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnChkd1": {
	      click: 'btnChkd1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnComp1": {
	      click: 'btnComp1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnList": {
	      itemclick: 'workOrderClick'
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

	var chkFlag = true;
	function btnChkd1Click() {
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var checkTrue = 0,
	  checkFalse = 0;

	  if (chkFlag) {
	    chkFlag = false;
	  } else {
	    chkFlag = true;
	  }

	  for (i = 0; i < count1; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(i));
	    var model1 = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];

	    var ynstatus = model1.data.WORKSTATUS;

	    if (ynstatus != "CANCEL" && ynstatus != "COMPLETE") {
	      if (!chkFlag) {
	        // 체크 상태로
	        model1.set("CHK", true);
	        checkFalse++;
	      } else {
	        model1.set("CHK", false);
	        checkTrue++;
	      }
	    }
	  }
	  if (checkTrue > 0) {
	    console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
	  }
	  if (checkFalse > 0) {
	    console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
	  }
	}

	function btnComp1Click(o, e) {

	  var gridcount = Ext.getStore(gridnms["store.1"]).count() * 1;
	  if (gridcount == 0) {
	    extAlert("완료하실 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
	    return;
	  }

	  // 체크여부 확인
	  var count = 0;
	  for (var k = 0; k < gridcount; k++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(k));
	    var model = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];

	    if (model.data.CHK) {
	      count++;
	    }
	  }

	  var msgdata = "",
	  completecount = 0;
	  if (count > 0) {

	    Ext.MessageBox.confirm('완료 ', '일괄 완료처리를 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var url = "<c:url value='/update/prod/work/WorkProdEndStatus.do' />";

	        for (var j = 0; j < gridcount; j++) {
	          Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(j));
	          var record = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];

	          if (record.data.CHK) {

	            var orgid = record.data.ORGID;
	            var companyid = record.data.COMPANYID;
	            var workorderid = record.data.WORKORDERID;
	            var status = record.data.WORKSTATUS;
	            var statusname = record.data.WORKSTATUSNAME;
	            if (status == "CANCEL" || status == "COMPLETE") {
	              extAlert(statusname + " 상태에서는 완료 처리가 불가능합니다.");
	              return false;
	            }

	            var workstatus = "COMPLETE";

	            var sparams = {
	              ORGID: orgid,
	              COMPANYID: companyid,
	              WORKORDERID: workorderid,
	              WORKSTATUS: workstatus,
	            };

	            $.ajax({
	              url: url,
	              type: "post",
	              dataType: "json",
	              data: sparams,
	              success: function (data) {
	                msgdata = data.msg;

	                var returnstatus = data.success;
	                if (returnstatus) {
	                  completecount++;
	                }

	                if (completecount == count) {
	                  extAlert(msgdata);

	                  fn_search();
	                }
	              },
	              error: ajaxError
	            });
	          }

	        }
	      } else {
	        Ext.Msg.alert('완료', '완료 처리가 취소되었습니다.');
	        return;
	      }
	    });
	  } else {
	    extAlert("완료하실 항목이 선택되지 않았습니다.<br/>다시 한번 확인해주십시오.");
	    return;
	  }
	}

	function fn_status_change(record, flag) {
	  var flag_name = (flag == "COMPLETE") ? "완료" : "취소";
	  var workstatus = record.WORKSTATUS;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();
	  if (gridcount == 0) {
	    extAlert("[확정 " + flag_name + "]<br/>데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  if (workstatus == flag) {
	    extAlert("[확정 " + flag_name + "]<br/>이미 변경된 상태입니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  var url = "<c:url value='/update/prod/work/WorkProdEndStatus.do' />";
	  record.WORKSTATUS = flag;

	  Ext.MessageBox.confirm('확정 ' + flag_name, flag_name + ' 상태로 변경 하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      var params = [];
	      $.ajax({
	        url: url,
	        type: "post",
	        dataType: "json",
	        data: record,
	        success: function (data) {
	          var success = data.success;
	          var msg = data.msg;
	          if (!success) {
	            extAlert("관리자에게 문의하십시오.<br/>" + msg);
	            return;
	          } else {
	            extAlert(msg);

	            setTimeout(function () {
	              fn_search();
	            }, 500);
	          }
	        },
	        error: ajaxError
	      });

	    } else {
	      Ext.Msg.alert('확정 ' + flag_name, flag_name + ' 상태 변경이 취소되었습니다.');
	      record.WORKSTATUS = workstatus;
	      return;
	    }
	  });
	}

	function workOrderClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var workorderid = record.data.WORKORDERID;
	  var itemcode = record.data.ITEMCODE;
	  var worktype = record.data.WORKTYPE;
	  $('#workorderid').val(workorderid);
	  $('#itemcode').val(itemcode);
	  $('#worktype').val(worktype);
	  $('#rowIndexVal').val(index);

	  if (workorderid === "") {
	    Ext.getStore(gridnms["store.2"]).removeAll();

	  } else {
	    var sparams = {
	      ORGID: orgid,
	      COMPANYID: companyid,
	      WORKORDERID: workorderid,
	    };

	    extGridSearch(sparams, gridnms["store.2"]);
	  }
	}

	function setValues_detail() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "WorkOrderDetail";

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
	      name: 'WORKORDERID',
	    }, {
	      type: 'string',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'WORKSTATUS',
	    }, {
	      type: 'string',
	      name: 'WORKSTATUSNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
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
	      name: 'ROUTINGCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNO',
	    }, {
	      type: 'string',
	      name: 'ROUTINGOP',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'number',
	      name: 'WORKORDERQTY',
	    }, {
	      type: 'number',
	      name: 'DAILYQTY',
	    }, {
	      type: 'string',
	      name: 'MOLDCODE',
	    }, {
	      type: 'string',
	      name: 'MOLDNAME',
	    }, {
	      type: 'date',
	      name: 'WORKPLANSTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKPLANENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKSTARTDATE',
	      dateFormat: 'Y-m-d H:i',
	    }, {
	      type: 'date',
	      name: 'WORKENDDATE',
	      dateFormat: 'Y-m-d H:i',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'OUTSIDEORDERGUBUN',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODEOUT',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAMEOUT',
	    }, {
	      type: 'string',
	      name: 'FIRSTORDER',
	    }, {
	      type: 'string',
	      name: 'CHANGEEQUIP',
	    }, {
	      type: 'string',
	      name: 'CHANGEEQUIPNAME',
	    }, {
	      type: 'string',
	      name: 'EXCESSQTYYN1',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE2',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME2',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE3',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME3',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE4',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME4',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE5',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME5',
	    }, ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      menuDisabled: true,
	      sortable: false,
	      resizable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      dataIndex: 'XXXXXXXXXXX',
	      text: '',
	      width: 65,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "완료",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var status = record.data.WORKSTATUS;
	          var statusname = record.data.WORKSTATUSNAME;
	          if (status == "CANCEL" || status == "COMPLETE") {
	            extAlert(statusname + " 상태에서는 완료 처리가 불가능합니다.");
	            return;
	          }

	          fn_detail_status_change(record.data, 'COMPLETE');
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
	        }
	      }
	    }, {
	      menuDisabled: true,
	      sortable: false,
	      resizable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      dataIndex: 'XXXXXXXXXXX',
	      text: '',
	      width: 65,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "취소",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var status = record.data.WORKSTATUS;
	          if (status != "COMPLETE") {
	            extAlert("완료상태의 지시에 대해서만 취소 처리가 가능합니다.");
	            return;
	          }

	          fn_detail_status_change(record.data, 'BACK');
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
	        }
	      }
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      text: '작업<br/>순번',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'FIRSTORDERNAME',
	      text: '우선<br>순위',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'WORKSTATUSNAME',
	      text: '상태',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
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
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
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
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'EQUIPMENTNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	      //      }, {
	      //        dataIndex: 'WORKCENTERNAME2',
	      //        text: '설비명2',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	      //          if (check) {
	      //            meta.style = " background-color:rgb(255, 0, 0); ";
	      //            meta.style += "color:white; ";
	      //            meta.style += "font-weight: bold; ";
	      //          }

	      //          return value;
	      //        },
	      //      }, {
	      //        dataIndex: 'WORKCENTERNAME3',
	      //        text: '설비명3',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	      //          if (check) {
	      //            meta.style = " background-color:rgb(255, 0, 0); ";
	      //            meta.style += "color:white; ";
	      //            meta.style += "font-weight: bold; ";
	      //          }

	      //          return value;
	      //        },
	      //      }, {
	      //        dataIndex: 'WORKCENTERNAME4',
	      //        text: '설비명4',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	      //          if (check) {
	      //            meta.style = " background-color:rgb(255, 0, 0); ";
	      //            meta.style += "color:white; ";
	      //            meta.style += "font-weight: bold; ";
	      //          }

	      //          return value;
	      //        },
	      //      }, {
	      //        dataIndex: 'WORKCENTERNAME5',
	      //        text: '설비명5',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	      //          if (check) {
	      //            meta.style = " background-color:rgb(255, 0, 0); ";
	      //            meta.style += "color:white; ";
	      //            meta.style += "font-weight: bold; ";
	      //          }

	      //          return value;
	      //        },
	    }, {
	      dataIndex: 'CHANGEEQUIPNAME',
	      text: '변경설비',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        var result = value;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	          if (result != "") {
	            meta.style += " color:rgb(0, 0, 255);";
	            meta.style += " font-weight: bold;";
	          }
	        } else {

	          if (result != "") {
	            meta.style += " color:rgb(255, 0, 0);";
	            meta.style += " font-weight: bold;";
	          }
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'WORKORDERQTY',
	      text: '지시수량',
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

	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'DAILYQTY',
	      text: '일<br/>계획수량',
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

	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'WORKSTARTDATE',
	      text: '시작일',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d H:i',
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.date(value, 'Y-m-d H:i');
	      },
	    }, {
	      dataIndex: 'WORKENDDATE',
	      text: '종료일',
	      xtype: 'datecolumn',
	      width: 135,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d H:i',
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.date(value, 'Y-m-d H:i');
	      },
	    }, {
	      dataIndex: 'OUTSIDEORDERGUBUN',
	      text: '외주<br>구분',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'CUSTOMERNAMEOUT',
	      text: '외주거래처',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return value;
	      },
	    }, {
	      dataIndex: 'IMPORTQTY',
	      text: '양품수량',
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
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'DEFECTEDQTY',
	      text: '불량수량',
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
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'WORKER',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var check = (record.data.EXCESSQTYYN1 == "Y") ? true : false;
	        if (check) {
	          meta.style = " background-color:rgb(255, 0, 0); ";
	          meta.style += "color:white; ";
	          meta.style += "font-weight: bold; ";
	        }

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
	      dataIndex: 'WORKSTATUS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORORDERID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MOLDNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EQUIPMENTCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKCENTERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKCENTERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODEOUT',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHANGEEQUIP',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EXCESSQTYYN1',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/prod/work/WorkOrderEndD.do' />"
	  });

	  items["btns.2"] = [];

	  items["btns.ctr.2"] = {};

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

	function fn_detail_status_change(record, flag) {
	  var flag_name = (flag == "COMPLETE") ? "완료" : "취소";
	  var workstatus = record.WORKSTATUS;

	  var gridcount = Ext.getStore(gridnms["store.2"]).count();
	  if (gridcount == 0) {
	    extAlert("[확정 " + flag_name + "]<br/>상세데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  if (workstatus == flag) {
	    extAlert("[확정 " + flag_name + "]<br/>이미 변경된 상태입니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  var url = "<c:url value='/update/prod/work/WorkProdDetailStatus.do' />";
	  record.WORKSTATUS = flag;

	  Ext.MessageBox.confirm('확정 ' + flag_name, flag_name + ' 상태로 변경 하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      var params = [];
	      $.ajax({
	        url: url,
	        type: "post",
	        dataType: "json",
	        data: record,
	        success: function (data) {
	          var success = data.success;
	          var msg = data.msg;
	          if (!success) {
	            extAlert("관리자에게 문의하십시오.<br/>" + msg);
	            return;
	          } else {
	            extAlert(msg);

	            setTimeout(function () {
	              fn_search();
	            }, 500);
	          }
	        },
	        error: ajaxError
	      });

	    } else {
	      Ext.Msg.alert('확정 ' + flag_name, flag_name + ' 상태 변경이 취소되었습니다.');
	      record.WORKSTATUS = workstatus;
	      return;
	    }
	  });
	}

	var gridarea, gridareadetail;
	function setExtGrid() {
	  setExtGrid_master();
	  setExtGrid_detail();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    gridareadetail.updateLayout();
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
	                WORKPLANDATE: $('#searchPlanDate').val(),
	                WORKSTATUS: $('#searchStatus').val(),
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
	      btnList: '#btnList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnChkd1Click: btnChkd1Click,
	    btnComp1Click: btnComp1Click,
	    workOrderClick: workOrderClick
	  });

	  Ext.define(gridnms["panel.1"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.1"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.1"],
	        id: gridnms["panel.1"],
	        store: gridnms["store.1"],
	        height: 321,
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
	          itemId: 'btnList',
	          trackOver: true,
	          loadMask: true,
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
	      gridarea = Ext.create(gridnms["views.viewer"], {
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
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                WORKPLANDATE: $('#searchPlanDate').val(),
	                WORKSTATUS: $('#searchStatus').val(),
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
	      btnListdetail: '#btnListdetail',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],
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
	        height: 275,
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
	          itemId: 'btnListdetail',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }
	                if (column.dataIndex.indexOf('CHANGEEQUIPNAME') >= 0) {
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
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridareadetail = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridViewAreadetail'
	        });
	    },
	  });

	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var workdate = $('#searchDate').val();
	  var workplandate = $('#searchPlanDate').val();
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
	    result = false;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  chkFlag = true;
	  
	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    WORKDATE: $('#searchDate').val(),
	    WORKPLANDATE: $('#searchPlanDate').val(),
	    WORKSTATUS: $('#searchStatus option:selected').val(),
	    WORKTYPE: $('#searchWorkType option:selected').val(),
	    WORKORDERID: $('#searchWorkNo').val(),
	    ROUTINGCODE: $('#searchRoutingCode').val(),
	    WORKCENTERCODE: $('#searchWorkCenterCode').val(),
	    ITEMCODE: $('#searchItemCode').val(),
      ORDERNAME: $('#searchOrderName').val(),
      ITEMNAME: $('#searchItemName').val(),
      MODELNAME: $('#searchModelName').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 200);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 작업지시번호 Lov
	  $("#searchWorkNo").bind("keydown", function (e) {
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
	      $.getJSON("<c:url value='/searchWorkNoListLov.do' />", {
	        keyword: extractLast(request.term),
	        WORKPLANDATE: $('#searchPlanDate').val(),
	        WORKDATE: $('#searchDate').val(),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.WORKORDERID,
	              label: m.WORKORDERID,
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
	      $("#searchWorkNo").val(o.item.value);

	      return false;
	    }
	  });

// 	  // 품번 Lov
// 	  $("#searchOrderName").bind("keydown", function (e) {
// 	    switch (e.keyCode) {
// 	    case $.ui.keyCode.TAB:
// 	      if ($(this).autocomplete("instance").menu.active) {
// 	        e.preventDefault();
// 	      }
// 	      break;
// 	    case $.ui.keyCode.BACKSPACE:
// 	    case $.ui.keyCode.DELETE:
// 	      //             $("#searchOrderName").val("");
// 	      $("#searchItemCode").val("");
// 	      $("#searchItemName").val("");
// 	      $("#searchModel").val("");
// 	      $("#searchModelName").val("");

// 	      break;
// 	    case $.ui.keyCode.ENTER:
// 	      $(this).autocomplete("search", "%");
// 	      break;

// 	    default:
// 	      break;
// 	    }
// 	  }).focus(
// 	    function (e) {
// 	    $(this).autocomplete("search",
// 	      (this.value === "") ? "%" : this.value);
// 	  }).autocomplete({
// 	    source: function (request, response) {
// 	      $.getJSON("<c:url value='/searchItemCodeOrderLov.do' />", {
// 	        keyword: extractLast(request.term),
// 	        ORGID: $('#searchOrgId option:selected').val(),
// 	        COMPANYID: $('#searchCompanyId option:selected').val(),
// 	        GROUPCODE: $('#searchGroupCode').val(),
// 	        GUBUN: 'ORDERNAME',
// 	      }, function (data) {
// 	        response($.map(data.data, function (m, i) {
// 	            return $.extend(m, {
// 	              label: m.ORDERNAME + ', ' + m.ITEMNAME + ', ' + m.MODELNAME,
// 	              value: m.ITEMCODE,
// 	              ITEMNAME: m.ITEMNAME,
// 	              ORDERNAME: m.ORDERNAME,
// 	              MODEL: m.MODEL,
// 	              MODELNAME: m.MODELNAME,
// 	            });
// 	          }));
// 	      });
// 	    },
// 	    search: function () {
// 	      if (this.value === "")
// 	        return;
// 	      var term = extractLast(this.value);
// 	      if (term.length < 1) {
// 	        return false;
// 	      }
// 	    },
// 	    focus: function () {
// 	      return false;
// 	    },
// 	    select: function (e, o) {
// 	      $("#searchItemCode").val(o.item.value);
// 	      $("#searchItemName").val(o.item.ITEMNAME);
// 	      $("#searchOrderName").val(o.item.ORDERNAME);
// 	      $("#searchModel").val(o.item.MODEL);
// 	      $("#searchModelName").val(o.item.MODELNAME);

// 	      return false;
// 	    }
// 	  });

// 	  // 품명 Lov
// 	  $("#searchItemName").bind("keydown", function (e) {
// 	    switch (e.keyCode) {
// 	    case $.ui.keyCode.TAB:
// 	      if ($(this).autocomplete("instance").menu.active) {
// 	        e.preventDefault();
// 	      }
// 	      break;
// 	    case $.ui.keyCode.BACKSPACE:
// 	    case $.ui.keyCode.DELETE:
// 	      //             $("#searchItemName").val("");
// 	      $("#searchItemCode").val("");
// 	      $("#searchOrderName").val("");
// 	      $("#searchModel").val("");
// 	      $("#searchModelName").val("");

// 	      break;
// 	    case $.ui.keyCode.ENTER:
// 	      $(this).autocomplete("search", "%");
// 	      break;

// 	    default:
// 	      break;
// 	    }
// 	  }).focus(
// 	    function (e) {
// 	    $(this).autocomplete("search",
// 	      (this.value === "") ? "%" : this.value);
// 	  }).autocomplete({
// 	    source: function (request, response) {
// 	      $.getJSON("<c:url value='/searchItemCodeOrderLov.do' />", {
// 	        keyword: extractLast(request.term),
// 	        ORGID: $('#searchOrgId option:selected').val(),
// 	        COMPANYID: $('#searchCompanyId option:selected').val(),
// 	        GROUPCODE: $('#searchGroupCode').val(),
// 	        GUBUN: 'ITEMNAME',
// 	      }, function (data) {
// 	        response($.map(data.data, function (m, i) {
// 	            return $.extend(m, {
// 	              label: m.ITEMNAME + ', ' + m.ORDERNAME + ', ' + m.MODELNAME,
// 	              value: m.ITEMCODE,
// 	              ITEMNAME: m.ITEMNAME,
// 	              ORDERNAME: m.ORDERNAME,
// 	              MODEL: m.MODEL,
// 	              MODELNAME: m.MODELNAME,
// 	            });
// 	          }));
// 	      });
// 	    },
// 	    search: function () {
// 	      if (this.value === "")
// 	        return;
// 	      var term = extractLast(this.value);
// 	      if (term.length < 1) {
// 	        return false;
// 	      }
// 	    },
// 	    focus: function () {
// 	      return false;
// 	    },
// 	    select: function (e, o) {
// 	      $("#searchItemCode").val(o.item.value);
// 	      $("#searchItemName").val(o.item.ITEMNAME);
// 	      $("#searchOrderName").val(o.item.ORDERNAME);
// 	      $("#searchModel").val(o.item.MODEL);
// 	      $("#searchModelName").val(o.item.MODELNAME);

// 	      return false;
// 	    }
// 	  });
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
                                <li>공정관리</li>
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
                        <input type="hidden" id="searchGroupCode" name=searchGroupCode value="A" />
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
                        <input type="hidden" id="workorderid" />
                        <input type="hidden" id="itemcode" />
                        <input type="hidden" id="rowIndexVal" />
                        <input type="hidden" id="worktype" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
		                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
		                        <input type="hidden" id="searchModel" name="searchModel" />
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
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">기준일자(계획)</th>
                                        <td >
                                            <input type="text" id="searchPlanDate" name="searchPlanDate" class="input_center " style="width: 97%; " maxlength="10" />
                                        </td>
                                        <th class="required_text">기준일자(실적)</th>
                                        <td >
                                            <input type="text" id="searchDate" name="searchDate" class="input_center " style="width: 97%; " maxlength="10" />
                                        </td>
                                        <th class="required_text">상태</th>
                                        <td>
                                            <select id="searchStatus" name="searchStatus" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS1}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByStatus}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">생산구분</th>
                                        <td>
                                            <select id="searchWorkType" name="searchWorkType" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS1}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByWorkType}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">작업지시번호</th>
                                        <td>
                                            <input type="text" id="searchWorkNo" name="searchWorkNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
			                                  </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">작업지시 완료</div></td>
                        </tr>
                    </table>
                    <div id="gridViewArea" style="width: 100%; margin-bottom: 5px; float: left;"></div>
                </div>
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">공정 완료/취소</div></td>
                        </tr>
                    </table>
                    <div id="gridViewAreadetail" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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