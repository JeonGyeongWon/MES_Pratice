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
	  $("#searchDate").val(getToDay("${searchVO.DATESYS}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "DailyEquipList";

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
	      type: 'number',
	      name: 'SEQ',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, {
	      type: 'string',
	      name: 'WORKDEPT',
	    }, {
	      type: 'string',
	      name: 'WORKDEPTNAME',
	    }, {
	      type: 'string',
	      name: 'OPERATECOLOR',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
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
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
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
	    }, {
	      dataIndex: 'WORKDEPTNAME',
	      text: '작업반',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'LABEL',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'XXXXXXXXXX',
	      text: '가동유무',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var operatecolor = record.data.OPERATECOLOR;
	        meta.style = "background-color:" + operatecolor + ";";

	        return value;
	      },
	    }, {
	      dataIndex: 'WORKORDERID',
	      text: '작업지시번호',
	      xtype: 'gridcolumn',
	      width: 130,
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
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
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
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
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
	    }, {
	      dataIndex: 'KRNAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	      dataIndex: 'SEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'VALUE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKDEPT',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OPERATECOLOR',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/DailyEquipList.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push(
	    '->');
	  items["btns.1"].push(
	    '<table>' +
	    '<colgroup>' +
	    '<col width="30px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '<col width="80px">' +
	    '</colgroup>' +
	    '<tr>' +
	    '<td>' +
	    '<strong>범례: </strong>' +
	    '</td>' +
	    '<td style="width: 80px; height: 15px; background-color: #00FF00; "></td>' +
	    '<td style="text-align: center;"> 가동중 </td>' +
	    '<td style="width: 80px; height: 15px; background-color: #FFFFFF; border: solid 1px; "></td>' +
	    '<td style="text-align: center;"> 미작업지시 </td>' +
	    '<td style="width: 80px; height: 15px; background-color: #FF0000; "></td>' +
	    '<td style="text-align: center;"> 설비 이상 </td>' +
	    '<td style="width: 80px; height: 15px; background-color: #FFE400; "></td>' +
	    '<td style="text-align: center;"> 설비 셋팅 </td>' +
	    '</tr>' +
	    '</table>');

	  items["btns.ctr.1"] = {};

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
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SEARCHDATE: $("#searchDate").val(),
	                WORKCENTERCODE: $('#searchWorkCenterCode').val(),
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
	      DailyEquipList: '#DailyEquipList',
	    },
	    stores: [gridnms["store.1"]],
	    //      control: items["btns.ctr.1"],
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
	        height: 687,
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
	          itemId: 'DailyEquipList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {

	                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
	                  }
	                }

	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
	  var searchDate = $("#searchDate").val();
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

	  if (searchDate == "") {
	    header.push("일자");
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
	  var searchDate = $("#searchDate").val();
	  var searchWorkCenterCode = $('#searchWorkCenterCode').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHDATE: searchDate,
	    WORKCENTERCODE: searchWorkCenterCode,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 설비명 Lov
	  $("#searchWorkCenterName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchWorkCenterCode").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchWorkCenterLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        MONITORINGGUBUN: "Y",
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              name: m.LABEL,
	              label: m.VALUE + ", " + m.LABEL,
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
	      $("#searchWorkCenterCode").val(o.item.value);
	      $("#searchWorkCenterName").val(o.item.label);
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
                        <input type="hidden" id="orgid" name="orgid" />
                        <input type="hidden" id="companyid" name="companyid" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="searchWorkCenterCode" name="searchWorkCenterCode" />
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
                                        <col width="130px">
                                        <col width="120px">
                                        <col width="25%">
                                        <col width="120px">
                                        <col width="25%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td >
                                            <input type="text" id="searchDate" name="searchDate" class="input_center" style="width: 100px;" maxlength="10" readonly />
                                        </td>
                                        <th class="required_text">설비명</th>
                                        <td>
                                            <input type="text" id="searchWorkCenterName" name="searchWorkCenterName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 72%;" />
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
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; margin-bottom: 5px; float: left;"></div>
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