package{
	import org.flixel.*;
	import org.lemonparty.ColorTilemap;
	import org.lemonparty.*;
	
	public class PlayState extends FlxState{
		
		public var player:FlxGroup = new FlxGroup();
		public var enemies:FlxGroup = new FlxGroup();
		public var lights:FlxGroup = new FlxGroup();
		public var bullets:FlxGroup = new FlxGroup();
		public var marks:FlxGroup = new FlxGroup();
		public var enemyBullets:FlxGroup = new FlxGroup();
		public var calendar:TimeKeeper;
		public var miscObjects:FlxGroup = new FlxGroup();
		public var collideMap:FlxGroup = new FlxGroup();
		public var items:FlxGroup = new FlxGroup();
		public var gui:K4GUI;
		public var mapLoader:K4Map;
		public var map:ColorTilemap;
		public var curSel:Unit;
		public var camFollow:FlxObject = new FlxObject();
		
		[Embed(source = "org/lemonparty/data/backBeam.png")] private var ImgTileset:Class;
		[Embed(source = "mapData/Level1_pipes.txt", mimeType = "application/octet-stream") ] private var LvlOneData:Class;
		[Embed(source = "mapData/Level1_Sprites.txt", mimeType = "application/octet-stream") ] private var LvlOneSprites:Class;
		override public function create():void{
			//FlxG.mouse.hide();
			FlxG.bgColor = 0xff3b424f;
			K4G.logic = this;
			calendar = new TimeKeeper();
			K4G.calendar = calendar;
			K4G.map = new K4Map();
			K4G.lights = lights;
			mapLoader = K4G.map;
			mapLoader.layerMain.loadMap(new LvlOneData(), ImgTileset, 96, 96, 0, 0, 1,3);
			map = mapLoader.layerMain;
			//trace(new LvlOneSprites());
			mapLoader.loadSprites(new LvlOneSprites());
			
			add(mapLoader.layerMain);
			
			add(miscObjects);
			add(player);
			add(marks);
			add(bullets);
			player.add(curSel);
			collideMap.add(player);
			FlxG.camera.setBounds(0, 0, map.width, map.height,true);
			FlxG.camera.follow(camFollow);
		}
		
		override public function update():void {
			super.update();
			mapLoader.update();
			calendar.update();
			camFollow.x = curSel.x+(FlxG.mouse.screenX-240)+8;
			camFollow.y = curSel.y+(FlxG.mouse.screenY-120)+16;
			FlxG.collide(collideMap, map);
			
			collideBullets();
		}
		
		public function collideBullets():void {
			var lowI:int = -1;
			var lowDist:Number = Infinity;
			var hitRes:FlxPoint = new FlxPoint();
			var i:int = 0;
			var dx:Number;
			var dy:Number;
			var len:Number;
			
			for each(var a:Projectile in bullets.members) {
				if(a&&a.alive){
					lowI = -1;
					lowDist = Infinity;
					if (!map.ray(a.tail, a.head, hitRes)) {
						a.hitLocs.push(hitRes);
						a.hits.push(map);
					}
					i = 0;
					while (i<a.hitLocs.length) {
						dx = a.hitLocs[i].x - a.ori.x;
						dy = a.hitLocs[i].y - a.ori.y;
						len = Math.sqrt(dx * dx + dy * dy);
						if (len < lowDist) {
							lowDist = len;
							lowI = i;
						}
						++i;
					}
					if (lowI > -1) {
						if (a.hits[lowI] is FlxTilemap) {
							trace("hit map");
							a.kill();
						}else if(a.hits[lowI] is GameObject){
							a.kill();
							trace("hit GameObject");
						}
					}
				}
			}
		}
		
	}
}

