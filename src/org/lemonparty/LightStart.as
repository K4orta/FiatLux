package org.lemonparty 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.lemonparty.units.Lumen;
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
		public var next:Pipe;
		public var spawnTimer:Number = 2;
		public var spawnMax:Number = 7;
		public var shortTimer:Number = 0;
		public var waveCount:int = 4;
		public var waveMax:int = 4;
		
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
			super.update();
			if (!projected) {
				project();
				projected = true;
			}
			if (spawnTimer <= 0) {
				
				if (shortTimer < 0) {
					K4G.logic.player.add(new Lumen(x, y));
					--waveCount;
					shortTimer = .8*Math.random();
				}else {
					shortTimer -= FlxG.elapsed;
				}
				
				if (waveCount <= 0) {
					spawnTimer = spawnMax;
					waveCount = waveMax;
				}
			}else {
				spawnTimer -= FlxG.elapsed;
			}
		}
		
		public function project():void {
			while(map.getTile(brush.x, brush.y)==4){
				if (K4G.logic.pipeLookup[brush.y][brush.x]) {
					var bx:FlxPoint = K4G.logic.pipeLookup[brush.y][brush.x].reroute(normal);
					normal = bx;
					next = K4G.logic.pipeLookup[brush.y][brush.x];
					K4G.logic.firstPipe = K4G.logic.pipeLookup[brush.y][brush.x];
					break;
				}
				map.setTile(brush.x, brush.y, (Math.abs(normal.x)>Math.abs(normal.y))?3:2)
				
				brush.x += normal.x;
				brush.y += normal.y;
			};
		}
		
	}

}