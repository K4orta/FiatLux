package org.lemonparty.units 
{
	import org.lemonparty.aiTrees.branches.*;
	import org.lemonparty.BasicObject;
	import org.lemonparty.btree.*;
	import org.lemonparty.projectiles.gooShot;
	import org.lemonparty.Unit;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Shadow extends Unit {
		[Embed(source = "../data/spectre.png")] private var ImgShadow:Class;
		[Embed(source = "../data/enemydies.mp3")] private var SndDie:Class;
		[Embed(source = "../data/enemyHurt.mp3")] private var SndHurt:Class;
		[Embed(source = "../data/enemyShoot.mp3")] private var SndShoot:Class;
		
		public function Shadow(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			health = 10;
			loadGraphic(ImgShadow, false, true, 32, 32);
			acceleration.y =0;
			facing = LEFT;
			hostileGroup = _logic.player;
			homeGroup = _logic.enemies;
			_coolTime = .8;
			cortex = new Selector(this as Unit);
			cortex.addChild(new BT_Combat(this as Unit));
			cortex.addChild(new BT_Idle(this as Unit));
			_maxRunSpeed = 90;
			sightRange = 300;
		}
		
		override public function update():void {
			super.update();
			cortex.run();
			if(attTar){
				if (_coolDown <= 0) {
					var emp:FlxPoint = attTar.getMidpoint();
					var slope:FlxPoint = new FlxPoint(emp.x - x - origin.x, emp.y - y - origin.y);
					var len:Number = sqrt(slope.x * slope.x + slope.y *slope.y);
					var norm:FlxPoint = new FlxPoint(slope.x/len, slope.y/len); 
					_logic.enemyBullets.add(new gooShot(getMidpoint(), norm));
					FlxG.play(SndShoot);
					_coolDown = _coolTime;
				}else {
					_coolDown -= FlxG.elapsed;
				}
			}
		}
		
		override public function hurt(Arg:Number):void {
			super.hurt(Arg);
			FlxG.play(SndHurt);
		}
		
		override public function kill():void {
			super.kill();
			FlxG.play(SndDie);
		}
		
		
		
	}

}