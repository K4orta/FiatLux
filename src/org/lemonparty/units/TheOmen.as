package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	import org.lemonparty.BasicObject;
	import org.lemonparty.K4G;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class TheOmen extends Unit {
		[Embed(source = "../data/theFilth.png")] private var ImgShadow:Class;
		[Embed(source = "../data/Explosion.mp3")] private var SndDie:Class;
		public var corruptRange:uint = 3;
		public var tLoc:FlxPoint;
		public var respawnTimer:Number=9;
		public var respaawnMaxTime:Number = 9;
		
		public function TheOmen(X:Number = 0, Y:Number = 0) {
			super(X, Y, ImgShadow);
			health = 20;
			acceleration.y = 0;
			tLoc = new FlxPoint(int(getMidpoint().x / 96), int(getMidpoint().y / 96));
			corrupt();
		}
		
		override public function update():void {
			super.update();
			var gCount:int = 0;
			if(respawnTimer<=0){
				for each(var a:BasicObject in _logic.enemies.members) {
					if (a && a.alive && a is Shadow) {
						if(getDist(a)<sightRange)
							++gCount;
					}
				}
				if (gCount >= 3) {
					respawnTimer = respaawnMaxTime;
				}else {
					_logic.enemies.add(new Shadow(x + (Math.random() * 64) + 16, y +(Math.random() * 64) + 16));
					
				}
				
			}else {
				respawnTimer -= FlxG.elapsed;
			}
			
		}
		
		override public function kill():void {
			corrupt(6, 4);
			_logic.redrawOnGooChange();
			FlxG.play(SndDie)
			super.kill();
		}
		
		override public function bite(Tar:BasicObject):void {
			
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