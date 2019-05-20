package xxl {
	import laya.display.Sprite;

	public class Blick extends Sprite {
//		public static var allColor:Array = ["#ff0000", "#00ff00", "#0000ff", "#ffff00", "#336699"];
		public static var allColor:Array = ["#ff0000", "#00ff00", "#0000ff"];
		public static const SIZE:int = 100;//大小

		public var i:int;
		public var j:int;
		public var color:int;
		private var _isSelect:Boolean;
		private var selSp:Sprite;

		
		public function Blick(color:int, col:int, row:int,targetY:int = 0,dur:int = 0) {
			this.mouseEnabled = true; //开启鼠标事件
			this.size(SIZE, SIZE); //放块的宽高
			this.i = col;
			this.j = row;
			this.color = color;
			if (color >= 0 && color < allColor.length) {
				var c:String = allColor[color];
				this.graphics.clear();
				this.graphics.drawRect(1, 1, SIZE - 2, SIZE - 2, c);
			}
			selSp = new Sprite();
			selSp.graphics.drawCircle(SIZE / 2, SIZE / 2, 30, "#000000");
			selSp.alpha = 0.5;
		}

		public function set isSelect(b:Boolean):void {
			_isSelect = b;
			if (b) {
				this.addChild(selSp);
			} else {
				selSp.removeSelf();
			}
		}

		public function get isSelect():Boolean {
			return _isSelect;
		}
	}
}
