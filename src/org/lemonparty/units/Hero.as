package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	import org.flixel.*;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Hero extends Unit {
		[Embed(source = "../data/hero.png")] private var ImgHero:Class;
		public function Hero(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			loadGraphic(ImgHero, false, true);
			_jumpPower = 200;
			drag.x = _maxRunSpeed * 10;
			_maxRunSpeed = 150;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			if (FlxG.keys.A) {
				facing = LEFT;
				if(velocity.x > -_maxRunSpeed)
					acceleration.x -= drag.x;
				
			}else if (FlxG.keys.D) {
				facing = RIGHT;
				if(velocity.x<_maxRunSpeed)
					acceleration.x += drag.x;
			}
			
			if (FlxG.keys.justPressed("SPACE")&&isTouching(DOWN)) {
				velocity.y -= _jumpPower;
			}
		}
		
	}

}