package org.lemonparty 
{
	import flash.utils.Dictionary;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Pipe extends BasicObject 
	{		
		
		public static const UP:uint = 0;
		public static const RIGHT:uint = 1;
		public static const DOWN:uint = 2;
		public static const LEFT:uint = 3;
		
		//[Embed(source = "data/LPipe.png")] private var ImgPipe:Class;
		public var pipeDirs:Dictionary = new Dictionary();
		public var directions:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		public var next:Vector.<Pipe>; // Works like a linked list; 
		public var beams:Vector.<FlxPoint>; // Works like a linked list;
		public var emit:Boolean = false;
		
		public function Pipe(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			// top, right, bottom, left
			directions.push(new FlxPoint(0, -1));
			directions.push(new FlxPoint(1, 0));
			directions.push(new FlxPoint(0, 1));
			directions.push(new FlxPoint(-1, 0));
			
			pipeDirs[new FlxPoint(0, -1)] = false;
			pipeDirs[new FlxPoint(1, 0)] = false;
			pipeDirs[new FlxPoint(0, 1)] = false;
			pipeDirs[new FlxPoint( -1, 0)] = false;
			
			var vat:FlxPoint = new FlxPoint(6, 7);
			_logic.pipeLookup[int(y / 96)][int(x / 96)] = this;
		}
		
		override public function hurt(Damage:Number):void {
			
		}
		
		public function rotate():void {
			var tDir:Boolean = false;
			tDir = pipeDirs[directions[LEFT]];
			for (var i:uint = 1; i < directions.length;++i) {
				pipeDirs[directions[i]] = pipeDirs[directions[i - 1]];
			}
			pipeDirs[directions[0]] = tDir;
		}
		
		public function shootBeam(Dir:FlxPoint):void {
			
		}
		
		public function breakConnections():void {
			
		}
		
		// takes a direction vector and returns a direction;
		public function reroute(LightDir:FlxPoint):FlxPoint {
			//passThrough
			return new FlxPoint(-LightDir.y,LightDir.x);
		}
		
	}

}