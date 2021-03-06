package org.lemonparty 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Pipe extends BasicObject {		
		public static const UP:uint = 0;
		public static const RIGHT:uint = 1;
		public static const DOWN:uint = 2;
		public static const LEFT:uint = 3;
		
		//[Embed(source = "data/LPipe.png")] private var ImgPipe:Class;
		public var pipeDirs:Dictionary = new Dictionary();
		public var pipeMap:ColorTilemap;
		public var directions:Vector.<FlxPoint> = new Vector.<FlxPoint>();
		public var next:Vector.<Pipe>=new Vector.<Pipe>(); // Works like a linked list; 
		public var beams:Vector.<FlxPoint>; // Works like a linked list;
		public var emit:Boolean = false;
		public var pipeLoc:FlxPoint;
		[Embed(source = "data/pipeRotate.mp3")] private var SndPipe:Class;
		public function Pipe(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			// top, right, bottom, left
			pipeMap = K4G.logic.pipeMap;
			directions.push(new FlxPoint(0, -1));
			directions.push(new FlxPoint(1, 0));
			directions.push(new FlxPoint(0, 1));
			directions.push(new FlxPoint(-1, 0));
			
			pipeDirs[new FlxPoint(0, -1)] = false;
			pipeDirs[new FlxPoint(1, 0)] = false;
			pipeDirs[new FlxPoint(0, 1)] = false;
			pipeDirs[new FlxPoint( -1, 0)] = false;
			
			pipeLoc = new FlxPoint(int(x / 96), int(y / 96));
			_logic.pipeLookup[pipeLoc.y][pipeLoc.x] = this;
			beams = new Vector.<FlxPoint>();
			
			if (!_logic.firstPipe) {
				_logic.firstPipe = this;
			}
		}
		
		override public function hurt(Damage:Number):void {
			if(Damage>1){
				angle += 90;
				rotate();
			}
		}
		
		public function rotate():void {
			var newDict:Dictionary = new Dictionary();
			newDict[directions[0]] = pipeDirs[directions[directions.length-1]];
			
			for (var i:uint = 0; i < directions.length-1;++i) {
				newDict[directions[i+1]] = pipeDirs[directions[i]]
			}
			pipeDirs = newDict;
			FlxG.play(SndPipe);
			redrawLight();
		}
		
		public function redrawLight():void {
			breakConnections();
			continueLight();
		}
		
		public function continueLight():void {
			var gt:uint;
			pipeMap.setTile(pipeLoc.x, pipeLoc.y, 4)
			for (var i:uint = 0; i < directions.length;++i) {
				if (pipeDirs[directions[i]]==true) {
					gt = pipeMap.getTile(pipeLoc.x+directions[i].x, pipeLoc.y+directions[i].y);
					if ((gt == 2&&Math.abs(directions[i].y)>directions[i].x) || (gt == 3&&Math.abs(directions[i].x)>directions[i].y)) {
						reroute(new FlxPoint( -directions[i].x, -directions[i].y));
						pipeMap.setTile(pipeLoc.x, pipeLoc.y, 1, false );
					}
				}
			}
		}
		
		public function shootBeam(Dir:FlxPoint):void {
			var brush:FlxPoint = new FlxPoint(pipeLoc.x + Dir.x, pipeLoc.y + Dir.y);
			var gt:uint = pipeMap.getTile(brush.x, brush.y);
			var len:uint = 0;
			var gooed:Boolean;
			while (gt==4||gt==6) {
				if (_logic.pipeLookup[brush.y][brush.x]&&_logic.pipeLookup[brush.y][brush.x].next.length<1) {
					next.push(_logic.pipeLookup[brush.y][brush.x]);
					next[next.length - 1].continueLight();
					break;
				}
				if(gt==4 &&!gooed){
					pipeMap.setTile(brush.x, brush.y, (abs(Dir.x) > abs(Dir.y))?3:2)
					
					++len;
				}else {
					gooed = true;
				}
				brush.x += Dir.x;
				brush.y += Dir.y;
				gt = pipeMap.getTile(brush.x, brush.y);
				
				
			}
			if(len>0)
				beams.push(Dir);
			if (gooed)
				_logic.redrawOnGoo.push(this);
		}
		
		public function breakConnections():void {
			//erase beams
			var eraser:FlxPoint;
			var gt:uint;
			if (beams.length > 0) {
				for (var i:uint = 0; i < beams.length;++i) {
					eraser = new FlxPoint(int(x / 96), int(y / 96));
					eraser.x += beams[i].x;
					eraser.y += beams[i].y;
					gt = pipeMap.getTile(eraser.x, eraser.y);
					while (gt == 2 || gt == 3) {
						pipeMap.setTile(eraser.x, eraser.y, 4)
						eraser.x += beams[i].x;
						eraser.y += beams[i].y;
						gt = pipeMap.getTile(eraser.x, eraser.y);
					}
				}
				beams = new Vector.<FlxPoint>();
			}
			pipeMap.setTile(pipeLoc.x, pipeLoc.y, 4,false);
			
			//call this method in any linked pipes
			for (i = 0; i < next.length;++i) {
				next[i].breakConnections();
			}
			next = new Vector.<Pipe>();
		}
		
		// takes a direction vector and returns a direction;
		public function reroute(LightDir:FlxPoint):FlxPoint {
			//passThrough
			for (var j:uint = 0; j < directions.length;++j) {
				if (LightDir.x==directions[j].x && LightDir.y==directions[j].y) {
					break;
				}
			}
			if (pipeDirs[directions[j]] == true) {
				shootBeam(LightDir);
				//beams.push(LightDir);
				return new FlxPoint(LightDir.x, LightDir.y);
			}
			var rev:FlxPoint = new FlxPoint(-LightDir.x,-LightDir.y);
			for (var i:uint = 0; i < directions.length;++i) {
				if (directions[i] == rev){
					continue;
				}else if (pipeDirs[directions[i]] == false) {
					continue;
				}else if(pipeDirs[directions[i]]==true){
					shootBeam(directions[i]);
				}
			}
			
			return new FlxPoint(LightDir.x, LightDir.y);
		}
		
		public function whichWay(LightDir:FlxPoint):FlxPoint {
			//passThrough
			for (var j:uint = 0; j < directions.length;++j) {
				if (LightDir.x==directions[j].x && LightDir.y==directions[j].y) {
					break;
				}
			}
			if (pipeDirs[directions[j]] == true) {
				//beams.push(LightDir);
				return new FlxPoint(directions[j].x, directions[j].y);
			}
			var rev:FlxPoint = new FlxPoint(-LightDir.x,-LightDir.y);
			for (var i:uint = 0; i < directions.length;++i) {
				if (directions[i] == rev){
					continue;
				}else if (pipeDirs[directions[i]] == false) {
					continue;
				}else if(pipeDirs[directions[i]]==true){
					return new FlxPoint(directions[i].x, directions[i].y);
				}
			}
			
			return new FlxPoint(LightDir.x, LightDir.y);
		}
	}

}