package org.lemonparty.units 
{
	import org.lemonparty.Projectile;
	import org.lemonparty.projectiles.luxShot;
	import org.lemonparty.Unit;
	import org.flixel.*;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Hero extends Unit {
		[Embed(source = "../data/hero.png")] private var ImgHero:Class;
		public var canDblJump:Boolean = false;
		public var canWallJump:Boolean = false;
		public function Hero(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			loadGraphic(ImgHero, false, true);
			_jumpPower = 220;
			drag.x = _maxRunSpeed * 10;
			_maxRunSpeed = 160;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			checkKeys();
		}
		
		public function checkKeys():void {
			//Shooting
			if (FlxG.mouse.justPressed()) {
				var slope:FlxPoint = new FlxPoint(FlxG.mouse.x-x-origin.x,FlxG.mouse.y-y-origin.y);
				var slopeLen:Number = sqrt(slope.x * slope.x + slope.y * slope.y);
				var norm:FlxPoint = new FlxPoint(slope.x / slopeLen, slope.y / slopeLen);
				_logic.bullets.add(new luxShot(getMidpoint(), norm));
			}
			
			//Movements
			if (FlxG.keys.A) {
				facing = LEFT;
				if(velocity.x > -_maxRunSpeed)
					acceleration.x -= drag.x;
				
			}else if (FlxG.keys.D) {
				facing = RIGHT;
				if(velocity.x<_maxRunSpeed)
					acceleration.x += drag.x;
			}
			
			//Jumping
			if (FlxG.keys.justPressed("SPACE")&&isTouching(DOWN)) {
				velocity.y -= _jumpPower;
			}
		}
	}

}