/**
    Created by: Byoung Su Lee
    on: 05/23/2006
*/

function getRefreshData() {
	var xmlHttp = newXMLHttpRequest();
	xmlHttp.onreadystatechange = getReadyStateHandler(xmlHttp, setRefreshData);
	xmlHttp.open("POST", "/VIAjaxServlet", true);
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlHttp.send("classname=visioninsight.manager.StatusDataManager&method=MMD&Ver="+systemVer);
}


function setRefreshData(xmlData){
	refreshTreeData(xmlData);
	refreshDocumentElement();
}

/********************************************************************
	현재 가장 큰 단위를 Group으로 묶여 있으므로 Group을 가져오면 
	전체 Data를 가져 올 수 있다.
	XML 형식의 데이터를 Tree형태로 Parsing 하는 parserXmlNodeData()를 Call한다.
********************************************************************/
function refreshTreeData(xmlData) {
	var xmlGroups = null;
	if (xmlData.getElementsByTagName("Reload").length == 0 ) {
		xmlGroups = xmlData.getElementsByTagName("Group");
		parserXmlNodeData(xmlGroups);
		return;
	}	else {
		alert('현재 Group 또는 BIZ에 변경 사항이 생겨 해당 페이지가 ReLoad 됩니다.');
		self.clearInterval(reCall);
		var frm = document.reLoad;
		frm.submit();
		
	}
}


/********************************************************************
	XML 형태의 데이터를 Tree 형태로 Parsing 한다.
*********************************************************************/
function parserXmlNodeData(xmlGroups) {
    var groupXML = null;
	var gNode = null;
	var out ='';
    for(var i = 0; i < xmlGroups.length; i++) {
        groupXML = xmlGroups[i];

		if (groupXML.getElementsByTagName("Biz")[0].firstChild.data == "false"){
			gNode = htGroups.get('G'+groupXML.getElementsByTagName("Gid")[0].firstChild.data);
		}	else {
			gNode = htGroups.get('B'+groupXML.getElementsByTagName("Gid")[0].firstChild.data);
		}
		if ( gNode != null )	{
			for ( var k=0; k < groupXML.childNodes.length; k++)	{
				groupNode = groupXML.childNodes[k];

				if ( k == 2) {																			// GroupNode의 Status 위치 Index 
					gNode.setStatus(groupNode.childNodes[0].nodeValue);
				}	else if ( k == 5 )	{
					gNode.setNodeMsg(groupNode.childNodes[0].nodeValue);
				}
				else if ( k > 5 ) {
					var nNode = null;
					if (gNode.isNodeBiz()){
						nNode = fineLastNodeBiz(gNode, groupNode.childNodes[1].childNodes[0].nodeValue, groupNode.childNodes[5].childNodes[0].nodeValue, groupNode.childNodes[6].childNodes[0].nodeValue);
					}	else {
						nNode = fineLastNode(gNode, groupNode.childNodes[1].childNodes[0].nodeValue);
					}
					if (nNode != null )	{																// GroupHash에 등록된 Group중에 해당 자식 Node가 있으면.
						var lastNode = groupNode.childNodes[2];											// lastNode 중 Status값을 가져온다.
						nNode.setStatus(lastNode.childNodes[0].nodeValue);								// 가져온 lastNode의 Status의 값을 Setting 한다.
						nNode.setConnected(groupNode.childNodes[4].childNodes[0].nodeValue);			// Connection 정보를 Setting 한다.
						nNode.setNodeMsg(groupNode.childNodes[9].childNodes[0].nodeValue);				// Message Setting
					}
				}
			}
		}
    }
}

function fineLastNode(groupNode, nID) {
	var node = null;
	var vecItems = groupNode.getSubObject();			// Group에 등록된 자식 Node를 가져온다.
	for ( var i = 0 ; i < vecItems.size() ; i++) {		
		node = vecItems.elementAt(i);					
		if ( node.getNodeID() == nID )	{				// 자식 Node ID와 Refresh Data의 자식 Node ID를 비교한다.
			return node;
		}	
	}
	return null;
}


function fineLastNodeBiz(groupNode, nID, bizdiv, bizitemcode) {
	var node = null;
	var vecItems = groupNode.getSubObject();			// Group에 등록된 자식 Node를 가져온다.
	for ( var i = 0 ; i < vecItems.size() ; i++) {		
		node = vecItems.elementAt(i);					
		if ( node.getNodeID() == nID && node.getBizDiv() == bizdiv && node.getBizItemCode() == bizitemcode)	{				// 자식 Node ID와 Refresh Data의 자식 Node ID를 비교한다.
			return node;
		}	
	}
	return null;
}


/********************************************************************
	Statsus의 값을 읽어 이미지를 상태에 맞게 변화 시켜주는 부분
*********************************************************************/
function refreshDocumentElement() {
	var keys = htGroups.keys();
	var groupNode = null;	
	var groupNodeIamge = null;
	for (var i = 0; i < keys.length; i++) {
		groupNode = htGroups.get(keys[i]);
		groupNodeIamge = document.all(keys[i] + 'Image');
		if ( groupNode.isNodeBiz() ) {
			if (groupNode.getStatus() == 0 )	{
				groupNodeIamge.src ='/images/icon/b_04.gif';		
			}	else if (groupNode.getStatus() == 1 )	{
				groupNodeIamge.src ='/images/icon/b_03.gif';
			}	else if (groupNode.getStatus() == 2 )	{
				groupNodeIamge.src ='/images/icon/b_02.gif';
			}	else if (groupNode.getStatus() == 3 )	{
				groupNodeIamge.src ='/images/icon/b_01.gif';
			}
		}	else {
			if (groupNode.getStatus() == 0 )	{
				groupNodeIamge.src ='/images/icon/g_04.gif';		
			}	else if (groupNode.getStatus() == 1 )	{
				groupNodeIamge.src ='/images/icon/g_03.gif';
			}	else if (groupNode.getStatus() == 2 )	{
				groupNodeIamge.src ='/images/icon/g_02.gif';		
			}	else if (groupNode.getStatus() == 3 )	{
				groupNodeIamge.src ='/images/icon/g_01.gif';
			}
		}

		groupNode.setImage(groupNodeIamge.src);

		var vectItems = groupNode.getSubObject();
		
		for ( var k = 0; k < vectItems.size() ; k++) {
			node = vectItems.elementAt(k);
			if (node.getNodeType() == 'BIZ')	{
				nodeImage = document.all(keys[i]+'N'+node.getNodeID()+ node.getBizDiv() + node.getBizItemCode()+'GroupItemImage');
			}	else {
				nodeImage = document.all(keys[i]+'N'+node.getNodeID()+'GroupItemImage');
			}
			if ( groupNode.isNodeBiz() ) {
				if (node.getNodeType() == 'BIZ') {
					if (node.getStatus() == 0) {
						nodeImage.src='/images/icon/bi_04.gif'; 
					}	else if ( node.getStatus() == 1) {
						nodeImage.src='/images/icon/bi_03.gif'; 
					}	else if ( node.getStatus() == 2) {
						nodeImage.src='/images/icon/bi_02.gif'; 
					}	else if ( node.getStatus() == 3) {
						nodeImage.src='/images/icon/bi_01.gif'; 
					}
				}
			}	else {
				if (node.isConnected() == 'true')	{
					if ( node.getNodeType() == 'AS400' || node.getNodeType() == 'UNIX' || node.getNodeType() == 'LINUX' || node.getNodeType() == 'NT' ) {
						if (node.getStatus() == 0) {
							nodeImage.src='/images/icon/s_04.gif'; 
						}	else if ( node.getStatus() == 1) {
							nodeImage.src='/images/icon/s_03.gif'; 
						}	else if ( node.getStatus() == 2) {
							nodeImage.src='/images/icon/s_02.gif'; 
						}	else if ( node.getStatus() == 3)  {
							nodeImage.src='/images/icon/s_01.gif'; 
						}
					}	else if (node.getNodeType() == 'FMS')	{
						if (node.getStatus() == 0) {
							nodeImage.src='/images/icon/f_04.gif'; 
						}	else if ( node.getStatus() == 1) {
							nodeImage.src='/images/icon/f_03.gif'; 
						}	else if ( node.getStatus() == 2) {
							nodeImage.src='/images/icon/f_02.gif'; 
						}	else if ( node.getStatus() == 3) {
							nodeImage.src='/images/icon/f_01.gif'; 
						}
					}	
				}	else {
					if ( node.getNodeType() == 'AS400' || node.getNodeType() == 'UNIX' || node.getNodeType() == 'LINUX' || node.getNodeType() == 'NT' ) {
						nodeImage.src='/images/icon/s_01.gif'; 
					}	else if (node.getNodeType() == 'FMS')	{
						nodeImage.src='/images/icon/f_01.gif'; 
					}	else if (node.getNodeType() == 'BIZ') {
						nodeImage.src='/images/icon/bi_01.gif'; 
					}
				}
			}
			node.setImage(nodeImage.src);
		}
	}
}
