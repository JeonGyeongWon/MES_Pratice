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

<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload-ui.css'/>">

<!-- jQuery-File-Upload-9.9.3 -->
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

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

#gridPopup1Area .x-form-field {
	ime-mode: disabled;
	text-transform: uppercase;
}

#gridPopup2Area .x-form-field {
	ime-mode: disabled;
	text-transform: uppercase;
}
</style>
<script type="text/javaScript">
var imgCnt = 0;
var selectedItemCode = "", selectedroutingid = "", selectedCheckBig = "";
var filetype = "check", gubun = "Image1";
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  // 제품선택 팝업창 추가
  setValues_Popup();
  setExtGrid_Popup();

  setLovList();

  $("#gridPopup1Area").hide("blind", {
    direction: "up"
  }, "fast");

  $("#gridPopup2Area").hide("blind", {
    direction: "up"
  }, "fast");

  $('#searchOrgId, #searchCompanyId').change(function (event) {
    fn_option_change('CMM', 'ITEM_TYPE', 'searchItemType');
  });

  $('#searchItemType').change(function (event) {
    var bigcd = $('#searchBigcd').val();
    if (bigcd != "") {
      $('#searchBigcd').val("");
      $('#searchBignm').val("");
      $('#searchGroupCode').val("");
    }
  });
});

function setInitial() {
  gridnms["app"] = "base";

  imgCnt = $("div[id^=fileBox_]").length;
  $("#fileform").fileupload();
  fn_fileBtnBox_display();
  $("#fileform")
  .bind('fileuploadsubmit', function (e, data) {
    data.formData = {
      itemcd: selectedItemCode,
      filetype: filetype,
      gubun: gubun,
      routingid: selectedroutingid,
      checkbig: selectedCheckBig,
    };
  })
  .bind('fileuploadadd', function (e, data) {
    if (selectedItemCode === "") {
      extAlert("품번을 먼저 선택해주세요.");
      return false;
    }

    if (selectedCheckBig == "") {
      extAlert("검사기준을 먼저 선택해주세요.");
      return false;
    } else {
      if (selectedCheckBig == "F" || selectedCheckBig == "H" || selectedCheckBig == "L") {
        if (gubun == "Image1" || gubun == "Image2" || gubun == "Image3" || gubun == "Image5" || gubun == "Image6") {
          if (selectedroutingid === "") {
            extAlert("공정명을 먼저 선택해주세요.");
            return false;
          }
        } else {
          selectedroutingid = "";
        }
      }
    }

    if (imgCnt > 0) {
      extAlert(msgs.valid.fail.img.limitcnt);
      return false;
    }
    if (!fileValidImg(data.files))
      return false;

    imgCnt++;
    //     setTimeout(function () {
    //       var $filetable = $("#filetable").find("tr");
    //       var size = $filetable.length;
    //       for (var i = 0; i < (size - 1); i++) {
    //         $filetable.eq(i).remove();
    //       }
    //       fn_fileBtnBox_display();
    //       setTimeout(function () {
    //         $("#filetable").click();
    //       }, 120);
    //     }, 88);

    setTimeout(function () {
      getItemFile();
    }, 8000);
  })
  .bind('fileuploadstop', function (e, data) {
    getItemFile();
  })
  .bind('fileuploadfail', function (e, data) {
    imgCnt--;
    fn_fileBtnBox_display();
  });
}

function getItemFile() {

  $("div[id^=fileBox_]").remove();
  $("#filetable").find(".cancel").click();
  $("#filetable").find("tr").remove();

  var routingid = "";
  if (selectedCheckBig == "F" || selectedCheckBig == "H" || selectedCheckBig == "L") {
    routingid = (gubun == "Image1" || gubun == "Image2" || gubun == "Image3" || gubun == "Image5" || gubun == "Image6") ? selectedroutingid : "";
  } else {
    routingid = "";
  }

  $.ajax({
    url: "<c:url value='/itemfile/select.do' />",
    type: "post",
    dataType: "json",
    data: {
      itemcd: selectedItemCode,
      filetype: filetype,
      gubun: gubun,
      routingid: routingid,
      checkbig: selectedCheckBig,
    },
    success: function (data) {
      var wth = $("#fileBox").width();
      var hgt = 356 * 1; // $("#fileBox").height();
      $.each(data, function (i, m) {
        var html = '';
        html += '<div id="fileBox_' + m.fileid + '" >';
        html += '<a href="' + m.filepathview + m.filenmreal + '" download="' + m.filenmview + '">';
        //         html += '<a href"' + m.filepathview + m.filenmreal + '" onclick="javascript:fn_file_download(\'' + m.filepathview + m.filenmreal + '\', \'' + m.filenmview + '\', \'' + m.fileexe + '\');" download="' + m.filenmview + '">';
        html += '<img alt="" src="' + m.filepathview + m.filenmreal + '" style="width: ' + wth + 'px; height: ' + (hgt - 40) + 'px; " />';
        html += '</a>';
        html += '<button class="btn btn-sm" href="#" onclick="javascript:fn_file_delete(\'' + m.fileid + '\'); return false;" style="background-color:#009fd6; color:white;">삭제</button>';
        html += '</div>';
        $("#fileBox").append(html);
      });
      imgCnt = $("div[id^=fileBox_]").length;
      fn_fileBtnBox_display();
    },
    error: ajaxError
  });
}

function fn_file_download(path, name, ftype) {
  $.ajax({
    url: "<c:url value='/file/download.do' />",
    type: "post",
    dataType: "json",
    data: {
      FILEPATH: path,
      FILENAME: name,
      FILEEXE: ftype,
    },
    success: function (data) {
      if (data.success) {
        console.log(data.msg);
      } else {
        console.log(data.msg);
      }
    },
    error: ajaxError
  });
}

function fn_file_delete(fileid) {
  if (!confirm("삭제하시겠습니까?\n삭제 시 파일은 즉시 제거됩니다."))
    return;

  var routingid = "";
  if (selectedCheckBig == "F" || selectedCheckBig == "H" || selectedCheckBig == "L") {
    routingid = (gubun == "Image1" || gubun == "Image2" || gubun == "Image3" || gubun == "Image5" || gubun == "Image6") ? selectedroutingid : "";
  } else {
    routingid = "";
  }

  $.ajax({
    url: "<c:url value='/file/delete.do' />",
    type: "post",
    dataType: "json",
    data: {
      fileid: fileid,
      itemcd: selectedItemCode,
      gubun: gubun,
      routingid: routingid,
      checkbig: selectedCheckBig,
    },
    success: function (data) {
      if (data.success) {
        $("#fileBox_" + fileid).remove();
        imgCnt--;
        fn_fileBtnBox_display();
      } else {
        alert("삭제 실패하였습니다.");
      }
    },
    error: ajaxError
  });
}

function fn_fileBtnBox_display() {
  if (imgCnt >= 1) {
    $("#fileBtnBox").hide();
  } else {
    $("#fileBtnBox").show();
  }
}

// 이미지 등록 / 삭제
function fn_imageHandle(val) {
  if (selectedItemCode === "") {
    extAlert("품번을 먼저 선택해주세요.");
    return false;
  }

  if (selectedCheckBig == "") {
    extAlert("검사기준을 먼저 선택해주세요.");
    return false;
  } else {
    if (selectedCheckBig == "F" || selectedCheckBig == "H" || selectedCheckBig == "L") {
      if (val == "Image1" || val == "Image2" || val == "Image3" || val == "Image5" || val == "Image6") {
        if (selectedroutingid === "") {
          extAlert("공정명을 먼저 선택해주세요.");
          return false;
        }
      }
    }
  }

  gubun = val;

  getItemFile();
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  setValues_Item();
}

var gridItemArea, gridMasterArea;
function setExtGrid() {
  setExtGrid_Item();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridItemArea.updateLayout();
    gridMasterArea.updateLayout();
  });
}

function setValues_Item() {
  gridnms["models.item"] = [];
  gridnms["stores.item"] = [];
  gridnms["views.item"] = [];
  gridnms["controllers.item"] = [];

  gridnms["models.check"] = [];
  gridnms["stores.check"] = [];
  gridnms["views.check"] = [];
  gridnms["controllers.check"] = [];

  gridnms["grid.4"] = "itemMaster";
  gridnms["grid.5"] = "itemType";
  gridnms["grid.6"] = "uom";
  gridnms["grid.7"] = "customer";

  gridnms["grid.10"] = "checkMaster";
  gridnms["grid.11"] = "big";
  gridnms["grid.12"] = "routing";
  gridnms["grid.13"] = "middle";
  gridnms["grid.14"] = "small";
  gridnms["grid.15"] = "specialcheckLov";
  gridnms["grid.16"] = "checkmethodLov";
  gridnms["grid.17"] = "fmlcodeLov";
  gridnms["grid.18"] = "checkcycleLov";
  gridnms["grid.19"] = "importantLov";

  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
  gridnms["views.item"].push(gridnms["panel.4"]);

  gridnms["panel.10"] = gridnms["app"] + ".view." + gridnms["grid.10"];
  gridnms["views.check"].push(gridnms["panel.10"]);

  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
  gridnms["controllers.item"].push(gridnms["controller.4"]);

  gridnms["controller.10"] = gridnms["app"] + ".controller." + gridnms["grid.10"];
  gridnms["controllers.check"].push(gridnms["controller.10"]);

  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];

  gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];
  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
  gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];
  gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
  gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];
  gridnms["model.15"] = gridnms["app"] + ".model." + gridnms["grid.15"];
  gridnms["model.16"] = gridnms["app"] + ".model." + gridnms["grid.16"];
  gridnms["model.17"] = gridnms["app"] + ".model." + gridnms["grid.17"];
  gridnms["model.18"] = gridnms["app"] + ".model." + gridnms["grid.18"];
  gridnms["model.19"] = gridnms["app"] + ".model." + gridnms["grid.19"];

  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];

  gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];
  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
  gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];
  gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
  gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];
  gridnms["store.15"] = gridnms["app"] + ".store." + gridnms["grid.15"];
  gridnms["store.16"] = gridnms["app"] + ".store." + gridnms["grid.16"];
  gridnms["store.17"] = gridnms["app"] + ".store." + gridnms["grid.17"];
  gridnms["store.18"] = gridnms["app"] + ".store." + gridnms["grid.18"];
  gridnms["store.19"] = gridnms["app"] + ".store." + gridnms["grid.19"];

  gridnms["models.item"].push(gridnms["model.4"]);
  gridnms["models.item"].push(gridnms["model.5"]);
  gridnms["models.item"].push(gridnms["model.6"]);
  gridnms["models.item"].push(gridnms["model.7"]);

  gridnms["models.check"].push(gridnms["model.10"]);
  gridnms["models.check"].push(gridnms["model.11"]);
  gridnms["models.check"].push(gridnms["model.12"]);
  gridnms["models.check"].push(gridnms["model.13"]);
  gridnms["models.check"].push(gridnms["model.14"]);
  gridnms["models.check"].push(gridnms["model.15"]);
  gridnms["models.check"].push(gridnms["model.16"]);
  gridnms["models.check"].push(gridnms["model.17"]);
  gridnms["models.check"].push(gridnms["model.18"]);
  gridnms["models.check"].push(gridnms["model.19"]);

  gridnms["stores.item"].push(gridnms["store.4"]);
  gridnms["stores.item"].push(gridnms["store.5"]);
  gridnms["stores.item"].push(gridnms["store.6"]);
  gridnms["stores.item"].push(gridnms["store.7"]);

  gridnms["stores.check"].push(gridnms["store.10"]);
  gridnms["stores.check"].push(gridnms["store.11"]);
  gridnms["stores.check"].push(gridnms["store.12"]);
  gridnms["stores.check"].push(gridnms["store.13"]);
  gridnms["stores.check"].push(gridnms["store.14"]);
  gridnms["stores.check"].push(gridnms["store.15"]);
  gridnms["stores.check"].push(gridnms["store.16"]);
  gridnms["stores.check"].push(gridnms["store.17"]);
  gridnms["stores.check"].push(gridnms["store.18"]);
  gridnms["stores.check"].push(gridnms["store.19"]);

  fields["model.4"] = [{
      type: 'number',
      name: 'RNUM'
    }, {
      type: 'number',
      name: 'ORGID'
    }, {
      type: 'number',
      name: 'COMPANYID'
    }, {
      type: 'string',
      name: 'GROUPCODE'
    }, {
      type: 'string',
      name: 'BIGCODE',
    }, {
      type: 'string',
      name: 'BIGNAME',
    }, {
      type: 'string',
      name: 'MIDDLECODE'
    }, {
      type: 'string',
      name: 'SMALLCODE'
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'ITEMNAME'
    }, {
      type: 'string',
      name: 'DRAWINGNO'
    }, {
      type: 'string',
      name: 'ORDERNAME'
    }, {
      type: 'string',
      name: 'ITEMTYPE'
    }, {
      type: 'string',
      name: 'ITEMTYPENAME'
    }, {
      type: 'string',
      name: 'UOM'
    }, {
      type: 'string',
      name: 'UOMNAME'
    }, {
      type: 'string',
      name: 'MODELNAME'
    }, {
      type: 'string',
      name: 'REMARKS'
    }, {
      type: 'string',
      name: 'USEYN'
    }, {
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'INVENTORYMANAGEYN'
    }, {
      type: 'string',
      name: 'LOTYN'
    }, {
      type: 'number',
      name: 'INVSAFEQTY'
    }, {
      type: 'number',
      name: 'INVREDURATE'
    }, {
      type: 'number',
      name: 'INVMINQTY'
    }, {
      type: 'number',
      name: 'INVMAXQTY'
    }, {
      type: 'string',
      name: 'PURPOUOM'
    }, {
      type: 'string',
      name: 'PURWAUOM'
    }, {
      type: 'string',
      name: 'WARNONINSPYN'
    }, {
      type: 'string',
      name: 'WARALTWAREYN'
    }, {
      type: 'string',
      name: 'PROMAKETYPE'
    }, {
      type: 'string',
      name: 'PROSOURTYPE'
    }, {
      type: 'string',
      name: 'PROSOURORG'
    }, {
      type: 'string',
      name: 'PROMATTYPE'
    }, {
      type: 'string',
      name: 'PROLEADTIME'
    }, {
      type: 'string',
      name: 'SHIPUOM'
    }, {
      type: 'string',
      name: 'SHIPBOX'
    }, {
      type: 'string',
      name: 'PROLEADSIZE'
    }, {
      type: 'string',
      name: 'ITEMCHECK'
    }, {
      type: 'string',
      name: 'FIRSTCHECKBIG'
    }, {
      type: 'string',
      name: 'FIRSTROUTINGID'
    },
  ];

  fields["model.5"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.6"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];
  fields["model.7"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.10"] = [{
      type: 'number',
      name: 'RNUM',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'number',
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
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGNO',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
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
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'number',
      name: 'CHECKQTY',
    }, {
      type: 'number',
      name: 'ORDERNO',
    }, {
      type: 'string',
      name: 'SPECIALCHECK',
    }, {
      type: 'string',
      name: 'SPECIALCHECKNAME',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPE',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPENAME',
    }, {
      type: 'string',
      name: 'FMLCREATECODE',
    }, {
      type: 'string',
      name: 'FMLCREATENAME',
    }, {
      type: 'string',
      name: 'CHECKCYCLE',
    }, {
      type: 'string',
      name: 'CHECKCYCLENAME',
    }, {
      type: 'string',
      name: 'CHECKINTERVAL',
    }, {
      type: 'string',
      name: 'INTERVALCNT',
    }, {
      type: 'string',
      name: 'EXTSTANDARD',
    }, {
      type: 'string',
      name: 'IMPORTANTCODE',
    }, {
      type: 'string',
      name: 'IMPORTANTNAME',
    }, ];

  fields["model.11"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.12"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.13"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.14"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.18"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.19"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["columns.4"] = [
    // Display Columns
    {
      dataIndex: 'RNUM',
      text: '순번',
      xtype: 'rownumberer',
      width: 55,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'BIGNAME',
      text: '대분류',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 150, // 120,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'DRAWINGNO',
      text: '도번',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
    }, {
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 300, // 200,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
    }, {
      dataIndex: 'ITEMTYPENAME',
      text: '유형',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
    }, {
      dataIndex: 'UOMNAME',
      text: '단위',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'MODELNAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'XXXXXXXX',
      menuDisabled: true,
      sortable: false,
      resizable: false,
      xtype: 'widgetcolumn',
      stopSelection: true,
      text: '검사기준정보',
      width: 100,
      style: 'text-align:center',
      align: "center",
      widget: {
        xtype: 'button',
        _btnText: "복사",
        defaultBindProperty: null, //important
        handler: function (widgetColumn) {
          var record = widgetColumn.getWidgetRecord();

          var itemcheck = record.data.ITEMCHECK;
          if (itemcheck == "Y") {
            extAlert("검사기준 정보가 하나라도 등록이 되어 있지 않아야 복사하기가 가능합니다.");
            return;
          }
          fn_copy(record.data);
        },
        listeners: {
          beforerender: function (widgetColumn) {
            var record = widgetColumn.getWidgetRecord();
            widgetColumn.setText(widgetColumn._btnText);
          }
        }
      }
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 280,
      //       flex: 1,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효시작일자',
      xtype: 'datecolumn',
      width: 110,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
      format: 'Y-m-d',
    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효종료일자',
      xtype: 'datecolumn',
      width: 110,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
      format: 'Y-m-d',
      //     }, {
      //       dataIndex: 'XXXXXXXXXX',
      //       text: '적용',
      //       xtype: 'templatecolumn',
      //       width: 300,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       menuDisabled: true,
      //       style: 'text-align:center',
      //       align: "left",
      //       tpl: ['<strong>순번 :</strong> {RNUM} -> <br>',
      //         '<strong>품번 :</strong> {ORDERNAME} <br/>',
      //         '<strong>품명 :</strong> {ITEMNAME}<br>',
      //         '<strong>거래처 :</strong> {CUSTOMERNAME}<br>',
      //         '<strong>종료일자 :</strong> {EFFECTIVEENDDATE:date("Y-m-d")}<br>',
      //       ],
    },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'GROUPCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'BIGCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MIDDLECODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'SMALLCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCHECK',
      xtype: 'hidden',
    }, {
      dataIndex: 'FIRSTCHECKBIG',
      xtype: 'hidden',
    }, {
      dataIndex: 'FIRSTROUTINGID',
      xtype: 'hidden',
    }, ];

  fields["columns.10"] = [
    // Display Columns
    {
      dataIndex: 'RNUM',
      text: '순번',
      xtype: 'gridcolumn',
      width: 55,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'CHECKBIGNAME',
      text: '검사구분',
      xtype: 'gridcolumn',
      width: 135, // 100,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.11"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("CHECKBIG", record.data.VALUE);

            var item = record.data.LABEL;

            if (item == "") {
              model.set("CHECKBIG", "");

            } else {
              model.set("ROUTINGID", "");
              model.set("ROUTINGNO", "");
              model.set("ROUTINGNAME", "");
              model.set("CHECKMIDDLE", "");
              model.set("CHECKMIDDLENAME", "");
              model.set("CHECKSMALL", "");
              model.set("CHECKSMALLNAME", "");

              var params1 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                ITEMCODE: record.data.ITEMCODE,
              };

              extGridSearch(params1, gridnms["store.12"]);

              var params2 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: "",
              };
              extGridSearch(params2, gridnms["store.13"]);

              var params3 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: "",
                MIDDLECD: "",
              };
              extGridSearch(params3, gridnms["store.14"]);
            }
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                //                  console.log("change : " + field.getValue());
                model.set("CHECKBIG", "");
                model.set("ROUTINGID", "");
                model.set("ROUTINGNO", "");
                model.set("ROUTINGNAME", "");
                model.set("CHECKMIDDLE", "");
                model.set("CHECKMIDDLENAME", "");
                model.set("CHECKSMALL", "");
                model.set("CHECKSMALLNAME", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255)";

        if (record.data.CHECKMASTEREND == "Y") {
        	meta.style = "background-color:rgb(234, 234, 234)";
       }
        return value;
      },
    }, {
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
      xtype: 'gridcolumn',
      width: 185, // 100,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.12"],
        valueField: "ROUTINGNAME",
        displayField: "ROUTINGNAME",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("ROUTINGID", record.data.ROUTINGCODE);
            model.set("ROUTINGNO", record.data.ROUTINGNO);
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("ROUTINGID", "");
                model.set("ROUTINGNO", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">{ROUTINGNAME}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {

        if (record.data.CHECKMASTEREND == "Y") {
          meta.style = "background-color:rgb(234, 234, 234)";
       }
        return value;
      },
    }, {
      dataIndex: 'CHECKMIDDLENAME',
      text: '검사분류',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.13"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("CHECKMIDDLE", record.data.VALUE);

            var item = record.data.LABEL;

            if (item == "") {
              model.set("CHECKMIDDLE", "");

            } else {
              model.set("CHECKSMALL", "");
              model.set("CHECKSMALLNAME", "");

              var params3 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: "",
                MIDDLECD: "",
              };
              extGridSearch(params3, gridnms["store.14"]);
            }
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                console.log("change : " + field.getValue());
                model.set("CHECKMIDDLE", "");
                model.set("CHECKMIDDLENAME", "");
                model.set("CHECKSMALL", "");
                model.set("CHECKSMALLNAME", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255)";

        if (record.data.CHECKMASTEREND == "Y") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        
        return value;
      },
    }, {
      dataIndex: 'CHECKSMALLNAME',
      text: '검사항목',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.14"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("CHECKSMALL", record.data.VALUE);
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("CHECKSMALL", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
	      meta.style = "background-color:rgb(253, 218, 255)";
	
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'ORDERNO',
      text: '검사<br/>순번',
      xtype: 'gridcolumn',
      width: 55,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      format: "0,000",
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
	
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'UOMNAME',
      text: '검사<br/>단위',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.6"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(
                Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("UOM", value.getValue());
          },
        },
      },
      renderer: function (value, meta, record) {
	
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'CHECKSTANDARD',
      text: '검사내용',
      xtype: 'gridcolumn',
      width: 350,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
      renderer: function (value, meta, record) {

        if (record.data.CHECKMASTEREND == "Y") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        
        return value;
      },
    }, {
      dataIndex: 'STANDARDVALUE',
      text: '검사기준',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
      renderer: function (value, meta, record) {

        if (record.data.CHECKMASTEREND == "Y") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        
        return value;
      },
    }, {
      dataIndex: 'MINVALUE',
      text: '허용치<br/>(하한)',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000.000",
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000.000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9.]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
	
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return Ext.util.Format.number(value, '0,000');
	    },
    }, {
      dataIndex: 'MAXVALUE',
      text: '허용치<br/>(상한)',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000.000",
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000.000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9.]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
    	  
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return Ext.util.Format.number(value, '0,000');
	    },
    }, {
      dataIndex: 'EXTSTANDARD',
      text: '규정',
      xtype: 'gridcolumn',
      width: 350,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
      renderer: function (value, meta, record) {
  
        if (record.data.CHECKMASTEREND == "Y") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        
        return value;
      },
    }, {
      dataIndex: 'CHECKQTY',
      text: '검사수',
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
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
          
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return Ext.util.Format.number(value, '0,000');
	    },
    }, {
      dataIndex: 'SPECIALCHECKNAME',
      text: '관리<br/>구분',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.15"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: true,
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("SPECIALCHECK", record.data.VALUE);
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("SPECIALCHECK", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table >'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
             + '</tr>'
             + '</table>'
          }
        },
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'CHECKMETHODTYPENAME',
      text: '검사방법',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.16"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'local', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("CHECKMETHODTYPE", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table >'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
             + '</tr>'
             + '</table>'
          }
        },
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    },
    {
      dataIndex: 'CHECKCYCLENAME',
      text: '검사주기',
      xtype: 'gridcolumn',
      width: 105,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.18"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: false,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("CHECKCYCLE", record.data.VALUE);
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("CHECKCYCLE", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'IMPORTANTNAME',
      text: '중요도',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.19"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: true,
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);

            model.set("IMPORTANTCODE", record.data.VALUE);
          },
          change: function (field, ov, nv, eOpts) {
            var model = Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0].id);
            var result = field.getValue();

            if (ov != nv) {
              if (!isNaN(result)) {
                model.set("IMPORTANTCODE", "");
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
          width: 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table >'
             + '<tr>'
             + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
             + '</tr>'
             + '</table>'
          }
        },
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }
	      
	      return value;
	    },
    }, {
      dataIndex: 'INTERVALCNT',
      text: '간격수',
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
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9.]/,
        selectOnFocus: true,
        listeners: {
          change: function (field, newValue, oldValue, eOpts) {
            var selectedRow = Ext.getCmp(gridnms["views.check"]).getSelectionModel().getCurrentPosition().row;

            Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).getSelectionModel().select(selectedRow));
            var store = Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0];

            var standardvalue = store.data.STANDARDVALUE;
            if (standardvalue != "") {

              var value = field.getValue() * 1;
              var diff = (store.data.MAXVALUE * 1) - (store.data.MINVALUE * 1);
              var checkinterval = 0.0000;
              checkinterval = (value > 0) ? diff / value : diff / 1;
              store.set("CHECKINTERVAL", checkinterval.toFixed(4));
            }

          },
        },
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }

	      return Ext.util.Format.number(value, '0,000');
	    },
    }, {
      dataIndex: 'CHECKINTERVAL',
      text: '검사간격',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000.0000",
      editor: {
        xtype: "textfield",
        minValue: 0,
        format: "0,000.0000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '7',
        maskRe: /[0-9.]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
          
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }

	      return Ext.util.Format.number(value, '0,000.0000');
	    },
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효시작일자',
      xtype: 'datecolumn',
      width: 110,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
      format: 'Y-m-d',
      editor: {
        xtype: 'datefield',
        enforceMaxLength: true,
        maxLength: 10,
        allowBlank: true,
        format: 'Y-m-d',
        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
      },
      renderer: function (value, meta, record) {
          
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }

        return Ext.util.Format.date(value, 'Y-m-d');
	    },
    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효종료일자',
      xtype: 'datecolumn',
      width: 110,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      align: "center",
      format: 'Y-m-d',
      editor: {
        xtype: 'datefield',
        enforceMaxLength: true,
        maxLength: 10,
        allowBlank: true,
        format: 'Y-m-d',
        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
      },
      renderer: function (value, meta, record) {
	      
	      if (record.data.CHECKMASTEREND == "Y") {
	        meta.style = "background-color:rgb(234, 234, 234)";
	      }

        return Ext.util.Format.date(value, 'Y-m-d');
	    },
    },
    // Hidden Columns
    {
      dataIndex: 'CHECKBIG',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKMIDDLE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSMALL',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGNO',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLCREATECODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLCREATENAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'SPECIALCHECK',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKMETHODTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLCREATECODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKCYCLE',
      xtype: 'hidden',
    }, {
      dataIndex: 'IMPORTANTCODE',
      xtype: 'hidden',
    }, ];

  items["api.4"] = {};
  $.extend(items["api.4"], {
    read: "<c:url value='/select/checkmaster/CheckMaster.do' />"
  });

  items["btns.4"] = [];
  items["btns.ctr.4"] = {};
  $.extend(items["btns.ctr.4"], {
    "#itemGrid": {
      itemclick: 'onMyviewItemClick'
    }
  });

  items["dock.btn.4"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.4"],
    items: items["btns.4"],
  };

  items["docked.4"] = [];

  items["api.10"] = {};
  $.extend(items["api.10"], {
    read: "<c:url value='/select/checkmaster/CheckMasterD.do' />"
  });
  $.extend(items["api.10"], {
    create: "<c:url value='/insert/checkmaster/CheckMasterD.do' />"
  });
  $.extend(items["api.10"], {
    update: "<c:url value='/update/checkmaster/CheckMasterD.do' />"
  });
  $.extend(items["api.10"], {
    destroy: "<c:url value='/delete/checkmaster/CheckMasterD.do' />"
  });
  items["btns.10"] = [];
  items["btns.10"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd10"
  });
  items["btns.10"].push({
    xtype: "button",
    text: "삭제",
    itemId: "btnDel10"
  });
  items["btns.10"].push({
    xtype: "button",
    text: "저장",
    itemId: "btnSav10"
  });
  items["btns.10"].push({
    xtype: "button",
    text: "새로고침",
    itemId: "btnRef10"
  });

  items["btns.ctr.10"] = {};
  $.extend(items["btns.ctr.10"], {
    "#btnAdd10": {
      click: 'btnAdd10Click'
    }
  });
  $.extend(items["btns.ctr.10"], {
    "#btnDel10": {
      click: 'btnDel10Click'
    }
  });
  $.extend(items["btns.ctr.10"], {
    "#btnSav10": {
      click: 'btnSav10Click'
    }
  });
  $.extend(items["btns.ctr.10"], {
    "#btnRef10": {
      click: 'btnRef10Click'
    }
  });
  $.extend(items["btns.ctr.10"], {
    "#masterGrid": {
      itemclick: 'onMyviewClick'
    }
  });

  items["dock.btn.10"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.10"],
    items: items["btns.10"],
  };

  items["docked.10"] = [];
  items["docked.10"].push(items["dock.btn.10"]);

}
function onMyviewClick(dataview, record, item, index, e, eOpts) {

  var params1 = {
    ORGID: record.data.ORGID,
    COMPANYID: record.data.COMPANYID,
  };
  extGridSearch(params1, gridnms["store.11"]);

  var params2 = {
    ORGID: record.data.ORGID,
    COMPANYID: record.data.COMPANYID,
    ITEMCODE: record.data.ITEMCODE,
  };
  extGridSearch(params2, gridnms["store.12"]);

  var params3 = {
    ORGID: record.data.ORGID,
    COMPANYID: record.data.COMPANYID,
    BIGCD: record.data.CHECKBIG,
  };
  extGridSearch(params3, gridnms["store.13"]);

  var params4 = {
    ORGID: record.data.ORGID,
    COMPANYID: record.data.COMPANYID,
    ITEMCODE: record.data.ITEMCODE,
    BIGCD: record.data.CHECKBIG,
    MIDDLECD: record.data.CHECKMIDDLE,
  };
  extGridSearch(params4, gridnms["store.14"]);

  selectedItemCode = record.data.ITEMCODE;
  selectedroutingid = record.data.ROUTINGID;
  selectedCheckBig = record.data.CHECKBIG;
  getItemFile();
};

function onMyviewItemClick(dataview, record, item, index, e, eOpts) {
  $("#orgid").val(record.data.ORGID);
  $("#companyid").val(record.data.COMPANYID);
  $("#itemcode").val(record.data.ITEMCODE);
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var itemcode = $('#itemcode').val();

  Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('orgid', orgid);
  Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('companyid', companyid);
  Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('itemcode', itemcode);
  Ext.getStore(gridnms["store.10"]).load();

  selectedItemCode = record.data.ITEMCODE;
  selectedroutingid = record.data.FIRSTROUTINGID;
  selectedCheckBig = record.data.FIRSTCHECKBIG;
  getItemFile();
};

function setExtGrid_Item() {
  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"]
  });

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"]
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"]
  });
  Ext.define(gridnms["model.7"], {
    extend: Ext.data.Model,
    fields: fields["model.7"]
  });

  Ext.define(gridnms["model.10"], {
    extend: Ext.data.Model,
    fields: fields["model.10"]
  });

  Ext.define(gridnms["model.11"], {
    extend: Ext.data.Model,
    fields: fields["model.11"],
  });

  Ext.define(gridnms["model.12"], {
    extend: Ext.data.Model,
    fields: fields["model.12"],
  });

  Ext.define(gridnms["model.13"], {
    extend: Ext.data.Model,
    fields: fields["model.13"],
  });
  Ext.define(gridnms["model.14"], {
    extend: Ext.data.Model,
    fields: fields["model.14"],
  });
  Ext.define(gridnms["model.15"], {
    extend: Ext.data.Model,
    fields: fields["model.15"],
  });
  Ext.define(gridnms["model.16"], {
    extend: Ext.data.Model,
    fields: fields["model.16"],
  });
  Ext.define(gridnms["model.17"], {
    extend: Ext.data.Model,
    fields: fields["model.17"],
  });
  Ext.define(gridnms["model.18"], {
    extend: Ext.data.Model,
    fields: fields["model.18"],
  });
  Ext.define(gridnms["model.19"], {
    extend: Ext.data.Model,
    fields: fields["model.19"],
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
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.4"],
              timeout: gridVals.timeout,
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.5"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.5"],
            model: gridnms["model.5"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'ITEM_TYPE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.6"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.6"],
            model: gridnms["model.6"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'UOM',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.7"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.7"],
            model: gridnms["model.7"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'CUSTOMER_GUBUN',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.10"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.10"],
            model: gridnms["model.10"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.10"],
              timeout: gridVals.timeout,
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.11"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.11"],
            model: gridnms["model.11"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchCheckBigCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.12"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.12"],
            model: gridnms["model.12"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchRoutingItemLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.13"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.13"],
            model: gridnms["model.13"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchCheckMiddleCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.14"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.14"],
            model: gridnms["model.14"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchCheckSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.15"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.15"],
            model: gridnms["model.15"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'QM',
                MIDDLECD: 'SPECIAL_CHECK',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.16"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.16"],
            model: gridnms["model.16"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'QM',
                MIDDLECD: 'CHECK_METHOD_TYPE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.17"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.17"],
            model: gridnms["model.17"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'QM',
                MIDDLECD: 'FML_TYPE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.18"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.18"],
            model: gridnms["model.18"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'QM',
                MIDDLECD: 'CHECK_CYCLE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.19"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.19"],
            model: gridnms["model.19"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'QM',
                MIDDLECD: 'IMPORTANT_CODE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.4"], {
    extend: Ext.app.Controller,
    refs: {
      itemGrid: '#itemGrid',
    },
    stores: [gridnms["store.4"]],
    control: items["btns.ctr.4"],

    onMyviewItemClick: onMyviewItemClick,
  });

  Ext.define(gridnms["controller.10"], {
    extend: Ext.app.Controller,
    refs: {
      masterGrid: '#masterGrid',
    },
    stores: [gridnms["store.10"]],
    control: items["btns.ctr.10"],

    btnAdd10Click: btnAdd10Click,
    btnSav10Click: btnSav10Click,
    btnDel10Click: btnDel10Click,
    btnRef10Click: btnRef10Click,
    onMyviewClick: onMyviewClick

  });

  Ext.define(gridnms["panel.4"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.4"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'rowmodel',
        mode: 'SINGLE',
        ignoreRightMouseSelection: false,
        allowDeselect: false,
        toggleOnClick: false,
        itemId: gridnms["panel.4"],
        id: gridnms["panel.4"],
        store: gridnms["store.4"],
        height: 167,
        border: 2,
        scrollable: true,
        columns: fields["columns.4"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'itemGrid',
          trackOver: true,
          loadMask: true,
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('DRAWINGNO') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 80) {
                    column.width = 80;
                  }
                }
                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
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
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = ctx.record;

                var editDisableCols = [];

                var isNew = ctx.record.phantom || false;
                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                  return false;
                else {
                  return true;
                }
              }
            },
          }, {
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20, // #1
            leadingBufferZone: 20, // #2
            synchronousRender: true,
            numFromEdge: 19,
          }
        ],
        dockedItems: items["docked.4"],
      }
    ],
  });

  Ext.define(gridnms["panel.10"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.10"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.10"],
        id: gridnms["panel.10"],
        store: gridnms["store.10"],
        height: 403,
        border: 2,
        scrollable: true,
        columns: fields["columns.10"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'masterGrid',
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var editDisableCols = [];

                var isNew = ctx.record.phantom || false;
                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                  return false;
                else {
                  return true;
                }
              }
            },
          }
        ],
        dockedItems: items["docked.10"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.item"],
    stores: gridnms["stores.item"],
    views: gridnms["panel.4"],
    controllers: gridnms["controller.4"],

    launch: function () {
      gridItemArea = Ext.create(gridnms["panel.4"], {
          renderTo: 'gridItemArea'
        });
    },
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.check"],
    stores: gridnms["stores.check"],
    views: gridnms["panel.10"],
    controllers: gridnms["controller.10"],

    launch: function () {
      gridMasterArea = Ext.create(gridnms["views.check"], {
          renderTo: 'gridMasterArea'
        });
    },
  });
}

function btnAdd10Click(o, e) {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var itemcode = $('#itemcode').val();
  if (itemcode == "") {
    extAlert("품명을 먼저 선택하여 주십시오.<br/>다시 한번 확인해주세요.");
    return;
  }

  var model = Ext.create(gridnms["model.10"]);
  var store = this.getStore(gridnms["store.10"]);

  //      var sortorder = Ext.getStore(gridnms["store.10"]).count() + 1;
  var sortorder = 0;
  var listcount = Ext.getStore(gridnms["store.10"]).count();
  for (var i = 0; i < listcount; i++) {
    Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).getSelectionModel().select(i));
    var dummy = Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0];

    var dummy_sort = dummy.data.RNUM * 1;
    if (sortorder < dummy_sort) {
      sortorder = dummy_sort;
    }
  }
  sortorder++;

  model.set("RNUM", sortorder);

  model.set("ORGID", orgid);
  model.set("COMPANYID", companyid);
  model.set("ITEMCODE", itemcode);
  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
  model.set("EFFECTIVEENDDATE", "4999-12-31");
  
//   store.insert(Ext.getStore(gridnms["store.10"]).count() + 1, model);
  var view = Ext.getCmp(gridnms['panel.10']).getView();
  var startPoint = 0;

  store.insert(startPoint, model);
  fn_grid_focus_move("UP", gridnms["store.10"], gridnms["views.check"], startPoint, 1);
};

function btnSav10Click(o, e) {
  //   var model = Ext.getStore(gridnms['store.10']).getById(Ext.getCmp(gridnms["panel.10"]).selModel.getSelection()[0].id);
  //   var count = 0;

  //   var check2 = model.get("CHECKBIG") + "";
  //   if (check2.length == 0) {
  //       extAlert("검사구분을 입력하세요.");
  //       count++;
  //   }

  //   var check1 = model.get("CHECKMIDDLE") + "";
  //   if (check1.length == 0) {
  //       extAlert("검사분류를 입력하세요.");
  //       count++;
  //   }

  //   var check = model.get("CHECKSMALL") + "";
  //   if (check.length == 0) {
  //       extAlert("검사기준을 입력하세요.");
  //       count++;
  //   }

  var count1 = Ext.getStore(gridnms["store.10"]).count();
  var header = [],
  count = 0;

  if (count1 > 0) {
    for (i = 0; i < count1; i++) {
      Ext.getStore(gridnms["store.10"]).getById(Ext.getCmp(gridnms["views.check"]).getSelectionModel().select(i));
      var model10 = Ext.getCmp(gridnms["views.check"]).selModel.getSelection()[0];

      var checkbig = model10.data.CHECKBIG;
      var checkmiddle = model10.data.CHECKMIDDLE;
      var checksmall = model10.data.CHECKSMALL;
      var startdate = model10.data.EFFECTIVESTARTDATE;
      var enddate = model10.data.EFFECTIVEENDDATE;
      //         var equipmentcode = model1.data.EQUIPMENTCODE;
      //         var moldcode = model1.data.MOLDCODE;

      if (checkbig == "" || checkbig == undefined) {
        header.push("검사구분");
        count++;
      }

      if (checkmiddle == "" || checkmiddle == undefined) {
        header.push("검사분류");
        count++;
      }

      if (checksmall == "" || checksmall == undefined) {
        header.push("검사기준");
        count++;
      }

      if (startdate == "" || startdate == undefined) {
        header.push("시작일자");
        count++;
      }
      if (enddate == "" || enddate == undefined) {
        header.push("종료일자");
        count++;
      }

      if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
        return;
      }
    }
  } else {
    extAlert("[저장] 저장 할 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
    return;
  }

  // 저장
  if (count == 0) {
    Ext.getStore(gridnms["store.10"]).sync({
      success: function (batch, options) {
        extAlert(msgs.noti.save, gridnms["store.10"]);

        var orgid = $('#orgid').val();
        var companyid = $('#companyid').val();
        var itemcode = $('#itemcode').val();

        Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('orgid', orgid);
        Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('companyid', companyid);
        Ext.getStore(gridnms["store.10"]).proxy.setExtraParam('itemcode', itemcode);
        Ext.getStore(gridnms["store.10"]).load();
      },
      failure: function (batch, options) {
        extAlert(batch.exceptions[0].error, gridnms["store.10"]);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnDel10Click(o, e) {
  extGridDel(gridnms["store.10"], gridnms["views.check"]);
};

function btnRef10Click(o, e) {
  Ext.getStore(gridnms["store.10"]).load();
};

// 자재불러오기 팝업
function setValues_Popup() {
  gridnms["models.popup1"] = [];
  gridnms["stores.popup1"] = [];
  gridnms["views.popup1"] = [];
  gridnms["controllers.popup1"] = [];

  gridnms["models.popup2"] = [];
  gridnms["stores.popup2"] = [];
  gridnms["views.popup2"] = [];
  gridnms["controllers.popup2"] = [];

  gridnms["grid.40"] = "Popup1";
  gridnms["grid.44"] = "Popup2"; // 입고검사 세부 항목 LIST

  gridnms["panel.40"] = gridnms["app"] + ".view." + gridnms["grid.40"];
  gridnms["views.popup1"].push(gridnms["panel.40"]);

  gridnms["panel.44"] = gridnms["app"] + ".view." + gridnms["grid.44"];
  gridnms["views.popup2"].push(gridnms["panel.44"]);

  gridnms["controller.40"] = gridnms["app"] + ".controller." + gridnms["grid.40"];
  gridnms["controllers.popup1"].push(gridnms["controller.40"]);

  gridnms["controller.44"] = gridnms["app"] + ".controller." + gridnms["grid.44"];
  gridnms["controllers.popup2"].push(gridnms["controller.44"]);

  gridnms["model.40"] = gridnms["app"] + ".model." + gridnms["grid.40"];

  gridnms["model.44"] = gridnms["app"] + ".model." + gridnms["grid.44"];

  gridnms["store.40"] = gridnms["app"] + ".store." + gridnms["grid.40"];
  gridnms["store.44"] = gridnms["app"] + ".store." + gridnms["grid.44"];

  gridnms["models.popup1"].push(gridnms["model.40"]);
  gridnms["models.popup2"].push(gridnms["model.44"]);

  gridnms["stores.popup1"].push(gridnms["store.40"]);
  gridnms["stores.popup2"].push(gridnms["store.44"]);

  fields["model.40"] = [{
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
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'ITEMNAME',
    }, {
      type: 'string',
      name: 'ITEMTYPE',
    }, {
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'string',
      name: 'CARTYPE',
    }, {
      type: 'string',
      name: 'CARTYPENAME',
    }, {
      type: 'string',
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
    }, ];

  fields["model.44"] = [{
      type: 'number',
      name: 'RNUM',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'number',
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
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGNO',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
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
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'number',
      name: 'CHECKQTY',
    }, {
      type: 'number',
      name: 'ORDERNO',
    }, {
      type: 'string',
      name: 'SPECIALCHECK',
    }, {
      type: 'string',
      name: 'SPECIALCHECKNAME',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPE',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPENAME',
    }, {
      type: 'string',
      name: 'FMLCREATECODE',
    }, {
      type: 'string',
      name: 'FMLCREATENAME',
    }, {
      type: 'string',
      name: 'CHECKCYCLE',
    }, {
      type: 'string',
      name: 'CHECKCYCLENAME',
    }, {
      type: 'string',
      name: 'CHECKINTERVAL',
    }, {
      type: 'string',
      name: 'INTERVALCNT',
    }, {
      type: 'string',
      name: 'EXTSTANDARD',
    }, {
      type: 'string',
      name: 'IMPORTANTCODE',
    }, {
      type: 'string',
      name: 'IMPORTANTNAME',
    },
  ];

  fields["columns.40"] = [{
      dataIndex: 'RN',
      text: '순번',
      xtype: 'gridcolumn',
      width: 55,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      //     }, {
      //       dataIndex: 'ITEMCODE',
      //       text: '품목',
      //       xtype: 'gridcolumn',
      //       width: 130,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       menuDisabled: true,
      //       style: 'text-align:center;',
      //       align: "center",
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 100,
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
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "left",
    }, {
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 350,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "left",
    }, {
      dataIndex: 'CARTYPENAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
    }, {
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
    }, {
      menuDisabled: true,
      sortable: false,
      resizable: false,
      xtype: 'widgetcolumn',
      stopSelection: true,
      width: 70,
      text: '적용',
      style: 'text-align:center',
      align: "center",
      widget: {
        xtype: 'button',
        _btnText: "적용",
        defaultBindProperty: null, //important
        handler: function (widgetColumn) {
          var record = widgetColumn.getWidgetRecord();

          var orgid = record.data.ORGID;
          var companyid = record.data.COMPANYID;
          var itemcode = record.data.ITEMCODE;
          var params = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: itemcode,
          };

          extGridSearch(params, gridnms["store.44"]);

          setTimeout(function () {

            var count40 = Ext.getStore(gridnms["store.40"]).count();
            var checknum = 0,
            checkqty = 0,
            checktemp = 0;
            var qtytemp = [];

            if (count40 == 0) {
              console.log("[적용] 품목 정보가 없습니다.");
            } else {
              var temp_item = null,
              temp_price = 0,
              temp_stand = null;

              checktemp++;
              popcount++;
              var count = Ext.getStore(gridnms["store.10"]).count();
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
                extAlert("해당 품목에 대해서 검사기준정보가 등록 되어있지 않습니다. <br/>해당 품목의 검사기준정보를 다시 확인해주십시오.");
                return false;
              }

              if (count44 == 0) {
                console.log("[적용] 검사기준정보 정보가 없습니다.");
              } else {
                for (var j = 0; j < count44; j++) {
                  Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(j));
                  var model44 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                  var chk = true; //model44.data.CHK;

                  if (chk === true) {
                    var model = Ext.create(gridnms["model.10"]);
                    var store = Ext.getStore(gridnms["store.10"]);

                    // 순번
                    model.set("RN", Ext.getStore(gridnms["store.10"]).count() + 1);

                    model.set("ORGID", model44.data.ORGID);
                    model.set("COMPANYID", model44.data.COMPANYID);
                    //                     model.set("CHECKSEQ", model44.data.CHECKSEQ);
//                     model.set("ITEMCODE", model44.data.ITEMCODE);
                    model.set("ITEMCODE", selectedItemCode);
                    model.set("CHECKBIG", model44.data.CHECKBIG);
                    model.set("CHECKBIGNAME", model44.data.CHECKBIGNAME);
                    model.set("CHECKMIDDLE", model44.data.CHECKMIDDLE);
                    model.set("CHECKMIDDLENAME", model44.data.CHECKMIDDLENAME);
                    model.set("CHECKSMALL", model44.data.CHECKSMALL);
                    model.set("CHECKSMALLNAME", model44.data.CHECKSMALLNAME);
                    //                     model.set("ROUTINGID", model44.data.ROUTINGID);
                    //                     model.set("ROUTINGNO", model44.data.ROUTINGNO);
                    //                     model.set("ROUTINGNAME", model44.data.ROUTINGNAME);
                    model.set("CHECKUOM", model44.data.CHECKUOM);
                    model.set("CHECKUOMNAME", model44.data.CHECKUOMNAME);
                    model.set("STANDARDVALUE", model44.data.STANDARDVALUE);
                    model.set("MINVALUE", model44.data.MINVALUE);
                    model.set("MAXVALUE", model44.data.MAXVALUE);

                    model.set("CHECKQTY", model44.data.CHECKQTY);
                    model.set("ORDERNO", model44.data.ORDERNO);
                    model.set("SPECIALCHECK", model44.data.SPECIALCHECK);
                    model.set("SPECIALCHECKNAME", model44.data.SPECIALCHECKNAME);
                    model.set("CHECKMETHODTYPE", model44.data.CHECKMETHODTYPE);
                    model.set("CHECKMETHODTYPENAME", model44.data.CHECKMETHODTYPENAME);
                    model.set("FMLCREATECODE", model44.data.FMLCREATECODE);
                    model.set("FMLCREATENAME", model44.data.FMLCREATENAME);
                    model.set("CHECKSTANDARD", model44.data.CHECKSTANDARD);
                    model.set("CHECKCYCLE", model44.data.CHECKCYCLE);
                    model.set("CHECKCYCLENAME", model44.data.CHECKCYCLENAME);
                    model.set("CHECKINTERVAL", model44.data.CHECKINTERVAL);
                    model.set("INTERVALCNT", model44.data.INTERVALCNT);
                    model.set("EXTSTANDARD", model44.data.EXTSTANDARD);
                    model.set("IMPORTANTCODE", model44.data.IMPORTANTCODE);
                    model.set("IMPORTANTNAME", model44.data.IMPORTANTNAME);
                    var today = new Date();
                    var start = Ext.util.Format.date(today, 'Y-m-d');
                    model.set("EFFECTIVESTARTDATE", start);
                    model.set("EFFECTIVEENDDATE", '4999-12-31');

                    //                     store.add(model);
                    store.insert(Ext.getStore(gridnms["store.10"]).count() + 1, model);

                    checktemp++;
                    popcount++;
                  }
                }

                Ext.getCmp(gridnms["panel.10"]).getView().refresh();
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
            widgetColumn.setText(widgetColumn._btnText);
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
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOMNAME',
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
    }, ];

  fields["columns.44"] = [{
      dataIndex: 'RN',
      text: '순번',
      xtype: 'gridcolumn',
      width: 55,
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
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
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
        dataIndex: 'ORDERNO',
        text: '검사<br/>순번',
        xtype: 'gridcolumn',
        width: 55,
        hidden: false,
        sortable: true,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        format: "0,000",
    }, {
        dataIndex: 'UOMNAME',
        text: '검사<br/>단위',
        xtype: 'gridcolumn',
        width: 70,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'CHECKSTANDARD',
        text: '검사내용',
        xtype: 'gridcolumn',
        width: 350,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
    }, {
        dataIndex: 'STANDARDVALUE',
        text: '검사기준',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'MINVALUE',
        text: '허용치<br/>(하한)',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000.000",
    }, {
        dataIndex: 'MAXVALUE',
        text: '허용치<br/>(상한)',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000.000",
    }, {
        dataIndex: 'EXTSTANDARD',
        text: '규정',
        xtype: 'gridcolumn',
        width: 350,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
    }, {
        dataIndex: 'CHECKQTY',
        text: '검사수',
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
    }, {
        dataIndex: 'SPECIALCHECKNAME',
        text: '관리<br/>구분',
        xtype: 'gridcolumn',
        width: 70,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'CHECKMETHODTYPENAME',
        text: '검사방법',
        xtype: 'gridcolumn',
        width: 150,
        hidden: false,
        sortable: false,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'CHECKCYCLENAME',
        text: '검사주기',
        xtype: 'gridcolumn',
        width: 105,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'IMPORTANTNAME',
        text: '중요도',
        xtype: 'gridcolumn',
        width: 70,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
    }, {
        dataIndex: 'INTERVALCNT',
        text: '간격수',
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
    }, {
        dataIndex: 'CHECKINTERVAL',
        text: '검사간격',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000.0000",
    }, {
        dataIndex: 'EFFECTIVESTARTDATE',
        text: '유효시작일자',
        xtype: 'datecolumn',
        width: 110,
        hidden: false,
        sortable: true,
        resizable: false,
        menuDisabled: true,
        align: "center",
        format: 'Y-m-d',
    }, {
        dataIndex: 'EFFECTIVEENDDATE',
        text: '유효종료일자',
        xtype: 'datecolumn',
        width: 110,
        hidden: false,
        sortable: true,
        resizable: false,
        menuDisabled: true,
        align: "center",
        format: 'Y-m-d',
    },
    // Hidden Columns
    {
        dataIndex: 'CHECKBIG',
        xtype: 'hidden',
      }, {
        dataIndex: 'CHECKMIDDLE',
        xtype: 'hidden',
      }, {
        dataIndex: 'CHECKSMALL',
        xtype: 'hidden',
      }, {
        dataIndex: 'ITEMCODE',
        xtype: 'hidden',
      }, {
        dataIndex: 'ROUTINGID',
        xtype: 'hidden',
      }, {
        dataIndex: 'ROUTINGNO',
        xtype: 'hidden',
      }, {
        dataIndex: 'FMLCREATECODE',
        xtype: 'hidden',
      }, {
        dataIndex: 'FMLCREATENAME',
        xtype: 'hidden',
      }, {
        dataIndex: 'CHECKSEQ',
        xtype: 'hidden',
      }, {
        dataIndex: 'ORGID',
        xtype: 'hidden',
      }, {
        dataIndex: 'COMPANYID',
        xtype: 'hidden',
      }, {
        dataIndex: 'UOM',
        xtype: 'hidden',
      }, {
        dataIndex: 'SPECIALCHECK',
        xtype: 'hidden',
      }, {
        dataIndex: 'CHECKMETHODTYPE',
        xtype: 'hidden',
      }, {
        dataIndex: 'FMLCREATECODE',
        xtype: 'hidden',
      }, {
        dataIndex: 'CHECKCYCLE',
        xtype: 'hidden',
      }, {
        dataIndex: 'IMPORTANTCODE',
        xtype: 'hidden',
    }, ];

  items["api.40"] = {};
  $.extend(items["api.40"], {
    read: "<c:url value='/checkmaster/CheckmasterPop.do' />"
  });

  items["btns.40"] = [];

  items["btns.ctr.40"] = {};
  $.extend(items["btns.ctr.40"], {
    "#btnPopup1": {
      itemclick: 'onMypopClick'
    }
  });

  items["dock.paging.40"] = {
    xtype: 'pagingtoolbar',
    dock: 'bottom',
    displayInfo: true,
    store: gridnms["store.40"],
  };

  items["dock.btn.40"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.40"],
    items: items["btns.40"],
  };

  items["docked.40"] = [];

  items["api.44"] = {};
  $.extend(items["api.44"], {
    read: "<c:url value='/checkmaster/CheckmasterPopCheck.do' />"
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

var gridpopup1;
function setExtGrid_Popup() {

  Ext.define(gridnms["model.40"], {
    extend: Ext.data.Model,
    fields: fields["model.40"],
  });

  Ext.define(gridnms["model.44"], {
    extend: Ext.data.Model,
    fields: fields["model.44"],
  });

  Ext.define(gridnms["store.40"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.40"],
            model: gridnms["model.40"],
            autoLoad: false,
            pageSize: 999999,
            proxy: {
              type: 'ajax',
              api: items["api.40"],
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
            autoLoad: false,
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

  Ext.define(gridnms["controller.40"], {
    extend: Ext.app.Controller,
    refs: {
      btnPopup1: '#btnPopup1',
    },
    stores: [gridnms["store.40"]],
    control: items["btns.ctr.40"],
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

  Ext.define(gridnms["panel.40"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.40"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.40"],
        id: gridnms["panel.40"],
        store: gridnms["store.40"],
        height: 360,
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
        columns: fields["columns.40"],
        viewConfig: {
          itemId: 'btnPopup1',
          trackOver: true,
          loadMask: true,
        },
        dockedItems: items["docked.40"],
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
    controllers: gridnms["controller.40"],

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
function fn_copy(val) {
  var header = [],
  count = 0;
  var dataSuccess = 0;
  var result = null;

  var chk = val;

  // 검사기준 정보 복사 팝업
  var width = 1158; // 가로
  var height = 440; // 500; // 세로
  var title = "검사기준 정보 복사 popup &nbsp;&nbsp;&nbsp;&nbsp;  [검사기준정보가 등록되어져 있는 품목만 조회가 됩니다.]";

  var check = true;

  popupclick = 0;
  if (check == true) {
    // 데이터가 없는 상태에서만 팝업 표시하도록 처리
    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    $('#popupItemCodeOLD').val(chk.ITEMCODE);
    $('#popupCarTypeName').val(/*chk.MODELNAME*/);
    $('#popupDrawingNo').val(/*chk.DRAWINGNO*/);
    $('#popupCustomerGubunName').val(/*chk.CUSTOMERGUBUNNAME*/);
    Ext.getStore(gridnms['store.40']).removeAll();

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
            itemId: gridnms["panel.40"],
            id: gridnms["panel.40"],
            store: gridnms["store.40"],
            height: '100%',
            border: 2,
            scrollable: true,
            frameHeader: true,
            columns: fields["columns.40"],
            defaults: gridVals.defaultField,
            viewConfig: {
              itemId: 'btnPopup1'
            },
            plugins: 'bufferedrenderer',
            dockedItems: items["docked.40"],
          }
        ],
        tbar: [
          //           '품목', {
          //             xtype: 'textfield',
          //             name: 'searchItemCode',
          //             clearOnReset: true,
          //             hideLabel: true,
          //             width: 100,
          //             editable: true,
          //             allowBlank: true,
          //             listeners: {
          //               scope: this,
          //               buffer: 50,
          //               change: function (value, nv, ov, e) {
          //                 value.setValue(nv.toUpperCase());
          //                 var result = value.getValue();

          //                 $('#popupItemCode').val(result);
          //               },
          //             },
          //           },
          '품번', {
            xtype: 'textfield',
            name: 'searchOrderName',
            clearOnReset: true,
            hideLabel: true,
            width: 100,
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
          '도번', {
            xtype: 'textfield',
            name: 'searchDrawingNo',
            clearOnReset: true,
            hideLabel: true,
            width: 100,
            editable: true,
            allowBlank: true,
            listeners: {
              scope: this,
              buffer: 50,
              change: function (value, nv, ov, e) {
                value.setValue(nv.toUpperCase());
                var result = value.getValue();

                $('#popupDrawingNo').val(result);
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
          },
          '기종', {
            xtype: 'textfield',
            name: 'searchCarTypeName',
            clearOnReset: true,
            hideLabel: true,
            width: 100,
            editable: true,
            allowBlank: true,
            listeners: {
              scope: this,
              buffer: 50,
              change: function (value, nv, ov, e) {
                value.setValue(nv.toUpperCase());
                var result = value.getValue();

                $('#popupCarTypeName').val(result);
                if (isNaN(result)) {
                  $('#popupCarTypeName').val("");
                }
              },
            },
          },
          '거래처', {
            xtype: 'textfield',
            name: 'searchCustomerGubunName1',
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

                $('#popupCustomerGubunName').val(result);
              },
            },
          }, '->', {
            text: '조회',
            scope: this,
            handler: function () {
              var sparams3 = {
                ORGID: $('#popupOrgId').val(),
                COMPANYID: $('#popupCompanyId').val(),
                ITEMNAME: $('#popupItemName').val(),
                DRAWINGNO: $('#popupDrawingNo').val(),
                ORDERNAME: $('#popupOrderName').val(),
                CARTYPENAME: $('#popupCarTypeName').val(),
                CUSTOMERNAME: $('#popupCustomerGubunName').val(),
              };

              extGridSearch(sparams3, gridnms["store.40"]);
            }
          },
        ]
      });

    win1.show();
        $('input[name=searchCarTypeName]').val($('#popupCarTypeName').val());
    $('input[name=searchCustomerGubunName1]').val($('#popupCustomerGubunName').val());
  }
}

function onMypopClick(dataview, record, item, index, e, eOpts) {
  $("#popupItemcodeD").val(record.get("ITEMCODE"));
  $('#popupOrgId').val($('#searchOrgId option:selected').val());
  $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
  var orgid = $('#popupOrgId').val();
  var companyid = $('#popupCompanyId').val();
  var itemcode = $('#popupItemcodeD').val();

  var params = {
    ITEMCODE: itemcode,
    ORGID: orgid,
    COMPANYID: companyid,
  };

  extGridSearch(params, gridnms["store.44"]);
}

function fn_search() {
  var orgid = $('#searchOrgId option:selected').val();
  var companyid = $('#searchCompanyId option:selected').val();
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
    return;
  }

  var sparams = {
    orgid: $("#searchOrgId").val() + "",
    companyid: $("#searchCompanyId").val() + "",
    itemcode: $("#searchItemCode").val() + "",
    itemname: $("#searchItemName").val() + "",
    ordername: $("#searchOrderName").val() + "",
    ITEMTYPE: $('#searchItemType').val(),
    modelname: $("#searchModelName").val() + "",
    customer: $("#searchCustomerCode").val() + "",
    ITEMCHECK: $('#searchItemCheck').val(),
    GROUPCODE: $("#searchGroupCode option:selected").val(),
    BIGCODE: $('#searchBigcd').val(),
  };

  extGridSearch(sparams, gridnms["store.4"]);
  setTimeout(function () {
    extGridSearch(sparams, gridnms["store.10"]);
  }, 200);

  gubun = "Image1";
  selectedItemCode = "";
  selectedroutingid = "";
  selectedCheckBig = "";
  getItemFile();
}

function setLovList() {
  // 대분류 Lov
  $("#searchBignm")
  .bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      $("#searchGroupCode").val("");
      $("#searchBigcd").val("");
      //          $("#searchBignm").val("");

      var itemcd = $('#searchItemCode').val();
      if (itemcd != "") {
        $("#searchItemCode").val("");
        $("#searchItemName").val("");
        $("#searchOrderName").val("");
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
      $.getJSON("<c:url value='/searchBigClassListLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        ITEMTYPE: $('#searchItemType').val(),
        GUBUN: "TOTAL",
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.LABEL,
              value: m.VALUE,
              GROUPCODE: m.GROUPCODE,
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
      $("#searchGroupCode").val(o.item.GROUPCODE);
      $("#searchBigcd").val(o.item.value);
      $("#searchBignm").val(o.item.label);

      var itemcd = $('#searchItemCode').val();
      if (itemcd != "") {
        $("#searchItemCode").val("");
        $("#searchItemName").val("");
        $("#searchOrderName").val("");
      }

      return false;
    }
  });

  // 거래처명 lov
  $("#searchCustomerName").bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      //             $("#searchCustomerName").val("");
      $("#searchCustomerCode").val("");

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
        CUSTOMERTYPE: 'A',
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              value: m.VALUE,
              label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
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
      $("#searchCustomerCode").val(o.item.value);
      $("#searchCustomerName").val(o.item.NAME);

      return false;
    }
  });
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
                            <li>기준정보</li>
                            <li>&gt;</li>
                            <li><strong>${pageTitle}</strong></li>
                        </ul>
                    </div>
                </div>
                <input type="hidden" id="popupItemCodeD" />
                <input type="hidden" id="popupItemCodeOLD" />
                <input type="hidden" id="popupOrgId" name="popupOrgId" />
                <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                <input type="hidden" id="popupItemCode" name="popupItemCode" />
                <input type="hidden" id="popupItemName" name="popupItemName" />
                <input type="hidden" id="popupOrderName" name="popupOrderName" />
                <input type="hidden" id="popupModelName" name="popupModelName" />
                <input type="hidden" id="popupCustomerGubunName" name="popupCustomerGubunName" />
                <input type="hidden" id="popupDrawingNo" name="popupDrawingNo" />
                <input type="hidden" id="popupCarTypeName" name="popupCarTypeName" />
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field" style="margin-bottom: 0px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <input type="hidden" id="orgid" name="orgid" />
                    <input type="hidden" id="companyid" name="companyid" />
                    <input type="hidden" id="itemcode" name="itemcode" />
                    <input type="hidden" id="routingid" name="routingid" />
                    <input type="hidden" id="searchGroupCode" name="searchGroupCode" />
                    <fieldset>
                        <legend>조건정보 영역</legend>
                        <div>
                            <table class="tbl_type_view" border="1">
                                <colgroup>
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col width="10%">
                                    <col width="20%">
                                    <col>
                                </colgroup>
                                <tr>
                                    <th class="required_text">사업장</th>
                                    <td>
                                    <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 97%;">
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
                                    <th class="required_text">공장</th>
                                    <td>
                                    <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 97%;">
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
                                    <th class="required_text">유형</th>
                                    <td>
                                    <select id="searchItemType" name="searchItemType" class="input_left validate[required]" style="width: 97%;">
                                        <c:if test="${empty searchVO.ITEMTYPE}">
                                            <option value="">전체</option>
                                        </c:if>
                                        <c:forEach var="item" items="${labelBox.findByItemType}" varStatus="status">
                                            <c:choose>
                                                <c:when test="${item.VALUE==searchVO.ITEMTYPE}">
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
                                            <div class="buttons" style="float: right;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">대분류</th>
                                    <td>
                                          <input type="text" id="searchBignm" name="searchBignm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                          <input type="hidden" id="searchBigcd" name="searchBigcd" />
                                    </td>
                                    <th class="required_text">품번</th>
                                    <td>
                                    <input type="text" id="searchOrderName" name="searchOrderName" class="input_left" style="width: 97%;" /></td>
                                    <th class="required_text">품명</th>
                                    <td>
                                    <input type="text" id="searchItemName" name="searchItemName" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                    <input type="hidden" id="searchItemCode" name="searchItemCode" />
                                    </td>
                                    <td></td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">기종</th>
                                    <td>
                                        <input type="text" id="searchModelName" name="searchModelName" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                    </td>
                                    <th class="required_text">거래처</th>
                                    <td>
                                    <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left" style="width: 97%;" />
                                    <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
                                    </td>
                                    <th class="required_text">등록여부</th>
                                    <td>
                                    <select id="searchItemCheck" name="searchItemCheck" class="input_left validate[required]" style="width: 97%;">
                                        <c:if test="${empty searchVO.STATUS}">
                                            <option value="">전체</option>
                                            <option value="Y">검사기준 등록</option>
                                            <option value="N">검사기준 미등록</option>
                                        </c:if>
                                    </select>
                                    </td>
                                    <td></td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">품목마스터</div></td>
                        </tr>
                    </table>
                    <div id="gridItemArea" style="width: 100%; padding-bottom: 0px; float: left;"></div>
                    <table style="width: 100%;">
                        <colgroup>
                            <col width="67%">
                            <col width="5%">
                            <col width="28%">
                        </colgroup>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="subConTit3" style="margin-top: 40px; float: left;">검사 기준 정보</div>
                                </td>
                                <td>
                                    <div class="subConTit3" style="margin-top: 40px; float: left;">이미지</div>
                                </td>
                                <td>
                                    <div class="buttons" style="float: left; margin-top: 3px; margin-bottom: 3px;">
                                        <a id="btnChk3" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image1');" style="margin-bottom: 3px;">작업표준서</a>
                                        <a id="btnChk4" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image5');">공정도</a>
                                        <a id="btnChk6" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image3');" style="margin-bottom: 3px;">약도</a>
                                        <a id="btnChk2" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image4');" style="margin-bottom: 3px;">도면</a>
                                        <br />
                                        <a id="btnChk5" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image2');" style="margin-bottom: 3px;">Q포인트</a>
                                        <a id="btnChk7" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image6');">공구</a>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="gridMasterArea" style="width: 66%; padding-bottom: 5px; float: left;"></div>
                    <div style="width: 33%; height: 404px; border: 2px solid #81B1D5; float: left; margin-left: 1%; margin-bottom: 4px;">
                        <form id="fileform" name="fileform" data-upload-template-id="fileform" class="fileupload" method="POST" action='<c:url value="/itemfile/upload.do" />' enctype="multipart/form-data" data-file-upload="options" data-ng-controller="FileUploadController">
                            <div id="fileBox" style="height: auto; width: 100%;">
                                <div id="fileBtnBox" style="width: 100%; height: auto;">
                                    <div class="row" style="margin-top: 183px; text-align: center;">
                                        <span class="btn btn-success fileinput-button"> <span>파일추가</span> <input type="file" name="FILE" class="multi with-preview" accept="gif|jpg|png" />
                                        </span>
                                    </div>
                                </div>
                                <table id="filetable" class="table table-striped files ng-cloak" style="width: 100%;">
                                    <tr data-ng-repeat="file in queue">
                                        <td data-ng-switch data-on="!!file.thumbnailUrl" width="100px" style="vertical-align: middle;">
                                            <div class="preview" data-ng-switch-when="true">
                                                <a data-ng-href="{{file.url}}" title="{{file.name}}" download="{{file.name}}" data-gallery><img data-ng-src="{{file.thumbnailUrl}}" alt=""></a>
                                            </div>
                                            <div class="preview" data-ng-switch-default data-file-upload-preview="file"></div>
                                        </td>
                                        <td width="30%" style="vertical-align: middle;">
                                            <p class="name" data-ng-switch data-on="!!file.url">
                                                <span data-ng-switch-default>{{file.name}}</span>
                                            </p>
                                            <p class="size">{{file.size | formatFileSize}}</p>
                                        </td>
                                        <td style="vertical-align: middle;">
                                            <button type="button" class="btn_cancel" data-ng-click="file.$cancel()" data-ng-hide="!file.$cancel" style="margin-bottom: 5px;">취&nbsp;&nbsp;소</button>
                                            <button type="button" class="btn_upload" data-ng-click="file.$submit()" data-ng-hide="!file.$submit || options.autoUpload" data-ng-disabled="file.$state() == 'pending' || file.$state() == 'rejected'">업로드</button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <div id="gridPopup1Area" style="width: 1145px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup2Area" style="width: 900px; padding-top: 0px; float: left;"></div>

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