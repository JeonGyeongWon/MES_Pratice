(function ($) {
	var cursorFocus = function (elem) {
		var x = window.scrollX,
		y = window.scrollY;
		elem.focus();
		window.scrollTo(x, y);
	}

	$.fn.numpad = function (options) {

		if (typeof options == 'string') {
			var nmpd = $.data(this[0], 'numpad');
			if (!nmpd)
				throw "Cannot perform '" + options + "' on a numpad prior to initialization!";
			switch (options) {
			case 'open':
				nmpd.open(nmpd.options.target ? nmpd.options.target : this.first());
				break;
			case 'close':
				nmpd.open(nmpd.options.target ? nmpd.options.target : this.first());
				break;
			}
			return this;
		}

		options = $.extend({}, $.fn.numpad.defaults, options);

		// KeyPad 생성자
		var id = 'nmpd' + ($('.nmpd-wrapper').length + 1);
		var nmpd = {};
		var isFlag = false;
		return this.each(function () {

			// KeyPad가 생성되어있다면, 새로 생성
			if ($('#' + id).length == 0) {
				/** @var jQuery 객체에 Keypad 내용 포함 */
				nmpd = $('<div id="' + id + '"></div>').addClass('nmpd-wrapper');
				nmpd.options = options;
				/** @var 입력 필드 표시 */
				var display = $(options.displayTpl).addClass('nmpd-display');
				nmpd.display = display;
				/** @var KeyPad, Button 등 표시 */
				var table = $(options.gridTpl).addClass('nmpd-grid');
				nmpd.grid = table;
				table.append($(options.rowTpl).append($(options.displayCellTpl).append(display).append($('<input type="hidden" class="dirty" value="0"></input>'))));
				/** KeyPad 버튼 구조
				/* 7 8 9 삭제
				 * 4 5 6 초기화
				 * 1 2 3 취소
				 * - 0 . 완료
				 */
				table.append(
					$(options.rowTpl)
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(7).addClass('numero'))) // 7 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(8).addClass('numero'))) // 8 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(9).addClass('numero'))) // 9 버튼
					//					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html(options.textDelete).addClass('del').click(function () {
					//								nmpd.setValue(nmpd.getValue().toString().substring(0, nmpd.getValue().toString().length - 1));
					//							}))) // 삭제
				).append(
					$(options.rowTpl)
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(4).addClass('numero'))) // 4 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(5).addClass('numero'))) // 5 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(6).addClass('numero'))) // 6 버튼
					//					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html(options.textClear).addClass('clear').click(function () {
					//								nmpd.setValue('');
					//							}))) // 초기화
				).append(
					$(options.rowTpl)
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(1).addClass('numero'))) // 1 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(2).addClass('numero'))) // 2 버튼
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(3).addClass('numero'))) // 3 버튼
					//					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html(options.textCancel).addClass('cancel').click(function () {
					//								nmpd.close(false);
					//							}))) // 취소
				).append(
					$(options.rowTpl)
					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html('&plusmn;').addClass('neg').click(function () {
								nmpd.setValue(nmpd.getValue() * (-1));
							}))) // +/-
//					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html('OK/NG').addClass('okng').click(function () {
//								if (!isFlag) {
//									nmpd.setValue("OK");
//									isFlag = true;
//								} else {
//									nmpd.setValue("NG");
//									isFlag = false;
//								}
//							}))) // OK / NG
					.append($(options.cellTpl).append($(options.buttonNumberTpl).html(0).addClass('numero'))) // 0 버튼
					//					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html(options.decimalSeparator).addClass('sep').click(function () {
					//								nmpd.setValue(nmpd.getValue().toString() + options.decimalSeparator);
					//							}))) // , 버튼
					//					.append($(options.cellTpl).append($(options.buttonNumberTpl).html('.').addClass('numero'))) // . 버튼
					.append($(options.cellTpl).append($(options.buttonFunctionTpl).html(options.textDone).addClass('done')))); // 완료
				// KeyPad Background 추가
				nmpd.append($(options.backgroundTpl).addClass('nmpd-overlay').click(function () {
						nmpd.close(false);
					}));
				// KeyPad 구조 추가
				nmpd.append(table);

				// 옵션에 따라 +/- , 버튼 숨기기 기능 작동
				if (options.hidePlusMinusButton) {
					nmpd.find('.neg').hide();
				}
				if (options.hideOkNgButton) {
					nmpd.find('.okng').hide();
				}
				if (options.hideDecimalButton) {
					nmpd.find('.sep').hide();
				}

				// KeyPad 실행 / 종료 이벤트
				if (options.onKeypadCreate) {
					nmpd.on('numpad.create', options.onKeypadCreate);
				}
				if (options.onKeypadOpen) {
					nmpd.on('numpad.open', options.onKeypadOpen);
				}
				if (options.onKeypadClose) {
					nmpd.on('numpad.close', options.onKeypadClose);
				}
				if (options.onChange) {
					nmpd.on('numpad.change', options.onChange);
				}
				(options.appendKeypadTo ? options.appendKeypadTo : $(document.body)).append(nmpd);

				// 숫자 버튼 전용 이벤트
				$('#' + id + ' .numero').bind('click', function () {
					var val;
					if ($('#' + id + ' .dirty').val() == '0') {
						val = $(this).text();
					} else {
						val = nmpd.getValue() ? nmpd.getValue().toString() + $(this).text() : $(this).text();
					}
					nmpd.setValue(val);
				});

				// KeyPad 인스턴스화되면, KeyPad 생성 트리거 작동
				nmpd.trigger('numpad.create');
			} else {
				// 이전에 이미 인스턴스화되었을 경우에, nmpd 변수로 불러옴
				//nmpd = $('#'+id);
				//nmpd.display = $('#'+id+' input.nmpd-display');
			}

			$.data(this, 'numpad', nmpd);

			// nmpd-target 클래스 추가, 숫자키에 수정불가 옵션 적용
			$(this).attr("readonly", true).attr('data-numpad', id).addClass('nmpd-target');

			// KeyPad Open 리스너 등록
			$(this).bind(options.openOnEvent, function () {
				nmpd.open(options.target ? options.target : $(this));
			});

			
			/**
			 * KeyPad에 표시되어 있는 값을 가져온다.
			 * @return string | number
			 */
			nmpd.getValue = function () {
				return isNaN(nmpd.display.val()) ? 0 : nmpd.display.val();
			};

			/**
			 * KeyPad에 표시되어 있는 값을 설정
			 * @param string value
			 * @return jQuery object nmpd
			 */
			nmpd.setValue = function (value) {
				if (nmpd.display.attr('maxLength') < value.toString().length)
					value = value.toString().substr(0, nmpd.display.attr('maxLength'));
				nmpd.display.val(value);
				nmpd.find('.dirty').val('1');
				nmpd.trigger('numpad.change', [value]);
				return nmpd;
			};

			/**
			 * 열려있는 KeyPad화면 종료
			 * @param jQuery object target
			 * @return jQuery object nmpd
			 */
			nmpd.close = function (target) {
				console.log("nmpd.close target >>>>>>>>>> " + target);
				if (target) {
					if (target.prop("tagName") == 'INPUT') {
						target.val(nmpd.getValue().toString().replace('.', options.decimalSeparator));
					} else {
						target.html(nmpd.getValue().toString().replace('.', options.decimalSeparator));
					}
				}
				nmpd.hide();
				nmpd.trigger('numpad.close');
				// 값이 변경되었을 때 change 트리거 실행
				// TODO 값이 실제로 변경되었는지 확인
				//				if (target && target.prop("tagName") == 'INPUT') {
				//					target.trigger('change');
				//				}
				return nmpd;
			};

			/**
			 *  KeyPad화면 열기
			 * @param jQuery object target
			 * @param string initialValue
			 * @return jQuery object nmpd
			 */
			nmpd.open = function (target, initialValue) {
				console.log("nmpd.open target >>>>>>>>>> " + target);
				// 초기 값 설정
				// change 트리거 실행을 피하는 방법 Part.1
				if (initialValue) {
					nmpd.display.val(initialValue);
				} else {
					if (target.prop("tagName") == 'INPUT') {
						nmpd.display.val(target.val());
						nmpd.display.attr('maxLength', target.attr('maxLength'));
					} else {
						nmpd.display.val(isNaN(parseFloat(target.text())) ? '' : parseFloat(target.text()));
					}
				}
				// 처음 생성시 쓰레기 값 생기지 않도록 초기화
				$('#' + id + ' .dirty').val(0);
				cursorFocus(nmpd.show().find('.cancel'));
				position(nmpd.find('.nmpd-grid'), options.position, options.positionX, options.positionY);
				// KeyPad를 여러번 열 때 부작용이 있사오니, 주의 바람
				$('#' + id + ' .done').off('click');
				$('#' + id + ' .done').one('click', function () {
					nmpd.close(target);
				});
				// KeyPad Open 트리거 실행
				nmpd.trigger('numpad.open');
				return nmpd;
			};
		});
	};

	/**
	 * KeyPad 화면 배치
	 */
	function position(element, mode, posX, posY) {
		var x = 0;
		var y = 0;
		if (mode == 'fixed') {
			// 자주 사용하지 않을 정식이
			element.css('position', 'fixed');

			if (posX == 'left') {
				x = 0;
			} else if (posX == 'right') {
				x = $(window).width() - element.outerWidth();
			} else if (posX == 'center') {
				x = ($(window).width() / 2) - (element.outerWidth() / 2);
			} else if ($.type(posX) == 'number') {
				x = posX;
			}
			element.css('left', x);

			if (posY == 'top') {
				y = 0;
			} else if (posY == 'bottom') {
				y = $(window).height() - element.outerHeight();
			} else if (posY == 'middle') {
				y = ($(window).height() / 2) - (element.outerHeight() / 2);
			} else if ($.type(posY) == 'number') {
				y = posY;
			}
			element.css('top', y);
		} else if (mode == 'relative') {
			// 자주 사용할 것만 같은 동식이

			var panX = 384 + 10;
			var totalX = window.innerWidth - panX;
			var curX = event.pageX;
			if (curX > 0 && curX < totalX) {
				x = curX;
			} else {
				x = curX - panX;
			}
			element.css('left', x);

			var panY = 301 + 10;
			var totalY = window.innerHeight - panY;
			var curY = event.pageY;
			if (curY > 0 && curY < totalY) {
				y = curY;
			} else {
				y = curY - panY;
			}
			element.css('top', y);
		}
		return element;
	}

	// KeyPad 기본 옵션
	$.fn.numpad.defaults = {
		target: false,
		openOnEvent: 'click',
		backgroundTpl: '<div></div>',
		gridTpl: '<table></table>',
		displayTpl: '<input type="text" />',
		displayCellTpl: '<td colspan="4"></td>',
		rowTpl: '<tr></tr>',
		cellTpl: '<td></td>',
		buttonNumberTpl: '<button></button>',
		buttonFunctionTpl: '<button></button>',
		gridTableClass: '',
		hideOkNgButton: true,
		hidePlusMinusButton: false,
		hideDecimalButton: true,
		textDone: '완료',
		textDelete: '삭제',
		textClear: '초기화',
		textCancel: '취소',
		//		decimalSeparator: ',',
		decimalSeparator: '.',
		precision: null,
		appendKeypadTo: false,
		position: 'fixed',
		positionX: 'center',
		positionY: 'middle',
		onKeypadCreate: false,
		onKeypadOpen: false,
		onKeypadClose: false,
		onChange: false
	};
})(jQuery);