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

<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/load-image.all.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-process.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-image.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/app.js'/>"></script>

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

.x-form-field {
  font-size: 10px;
}

.ERPQTY  .x-column-header-text {
  margin-right: 0px;
}

#gridPopup1Area .x-form-field {
    ime-mode:disabled;
    text-transform:uppercase;
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

	  $("#gridPopup2Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();
	  setLovList();

	  var inspno = $('#ShipInsNo').val();
	  if (inspno != "") {
	    fn_search();
	  } else {
	    $("#MfgDate").val($('#today').val());
	  }
	});

	function setInitial() {
	  // 최초 상태 설정
	  gridnms["app"] = "quality";

	  calender($('#MfgDate'));

	  $('#MfgDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  $('#ShipQty').keyup(function (event) {

	    if (event.keyCode >= '48' && event.keyCode <= '57') {
	      var shipqty = this.value;
	      var detailqty = $('#DetailQty').val() * 1;

	      if (detailqty < shipqty) {
	        extAlert("검사수량은 출하수량보다 클 수 없습니다.<br/>다시 확인해주세요.");
	        $('#ShipQty').val("");
	        return;
	      }
	    }
	  });

	  $('#FaultQty').keyup(function (event) {
	    if (event.keyCode >= '48' && event.keyCode <= '57') {
	      var faultqty = this.value;
	      var shipqty = $('#ShipQty').val() * 1;

	      if (shipqty < faultqty) {
	        extAlert("불량수량은 검사수량보다 클 수 없습니다.<br/>다시 확인해주세요.");
	        $('#FaultQty').val("");
	        $('#PassQty').val("");
	        return;
	      }

	      var passqty = shipqty - faultqty;
	      $('#PassQty').val(passqty);
	    }
	  });
	  var groupid = "${searchVO.groupId}";

	  switch (groupid) {
	  case "ROLE_ADMIN":
	    // 관리자 권한일 때 그냥 놔둠
	    break;
	  default:
	    // 관리자 외 권한일 때 사용자명 표기
	    $('#KrName').val("${searchVO.KRNAME}");
	    $('#PersonId').val("${searchVO.EMPLOYEENUMBER}");
	    break;
	  }
	}

	var colIdx = 0, rowIdx = 0;
	var gridnms = {};
	var fields = {};
	var items = {};
	var comboboxEmpty1 = '<span style="height: 40px; font-size: 15px; font-weight: bold;">&nbsp;데이터가 없습니다. 관리자에게 문의하십시오.</span>';
	var comboboxOption1 = '<div>'
	   + '<table>'
	   + '<tr>'
	   + '<td style="height: 40px; font-size: 15px; font-weight: bold;">{LABEL}</td>'
	   + '</tr>' + '</table>' + '</div>';
	var comboboxEmpty2 = '<span style="height: 40px; font-size: 15px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>';
	var comboboxOption2 = '<div style="height: auto; overflow: auto; display:block;">'
	   + '<ul>'
	   + '<li style="height: 40px; font-size: 15px; font-weight: bold; padding-top: 13px;">'
	   + '{LABEL}' + '</li>' + '</ul>' + '</div>';
	function setValues() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.1"] = "ShipmentInspDetail";
	  gridnms["grid.2"] = "okngLov"; // 검사값
	  gridnms["grid.3"] = "checkynLov"; // 판정

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.detail"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.detail"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
	  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
	  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	  gridnms["models.detail"].push(gridnms["model.1"]);
	  gridnms["models.detail"].push(gridnms["model.2"]);
	  gridnms["models.detail"].push(gridnms["model.3"]);

	  gridnms["stores.detail"].push(gridnms["store.1"]);
	  gridnms["stores.detail"].push(gridnms["store.2"]);
	  gridnms["stores.detail"].push(gridnms["store.3"]);

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
	      name: 'SHIPINSNO',
	    }, {
	      type: 'string',
	      name: 'SHIPINSPECTIONNO',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'number',
	      name: 'CHECKLISTID',
	    }, {
	      type: 'number',
	      name: 'ORDERNO',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLE',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALL',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALLNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKUOM',
	    }, {
	      type: 'string',
	      name: 'CHECKUOMNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE',
	    }, {
	      type: 'string',
	      name: 'MAXVALUE',
	    }, {
	      type: 'string',
	      name: 'MINVALUE',
	    }, {
	      type: 'string',
	      name: 'EXTSTANDARD',
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
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'CHECKYNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'PERSONID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'MANAGEEMPLOYEE',
	    }, {
	      type: 'string',
	      name: 'MANAGENAME',
	    }, ];

	  fields["model.2"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.3"] = [{
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
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },

	    }, {
	      dataIndex: 'CHECKMIDDLENAME',
	      text: '검사항목분류',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'CHECKSMALLNAME',
	      text: '검사항목',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'CHECKUOMNAME',
	      text: '검사단위',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'CHECKSTANDARD',
	      text: '검사내용',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'STANDARDVALUE',
	      text: '검사기준',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'MINVALUE',
	      text: '허용치(하한)',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '허용치(상한)',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'EXTSTANDARD',
	      text: '규정',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //        editor: {
	      //          xtype: 'textfield',
	      //          editable: false,
	      //          enableKeyEvents: true,
	      //          listeners: {
	      //            specialkey: function (field, e) {
	      //              if (e.keyCode === 38) {
	      //                // 위
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //              if (e.keyCode === 40) {
	      //                // 아래
	      //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	      //                rowIdx = selModel.getCurrentPosition().row;
	      //                colIdx = selModel.getCurrentPosition().column;

	      //                // 레코드별로 리스트 값이 변하는 경우 추가
	      //                fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	      //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	      //              }
	      //            },
	      //          },
	      //        },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'CHECKRESULT1',
	      text: 'X1',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x1',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '1');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {

	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '1');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 0 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x1');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x1');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x1');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT2',
	      text: 'X2',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x2',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '2');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '2');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 1 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x2');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x2');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x2');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT3',
	      text: 'X3',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x3',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '3');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '3');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 2 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x3');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x3');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x3');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT4',
	      text: 'X4',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x4',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '4');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '4');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 3 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x4');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x4');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x4');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT5',
	      text: 'X5',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x5',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '5');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '5');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 4 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x5');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x5');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x5');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT6',
	      text: 'X6',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x6',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '6');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '6');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 5 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x6');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x6');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x6');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT7',
	      text: 'X7',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x7',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '7');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '7');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 6 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x7');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x7');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x7');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT8',
	      text: 'X8',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x8',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '8');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '8');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 7 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x8');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x8');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x8');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT9',
	      text: 'X9',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x9',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '9');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '9');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 8 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x9');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x9');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x9');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT10',
	      text: 'X10',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      tdCls: 'x10',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'remote',
	        allowBlank: true,
	        transform: 'stateSelect',
	        listeners: {
	          select: function (field, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            var value = field.getValue();

	            fn_ext_check_column(model.data, selectedRow, value, '10');
	          },
	          specialkey: function (field, e) {
	            if (e.keyCode === 13 || e.keyCode === 9) {
	              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	              var value = field.getValue();

	              fn_ext_check_column(model.data, selectedRow, value, '10');
	            }
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: comboboxEmpty2,
	          width: 200,
	          getInnerTpl: function () {
	            return comboboxOption2;
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(250, 227, 125);";
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE;
	        var min = record.data.MINVALUE;
	        var checkqty = record.data.CHECKQTY * 1; // 시료수
	        var qty_check = false;

	        if (checkqty > 9 && checkqty <= 10) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = "background-color:rgb(234,234,234);";
	          meta.style += " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              setcolor('x10');
	              return value;
	            } else {
	              setcolor(clearInterval());
	              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	              meta.style += " border-color: #5B9BD5;";
	              meta.style += " border-left-style: solid;";
	              meta.style += " border-left-width: 1px;";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              setcolor('x10');
	              return value;
	            } else {
	              if (num > max) {
	                setcolor('x10');
	                return value;
	              } else {
	                setcolor(clearInterval());
	                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
	                meta.style += " border-color: #5B9BD5;";
	                meta.style += " border-left-style: solid;";
	                meta.style += " border-left-width: 1px;";
	                return value;
	              }
	            }
	          }
	        }
	      },
	      //      }, {
	      //        dataIndex: 'CHECKYNNAME',
	      //        text: '판정',
	      //        xtype: 'gridcolumn',
	      //        width: 80,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        editor: {
	      //          xtype: 'combobox',
	      //          store: gridnms["store.3"],
	      //          valueField: "LABEL",
	      //          displayField: "LABEL",
	      //          matchFieldWidth: true,
	      //          editable: false,
	      //          queryParam: 'keyword',
	      //          queryMode: 'remote', // 'local',
	      //          allowBlank: true,
	      //          typeAhead: true,
	      //          transform: 'stateSelect',
	      //          forceSelection: true,
	      //          listeners: {
	      //            select: function (value, record, eOpts) {
	      //              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

	      //              model.set("CHECKYN", record.data.VALUE);
	      //            },
	      //          },
	      //          listConfig: {
	      //            loadingText: '검색 중...',
	      //            emptyText: comboboxEmpty1,
	      //            width: 200,
	      //            getInnerTpl: function () {
	      //              return comboboxOption1;
	      //            }
	      //          },
	      //        },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 320,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	        listeners: {
	          specialkey: function (field, e) {
	            if (e.keyCode === 38) {
	              // 위
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	            if (e.keyCode === 40) {
	              // 아래
	              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
	              rowIdx = selModel.getCurrentPosition().row;
	              colIdx = selModel.getCurrentPosition().column;

	              // 레코드별로 리스트 값이 변하는 경우 추가
	              fn_combobox_refresh("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, gridnms["store.2"]);

	              fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
	            }
	          },
	        },
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
	      dataIndex: 'SHIPINSNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPINSPECTIONNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKLISTID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKSMALL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKUOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'PERSONID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'KRNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MANAGEEMPLOYEE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MANAGENAME',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/quality/ship/ShipmentInspDetail.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/quality/ship/ShipmentInspDetail.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#inspectionDetailList": {
	      itemclick: 'inspectionSelectClick'
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

	function btnDel1() {
	  // Detail 삭제
	  var store = this.getStore(gridnms["store.1"]);
	  var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
	  var inspno = $('#ShipInsNo').val();
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();

	  if (record === undefined) {
	    return;
	  }

	  Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      store.remove(record);
	      Ext.getStore(gridnms["store.1"]).sync({
	        success: function (batch, options) {
	          var reader = batch.proxy.getReader();

	          msg = reader.rawData.msg;
	          extAlert(msg);

	          //            setInterval(function () {
	          go_url("<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + inspno + "&org=" + orgid + "&company=" + companyid);
	          //            }, 1 * 0.5 * 1000);
	        },
	        failure: function (batch, options) {
	          var reader = batch.proxy.getReader();
	          msg = reader.rawData.msg;
	          extAlert(msg);
	        },
	        callback: function (batch, options) {},
	      });
	    }
	  });
	}

	function inspectionSelectClick(dataview, record, item, index, e, eOpts) {
	  var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	  var standardvalue = model.data.STANDARDVALUE;
	  var sparams = {};

	  if (standardvalue === "") {
	    // 검사기준값이 없으면 OK / NG 표시 될 수 있도록 변경
	    sparams = {
	      "BIGCD": "APP" + "",
	      "MIDDLECD": "유해한 결함 없을 것" + "",
	    };
	  } else {
	    sparams = {
	      "BIGCD": "APP" + "",
	      "MIDDLECD": "!@#$%" + "", // OK / NG 표시되지 않는 항목은 쓰레기 값을 넣어 조회가 되지 않도록한다.
	    };
	  }

	  extGridSearch(sparams, gridnms["store.2"]);
	};

	function fn_combobox_refresh(arrownm, storenm, viewnm, rowindex, listnm) {
	  var row_temp = 0;
	  switch (arrownm) {
	  case "UP":
	    row_temp = rowindex - 1;
	    break;
	  case "DOWN":
	    row_temp = rowindex + 1;
	    break;
	  case "LEFT":
	    row_temp = rowindex;
	    break;
	  case "RIGHT":
	    row_temp = rowindex;
	    break;
	  default:
	    break;
	  }

	  Ext.getStore(storenm).getById(Ext.getCmp(viewnm).getSelectionModel().select(row_temp));
	  var model = Ext.getCmp(viewnm).selModel.getSelection()[0];

	  var standardvalue = model.data.STANDARDVALUE;
	  var sparams = {};

	  if (standardvalue === "") {
	    // 검사기준값이 없으면 OK / NG 표시 될 수 있도록 변경
	    sparams = {
	      "BIGCD": "APP" + "",
	      "MIDDLECD": "유해한 결함 없을 것" + "",
	    };
	  } else {
	    sparams = {
	      "BIGCD": "APP" + "",
	      "MIDDLECD": "!@#$%" + "", // OK / NG 표시되지 않는 항목은 쓰레기 값을 넣어 조회가 되지 않도록한다.
	    };
	  }

	  extGridSearch(sparams, listnm);
	}

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"]
	  });

	  Ext.define(gridnms["model.3"], {
	    extend: Ext.data.Model,
	    fields: fields["model.3"]
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
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
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
	              type: "ajax",
	              url: "<c:url value='/searchDummyOKNGLov.do' />",
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
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
	              type: "ajax",
	              url: "<c:url value='/searchDummyOKNG2Lov.do' />",
	              extraParams: {
	                PARAM1: '합격',
	                PARAM2: '불합격',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      inspectionDetailList: '#inspectionDetailList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnDel1: btnDel1,
	    inspectionSelectClick: inspectionSelectClick,
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
	        height: 524,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'inspectionDetailList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CHECKMIDDLENAME') >= 0 || column.dataIndex.indexOf('CHECKSMALLNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 100) {
	                    column.width = 100;
	                  }
	                }

	                if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0 || column.dataIndex.indexOf('EXTSTANDARD') >= 0) {
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
	              beforeedit: function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var params = {};
	                var editDisableCols = [];

	                var checkqty = data.data.CHECKQTY * 1;

	                switch (checkqty) {
	                case 1:
	                  editDisableCols.push("CHECKRESULT2");
	                  editDisableCols.push("CHECKRESULT3");
	                  editDisableCols.push("CHECKRESULT4");
	                  editDisableCols.push("CHECKRESULT5");
	                  editDisableCols.push("CHECKRESULT6");
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 2:
	                  editDisableCols.push("CHECKRESULT3");
	                  editDisableCols.push("CHECKRESULT4");
	                  editDisableCols.push("CHECKRESULT5");
	                  editDisableCols.push("CHECKRESULT6");
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 3:
	                  editDisableCols.push("CHECKRESULT4");
	                  editDisableCols.push("CHECKRESULT5");
	                  editDisableCols.push("CHECKRESULT6");
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 4:
	                  editDisableCols.push("CHECKRESULT5");
	                  editDisableCols.push("CHECKRESULT6");
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 5:
	                  editDisableCols.push("CHECKRESULT6");
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 6:
	                  editDisableCols.push("CHECKRESULT7");
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 7:
	                  editDisableCols.push("CHECKRESULT8");
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 8:
	                  editDisableCols.push("CHECKRESULT9");
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                case 9:
	                  editDisableCols.push("CHECKRESULT10");
	                  break;
	                default:
	                  break;
	                }
	                var isNew = ctx.record.phantom || false;
	                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
	                  return false;
	                else {
	                  return true;
	                }
	              },
	            },
	          }
	        ],
	        dockedItems: items["docked.1"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	// 출하 대기 LIST 불러오기 팝업
	function setValues_Popup() {
	  gridnms["models.popup1"] = [];
	  gridnms["stores.popup1"] = [];
	  gridnms["views.popup1"] = [];
	  gridnms["controllers.popup1"] = [];

	  gridnms["models.popup2"] = [];
	  gridnms["stores.popup2"] = [];
	  gridnms["views.popup2"] = [];
	  gridnms["controllers.popup2"] = [];

	  gridnms["grid.4"] = "Popup1";

	  gridnms["grid.44"] = "Popup2"; // 입고검사 세부 항목 LIST

	  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
	  gridnms["views.popup1"].push(gridnms["panel.4"]);

	  gridnms["panel.44"] = gridnms["app"] + ".view." + gridnms["grid.44"];
	  gridnms["views.popup2"].push(gridnms["panel.44"]);

	  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
	  gridnms["controllers.popup1"].push(gridnms["controller.4"]);

	  gridnms["controller.44"] = gridnms["app"] + ".controller." + gridnms["grid.44"];
	  gridnms["controllers.popup2"].push(gridnms["controller.44"]);

	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

	  gridnms["model.44"] = gridnms["app"] + ".model." + gridnms["grid.44"];

	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

	  gridnms["store.44"] = gridnms["app"] + ".store." + gridnms["grid.44"];

	  gridnms["models.popup1"].push(gridnms["model.4"]);

	  gridnms["models.popup2"].push(gridnms["model.44"]);

	  gridnms["stores.popup1"].push(gridnms["store.4"]);

	  gridnms["stores.popup2"].push(gridnms["store.44"]);

	  fields["model.4"] = [{
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
	      name: 'SHIPNO',
	    }, {
	      type: 'string',
	      name: 'SHIPSEQ',
	    }, {
	      type: 'string',
	      name: 'SHIPDATE',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'number',
	      name: 'CONFIRMQTY',
	    }, {
	      type: 'number',
	      name: 'CHECKQTY',
	    }, {
	      type: 'string',
	      name: 'LOTNOVISUAL',
	    }, ];

	  fields["columns.4"] = [{
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
	      dataIndex: 'SHIPNO',
	      text: '출하번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'SHIPSEQ',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하일',
	      xtype: 'datecolumn',
	      width: 100,
	      hidden: false,
	      sortable: true,
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CHECKQTY',
	      text: '기출하수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CHECKREMAINQTY',
	      text: '검사수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      menuDisabled: true,
	      sortable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      width: 70,
	      text: '적용',
	      style: 'text-align:center',
	      align: "center",
	      resizable: false,
	      widget: {
	        xtype: 'button',
	        _btnText: "적용",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          var OrgIdVal = record.data.ORGID;
	          var CompanyIdVal = record.data.COMPANYID;
	          var ItemCodeVal = record.data.ITEMCODE;

	          var params = {
	            ORGID: OrgIdVal,
	            COMPANYID: CompanyIdVal,
	            ITEMCODE: ItemCodeVal,
	            CHECKBIG: $('#popupCheckBig').val(),
	          };

	          extGridSearch(params, gridnms["store.44"]);

	          setTimeout(function () {

	            // 전체등록 Pop up 적용 버튼 핸들러
	            var count4 = Ext.getStore(gridnms["store.4"]).count();
	            var checknum = 0,
	            checkqty = 0,
	            checktemp = 0;
	            var qtytemp = [];

	            if (count4 == 0) {
	              console.log("[적용] 출하검사 정보가 없습니다.");
	            } else {
	              $('#ShipNo').val(record.data.SHIPNO);
	              $('#ShipSeq').val(record.data.SHIPSEQ);
	              $('#CustomerName').val(record.data.CUSTOMERNAME);
	              $('#CustomerCode').val(record.data.CUSTOMERCODE);
	              $('#ItemCode').val(record.data.ITEMCODE);
	              $('#OrderName').val(record.data.ORDERNAME);
	              $('#ItemName').val(record.data.ITEMNAME);
	              $('#DrawingNo').val(record.data.DRAWINGNO);
	              $('#DetailQty').val(record.data.SHIPQTY);
	              $('#MfgNo').val(record.data.LOTNOVISUAL);

	              checktemp++;
	              popcount++;
	              //아래 부분은 검사세부 정보 loop 형태로 변경
	              //전체등록 Pop up 적용 버튼 핸들러
	              var count = Ext.getStore(gridnms["store.1"]).count();
	              var count44 = Ext.getStore(gridnms["store.44"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count44; i++) {
	                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
	                var model44 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
	                var chk = true;

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("해당 제품에 대해서 품질기준 마스터가 등록 되어있지 않습니다. <br/>해당 제품의 품질기준 정보를 다시 확인해주십시오.");
	                return false;
	              }

	              if (count44 == 0) {
	                console.log("[적용] 제품 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count44; j++) {
	                  Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(j));
	                  var model44 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
	                  var chk = true; //model44.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.1"]);
	                    var store = Ext.getStore(gridnms["store.1"]);

	                    // 순번
	                    model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("CHECKLISTID", model44.data.CHECKSEQ);
	                    model.set("CHECKUOM", model44.data.UOM);
	                    model.set("CHECKUOMNAME", model44.data.UOMNAME);
	                    model.set("CHECKBIG", model44.data.CHECKBIG);
	                    model.set("CHECKBIGNAME", model44.data.CHECKBIGNAME);
	                    model.set("CHECKMIDDLE", model44.data.CHECKMIDDLE);
	                    model.set("CHECKMIDDLENAME", model44.data.CHECKMIDDLENAME);
	                    model.set("CHECKSMALL", model44.data.CHECKSMALL);
	                    model.set("CHECKSMALLNAME", model44.data.CHECKSMALLNAME);
	                    model.set("CHECKSTANDARD", model44.data.CHECKSTANDARD);
	                    model.set("STANDARDVALUE", model44.data.STANDARDVALUE);
	                    model.set("MINVALUE", model44.data.MINVALUE);
	                    model.set("MAXVALUE", model44.data.MAXVALUE);
	                    model.set("EXTSTANDARD", model44.data.EXTSTANDARD);
	                    model.set("CHECKQTY", model44.data.CHECKQTY);
	                    model.set("ITEMCODE", model44.data.ITEMCODE);

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
	                win1.close();

	                $("#gridPopup1Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	                $("#gridPopup2Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	              // 여기까지 부분은 검사세부 정보 loop 형태로 변경
	            }

	            if (checktemp > 0) {
	              popcount = 0;
	              win1.close();

	              $("#gridPopup1Area").hide("blind", {
	                direction: "up"
	              }, "fast");
	              $("#gridPopup2Area").hide("blind", {
	                direction: "up"
	              }, "fast");

	            }
	          }, 300);
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
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOMNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LOTNOVISUAL',
	      xtype: 'hidden',
	    }, ];

	  fields["model.44"] = [{
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
	      name: 'CHECKSEQ',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'CHECKBIG',
	    }, {
	      type: 'string',
	      name: 'CHECKBIGNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLE',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALL',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALLNAME',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE',
	    }, {
	      type: 'string',
	      name: 'MINVALUE',
	    }, {
	      type: 'string',
	      name: 'MAXVALUE',
	    }, {
	      type: 'string',
	      name: 'EXTSTANDARD',
	    },
	  ];

	  fields["columns.44"] = [{
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 45,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      align: "center",
	    }, {
	      dataIndex: 'CHECKBIGNAME',
	      text: '검사구분',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKMIDDLENAME',
	      text: '검사분류',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSMALLNAME',
	      text: '검사항목',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '검사단위',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'CHECKSTANDARD',
	      text: '검사내용',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      align: "center",
	    }, {
	      dataIndex: 'STANDARDVALUE',
	      text: '검사기준',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'MINVALUE',
	      text: '허용치(하한)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '허용치(상한)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      style: 'text-align:center;',
	      align: "left",
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
	      dataIndex: 'CHECKBIG',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKSMALL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EXTSTANDARD',
	      xtype: 'hidden',
	    }, ];

	  items["api.4"] = {};
	  $.extend(items["api.4"], {
	    read: "<c:url value='/select/quality/ship/ShipmentInspPopup.do' />"
	  });

	  items["btns.4"] = [];

	  items["btns.ctr.4"] = {};
	  $.extend(items["btns.ctr.4"], {
	    "#btnPopup1": {
	      itemclick: 'onMypopClick'
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

	  items["api.44"] = {};
	  $.extend(items["api.44"], {
	    read: "<c:url value='/searchCheckMasterListLov.do' />"
	  });

	  items["btns.44"] = [];

	  items["btns.ctr.44"] = {};

	  items["dock.paging.44"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.44"],
	  };

	  items["dock.btn.44"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.44"],
	    items: items["btns.44"],
	  };

	  items["docked.44"] = [];
	}

	function onMypopClick(dataview, record, item, index, e, eOpts) {
	  $('#popupOrgId').val(record.data.ORGID);
	  $('#popupCompanyId').val(record.data.COMPANYID);
	  $("#popupItemCode").val(record.data.ITEMCODE);
	  var orgid = $('#popupOrgId').val();
	  var companyid = $('#popupCompanyId').val();
	  var itemcode = $('#popupItemCode').val();

	  var params = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    ITEMCODE: itemcode,
	  };

	  extGridSearch(params, gridnms["store.44"]);
	}

	var gridpopup1;
	function setExtGrid_Popup() {

	  Ext.define(gridnms["model.4"], {
	    extend: Ext.data.Model,
	    fields: fields["model.4"],
	  });

	  Ext.define(gridnms["model.44"], {
	    extend: Ext.data.Model,
	    fields: fields["model.44"],
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.4"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.44"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.44"],
	            model: gridnms["model.44"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.44"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                ITEMCODE: 'Z'
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.4"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup1: '#btnPopup1',
	    },
	    stores: [gridnms["store.4"]],
	    control: items["btns.ctr.4"],
	    onMypopClick: onMypopClick,
	  });

	  Ext.define(gridnms["controller.44"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup2: '#btnPopup2',
	    },
	    stores: [gridnms["store.44"]],
	    control: items["btns.ctr.44"],
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
	        columns: fields["columns.4"],
	        viewConfig: {
	          itemId: 'btnPopup1',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.4"],
	      }
	    ],
	  });

	  Ext.define(gridnms["panel.44"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.44"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.44"],
	        id: gridnms["panel.44"],
	        store: gridnms["store.44"],
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
	        columns: fields["columns.44"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'btnPopup2',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.44"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup1"],
	    stores: gridnms["stores.popup1"],
	    views: gridnms["views.popup1"],
	    controllers: gridnms["controller.4"],

	    launch: function () {
	      gridpopup1 = Ext.create(gridnms["views.popup1"], {
	          renderTo: 'gridPopup1Area'
	        });
	    },
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup2"],
	    stores: gridnms["stores.popup2"],
	    views: gridnms["views.popup2"],
	    controllers: gridnms["controller.44"],

	    launch: function () {
	      gridpopup2 = Ext.create(gridnms["views.popup2"], {
	          renderTo: 'gridPopup2Area'
	        });
	    },
	  });
	}

	var popcount = 0, popupclick = 0;
	// 검사 대기 LIST
	function btnSel1(btn) {
	  var ShipInsNo = $('#ShipInsNo').val();
	  var ItemCode = $('#ItemCode').val();
	  var ItemName = $('#ItemName').val();
	  var MfgDate = $('#MfgDate').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (ShipInsNo !== "") {
	    header.push("출하검사번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 되어져 있습니다. 새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
	    return false;
	  }

	  if (ItemCode !== "") {
	    header.push(ItemName);
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 중입니다. 새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
	    return false;
	  }

	  // 출하검사 대기 LIST 불러오기 팝업
	  var width = 1308; // 가로
	  var height = 640; // 세로
	  var title = "출하검사 대기 LIST Popup";

	  var check = true;

	  popupclick = 0;
	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupFrom').val("");
	    $('#popupTo').val("");
	    $('#popupItemCode').val("");
	    //      $('#popupCheckBig').val("O");
	    Ext.getStore(gridnms['store.4']).removeAll();

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
	            itemId: gridnms["panel.4"],
	            id: gridnms["panel.4"],
	            store: gridnms["store.4"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.4"],
	            defaults: gridVals.defaultField,
	            viewConfig: {
	              itemId: 'btnPopup1'
	            },
	            plugins: 'bufferedrenderer',
	            dockedItems: items["docked.4"],
	          }
	        ],
	        tbar: [
	          '기간', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            align: 'center',
	            width: 110,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {

	                  if (result === "") {
	                    $('#popupFrom').val("");
	                  } else {
	                    var popupFrom = Ext.Date.format(result, 'Y-m-d');
	                    var popupTo = $('#popupTo').val();

	                    if (popupTo === "") {
	                      $('#popupFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupFrom, popupTo);
	                      if (diff < 0) {
	                        extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupFrom').val("");
	                        return;
	                      } else {
	                        $('#popupFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          }, ' ~ ', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            width: 110,
	            align: 'center',
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {

	                  if (result === "") {
	                    $('#popupTo').val("");
	                  } else {
	                    var popupFrom = $('#popupFrom').val();
	                    var popupTo = Ext.Date.format(result, 'Y-m-d');

	                    if (popupFrom === "") {
	                      $('#popupTo').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupFrom, popupTo);
	                      if (diff < 0) {
	                        extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupTo').val("");
	                        return;
	                      } else {
	                        $('#popupTo').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          },
	          '품번', {
	            xtype: 'textfield',
	            name: 'searchOrderName',
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
	            name: 'searchItemName',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 250,
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
	          }, '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                SEARCHFROM: $('#popupFrom').val(),
	                SEARCHTO: $('#popupTo').val(),
	                ITEMCODE: $('#popupItemCode').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ORDERNAME: $('#popupOrderName').val(),
	                POPGUBUN: 'POPUP',
	              };

	              extGridSearch(sparams3, gridnms["store.4"]);
	            }
	          },
	        ]
	      });

	    win1.show();

	  } else {
	    extAlert("출하 검사등록 하실 경우에만 출하검사 대기 LIST 불러오기가 가능합니다.");
	    return;
	  }
	}

	// 종합판정 Function
	function fn_check_result() {
	  var count = Ext.getStore(gridnms["store.1"]).count();
	  var chk_count = 0;
	  var result_check = false;

	  for (var i = 0; i < count; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
	    var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
	    var checkyn = model1.data.CHECKYN;

	    var X1 = model1.data.CHECKRESULT1;
	    var X2 = model1.data.CHECKRESULT2;
	    var X3 = model1.data.CHECKRESULT3;
	    var X4 = model1.data.CHECKRESULT4;
	    var X5 = model1.data.CHECKRESULT5;
	    var X6 = model1.data.CHECKRESULT6;
	    var X7 = model1.data.CHECKRESULT7;
	    var X8 = model1.data.CHECKRESULT8;
	    var X9 = model1.data.CHECKRESULT9;
	    var X10 = model1.data.CHECKRESULT10;
	    var max = model1.data.MAXVALUE;
	    var min = model1.data.MINVALUE;
	    var standardvalue = model1.data.STANDARDVALUE;

	    var checkqty = model1.data.CHECKQTY * 1;

	    var xList = fn_push_list(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, checkqty);

	    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);

	    if (result_check == true) {
	      model1.set('CHECKYNNAME', 'OK');
	      model1.set('CHECKYN', 'OK');
	    } else {
	      model1.set('CHECKYNNAME', 'NG');
	      model1.set('CHECKYN', 'NG');
	      chk_count++;
	    }
	  }

	  // 판정 값 중 하나라도 NG가 있을 경우 불합격
	  if (chk_count > 0) {
	    var checkqty = $("#DetailQty").val();
	    var passqty = 0;
	    var failqty = checkqty;
	    $("#CheckYn").val('NG');
	    $("#CheckYnName").val('NG');
	    $("#ShipQty").val(checkqty);
	    $("#PassQty").val(passqty);
	    $("#FaultQty").val(failqty);
	  } else {
	    var checkqty = $("#DetailQty").val();
	    var passqty = checkqty;
	    var failqty = 0;
	    $("#CheckYn").val('OK');
	    $("#CheckYnName").val('OK');
	    $("#ShipQty").val(checkqty);
	    $("#PassQty").val(passqty);
	    $("#FaultQty").val(failqty);
	  }
	}

	// 종합판정 Function
	function fn_check_result2(flag) {
	  // 판정 값 중 하나라도 NG가 있을 경우 불합격

	  var check_yn = $("#CheckYnName").val();
	  var check_qty = $("#ShipQty").val();
	  if (check_yn == "OK") {
	    var passqty = check_qty;
	    var failqty = 0;
	    $("#PassQty").val(passqty);
	    $("#FaultQty").val(failqty);
	    $("#CheckYn").val(check_yn);
	  } else {
	    var passqty = 0;
	    var failqty = check_qty;
	    $("#PassQty").val(passqty);
	    $("#FaultQty").val(failqty);
	    $("#CheckYn").val(check_yn);
	  }
	}

	function fn_push_list(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, qty) {
	  // 리스트 생성
	  var list = [];
	  switch (qty) {
	  case 1:
	    list.push(X1);
	    break;
	  case 2:
	    list.push(X1);
	    list.push(X2);
	    break;
	  case 3:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    break;
	  case 4:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    break;
	  case 5:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    break;
	  case 6:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    list.push(X6);
	    break;
	  case 7:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    list.push(X6);
	    list.push(X7);
	    break;
	  case 8:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    list.push(X6);
	    list.push(X7);
	    list.push(X8);
	    break;
	  case 9:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    list.push(X6);
	    list.push(X7);
	    list.push(X8);
	    list.push(X9);
	    break;
	  case 10:
	    list.push(X1);
	    list.push(X2);
	    list.push(X3);
	    list.push(X4);
	    list.push(X5);
	    list.push(X6);
	    list.push(X7);
	    list.push(X8);
	    list.push(X9);
	    list.push(X10);
	    break;
	  default:
	    break;
	  }
	  return list;
	}

	function fn_defact_check(list, num, max, min, svalue) {
	  // 합/불 판정
	  var result = true,
	  isCheck = false,
	  count = 0;
	  var max_num = max * 1;
	  var min_num = min * 1;
	  for (var i = 0; i < num; i++) {
	    var value = list[i];
	    // 입력된 값이 아니면 패스
	    if (value.length > 0) {
	      if (svalue == "") {
	        if (value == "OK") {
	          // 합격
	          isCheck = true;
	        } else if (value == "NG") {
	          // 불합격
	          isCheck = false;
	        }
	      } else {
	        var value_num = value * 1;
	        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
	        if (regexp.test(value)) {
	          // 합격
	          if (min_num > value_num) {
	            isCheck = false;
	          } else {
	            if (value_num > max_num) {
	              isCheck = false;
	            } else {
	              isCheck = true;
	            }
	          }
	        } else {
	          // 불합격
	          isCheck = false;
	        }
	      }

	      // 불합격 판정 받았을 경우에만 불합격 처리되도록
	      if (isCheck == false) {
	        result = false;
	      }
	      count++;
	    } else {
	      // 2016.03.14 검사값 입력시 불합격 표시부분 주석 처리
	      //             result = true;
	    }
	  }

	  return result;
	}

	function setcolor(x) {
	  // 불합격 판정시 글자 깜빡임 스크립터
	  var count = 1;
	  if (x == 'x1') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x1').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x1').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x2') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x2').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x2').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x3') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x3').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x3').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x4') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x4').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x4').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x5') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x5').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x5').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x6') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x6').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x6').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x7') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x7').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x7').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x8') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x8').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x8').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x9') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x9').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x9').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'x10') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.x10').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.x10').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  } else if (x == 'checkynnm') {
	    setInterval(function () {
	      if (count == 1) {
	        $('.checkynnm').css("color", "rgb(255,0,0)");

	        count = 2
	      } else {
	        $('.checkynnm').css("color", "rgb(0,0,255)");
	        count = 1
	      }
	    }, 500);
	  }
	}

	function fn_ext_check_column(record, rowindex, val, col) {
	  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(rowindex));
	  var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	  var max = record.MAXVALUE;
	  var min = record.MINVALUE;
	  var standardvalue = record.STANDARDVALUE; // 검사기준값
	  var checkqty = record.CHECKQTY * 1; // 시료수
	  var qty_check = false; // 시료수 체크
	  var input_check = false; // 입력 / 미입력 체크
	  var msg = "",
	  result_check = false;
	  var chk_count = 0;

	  // 검사 값
	  var X1 = (col == '1') ? val : record.CHECKRESULT1,
	  X2 = (col == '2') ? val : record.CHECKRESULT2,
	  X3 = (col == '3') ? val : record.CHECKRESULT3,
	  X4 = (col == '4') ? val : record.CHECKRESULT4,
	  X5 = (col == '5') ? val : record.CHECKRESULT5,
	  X6 = (col == '6') ? val : record.CHECKRESULT6,
	  X7 = (col == '7') ? val : record.CHECKRESULT7,
	  X8 = (col == '8') ? val : record.CHECKRESULT8,
	  X9 = (col == '9') ? val : record.CHECKRESULT9,
	  X10 = (col == '10') ? val : record.CHECKRESULT10;

	  // 1. 시료수 범위 체크
	  if (checkqty > ((col * 1) - 1) && checkqty <= 10) {
	    msg = "입력이 가능합니다.";
	    qty_check = true;
	  } else {
	    msg = "작업지시수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
	    qty_check = false;
	  }

	  // 2. 입력 가능 / 불가 체크
	  if (qty_check == true) {
	    // 2-1. 입력되어있는지 유무 확인
	    // 입력되어있을 경우에만 판정이 변경되도록 변경
	    var result = (val == null) ? "" : val;
	    if (result.length > 0) {
	      input_check = true;
	    } else {
	      input_check = false;
	    }

	    // 입력이 되어있으면
	    if (input_check == true) {

	      // 리스트 생성 함수 호출
	      var xList = fn_push_list(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, checkqty);
	      if (standardvalue === "") {
	        if (val == "OK" || val == "NG") {}
	        else {
	          extAlert("OK/NG 중에 하나를 입력해주십시오!");
	          model1.set("CHECKRESULT" + col + "", "");
	          //           model1.set("CHECKTIME" + col + "", "");
	          //           model1.set("CHECKRESULTNG" + col + "", "");
	          return false;
	        }
	      } else {
	        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
	        if (!regexp.test(val)) {
	          // 숫자가 아닌 값을 입력시
	          extAlert("입력하신 값이 숫자가 아닙니다!");
	          model1.set("CHECKRESULT" + col + "", "");
	          //           model1.set("CHECKTIME" + col + "", "");
	          //           model1.set("CHECKRESULTNG" + col + "", "");
	          return false;
	        }
	      }

	      // 판정결과
	      result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);

	      if (result_check == true) {
	        model1.set('CHECKYNNAME', 'OK');
	        model1.set('CHECKYN', 'OK');
	        model1.set("CHECKRESULTNG" + col + "", "");
	      } else {
	        model1.set('CHECKYNNAME', 'NG');
	        model1.set('CHECKYN', 'NG');
	        chk_count++;
	      }

	      //       var todate = new Date();
	      //       var today = Ext.util.Format.date(todate, 'Y-m-d H:i');
	      //       model1.set("CHECKTIME" + col + "", today);

	      // 판정 값 중 하나라도 NG가 있을 경우 불합격
	      if (chk_count > 0) {
	        var checkqty = $("#DetailQty").val();
	        var passqty = 0;
	        var failqty = checkqty;
	        $("#CheckYn").val('NG');
	        $("#CheckYnName").val('NG');
	        $("#ShipQty").val(checkqty);
	        $("#PassQty").val(passqty);
	        $("#FaultQty").val(failqty);
	      } else {
	        var checkqty = $("#DetailQty").val();
	        var passqty = checkqty;
	        var failqty = 0;
	        $("#CheckYn").val('OK');
	        $("#CheckYnName").val('OK');
	        $("#ShipQty").val(checkqty);
	        $("#PassQty").val(passqty);
	        $("#FaultQty").val(failqty);
	      }

	      return true;
	    } else {
	      // 미입력시 메시지 안띄우고 그냥 넘어감
	      return true;
	    }
	  } else {
	    // 시료수량 미등록 또는 범위 초과시 메시지 발생
	    extAlert(msg);
	    model1.set("CHECKRESULT" + col + "", "");
	    //     model1.set("CHECKTIME" + col + "", "");
	    //     model1.set("CHECKRESULTNG" + col + "", "");
	    return false;
	  }
	}

	function fn_save() {
	  var MfgDate = $('#MfgDate').val();
	  var ShipNo = $('#ShipNo').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (MfgDate === "") {
	    header.push("검사일");
	    count++;
	  }

	  if (ShipNo === "") {
	    header.push("출하번호/순번");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return false;
	  }

	  fn_check_result();

	  // 저장
	  var ShipInsNo = $('#ShipInsNo').val();
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var isNew = ShipInsNo.length === 0;
	  var url = "",
	  url1 = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (gridcount == 0) {
	    extAlert("[상세 미등록]<br/> 출하검사등록 상세 데이터가 등록되지 않았습니다.<br/>관리자에게 문의하십시오.");
	    return false;
	  }

	  if (isNew) {
	    url = "<c:url value='/insert/quality/ship/ShipmentInspMaster.do' />";
	    url1 = "<c:url value='/insert/quality/ship/ShipmentInspDetail.do' />";
	    msgGubun = 1;
	  } else {
	    url = "<c:url value='/update/quality/ship/ShipmentInspMaster.do' />";
	    url1 = "<c:url value='/update/quality/ship/ShipmentInspDetail.do' />";
	    msgGubun = 2;
	  }

	  if (msgGubun == 1) {
	    Ext.MessageBox.confirm('출하검사 등록 알림', '저장 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            // extAlert(data.msg);
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;
	            var inspno = data.SHIPINSNO;

	            if (inspno.length == 0) {
	              //   안되었을 때 로직 추가
	            } else {
	              //   정상적으로 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);
	                model.set("SHIPINSNO", inspno);

	                if (model.get("SHIPINSNO") != '') {
	                  params.push(model.data);
	                }
	              }
	              dataSuccess = 1;

	              if (params.length > 0) {
	                Ext.Ajax.request({
	                  url: url1,
	                  method: 'POST',
	                  headers: {
	                    'Content-Type': 'application/json'
	                  },
	                  jsonData: {
	                    data: params
	                  },
	                  success: function (conn, response, options, eOpts) {
	                    if (msgGubun == 1) {
	                      msg = "정상적으로 저장 하였습니다.";
	                    } else if (msgGubun == 2) {
	                      msg = "내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                          setInterval(function () {
	                      go_url("<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + inspno + "&org=" + orgid + "&company=" + companyid);
	                      //                          }, 1 * 0.5 * 1000);
	                    }
	                  },
	                  error: ajaxError
	                });
	              }
	            }
	          },
	          error: ajaxError
	        });
	      } else {
	        Ext.Msg.alert('출하검사 등록', '출하검사 등록이 취소되었습니다.');
	        $('#Status').val($('#StatusTemp').val());
	        return;
	      }
	    });
	  } else if (msgGubun == 2) {

	    Ext.MessageBox.confirm('출하검사 등록 변경 알림', '등록을 변경하시겠습니까?', function (btn) {
	      if (btn == 'yes') {

	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var inspno = data.ShipInsNo;
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;

	            if (inspno.length == 0) {
	              //  생성이 안되었을 때 로직 추가
	            } else {
	              //  정상적으로 생성이 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);
	                model.set("SHIPINSNO", inspno);
	                if (model.get("SHIPINSNO") != '') {
	                  params.push(model.data);

	                }
	              }
	              dataSuccess = 1;

	              if (params.length > 0) {
	                Ext.Ajax.request({
	                  url: url1,
	                  method: 'POST',
	                  headers: {
	                    'Content-Type': 'application/json'
	                  },
	                  jsonData: {
	                    data: params
	                  },
	                  success: function (conn, response, options, eOpts) {
	                    if (msgGubun == 1) {
	                      msg = "정상적으로 저장 하였습니다.";
	                    } else if (msgGubun == 2) {
	                      msg = "내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                          setInterval(function () {
	                      go_url("<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + inspno + "&org=" + orgid + "&company=" + companyid);
	                      //                          }, 1 * 0.5 * 1000);
	                    }
	                  },
	                  error: ajaxError
	                });
	              }
	            }
	          },
	          error: ajaxError
	        });
	      } else {
	        Ext.Msg.alert('변경', '변경이 취소되었습니다.');
	        return;
	      }
	    });
	  }
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var inspno = $('#ShipInsNo').val();

	  var header = [],
	  count = 0;
	  var dataSuccess = 0;

	  if (orgid === "") {
	    header.push("사업장");
	    count++;
	  }
	  if (companyid === "") {
	    header.push("공장");
	    count++;
	  }
	  if (inspno === "") {
	    header.push("출하검사번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	    return result;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var inspno = $('#ShipInsNo').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SHIPINSNO: inspno,
	  };

	  url = "<c:url value='/select/quality/ship/ShipmentInspMaster.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      if (data.totcnt > 0) {
	        var dataList = data.data[0];

	        var shipinsno = dataList.SHIPINSNO;
	        var mfgdate = dataList.MFGDATE;
	        var shipno = dataList.SHIPNO;
	        var shipseq = dataList.SHIPSEQ;
	        var customercode = dataList.CUSTOMERCODE;
	        var customername = dataList.CUSTOMERNAME;
	        var itemcode = dataList.ITEMCODE;
	        var ordername = dataList.ORDERNAME;
	        var drawingno = dataList.DRAWINGNO;
	        var itemname = dataList.ITEMNAME;
	        var detailqty = dataList.DETAILQTY;
	        var shipqty = dataList.SHIPQTY;
	        var passqty = dataList.PASSQTY;
	        var faultqty = dataList.FAULTQTY;

	        var checkyn = dataList.CHECKYN;
	        var checkynname = dataList.CHECKYNNAME;
	        var remarks = dataList.REMARKS;
	        var personid = dataList.PERSONID;
	        var krname = dataList.KRNAME;
	        var manageemployee = dataList.MANAGEEMPLOYEE;
	        var managename = dataList.MANAGENAME;
	        var mfgno = dataList.MFGNO;

	        //         $("#ShipInsNo").val(shipinsno);

	        if (mfgdate === "" || mfgdate === null) {
	          $("#MfgDate").val($('#today').val());
	        } else {
	          $("#MfgDate").val(mfgdate);
	        }

	        $("#ShipNo").val(shipno);
	        $("#ShipSeq").val(shipseq);
	        $("#CustomerCode").val(customercode);
	        $("#CustomerName").val(customername);
	        $("#ItemCode").val(itemcode);
	        $("#OrderName").val(ordername);
	        $("#DrawingNo").val(drawingno);
	        $("#ItemName").val(itemname);
	        $("#DetailQty").val(detailqty);
	        $("#ShipQty").val(shipqty);
	        $("#PassQty").val(passqty);

	        $("#FaultQty").val(faultqty);
	        //         $("#ShipLot").val(shiplot);
	        $("#Remarks").val(remarks);
	        $("#CheckYn").val(checkyn);
	        $("#CheckYnName").val(checkynname);
	        $("#PersonId").val(personid);
	        $("#KrName").val(krname);
	        $("#ManageEmployee").val(manageemployee);
	        $("#ManageName").val(managename);
	        $("#MfgNo").val(mfgno);

	        var sparams1 = {
	          ORGID: orgid,
	          COMPANYID: companyid,
	          SHIPINSNO: shipinsno,
	        };

	        extGridSearch(sparams1, gridnms["store.1"]);
	      }
	    },
	    error: ajaxError
	  });

	}

	function fn_print(val) {
	  if (!fn_validation())
	    return;

	  var customercode = $("#CustomerCode").val();

	  if (customercode == "0000000001") {
	    var customername = $("#CustomerName").val();
	    var targetname = "두산모트롤";
	    if (customername.indexOf(targetname) != -1) {

	      var column = 'master';
	      var url = null;
	      var target = '_blank';

	      url = "<c:url value='/report/ShipInspectionReport.pdf'/>";

	      fn_popup_url(column, url, target);
	    } else {
	      extAlert("[알림]<br/>현재 두산 출하검사성적서만 출력가능합니다.<br/>다시 한번 확인해주세요.");
	      return;
	    }
	  } else if (customercode == "0000000002") {
	    var customername = $("#CustomerName").val();
	    var targetname = "이튼인더스트리스 유한회사";
	    if (customername.indexOf(targetname) != -1) {

	      var column = 'master';
	      var url = null;
	      var target = '_blank';

	      url = "<c:url value='/report/ShipInspectionETReport.pdf'/>";

	      fn_popup_url(column, url, target);
	    } else {
	      extAlert("[알림]<br/>현재 이튼인더스트리스 유한회사 출하검사성적서만 출력가능합니다.<br/>다시 한번 확인해주세요.");
	      return;
	    }
	  } else if (customercode == "0000000005") {
	    var customername = $("#CustomerName").val();
	    var targetname = "하이드로텍㈜";
	    if (customername.indexOf(targetname) != -1) {

	      var column = 'master';
	      var url = null;
	      var target = '_blank';

	      url = "<c:url value='/report/ShipInspectionHDReport.pdf'/>";

	      fn_popup_url(column, url, target);
	    } else {
	      extAlert("[알림]<br/>현재 하이드로텍㈜ 출하검사성적서만 출력가능합니다.<br/>다시 한번 확인해주세요.");
	      return;
	    }
	  } else if (customercode == "0000000013") {
	    var customername = $("#CustomerName").val();
	    var targetname = "훌루테크㈜";
	    if (customername.indexOf(targetname) != -1) {

	      var column = 'master';
	      var url = null;
	      var target = '_blank';

	      url = "<c:url value='/report/ShipInspectionFLReport.pdf'/>";

	      fn_popup_url(column, url, target);
	    } else {
	      extAlert("[알림]<br/>현재 훌루테크㈜ 출하검사성적서만 출력가능합니다.<br/>다시 한번 확인해주세요.");
	      return;
	    }
	  } else {
	    var customername = $("#CustomerName").val();
	    var column = 'master';
	    var url = null;
	    var target = '_blank';

	    url = "<c:url value='/report/ShipInspectionEtcReport.pdf'/>";

	    fn_popup_url(column, url, target);
	  }
	}

	function fn_delete() {
	  // 삭제
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var inspno = $('#ShipInsNo').val();
	  var url = "";
	  var statuschk = true;

	  if (inspno === "") {
	    extAlert("데이터가 등록되지 않은 상태에서 삭제하실수 없습니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();
	  if (!gridcount == 0) {
	    extAlert("[상세 데이터]<br/>상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
	    return false;
	  }

	  url = "<c:url value='/delete/quality/ship/ShipmentInspMaster.do' />";

	  Ext.MessageBox.confirm('출하검사 삭제 알림', '데이터를 삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      var params = [];
	      $.ajax({
	        url: url,
	        type: "post",
	        dataType: "json",
	        data: $("#master").serialize(),
	        success: function (data) {
	          extAlert(data.msg);
	          var result = data.success;

	          if (result) {
	            // 삭제 성공
	            var msg = data.msg;
	            extAlert(msg);
	            //                setInterval(function () {
	            fn_list();
	            //                }, 1 * 0.5 * 1000);
	          } else {
	            // 실패 했을 경우
	            var msg = data.msg;
	            extAlert(msg);
	            return;
	          }

	        },
	        error: ajaxError
	      });
	    } else {
	      Ext.Msg.alert('출하검사등록 삭제', '삭제가 취소되었습니다.');
	      return;
	    }
	  });
	}

	function fn_list() {
	  go_url("<c:url value='/quality/ship/ShipmentInspList.do'/>");
	}

	function fn_add() {
	  go_url("<c:url value='/quality/ship/ShipmentInspManage.do' />");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function fn_emp_all(p_mode, p_flag) {
	  // 검사자 선택시 상세 내역에 등록하는 Function
	  var count1 = Ext.getStore(gridnms["store.1"]).count();

	  var personid,
	  krname;
	  if (p_mode == "CLEAR") {
	    personid = "";
	    krname = "";
	  } else if (p_mode == "REGIST") {
	    if (p_flag == "EMPLOYEE") {
	      personid = $('#PersonId').val();
	      krname = $('#KrName').val();
	    } else if (p_flag == "MANAGE") {
	      personid = $('#ManageEmployee').val();
	      krname = $('#ManageName').val();
	    }
	  }

	  if (count1 > 0) {
	    for (var i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
	      var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	      if (p_flag == "EMPLOYEE") {
	        model1.set('PERSONID', personid);
	        model1.set('KRNAME', krname);
	      } else if (p_flag == "MANAGE") {
	        model1.set('MANAGEEMPLOYEE', personid);
	        model1.set('MANAGENAME', krname);
	      }
	    }
	  } else {
	    extAlert("검사 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	  }
	}

	function setLovList() {

	  // 검사자 Lov
	  $("#KrName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#PersonId").val("");
	      fn_emp_all('CLEAR', 'EMPLYEE');
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
	        INSPECTORTYPE: '10', // 관리직 검색
	        INSPECTORTYPE2: '20', // 생산관리직 추가
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
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
	      $("#PersonId").val(o.item.value);
	      $("#KrName").val(o.item.label);
	      fn_emp_all('REGIST', 'EMPLOYEE');

	      return false;
	    }
	  });

	  // 품질책임자 Lov
	  $("#ManageName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#ManageEmployee").val("");
	      fn_emp_all('CLEAR', 'MANAGE');
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
	      $.getJSON("<c:url value='/searchSmallCodeListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        BIGCD: 'QM',
	        MIDDLECD: 'MANAGE_EMPLOYEE',
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
	      $("#ManageEmployee").val(o.item.value);
	      $("#ManageName").val(o.item.label);
	      fn_emp_all('REGIST', 'MANAGE');

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
                                <li>출하검사</li>
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
                            <input type="hidden" id="popupCheckBig" name="popupCheckBig" value="O" />
                            <input type="hidden" id="popupOrgId" name="popupOrgId" />
                            <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                            <input type="hidden" id="popupFrom" name="popupFrom" />
                            <input type="hidden" id="popupTo" name="popupTo" />
                            <input type="hidden" id="popupItemCode" name="popupItemCode" />
                            <input type="hidden" id="popupItemName" name="popupItemName" />
                            <input type="hidden" id="popupOrderName" name="popupOrderName" />
                            <form id="master" name="master" action="" method="post">
                                <input type="hidden" id="today" name="today" value="${searchVO.TODAY }"/>
                                <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                <input type="hidden" id="ItemCode" name="ItemCode" />
                                <input type="hidden" id="PersonId" name="PersonId" />
                                <input type="hidden" id="ManageEmployee" name="ManageEmployee" />
                                <input type="hidden" id="CheckYn" name="CheckYn" />
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
                                                <td>
                                                    <div class="buttons" style="float: right; margin-top: 3px;">
                                                        <a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel1();"> 출하검사 대기 List </a>
                                                        <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
                                                        <a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
                                                        <a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                        <a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                        <a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print();"> 출하검사성적서 </a>
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
                                        <th class="required_text">출하검사번호</th>
                                        <td>
                                            <input type="text" id="ShipInsNo" name="ShipInsNo" class="input_center" style="width: 97%;" value="${searchVO.SHIPINSNO}" readonly />
                                        </td>
                                        <th class="required_text">검사일</th>
                                        <td>
                                            <input type="text" id="MfgDate" name="MfgDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
                                        </td>
                                        <th class="required_text">출하번호</th>
                                        <td>
                                            <input type="text" id="ShipNo" name="ShipNo" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">출하순번</th>
                                        <td>
                                            <input type="text" id="ShipSeq" name="ShipSeq" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">거래처</th>
                                        <td>
                                            <input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                            <input type="text" id="OrderName" name="OrderName" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">도번</th>
                                        <td>
                                            <input type="text" id="DrawingNo" name="DrawingNo" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="ItemName" name="ItemName" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">출하수량</th>
                                        <td>
                                            <input type="text" id="DetailQty" name="DetailQty" class="input_right" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">검사수량</th>
                                        <td>
                                            <input type="text" id="ShipQty" name="ShipQty" class="input_right" style="width: 97%; ime-mode: disabled;" onkeydown="return fn_key_number(event)" onkeyup='fn_remove_char(event)' />
                                        </td>
                                        <th class="required_text">합격수량</th>
                                        <td>
                                            <input type="text" id="PassQty" name="PassQty" class="input_right" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">불량수량</th>
                                        <td>
                                            <input type="text" id="FaultQty" name="FaultQty" class="input_right" style="width: 97%; ime-mode: disabled;" onkeydown="return fn_key_number(event)" onkeyup='fn_remove_char(event)' />
                                        </td>
                                        <!-- <th class="required_text">출하LOT</th>
                                        <td>
                                            <input type="text" id="ShipLot" name="ShipLot" class="input_center" style="width: 97%;" readonly />
                                        </td> -->
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">결과</th>
                                        <td><input type="text" id="CheckYnName" name="CheckYnName" class="input_validation input_center" style="width: 67%; margin-top: 6px;" onkeydown="javascript:fn_check_result2();" onkeyup="javascript:fn_check_result2();" />
                                        </td>
                                        <th class="required_text">검사자</th>
                                        <td>
                                            <input type="text" id="KrName" name="KrName" class="input_center" style="width: 97%; "/>
                                        </td>
                                        <th class="required_text">품질책임자</th>
                                        <td>
                                            <input type="text" id="ManageName" name="ManageName" class="input_center" style="width: 97%; "/>
                                        </td>
                                        <th class="required_text">LOT번호</th>
                                        <td>
                                            <input type="text" id="MfgNo" name="MfgNo" class="input_center" style="width: 97%; "/>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                            <th class="required_text">비고</th>
                                            <td colspan="7">
                                                <textarea id="Remarks" name="Remarks" class="input_left" rows=2 style="width:100%; " ></textarea>
                                            </td>
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
        <div id="gridPopup1Area" style="width: 1300px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup2Area" style="width: 1300px; padding-top: 0px; float: left;"></div>

        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>