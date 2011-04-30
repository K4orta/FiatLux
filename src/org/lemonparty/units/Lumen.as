package org.lemonparty.units 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.btree.Node;
	import org.lemonparty.projectiles.luxShot;
	import org.lemonparty.Unit;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Lumen extends Unit{
		
		public var bTree:Node;
		[Embed(source = "../data/lumen.png")] private var ImgLumen:Class;
		public function Lumen(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgLumen, false, true, 23, 23);
			acceleration.y = 0;
			hostileGroup = _logic.enemies;
			homeGroup = _logic.player;
			_coolTime = .6;
		}
		
		override public function update():void {
			super.update();
			if (attTar&&attTar.alive) {
				if (_coolDown <= 0) {
					var emp:FlxPoint = attTar.getMidpoint();
					var slope:FlxPoint = new FlxPoint(emp.x - x - origin.x, emp.y - y - origin.y);
					var len:Number = sqrt(slope.x * slope.x + slope.y *slope.y);
					var norm:FlxPoint = new FlxPoint(slope.x/len, slope.y/len); 
					_logic.bullets.add(new luxShot(getMidpoint(), norm));
					_coolDown = _coolTime;
				}else {
					_coolDown -= FlxG.elapsed;
				}
			}else {
				attTar = lineOfSight(hostileGroup);
			}
			velocity.x = 100;
		}
	}

}