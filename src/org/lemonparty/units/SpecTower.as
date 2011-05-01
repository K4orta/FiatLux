package org.lemonparty.units 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class SpecTower extends Unit {
		[Embed(source = "../data/specTower.png")] private var ImgTower:Class;
		public var corruptRange:uint = 2;
		public var tLoc:FlxPoint;
		public function SpecTower(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			loadGraphic(ImgTower, false, true, 83, 91);
			health = 22;
			tLoc = new FlxPoint(int(getMidpoint().x / 96), int(getMidpoint().y / 96));
			corrupt();
		}
		
		override public function update():void {
			super.update();
		}
		
		public function corrupt(From:uint=4, To:uint=6):void {
			var cr:int = corruptRange * 2 + 1;
			var sx:int = tLoc.x - corruptRange;
			var sy:int = tLoc.y - corruptRange;
			var gt:uint;
			var brush:FlxPoint = new FlxPoint();
			for (var i:uint = 0; i < cr;++i ) {
				for (var j:uint = 0; j < cr;++j) {
					brush.make(sx + j, sy + i);
					gt = K4G.logic.pipeMap.getTile(brush.x, brush.y);
					if (gt == From) {
						K4G.logic.pipeMap.setTile(brush.x, brush.y, To);
					}
				}
			}
		}
		
		
	}

}