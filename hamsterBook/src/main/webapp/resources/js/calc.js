/**
 * 계산기 관련
 */

var pre_op;

var pre_num;

//키보드 입력 처리 함수
function on_key_down() {
	
	  var key;
	  var isShift;
	  
	  if (window.event) {
	    key = window.event.keyCode;
	    isShift = !!window.event.shiftKey; // typecast to boolean
	  } else {
	    key = ev.which;
	    isShift = !!ev.shiftKey;
	  }
	  
	  if ( isShift ) {
	    switch (key) {
	      case 16:	//쉬프트 입력 무시
	        break;
	      case 56:	//쉬프트 + 8 -> 곱하기
	    	  key = 106;
	    	  break;
	      case 187:	//쉬프트 + = -> 더하기 
	    	  key = 107;
	    	  break;
	      case 189: case 190: case 191:
	    	  // '-', '.', '/'에 쉬프트를 누른 경우이므로 무시
	    	  key = 0;
	    	  break;
	    }
	  }
	
	var keyCode = key;
	
	//상단 숫자키 입력
	if(48 <= keyCode && keyCode <= 57 ) {
		inputNum(keyCode - 48);
		return;
	}
	
	//숫자키패드 입력
	if(96 <= keyCode && keyCode <= 105) {
		inputNum(keyCode - 96);
		return;
	}
	
	switch(keyCode) {
	case 13: case 187:
		equal();
		break;
	case 107:
		inputOp('+');
		break;
	case 109: case 189:
		inputOp('-');
		break;
	case 106:
		inputOp('*');
		break;
	case 111: case 191:
		inputOp('/');
		break;
	case 110: case 190:
		inputNum('.');
		break;
	case 8:
		del();
		break;
	case 67:
		c();
		break;
	}
}

function zzick() {
	alert("찍!");
}

function inputNum(input) {
	
	// 화면이 에러면 지우고 입력 받기
	if(currNum.value == 'error!') c();
	
	// 이미 . 이 입력되어 있을 경우 . 입력은 무시하기
	if(currNum.value.indexOf('.') > -1 && input == '.') {
		return;
	}
	
	// 현재 0(초기 또는 0입력 상태)일 경우
	if (currNum.value == '0' && input != '.') {
		currNum.value = input;
	} else {
		currNum.value += input;
	}
	
}

function inputOp(input) {
	
	//display에 숫자와 연산자 조합이 들어가 있을 경우.. 먼저 계산처리..
	if(isNaN(display.value)) {
		equal();
	}

	// 화면이 에러면 지우고 입력 받기
	if(currNum.value == 'error!') c();
	
	// currNum이 null이고 입력이 -이면 -입력을 currNum에 넣고 리턴
	if(( currNum.value == '' || currNum.value == '0' ) && input == '-') {
		currNum.value = input;
		return;
	}
	
	//display이 비었고 currNum이 비었거나 -뿐이면 리턴 
	if( (currNum.value == '' || currNum.value == '-') && display.value == '') {
		return;
	}

	
	if(isNaN(display.value.charAt(display.value.length - 1)) && (currNum.value.length == 0 || currNum.value == '-')) {
		//display의 마지막이 연산자이면서, curr이 비었거나 -인 경우
		if(currNum.value == '-') {
			//currNum에 -만 입력되어 있으면 지워주기
			currNum.value = '';
		}
		
		display.value = display.value.substring(0, display.value.length-1);
		display.value += input;
		
	} else {
		//display의 마지막이 숫자인 경우
		display.value += currNum.value;
		display.value += input;
		currNum.value = '';
	}

	
}

function del() {
	if(display.value == 'error!') c();
	currNum.value = currNum.value.substring(0, currNum.value.length-1);
	if(currNum.value == '') {
		currNum.value = 0;
	}
}

function equal() {
	
	/*if(display.value == '' && !isNaN(currNum.value)) {
		inputOp(pre_op);
		inputNum(pre_num);
	}*/
	
	//디스플레이가 비었고 currNum만 있을 경우 무시
	if (display.value == '' || currNum.value == '' || currNum.value == '-') {
		return;
	}
	
	//마지막 남은 숫자를 올린다.
	display.value += currNum.value; 
	
	// 숫자만 담은 배열, 정규식을 이용해 숫자를 제외한 문자를 기준으로 자른다.
	var numList = display.value.split(/[\+\-\*\/]/);
	
	/*
	 * 방법. 1. display.value의 길이 만큼 반복문 실행 2. 연산에 사용되는 숫자는 disList에서 차례대로 꺼내와서
	 * left와 right에 할당 3. 최초 연산 시에는 left = disList[0], 이후에는 left = result 4. +, -, *, /
	 * 가 나오면 left와 right를 연산 5. 예외에 대해서는 err() 호출하고 종료
	 */
	
	var result = numList[0];
	var index = 1;
	var left = 0;
	var right = 0;
	
	try {
	
		for (var i = 0; i < display.value.length-1; i++) {
			left = result;
			
			//right가 null일 경우 index 증가시키고 continue
			while(index < numList.length) {
				right = numList[index];
				if (right == '') {
					index++;
				} else {
					break;
				}
			}
			
			var op = display.value.charAt(i);
			var op2 = display.value.charAt(i + 1);

			// 다음이 -일 경우 음수 표현인지 계산 표현인지 확인
			if(op2 == '-') {
				if (op == '+' || op == '-' || op == '*' || op == '/') {
					// 음수 표현에 대한 처리
					right = right * -1;
					i++;
				} else {
					// -계산 표현에 대한 처리
					continue;
				}
			}
			
			if(op == '+') {
				result = Number(left) + Number(right);
				index++;
			} else if (op == '-') {
				result = Number(left) - Number(right);
				index++;
			} else if (op == '*') {
				result = Number(left) * Number(right);
				index++;
			} else if (op == '/') {
				if(Number(right) == 0) {
					err();
					return;
				}
				result = Number(left) / Number(right);
				index++;
			}
			
			//아래는 엔터키 만으로 계산하기 위해 마지막 연산자와 숫자를 저장하는 코드
			pre_op = op;
			pre_num = right;
			
		}
		//디스플레이를 비운다.
		display.value = '';
		
		
		//이하 결과값이 소숫점 포함하는지 여부 검사
		var dotcheck = result + '';
		
		if(dotcheck.indexOf('.') > -1) {
			
			//아래부터는 자바스크립트의 소숫점 계산 오류를 고치는 코드.. 
			var temp_result = result.toFixed(12); //temp_result의 길이는 14
			for (var i = 1; i < temp_result.length; i++) {
				if (temp_result.charAt(temp_result.length - i) == 0 
						|| temp_result.charAt(temp_result.length - i) == '.') {
					result = temp_result.substring(0, temp_result.length - i);
				} else {
					break;
				}
			}
		}
		
		//currNum에 계산 결과를 출력한다.
		currNum.value = result;
		
	} catch(exception) {
		err();
	}

}

//display를 지우고 currNum은 0으로
function c() {
	display.value = '';
	currNum.value = 0;
}

//에러 발생 시...
function err() {
	currNum.value = 'error!';
}