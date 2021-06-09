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
	  gridnms["app"] = "prod";

	  calender($('#searchDate'));

	  $('#searchDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchDate").val(getToDay("${searchVO.dateSys}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_master();
	}

	function setValues_master() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["grid.1"] = "ToolInOutList";

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
	      type: 'string',
	      name: 'OUTNO',
	    }, {
	      type: 'number',
	      name: 'OUTSEQ',
	    }, {
	      type: 'date',
	      name: 'OUTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'OUTCUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'OUTCUSTOMERNAME',
	    }, {
	      type: 'string',
	      name: 'OUTPERSON',
	    }, {
	      type: 'string',
	      name: 'OUTKRNAME',
	    }, {
	      type: 'string',
	      name: 'OUTSTATUS',
	    }, {
	      type: 'string',
	      name: 'OUTSTATUSNAME',
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
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'OUTQTY',
	    }, {
	      type: 'string',
	      name: 'OUTREMARKS',
	    }, {
	      type: 'string',
	      name: 'TOOLSTATUS',
	    }, {
	      type: 'string',
	      name: 'TOOLSTATUSNAME',
	    }, {
	      type: 'date',
	      name: 'INDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'INQTY',
	    }, {
	      type: 'string',
	      name: 'INREMARKS',
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
	      //      }, {
	      //        dataIndex: 'ORDERNAME',
	      //        text: '품번',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	    }, {
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
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
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
	    }, {
	      dataIndex: 'TOOLSTATUSNAME',
	      text: '상태',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'OUTDATE',
	      text: '반출일',
	      xtype: 'datecolumn',
	      width: 85,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'OUTQTY',
	      text: '반출수량',
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'INDATE',
	      text: '반입일',
	      xtype: 'datecolumn',
	      width: 85,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'INQTY',
	      text: '반입수량',
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'INREMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 450,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: "textareafield",
	        //              allowBlank: true,
	        editable: false,
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
	      dataIndex: 'OUTNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTCUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTCUSTOMERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTPERSON',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTKRNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTSTATUS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTSTATUSNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTREMARKS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TOOLSTATUS',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/tool/ToolInOutList.do' />"
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
	  setExtGrid_master();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
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
	                ORGID: $('#searchOrgId').val(),
	                COMPANYID: $('#searchCompanyId').val(),
	                SEARCHDATE: "${searchVO.dateSys}",
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
	      ToolInOutList: '#ToolInOutList',
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
	          itemId: 'ToolInOutList',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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

	}

	function fn_validation() {
	  var result = true;
	  var searchdate = $('#searchDate').val();
	  var header = [],
	  count = 0;

	  if (searchdate === "") {
	    header.push("기준일자");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
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
	  var searchdate = $('#searchDate').val();
	  var toolstatus = $('#searchStatus option:selected').val();

	  // 필수 체크
	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHDATE: searchdate + "",
	    TOOLSTATUS: toolstatus,
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
                                <li>치공구 관리</li>
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
                        <input type="hidden" id="orgid" name="orgid" value="<c:out value='${searchVO.ORGID}'/>" />
                        <input type="hidden" id="companyid" name="companyid" value="<c:out value='${searchVO.COMPANYID}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
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
                                        <col width="10%">
								                        <col width="23%">
								                        <col width="10%">
								                        <col width="23%">
								                        <col width="10%">
								                        <col width="23%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">기준일자</th>
                                        <td >
                                            <input type="text" id="searchDate" name="searchDate" class="input_validation input_center" style="width: 100px;" maxlength="10" />
                                        </td>
                                        <th class="required_text">상태</th>
                                        <td>
                                            <select id="searchStatus" name="searchStatus" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS}">
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
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    
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