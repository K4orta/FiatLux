package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Shadow extends Unit {
		[Embed(source = "../data/spectre.png")] private var ImgShadow:Class;
		protected var _aiDelay:Number = 0;
		protected var _aiDelayMax:Number = 1;
		
		public function Shadow(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			health = 5;
			loadGraphic(ImgShadow, false, true, 32, 32);
			acceleration.y =0;
			facing = LEFT;
			hostileGroup = _logic.player;
			homeGroup = _logic.enemies;
		}
		
		override public function update():void {
			super.update();
			if (_aiDelay <= 0) {
				attTar = lineOfSight(hostileGroup);
				if (attTar) {
					trace("ENEMY SUB SPOTTED!");
				}
				_aiDelay = _aiDelayMax;
			}else {
				_aiDelay -= FlxG.elapsed;
			}
		}
		
	}

}