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


    $('#searchOrgId, #searchCompanyId').change(function (event) {});

    gridnms["app"] = "prod";
  }

  var gridnms = {};
  var fields = {};
  var items = {};
  function setValues() {
	  //기본정보
	  setValues_List();
	  //제품별 집계
	  setValues_Count();
	  //세부정보
	  setValues_Detail();
	  
  }
  
  function setValues_List() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WrappingIFPerform";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.list"].push(gridnms["model.1"]);

    gridnms["stores.list"].push(gridnms["store.1"]);

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
	      type: 'string',
	      name: 'WORKDATE',
	    }, {
        type: 'string',
        name: 'EQUIPMENTNAME',
      }, {
        type: 'number',
        name: 'IFQTY',
      }, {
        type: 'number',
        name: 'PERSONQTY',
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
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, record) {
          
          return Ext.util.Format.number(value, '0,000');
        },
      }, {
        dataIndex: 'WORKDATE',
        text: '작업일자',
        xtype: 'gridcolumn',
        width: 160,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        summaryRenderer: function (value, meta, record) {
          value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>합계</div>";
          return value;
        },
        renderer: function (value, meta, record) {
        	return value;
        },
      }, {
        dataIndex: 'EQUIPMENTNAME',
        text: '설비명',
        xtype: 'gridcolumn',
        width: 180,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        renderer: function (value, meta, record) {
          
          return value;
        },
      }, {
        text: '생산현황',
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        columns: [{
            dataIndex: 'IFQTY',
            text: 'I/F',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
              summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
              },
            renderer: function (value, meta, record) {
              
              return Ext.util.Format.number(value, '0,000');
            },
          }, {
            dataIndex: 'PERSONQTY',
            text: '작업자',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
              var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
              return result;
            },
            renderer: function (value, meta, record) {
              
              return Ext.util.Format.number(value, '0,000');
            },
          }, {
              dataIndex: 'QTY',
              text: '차이수량',
              xtype: 'gridcolumn',
              width: 90,
              hidden: false,
              sortable: false,
              resizable: true,
              menuDisabled: true,
              style: 'text-align:center;',
              align: "right",
              cls: 'ERPQTY',
              format: "0,000.00",
              summaryType: 'sum',
              summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
              },
              renderer: function (value, meta, record) {
                
                return Ext.util.Format.number(value, '0,000');
              },
            },],
      },
      // Hidden Columns
      {
        dataIndex: 'ORGID',
        xtype: 'hidden',
      }, {
        dataIndex: 'COMPANYID',
        xtype: 'hidden',
      }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
      read: "<c:url value='/select/prod/manage/WrappingIFPerformList.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
      "#WrappingIFPerform": {
        itemclick: 'ListClick'
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
//     items["docked.1"].push(items["dock.btn.1"]);
  }
  

  function ListClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var workcentercode = record.data.WORKCENTERCODE;
    var workdate = record.data.WORKDATE;
    
    if (workdate === "") {
      Ext.getStore(gridnms["store.2"]).removeAll();

    } else {
      var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHDATE: workdate,
        WORKCENTERCODE: workcentercode,
      };

      extGridSearch(sparams, gridnms["store.2"]);
    }
  }


  function setValues_Count() {
	    gridnms["models.count"] = [];
	    gridnms["stores.count"] = [];
	    gridnms["views.count"] = [];
	    gridnms["controllers.count"] = [];

	    gridnms["grid.2"] = "WrappingIFPerformCount";

	    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	    gridnms["views.count"].push(gridnms["panel.2"]);

	    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	    gridnms["controllers.count"].push(gridnms["controller.2"]);

	    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	    gridnms["models.count"].push(gridnms["model.2"]);

	    gridnms["stores.count"].push(gridnms["store.2"]);

	    fields["model.2"] = [{
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
	        name: 'PRODDATE',
	      }, {
	        type: 'string',
	        name: 'EQUIPMENTNAME',
	      }, {
          type: 'string',
          name: 'ORDERNAME',
        }, {
	        type: 'string',
	        name: 'ITEMCODE',
	      }, {
	        type: 'string',
	        name: 'ITEMNAME',
	      }, {
		      type: 'string',
		      name: 'MODEL',
		    }, {
		      type: 'string',
		      name: 'MODELNAME',
		    }, {
          type: 'string',
          name: 'ITEMSTANDARDDETAIL',
        }, {
	        type: 'number',
	        name: 'PRODQTY',
	      }, {
	        type: 'number',
	        name: 'IMPORTQTY',
	      }, {
	        type: 'number',
	        name: 'FAULTQTY',
	      }, ];

	    fields["columns.2"] = [
	      // Display Columns
	      {
	        dataIndex: 'RN',
	        text: '순번',
	        xtype: 'gridcolumn',
	        width: 55,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        cls: 'ERPQTY',
	        format: "0,000",
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.number(value, '0,000');
	        },
	      }, {
	        dataIndex: 'PRODDATE',
	        text: '작업일자',
	        xtype: 'gridcolumn',
	        width: 160,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.date(value, 'Y-m-d');
	        },
	      }, {
	        dataIndex: 'EQUIPMENTNAME',
	        text: '설비명',
	        xtype: 'gridcolumn',
	        width: 180,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
      }, {
          dataIndex: 'ORDERNAME',
          text: '품번',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
          dataIndex: 'ITEMNAME',
          text: '품명',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
	        dataIndex: 'MODELNAME',
	        text: '기종',
	        xtype: 'gridcolumn',
	        width: 110,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
	      }, {
          dataIndex: 'ITEMSTANDARDDETAIL',
          text: '타입',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          summaryRenderer: function (value, meta, record) {
              value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>합계</div>";
              return value;
            },
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
	    	  dataIndex: 'DEFECTEDQTY',
	        text: '생산수량',
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
	        summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
              var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
              return result;
            },
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.number(value, '0,000');
	        },
	      }, {
          dataIndex: 'PRODQTY',
          text: '양품수량',
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
          summaryType: 'sum',
          summaryRenderer: function (value, meta, record) {
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            return result;
          },
          renderer: function (value, meta, record) {
            
            return Ext.util.Format.number(value, '0,000');
          },
        }, {
	        dataIndex: 'FAULTQTY',
	        text: '불량수량',
	        xtype: 'gridcolumn',
	        width: 90,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "right",
	        cls: 'ERPQTY',
	        format: "0,000.00",
	          summaryType: 'sum',
	          summaryRenderer: function (value, meta, record) {
	            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	            return result;
	          },
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.number(value, '0,000');
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
	        dataIndex: 'MODEL',
	        xtype: 'hidden',
	      },];

	    items["api.2"] = {};
	    $.extend(items["api.2"], {
	      read: "<c:url value='/select/prod/manage/WrappingIFPerformCount.do' />"
	    });

	    items["btns.2"] = [];

	    items["btns.ctr.2"] = {};
	    $.extend(items["btns.ctr.2"], {
	      "#WrappingIFPerformCount": {
	        itemclick: 'CountClick'
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
// 	    items["docked.2"].push(items["dock.btn.2"]);
	  }
  
  function CountClick(dataview, record, item, index, e, eOpts) {
	    var orgid = record.data.ORGID;
	    var companyid = record.data.COMPANYID;
	    var workcentercode = record.data.WORKCENTERCODE;
	    var workdate = record.data.PRODDATE;
	    var itemcode = record.data.ITEMCODE;
	    
	    if (workdate === "") {
	      Ext.getStore(gridnms["store.3"]).removeAll();

	    } else {
	      var sparams = {
	        ORGID: orgid,
	        COMPANYID: companyid,
	        SEARCHDATE: workdate,
	        ITEMCODE: itemcode,
	        WORKCENTERCODE: workcentercode,
	      };

	      extGridSearch(sparams, gridnms["store.3"]);
	    }
	  }
  
  function setValues_Detail() {
	    gridnms["models.detail"] = [];
	    gridnms["stores.detail"] = [];
	    gridnms["views.detail"] = [];
	    gridnms["controllers.detail"] = [];

	    gridnms["grid.3"] = "WrappingIFPerformDetail";

	    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
	    gridnms["views.detail"].push(gridnms["panel.3"]);

	    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
	    gridnms["controllers.detail"].push(gridnms["controller.3"]);

	    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	    gridnms["models.detail"].push(gridnms["model.3"]);

	    gridnms["stores.detail"].push(gridnms["store.3"]);

	    fields["model.3"] = [{
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
	        name: 'EQUIPMENTNAME',
	      }, {
          type: 'string',
          name: 'ORDERNAME',
        }, {
          type: 'string',
          name: 'ITEMCODE',
        }, {
          type: 'string',
          name: 'ITEMNAME',
        }, {
          type: 'string',
          name: 'MODEL',
        }, {
          type: 'string',
          name: 'MODELNAME',
        }, {
          type: 'string',
          name: 'ITEMSTANDARDDETAIL',
        }, {
	        type: 'string',
	        name: 'KRNAME',
	      }, {
	        type: 'string',
	        name: 'WORKDIVNAME',
	      }, {
          type: 'number',
          name: 'PRODQTY',
        }, {
	        type: 'number',
	        name: 'IMPORTQTY',
	      }, {
          type: 'number',
          name: 'FAULTQTY',
        }, {
          type: 'string',
          name: 'STARTTIME',
        }, {
          type: 'string',
          name: 'ENDTIME',
        }, ];

	    fields["columns.3"] = [
	      // Display Columns
	      {
	        dataIndex: 'RN',
	        text: '순번',
	        xtype: 'gridcolumn',
	        width: 55,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        cls: 'ERPQTY',
	        format: "0,000",
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.number(value, '0,000');
	        },
	      }, {
	        dataIndex: 'WORKTIME',
	        text: '작업일자',
	        xtype: 'gridcolumn',
	        width: 160,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return Ext.util.Format.date(value, 'Y-m-d');
	        },
	      }, {
	        dataIndex: 'EQUIPMENTNAME',
	        text: '설비명',
	        xtype: 'gridcolumn',
	        width: 180,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
	      }, {
          dataIndex: 'ORDERNAME',
          text: '품번',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
          dataIndex: 'ITEMNAME',
          text: '품명',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
          dataIndex: 'MODELNAME',
          text: '기종',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
          dataIndex: 'ITEMSTANDARDDETAIL',
          text: '타입',
          xtype: 'gridcolumn',
          width: 110,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          renderer: function (value, meta, record) {
            
            return value;
          },
        }, {
	        dataIndex: 'KRNAME',
	        text: '작업자',
	        xtype: 'gridcolumn',
	        width: 80,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
	      }, {
	        dataIndex: 'WORKDIVNAME',
	        text: '주야구분',
	        xtype: 'gridcolumn',
	        width: 80,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        summaryRenderer: function (value, meta, record) {
	            value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>합계</div>";
	            return value;
	          },
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
	      }, {
          dataIndex: 'PRODQTY',
          text: '생산수량',
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
          summaryType: 'sum',
          summaryRenderer: function (value, meta, record) {
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            return result;
          },
          renderer: function (value, meta, record) {
            
            return Ext.util.Format.number(value, '0,000');
          },
        }, {
          dataIndex: 'IMPORTQTY',
          text: '양품수량',
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
          summaryType: 'sum',
          summaryRenderer: function (value, meta, record) {
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            return result;
          },
          renderer: function (value, meta, record) {
            
            return Ext.util.Format.number(value, '0,000');
          },
        }, {
          dataIndex: 'FAULTQTY',
          text: '불량수량',
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
          summaryType: 'sum',
          summaryRenderer: function (value, meta, record) {
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            return result;
          },
          renderer: function (value, meta, record) {
            
            return Ext.util.Format.number(value, '0,000');
          },
        }, {
	        dataIndex: 'STARTTIME',
	        text: '시작시간',
	        xtype: 'gridcolumn',
	        width: 140,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
	          return value;
	        },
	      }, {
	        dataIndex: 'ENDTIME',
	        text: '종료시간',
	        xtype: 'gridcolumn',
	        width: 140,
	        hidden: false,
	        sortable: false,
	        resizable: true,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        align: "center",
	        renderer: function (value, meta, record) {
	          
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
	      }, ];

	    items["api.3"] = {};
	    $.extend(items["api.3"], {
	      read: "<c:url value='/select/prod/manage/WrappingIFPerformDetail.do' />"
	    });

	    items["btns.3"] = [];

	    items["btns.ctr.3"] = {};

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
  
  
  var gridarea, gridarea1, gridarea2;
  function setExtGrid() {
	  //기본정보
	  setExtGrid_List();
	  //제품별 집계
	  setExtGrid_Count();
	  //상세내역
	  setExtGrid_Detail();
	  

      Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea1.updateLayout();
        gridarea2.updateLayout();
      });
  }
	  
  function setExtGrid_List() {
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
	                writer: $.extend(gridVals.writer, {
	                  writeAllFields: true
	                }),
	              },
	              listeners: {
                      load: function (dataStore, rows, bool) {
                          var cnt = rows.length;
                          if (cnt > 0) {
                              Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                              var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                              var orgid = model.data.ORGID;
                              var companyid = model.data.COMPANYID;
                              var searchdate = model.data.WORKDATE;
                              var workcentercode = model.data.WORKCENTERCODE;

                              var sparams = {
                                  ORGID: orgid,
                                  COMPANYID: companyid,
                                  SEARCHDATE: searchdate,
                                  WORKCENTERCODE: workcentercode,
                              };
                              extGridSearch(sparams, gridnms["store.2"]);
                          } else {
                              Ext.getStore(gridnms['store.2']).removeAll();
//                               Ext.getStore(gridnms['store.3']).removeAll();
                          }
                      },
                      scope: this
                  },
	            }, cfg)]);
	      },
	    });

	    Ext.define(gridnms["controller.1"], {
	      extend: Ext.app.Controller,
	      refs: {
	        WrappingIFPerform: '#WrappingIFPerform',
	      },
	      stores: [gridnms["store.1"]],
	           control: items["btns.ctr.1"],
	           
	           ListClick: ListClick,
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
	          height: 350,
	          border: 2,
	          features: [{
	              ftype: 'summary',
	              dock: 'bottom'
	            }
	          ],
	          scrollable: true,
	          columns: fields["columns.1"],
	          plugins: [{
	              ptype: 'bufferedrenderer',
	              trailingBufferZone: 20, // #1
	              leadingBufferZone: 20, // #2
	              synchronousRender: false,
	              numFromEdge: 19,
	            },
	          ],
	          viewConfig: {
	            itemId: 'WrappingIFPerform',
	            trackOver: true,
	            loadMask: true,
	            striptRows: true,
	            forceFit: true,
	            listeners: {
	              refresh: function (dataView) {
	                Ext.each(dataView.panel.columns, function (column) {
	                  if (column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 ) {
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

	  }
  
  function setExtGrid_Count() {
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
	                },
	                reader: gridVals.reader,
	                writer: $.extend(gridVals.writer, {
	                  writeAllFields: true
	                }),
	              },
	              listeners: {
                      load: function (dataStore, rows, bool) {
                          var cnt = rows.length;
                          if (cnt > 0) {
                              Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.count"]).getSelectionModel().select(0));
                              var model = Ext.getCmp(gridnms["views.count"]).selModel.getSelection()[0];

                              var orgid = model.data.ORGID;
                              var companyid = model.data.COMPANYID;
                              var searchdate = model.data.PRODDATE;
                              var workcentercode = model.data.WORKCENTERCODE;
                              var itemcode = model.data.ITEMCODE;

                              var sparams = {
                                  ORGID: orgid,
                                  COMPANYID: companyid,
                                  SEARCHDATE: searchdate,
                                  ITEMCODE: itemcode,
                                  WORKCENTERCODE: workcentercode,
                              };
                              extGridSearch(sparams, gridnms["store.3"]);
                          } else {
                              Ext.getStore(gridnms['store.3']).removeAll();
                          }
                      },
                      scope: this
                  },

	            }, cfg)]);
	      },
	    });

	    Ext.define(gridnms["controller.2"], {
	      extend: Ext.app.Controller,
	      refs: {
	    	  WrappingIFPerformCount: '#WrappingIFPerformCount',
	      },
	      stores: [gridnms["store.2"]],
	           control: items["btns.ctr.2"],
	           
	           CountClick: CountClick,
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
	          height: 350,
	          border: 2,
	            features: [{
	                ftype: 'summary',
	                dock: 'bottom'
	              }
	            ],
	          scrollable: true,
	          columns: fields["columns.2"],
	          plugins: [{
	              ptype: 'bufferedrenderer',
	              trailingBufferZone: 20, // #1
	              leadingBufferZone: 20, // #2
	              synchronousRender: false,
	              numFromEdge: 19,
	            },
	          ],
	          viewConfig: {
	            itemId: 'WrappingIFPerformCount',
	            trackOver: true,
	            loadMask: true,
	            striptRows: true,
	            forceFit: true,
	            listeners: {
	              refresh: function (dataView) {
	                Ext.each(dataView.panel.columns, function (column) {
	                  if (column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 ) {
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
	            }
	          ],
	          dockedItems: items["docked.2"],
	        }
	      ],
	    });

	    Ext.application({
	      name: gridnms["app"],
	      models: gridnms["models.count"],
	      stores: gridnms["stores.count"],
	      views: gridnms["views.count"],
	      controllers: gridnms["controller.2"],

	      launch: function () {
	        gridarea1 = Ext.create(gridnms["views.count"], {
	            renderTo: 'gridArea1'
	          });
	      },
	    });
	  }
  
  function setExtGrid_Detail() {
	    Ext.define(gridnms["model.3"], {
	      extend: Ext.data.Model,
	      fields: fields["model.3"],
	    });

	    Ext.define(gridnms["store.3"], {
	      extend: Ext.data.JsonStore, // Ext.data.Store,
	      constructor: function (cfg) {
	        var me = this;
	        cfg = cfg || {};
	        me.callParent([Ext.apply({
	              storeId: gridnms["store.3"],
	              model: gridnms["model.3"],
	              autoLoad: true,
	              isStore: false,
	              autoDestroy: true,
	              clearOnPageLoad: true,
	              clearRemovedOnLoad: true,
	              pageSize: 9999,
	              proxy: {
	                type: 'ajax',
	                api: items["api.3"],
	                timeout: gridVals.timeout,
	                extraParams: {
	                  ORGID: $('#searchOrgId option:selected').val(),
	                  COMPANYID: $('#searchCompanyId option:selected').val(),
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
	        WrappingIFPerformDetail: '#WrappingIFPerformDetail',
	      },
	      stores: [gridnms["store.3"]],
	           control: items["btns.ctr.3"],
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
	          height: 280,
	          border: 2,
	            features: [{
	                ftype: 'summary',
	                dock: 'bottom'
	              }
	            ],
	          scrollable: true,
	          columns: fields["columns.3"],
	          plugins: [{
	              ptype: 'bufferedrenderer',
	              trailingBufferZone: 20, // #1
	              leadingBufferZone: 20, // #2
	              synchronousRender: false,
	              numFromEdge: 19,
	            },
	          ],
	          viewConfig: {
	            itemId: 'WrappingIFPerformDetail',
	            trackOver: true,
	            loadMask: true,
	            striptRows: true,
	            forceFit: true,
	            listeners: {
	              refresh: function (dataView) {
	                Ext.each(dataView.panel.columns, function (column) {
	                  if (column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 ) {
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
	            }
	          ],
	          dockedItems: items["docked.3"],
	        }
	      ],
	    });

	    Ext.application({
	      name: gridnms["app"],
	      models: gridnms["models.detail"],
	      stores: gridnms["stores.detail"],
	      views: gridnms["views.detail"],
	      controllers: gridnms["controller.3"],

	      launch: function () {
	        gridarea2 = Ext.create(gridnms["views.detail"], {
	            renderTo: 'gridArea2'
	          });
	      },
	    });
	  }

  function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchfrom = $('#searchFrom').val();
    var searchto = $('#searchTo').val();
    var searchitemcode = $('#searchItemCode').val();
    var searchroutingid = $('#searchRoutingId').val();
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

    if (searchfrom == "") {
      header.push("일자 From");
      count++;
    }

    if (searchto == "") {
      header.push("일자 To");
      count++;
    }

    //    if (searchitemcode == "") {
    //      header.push("품번/품명");
    //      count++;
    //    }

    //    if (searchroutingid == "") {
    //      header.push("공정명");
    //      count++;
    //    }

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
    var searchfrom = $('#searchFrom').val();
    var searchto = $('#searchTo').val();
    var searchEquipmentName = $('#searchEquipmentName').val();
    
    
    
    //    var searchroutinggroup = $('#RoutingGroup').val();

    var sparams = {
      ORGID: orgid,
      COMPANYID: companyid,
      SEARCHFROM: searchfrom,
      SEARCHTO: searchto,
      EQUIPMENTNAME : searchEquipmentName,
    };

    extGridSearch(sparams, gridnms["store.1"]);
    extGridSearch(sparams, gridnms["store.2"])
  }


  function fn_ready() {
    extAlert("준비중입니다...");
  }

  function setLovList() {

       // 품번 LOV
       $("#searchEquipmentName")
       .bind("keydown", function (e) {
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
           $.getJSON("<c:url value='/searchWorkCenterLov.do' />", {
             keyword: extractLast(request.term),
             ORGID: $('#searchOrgId option:selected').val(),
             COMPANYID: $('#searchCompanyId option:selected').val(),
             WORKCENTERCODEIF: 'Y',
           }, function (data) {
             response($.map(data.data, function (m, i) {
                     return $.extend(m, {
                         value: m.VALUE,
                         label: m.LABEL,
                         name: m.LABEL,
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
           $("#searchEquipmentName").val(o.item.name);
           $("#searchEquipmentCode").val(o.item.value);

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
                                <li>공정 현황</li>
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
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <input type="hidden" id="orgid" name="orgid" />
                            <input type="hidden" id="companyid" name="companyid" />
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
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td >
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">설비명</th>
                                        <td >
                                            <input type="text" id="searchEquipmentName" name="searchEquipmentName" class=" input_left " style="width: 97%; " />
                                            <input type="hidden" id="searchEquipmentCode" name="searchEquipmentCode" />
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
                    <table style="width: 100%;">
                        <tr>
                        <td style="width: 34%;"><div class="subConTit2">기본정보</div></td>
                        <td style="width: 2%;"></td>
                        <td style="width: 64%;"><div class="subConTit2">제품별 집계</div></td>
                      </tr>
                    </table>
                    <div id="gridArea" style="width: 34%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
                    <div  style="width: 2%; padding-bottom: 5px; float: left;"></div>
                    <div id="gridArea1" style="width: 64%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
                </div>
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세내역</div></td>
                        </tr>
                    </table>
                    <div id="gridArea2" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
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