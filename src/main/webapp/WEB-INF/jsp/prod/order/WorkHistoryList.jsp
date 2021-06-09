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

.ResultTable th {
  font-size: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid white;
}

.ResultTable td {
  font-size: 22px;
  color: black;
  text-align: center;
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

	  $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchTo").val(getToDay("${searchVO.dateTo}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	    //       fn_option_change('MFG', 'STATUS', 'searchStatus');
	  });

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["grid.1"] = "WorkHistoryList";

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
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'number',
	      name: 'FMLID',
	    }, {
	      type: 'number',
	      name: 'ORDERNO',
	    }, {
	      type: 'number',
	      name: 'CHECKLISTID',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'CHECKBIG',
	    }, {
	      type: 'string',
	      name: 'FMLTYPE',
	    }, {
	      type: 'number',
	      name: 'EMPLOYEESEQ',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO',
	    }, {
	      type: 'string',
	      name: 'FMLTYPENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKTYPENAME',
	    }, {
	      type: 'date',
	      name: 'CHECKDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'CHECKSTARTTIME',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME',
	    }, {
	      type: 'string',
	      name: 'STANDARDSTARTTIME',
	    }, {
	      type: 'string',
	      name: 'STANDARDENDTIME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTCODE',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTNAME',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEENAME',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEENUMBER',
	    }, {
	      type: 'string',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKBIGNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALLNAME',
	    }, {
	      type: 'string',
	      name: 'SPECIALCHECKNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE',
	    }, {
	      type: 'string',
	      name: 'CHECKCYCLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKCYCLE',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE',
	    }, {
	      type: 'number',
	      name: 'MINVALUE',
	    }, {
	      type: 'number',
	      name: 'CHECKQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT1',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT2',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT3',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT4',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT5',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT6',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT7',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT8',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT9',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT10',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT11',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT12',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT13',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT14',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT15',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT16',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT17',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT18',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT19',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT20',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT21',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT22',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT23',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT24',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT25',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT26',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT27',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT28',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT29',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT30',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT31',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT32',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT33',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT34',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT35',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT36',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT37',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT38',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT39',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT40',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT41',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT42',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT43',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT44',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT45',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT46',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT47',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT48',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT49',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT50',
	    }, {
	      type: 'string',
	      name: 'CHECK1',
	    }, {
	      type: 'string',
	      name: 'CHECK2',
	    }, {
	      type: 'string',
	      name: 'CHECK3',
	    }, {
	      type: 'string',
	      name: 'CHECK4',
	    }, {
	      type: 'string',
	      name: 'CHECK5',
	    }, {
	      type: 'string',
	      name: 'CHECK6',
	    }, {
	      type: 'string',
	      name: 'CHECK7',
	    }, {
	      type: 'string',
	      name: 'CHECK8',
	    }, {
	      type: 'string',
	      name: 'CHECK9',
	    }, {
	      type: 'string',
	      name: 'CHECK10',
	    }, {
	      type: 'string',
	      name: 'CHECK11',
	    }, {
	      type: 'string',
	      name: 'CHECK12',
	    }, {
	      type: 'string',
	      name: 'CHECK13',
	    }, {
	      type: 'string',
	      name: 'CHECK14',
	    }, {
	      type: 'string',
	      name: 'CHECK15',
	    }, {
	      type: 'string',
	      name: 'CHECK16',
	    }, {
	      type: 'string',
	      name: 'CHECK17',
	    }, {
	      type: 'string',
	      name: 'CHECK18',
	    }, {
	      type: 'string',
	      name: 'CHECK19',
	    }, {
	      type: 'string',
	      name: 'CHECK20',
	    }, {
	      type: 'string',
	      name: 'CHECK21',
	    }, {
	      type: 'string',
	      name: 'CHECK22',
	    }, {
	      type: 'string',
	      name: 'CHECK23',
	    }, {
	      type: 'string',
	      name: 'CHECK24',
	    }, {
	      type: 'string',
	      name: 'CHECK25',
	    }, {
	      type: 'string',
	      name: 'CHECK26',
	    }, {
	      type: 'string',
	      name: 'CHECK27',
	    }, {
	      type: 'string',
	      name: 'CHECK28',
	    }, {
	      type: 'string',
	      name: 'CHECK29',
	    }, {
	      type: 'string',
	      name: 'CHECK30',
	    }, {
	      type: 'string',
	      name: 'CHECK31',
	    }, {
	      type: 'string',
	      name: 'CHECK32',
	    }, {
	      type: 'string',
	      name: 'CHECK33',
	    }, {
	      type: 'string',
	      name: 'CHECK34',
	    }, {
	      type: 'string',
	      name: 'CHECK35',
	    }, {
	      type: 'string',
	      name: 'CHECK36',
	    }, {
	      type: 'string',
	      name: 'CHECK37',
	    }, {
	      type: 'string',
	      name: 'CHECK38',
	    }, {
	      type: 'string',
	      name: 'CHECK39',
	    }, {
	      type: 'string',
	      name: 'CHECK40',
	    }, {
	      type: 'string',
	      name: 'CHECK41',
	    }, {
	      type: 'string',
	      name: 'CHECK42',
	    }, {
	      type: 'string',
	      name: 'CHECK43',
	    }, {
	      type: 'string',
	      name: 'CHECK44',
	    }, {
	      type: 'string',
	      name: 'CHECK45',
	    }, {
	      type: 'string',
	      name: 'CHECK46',
	    }, {
	      type: 'string',
	      name: 'CHECK47',
	    }, {
	      type: 'string',
	      name: 'CHECK48',
	    }, {
	      type: 'string',
	      name: 'CHECK49',
	    }, {
	      type: 'string',
	      name: 'CHECK50',
	    }, {
	      type: 'number',
	      name: 'TOTALQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME1',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME2',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME3',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME4',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME5',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME6',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME7',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME8',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME9',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME10',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME11',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME12',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME13',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME14',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME15',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME16',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME17',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME18',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME19',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME20',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME21',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME22',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME23',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME24',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME25',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME26',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME27',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME28',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME29',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME30',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME31',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME32',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME33',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME34',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME35',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME36',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME37',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME38',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME39',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME40',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME41',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME42',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME43',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME44',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME45',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME46',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME47',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME48',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME49',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME50',
	    }, {
	      type: 'string',
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'INSPECTIONYN',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT',
	    }, {
	      type: 'string',
	      name: 'TOTALRESULT',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULTM',
	    }, {
	      type: 'string',
	      name: 'MANAGEEMPLOYEENAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'CHK1',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      listeners: {
	        checkchange: function (column, recordIndex, checked) {
	          var count = Ext.getStore(gridnms["store.1"]).count();
	          Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(recordIndex));
	          var model = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];
	          var chk = model.data.CHK1;
	          var workorderid = model.data.WORKORDERID;
	          var workorderseq = model.data.WORKORDERSEQ;
	          var employeenumber = model.data.EMPLOYEENUMBER;
	          var employeeseq = model.data.EMPLOYEESEQ;

	          if (chk == true) {
	            for (var j = 0; j < count; j++) {
	              Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(j));
	              var model1 = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];
	              var workorderid1 = model1.data.WORKORDERID;
	              var workorderseq1 = model1.data.WORKORDERSEQ;
	              var employeenumber1 = model1.data.EMPLOYEENUMBER;
	              var employeeseq1 = model1.data.EMPLOYEESEQ;
	              var checkbig1 = model1.data.CHECKBIG;

	              if (workorderid == workorderid1) {
	                if (workorderseq == workorderseq1) {
	                  if (employeenumber == employeenumber1) {
	                    if (employeeseq == employeeseq1) {
	                      model1.set("CHK1", true);
	                    }
	                  }
	                }
	              }

	              if (workorderid == workorderid1) {
	                if (workorderseq == workorderseq1) {
	                  if (employeenumber == employeenumber1) {
	                    if (employeeseq == employeeseq1) {
	                      if (checkbig1 == "F") {
	                        model1.set("CHK", true);
	                      }
	                    }
	                  }
	                }
	              }

	            }
	          } else {
	            for (var l = 0; l < count; l++) {
	              Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(l));
	              var model1 = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];
	              var workorderid1 = model1.data.WORKORDERID;
	              var workorderseq1 = model1.data.WORKORDERSEQ;
	              var employeenumber1 = model1.data.EMPLOYEENUMBER;
	              var employeeseq1 = model1.data.EMPLOYEESEQ;
	              var checkbig1 = model1.data.CHECKBIG;

	              if (workorderid == workorderid1) {
	                if (workorderseq == workorderseq1) {
	                  if (employeenumber == employeenumber1) {
	                    if (employeeseq == employeeseq1) {
	                      model1.set("CHK1", false);
	                    }
	                  }
	                }
	              }

	              if (workorderid == workorderid1) {
	                if (workorderseq == workorderseq1) {
	                  if (employeenumber == employeenumber1) {
	                    if (employeeseq == employeeseq1) {
	                      if (checkbig1 == "F") {
	                        model1.set("CHK", false);
	                      }
	                    }
	                  }
	                }
	              }
	            }

	          }
	        }
	      }
	    }, {
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 50,
	      hidden: true,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: "0,000",
	    }, {
	      dataIndex: 'XXXXXXXXXX',
	      menuDisabled: true,
	      sortable: false,
	      resizable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      text: '',
	      width: 65,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "상세",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          fn_detail_popup(record.data);
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
	        }
	      }
	    }, {
	      dataIndex: 'CHECKBIGNAME',
	      text: '검사구분',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKDATE',
	      text: '검사일자',
	      xtype: 'datecolumn',
	      width: 85,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'CHECKSTARTTIME',
	      text: '작업시작<br/>시간',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKTIME',
	      text: '작업종료<br/>시간',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 130,
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
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'EQUIPMENTNAME',
	      text: '설비',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	      //      }, {
	      //        dataIndex: 'EMPLOYEENAME',
	      //        text: '작업자',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        align: "center",
	    }, {
	      dataIndex: 'TOTALRESULT',
	      text: '판정',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        switch (value) {
	        case "미입력":
	        case "미검사":
	        case "불합격":
	          meta.style = "color:rgb(255, 0, 0);";
	          return value;
	          break;
	        case "합격":
	          meta.style = "color:rgb(0, 0, 255);";
	          return value;
	          break;
	        default:
	          meta.style = "color:rgb(255, 0, 0);";
	          return value;
	          break;
	        }
	      },
	    }, {
	      dataIndex: 'KRNAME',
	      text: '검사자',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSMALLNAME',
	      text: '검사항목',
	      xtype: 'gridcolumn',
	      width: 145,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSTANDARD',
	      text: '검사내용',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'CHECKCYCLENAME',
	      text: '검사주기',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'STANDARDVALUE',
	      text: '기준',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MINVALUE',
	      text: '하한',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.000",
	      renderer: Ext.util.Format.numberRenderer('0,000.000'),
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '상한',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.000",
	      renderer: Ext.util.Format.numberRenderer('0,000.000'),
	    }, {
	      dataIndex: 'CHECK1',
	      text: 'X1',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 0 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK2',
	      text: 'X2',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 1 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK3',
	      text: 'X3',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 2 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK4',
	      text: 'X4',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 3 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK5',
	      text: 'X5',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 4 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK6',
	      text: 'X6',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 5 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK7',
	      text: 'X7',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 6 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK8',
	      text: 'X8',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 7 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK9',
	      text: 'X9',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 8 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK10',
	      text: 'X10',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 9 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK11',
	      text: 'X11',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 10 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK12',
	      text: 'X12',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 11 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK13',
	      text: 'X13',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 12 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK14',
	      text: 'X14',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 13 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK15',
	      text: 'X15',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 14 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK16',
	      text: 'X16',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 15 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK17',
	      text: 'X17',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 16 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK18',
	      text: 'X18',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 17 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK19',
	      text: 'X19',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 18 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK20',
	      text: 'X20',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 19 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK21',
	      text: 'X21',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 20 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK22',
	      text: 'X22',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 21 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK23',
	      text: 'X23',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 22 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK24',
	      text: 'X24',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 23 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK25',
	      text: 'X25',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 24 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK26',
	      text: 'X26',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 25 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK27',
	      text: 'X27',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 26 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK28',
	      text: 'X28',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 27 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK29',
	      text: 'X29',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 28 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK30',
	      text: 'X30',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 29 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK31',
	      text: 'X31',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 30 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK32',
	      text: 'X32',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 31 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK33',
	      text: 'X33',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 32 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK34',
	      text: 'X34',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 33 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK35',
	      text: 'X35',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 34 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK36',
	      text: 'X36',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 35 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK37',
	      text: 'X37',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 36 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK38',
	      text: 'X38',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 37 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK39',
	      text: 'X39',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 38 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK40',
	      text: 'X40',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 39 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK41',
	      text: 'X41',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 40 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK42',
	      text: 'X42',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 41 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK43',
	      text: 'X43',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 42 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK44',
	      text: 'X44',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 43 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK45',
	      text: 'X45',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 44 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK46',
	      text: 'X46',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 45 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK47',
	      text: 'X47',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 46 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK48',
	      text: 'X48',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 47 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK49',
	      text: 'X49',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 48 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK50',
	      text: 'X50',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 49 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234, 234, 234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT',
	      text: '결과',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        if (value == "NG" || value == "OK") {
	          if (value == "NG") {
	            meta.style += " color:rgb(255, 0, 0);";
	            return value;
	          } else {
	            meta.style += "color:rgb(0, 0, 255);";
	            return value;
	          }
	        } else {
	          var num = value * 1;

	          if (min > num) {
	            meta.style += " color:rgb(255, 0, 0);";
	            return value;
	          } else {
	            if (num > max) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          }
	        }
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
	      dataIndex: 'FMLID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FMLTYPENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKLISTID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTYPENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SPECIALCHECKNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'INSPECTIONYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKRESULTM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EMPLOYEENUMBER',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MANAGEEMPLOYEENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'STANDARDSTARTTIME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'STANDARDENDTIME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCYCLE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EQUIPMENTCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKBIG',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FMLTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EMPLOYEESEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'REMARKS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME1',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME2',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME3',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME4',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME5',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME6',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME7',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME8',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME9',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME10',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME11',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME12',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME13',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME14',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME15',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME16',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME17',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME18',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME19',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME20',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME21',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME22',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME23',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME24',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME25',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME26',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME27',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME28',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME29',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME30',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME31',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME32',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME33',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME34',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME35',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME36',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME37',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME38',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME39',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME40',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME41',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME42',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME43',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME44',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME45',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME46',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME47',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME48',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME49',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME50',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TOTALQTY',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/order/WorkHistoryList.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "전체선택/해제",
	    itemId: "btnChkd1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnChkd1": {
	      click: 'btnChk1Click'
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

	var popupclick = 0;
	function btnChk1Click() {
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var checkTrue = 0,
	  checkFalse = 0;

	  if (popupclick == 0) {
	    popupclick = 1;
	  } else {
	    popupclick = 0;
	  }

	  for (i = 0; i < count1; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(i));
	    var model1 = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];

	    var checkbig1 = model1.data.CHECKBIG;

	    if (popupclick == 1) {
	      model1.set("CHK1", true);
	      if (checkbig1 == "F") {
	        model1.set("CHK", true);
	      }
	      checkFalse++;
	    } else {
	      model1.set("CHK1", false);
	      if (checkbig1 == "F") {
	        model1.set("CHK", false);
	      }
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

	function fn_detail_popup(data) {

	  var width = 1376;
	  var height = 520;
	  var title_name = $('#title').val();
	  var title = title_name + " 상세";

	  Ext.create('Ext.window.Window', {
	    autoShow: true,
	    width: width,
	    height: height,
	    title: title,
	    html: '<table class="ResultTable" cellpadding="0" cellspacing="0" border="1" width="100%" style="padding-top:0px;  float: left; ">' +
	    '<colgroup>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '<col>' +
	    '</colgroup>' +
	    '<tbody>' +
	    '<tr style="height: 40px;">' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '품번' +
	    '</th>' +
	    '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="ordername" name="ordername" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.ORDERNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '품명' +
	    '</th>' +
	    '<td colspan="6" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="itemname" name="itemname" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.ITEMNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '검사구분' +
	    '</th>' +
	    '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="checkbigname" name="checkbigname" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.CHECKBIGNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '검사내용' +
	    '</th>' +
	    '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="checkstandard" name="checkstandard" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.CHECKSTANDARD + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '검사일자' +
	    '</th>' +
	    '<td class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="checkdate" name="checkdate" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + Ext.util.Format.date(data.CHECKDATE, 'Y-m-d') + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '검사수량' +
	    '</th>' +
	    '<td class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="totalqty" name="totalqty" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + Ext.util.Format.number(data.TOTALQTY, '0,000') + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X1' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X2' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X3' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X4' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X5' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X6' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X7' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X8' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X9' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X10' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME1 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME2 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME3 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME4 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME5 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME6 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME7 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME8 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME9 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME10 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X11' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X12' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X13' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X14' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X15' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X16' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X17' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X18' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X19' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X20' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME11 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME12 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME13 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME14 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME15 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME16 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME17 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME18 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME19 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME20 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X21' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X22' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X23' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X24' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X25' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X26' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X27' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X28' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X29' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X30' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME21 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME22 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME23 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME24 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME25 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME26 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME27 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME28 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME29 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME30 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X31' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X32' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X33' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X34' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X35' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X36' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X37' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X38' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X39' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X40' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME31 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME32 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME33 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME34 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME35 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME36 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME37 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME38 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME39 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME40 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X41' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X42' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X43' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X44' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X45' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X46' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X47' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X48' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X49' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    'X50' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME41 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME42 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME43 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME44 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME45 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME46 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME47 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME48 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME49 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
	    '<span>' + data.CHECKTIME50 + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '</tbody>' +
	    '</table>',
	    draggable: true,
	    resizable: false,
	    maximizable: false,
	    closeAction: 'destroy',
	    modal: true,
	  });
	}

	var gridarea;
	function setExtGrid() {
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
	                SEARCHFROM: $('#searchFrom').val(),
	                SEARCHTO: $('#searchTo').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      workHistoryList: '#workHistoryList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnChk1Click: btnChk1Click,
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
	        height: 619,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20,
	            leadingBufferZone: 20,
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'workHistoryList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('CHECKSMALLNAME') >= 0 || column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 110) {
	                    column.width = 110;
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
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchFrom = $('#searchFrom').val();
	  var searchTo = $('#searchTo').val();
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

	  if (searchFrom == "") {
	    header.push("일자From");
	    count++;
	  }

	  if (searchTo == "") {
	    header.push("일자To");
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

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchFrom = $('#searchFrom').val();
	  var searchTo = $('#searchTo').val();
	  var searchcheck = $('#searchCheck option:selected').val();
	  var searchcheckbig = $('#searchCheckBig option:selected').val();
	  var itemcode = $('#searchItemCode').val();
	  var routingid = $('#searchRoutingId').val();
	  var employeenumber = $('#searchEmployeeNumber').val();
	  var equipmentcode = $('#searchEquipmentCode').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHFROM: searchFrom,
	    SEARCHTO: searchTo,
	    CHECKBIG: searchcheckbig,
	    TOTALRESULT: searchcheck,
	    ITEMCODE: itemcode,
	    ROUTINGID: routingid,
	    EMPLOYEENUMBER: employeenumber,
	    EQUIPMENTCODE: equipmentcode,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  popupclick = 0;
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchFrom = $('#searchFrom').val();
	  var searchTo = $('#searchTo').val();
	  var searchcheckbig = $('#searchCheckBig option:selected').val();
	  var searchcheck = $('#searchCheck option:selected').val();
	  var itemcode = $('#searchItemCode').val();
	  var routingid = $('#searchRoutingId').val();
	  var employeenumber = $('#searchEmployeeNumber').val();
	  var equipmentcode = $('#searchEquipmentCode').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/prod/order/ExcelDownload.do?GUBUN='/>" + "WORKHISTORY"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&SEARCHFROM=" + searchFrom + ""
	     + "&SEARCHTO=" + searchTo + ""
	     + "&CHECKBIG=" + searchcheckbig + ""
	     + "&TOTALRESULT=" + searchcheck + ""
	     + "&ITEMCODE=" + itemcode + ""
	     + "&ROUTINGID=" + routingid + ""
	     + "&EMPLOYEENUMBER=" + employeenumber + ""
	     + "&EQUIPMENTCODE=" + equipmentcode + ""
	     + "&TITLE=" + title + "");
	}

	function fn_print() {
	  // 전체등록 Pop up 적용 버튼 핸들러
	    var count = Ext.getStore(gridnms["store.1"]).count();
	    var checknum = 0;
	    var CheckCnt = 0;
	    var workorderid = [];
	    var workorderseq = [];
	    var checkbig = [];
	    var employeeseq = [];
	    var checkqty = [];

	    for (var i = 0; i < count; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];
	      var chk = model.data.CHK;

	      if (chk == true) {
	        checknum++;
	      }
	    }

	    if (checknum == 0) {
	      extAlert("출력할 데이터를 선택해 주십시오.");
	      return false;
	    }

	    if (count == 0) {
	      console.log("출력할 데이터가 없습니다.");
	    } else {
	      for (var j = 0; j < count; j++) {
	        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(j));
	        var model1 = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];
	        var chk1 = model1.data.CHK;
	        CheckCnt = 0;

	        var workorderid1 = model1.data.WORKORDERID;
	        var workorderseq1 = model1.data.WORKORDERSEQ;
	        var checkbig1 = model1.data.CHECKBIG;
	        var employeeseq1 = model1.data.EMPLOYEESEQ;
	        var checkqty1 = model1.data.CHECKQTY;

	        if (chk1 === true) {

	          // 자주검사 체크시트의 시료수 갯수에 따라 출력물 갯수 변경
	          var xcount1 = 0;
	          var xcount2 = 0;
	          var xcount3 = 0;
	          var Allcount = 1; //기본적으로 한페이지는 나와야 함

	          var ck1 = model1.data.CHECKRESULT1;
	          if (ck1 != "") {
	            xcount1++;
	          }
	          var ck2 = model1.data.CHECKRESULT2;
	          if (ck2 != "") {
	            xcount1++;
	          }
	          var ck3 = model1.data.CHECKRESULT3;
	          if (ck3 != "") {
	            xcount1++;
	          }
	          var ck4 = model1.data.CHECKRESULT4;
	          if (ck4 != "") {
	            xcount1++;
	          }
	          var ck5 = model1.data.CHECKRESULT5;
	          if (ck5 != "") {
	            xcount1++;
	          }
	          var ck6 = model1.data.CHECKRESULT6;
	          if (ck6 != "") {
	            xcount1++;
	          }
	          var ck7 = model1.data.CHECKRESULT7;
	          if (ck7 != "") {
	            xcount1++;
	          }
	          var ck8 = model1.data.CHECKRESULT8;
	          if (ck8 != "") {
	            xcount1++;
	          }
	          var ck9 = model1.data.CHECKRESULT9;
	          if (ck9 != "") {
	            xcount1++;
	          }
	          var ck10 = model1.data.CHECKRESULT10;
	          if (ck10 != "") {
	            xcount1++;
	          }
	          var ck11 = model1.data.CHECKRESULT11;
	          if (ck11 != "") {
	            xcount1++;
	          }
	          var ck12 = model1.data.CHECKRESULT12;
	          if (ck12 != "") {
	            xcount1++;
	          }
	          var ck13 = model1.data.CHECKRESULT13;
	          if (ck13 != "") {
	            xcount1++;
	          }
	          var ck14 = model1.data.CHECKRESULT14;
	          if (ck14 != "") {
	            xcount1++;
	          }
	          var ck15 = model1.data.CHECKRESULT15;
	          if (ck15 != "") {
	            xcount1++;
	          }
	          var ck16 = model1.data.CHECKRESULT16;
	          if (ck16 != "") {
	            xcount1++;
	          }
	          var ck17 = model1.data.CHECKRESULT17;
	          if (ck17 != "") {
	            xcount1++;
	          }
	          var ck18 = model1.data.CHECKRESULT18;
	          if (ck18 != "") {
	            xcount1++;
	          }
	          var ck19 = model1.data.CHECKRESULT19;
	          if (ck19 != "") {
	            xcount1++;
	          }
	          var ck20 = model1.data.CHECKRESULT20;
	          if (ck20 != "") {
	            xcount1++;
	          }
	          var ck21 = model1.data.CHECKRESULT21;
	          if (ck21 != "") {
	            xcount2++;
	          }
	          var ck22 = model1.data.CHECKRESULT22;
	          if (ck22 != "") {
	            xcount2++;
	          }
	          var ck23 = model1.data.CHECKRESULT23;
	          if (ck23 != "") {
	            xcount2++;
	          }
	          var ck24 = model1.data.CHECKRESULT24;
	          if (ck24 != "") {
	            xcount2++;
	          }
	          var ck25 = model1.data.CHECKRESULT25;
	          if (ck25 != "") {
	            xcount2++;
	          }
	          var ck26 = model1.data.CHECKRESULT26;
	          if (ck26 != "") {
	            xcount2++;
	          }
	          var ck27 = model1.data.CHECKRESULT27;
	          if (ck27 != "") {
	            xcount2++;
	          }
	          var ck28 = model1.data.CHECKRESULT28;
	          if (ck28 != "") {
	            xcount2++;
	          }
	          var ck29 = model1.data.CHECKRESULT29;
	          if (ck29 != "") {
	            xcount2++;
	          }
	          var ck30 = model1.data.CHECKRESULT30;
	          if (ck30 != "") {
	            xcount2++;
	          }
	          var ck31 = model1.data.CHECKRESULT31;
	          if (ck31 != "") {
	            xcount2++;
	          }
	          var ck32 = model1.data.CHECKRESULT32;
	          if (ck32 != "") {
	            xcount2++;
	          }
	          var ck33 = model1.data.CHECKRESULT33;
	          if (ck33 != "") {
	            xcount2++;
	          }
	          var ck34 = model1.data.CHECKRESULT34;
	          if (ck34 != "") {
	            xcount2++;
	          }
	          var ck35 = model1.data.CHECKRESULT35;
	          if (ck35 != "") {
	            xcount2++;
	          }
	          var ck36 = model1.data.CHECKRESULT36;
	          if (ck36 != "") {
	            xcount2++;
	          }
	          var ck37 = model1.data.CHECKRESULT37;
	          if (ck37 != "") {
	            xcount2++;
	          }
	          var ck38 = model1.data.CHECKRESULT38;
	          if (ck38 != "") {
	            xcount2++;
	          }
	          var ck39 = model1.data.CHECKRESULT39;
	          if (ck39 != "") {
	            xcount2++;
	          }
	          var ck40 = model1.data.CHECKRESULT40;
	          if (ck40 != "") {
	            xcount2++;
	          }
	          var ck41 = model1.data.CHECKRESULT41;
	          if (ck41 != "") {
	            xcount3++;
	          }
	          var ck42 = model1.data.CHECKRESULT42;
	          if (ck42 != "") {
	            xcount3++;
	          }
	          var ck43 = model1.data.CHECKRESULT43;
	          if (ck43 != "") {
	            xcount3++;
	          }
	          var ck44 = model1.data.CHECKRESULT44;
	          if (ck44 != "") {
	            xcount3++;
	          }
	          var ck45 = model1.data.CHECKRESULT45;
	          if (ck45 != "") {
	            xcount3++;
	          }
	          var ck46 = model1.data.CHECKRESULT46;
	          if (ck46 != "") {
	            xcount3++;
	          }
	          var ck47 = model1.data.CHECKRESULT47;
	          if (ck47 != "") {
	            xcount3++;
	          }
	          var ck48 = model1.data.CHECKRESULT48;
	          if (ck48 != "") {
	            xcount3++;
	          }
	          var ck49 = model1.data.CHECKRESULT49;
	          if (ck49 != "") {
	            xcount3++;
	          }
	          var ck50 = model1.data.CHECKRESULT50;
	          if (ck50 != "") {
	            xcount3++;
	          }

	          if (xcount1 > 0 && xcount2 == 0 && xcount3 == 0) {
	            Allcount = 1;
	          } else if (xcount1 >= 0 && xcount2 > 0 && xcount3 == 0) {
	            Allcount = 2;
	          } else if (xcount1 >= 0 && xcount2 >= 0 && xcount3 > 0) {
	            Allcount = 3;
	          }

	          var forcount = workorderid.length;

	          if (forcount == 0) {
	            workorderid.push(workorderid1);
	            workorderseq.push(workorderseq1);
	            checkbig.push(checkbig1);
	            employeeseq.push(employeeseq1);
	            checkqty.push(Allcount);
	          } else {
	            for (var k = 0; k < forcount; k++) {
	              if (workorderid[k] == workorderid1) {
	                if (workorderseq[k] == workorderseq1) {
	                  if (checkbig[k] == checkbig1) {
	                    if (employeeseq[k] == employeeseq1) {
	                      CheckCnt++;
	                    }
	                  }
	                }
	              }
	            }
	            if (CheckCnt == 0) {
	              workorderid.push(workorderid1);
	              workorderseq.push(workorderseq1);
	              checkbig.push(checkbig1);
	              employeeseq.push(employeeseq1);
	              checkqty.push(Allcount);
	            }
	          }
	        }
	      }
	    }

	    $("#workorderid").val(workorderid);
	    $("#workorderseq").val(workorderseq);
	    $("#checkbig").val(checkbig);
	    $("#employeeseq").val(employeeseq);
	    $("#checkqty").val(checkqty);

	    var column = 'master';
	    var url = "<c:url value='/report/workHistoryChecksheetReport.pdf'/>";
	    var target = '_blank';

	    fn_popup_url(column, url, target);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 품번 Lov
	  $("#searchOrderName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchItemName").val("");
	      $("#searchItemCode").val("");

	      var routingid = $("#searchRoutingId").val();
	      if (routingid != "") {
	        $("#searchRoutingName").val("");
	        $("#searchRoutingId").val("");
	        $("#searchRoutingOp").val("");
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
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ORDERNAME', // 제품, 반제품 조회
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
	      $("#searchItemCode").val(o.item.value);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);

	      var routingid = $("#searchRoutingId").val();
	      if (routingid != "") {
	        $("#searchRoutingName").val("");
	        $("#searchRoutingId").val("");
	        $("#searchRoutingOp").val("");
	      }
	      return false;
	    }
	  });

	  // 품번 Lov
	  $("#searchItemName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchItemCode").val("");
	      $("#searchOrderName").val("");
	      //        $("#searchItemName").val("");

	      var routingid = $("#searchRoutingId").val();
	      if (routingid != "") {
	        $("#searchRoutingName").val("");
	        $("#searchRoutingId").val("");
	        $("#searchRoutingOp").val("");
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
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ITEMNAME', // 제품, 반제품 조회
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
	      $("#searchItemCode").val(o.item.value);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);

	      var routingid = $("#searchRoutingId").val();
	      if (routingid != "") {
	        $("#searchRoutingName").val("");
	        $("#searchRoutingId").val("");
	        $("#searchRoutingOp").val("");
	      }
	      return false;
	    }
	  });

	  // 공정 lov
	  $("#searchRoutingName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //               $("#searchRoutingName").val("");
	      $("#searchRoutingId").val("");
	      $("#searchRoutingOp").val("");
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
	        ITEMCODE: $('#searchItemCode').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ROUTINGOP + ", " + m.ROUTINGNAME,
	              value: m.ROUTINGCODE,
	              ROUTINGNO: m.ROUTINGNO,
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
	      $("#searchRoutingOp").val(o.item.ROUTINGOP);

	      return false;
	    }
	  });

	  // 검사자 lov
	  $("#searchKrName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchEmployeeNumber").val("");
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
	      $.getJSON("<c:url value='/searchWorkerLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        INSPECTORTYPE: '10',
	        INSPECTORTYPE2: '20',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchEmployeeNumber").val(o.item.value);
	      $("#searchKrName").val(o.item.label);

	      return false;
	    }
	  });

	  // 설비 lov
	  $("#searchEquipmentName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchEquipmentCode").val("");
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
	      $.getJSON("<c:url value='/searchWorkCenterLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHGUBUN: 'OUT',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchEquipmentCode").val(o.item.value);
	      $("#searchEquipmentName").val(o.item.label);

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
                                <li>품질관리</li>
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
                        <input type="hidden" id="orgid" value="<c:out value='${searchVO.ORGID}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${searchVO.COMPANYID}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
	                      <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <input type="hidden" id="equipmentcode" name="equipmentcode"/>
                            <input type="hidden" id="itemcode" name="itemcode"/>
                            <input type="hidden" id="routingid" name="routingid" />
		                        <input type="hidden" id="workorderid" name="workorderid"/>
		                        <input type="hidden" id="workorderseq" name="workorderseq"/>
		                        <input type="hidden" id="checkbig" name="checkbig"/>
		                        <input type="hidden" id="fmltype" name="fmltype"/>
		                        <input type="hidden" id="fmlid" name="fmlid"/>
                            <input type="hidden" id="checkqty" name="checkqty"/>
		                        <input type="hidden" id="employeeseq" name="employeeseq"/>
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
                            <input type="hidden" id="searchRoutingOp" name="searchRoutingOp" />
                            <input type="hidden" id="searchEmployeeNumber" name="searchEmployeeNumber" />
                            <input type="hidden" id="searchEquipmentCode" name="searchEquipmentCode" />
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
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                   엑셀
                                                </a>
                                                <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print();">
                                                   자주검사 Check Sheet
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="90px">
                                        <col width="207px">
                                        <col width="90px">
                                        <col width="23%">
                                        <col width="90px">
                                        <col width="15%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td>
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 100px;" maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 100px;" maxlength="10" />
                                        </td>
                                        <th class="required_text">검사구분</th>
                                        <td>
                                            <select id="searchCheckBig" name="searchCheckBig" class="input_left " style="width: 50%;">
                                                <c:if test="${empty searchVO.CHECKBIG}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByCheckBig}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.CHECKBIG}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">판정</th>
                                        <td>
                                            <select id="searchCheck" name="searchCheck" class="input_left " style="width: 50%;">
                                                <c:if test="${empty searchVO.CHECKYN}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByCheckyn}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.CHECKYN}">
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
                                        <th class="required_text">품번</th>
                                        <td>
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="searchItemName" name="searchItemName" class="input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                        <th class="required_text">공정명</th>
                                        <td>
                                            <input type="text" id="searchRoutingName" name="searchRoutingName" class="input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">검사자</th>
                                        <td>
                                            <input type="text" id="searchKrName" name="searchKrName" class="input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                        <th class="required_text">설비</th>
                                        <td>
                                            <input type="text" id="searchEquipmentName" name="searchEquipmentName" class="input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
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