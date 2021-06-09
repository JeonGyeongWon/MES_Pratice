var root = "../";
var util = {
	user : function(type){
			if(!type) return;
			if(type=="ie") return (!!(window.attachEvent && !window.opera));
			if(type=="firefox") return (navigator.userAgent.toLowerCase().indexOf("firefox")!=-1);
			if(type=="opera") return (!!window.opera);
			if(type=="webkit") return (navigator.userAgent.indexOf("AppleWebKit/") > -1);
			if(type=="gecko") return (navigator.userAgent.indexOf("Gecko") > -1 && navigator.userAgent.indexOf("KHTML") == -1);
			if(type=="mobile") return (navigator.userAgent.match(/iPhone|iPad|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson/i) != null || navigator.userAgent.match(/phone|samsung|lgtel|mobile|skt|nokia|blackberry|android|sony/i) != null);
			return type;
	},
	bigImg : function(obj,$bigObj,$item){
		$bigObj.attr("src",obj.href);
		if($item) $item.removeClass("active").filter(obj).addClass("active");
	},
	reflash: function (containerid, swfid, src, w, h, flashvars, base, wmode, bg) { // flash reWrite.
		var wmode = wmode || "transparent", bg = bg || "none", base = base || "", flashvars = flashvars || "", html = "";
		if (!!(window.attachEvent && !window.opera)) {
		html += "<object id=\"" + swfid + "\" name=\"" + swfid + "\" width=\"" + w + "\" height=\"" + h + "\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/_flash/swflash.cab#version=9,0,0,0\">"
			+ "<param name=\"base\" value=\"" + base + "\" />"
			+ "<param name=\"movie\" value=\"" + src + "\" />"
			+ "<param name=\"wmode\" value=\"" + wmode + "\" />"
			+ "<param name=\"bgcolor\" value=\"" + bg + "\" />"
			+ "<param name=\"flashvars\" value=\"" + flashvars + "\"/>"
			+ "<param name=\"allowScriptAccess\" value=\"always\" />"
			+ "<param name=\"allowFullScreen\" value=\"true\" />"
			+ "<param name=\"quality\" value=\"high\" />"
			+ "</object>";
		} else {
			html += "<embed id=\"" + swfid + "\" name=\"" + swfid + "\" src=\"" + src + "\" flashvars=\"" + flashvars + "\" width=\"" + w + "\" height=\"" + h + "\" quality=\"high\" base=\"" + base + "\" wmode=\"" + wmode + "\" bgcolor=\"" + bg + "\" allowScriptAccess=\"always\" allowFullScreen=\"true\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\"></embed>";
		}
		if($("#" + containerid).length>0) $("#" + containerid).html(html);
		else return html;
	},
	tabChange : function($item){
		$item.click(function(){
			var curObj = this;
			$item.each(function(){
				if(this==curObj){
					if(this.href.split("#").length>1) $("#"+this.href.split("#")[1]).addClass("active");
				}else{
					if(this.href.split("#").length>1) $("#"+this.href.split("#")[1]).removeClass("active");
				}
			});
		})
	},
	trace : function(msg,type){ //util.trace(1);
		if($("#trace").length==0) $("body").append("<div id='trace' style='position:fixed; right:0; bottom:0; padding:5px; width:600px; background:#fff; border:1px solid red;z-index:100;'></div>");
		$box = $("#trace");
		msg = (type) ? $box.html()+" || "+msg : msg;
		$box.html(msg);
	},
	getCookie : function(name){
		var start = document.cookie.indexOf(name + "=");
		var len = start + name.length + 1;
		if ((!start) && (name != document.cookie.substring(0, name.length))) return null;
		if (start == -1) return null;
		var end = document.cookie.indexOf(";", len);
		if (end == -1) end = document.cookie.length;
		return unescape(document.cookie.substring(len, end));
	},
	setCookie : function(name, value, expires, path, domain, secure){
		var today = new Date();
		today.setTime(today.getTime());
		if (expires) expires = expires * 1000 * 60 * 60 * 24;
		var expires_date = new Date(today.getTime() + (expires));
		document.cookie = name+"="+escape(value) +
			((expires) ? ";expires="+expires_date.toGMTString() : "") + //expires.toGMTString()
			((path) ? ";path=" + path : "") +
			((domain) ? ";domain=" + domain : "") +
			((secure) ? ";secure" : "");
	},
	toggleList : function($obj){
		var obj = $obj[0];
		obj.reset = function(){
			obj.t = $obj.find(".listHead"), obj.btn = obj.t.find(".btn"), obj.v = $obj.find(".listBody");
			obj.v.eq(obj.v.length-1).addClass("last");
			if(obj.t.length==0) return;
			obj.btn.each(function(z){
				this.flag = (obj.t[z].className.match(/active/)) ? true : false;
				this.onclick = function(){
					var bThis = this;
					obj.t.each(function(i){
						if(z==i && !obj.btn[i].flag){
							obj.btn[i].flag = true, obj.btn[i].title = bThis.title.replace("열기","닫기");;
							obj.t.eq(i).addClass("active");
							obj.v.eq(i).addClass("active");
						}else{
							obj.btn[i].flag = false, obj.btn[i].title = bThis.title.replace("닫기","열기");
							obj.t.eq(i).removeClass("active");
							obj.v.eq(i).removeClass("active");
						}
					});
					return false;
				}
			});
		}
		obj.reset();
	}
}

//popup
var popup={
	body : null,
	open : function(name, url, width, height, scroll){
		scroll='yes';
		window.open(url, name, 'width='+width+',height='+height+',scrollbars='+scroll+',resizable=yes,toolbar=no,location=no,status=no,menubar=no');
	},
	blank : function(url){ window.open(url); },
	close : function(){ self.close(); return false; },
	resize : function(h){
		var target, targetW;
		$("html").css("overflow","hidden");
		if(this.body.attr("id")=="popWrap") this.body.css({"min-height":0,"height":"auto"});
		var maxH = (this.body.height() > screen.height-100) ? screen.height-100 : this.body.height();
		var maxW = screen.width-100;
		targetW = this.body.width()>maxW ? maxW-this.body.width : 0;
		if(h) target = (h-document.documentElement.clientHeight);
		else target = (maxH-(document.documentElement.clientHeight));
		$("html").css("overflow","auto");
		resizeBy(targetW,target);
	},
	init : function(h){
		h = h || false;
		if($("#popWrap").length>0) this.body = $("#popWrap");
		else this.body = $("body").children().first();
		setTimeout(function(){popup.resize(h);},300);
	}
}

var page={
	wrap : null, active : [0,0,0], depName : ["g", "l", "s"],
	gnb : {
		$obj : null, obj : null, resettimer : null, flag : false, maxH : null, minH : null, dep1 : null, dep2 : null,
		over : function(){
			var gnb = page.gnb;
			if(gnb.$obj.height()==gnb.maxH) return;
			gnb.$obj.find(".dep2").show();
			gnb.$obj.stop().animate({"height":gnb.maxH},300,'easeInOutCubic');
		},
		out : function(){
			var gnb = page.gnb;
			if(gnb.$obj.height()==gnb.minH) return;
			gnb.$obj.stop().animate({"height":gnb.minH},300,'easeInOutCubic');
		},
		one : function(type){
			var gnb = page.gnb;
			gnb.dep1.not(this.parentNode.parentNode).find(".dep2").children().children("a").removeClass("active").end().end().end().end().removeClass("active").filter(this.parentNode.parentNode).addClass("active");
			if(type!=true) gnb.over();
		},
		two : function(type){
			var gnb = page.gnb, $this = $(this);
			gnb.dep2.removeClass("active").filter(this).addClass("active");
			if(type!=true) gnb.one.call($this.parent().parent().prev().find("a")[0]);
		},
		resetaction : function(){
			var gnb = page.gnb;
			if(page.active[0] <= gnb.dep1.length && page.active[0]-1 != -1) gnb.one.call(gnb.dep1.filter("."+page.depName[0]+ page.active[0]).find("strong a")[0], true);
			else gnb.dep1.removeClass("active");
			if(page.active[1] <= gnb.dep1.find(".dep2").children().children("a").length && page.active[1]-1 != -1) gnb.two.call(gnb.dep1.filter("."+page.depName[0]+ page.active[0]).find("."+page.depName[1]+ page.active[1]).children("a")[0], true);
			else gnb.dep2.removeClass("active");
			gnb.out();
		},
		clearreset : function(){ clearTimeout(page.gnb.resettimer); },
		reset : function(nodelay){
			var gnb=page.gnb;
			gnb.clearreset();
			if(gnb.$obj.find(":focus").length>0 || page.gnb.flag) return false;
			if(nodelay===true) gnb.resetaction(true);
			else gnb.resettimer=setTimeout(function(){ gnb.reset(true); }, 300);
		},
		init : function(){
			var gnb = this;
			gnb.$obj = $("#gnb .gnb");
			gnb.$obj.parent().append('<span class="subLine"></span>').parent().prepend('<span class="subLine"></span>'); //그림자 효과.
			gnb.obj = gnb.$obj[0];
			gnb.maxH = gnb.obj.scrollHeight;
			gnb.minH = gnb.obj.offsetHeight;
			gnb.$obj.mouseover(function(){ gnb.flag = true; gnb.clearreset(); gnb.over.call(this); })
				.mouseout(function(){ gnb.flag = false; gnb.reset(); })
				.find("strong a").focus(function(){ gnb.clearreset(); gnb.one.call(this); })
				.each(function(){ if(util.user('mobile')){ this.onclick = function(){ gnb.clearreset(); gnb.one.call(this); return false; } } }) //모바일 클릭
				.mouseover(function(){ gnb.flag = true; gnb.clearreset(); gnb.one.call(this); })
				.blur(gnb.reset);
			gnb.dep1 = gnb.$obj.children();
			gnb.dep2 = gnb.$obj.find(".dep2").hide().children().children("a").focus(gnb.two).mouseover(gnb.two).blur(gnb.reset);
			gnb.resetaction();
		}
	},
	path : {
		$obj : null, resettimer : null, flag : false,
		one : function(){
			$(this).parent().addClass("view").parent().find(".view").not(this.parentNode).removeClass("view").find(".other").slideUp(100).end().end().end().end().end().next().slideDown(100,function(){ this.style.display = "block" });
		},
		two : function(){
			if(this.className.match(/more/)){
				$(this).parent().addClass("active").end().next().css({"display":"block"}).parent().parent().children().not(this.parentNode).removeClass("active").find(".dep3").css({"display":"none"});
			}else{
				$(this).parent().addClass("active").parent().children().not(this.parentNode).removeClass("active").find(".dep3").css({"display":"none"});
			}
		},
		out : function(type){
			page.path.$obj.find(".view").removeClass("view")
				.find(".other").slideUp(100)
				.find(".active").removeClass("active")
				.find(".dep3").css({"display":"none"}).end().end().end().end()
				.find("."+page.depName[1]+page.active[1]).addClass("active").end().find(".sub").not(".fixed").find("."+page.depName[2]+page.active[2]).addClass("active");
		},
		clearreset : function(){ clearTimeout(page.path.resettimer); },
		reset : function(type,nodelay){
			var path=page.path, $this = $(this), curThis = this;
			type = type || "one";
			path.clearreset();
			if($this.find(":focus").length>0 || path.flag) return false;
			if(nodelay===true) path.out.call(this, type);
			else path.resettimer=setTimeout(function(){ path.reset.call(curThis, type, true); }, 100);
		},
		init : function(){
			var path = this;
			if(page.gnb.$obj == 0 || page.active[0] == 0) return;
			var curPath = page.gnb.$obj.find("."+page.depName[0]+page.active[0]);
			var dep2, dep3, dep2This, dep3This;
			var html   = '<div class="location"><div class="locationIn"><a href="../../../main.do" class="home">home</a>';
			html += curPath.find("strong").html();
			dep2 = curPath.children(".dep2").children();

			if( curPath.find("."+page.depName[1]+page.active[1]).length > 0 ){
				html += '<span class="sub">';
				html += '<a href="'+curPath.find("."+page.depName[1]+page.active[1]+" a").first().attr("href")+'"><span class="arr">'+curPath.find("."+page.depName[1]+page.active[1]+" a").first().text()+'</span></a>';
				dep2.each(function(i){
					dep2This = $(this);
					if(dep2.length>0 && i==0) html += '<span class="other">';
					dep3 = dep2This.find(".dep3").children();
					html += '<span class="'+dep2This.attr("class")+' '+dep2This.find("a").first().attr("class")+'"><a href="'+dep2This.find("a").first().attr("href")+'" class="'+(dep3.length>0 ? 'more' : '')+'">'+dep2This.find("a").first().text()+'</a>';
					dep3.each(function(j){
						dep3This = $(this);
						if(j==0) html += '<span class="dep3">';
						html += '<span class="'+dep3This.attr("class")+'"><a href="'+dep3This.find("a").first().attr("href")+'">'+dep3This.find("a").first().text()+'</a></span>';
						if(j==dep3.length-1) html += '</span>';
					});
					html += '</span>';
					if(dep2.length>0 && i==dep2.length-1) html += '</span>';
				});
				html += '</span>';

				dep3 = curPath.find("."+page.depName[1]+page.active[1]).find(".dep3").children();
				if(dep3.length > 0){
					if(dep3.filter("."+page.depName[2]+page.active[2]).length>0){
						html += '<span class="sub">';
						html += '<a href="'+dep3.filter("."+page.depName[2]+page.active[2]).find("a").first().attr("href")+'"><span class="arr">'+dep3.filter("."+page.depName[2]+page.active[2]).find("a").first().text()+'</span></a>';
						if(dep3.length>1) html += '<span class="other">';
							dep3.each(function(j){
							dep3This = $(this);
							html += '<span class="'+dep3This.attr("class")+' '+( dep3This.attr("class")==page.depName[2]+page.active[2]?' active':'' )+'"><a href="'+dep3This.find("a").first().attr("href")+'">'+dep3This.find("a").first().text()+'</a></span>';
						});
						if(dep3.length>1) html += '</span>';
						html += '</span>';
					}
				}
			}
			html += '</div></div>';

			$("#container .titleDep1").after(html);
			this.$obj = $("#container .locationIn");
			if(this.$obj == 0) return;
			page.winTitle();
			var curName = "";
			this.$obj.children().eq(2).addClass("fixed").end().last().each(function(){
				if(this.nodeName.toLowerCase()=="a") $(this).addClass("last");
				else $(this).children("a").first().addClass("last");
			});
			this.$obj.find(".sub").children().each(function(){
				if(this.nodeName.toLowerCase()=="a"){
					curName = $(this).mouseover(function(){ path.flag = true; path.clearreset(); path.one.call(this); }).focus(function(){ path.flag = true; path.clearreset(); path.one.call(this); }).text();
					if(util.user('mobile')){ this.onclick = function(){ path.flag = true; path.clearreset(); path.one.call(this); return false; } } //모바일 클릭
				}else{
					$(this).children().find("a").not(".more").mouseover(function(){ path.flag = true; $(this).parent().parent().children().removeClass("active"); path.two.call(this); }).focus(function(){ path.flag = true; $(this).parent().parent().children().removeClass("active"); }).end().end().find(".more").each(function(){
						if(util.user('mobile')){ this.onclick = function(){ path.flag = true; path.clearreset(); path.two.call(this); return false; } } //모바일 클릭
						$(this).mouseover(function(){ path.flag = true; path.clearreset(); path.two.call(this); })
							.focus(function(){ path.flag = true; path.clearreset(); path.two.call(this); })
							.next().find("a").mouseover(function(){ path.flag = true; path.clearreset(); path.two.call($(this).parent().parent().prev()[0]); })
							.focus(function(){ path.flag = true; path.clearreset(); path.two.call($(this).parent().parent().prev()[0]); });
					});
				}
			});
			this.$obj.find("a").blur(function(){ path.flag = false; path.reset.call(this); })
				.mouseout(function(){ path.flag = false; path.reset.call(this); });
		}
	},
	winTitle : function(){
			var pathTxt = [], addTxt = $(".winTitleAd");
			page.path.$obj.children().each(function(){
				if($(this).children().length>0) pathTxt.push($(this).children().first().text());
				else if($(this).text()!="home") pathTxt.push($(this).text());
			});
			addTxt.each(function(){ pathTxt.push($(this).text()); });
			document.title = pathTxt.join(" > ") +" | "+ document.title;
	},
	footer : {
		$obj : null,
		wing : {
			$obj : null, baseSc : 0, baseMg : 0, maxWidth : 1060,
			sc : function(){
				var wing = page.footer.wing;
				var $obj = ($("html").scrollTop() > $("body").scrollTop()) ? $("html") : (($("html").scrollLeft() > $("body").scrollLeft()) ? $("html") : $("body"));
				var obj = $obj.get(0);
				if(obj.scrollTop <= wing.baseSc) wing.$obj.css({"top":(wing.baseSc-obj.scrollTop)+"px"});
				else wing.$obj.css({"top":0});
				if(obj.clientWidth < wing.maxWidth)  wing.$obj.css({"left":0,"margin-left":(wing.maxWidth-obj.scrollLeft-wing.$obj.width()-20)+"px"});
				else wing.$obj.css({"left":"auto","right":"20px","margin-left":wing.baseMg});
			},
			init : function($obj){
				this.baseSc = (page.active[0]==0) ? 290 : this.$obj.offset().top;
				this.baseMg = ((this.maxWidth/2)-this.$obj.width())+"px";
				if(!util.user("mobile")){
					this.$obj.css({"position":"fixed","top":this.baseSc+"px"})
					$(window, "body", "html").resize(this.sc).scroll(this.sc)
					this.sc();
				}
			}
		},
		family : function(){
			var familySiteDiv = this.$obj.find("#familySiteDiv");
			var familySiteGroup = this.$obj.find("#familySiteGroup");
			var familySiteGo = this.$obj.find(".btnGo");
			var familyList = {
				"1" : '<option value="#">1_1</option>'
												 +'<option value="#">1_1</option>'
												 +'<option value="#">1_2</option>'
												 +'<option value="#">1_3</option>'
			,
				"2" : '<option value="#">2_1</option>'
												 +'<option value="#">2_2</option>'
												 +'<option value="#">2_3</option>'
			}
			for(familyName in familyList) familySiteDiv.append('<option value="'+familyName+'">'+familyName+'</option>');

			familySiteDiv.change(function(){
				if(this.value) familySiteGroup.html('<option value="">그룹사선택</option>'+familyList[this.value]);
				else familySiteGroup.html('<option value="">그룹사선택</option>');
			});
			familySiteGo.click(function(){
				if(familySiteGroup.val()){
					window.open(familySiteGroup.val());
				}else{
					if(familySiteDiv.val()==""){
						alert("패밀리 사이트 분류를 선택해주세요."); familySiteDiv.focus();
					}else{
						alert("패밀리 사이트 그룹사를 선택해주세요."); familySiteGroup.focus();
					}
				}
				return false;
			});
		},
		init : function(){
			this.$obj = $("#footer");
			if(this.$obj.length==0) return;
			this.$obj.find(".gnbWrap").html(page.gnb.$obj.parent().html());
			this.family();
			this.wing.init();
		}
	},
	init : function(){
		this.wrap = $('#wrap');
		this.footer.wing.$obj = $("#footer .sideMenu");
		if(page.wrap.length>0){
			if(!page.wrap[0].className) return;
			if(!page.wrap[0].className.match(/active-/)) return;
			var acNum = page.wrap[0].className.replace(/active-/g,'').split('-');
			for(i=0;i<acNum.length;i++) page.active[i] = parseFloat(acNum[i]);
		}
		this.gnb.init();
		this.footer.init();
		this.path.init();
		$(".viewHead .addFile").each(function(){
			this.title = "첨부파일 목록 열기";
			$(this).find(".fileList a").last().keydown(function(event){
				if(event.keyCode == "9"){ $(this.parentNode.parentNode).find("button").focus(); return false; }
			});
			$(this).find(".file button").click(function(){
				if(this.className.match(/active/)) $(this).attr("title","첨부파일 목록 열기").removeClass("active").parent().parent().find(".fileList").hide();
				else $(this).attr("title","첨부파일 목록 닫기").addClass("active").parent().parent().find(".fileList").show().find("a").first().focus();
				return false;
			});
		});
	}
}

/* 메인에서만 사용 */
var mainSet = {
	$container : null, $item : null, cur : [0, null], $btn : null, $play : null, flag : false, time : 800, aflag : false, repeat : null,
	change : function(type,auto){
		auto = auto || false;
		if(!type || mainSet.flag) return;
		mainSet.flag = true;
		mainSet.cur[1] = mainSet.cur[0];
		mainSet.cur[0] = mainSet.cur[0]+type;
		if(mainSet.cur[0]>=mainSet.$item.length) mainSet.cur[0] = 0;
		if(mainSet.cur[0]<0) mainSet.cur[0] = mainSet.$item.length-1;
		var oneStep = -(mainSet.$container[0].offsetWidth*type);
		mainSet.$item.css({"z-index":"1", "display":"block"}).stop().animate({"left":oneStep+"px"},mainSet.time,'easeInOutCubic',function(){ this.style.display = "none" })
				.eq(mainSet.cur[0]).css({"z-index":"2","left":("100"*type)+"%", "display":"block"}).stop().animate({"left":"0"},mainSet.time,'easeInOutCubic',function(){ mainSet.flag = false; });
		mainSet.btnSet();
	},
	btnSet : function(){
		mainSet.$btn.eq(0).attr("class",function(){
			return (mainSet.cur[0]==0) ? "disabled" : "";
		}).end().eq(1).attr("class",function(){
			return (mainSet.cur[0]==mainSet.$item.length-1) ? "disabled" : "";
		});
	},
	toggle : function(obj){ mainSet.clear(); mainSet.aflag = !mainSet.aflag; if(!mainSet.aflag){ mainSet.auto(); } $(obj).toggleClass("play").html(function(){ return (this.innerHTML.indexOf("수동")>-1)?"슬라이드 자동":"슬라이드 수동"}); },
	stop : function(){ mainSet.clear(); },
	play : function(){ mainSet.clear(); mainSet.auto(); },
	auto : function(){ mainSet.clear(); if(!mainSet.aflag){ mainSet.autoRepeat(); }},
	clear : function(){ clearTimeout(mainSet.repeat); },
	autoRepeat : function(){ mainSet.repeat = setTimeout(function(){ mainSet.change(1,true); mainSet.auto(); },5000); },
	init : function(){
		var mainaddHtml = '';
		this.$container = $('#container');
		this.$item = this.$container.find('.mainItem');
		if(mainSet.$item.length-1 != 0){
			var mainaddHtml = '<span class="controllBtn"><a href="#play">슬라이드 수동</a></span><span class="btnSet"><a href="#prev" class="disabled" onclick="mainSet.change(-1); return false;"><span class="prev">이전 컨텐츠 보기</span></a><a href="#next" onclick="mainSet.change(+1); return false;"><span class="next">다음 컨텐츠 보기</span></a></span>';
			this.$container.prepend(mainaddHtml);
			this.$btn = this.$container.find(".btnSet a");
			this.$play = this.$container.find(".controllBtn a").click(function(){ mainSet.toggle(this); return false; });
			this.auto();
		}
	}
}

