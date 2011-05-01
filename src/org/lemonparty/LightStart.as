package org.lemonparty 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class LightStart extends FlxObject 
	{
		public var dir:uint;
		public var normal:FlxPoint;
		public var brush:FlxPoint = new FlxPoint();
		public var map:FlxTilemap;
		public var projected:Boolean = false;
		public function LightStart(X:Number = 0, Y:Number = 0){
			super(X, Y);
			map = K4G.logic.pipeMap;
			dir = RIGHT;
			normal = new FlxPoint(1, 0);
			brush.make(int(X / 96), int(Y / 96))
			//brush.x += normal.x;
			//brush.y += normal.y;
		}
		
		override public function update():void {
			if (!projected) {
				project();
				projected = true;
			}
		}
		
		public function project():void {
			while(map.getTile(brush.x, brush.y)==1){
				if (K4G.logic.pipeLookup[brush.y][brush.x]) {
					var bx:FlxPoint = K4G.logic.pipeLookup[brush.y][brush.x].reroute(normal);
					normal = bx;
					break;
				}
				map.setTile(brush.x, brush.y, (Math.abs(normal.x)>Math.abs(normal.y))?3:2)
				
				brush.x += normal.x;
				brush.y += normal.y;
			};
		}
	}

}