package xxl {
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Tween;

	//包内成员可以互相访问
	public class ClearGame {
		//随机的颜色
		private const SIZE:int = 5;
		private const SPEED:Number = 0.4;
		private var a:Blick;
		private var b:Blick;
		private var container:Sprite;
		private var clearArr:Array = []; //保存要清楚的数组
		private var map:Array = []; //二维存放全部的节点数据
		private var mapData:Array = [];

		public function ClearGame() {
			//初始化引擎
			initGame();
		}

		private function initGame():void {
			Laya.init(900 , 900);
			Laya.stage.bgColor = "#3c3c3c";
			container = new Sprite();
			var masker:Sprite = new Sprite();
			masker.graphics.drawRect(1 , 1 , 498 , 498 , "#000000");
			container.mask = masker;
			var flag:Boolean = false;

			mapData = initBlick(); //初始化数据
			while (true) {
				flag = checkData(); //检查数据
				if (flag == false) {
					break;
				} else {
					mapData = initBlick(); //初始化数据
				}
			}

			initView(mapData); //绘制试图
		}

		private function checkData():Boolean {
			//检测二维矩阵存在重复的
			for (var i:int = 0 ; i < mapData.length ; i++) {
				var hasBlick:Boolean;
				hasBlick = checkLine(mapData[i]); //检测一列 数字
				if (hasBlick) {
					return true;
				}
				hasBlick = checkLine(getOneRow(i)); //检测一行 数字
				if (hasBlick) {
					return true;
				}
			}
			return false;
		}

		//遍历查找
		private function checkLine(arr:Array):Boolean {
			var last:int;
			var len:int = arr.length - 1;
			var num:int = 1;

			for (var i:int = 0 ; i < len ; i++) {
				if (arr[i + 1] == arr[i]) {
					last = arr[i];
					++num;
				} else {
					num = 1;
				}
				if (num >= 3) {
					return true;
				}
			}
			return false;
		}

		//得到一行
		private function getOneRow(row:int):Array {
			var rowArr:Array = [];
			for (var i:int = 0 ; i < mapData.length ; i++) {
				rowArr.push(mapData[i][row]);
			}
			return rowArr;
		}

		//返回没有可消除的数据
		private function initBlick():Array {
			var ret:Array = new Array(SIZE);
			for (var i:int = 0 ; i < ret.length ; i++) {
				ret[i] = new Array(SIZE);
				for (var j:int = 0 ; j < SIZE ; j++) {
					ret[i][j] = Math.floor(Math.random() * Blick.allColor.length);
				}
			}
			return ret;
		}

		private function initView(mapData:Array):void {
			console.log(mapData);
			container.pos(50 , 300);
			container.graphics.drawRect(0 , -310 , 500 , 810 , null , "#ffffff");
			Laya.stage.addChild(container);
			for (var i:int = 0 ; i < mapData.length ; i++) { //map[x][y] == color
				var arr:Array = mapData[i];
				map[i] = new Array(arr.length);
				for (var j:int = 0 ; j < arr.length ; j++) {
					var color:int = mapData[i][j];
					var b:Blick = new Blick(color , i , j);
					b.pos(i * Blick.SIZE , j * Blick.SIZE);
					map[i][j] = b; //初始化地图
					container.addChild(b);
					b.on(Event.CLICK , this , onClickBlick);
				}
			}
		}

		private function onClickBlick(e:Event):void {
			var item:Blick = e.target as Blick;
			if (a == null) {
				a = item;
				a.isSelect = true;
			} else if (a != null && a != item && b == null) {
				b = item;
				b.isSelect = true;
			}

			if (a != null && b != null) {
				Laya.timer.once(500 , this , changePos);
			}
		}

		private function changePos():void {
			var ai:int = a.i;
			var aj:int = a.j;
			var bi:int = b.i;
			var bj:int = b.j; //更新坐标位置

			map[ai][aj] = b;
			map[bi][bj] = a; //更新存的map地图
			//交换位置
			a.i = bi;
			a.j = bj;
			b.i = ai;
			b.j = aj;
			//交换精灵节点的
			var bx:Number = b.x;
			var by:Number = b.y;
			b.pos(a.x , a.y);
			a.pos(bx , by);

			a.isSelect = false;
			b.isSelect = false;
			a = null;
			b = null;
			console.log(map);
			Laya.timer.once(1000 , this , checkClear);
		}

		//遍历查找
		private function findClear(arr:Array):Array {
			var findResult:Array = []; //存放总的结果
			var result:Array = []; //存放临时结果
			var lastBlick:Blick = arr[0];
			var curBlick:Blick;
			for (var i:int = 1 ; i < arr.length ; i++) {
				curBlick = arr[i];
				if (lastBlick.color == curBlick.color) {
					result.push(curBlick);
				} else {
					result.unshift(lastBlick);
					saveResult(result , findResult);
					lastBlick = curBlick;
					result = [];
				}
			}
			result.unshift(lastBlick);
			saveResult(result , findResult);
			return findResult;
		}

		//去重
		private function saveResult(arr:Array , findResult:Array):void {
			if (arr.length >= 3) { //保证三个才消除
				for each (var blick:Blick in arr) {
					if (findResult.indexOf(blick) < 0) { //去除重复节点
						findResult.push(blick);
					}
				}
			}
		}

		private function filterCB(element:* , index:int , self:Array):Boolean {
			return self.indexOf(element) === index;
		}

		//检查是否需要消除
		private function checkClear():void {
			var clearList:Array = [];
			for (var i:int = 0 ; i < map.length ; i++) {
				clearList = clearList.concat(findClear(map[i]));
				clearList = clearList.concat(findClear(getOneClickRow(i)));
			}
			//数组去重
			clearList = clearList.filter(filterCB);
			console.log("checkClear()");
			console.log(clearList);
			if (clearList.length >= 3) {
				while (clearList.length > 0) {
					var item:Blick = clearList.pop();
					map[item.i][item.j] = null;
					item.removeSelf();
				}
				resetMap();
			} else {
				clearList = [];
			}
		}

		private function resetMap():void {
			var latestTime:int;
			for (var i:int = 0 ; i < map.length ; i++) {
				var mapCol:Array = map[i]; //拿到每一列
				map[i] = resetCol(mapCol , i); //处理了每一列
				for (var j:int = mapCol.length - 1 ; j >= 0 ; j--) {
					var item:Blick = map[i][j];
					if (item && item.j != j) {
						item.j = j;
						var time:Number = (j * 100 - item.y) / SPEED;
						if (time > latestTime) {
							latestTime = time;
						}
						Animation(item , j * 100 , time); //每个都会动
					} else {
//						Animation(item , (item.j - j)*100);
					}
				}
			}
			Laya.timer.once(latestTime + 200 , this , checkClear);
		}

		private function resetCol(arr:Array , col:int):Array {
			var ret:Array = [];
//			var index:int = arr.length - 1;
			for (var i:int = arr.length - 1 ; i >= 0 ; i--) {
				var b:Blick = arr[i];

				if (b != null) {
//					b.j = index;
					ret.unshift(b);
//					index--;
				}
			}
			//列的前面插空
			var count:int = 5 - ret.length;
			for (var j:int = 0 ; j < count ; j++) {
				ret.unshift(null);
			}
			//
			var posY:int = -1;
			for (var k:int = count - 1 ; k >= 0 ; k--) {

				var item:Blick = ret[k];
				if (item == null) {
					var color:int = Math.floor(Math.random() * Blick.allColor.length);
					item = new Blick(color , col , posY);
					container.addChild(item);
					item.on(Event.CLICK , this , onClickBlick);
					ret[k] = item;

					item.pos(col * 100 , posY * 100);

//					var targetY:int = k * 100;//100 //距离
//					var dur:Number = targetY  * 1000;//时间
//					item.targetY = targetY;
//					item.dur = dur;
					posY--;

				} else {
					break;
				}
			}
			return ret;
		}

		//距 离除 时间
		private function Animation(target:Blick , targetY:Number , time:int = 1000):void {
			Tween.to(target , {y: targetY} , time);
		}

		private function getOneClickRow(row:int):Array {
			var rowArr:Array = [];
			for (var i:int = 0 ; i < map.length ; i++) {
				rowArr.push(map[i][row]);
			}
			return rowArr;
		}
	}
}

