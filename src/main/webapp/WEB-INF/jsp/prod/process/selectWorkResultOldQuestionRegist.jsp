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

<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">
<style>
.x-column-header-inner {
  font-size: 18px;
  line-height: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  padding-left: 0px;
  padding-right: 0px;
}

.FML .x-grid-cell-inner {
  padding-left: 0px;
  padding-right: 0px;
}

.x-grid-cell-inner {
  position: relative;
  text-overflow: ellipsis;
  padding-top: 10px;
  padding-left: 10px;
  height: 45px;
  font-size: 18px !important;
  font-weight: bold;
}

.x-btn {
  margin-top: 2px;
  height: 39px;
}

.x-btn-inner {
  font-size: 14px !important;
}

#gridArea .x-form-field {
  font-size: 18px;
  font-weight: bold;
}

.x-window-item {
  text-align: center;
  background-color: rgb(79, 79, 79);
  color: rgb(255, 255, 255);
}

.x-toolbar {
  background-color: rgb(79, 79, 79);
}
</style>
<style>
.shadow {
  -webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
  -moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
  box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
  background-color: highlight;
}

.blue {
  background-color: #003399;
  color: white;
}

.blue2:HOVER {
  background-color: highlight;
  font-size: 18px;
  font-weight: bold;
}

.blue2 {
  background-color: #5B9BD5;
  color: white;
  font-size: 18px;
  font-weight: bold;
}

.blue3:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #003399;
}

.blue3 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #003399 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.gray:HOVER {
  background-color: #EAEAEA;
}

.gray {
  background-color: #BDBDBD;
  color: black;
}

.black:HOVER {
  background-color: #EAEAEA;
}

.black {
  background-color: #BDBDBD;
  color: black !important;
}

.white:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white2:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white2 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 16px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  border-bottom: 4px solid #5B9BD5;
  margin-top: 0px;
  margin-bottom: 0px;
}

.yellow:hover {
  background-color: #FFFFFF;
  color: yellow !important;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  border-bottom: 4px solid yellow;
}

.yellow {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.yellow_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid yellow;
}

.yellow_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: yellow !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  cursor: pointer;
  border-bottom: 4px solid yellow;
  cursor: pointer;
}

.red:HOVER {
  background-color: #FFD8D8;
}

.red {
  background-color: #FFA7A7;
  color: black;
}

.green:HOVER {
  background-color: #CEFBC9;
}

.green {
  background-color: #B7F0B1;
  color: black;
}

.r {
  border-radius: 4px 4px 4px 4px;
  -moz-border-radius: 4px 4px 4px 4px;
  -webkit-border-radius: 4px 4px 4px 4px;
  border: 0px solid #000000;
}

.ui-autocomplete {
  font-size: 33px;
  font-weight: bold;
  max-height: 400px;
  overflow-y: auto;
  /* prevent horizontal scrollbar */
  overflow-x: hidden;
}

* html .ui-autocomplete {
  /* IE 6.0 */
  height: 400px;
  font-size: 33px;
  font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

*::-webkit-input-placeholder {
  color: blue;
}

*:-moz-placeholder {
  /* FF 4-18 */
  color: blue;
}

*::-moz-placeholder {
  /* FF 19+ */
  color: blue;
}

*:-ms-input-placeholder {
  /* IE 10+ */
  color: blue;
}

.ResultTable th {
  font-size: 20px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid white;
}

.ResultTable td {
  font-size: 20px;
  color: black;
  text-align: center;
}

</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var clickindex = 0;
var clickindex2 = 0;
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setReadOnly();

  setLovList();
});

var worker_value, worker_label;
function setInitial() {
  gridnms["app"] = "process";

  var filter_params = {
    ORGID: $('#orgid').val(),
    COMPANYID: $('#companyid').val(),
    DEPTCODE: "A009",
    POSITIONCODE: "",
    INSPECTIONTYPE: "20",
    WORKDEPT: $('#gubun').val(),
  };
  worker_value = fn_worker_filter_data(filter_params.ORGID, filter_params.COMPANYID, filter_params.DEPTCODE, filter_params.POSITIONCODE, filter_params.INSPECTIONTYPE, filter_params.WORKDEPT, "VALUE");
  worker_label = fn_worker_filter_data(filter_params.ORGID, filter_params.COMPANYID, filter_params.DEPTCODE, filter_params.POSITIONCODE, filter_params.INSPECTIONTYPE, filter_params.WORKDEPT, "LABEL");

  fn_calc_grid_height();

  for (var i = 0; i < worker_value.length; i++) {
    var nm = (i + 1);
    var value = worker_value[i];
    var label = worker_label[i];
    var btn_style = " width: 205px; height: 45px; font-size: 22px; font-weight: bold; color: #fff; margin-left: 5px; margin-right: 5px; margin-bottom: 10px; disabled ";
    var btn_css = fn_html_create("btn", "btnWorker" + nm, value, label, btn_style);

    $('#changebuttons').append(btn_css);
  }
}

var btn_height = 0, base_height = 55, menu_height = 0, area_height = 930, grid_height = 0;
function fn_calc_grid_height() {
  var btnRowCnt = Math.round((worker_value.length / 8));
  menu_height = $("#menuArea").outerHeight(true);
  btn_height = menu_height + (base_height * btnRowCnt);
  grid_height = area_height - btn_height;
}

function fn_html_create(flag_type, flag_id, flag_val, flag_label, flag_css) {
  var result = "";
  switch (flag_type) {
  case "hidden":
    // 숨김
    result = '<input type="hidden" id="' + flag_id + '" name="' + flag_id + '" value="' + flag_val + '" />';
    break;
  case "img":
    // 이미지
    result = '<img alt="" src="' + flag_val + '" style="' + flag_css + '" />';
    break;
  case "no_img":
    // 이미지 X
    result = '<img alt="" src="' + '<c:url value="/" />' + 'images/noimage.png" style="' + flag_css + '" />';
    break;
  case "select":
    // option
    result = '<select id="' + flag_id + '" name="' + flag_id + '" class=" input_center" style="' + flag_css + '">'
       + '<option style="color: blue; font-weight: bold; height: 50px;" value="OK" ' + ((flag_val == "OK") ? "selected" : "") + '>OK</option>'
       + '<option style="color: red; font-weight: bold; height: 50px;" value="NG" ' + ((flag_val == "NG") ? "selected" : "") + '>NG</option>'
       + '</select>';
    break;
  case "input":
    // 입력
    result = '<input type="text" id="' + flag_id + '" name="' + flag_id + '" class="input_left " value="' + flag_val + '" style="' + flag_css + '" />';
    break;
  case "no_input":
    // 입력 X
    result = '<input type="text" id="' + flag_id + '" name="' + flag_id + '" class="input_left " value="" style="' + flag_css + '" />';
    break;
  case "btn":
    // 버튼
    result = '<button type="button" id="' + flag_id + '" name="' + flag_id + '" onclick="javascript:fn_worker_click(\'' + flag_val + '\', \'' + flag_label + '\');"class="black h r shadow " value="" style="' + flag_css + '" >' +
      flag_label +
      '</button>';
    break;
  default:
    result = "";
    break;
  }
  return result;
}

function fn_worker_click(value, label) {
  var count = Ext.getStore(gridnms["store.1"]).count();
  if (count > 0) {
    var workorderid = $('#workorderid').val();
    if (workorderid == "") {
      extToastView("작업지시 내역이 선택되지 않았습니다.<br/>작업지시 내역을 선택해주세요.");
      return false;
    }

    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx));
    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

    model.set("WORKER", value);
    model.set("WORKERNAME", label);
  } else {
    extToastView("작업지시 내역이 없습니다.<br/>관리자에게 문의해주세요.");
    return false;
  }
}

function setValues() {
  setValues_work();
}

function setValues_work() {
  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "WorkOrderBtnList";

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
      name: 'WORKRN',
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
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'number',
      name: 'LEV',
    }, {
      type: 'string',
      name: 'WORKCENTERCODE',
    }, {
      type: 'string',
      name: 'WORKCENTERNAME',
    }, {
      type: 'string',
      name: 'WORKDIV',
    }, {
      type: 'string',
      name: 'WORKDIVNAME',
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
      name: 'CARTYPE',
    }, {
      type: 'string',
      name: 'CARTYPENAME',
    }, {
      type: 'string',
      name: 'ITEMSTANDARDDETAIL',
    }, {
      type: 'string',
      name: 'WORKER',
    }, {
      type: 'string',
      name: 'WORKERNAME',
    }, {
      type: 'string',
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'number',
      name: 'MONTHLYQTY',
    }, {
      type: 'number',
      name: 'DAILYQTY',
    }, {
      type: 'number',
      name: 'MONTHLYFAULTQTY',
    }, {
      type: 'number',
      name: 'DAILYFAULTQTY',
    }, {
      type: 'string',
      name: 'FMLYN',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순<br/>번',
      xtype: 'gridcolumn',
      width: 60,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return value;
      },
    }, {
      dataIndex: 'WORKCENTERNAME',
      text: '설비<br/>번호',
      xtype: 'gridcolumn',
      width: 75,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 1) {
          return value;
        } else {
          if (rn == 2) {
            meta.style = "border-bottom: 1px solid blue;";
          }
          return "";
        }
      },
    }, {
      dataIndex: 'XBUTTON',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      xtype: 'widgetcolumn',
      stopSelection: true,
      text: '작업<br/>완료',
      width: 80,
      style: 'text-align:center; ',
      align: "center",
      locked: true,
      lockable: false,
      widget: {
        xtype: 'button',
        _btnText: "완료",
        defaultBindProperty: null,
        handler: function (widgetColumn) {
          var record = widgetColumn.getWidgetRecord();

          var rec_row = rowIdx;
          var rec_col = colIdx;
          fn_work_result_fnc(record.data, rec_row, rec_col, "END");
        },
        listeners: {
          beforerender: function (widgetColumn) {
            var record = widgetColumn.getWidgetRecord();
            var workdivname = record.data.WORKDIVNAME;
            //               widgetColumn.setText(widgetColumn._btnText);
            widgetColumn.setText(workdivname + "");
          }
        }
      },
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
      },
    }, {
      dataIndex: 'WORKDIVNAME',
      text: '주야<br/>구분',
      xtype: 'gridcolumn',
      width: 75,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return value;
      },
    }, {
      dataIndex: 'WORKERNAME',
      text: '작업자',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return value;
      },
    }, {
      dataIndex: 'CARTYPENAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 1) {
          return value;
        } else {
          if (rn == 2) {
            meta.style = "border-bottom: 1px solid blue;";
          }
          return "";
        }
      },
    }, {
      dataIndex: 'ITEMSTANDARDDETAIL',
      text: '타입',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      resizable: false,
      style: 'text-align:center',
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 1) {
          return value;
        } else {
          if (rn == 2) {
            meta.style = "border-bottom: 1px solid blue;";
          }
          return "";
        }
      },
    }, {
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
      xtype: 'gridcolumn',
      width: 200,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      locked: true,
      lockable: false,
      renderer: function (value, meta, record) {
        var rn = record.data.WORKRN;
        if (rn == 1) {
          return value;
        } else {
          if (rn == 2) {
            meta.style = "border-bottom: 1px solid blue;";
          }
          return "";
        }
      },
    }, {
      text: '양품수량',
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      locked: true,
      lockable: false,
      columns: [{
          dataIndex: 'MONTHLYQTY',
          text: '월누계',
          xtype: 'gridcolumn',
          width: 90,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          cls: 'ERPQTY',
          format: "0,000",
          locked: true,
          lockable: false,
          renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
              return Ext.util.Format.number(value, '0,000');
            } else {
              if (rn == 2) {
                meta.style = "border-bottom: 1px solid blue;";
              }
              return "";
            }
          },
        }, {
          dataIndex: 'DAILYQTY',
          text: '일누계',
          xtype: 'gridcolumn',
          width: 75,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          cls: 'ERPQTY',
          format: "0,000",
          locked: true,
          lockable: false,
          renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 2) {
              meta.style = "border-bottom: 1px solid blue;";
            }
            return Ext.util.Format.number(value, '0,000');
          },
        }, ],
    }, {
      text: '불량수량',
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      locked: true,
      lockable: false,
      columns: [{
          dataIndex: 'MONTHLYFAULTQTY',
          text: '월누계',
          xtype: 'gridcolumn',
          width: 90,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          cls: 'ERPQTY',
          format: "0,000",
          locked: true,
          lockable: false,
          renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 1) {
              return Ext.util.Format.number(value, '0,000');
            } else {
              if (rn == 2) {
                meta.style = "border-bottom: 1px solid blue;";
              }
              return "";
            }
          },
        }, {
          dataIndex: 'DAILYFAULTQTY',
          text: '일누계',
          xtype: 'gridcolumn',
          width: 75,
          hidden: false,
          sortable: false,
          resizable: true,
          menuDisabled: true,
          style: 'text-align:center;',
          align: "center",
          cls: 'ERPQTY',
          format: "0,000",
          locked: true,
          lockable: false,
          renderer: function (value, meta, record) {
            var rn = record.data.WORKRN;
            if (rn == 2) {
              meta.style = "border-bottom: 1px solid blue;";
            }
            return Ext.util.Format.number(value, '0,000');
          },
        }, ],
    },
    // Hidden Columns
    {
      dataIndex: 'WORKRN',
      xtype: 'hidden',
    }, {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
        dataIndex: 'WORKORDERID',
        xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKSTATUS',
      xtype: 'hidden',
    }, {
      dataIndex: 'LEV',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKCENTERCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKDIV',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CARTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKER',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGID',
      xtype: 'hidden',
    }, ];

  fields["columns-qty.1"] = [];
  fields["columns.1"].push({
    dataIndex: 'XXXXXTOTALQTY',
    text: "생산수량",
    hidden: false,
    sortable: false,
    resizable: false,
    menuDisabled: true,
    columns: fields["columns-qty.1"],
  });

  var qty_count = 99;
  for (var i = 0; i < qty_count; i++) {
    var displayColumn = "";
    (function (x) {
      displayColumn = (x + 1);
      fields["columns-qty.1"].push({
        dataIndex: 'XXXXXXXXXX' + i,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        xtype: 'widgetcolumn',
        stopSelection: true,
        text: displayColumn,
        width: 50,
        style: 'text-align:center',
        align: "center",
        widget: {
          xtype: 'button',
          defaultBindProperty: null,
          handler: function (widgetColumn) {
            var record = widgetColumn.getWidgetRecord();

            var rn = (x + 1);
            var rec_row = rowIdx;

            fn_work_result_fnc(record.data, rec_row, rn, "START");
          },
          listeners: {
            beforerender: function (widgetColumn) {
              var record = widgetColumn.getWidgetRecord();

              var btn_text = "X";
              var rn = (x + 1);
              var dailyqty = record.data.DAILYQTY * 1;
              if (dailyqty >= rn) {
                btn_text = "O";
              } else {
                btn_text = "X";
              }
              widgetColumn.setText(btn_text);
            }
          }
        },
        onWidgetAttach: function (col, widget, rec) {
          // 버튼 활성화 / 비활성화
          var btn_text = "X";
          var rn = (x + 1);
          var dailyqty = rec.data.DAILYQTY * 1;
          if (dailyqty >= rn) {
            btn_text = "O";
          } else {
            btn_text = "X";
          }
          widget.setText(btn_text);
          //               widget.setDisabled(false);

          col.mon(col.up('gridpanel').getView(), {
            itemupdate: function () {
              var btn_text = "X";
              var rn = (x + 1);
              var dailyqty = rec.data.DAILYQTY * 1;
              if (dailyqty >= rn) {
                btn_text = "O";
              } else {
                btn_text = "X";
              }
              widget.setText(btn_text);
            }
          });
        },
        renderer: function (value, meta, record) {
          var workrn = record.data.WORKRN;
          if (workrn == 2) {
            meta.style = " border-bottom: 1px solid blue; ";
          }
          var chk = false; ;
          var rn = (x + 1);
          var dailyqty = record.data.DAILYQTY * 1;
          if (dailyqty >= rn) {
            chk = true;
          } else {
            chk = false;
          }

          if (chk) {
            var workdiv = record.data.WORKDIV;
            if (workdiv == "01") {
              meta.style += " background-color: rgb(255, 192, 0); ";
            } else if (workdiv == "02") {
//               meta.style += " background-color: rgb(31, 78, 120); ";
              meta.style += " background-color: rgb(0, 176, 80); ";
            }
          }
        },
      });
    })(i);
  }

  fields["columns.1"].push({
    dataIndex: 'ITEMNAME',
    text: '품명',
    xtype: 'gridcolumn',
    width: 260,
    hidden: false,
    sortable: false,
    resizable: true,
    menuDisabled: true,
    style: 'text-align:center',
    align: "left",
    renderer: function (value, meta, record) {
      var rn = record.data.WORKRN;
      if (rn == 1) {
        return value;
      } else {
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return "";
      }
    },
  }, {
    dataIndex: 'ORDERNAME',
    text: '품번',
    xtype: 'gridcolumn',
    width: 140,
    hidden: false,
    sortable: false,
    resizable: true,
    menuDisabled: true,
    align: "center",
    renderer: function (value, meta, record) {
      var rn = record.data.WORKRN;
      if (rn == 1) {
        return value;
      } else {
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return "";
      }
    },
  }, {
    dataIndex: 'WORKSTATUSNAME',
    text: '상태',
    xtype: 'gridcolumn',
    width: 90,
    hidden: false,
    sortable: false,
    resizable: true,
    menuDisabled: true,
    resizable: false,
    style: 'text-align:center',
    align: "center",
    renderer: function (value, meta, record) {
      var rn = record.data.WORKRN;
      if (rn == 1) {
        return value;
      } else {
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return "";
      }
    },
  }, {
    dataIndex: 'XXXXXXXXXX',
    text: '작업지시번호',
    xtype: 'gridcolumn',
    width: 140,
    hidden: false,
    sortable: false,
    resizable: false,
    menuDisabled: true,
    align: "center",
    renderer: function (value, meta, record) {
      var workorderid = record.data.WORKORDERID;
      var rn = record.data.WORKRN;
      if (rn == 1) {
        return workorderid;
      } else {
        if (rn == 2) {
          meta.style = "border-bottom: 1px solid blue;";
        }
        return "";
      }
    },
  }, {
    dataIndex: 'FMLYN',
    text: '자주검사<BR/>여부',
    xtype: 'gridcolumn',
    width: 80,
    hidden: false,
    sortable: false,
    resizable: false,
    menuDisabled: true,
    style: 'text-align:center;',
    align: "center",
    renderer: function (value, meta, record) {
      var rn = record.data.WORKRN;
      if (rn == 2) {
        meta.style = "border-bottom: 1px solid blue;";
      }
      return value;
    },
  });

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/WorkOrderBtnList.do' />"
  });
  //   $.extend(items["api.1"], {
  //     update: "<c:url value='/update/prod/process/WorkOrderBtnList.do' />"
  //   });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
    "#WorkSelect": {
      itemclick: 'WorkSelectClick'
    }
  });

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

function fn_work_result_fnc(rec, row, col, flag) {
  var flag_name = (flag == "END") ? "완료" : "등록";

  var gridcount = Ext.getStore(gridnms["store.1"]).count();
  if (gridcount == 0) {
    extToastView("[작업실적 " + flag_name + "]<br/>데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
    return false;
  }

  var select_record = rec;
  if (flag == "END") {
    // 주야별 작업마감
    console.log("[주야별 작업마감] 영역입니다.");
  } else {
    // 주야별 작업자 실적 등록
    console.log("[주야별 작업등록] 영역입니다.");

    var dailyqty = select_record.DAILYQTY * 1;
    if (dailyqty >= col) {
      select_record.INPUTQTY = -1;
    } else {
      select_record.INPUTQTY = 1;
    }
    console.log("수량 >>>>>>>>>> " + select_record.INPUTQTY);
  }

  var url = "<c:url value='/update/prod/process/WorkOrderBtnList.do' />";
  select_record.WORKFLAG = flag;
  var qty = select_record.INPUTQTY;
  
  if ( qty > 0 ) {

      $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: select_record,
        success: function (data) {
          var success = data.success;
          var msg = data.msg;
          if (!success) {
            extToastView("관리자에게 문의하십시오.<br/>" + msg);
            return;
          } else {
                          Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                          Ext.getCmp(gridnms["views.list"]).doLayout();

            extToastView(msg);

            Ext.getStore(gridnms["store.1"]).load();
            Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
              row: rowIdx,
              column: colIdx,
              animate: false
            });
          }
        },
        error: ajaxError
      });
  } else {
      var msgFlagName = (qty < 0) ? "등록취소" : flag_name;
    var msgTitle = '작업실적 ' + msgFlagName;
    var msgTitle_css = "<strong style='font-size: 42px; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + msgTitle + "</strong>";

    var msgData = msgFlagName + ' 처리하시겠습니까?';
    var msgData_css = "<strong style='font-size: 40px; text-align: center; font-weight: bold; color: rgb(255, 255, 255); line-height: 45px; '>" + msgData + "</strong>";
    Ext.MessageBox.confirm(msgTitle_css, msgData_css, function (btn) {
      if (btn == 'yes') {
        var params = [];
        $.ajax({
          url: url,
          type: "post",
          dataType: "json",
          data: select_record,
          success: function (data) {
            var success = data.success;
            var msg = data.msg;
            if (!success) {
              extToastView("관리자에게 문의하십시오.<br/>" + msg);
              return;
            } else {
                            Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                            Ext.getCmp(gridnms["views.list"]).doLayout();

              extToastView(msg);

              Ext.getStore(gridnms["store.1"]).load();
              Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                row: rowIdx,
                column: colIdx,
                animate: false
              });
            }
          },
          error: ajaxError
        });

      } else {
          var msgFlagName = (qty < 0) ? "등록취소" : flag_name;
        var msgData = msgFlagName + ' 처리가 취소되었습니다.';
        var msgbtn = "확인되었음<br/>[Confirmed]";
        extWorkAlert(msgTitle, msgData, msgbtn);
        //         Ext.Msg.alert('작업실적 ' + flag_name, flag_name + ' 처리가 취소되었습니다.');
        return false;
      }
    });
  }
}

var rowIdx = 0, colIdx = 0;
function WorkSelectClick(dataview, record, item, index, e, eOpts) {
  rowIdx = e.position.rowIdx;
  colIdx = e.position.colIdx;

  // 작업항목 선택시
  var orgid = record.data.ORGID;
  var companyid = record.data.COMPANYID;
  var workorderid = record.data.WORKORDERID;
  var workorderseq = record.data.WORKORDERSEQ;
  var itemcode = record.data.ITEMCODE;
  var routingcode = record.data.ROUTINGCODE;

  $("#orgid").val(orgid);
  $("#companyid").val(companyid);
  $("#workorderid").val(workorderid);
  $("#workorderseq").val(workorderseq);
  $("#itemcode").val(itemcode);
  $("#routingcode").val(routingcode);
};

var gridarea1;
function setExtGrid() {
  setExtGrid_work();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function setExtGrid_work() {
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
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.1"],
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                WORKDEPT: '${searchVO.gubun}',
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
      WorkSelect: '#WorkSelect',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    WorkSelectClick: WorkSelectClick,
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
        height: grid_height, // 630,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'WorkSelect',
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('WORKERNAME') >= 0 || column.dataIndex.indexOf('CARTYPENAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 100) {
                    column.width = 100;
                  }
                }
                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
      gridarea1 = Ext.create(gridnms["views.list"], {
          renderTo: 'gridArea'
        });
    },
  });
}

function fn_goHome() {
   <%--작업시작 처음 화면으로 넘어감.--%>
  go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goPrevPage() {
  go_url('<c:url value="/prod/process/selectWorkDeptList.do?type=" />' + "${searchVO.type}");
}

function fn_goMovePage(flag) {
  if (flag === 8) {
    go_url('<c:url value="/prod/process/WarehousingRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 10) {
    go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + flag + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 11) {
    go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 12) {
    go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val());
  } else if (flag === 13) {
    go_url('<c:url value="/prod/process/WorkOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else {
    go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
  }
}

function fn_ready() {
  extToastView("준비중입니다...");
  return;
}

function setLovList() {
  //
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
    <!-- 현재위치 네비게이션 시작 -->
    <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
        <div style="width: 100%; padding-left: 0px;">
            <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)">
                <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                <input type="hidden" id="workorderid" name="workorderid" />
                <input type="hidden" id="workorderseq" name="workorderseq" />
                <input type="hidden" id="itemcode" name="itemcode" />
                <input type="hidden" id="routingcode" name="routingcode" />
                <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                <c:choose>
                    <c:when test="${searchVO.work == 'Y'}">
                        <div id="menuArea" style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                             <button type="button" class="white_selected h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                     생산실적<br/>( TOUCH ) -->
<!--                             </button> -->
                            <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                    생산실적<br/>( TOUCH )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                    래핑/연마입력<br/>( RESULT )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                    자주검사<br/>( CHECK SHEET )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                    공구변경<br/>( TOOL CHANGE )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                    외주발주<br/>( ORDER )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                    외주입고<br/>( REGISTER )
                            </button>
                            <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                    반입반출<br/>( STORED & RELEASED )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                    설비변경<br/>( FACILITIES )
                            </button>
                        </div>
                        <div id="logoutArea" style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
                            <button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
                                    나가기<br/>( LOGOUT )
                            </button>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div id="menuArea" style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
                            <button type="button" class="btn_work_home blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">
                                    HOME
                            </button>
                            <button type="button" class="btn_work_prev blue3 h " onclick="fn_goPrevPage( );" style="width: 8%; height: 63px; float: left';">
                                    이전화면<br/>( BACK )
                            </button>
<!--                             <button type="button" class="white_selected h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                     생산실적<br/>( TOUCH ) -->
<!--                             </button> -->
                            <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                    생산실적<br/>( TOUCH )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                    래핑/연마입력<br/>( RESULT )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                    자주검사<br/>( CHECK SHEET )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                    공구변경<br/>( TOOL CHANGE )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                    외주발주<br/>( ORDER )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                    외주입고<br/>( REGISTER )
                            </button>
                            <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                    반입반출<br/>( STORED & RELEASED )
                            </button>
                            <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                    설비변경<br/>( FACILITIES )
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
                <center id="changebuttons" style="width: 100%; margin-bottom: 5px;">
                </center>
                
                <div id="gridArea" style="width: 100%; margin-top: 0px; margin-bottom: 0px; float: left;"></div>
            </form>
        </div>
    </div>
    <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
    <div id="loadingBar" style="display: none;">
        <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading" />
    </div>
</body>
</html>