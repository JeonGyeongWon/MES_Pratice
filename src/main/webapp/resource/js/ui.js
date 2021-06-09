//utilities - form
var util={
    user : function(type){
            if(!type) return;
            if(type=="ie") return (!!(window.attachEvent && !window.opera));
            if(type=="firefox") return (navigator.userAgent.toLowerCase().indexOf("firefox")!=-1);
            if(type=="opera") return (!!window.opera);
            if(type=="webkit") return (navigator.userAgent.indexOf("AppleWebKit/") > -1);
            if(type=="gecko") return (navigator.userAgent.indexOf("Gecko") > -1 && navigator.userAgent.indexOf("KHTML") == -1);
            if(type=="mobile") return (navigator.userAgent.match(/iPhone|iPad|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || navigator.userAgent.match(/LG|SAMSUNG|Samsung/) != null);
            return type;
    },
    inputDesign : function(){
		$('input[type="radio"], input[type="checkbox"], input[type="file"]').each(function(i){
			if(this.type=="file"){
				this.baseW = this.offsetWidth;
				$(this).wrap('<span class="fileForm" />');
				$(this).parent().prepend('<input type="text" id="designFileInput'+i+'" class="text" readonly="readonly" title="÷������ ������ ����" value="'+($(this).attr("placeholder")?$(this).attr("placeholder"):"")+'" style="width:'+(this.baseW-110)+'px;" />');
				$("#designFileInput"+i)[0].matchFile = this;
				this.matchInput = $("#designFileInput"+i).attr({"readonly":"true","disabled":"true"});
				this.onchange = function(){ this.matchInput[0].value = this.value; }
			}else{
				var cn = (this.type =="radio") ? "radio" : "check";
				$(this).wrap('<span class="'+cn+'Design" />').focus(function(){ $(this).parent().addClass(cn+"Focus") }).blur(function(){ $(this).parent().removeClass(cn+"Focus") }).change(util.inputChange);
				util.inputChange.call(this);
			}
		});
	},
	inputChange : function(){
		var cn = (this.type =="radio") ? "radio" : "check";
		if(cn=="radio") $('input[name="'+this.name+'"]').parent().removeClass(cn+"Checked");
		if(this.checked) $(this).parent().addClass(cn+"Checked");
		else $(this).parent().removeClass(cn+"Checked");
	}
}

//윈도우 팝업
function winPopup(pUrl,pWidth,pHeight) {
	var popupUrl = pUrl;
	var windowW = pWidth;
	var windowH = pHeight;
	var posLeft = Math.ceil((window.screen.width - windowW)/2);
	var posTop = Math.ceil((window.screen.height - windowH)/2);
	window.open(pUrl,'',"top="+posTop+", left="+posLeft+", height="+pHeight+", width="+pWidth);
}

//디자인 셀렉트
$(document).ready(function() {
	if( $("input:radio").parent().is("span") ) {
			$(".objSelect").find("input:radio").unwrap();
		}
	$(".objSelect").find(">.btn").click(function() {
		$(".objSelect").css({"z-index":"18"});
		$(".objSelect").find(">.btn").removeClass("on");
		$(".objSelect").find(">ul").css({"left":"-9999px"});
	});
	$(".objSelect").each(function() {
		initObjSelect($(this));
	});

	if($("ul").hasClass("tabs")) {
		$("ul.tabs").each(function() {
			initTab($(this));
		});
	}

	//언어 선택 및 패밀리 사이트
	$('ul#language').hide();
	$('a.languagego').click(function(){
		$('ul#familysites').hide();
		$('ul#language').toggle();
		return false;
	});
	/*
	$('.language').mouseleave(function() {
		$('ul#language').hide();
	});
	*/

	$('ul#familysites').hide();
	$('a.familysitesgo').click(function(){
		$('ul#language').hide();
		$('ul#familysites').toggle();
		return false;
	});
	/*
	$('.familysites').mouseleave(function() {
		$('ul#familysites').hide();
	});
	*/

	// btnArea - hover
	$(".btnArea > a").hover(function() {
		$(this).toggleClass("atv");
	});

	/* imgRollover  */
	$(".imgRollover").on("mouseover focusin",function() {
		$(this).attr("src", $(this).attr("src").replace(/_datv\.gif$/, "_atv.gif"));
	});
	$(".imgRollover").on("mouseout focusout",function() {
		$(this).attr("src", $(this).attr("src").replace(/_atv\.gif$/, "_datv.gif"));
	});
});

initObjSelect = function(objSelect) {
	var selectWidth = objSelect.width();
	var selectBtn = objSelect.find(">.btn");
	var selectList = objSelect.find(">ul");
		selectList.css({"left":"-9999px"});
		selectList.css("width",selectWidth-2+"px");
	var selectItems = selectList.find(">li");
	var current = false;

	//셀렉트 기본설정
	function defaultValue() {
		objSelect.each(function(m) {
			var dfInput = $(this).find("ul>li>input:checked");
			var dfTxt = dfInput.next("label").text();
			$(this).find(">.btn").text(dfTxt);
		});
	};
	defaultValue();

	//셀렉트 오픈
	selectBtn.on("click",function(e) {
		$(this).parent().css({"z-index":"20"});
		$(this).next().css({"left":"0px"});
		$(this).addClass("on");
		current = true;
		var evt = window.event || e;
		if (evt.stopPropagation) {
			evt.stopPropagation();
		} else {
			evt.cancelBubble = true;
		};
	});

	//옵션선택
	selectItems.each(function(i) {
		$(this).on("mouseenter",function() { $(this).addClass("on").siblings().removeClass("on"); });
		$(this).find(">input:radio").on("focusin",function() {
			$(this).parent().addClass("on").siblings().removeClass("on");
			selectBtn.addClass("on");
			$(this).parents(".objSelect").css({"z-index":"20"});
		});
		$(this).find(">input:radio").on("focusout",function() {
			selectBtn.removeClass("on");
			$(this).parents(".objSelect").css({"z-index":"18"});
		});
		$(this).find(">input:radio").on("change",function() { valueChange(i); });
	});

	//옵션 Change
	function valueChange(val) {
		objSelect.each(function() {
			$(this).find(">.btn").text($(this).find(">ul>li:eq("+val+")>label").text());
		});
	};

	//셀렉트 초기화
	$("html").on("click",function() {
		if(current == true) {
			selectList.css({"left":"-9999px"});
			selectBtn.removeClass("on");
			objSelect.css({"z-index":"18"});
			current = false;
		};
	});
};

//텝 컨텐츠
function initTab(tabList) {
	var tabs = tabList;
	var tabItem = tabs.find(">li");
	var tabContent = $(".tabContent")

	tabItem.each(function(i) {
		tabItem.find(">a").on("click",function() {
			//텝 버튼 이미지 전체 Off
			var allBtn = tabItem.eq(i).find(">a>img");
			var allBtnSrc = allBtn.attr("src").replace("_on.gif","_off.gif");
				allBtn.attr("src",allBtnSrc);
				allBtn.removeClass("active");

			//자기자신 On
			var myBtn = $(this).find(">img");
			var myBtnSrc = myBtn.attr("src").replace("_off.gif","_on.gif");
				myBtn.attr("src",myBtnSrc);
				myBtn.addClass("active");

			//텝 컨텐츠 변경
			var contUrl = $(this).attr("href")
			$(contUrl).show().siblings().hide();
			return false;
		});

		tabItem.find(">a").on("mouseover focusin",function() {
			//자기자신 On
			var myBtn = $(this).find(">img");
			if(myBtn.hasClass("")) {
				var myBtnSrc = myBtn.attr("src").replace("_off.gif","_on.gif");
					myBtn.attr("src",myBtnSrc);
			};
		});

		tabItem.find(">a").on("mouseout focusout",function() {
			//자기자신 Off
			var myBtn = $(this).find(">img");
			if(myBtn.hasClass("")) {
				var myBtnSrc = myBtn.attr("src").replace("_on.gif","_off.gif");
					myBtn.attr("src",myBtnSrc);
			};
		});
	});
	tabItem.eq(0).find(">a").click();
}

// Gnb
function initGnb(dep1) {
	// 앨리먼트 설정
	var gnb = $("nav#gnb");
		gnb.css({height:"48px"});
	var gItem = gnb.find(">ul>li");
	var openMenu = false;

	gItem.each(function(i) {
		gItem.on("mouseenter", function() {
			openMenu = true;
			if(openMenu == true) {
				//메뉴 전체 오프
				var allBtn = gItem.eq(i).find(">a");
				allBtn.removeClass("on");

				// 자기자신 오버
				var myBtn = $(this).find(">a");
				myBtn.addClass("on");

				//2deps show
				gnb.stop();
				gnb.animate({height:"156px"},"fast");
				gItem.find(">ul").show();
			};
		});

		gItem.find(">a").on("focusin", function() {
			openMenu = true;
			if(openMenu == true) {
				//메뉴 전체 오프
				var allBtn = gItem.eq(i).find(">a");
				allBtn.removeClass("on");

				// 자기자신 오버
				var myBtn = $(this);
				myBtn.addClass("on");

				//2deps show
				gnb.stop();
				gnb.animate({height:"156px"},"fast");
				gItem.find(">ul").show();
			};
		});
	});

	$("#top,#header h1,#container").on("mouseenter focusin",function() {
		openMenu = false;

		//메뉴 전체 오프
		gItem.each(function(k) {
			if(openMenu == false) {
				var allBtn = gItem.eq(k).find(">a");
				allBtn.removeClass("on");
				gnb.stop();
				gnb.animate({height:"48px"},"fast");
				gItem.find(">ul").hide();

				//1Depth Over
				if(dep1 != 0) {
					var deps1Btn = gItem.eq(dep1-1).find(">a");
					deps1Btn.addClass("on");
				};
			};
		});
	});

	if(dep1 != 0) {
		gItem.eq(dep1-1).find(">a").addClass("on");
	};
};

//Main Gnb
function initMainGnb() {
	// 앨리먼트 설정
	var gnb = $("nav#main_gnb");
		gnb.css({height:"48px"});
	var gItem = gnb.find(">ul>li");
	var openMenu = false;

	gItem.each(function(i) {
		gItem.on("mouseenter", function() {
			openMenu = true;
			if(openMenu == true) {
				//메뉴 전체 오프
				var allBtn = gItem.eq(i).find(">a");
				allBtn.removeClass("on");

				// 자기자신 오버
				var myBtn = $(this).find(">a");
				myBtn.addClass("on");

				//2deps show
				gnb.stop();
				gnb.animate({height:"156px"},"fast");
				gItem.find(">ul").show();
			};
		});

		gItem.find(">a").on("focusin", function() {
			openMenu = true;
			if(openMenu == true) {
				//메뉴 전체 오프
				var allBtn = gItem.eq(i).find(">a");
				allBtn.removeClass("on");

				// 자기자신 오버
				var myBtn = $(this);
				myBtn.addClass("on");

				//2deps show
				gnb.stop();
				gnb.animate({height:"156px"},"fast");
				gItem.find(">ul").show();
			};
		});
	});

	$("#main_poster").on("mouseenter focusin",function() {
		openMenu = false;

		//메뉴 전체 오프
		gItem.each(function(k) {
			if(openMenu == false) {
				var allBtn = gItem.eq(k).find(">a");
				allBtn.removeClass("on");
				gnb.stop();
				gnb.animate({height:"48px"},"fast");
				gItem.find(">ul").hide();
			};
		});
	});
}

//Lnb
function initLnb(dep1) {
	var lnb = $("nav#lnb>ul");
	var lItem = lnb.find(">li");

	lItem.eq(dep1-1).find(">a").addClass("on");
	lItem.eq(dep1-1).next().find(">a").addClass("off_right");
	lItem.eq(dep1-1).prev().find(">a").addClass("off_left");
};

//메인 홈 슬라이드 버튼
function slideHome() {
	var btnHome = $("a#btn_home");
	btnHome.on("click",function() {
		$("html, body").animate({
			scrollLeft : 0
		});
		return false;
	});
}

// 메인 프로모션
function mainPromotion() {
	// 앨리먼트 설정
	var promotion = $("#main_promotion");
	var prWrap = promotion.find(">.promotion_wrap");
	var prItem = prWrap.find(">ul>li");
	var prIndicator = promotion.find(">.indicator");
	var indItem = prIndicator.find(">a");

	//슬라이드 옵션
	var o = {
		total: prItem.size(),
		current: 1,
		slideTo: parseInt(promotion.width())
	}

	// 프로모션 감싸는 부분 넓이 설정
	prWrap.css({"width":o.slideTo*o.total+"px"});

	//Indicator 클릭 및 슬라이드 설정
	indItem.each(function(i) {
		indItem.on("click",function() {
			//전체 Indicator 오프
			var allBtn = indItem.eq(i).find(">img");
			var allBtnOn = allBtn.attr("src").replace("_on.png","_off.png");
			allBtn.attr("src",allBtnOn);

			//해당 Indicator 오버
			var myBtn = $(this).find(">img");
			var myBtnSrc = myBtn.attr("src").replace("_off.png","_on.png");
			myBtn.attr("src",myBtnSrc)

			//프로모션 슬라이드
			var prNum = $(this).attr("href").split("#")[1];
			o.current = prNum;
			prWrap.stop();
			prWrap.animate({
				marginLeft : o.slideTo * (1-o.current) + "px"
			});
		});
	});
	indItem.eq(0).find(">img").attr("src",indItem.eq(0).find(">img").attr("src").replace("_off.png","_on.png"));
}


//Top 메뉴
$(document).ready(function() {
	planetGate();
});

function planetGate() {
	//앨리먼트 설정
	var btnGate = $("a#btn_gate");
	if(btnGate.length==0) return;
	var planetGate = $("nav#planet_gate");
		gateItem = planetGate.find(">ul>li");
		gateItem.eq(3).addClass("active");
	var gateItem3Src = gateItem.eq(3).find(">a>img").attr("src").replace("_off.png","_on.png");
		gateItem.eq(3).find(">a>img").attr("src",gateItem3Src);
	var header = $("header#header");
	var footer = $("footer#footer");
	var wrapper = $("#wrapper,#main_wrap");
	var modal = $(document.createElement("div"));
		modal.css({
			"display" : "none",
			"position": "fixed",
			"top": "0",
			"left": "0",
			"z-index": "26",
			"width": "100%",
			"height": "100%",
			"background": "black",
			"opacity": "0.45"
		});
	modal.insertBefore(wrapper);

    var wh = $(window).height(), dh=$(document).height();
    $(window).bind('resize', function(e){
        window.resizeEvt;
        $(window).resize(function(){
            clearTimeout(window.resizeEvt);
                window.resizeEvt = setTimeout(function(){
                    wh = $(window).height();
                    dh=$(document).height();
                }, 200);
        });
    });

	//Aqua Planet Toggle
	btnGate.toggle(function() {
		$(this).parent().css({position:"fixed"});
		$(this).animate({top:"+=118"});
		planetGate.slideDown("easing");
		modal.css({display:"block"});
		wrapper.animate({top:"+=118"});
        if(wh==dh){
            $("html body").css({overflow:"hidden"});
        }else{
            $("html body").css({overflowX:"hidden"});
        }
		//$("html body").css({overflowX:"hidden"});
		if($("#main_poster .photo").length>0) $("#main_poster .photo")[0].clear();
	},function() {
		$(this).parent().css({position:"absolute"});
		$(this).animate({top:"-=118"});
		planetGate.slideUp("easing");
		modal.css({display:"none"});
		wrapper.animate({top:"-=118"},function() {
			$("html body").css({overflow:"auto"});
		});
		if($("#main_poster .photo").length>0) $("#main_poster .photo")[0].auto();
	});

	//메뉴 On,Off
	gateItem.each(function() {
		gateItem.find(">a").on("mouseenter focusin",function() {
			if($(this).parent().hasClass("")) {
				var btn = $(this).find(">img");
				var btnSrc = btn.attr("src").replace("_off.png","_on.png");
				btn.attr("src",btnSrc);
			}
		});
		gateItem.find(">a").on("mouseleave focusout",function() {
			if($(this).parent().hasClass("")) {
				var btn = $(this).find(">img");
				var btnSrc = btn.attr("src").replace("_on.png","_off.png");
				btn.attr("src",btnSrc);
			}
		});
	});
}


function buildPhotoGallery() {
	//노드 설정
	var buildGallery = $("#build_gallery");
	var photo = buildGallery.find(">.photo>img");
	var btnPrev = buildGallery.find(">.btn_set>img.prev");
	var btnNext = buildGallery.find(">.btn_set>img.next");
	var galleryList = buildGallery.find(">ul.gallery");
	var gItem = galleryList.find(">li");

	//갤러리 리스트 넓이
	galleryList.css({width: (110*gItem.size())-2+"px"});

	//옵션
	var o = {
		total: gItem.size(), current: 1
	}

	//갤러리 리스트
	gItem.each(function(i) {
		gItem.find(">a").on("click",function() {
			//갤러리 On,Off
			gItem.eq(i).find(">a").removeClass("on");
			$(this).addClass("on");

			//갤러리 변환
			o.current = $(this).parent().index() + 1;
			photo.attr("src",$(this).attr("href"));
			return false;
		});
	});
	gItem.eq(0).find(">a").click();

	//이전 버튼
	btnPrev.on("click",function() {
		if(o.current <= 1) {
			o.current = o.total;
		} else {
			o.current--;
		};
		gItem.eq(o.current-1).find(">a").click();
	});

	//다음 버튼
	btnNext.on("click",function() {
		if(o.current >= o.total) {
			o.current = 1;
		} else {
			o.current++;
		};
		gItem.eq(o.current-1).find(">a").click();
	});
};
/*
function mainPoster() {
	//앨리먼트 설정
	var poster = $("article#main_poster");
	var photo =  poster.find(">ul.photo");
	var pItem = photo.find(">li");
		pItem.eq(0).show();
	var indicator = poster.find(">nav.indicator");
	var btnInd = indicator.find(">a");
	var player = poster.find(".player>a");

	//옵션
	var o = {
		movement: true,
		current: 1,
		total : pItem.size()
	}

	// Indicator
	btnInd.each(function(i) {
		btnInd.on("click",function() {
			//전체 버튼 Off
			var allBtnImg = btnInd.find(">img");
				allBtnImgSrc = allBtnImg.attr("src").replace("_on.png","_off.png");
				allBtnImg.attr("src",allBtnImgSrc);

			//자기 자신 On
			var myBtnImg = $(this).find(">img");
				myBtnImgSrc = myBtnImg.attr("src").replace("_off.png","_on.png");
				myBtnImg.attr("src",myBtnImgSrc);

			//Fade In & Out
			o.current = $(this).index()+1;
			pItem.eq(o.current - 1).siblings().animate({"opacity":"0"});
			pItem.eq(o.current - 1).animate({"opacity":"1"});
		});
	});

	var autoMove = setInterval(
		function() {
			if(o.movement == true) {
				if(o.current <= o.total) {
					o.current++;
				} else {
					o.current = 1;
				}
				btnInd.eq(o.current - 1).click();
			};
		}
	,3000);

	// 플레이 버튼
	player.on("click",function() {
		if(o.movement == true) {
			var btnSrc = $(this).find(">img").attr("src").replace("_stop.png","_play.png");
			$(this).find(">img").attr("src",btnSrc);
			o.movement = false;
		} else if(o.movement == false) {
			var btnSrc = $(this).find(">img").attr("src").replace("_play.png","_stop.png");
			$(this).find(">img").attr("src",btnSrc);
			o.movement = true;
		}
	});

	//이미지 리 사이징
	var winResize = setInterval(
		function() {
			var winHeight = function() {
				return Math.max(document.documentElement.clientHeight,document.body.clientHeight)
			};
			var winWidth = function() {
				return Math.max(document.documentElement.clientWidth,document.body.clientWidth)
			};
			var imgMargin = pItem.find(">img").width() - winWidth();

			if(winHeight()*1.76 < winWidth()) {
				pItem.find(">img").css({"height": "auto", "width": "100%" , "marginLeft": "0px"});
			} else {
				pItem.find(">img").css({"height": "100%", "width": "auto" , "marginLeft": "-"+imgMargin/2+"px"});
			};
		}
	,100);
};
*/
var mainPoster = function(obj){
	var thisObj = obj.get(0);
	thisObj.item = null, thisObj.time = 3000, thisObj.aflag = false, thisObj.overed = false, thisObj.icoBtn = null, thisObj.onStep = 0, thisObj.autoTy = "auto";
	thisObj.reset = function(){
		var $this = $(this).css({"position":"relative","z-index":"1"}), box = this, inHTML = '';
		this.item = $this.find("li");
		this.item.css({"position":"absolute","left":"0","top":"0"});
		this.curNum = 0;
		$this.parent().find(".btnSet").remove();
		if(this.item.length>1){
			this.onStep = this.item[0].offsetWidth;
			inHTML += '<span class="curIco">';
			this.item.each(function(index){
				if(index!=0) $(this).css({"display":"none","opacity":"0"});
				inHTML += '<a href="#'+(index+1)+'번 배너보기" onclick="return false;"'+(index==0?' class="on"':'')+'>'+(index+1)+' 배너'+'</a>';
			})
			inHTML += '</span>';
			if(this.autoTy=="auto") inHTML += '<a href="#stop" class="stop"><span>슬라이드 수동</span></a>';
			$this.parent().prepend('<span class="btnSet" style="z-index:2;">'+inHTML+'</span>');
			this.icoBtn = $this.parent().find(".btnSet");
			this.icoBtn.find(".stop").click(function(){ box.toggle(this); return false; });
			this.icoBtn.find(".curIco a").each(function(index){ this.curNum = index; $(this).click(function(){ box.clear(); box.change(this.curNum); box.auto(); }); });
			box.repeat = null;
			if(this.autoTy=="auto") this.aflag = true;
			this.auto();
		}else{ this.item.css({"opacity":"1","z-index":"2"}); }
		this.winResize();
	}
	thisObj.change = function(num){
		var icoBtn = this.icoBtn, box = this;
		this.clear();
		num = (num<0) ? this.item.length-1 : ((num>=this.item.length)? 0 : num);
		this.curNum = num;
		this.item.each(function(index){
			if(index==num) $(this).css({"display":"block"}).stop().animate({"opacity":"1"},600);
			else $(this).stop().animate({"opacity":"0"},600,function(){ this.style.display = "none" });
			if(index==num) icoBtn.find(".curIco a").eq(index).addClass("on");
			else icoBtn.find(".curIco a").eq(index).removeClass("on");
		});
		this.winResize();
	}
	thisObj.winResize = function(){
		var imgSize = [2560,1424], minSize = [720,1053];
		var visualBox = $("#main_poster");
		var maxH = Math.max(document.documentElement.clientHeight,document.body.clientHeight,minSize[0]);
		var maxW = Math.max(document.documentElement.clientWidth,document.body.clientWidth,minSize[1]);
		visualBox.css({"width":maxW+"px", "height":maxH+"px"});
		var basepos = (imgSize[0]/imgSize[1]);
		var visual = visualBox.find(".visual").removeAttr("style");
		if(maxH*basepos < maxW) visual.css({"width":"100%","height":"auto"});
		else{
			visual.css({"width":"auto","height":"100%"});
			visual.each(function(){
				if(this.offsetWidth!=0){
					var mgr = ((this.parentNode.offsetWidth-this.offsetWidth)/2);
					visual.css({"margin-left":(mgr>0?0:mgr)+"px"})
				}
			})
		}
	}
	thisObj.toggle = function(obj){ this.clear(); this.aflag = !this.aflag; if(this.aflag){ this.auto(); } $(obj).children().toggleClass("on").attr("alt",function(){ return (this.alt=="슬라이드 수동")?"슬라이드 자동":"슬라이드 수동" }); }
	thisObj.stop = function(){ this.clear(); }
	thisObj.play = function(){ this.clear(); this.auto(); }
	thisObj.auto = function(){ this.clear(); if(!(!this.aflag || this.overed )){ this.autoRepeat(); } }
	thisObj.clear = function(){ clearTimeout(this.repeat); }
	thisObj.autoRepeat = function(){ var next = (this.curNum+1>this.item.length-1) ? 0 : this.curNum+1, box = this; this.repeat = setTimeout(function(){ box.change(next); box.auto(); },box.time); }
	thisObj.reset();
	$(window).resize(thisObj.winResize);
}