package org.lemonparty.units 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.btree.Node;
	import org.lemonparty.Pipe;
	import org.lemonparty.projectiles.luxShot;
	import org.lemonparty.Unit;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Lumen extends Unit{
		
		public var bTree:Node;
		public var dest:FlxPoint=new FlxPoint(); 
		[Embed(source = "../data/lumen.png")] private var ImgLumen:Class;
		public function Lumen(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			loadGraphic(ImgLumen, false, true, 23, 23);
			acceleration.y = 0;
			hostileGroup = _logic.enemies;
			homeGroup = _logic.player;
			_coolTime = .6;
			_maxRunSpeed = 100;
			
			dest.x = _logic.firstPipe.pipeLoc.x*96+int(Math.random()*64)+16;
			dest.y = _logic.firstPipe.pipeLoc.y*96+int(Math.random()*64)+16;
		}
		
		override public function update():void {
			super.update();
			if (attTar) {
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
				if (!attTar.alive) attTar = null;
			}else {
				attTar = lineOfSight(hostileGroup);
			}
		
			//trace(mtp);
			if (dest &&moveToPoint(dest) < 20) {
				
				var np:Pipe = _logic.pipeLookup[int(y / 96)][int(x / 96)];
				
				if (np && np.next.length > 0) {
					moveNormal = null;
					dest.x=np.next[0].pipeLoc.x*96+int(Math.random()*48)+24;
					dest.y=np.next[0].pipeLoc.y*96+int(Math.random()*48)+24;
				}else {
					//dest = null;
				}
			}else if(moveNormal){
				//velocity.x = _maxRunSpeed*moveNormal.x;
				//velocity.y = _maxRunSpeed*moveNormal.y;
			}
			
			/*if (_logic.pipeMap.getTile(int(x / 96), int(y / 96))==4) {
				moveNormal = _logic.pipeLookup[int(y / 96)][int(x / 96)].whichWay(moveNormal);
			}*/
			/*if (isTouching(RIGHT)) {
				moveNormal.make(-1,0);
			}
			if (isTouching(UP)) {
				moveNormal.make(0,1);
			}*/
			if (isTouching(DOWN)) {
				//trace(mtp)
			}
		}
	}

}