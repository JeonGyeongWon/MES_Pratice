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
	���� ���� ū ������ Group���� ���� �����Ƿ� Group�� �������� 
	��ü Data�� ���� �� �� �ִ�.
	XML ������ �����͸� Tree���·� Parsing �ϴ� parserXmlNodeData()�� Call�Ѵ�.
********************************************************************/
function refreshTreeData(xmlData) {
	var xmlGroups = null;
	if (xmlData.getElementsByTagName("Reload").length == 0 ) {
		xmlGroups = xmlData.getElementsByTagName("Group");
		parserXmlNodeData(xmlGroups);
		return;
	}	else {
		alert('���� Group �Ǵ� BIZ�� ���� ������ ���� �ش� �������� ReLoad �˴ϴ�.');
		self.clearInterval(reCall);
		var frm = document.reLoad;
		frm.submit();
		
	}
}


/********************************************************************
	XML ������ �����͸� Tree ���·� Parsing �Ѵ�.
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

				if ( k == 2) {																			// GroupNode�� Status ��ġ Index 
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
					if (nNode != null )	{																// GroupHash�� ��ϵ� Group�߿� �ش� �ڽ� Node�� ������.
						var lastNode = groupNode.childNodes[2];											// lastNode �� Status���� �����´�.
						nNode.setStatus(lastNode.childNodes[0].nodeValue);								// ������ lastNode�� Status�� ���� Setting �Ѵ�.
						nNode.setConnected(groupNode.childNodes[4].childNodes[0].nodeValue);			// Connection ������ Setting �Ѵ�.
						nNode.setNodeMsg(groupNode.childNodes[9].childNodes[0].nodeValue);				// Message Setting
					}
				}
			}
		}
    }
}

function fineLastNode(groupNode, nID) {
	var node = null;
	var vecItems = groupNode.getSubObject();			// Group�� ��ϵ� �ڽ� Node�� �����´�.
	for ( var i = 0 ; i < vecItems.size() ; i++) {		
		node = vecItems.elementAt(i);					
		if ( node.getNodeID() == nID )	{				// �ڽ� Node ID�� Refresh Data�� �ڽ� Node ID�� ���Ѵ�.
			return node;
		}	
	}
	return null;
}


function fineLastNodeBiz(groupNode, nID, bizdiv, bizitemcode) {
	var node = null;
	var vecItems = groupNode.getSubObject();			// Group�� ��ϵ� �ڽ� Node�� �����´�.
	for ( var i = 0 ; i < vecItems.size() ; i++) {		
		node = vecItems.elementAt(i);					
		if ( node.getNodeID() == nID && node.getBizDiv() == bizdiv && node.getBizItemCode() == bizitemcode)	{				// �ڽ� Node ID�� Refresh Data�� �ڽ� Node ID�� ���Ѵ�.
			return node;
		}	
	}
	return null;
}


/********************************************************************
	Statsus�� ���� �о� �̹����� ���¿� �°� ��ȭ �����ִ� �κ�
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
