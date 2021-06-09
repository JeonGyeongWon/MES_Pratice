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

	  setReadOnly();

	  setLovList();
	});
	function setInitial() {
	  gridnms["app"] = "sys";

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
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "UserList";

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
	      name: 'RN'
	    }, {
	      type: 'string',
	      name: 'STARTDATE',
	      dateFormat: 'Y-m-d H:i:s',
	    }, {
	      type: 'string',
	      name: 'USERNAME'
	    }, {
	      type: 'string',
	      name: 'FUNCNAME'
	    }, {
	      type: 'string',
	      name: 'FUNCID',
	    }, {
	      type: 'string',
	      name: 'NOTE',
	    }, {
	      type: 'string',
	      name: 'REMARK',
	    }
	  ];

	  fields["columns.1"] = [
	    // Display columns
	    {
	      dataIndex: "RN",
	      text: "순번",
	      xtype: "gridcolumn",
	      width: 65,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'STARTDATE',
	      text: '일시',
	      xtype: 'datecolumn',
	      width: 150,
	      hidden: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d H:i:s',
	    }, {
	      dataIndex: 'USERNAME',
	      text: '사용자',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'NOTE',
	      text: '화면명',
	      xtype: 'gridcolumn',
	      width: 300,
	      hidden: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'REMARK',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 500,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'FUNCID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FUNCNAME',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/sys/user/UserList.do' />"
	  });

	  items["btns.1"] = [];

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
	}

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              extraParams: {
	                DTFROM: '${searchVO.dateFrom}',
	                DTTO: '${searchVO.dateTo}',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      userList: '#userList',
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
	        selType: 'cellmodel',
	        itemId: gridnms["panel.1"],
	        id: gridnms["panel.1"],
	        store: gridnms["store.1"],
	        height: 642,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
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
	          itemId: 'userList',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('USERNAME') >= 0) {
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
	    views: gridnms["panel.1"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["panel.1"], {
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
	  var header = [],
	  count = 0;

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

	  var dtfrom = $('#searchFrom').val();
	  var dtto = $('#searchTo').val();
	  var username = $('#searchUserName').val();
	  var programname = $('#searchProgramName').val();

	  var sparams = {
	    DTFROM: dtfrom,
	    DTTO: dtto,
	    USERNAME: username,
	    PROGRAMNAME: programname,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function setLovList() {}

	function setReadOnly() {
	  $("[readonly]").addClass("ui-state-disabled");
	}

	function fn_excel_download() {

	  var dtfrom = $('#searchFrom').val();
	  var dtto = $('#searchTo').val();
	  var username = $('#searchUserName').val();
	  var programname = $('#searchProgramName').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/sys/user/ExcelDownload.do?'/>"
	     + "DTFROM=" + dtfrom + ""
	     + "&DTTO=" + dtto + ""
	     + "&USERNAME=" + username + ""
	     + "&PROGRAMNAME=" + programname + ""
	     + "&TITLE=" + title + "");
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
                                <li>내부시스템관리</li>
                                <li>&gt;</li>
                                <li><strong>${pageTitle}</strong></li>
                            </ul>
                        </div>
                    </div>
                    <!-- 검색 필드 박스 시작 -->
                    <div id="search_field" style="margin-bottom: 0px;">
                        <div id="search_field_loc">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                        <form id="master" name="master" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <fieldset>
                                <legend>조건정보 영역</legend>
                                <div>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="20%">
                                        <col width="20%">
                                        <col width="60%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <td colspan="3">
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">엑셀 </a>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                    <table class="tbl_type_view" border="1">
                                        <colgroup>
                                            <col width="50px">
                                            <col width="250px">
                                            <col width="100px">
                                            <col width="18%">
                                            <col width="120px">
                                            <col width="20%">
                                        </colgroup>
                                        <tr style="height: 34px;">
                                        	<th class="required_text">일자</th>
                                            <td>
                                            	<input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 100px;" maxlength="10" />
	                                            &nbsp;~&nbsp;
	                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 100px;" maxlength="10" />
	                                            <div class="buttons" style="float: left; margin-top: 3px;">
					                                    <a id="btnChkDate1" class="" href="#" onclick="javascript:fn_btn_change_date('searchFrom', 'searchTo', '${searchVO.dateSys}', '${searchVO.dateSys}');">
					                                       &nbsp;&nbsp;금일&nbsp;&nbsp;
					                                    </a>
					                                    <a id="btnChkDate2" class="" href="#" onclick="javascript:fn_btn_change_date('searchFrom', 'searchTo', '${searchVO.predateSys}', '${searchVO.predateSys}');">
					                                       &nbsp;&nbsp;전일&nbsp;&nbsp;
					                                    </a>
					                                    <a id="btnChkDate3" class="" href="#" onclick="javascript:fn_btn_change_date('searchFrom', 'searchTo', '${searchVO.postdateFrom}', '${searchVO.postdateTo}');">
					                                       &nbsp;&nbsp;금월&nbsp;&nbsp;
					                                    </a>
					                                    <a id="btnChkDate4" class="" href="#" onclick="javascript:fn_btn_change_date('searchFrom', 'searchTo', '${searchVO.predateFrom}', '${searchVO.predateTo}');">
					                                       &nbsp;&nbsp;전월&nbsp;&nbsp;
					                                    </a>
		                                      </div>
                                            </td>
                                            <th class="required_text">사용자</th>
                                            <td>
                                            	<input type="text" id="searchUserName" name="searchUserName" class="input_left" style="width: 97%;" />
                                            </td>
                                            <th class="required_text">화면명</th>
                                            <td>
                                            	<input type="text" id="searchProgramName" name="searchProgramName" class="input_left" style="width: 97%;" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </fieldset>
                        </form>
                    </div>
                    <!-- //검색 필드 박스 끝 -->

                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">사용자 List</div></td>
                        </tr>
                    </table>
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