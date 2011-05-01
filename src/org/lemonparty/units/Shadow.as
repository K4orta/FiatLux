package org.lemonparty.units 
{
	import org.lemonparty.aiTrees.branches.*;
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
		protected var _aiDelay:Number = 0;
		protected var _aiDelayMax:Number = 1;
		
		public function Shadow(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			health = 8;
			loadGraphic(ImgShadow, false, true, 32, 32);
			acceleration.y =0;
			facing = LEFT;
			hostileGroup = _logic.player;
			homeGroup = _logic.enemies;
			_coolTime = 1;
			cortex = new Selector(this as Unit);
			cortex.addChild(new BT_Combat(this as Unit));
			cortex.addChild(new BT_Idle(this as Unit));
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
					
					_coolDown = _coolTime;
				}else {
					_coolDown -= FlxG.elapsed;
				}
			}
		}
		
	}

}