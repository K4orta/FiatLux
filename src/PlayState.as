package{
	import org.flixel.*;
	import org.lemonparty.ColorTilemap;
	import org.lemonparty.*;
	
	public class PlayState extends FlxState{
		
		public var player:FlxGroup = new FlxGroup();
		public var enemies:FlxGroup = new FlxGroup();
		public var lights:FlxGroup = new FlxGroup();
		public var calendar:TimeKeeper;
		public var miscObjects:FlxGroup = new FlxGroup();
		public var collideMap:FlxGroup = new FlxGroup();
		public var items:FlxGroup = new FlxGroup();
		public var gui:K4GUI;
		public var mapLoader:K4Map;
		public var map:ColorTilemap;
		public var curSel:Unit;
		
		[Embed(source = "org/lemonparty/data/tiles.png")] private var ImgTileset:Class;
		[Embed(source = "mapData/Level1.txt", mimeType = "application/octet-stream") ] private var LvlOneData:Class;
		[Embed(source = "mapData/Level1_Sprites.txt", mimeType = "application/octet-stream") ] private var LvlOneSprites:Class;
		override public function create():void{
			FlxG.mouse.hide();
			FlxG.bgColor = 0xff3b424f;
			K4G.logic = this;
			calendar = new TimeKeeper();
			K4G.calendar = calendar;
			K4G.map = new K4Map();
			K4G.lights = lights;
			mapLoader = K4G.map;
			mapLoader.layerMain.loadMap(new LvlOneData(), ImgTileset, 16, 16, 0, 0, 1,1);
			map = mapLoader.layerMain;
			//trace(new LvlOneSprites());
			mapLoader.loadSprites(new LvlOneSprites());
			
			add(mapLoader.layerMain);
			
			add(miscObjects);
			add(player);
			player.add(curSel);
			collideMap.add(player);
			FlxG.camera.setBounds(0, 0, map.width, map.height,true);
			FlxG.camera.follow(curSel);
			
		}
		
		override public function update():void {
			super.update();
			FlxG.collide(collideMap, map);
			
		}
		
	}
}

