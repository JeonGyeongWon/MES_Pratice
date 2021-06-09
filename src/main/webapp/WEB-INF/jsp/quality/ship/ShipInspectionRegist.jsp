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
var Cnt = 0;
var selectedPrno = "";
var filetype = "quality", gubun = "ship";
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setReadOnly();
  setLovList();

  var shipno = $('#shipno').val();
  var shipseq = $('#shipseq').val();
  if (shipno != "" && shipseq != "") {
    fn_search();
  }

  $('#searchOrgId, #searchCompanyId').change(function (event) {});

  $('#ShipQty').keyup(function (event) {

    if (event.keyCode >= '48' && event.keyCode <= '57') {
      var shipqty = this.value;
      var detailqty = $('#DetailQty').val() * 1;
      //             var shipqty = $('#ShipQty').val() * 1;

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
      //         var faultqty = $('#FaultQty').val() * 1;

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
});

function setInitial() {
  // 최초 상태 설정
  gridnms["app"] = "order";

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

//   $("#fileform")
//   .bind('fileuploadsubmit', function (e, data) {
//     data.formData = {
//       itemcd: selectedPrno,
//       filetype: filetype,
//       gubun: (gubun === "") ? "ship" : gubun
//     };
//   })
//   .bind('fileuploadadd', function (e, data) {
//     selectedPrno = $('#ShipNo').val() + "-" + $('#ShipSeq').val();

//     if (selectedPrno === "") {
//       extAlert("출하번호가 없습니다.");
//       return false;
//     }

//     Cnt++;
//     setTimeout(function () {
//       var $filetable = $("#filetable").find("tr");
//       var size = $filetable.length;
//       for (var i = 0; i < (size - 1); i++) {
//         $filetable.eq(i).remove();
//       }
//       setTimeout(function () {
//         $("#filetable").click();
//       }, 120);
//     }, 88);
//   })
//   .bind('fileuploadfail', function (e, data) {
//     Cnt--;
//   });
}

function fn_file_submit() {
  var Cnt = 0;
  selectedPrno = $('#ShipNo').val() + "-" + $('#ShipSeq').val();

  Cnt = $("div[id^=fileBox_]").length;
  //       console.log("CNT : " + Cnt);
  $("#fileform")
  .bind('fileuploadsubmit', function (e, data) {
    data.formData = {
      itemcd: selectedPrno,
      filetype: filetype,
      gubun: (gubun === "") ? "ship" : gubun
    };
  })
  .bind('fileuploadadd', function (e, data) {
    selectedPrno = $('#ShipNo').val() + "-" + $('#ShipSeq').val();
    if (selectedPrno === "") {
      extAlert("출하번호가 없습니다.");
      return false;
    }

    Cnt++;
    setTimeout(function () {
      var $filetable = $("#filetable").find("tr");
      var size = $filetable.length;
      for (var i = 0; i < (size - 1); i++) {
        $filetable.eq(i).remove();
      }
      setTimeout(function () {
        $("#filetable").click();
      }, 120);
    }, 88);
  })
}

function getItemFile() {
  selectedPrno = $('#ShipNo').val() + "-" + $('#ShipSeq').val();
  $("div[id^=fileBox_]").remove();
  $("#filetable").find(".cancel").click();
  $("#filetable").find("tr").remove();
  $.ajax({
    url: "<c:url value='/itemfile/select.do' />",
    type: "post",
    dataType: "json",
    data: {
      itemcd: selectedPrno,
      filetype: filetype,
      gubun: gubun
    },
    success: function (data) {
      var wth = $("#fileBox").width();
      var hgt = $("#fileBox").height();
      $.each(data, function (i, m) {
        var html = '';
        html += '<div id="fileBox_' + m.fileid + '" >';
        html += '<span style="width: 800px; height: 25px; float: left; padding-left: 7px; padding-top: 3px;"><a href="' + m.filepathview + m.filenmreal + '" download="' + m.filenmview + '">' + m.filenmview + '</a></span>';
        html += '<button class="btn btn-danger destroy ng-scope" href="#" onclick="javascript:fn_file_delete(\'' + m.fileid + '\'); return false;" style="float: left; padding-left: 7px !important; padding-top: 0px !important; height: 18px !important; font-size: 10px !important; margin-top: 4px; padding-bottom: 0px;padding-right: 8px;">삭제</button>';
        html += '</div>';
        $("#fileBox").append(html);
      });
      Cnt = $("div[id^=fileBox_]").length;
    },
    error: ajaxError
  });
}

function fn_file_delete(fileid) {
  selectedPrno = $('#ShipInsNo').val();
  if (!confirm("삭제하시겠습니까?\n삭제 시 파일은 즉시 제거됩니다."))
    return;
  $.ajax({
    url: "<c:url value='/file/delete.do' />",
    type: "post",
    dataType: "json",
    data: {
      fileid: fileid,
      itemcd: selectedPrno,
      gubun: gubun
    },
    success: function (data) {
      if (data.success) {
        $("#fileBox_" + fileid).remove();
        Cnt--;
      } else {
        alert("삭제 실패하였습니다.");
      }
    },
    error: ajaxError
  });
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  gridnms["models.detail"] = [];
  gridnms["stores.detail"] = [];
  gridnms["views.detail"] = [];
  gridnms["controllers.detail"] = [];

  gridnms["grid.1"] = "ShipInspectionDetail";
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
      type: 'number',
      name: 'SHIPINSPECTIONNO',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'number',
      name: 'CHECKLISTID',
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
      enableFocusableContainer: false,
      tdCls: 'x1',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        allowBlank: true,
        listeners: {
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {

              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
              var max = model.data.MAXVALUE;
              var min = model.data.MINVALUE;
              var standardvalue = model.data.STANDARDVALUE; // 검사기준값
              var checkqty = model.data.CHECKQTY * 1; // 시료수
              var value = field.getValue(); // X1
              var qty_check = false; // 시료수 체크
              var input_check = false; // 입력 / 미입력 체크
              var msg = "",
              result_check = false;

              // 검사 값
              const X1 = field.getValue(),
              X2 = model.data.CHECKRESULT2,
              X3 = model.data.CHECKRESULT3,
              X4 = model.data.CHECKRESULT4,
              X5 = model.data.CHECKRESULT5;

              // 1. 시료수 범위 체크
              switch (checkqty) {
              case 1:
              case 2:
              case 3:
              case 4:
              case 5:
                msg = "입력이 가능합니다.";
                qty_check = true;
                break;
              default:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
                break;
              }

              // 2. 입력 가능 / 불가 체크
              if (qty_check == true) {
                // 2-1. 입력되어있는지 유무 확인
                // 입력되어있을 경우에만 판정이 변경되도록 변경
                if (value.length > 0) {
                  input_check = true;
                } else {
                  input_check = false;
                }

                // 입력이 되어있으면
                if (input_check == true) {

                  // 리스트 생성 함수 호출
                  var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                  if (standardvalue === "") {
                    if (value == "OK" || value == "NG") {}
                    else {
                      extAlert("OK/NG 중에 하나를 입력해주십시오!");
                      field.setValue();
                      return false;
                    }
                  } else {
                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                    if (!regexp.test(value)) {
                      // 숫자가 아닌 값을 입력시
                      extAlert("입력하신 값이 숫자가 아닙니다!");
                      field.setValue();
                      return false;
                    } else {}
                  }

                  // 판정결과
                  result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                  //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                  if (result_check == true) {
                    model.set('CHECKYNNAME', '합격');
                    model.set('CHECKYN', 'OK');
                  } else {
                    model.set('CHECKYNNAME', '불합격');
                    model.set('CHECKYN', 'NG');
                  }

                  return true;
                } else {
                  // 미입력시 메시지 안띄우고 그냥 넘어감
                  return true;
                }
              } else {
                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                extAlert(msg);
                field.setValue();
                return false;
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 180, // 150,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
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
        switch (checkqty) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
          qty_check = true;
          break;
        default:
          qty_check = false;
          break;
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
      enableFocusableContainer: false,
      tdCls: 'x2',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        allowBlank: true,
        listeners: {
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
              var max = model.data.MAXVALUE;
              var min = model.data.MINVALUE;
              var standardvalue = model.data.STANDARDVALUE; // 검사기준값
              var checkqty = model.data.CHECKQTY * 1; // 시료수
              var value = field.getValue(); // X2
              var qty_check = false; // 시료수 체크
              var input_check = false; // 입력 / 미입력 체크
              var msg = "",
              result_check = false;

              // 검사 값
              const X1 = model.data.CHECKRESULT1,
              X2 = field.getValue(),
              X3 = model.data.CHECKRESULT3,
              X4 = model.data.CHECKRESULT4,
              X5 = model.data.CHECKRESULT5;

              // 1. 시료수 범위 체크
              switch (checkqty) {
              case 1:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
              case 2:
              case 3:
              case 4:
              case 5:
                msg = "입력이 가능합니다.";
                qty_check = true;
                break;
              default:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
                break;
              }

              // 2. 입력 가능 / 불가 체크
              if (qty_check == true) {
                // 2-1. 입력되어있는지 유무 확인
                // 입력되어있을 경우에만 판정이 변경되도록 변경
                if (value.length > 0) {
                  input_check = true;
                } else {
                  input_check = false;
                }

                // 입력이 되어있으면
                if (input_check == true) {

                  // 리스트 생성 함수 호출
                  var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                  if (standardvalue === "") {
                    if (value == "OK" || value == "NG") {}
                    else {
                      extAlert("OK/NG 중에 하나를 입력해주십시오!");
                      field.setValue();
                      return false;
                    }
                  } else {
                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                    if (!regexp.test(value)) {
                      // 숫자가 아닌 값을 입력시
                      extAlert("입력하신 값이 숫자가 아닙니다!");
                      field.setValue();
                      return false;
                    } else {}
                  }

                  // 판정결과
                  result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                  //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                  if (result_check == true) {
                    model.set('CHECKYNNAME', '합격');
                    model.set('CHECKYN', 'OK');
                  } else {
                    model.set('CHECKYNNAME', '불합격');
                    model.set('CHECKYN', 'NG');
                  }

                  return true;
                } else {
                  // 미입력시 메시지 안띄우고 그냥 넘어감
                  return true;
                }
              } else {
                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                extAlert(msg);
                field.setValue();
                return false;
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 180, // 150,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
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
        switch (checkqty) {
        case 1:
          qty_check = false;
          break;
        case 2:
        case 3:
        case 4:
        case 5:
          qty_check = true;
          break;
        default:
          qty_check = false;
          break;
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
      enableFocusableContainer: false,
      tdCls: 'x3',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "VALUE",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        allowBlank: true,
        listeners: {
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
              var max = model.data.MAXVALUE;
              var min = model.data.MINVALUE;
              var standardvalue = model.data.STANDARDVALUE; // 검사기준값
              var checkqty = model.data.CHECKQTY * 1; // 시료수
              var value = field.getValue(); // X3
              var qty_check = false; // 시료수 체크
              var input_check = false; // 입력 / 미입력 체크
              var msg = "",
              result_check = false;

              // 검사 값
              const X1 = model.data.CHECKRESULT1,
              X2 = model.data.CHECKRESULT2,
              X3 = field.getValue(),
              X4 = model.data.CHECKRESULT4,
              X5 = model.data.CHECKRESULT5;

              // 1. 시료수 범위 체크
              switch (checkqty) {
              case 1:
              case 2:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
              case 3:
              case 4:
              case 5:
                msg = "입력이 가능합니다.";
                qty_check = true;
                break;
              default:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
                break;
              }

              // 2. 입력 가능 / 불가 체크
              if (qty_check == true) {
                // 2-1. 입력되어있는지 유무 확인
                // 입력되어있을 경우에만 판정이 변경되도록 변경
                if (value.length > 0) {
                  input_check = true;
                } else {
                  input_check = false;
                }

                // 입력이 되어있으면
                if (input_check == true) {

                  // 리스트 생성 함수 호출
                  var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                  if (standardvalue === "") {
                    if (value == "OK" || value == "NG") {}
                    else {
                      extAlert("OK/NG 중에 하나를 입력해주십시오!");
                      field.setValue();
                      return false;
                    }
                  } else {
                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                    if (!regexp.test(value)) {
                      // 숫자가 아닌 값을 입력시
                      extAlert("입력하신 값이 숫자가 아닙니다!");
                      field.setValue();
                      return false;
                    } else {}
                  }

                  // 판정결과
                  result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                  //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                  if (result_check == true) {
                    model.set('CHECKYNNAME', '합격');
                    model.set('CHECKYN', 'OK');
                  } else {
                    model.set('CHECKYNNAME', '불합격');
                    model.set('CHECKYN', 'NG');
                  }

                  return true;
                } else {
                  // 미입력시 메시지 안띄우고 그냥 넘어감
                  return true;
                }
              } else {
                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                extAlert(msg);
                field.setValue();
                return false;
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 180, // 150,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
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
        switch (checkqty) {
        case 1:
        case 2:
          qty_check = false;
          break;
        case 3:
        case 4:
        case 5:
          qty_check = true;
          break;
        default:
          qty_check = false;
          break;
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
      enableFocusableContainer: false,
      tdCls: 'x4',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "VALUE",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        allowBlank: true,
        listeners: {
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
              var max = model.data.MAXVALUE;
              var min = model.data.MINVALUE;
              var standardvalue = model.data.STANDARDVALUE; // 검사기준값
              var checkqty = model.data.CHECKQTY * 1; // 시료수
              var value = field.getValue(); // X4
              var qty_check = false; // 시료수 체크
              var input_check = false; // 입력 / 미입력 체크
              var msg = "",
              result_check = false;

              // 검사 값
              const X1 = model.data.CHECKRESULT1,
              X2 = model.data.CHECKRESULT2,
              X3 = model.data.CHECKRESULT3,
              X4 = field.getValue(),
              X5 = model.data.CHECKRESULT5;

              // 1. 시료수 범위 체크
              switch (checkqty) {
              case 1:
              case 2:
              case 3:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
              case 4:
              case 5:
                msg = "입력이 가능합니다.";
                qty_check = true;
                break;
              default:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
                break;
              }

              // 2. 입력 가능 / 불가 체크
              if (qty_check == true) {
                // 2-1. 입력되어있는지 유무 확인
                // 입력되어있을 경우에만 판정이 변경되도록 변경
                if (value.length > 0) {
                  input_check = true;
                } else {
                  input_check = false;
                }

                // 입력이 되어있으면
                if (input_check == true) {

                  // 리스트 생성 함수 호출
                  var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                  if (standardvalue === "") {
                    if (value == "OK" || value == "NG") {}
                    else {
                      extAlert("OK/NG 중에 하나를 입력해주십시오!");
                      field.setValue();
                      return false;
                    }
                  } else {
                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                    if (!regexp.test(value)) {
                      // 숫자가 아닌 값을 입력시
                      extAlert("입력하신 값이 숫자가 아닙니다!");
                      field.setValue();
                      return false;
                    } else {}
                  }

                  // 판정결과
                  result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                  //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                  if (result_check == true) {
                    model.set('CHECKYNNAME', '합격');
                    model.set('CHECKYN', 'OK');
                  } else {
                    model.set('CHECKYNNAME', '불합격');
                    model.set('CHECKYN', 'NG');
                  }

                  return true;
                } else {
                  // 미입력시 메시지 안띄우고 그냥 넘어감
                  return true;
                }
              } else {
                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                extAlert(msg);
                field.setValue();
                return false;
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 180, // 150,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
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
        switch (checkqty) {
        case 1:
        case 2:
        case 3:
          qty_check = false;
          break;
        case 4:
        case 5:
          qty_check = true;
          break;
        default:
          qty_check = false;
          break;
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
      enableFocusableContainer: false,
      tdCls: 'x5',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "VALUE",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: true,
        allowBlank: true,
        listeners: {
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
              var max = model.data.MAXVALUE;
              var min = model.data.MINVALUE;
              var standardvalue = model.data.STANDARDVALUE; // 검사기준값
              var checkqty = model.data.CHECKQTY * 1; // 시료수
              var value = field.getValue(); // X5
              var qty_check = false; // 시료수 체크
              var input_check = false; // 입력 / 미입력 체크
              var msg = "",
              result_check = false;

              // 검사 값
              const X1 = model.data.CHECKRESULT1,
              X2 = model.data.CHECKRESULT2,
              X3 = model.data.CHECKRESULT3,
              X4 = model.data.CHECKRESULT4,
              X5 = field.getValue();

              // 1. 시료수 범위 체크
              switch (checkqty) {
              case 1:
              case 2:
              case 3:
              case 4:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
              case 5:
                msg = "입력이 가능합니다.";
                qty_check = true;
                break;
              default:
                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                qty_check = false;
                break;
              }

              // 2. 입력 가능 / 불가 체크
              if (qty_check == true) {
                // 2-1. 입력되어있는지 유무 확인
                // 입력되어있을 경우에만 판정이 변경되도록 변경
                if (value.length > 0) {
                  input_check = true;
                } else {
                  input_check = false;
                }

                // 입력이 되어있으면
                if (input_check == true) {

                  // 리스트 생성 함수 호출
                  var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                  if (standardvalue === "") {
                    if (value == "OK" || value == "NG") {}
                    else {
                      extAlert("OK/NG 중에 하나를 입력해주십시오!");
                      field.setValue();
                      return false;
                    }
                  } else {
                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                    if (!regexp.test(value)) {
                      // 숫자가 아닌 값을 입력시
                      extAlert("입력하신 값이 숫자가 아닙니다!");
                      field.setValue();
                      return false;
                    } else {}
                  }

                  // 판정결과
                  result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                  //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                  if (result_check == true) {
                    model.set('CHECKYNNAME', '합격');
                    model.set('CHECKYN', 'OK');
                  } else {
                    model.set('CHECKYNNAME', '불합격');
                    model.set('CHECKYN', 'NG');
                  }

                  return true;
                } else {
                  // 미입력시 메시지 안띄우고 그냥 넘어감
                  return true;
                }
              } else {
                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                extAlert(msg);
                field.setValue();
                return false;
              }
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
          width: 180, // 150,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
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
        switch (checkqty) {
        case 1:
        case 2:
        case 3:
        case 4:
          qty_check = false;
          break;
        case 5:
          qty_check = true;
          break;
        default:
          qty_check = false;
          break;
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
      dataIndex: 'CHECKYNNAME',
      text: '판정',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.3"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote', // 'local',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

            model.set("CHECKYN", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;데이터가 없습니다. 관리자에게 문의하십시오.</span>',
          width: 200, // 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
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
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/order/ship/ShipInspectionDetail.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
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

                if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
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
                  break;
                case 2:
                  editDisableCols.push("CHECKRESULT3");
                  editDisableCols.push("CHECKRESULT4");
                  editDisableCols.push("CHECKRESULT5");
                  break;
                case 3:
                  editDisableCols.push("CHECKRESULT4");
                  editDisableCols.push("CHECKRESULT5");
                  break;
                case 4:
                  editDisableCols.push("CHECKRESULT5");
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
              beforerender: function (c) {
                var formFields = [];
                // 컴포넌트를 탐색하면서 field인것만 검
                c.cascade(function (field) {
                  var xtypeChains = field.xtypesChain;

                  var isField = Ext.Array.findBy(xtypeChains, function (item) {

                      // DisplayField는 이벤트 대상에서 제외
                      if (item == 'displayfield') {
                        return false;
                      }

                      // Ext.form.field.Base를 상속받는 모든객체
                      if (item == 'field') {
                        return true;
                      }
                    });
                  // keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
                  if (isField) {
                    field.enableKeyEvents = true;
                    field.isShiftKeyPressed = false;
                    formFields.push(field);
                  }
                });

                for (var i = 0; i < formFields.length - 1; i++) {
                  var beforeField = (i == 0) ? null : formFields[i - 1];
                  var field = formFields[i];
                  var nextField = formFields[i + 1];

                  field.addListener('keyup', function (thisField, e) {
                    //Shift Key 처리방법
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = false;
                      return;
                    }
                  });

                  field.addListener('keydown', function (thisField, e) {
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = true;
                      return;
                    }

                    // Shift키 안누르고 ENTER키 또는 TAB키 누를때 다음필드로 이동
                    if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                      this.nextField.focus();
                      e.stopEvent();

                    }
                    // Shift키 누른상태에서 TAB키 누를때 이전필드로 이동
                    else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
                      if (this.beforeField != null) {
                        this.beforeField.focus();
                        e.stopEvent();
                      }
                    }

                  }, {
                    nextField: nextField,
                    beforeField: beforeField
                  });
                }
              }
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

function fn_push_list(X1, X2, X3, X4, X5, qty) {
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

function fn_save() {
  var MfgDate = $('#MfgDate').val();
  var header = [],
  count = 0;
  var dataSuccess = 0;
  var result = null;

  if (MfgDate === "") {
    header.push("검사일");
    count++;
  }

  if (count > 0) {
    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
    return false;
  }

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

  if (!isNew) {
    url = "<c:url value='/update/order/ship/ShipInspectionMaster.do' />";
    url1 = "<c:url value='/update/order/ship/ShipInspectionDetail.do' />";
    msgGubun = 2;
  }

  if (msgGubun == 2) {

    Ext.MessageBox.confirm('출하검사등록 알림', '출하검사 결과를 등록하시겠습니까?', function (btn) {
      if (btn == 'yes') {
        btnbreak = true;
        if (statuschk == true) {

          var params = [];
          $.ajax({
            url: url,
            type: "post",
            dataType: "json",
            data: $("#master").serialize(),
            success: function (data) {
              var shipinsno = data.ShipInsNo;
              var orgid = data.searchOrgId;
              var companyid = data.searchCompanyId;

              if (shipinsno.length == 0) {
                //  생성이 안되었을 때 로직 추가
              } else {
                //  정상적으로 생성이 되었으면
                var recount = Ext.getStore(gridnms["store.1"]).count();

                for (var i = 0; i < recount; i++) {
                  var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                  model.set("SHIPINSNO", shipinsno);
                  model.set("ORGID", orgid);
                  model.set("COMPANYID", companyid);
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
                        setInterval(function () {
                          fn_list();
                        }, 1 * 0.5 * 1000);
                      }
                    },
                    error: ajaxError
                  });
                }
              }
            },
            error: ajaxError
          });

          if (dataSuccess > 0) {
            setInterval(function () {
              fn_list();
            }, 1 * 0.5 * 1000);
          }
        } else {
          extAlert(msg);
          return;
        }
        return;
      } else {
        Ext.Msg.alert('출하검사등록 취소', '등록이 취소되었습니다.');
        return;
      }
    });
  }
}

function fn_search() {
  var orgid = $('#searchOrgId option:selected').val();
  var companyid = $('#searchCompanyId option:selected').val();
  var shipno = $('#shipno').val();
  var shipseq = $('#shipseq').val();
  var header = [],
  count = 0;
  var dataSuccess = 0;
  var result = null;

  if (shipno === "") {
    header.push("출하번호");
  }

  if (shipseq === "") {
    header.push("출하순번");
  }

  if (count > 0) {
    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
    return false;
  }

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    SHIPNO: shipno,
    SHIPSEQ: shipseq,
  };

  url = "<c:url value='/select/order/ship/ShipInspectionMaster.do' />";

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
        var itemname = dataList.ITEMNAME;
        var ordername = dataList.ORDERNAME;
        var detailqty = dataList.DETAILQTY;
        var shipqty = dataList.SHIPQTY;
        var passqty = dataList.PASSQTY;

        var faultqty = dataList.FAULTQTY;
        var shiplot = dataList.SHIPLOT;
        var remarks = dataList.REMARKS;
        var personid = dataList.PERSONID;
        var krname = dataList.KRNAME;

        $("#ShipInsNo").val(shipinsno);

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
        $("#ItemName").val(itemname);
        $("#OrderName").val(ordername);
        $("#DetailQty").val(detailqty);
        $("#ShipQty").val(shipqty);
        $("#PassQty").val(passqty);

        $("#FaultQty").val(faultqty);
        $("#ShipLot").val(shiplot);
        $("#Remarks").val(remarks);
        $("#PersonId").val(personid);
        $("#KrName").val(krname);

        var sparams1 = {
          ORGID: orgid,
          COMPANYID: companyid,
          SHIPINSNO: shipinsno,
        };

        getItemFile();

        extGridSearch(sparams1, gridnms["store.1"]);
      }
    },
    error: ajaxError
  });

}

function fn_list() {
  go_url("<c:url value='/quality/ship/ShipInspectionList.do'/>");
}

function fn_ready() {
  extAlert("준비중입니다...");
}

function fn_emp_all() {
  // 검사자 선택시 상세 내역에 등록하는 Function
  var count1 = Ext.getStore(gridnms["store.1"]).count();

  if (count1 > 0) {
    for (var i = 0; i < count1; i++) {
      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
      var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

      var personid = $('#PersonId').val();
      var krname = $('#KrName').val();

      model1.set('PERSONID', personid);
      model1.set('KRNAME', krname);
    }
  } else {
    extToastView("검사 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
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
      //             $("#KrName").val("");
      $("#PersonId").val("");
      fn_emp_all();
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
      fn_emp_all();

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
                                <li>출하관리</li>
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
                                <input type="hidden" id="shipno" name="shipno" value="${searchVO.shipno}" />
                                <input type="hidden" id="shipseq" name="shipseq" value="${searchVO.shipseq}" />
                                <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                <input type="hidden" id="ItemCode" name="ItemCode" />
                                <input type="hidden" id="today" name="today" value="${searchVO.TODAY }"/>
                                <input type="hidden" id="PersonId" name="PersonId" />
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
                                                            <a id="btnChk1" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                            <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
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
                                            <input type="text" id="ShipInsNo" name="ShipInsNo" class="input_center" style="width: 97%;" readonly />
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
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="ItemName" name="ItemName" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                        <th class="required_text">출하수량</th>
                                        <td>
                                            <input type="text" id="DetailQty" name="DetailQty" class="input_right" style="width: 97%;" readonly />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
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
                                        <th class="required_text">출하LOT</th>
                                        <td>
                                            <input type="text" id="ShipLot" name="ShipLot" class="input_center" style="width: 97%;" readonly />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">검사자</th>
                                        <td>
                                            <input type="text" id="KrName" name="KrName" class="input_center" style="width: 97%; "/>
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
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
                
                <%-- <form id="fileform" name="fileform" method="POST" action='<c:url value="/itemfile/upload.do" />' enctype="multipart/form-data" data-ng-app="demo" data-file-upload="options" data-ng-controller="FileUploadController">
                    <div id="fileBox" style="width: 100%; border: 2px solid #81B1D5; float: left; overflow: auto;">
                        <div id="fileBtnBox" style="width: 100%; overflow: auto;">
                            <div class="row" style="margin-top: 0px; text-align: left;">
                                <input type="file" name="FILE" multiple style="margin-top: 5px; margin-left: 5px; float: left;" />
                            </div>
                        </div>
                        <table id="filetable" class="table table-striped files ng-cloak" style="width: 100%;">
                            <tr data-ng-repeat="file in queue" style="height: 30px !important;">
                                <td width="700px" style="vertical-align: middle;">
                                    <p class="name" data-ng-switch data-on="!!file.url">
                                        <span data-ng-switch-default>{{file.name}}</span>
                                    </p>
                                </td>
                                <td width="100px" style="vertical-align: middle;">
                                    <p class="size">{{file.size | formatFileSize}}</p>
                                </td>
                                <td style="vertical-align: middle;">
                                    <button type="button" class="btn btn-warning cancel" data-ng-click="file.$cancel()" data-ng-hide="!file.$cancel" style="font-size: 10px !important; padding-left: 7px !important; padding-top: 0px !important; padding-right: 7px; height: 18px !important;">
                                        <i class="glyphicon glyphicon-ban-circle"></i> <span>취소</span>
                                    </button>
                                    <button type="button" class="btn btn-primary start" data-ng-click="file.$submit()" data-ng-hide="!file.$submit || options.autoUpload" data-ng-disabled="file.$state() == 'pending' || file.$state() == 'rejected'" style="font-size: 10px !important; padding-left: 7px !important; padding-top: 0px !important; padding-right: 7px; height: 18px !important;">
                                        <i class="glyphicon glyphicon-upload"></i> <span>업로드</span>
                                    </button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form> --%>
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