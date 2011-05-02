package org.lemonparty.units 
{
	import org.lemonparty.Projectile;
	import org.lemonparty.projectiles.luxShot;
	import org.lemonparty.Unit;
	import org.flixel.*;
	import org.lemonparty.*;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Hero extends Unit {
		[Embed(source = "../data/hero.png")] private var ImgHero:Class;
		[Embed(source = "../data/Jump.mp3")] private var SndJump:Class;
		[Embed(source = "../data/laser1.mp3")] private var SndLaser:Class;
		[Embed(source = "../data/Hurt.mp3")] private var SndHurt:Class;
		[Embed(source = "../data/tone.mp3")] private var SndTone:Class;
		public var canDblJump:Boolean = false;
		public var canWallJump:Boolean = false;
		public var regenTime:Number=1.5;
		public var regenMax:Number = 1.5;
		public var maxHealth:Number = 5;
		public function Hero(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			
			health = maxHealth;
			loadGraphic(ImgHero, false, true);
			_jumpPower = 220;
			maxVelocity.y = K4G.gravity;
			drag.x = _maxRunSpeed * 10;
			drag.y = _maxRunSpeed * 10;
			_maxRunSpeed = 160;
		}
		
		// move this code into the unit class and add hooks.
		/*override public function preUpdate():void {
			var gt:uint = _logic.pipeMap.getTile(int(x / 96), int(y / 96));
			if (gt == 2||gt==3||gt==1) {
				acceleration.y = K4G.gravity / 4;
				_maxRunSpeed = 400;
				_jumpPower = 420;
				_inField = true;
			}else{
				acceleration.y = K4G.gravity;
				_maxRunSpeed = 160;
				_inField = false;
				_jumpPower = 220;
			}
			super.preUpdate();
		}*/
		
		override public function enterField():void {
			_maxRunSpeed = 400;
			_jumpPower = 420;
			acceleration.y = K4G.gravity / 6;
			drag.x = _maxRunSpeed * 10;
			drag.y = _maxRunSpeed * 10;
			regenTime = regenMax;
		}
		
		override public function leaveField():void {
			acceleration.y = K4G.gravity;
			_maxRunSpeed = 160;
			_jumpPower = 220;
			drag.x = _maxRunSpeed * 10;
			drag.y = _maxRunSpeed * 10;
		}
		
		override public function update():void {
			super.update();
			acceleration.x = 0;
			checkKeys();
			if (regenTime <= 0) {
				if(health<maxHealth)
					health+=1
				regenTime=regenMax
			}else if(_inField){
				regenTime -= FlxG.elapsed;
			}
			if (x > _map.width && !_logic.victory) {
				trace("you won!");
				FlxG.play(SndTone);
				_logic.victory = true;
				FlxG.fade(0xffffffff, 2, _logic.scoreScreen);
			}
		}
		
		public function checkKeys():void {
			//Shooting
			if (FlxG.mouse.justPressed()) {
				var slope:FlxPoint = new FlxPoint(FlxG.mouse.x-x-origin.x,FlxG.mouse.y-y-origin.y);
				var slopeLen:Number = sqrt(slope.x * slope.x + slope.y * slope.y);
				var norm:FlxPoint = new FlxPoint(slope.x / slopeLen, slope.y / slopeLen);
				_logic.bullets.add(new luxShot(getMidpoint(), norm, 2, this));
				FlxG.play(SndLaser );
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
			
			if (_inField) {
				acceleration.y =K4G.gravity*.2;
				if (FlxG.keys.W) {
					if(velocity.y > -_maxRunSpeed)
					acceleration.y -= drag.y*.3;
				}else if(FlxG.keys.S) {
					if (velocity.y < _maxRunSpeed)
					acceleration.y += drag.y*.3;
				}
			}
			
			//Jumping
			if (FlxG.keys.justPressed("SPACE")&&(isTouching(DOWN)||_inField)) {
				velocity.y -= _jumpPower;
				FlxG.play(SndJump);
				//FlxG.sounds.
			}
		}
		
		override public function hurt(Dam:Number):void {
			FlxG.play(SndHurt);
			super.hurt(Dam);
		}
		
		override public function kill():void {
			x = _logic.spawnPoint.x;
			y = _logic.spawnPoint.y;
			health = 5;
		}
	}

}