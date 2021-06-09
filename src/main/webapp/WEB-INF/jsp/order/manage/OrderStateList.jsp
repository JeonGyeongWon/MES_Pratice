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

	  $("#SoStatus").val("STAND BY");

	  setLovList();
	  setReadOnly();
	});

	function setInitial() {
	  calender($('#searchFrom, #searchTo, #searchDueFrom, #searchDueTo'));

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

	  gridnms["app"] = "order";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "OrderStateList";

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
	      name: 'SONO',
	    }, {
	      type: 'number',
	      name: 'SOSEQ',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
	    }, {
	      type: 'date',
	      name: 'SODATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'SOTYPE',
	    }, {
	      type: 'string',
	      name: 'SOTYPENAME',
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
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'WEIGHT',
	    }, {
	      type: 'number',
	      name: 'SUMWEIGHT',
	    }, {
	      type: 'number',
	      name: 'SOQTY',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'number',
	      name: 'BEFOREQTY',
	    }, {
	      type: 'number',
	      name: 'UNITPRICE',
	    }, {
	      type: 'number',
	      name: 'SUPPLYPRICE',
	    }, {
	      type: 'number',
	      name: 'ADDITIONALTAX',
	    }, {
	      type: 'number',
	      name: 'TOTAL',
	    }, {
	      type: 'date',
	      name: 'DUEDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'CASTENDPLANDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKENDPLANDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'TAXDIV',
	    }, {
	      type: 'string',
	      name: 'PAYMENTTERMS',
	    }, {
	      type: 'string',
	      name: 'WORKORDERDIV',
	    }, {
	      type: 'string',
	      name: 'SOSTATUS',
	    }, {
	      type: 'string',
	      name: 'SOSTATUSNAME',
	    }, {
	      type: 'string',
	      name: 'SALESPERSON',
	    }, {
	      type: 'string',
	      name: 'SALESPERSONNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
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
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SONO',
	      text: '수주번호',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SOSEQ',
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
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SODATE',
	      text: '수주일',
	      xtype: 'datecolumn',
	      width: 105,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SOTYPENAME',
	      text: '수주구분',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	      //      }, {
	      //        dataIndex: 'SMALLNAME',
	      //        text: '소분류',
	      //        xtype: 'gridcolumn',
	      //        width: 90,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        align: "center",
	    },  
// 	    {
// 	      dataIndex: 'DRAWINGNO',
// 	      text: '도번',
// 	      xtype: 'gridcolumn',
// 	      width: 200,
// 	      hidden: false,
// 	      sortable: false,
// 	      resizable: false,
// 	      menuDisabled: true,
// 	      style: 'text-align:center',
// 	      align: "left",
// 	      renderer: function (value, meta, record) {
// 	        var colorchk = record.data.COLORCHK;
// 	        if (colorchk == "RED") {
// 	          meta.style = "color:rgb(255, 0, 0) ;";
// 	          meta.style += "font-weight: bold ;";
// 	        } else if (colorchk == "BLUE") {
// 	          meta.style = "color:rgb(0, 84, 255) ;";
// 	          meta.style += "font-weight: bold ;";
// 	        }
// 	        return value;
// 	      },
// 	    }, 
	    {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      summaryRenderer: function (value, meta, record) {
	        value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
	        return value;
	      },
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
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
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
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
        width: 60,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
            var colorchk = record.data.COLORCHK;
            if (colorchk == "RED") {
              meta.style = "color:rgb(255, 0, 0) ;";
              meta.style += "font-weight: bold ;";
            } else if (colorchk == "BLUE") {
              meta.style = "color:rgb(0, 84, 255) ;";
              meta.style += "font-weight: bold ;";
            }
            return value;
        },
      },{
        dataIndex: 'ORDERNAME',
        text: '품번',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
          var colorchk = record.data.COLORCHK;
          if (colorchk == "RED") {
            meta.style = "color:rgb(255, 0, 0) ;";
            meta.style += "font-weight: bold ;";
          } else if (colorchk == "BLUE") {
            meta.style = "color:rgb(0, 84, 255) ;";
            meta.style += "font-weight: bold ;";
          }
          return value;
        },
      }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	      //      }, {
	      //        dataIndex: 'WEIGHT',
	      //        text: '단중',
	      //        xtype: 'gridcolumn',
	      //        width: 80,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        style: 'text-align:center',
	      //        align: "right",
	      //        cls: 'ERPQTY',
	      //        summaryType: 'sum',
	      //        summaryRenderer: function (value, meta, record) {
	      //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000.00') + "</div>";
	      //          return result;
	      //        },
	      //        renderer: Ext.util.Format.numberRenderer('0,000.00'),
	      //      }, {
	      //        dataIndex: 'SUMWEIGHT',
	      //        text: '중량',
	      //        xtype: 'gridcolumn',
	      //        width: 80,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        style: 'text-align:center',
	      //        align: "right",
	      //        cls: 'ERPQTY',
	      //        summaryType: 'sum',
	      //        summaryRenderer: function (value, meta, record) {
	      //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000.00') + "</div>";
	      //          return result;
	      //        },
	      //        renderer: Ext.util.Format.numberRenderer('0,000.00'),
	    }, {
	      dataIndex: 'SOQTY',
	      text: '수주수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'BEFOREQTY',
	      text: '미출하수량',
	      xtype: 'gridcolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'UNITPRICE',
	      text: '단가',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SUPPLYPRICE',
	      text: '공급가액',
	      xtype: 'gridcolumn',
	      width: 115,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'ADDITIONALTAX',
	      text: '부가세',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOTAL',
	      text: '합계',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'DUEDATE',
	      text: '납기일',
	      xtype: 'datecolumn',
	      width: 105,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	      //      }, {
	      //        dataIndex: 'CASTENDPLANDATE',
	      //        text: '주조완료<br/>예정일',
	      //        xtype: 'datecolumn',
	      //        width: 105,
	      //        hidden: false,
	      //        sortable: true,
	      //        align: "center",
	      //        format: 'Y-m-d',
	      //        renderer: function (value, meta, record) {
	      //          return Ext.util.Format.date(value, 'Y-m-d');
	      //        },
	      //      }, {
	      //        dataIndex: 'WORKENDPLANDATE',
	      //        text: '가공완료<br/>예정일',
	      //        xtype: 'datecolumn',
	      //        width: 105,
	      //        hidden: false,
	      //        sortable: true,
	      //        align: "center",
	      //        format: 'Y-m-d',
	      //        renderer: function (value, meta, record) {
	      //          return Ext.util.Format.date(value, 'Y-m-d');
	      //        },
	    }, {
	      dataIndex: 'TAXDIVNAME',
	      text: '세액구분',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'PAYMENTTERMSNAME',
	      text: '결제조건',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'WORKORDERDIV',
	      text: '작업의뢰<br/>여부',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SOSTATUSNAME',
	      text: '수주상태',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SALESPERSONNAME',
	      text: '담당자',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	      renderer: function (value, meta, record) {
	        var colorchk = record.data.COLORCHK;
	        if (colorchk == "RED") {
	          meta.style = "color:rgb(255, 0, 0) ;";
	          meta.style += "font-weight: bold ;";
	        } else if (colorchk == "BLUE") {
	          meta.style = "color:rgb(0, 84, 255) ;";
	          meta.style += "font-weight: bold ;";
	        }
	        return value;
	      },
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'SONO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SOTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CARTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SOSTATUS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SALESPERSON',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SMALLCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CASTENDPLANDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKENDPLANDATE',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/order/manage/OrderStateList.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};

	  // 페이징
	  items["dock.paging.1"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.1"],
	  };

	  // 버튼 컨트롤
	  items["dock.btn.1"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.1"],
	    items: items["btns.1"],
	  };

	  items["docked.1"] = [];
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
	                DATEFROM: $('#searchFrom').val(),
	                DATETO: $('#searchTo').val(),
	                SOSTATUS: $('#SoStatus').val(),
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
	      inventoryList: '#inventoryList',
	    },
	    stores: [gridnms["store.1"]],
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
	        height: 653,
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
	            trailingBufferZone: 20,
	            leadingBufferZone: 20,
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'inventoryList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchFrom = $("#searchFrom").val();
	    var searchTo = $("#searchTo").val();
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
	    header.push("수주일자 FROM");
	    count++;
	  }

	    if (searchTo == "") {
	      header.push("수주일자 TO");
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
	  var datefrom = $('#searchFrom').val();
	  var dateto = $('#searchTo').val();
	  var customercode = $('#CustomerCode').val();
	  var sotype = $('#SoType').val();
	  var smallcode = $('#SearchSmallCode').val();
	  var salesperson = $('#SalesPerson').val();
	  var duefrom = $('#searchDueFrom').val();
	  var dueto = $('#searchDueTo').val();
	  var itemcode = $('#searchItemcd').val();
	  var sostatus = $('#SoStatus').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    DATEFROM: datefrom,
	    DATETO: dateto,
	    CUSTOMERCODE: customercode,
	    SOTYPE: sotype,
	    SMALLCODE: smallcode,
	    SALESPERSON: salesperson,
	    DUEFROM: duefrom,
	    DUETO: dueto,
	    ITEMCODE: itemcode,
	    SOSTATUS: sostatus,
	  };
	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#searchFrom').val();
	  var dateto = $('#searchTo').val();
	  var customercode = $('#CustomerCode').val();
	  var sotype = $('#SoType').val();
	  var smallcode = $('#SearchSmallCode').val();
	  var salesperson = $('#SalesPerson').val();
	  var duefrom = $('#searchDueFrom').val();
	  var dueto = $('#searchDueTo').val();
	  var itemcode = $('#searchItemcd').val();
	  var sostatus = $('#SoStatus').val();

	  go_url("<c:url value='/order/manage/ExcelDownload.do?ORGID='/>" + orgid
	     + "&COMPANYID=" + companyid + ""
	     + "&DATEFROM=" + datefrom + ""
	     + "&DATETO=" + dateto + ""
	     + "&CUSTOMERCODE=" + customercode + ""
	     + "&SOTYPE=" + sotype + ""
	     + "&SMALLCODE=" + smallcode + ""
	     + "&SALESPERSON=" + salesperson + ""
	     + "&DUEFROM=" + duefrom + ""
	     + "&DUETO=" + dueto + ""
	     + "&ITEMCODE=" + itemcode + ""
	     + "&SOSTATUS=" + sostatus + ""
	     + "&TITLE=" + "${pageTitle}" + "");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
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
	        GUBUN: 'ITEMNAME',
	        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
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
	        GUBUN: 'ORDERNAME',
	        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
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
	  // 거래처명 lov
	  $("#CustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#CustomerCode").val("");

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
	        CUSTOMERTYPE1: 'S',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
	              NAME: m.LABEL,
	              ADDRESS: m.ADDRESS,
	              FREIGHT: m.FREIGHT,
	              PHONENUMBER: m.PHONENUMBER,
	              UNITPRICEDIV: m.UNITPRICEDIV,
	              UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
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
	      $("#CustomerCode").val(o.item.value);
	      $("#CustomerName").val(o.item.NAME);

	      return false;
	    }
	  });

	  // 담당자 Lov
	  $("#SalesPersonName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#SalesPersonName").val("");
	      $("#SalesPerson").val("");
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
	        INSPECTORTYPE: '10', // 관리직만 검색
	        //              DEPTCODE : 'A004' // 영업부만 조회
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
	      $("#SalesPerson").val(o.item.value);
	      $("#SalesPersonName").val(o.item.label);

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
														<li>수주관리</li>
														<li>&gt;</li>
														<li><strong>${pageTitle}</strong></li>
												</ul>
										</div>
								</div>
								<div id="search_field">
										<div id="search_field_loc">
												<h2>
														<strong>${pageTitle}</strong>
												</h2>
										</div>
										<fieldset style="width: 100%;">
												<legend>조건정보 영역</legend>
												<form id="master" name="master" action="" method="post">
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
																		<td colspan="2"><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 50%;">
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
																		<td colspan="2"><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
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
																		<td colspan="2">
																				<div class="buttons" style="float: right; margin-top: 3px;">
																						<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																						<a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
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
																				<col width="120px">
																				<col>
																</colgroup>
																<tr style="height: 34px;">
																		<th class="required_text">수주일자</th>
																		<td>
																				<input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 90px;" maxlength="10" />
																				&nbsp;~&nbsp;
																				<input type="text" id="searchTo" name="searchTo" class="input_validation input_center " style="width: 90px;" maxlength="10" />
																		</td>
																		<th class="required_text">납기일자</th>
																		<td>
																				<input type="text" id="searchDueFrom" name="searchDueFrom" class="input_center " style="width: 90px;" maxlength="10" />
																				&nbsp;~&nbsp;
																				<input type="text" id="searchDueTo" name="searchDueTo" class="input_center " style="width: 90px;" maxlength="10" />
																		</td>
																		<th class="required_text">거래처</th>
																		<td>
																				<input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;" />
																				<input type="hidden" id="CustomerCode" name="CustomerCode" />
																		</td>
																		<th class="required_text">수주구분</th>
																		<td>
																				<select id="SoType" name="SoType" class="input_left " style="width: 94%;">
																						<c:if test="${empty searchVO.SOTYPE}">
																										<option value="">전체</option>
																						</c:if>
																						<c:forEach var="item" items="${labelBox.findBySoTypeGubun}" varStatus="status">
																										<c:choose>
																														<c:when test="${item.VALUE==searchVO.SOTYPE}">
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
																				<input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 94%;" />
																				<input type="hidden" id="searchItemcd" name="searchItemcd" />
																		</td>
																		<th class="required_text">품명</th>
																		<td>
																		    <input type="text" id="searchItemnm" name="searchItemnm" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;" />
																		</td>
																		<th class="required_text">담당자</th>
																		<td>
																				<input type="text" id="SalesPersonName" name="SalesPersonName" class=" input_center" style="width: 94%;" />
																				<input type="hidden" id="SalesPerson" name="SalesPerson" />
																		</td>
																		<th class="required_text">수주상태</th>
																		<td>
																				<select id="SoStatus" name="SoStatus" class="input_left " style="width: 94%;">
																						<c:if test="${empty searchVO.SOSTATUS}">
																										<option value="">전체</option>
																						</c:if>
																						<c:forEach var="item" items="${labelBox.findBySoStatusGubun}" varStatus="status">
																										<c:choose>
																														<c:when test="${item.VALUE==searchVO.SOSTATUS}">
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
														</table>
												</form>
										</fieldset>
								</div>
								<div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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