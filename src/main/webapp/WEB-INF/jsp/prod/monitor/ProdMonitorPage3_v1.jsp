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
.x-column-header-inner {
	font-size: 40px;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	padding: 0px;
	vertical-align: middle;
}

.x-column-header-text {
	height: 111px;
  line-height: 50px;
	display: -webkit-flex;
	display: flex;
	-webkit-align-items: center;
	align-items: center;
	-webkit-justify-content: center;
	justify-content: center;
}

#gridArea .x-grid-cell-inner {
  position: relative;
  text-overflow: ellipsis;
  font-size: 30px !important;
  font-weight: bold;
  height: 92px;
  background-color: white;
  color: black;
  font-weight: bold;
  display: -webkit-flex;
  display: flex;
  -webkit-align-items: center;
  align-items: center;
  -webkit-justify-content: center;
  justify-content: center;
}

.gridArea .x-grid-cell {
  border-top: 1px solid black !important;
  border-bottom: 1px solid black !important;
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

.blue2 {
    background-color: #5B9BD5;
    color: white;
}

.blue3:HOVER {
    background-color: highlight;
}
.blue3 {
    background-color: #003399;
    color: white;
}

.gray:HOVER {
    background-color: #EAEAEA;
}

.gray {
    background-color: #BDBDBD;
    color: black;
}

.white:HOVER {
    background-color: #FFFFFF;
    color: black;
}

.white {
    background-color: #000000;
    color: white;
}

.yellow:HOVER {
    background-color: #FFFF7E;
}

.yellow {
    background-color: yellow;
    color: black;
}

.red:HOVER {
    background-color: #FFD8D8;
}

.red {
    background-color: #FFA7A7;
    color: black;
}

.gray:HOVER {
    background-color: #d8d8d8;
}

.gray {
    background-color: #e1e1e1;
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
</style>
<script type="text/javaScript">
var gridnms = {};
var fields = {};
var items = {};
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setReadOnly();
});

function setInitial() {
  gridnms["app"] = "prod";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  setValues_monitoring();
}

function setValues_monitoring() {
  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "ProdMonitorPage3";

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
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, {
      type: 'string',
      name: 'MODELSTANDARD',
    }, {
      type: 'string',
      name: 'OPERATETEXT',
    }, {
      type: 'string',
      name: 'OPERATECOLOR',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순<br/>번',
      xtype: 'gridcolumn',
      flex: 0.5,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        //            meta.style = "background-color:rgb(5, 0, 153);";
        //            meta.style += "font-weight:bold;";
        //            meta.style += "color:rgb(255, 255, 255);";

        return value;
      },
    }, {
      dataIndex: 'VALUE',
      text: '설비<br/>코드',
      xtype: 'gridcolumn',
      flex: 1,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {

        return value;
      },
    }, {
      dataIndex: 'LABEL',
      text: '설비명',
      xtype: 'gridcolumn',
      flex: 4.5,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {

        return value;
      },
    }, {
      dataIndex: 'MODELSTANDARD',
      text: '모델 및 규격',
      xtype: 'gridcolumn',
      flex: 2,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {

        return value;
      },
    }, {
      dataIndex: 'OPERATETEXT',
      text: '가동<br/>유무',
      xtype: 'gridcolumn',
      flex: 1,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        var operatecolor = record.data.OPERATECOLOR;
        meta.style = "background-color:" + operatecolor + ";";

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
      dataIndex: 'OPERATECOLOR',
      xtype: 'hidden',
    }
  ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/monitor/ProdMonitorPage3.do' />"
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

var gridarea1;
function setExtGrid() {
  setExtGrid_monitoring();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function setExtGrid_monitoring() {

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
                SEARCHPAGE: '${searchVO.FIRSTPAGE}',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      MonitorPage3List: '#MonitorPage3List',
    },
    stores: [gridnms["store.1"]],
    //      control: items["btns.ctr.1"],
  });

  Ext.define(gridnms["panel.1"], {
    cls: 'gridArea',
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
        height: 491,
        border: 2,
        //          columnLines: true,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'MonitorPage3List',
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1
          }
        ],
        dockedItems: items["docked.1"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["model.1"],
    stores: gridnms["store.1"],
    views: gridnms["panel.1"],
    controllers: gridnms["controllers.1"],

    launch: function () {
      gridarea1 = Ext.create(gridnms["panel.1"], {
          renderTo: 'gridArea'
        });
    },
  });

}

function fn_search() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var currentpage = $('#currentpage').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    SEARCHPAGE: currentpage,
  };

  extGridSearch(sparams, gridnms["store.1"]);
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}

function DisplayTime() {
  var date = new Date();
  var Year = date.getFullYear() + "",
  Month = date.getMonth(),
  Day = date.getDate(),
  Hour = date.getHours(),
  Minute = date.getMinutes(),
  Second = date.getSeconds();
  var AmPm;
  var Week = new Array('일', '월', '화', '수', '목', '금', '토');

  Year = Year.substr(2, 2);

  if (Month < 9) {
    Month = "0" + ((Month * 1) + 1);
  } else {
    Month = ((Month * 1) + 1);
  }
  if (Day < 10) {
    Day = "0" + (Day);
  }

  if (Hour == 0) {
    AmPm = "오후";
  } else if (Hour < 13) {
    AmPm = "오전";
  } else {
    Hour -= 12;
    AmPm = "오후";
  }

  Hour = (Hour == 0) ? 12 : Hour;
  if (Hour < 10) {
    Hour = '0' + (Hour);
  }
  if (Minute < 10) {
    Minute = '0' + (Minute);
  }

  var hippen = null;
  if (Second % 2 == 0) {
    hippen = ":";
  } else {
    hippen = " ";
  }

  $('#DateTimeArea span').text(Year + "-" + Month + "-" + Day + " " + AmPm + " " + Hour + hippen + Minute);
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

setInterval(function () {
  DisplayTime();
}, 1000);

// 20초 간격으로 새로고침
setInterval(function () {
  var currentpage = $('#currentpage').val() * 1;
  var lastpage = $('#lastpage').val() * 1;
  if (currentpage == lastpage) {
    go_url('<c:url value="/prod/monitor/ProdMonitorPage1.do" />');
  } else {
    currentpage += 1;
    $('#currentpage').val(currentpage);

    fn_search();
  }
}, 10 * 2 * 1000);
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;">
		<!-- 전체 레이어 시작 -->
    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
    <input type="hidden" id="totalcount" value="${searchVO.TOTALCOUNT}" />
    <input type="hidden" id="currentpage" value="${searchVO.FIRSTPAGE}" />
    <input type="hidden" id="lastpage" value="${searchVO.LASTPAGE}" />
		<sec:authorize ifNotGranted="ROLE_MONITOR">
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
								<div id="content" style="padding-right: 0px;">
										<!-- 검색 필드 박스 시작 -->
                    <div id="search_field" style="width: 300px; float: left; padding-left: 0px; padding-bottom: 0px; margin-top: 23px;">
                        <div id="search_field_loc" style="padding-bottom: 0px;">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                    </div>
				            <div style="float: left; width: 100%; margin-bottom: 0px; padding-left: 15px; padding-top: 10px;">
		                    <table style="width: 100%;" border="0">
                            <colgroup>
                                <col width="35%">
                                <col width="30%">
                                <col width="35%">
                            </colgroup>
                            <tr>
                                <td>
                                    <strong style="font-size: 35px; font-weight: bold; padding-left: 10px;">${pageSubTitle}</strong>
                                </td>
                                <td>
                                    <label id="DateTimeArea" name="DateTimeArea" style="width: 100%; height: 80px; font-size: 35px; font-weight: bold; text-align: center; padding-top: 20px;">
                                        <span></span>
                                    </label>
                                </td>

                                <td style="float: right;">
<!-- 		                                <button class="blue2 h r shadow" type="button" onclick="fn_logout();" style="width: 180px; height: 60px; font-size: 30px; font-weight: bold; color: white; margin-top: 15px; margin-right: 15px;">나가기</button> -->
                                </td>
                            </tr>
		                    </table>
				            </div>
										<!-- //검색 필드 박스 끝 -->

                    <div id="gridArea" style="width: 100%; margin-top: 30px; margin-bottom: 0px; padding-bottom: 0px; float: left;"></div>
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
		</sec:authorize>

		<sec:authorize ifAllGranted="ROLE_MONITOR">
				<!-- 현재위치 네비게이션 시작 -->
				<!-- 검색 필드 박스 시작 -->
		    <div style="float: left; width: 100%;">
		
		        <table style="width: 100%;" border="0">
		            <colgroup>
		                <col width="35%">
		                <col width="30%">
		                <col width="35%">
		            </colgroup>
		            <tr>
		                <td>
		                    <strong style="font-size: 35px; font-weight: bold; padding-left: 10px;">${pageSubTitle}</strong>
		                </td>
		                <td>
		                    <label id="DateTimeArea" name="DateTimeArea" style="width: 100%; height: 80px; font-size: 35px; font-weight: bold; text-align: center; padding-top: 20px;">
		                        <span></span>
		                    </label>
		                </td>
		
		                <td style="float: right;">
		                    <button class="blue2 h r shadow" type="button" onclick="fn_logout();" style="width: 180px; height: 60px; font-size: 30px; font-weight: bold; color: white; margin-top: 15px; margin-right: 15px;">나가기</button>
		                </td>
		            </tr>
		        </table>
		    </div>
				<!-- //검색 필드 박스 끝 -->

        <div id="gridArea" style="width: 100%; margin-top: 30px; margin-bottom: 0px; padding-bottom: 0px; float: left;"></div>
				<!-- //content 끝 -->
		</sec:authorize>
		<!-- //전체 레이어 끝 -->
</body>
</html>