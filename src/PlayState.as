package{
	import org.flixel.*;
	import org.flixel.plugin.DebugPathDisplay;
	import org.lemonparty.ColorTilemap;
	import org.lemonparty.*;
	import org.lemonparty.units.Hero;
	import org.lemonparty.units.TheOmen;
	
	public class PlayState extends FlxState{
		
		public var player:FlxGroup = new FlxGroup();
		public var enemies:FlxGroup = new FlxGroup();
		public var lights:FlxGroup = new FlxGroup();
		public var bullets:FlxGroup = new FlxGroup();
		public var lightPipes:FlxGroup = new FlxGroup();
		public var marks:FlxGroup = new FlxGroup();
		public var enemyBullets:FlxGroup = new FlxGroup();
		public var calendar:TimeKeeper;
		public var miscObjects:FlxGroup = new FlxGroup();
		public var collideMap:FlxGroup = new FlxGroup();
		public var bulletsHit:FlxGroup = new FlxGroup();
		public var items:FlxGroup = new FlxGroup();
		public var gui:K4GUI;
		public var mapLoader:K4Map;
		public var map:ColorTilemap;
		public var pipeMap:ColorTilemap; 
		public var curSel:Unit;
		public var omen:Unit;
		public var pathThrough:FlxPath;
		public var camFollow:FlxObject = new FlxObject();
		
		public var firstPipe:Pipe;
		
		public var pipeLookup:Array = new Array();
		public var pathDebug:DebugPathDisplay;
		
		[Embed(source = "org/lemonparty/data/tiles.png")] private var ImgTileset:Class;
		[Embed(source = "org/lemonparty/data/backBeam.png")] private var ImgLightSet:Class;
		[Embed(source = "org/lemonparty/data/mark.png")] private var ImgMark:Class;
		override public function create():void{
			//FlxG.mouse.hide();
			pathDebug = new DebugPathDisplay();
			FlxG.addPlugin(pathDebug);
			FlxG.bgColor = 0xff3b424f;
			K4G.logic = this;
			calendar = new TimeKeeper();
			K4G.calendar = calendar;
			K4G.map = new K4Map();
			K4G.lights = lights;
			mapLoader = K4G.map;
			mapLoader.layerMain.loadMap(new K4G.levelTiles[K4G.curLevel](), ImgTileset, 16, 16, 0, 0, 1, 1);
			mapLoader.backLayer.loadMap(new K4G.levelPipes[K4G.curLevel](), ImgLightSet, 96, 96, 0, 0, 1, 4);
			map = mapLoader.layerMain;
			pipeMap = mapLoader.backLayer;
			//trace(new LvlOneSprites());
			setupPipes();
			mapLoader.loadSprites(new K4G.levelSprites[K4G.curLevel]());
			
			add(mapLoader.backLayer);
			add(mapLoader.layerMain);
			add(lightPipes);
			add(miscObjects);
			add(enemies)
			add(player);
			add(marks);
			add(bullets);
			add(enemyBullets);
			
			player.add(curSel);
			enemies.add(omen);
			// meta groups
			collideMap.add(player);
			collideMap.add(enemies);
			collideMap.add(enemyBullets);
			bulletsHit.add(enemies);
			bulletsHit.add(lightPipes);
			
			FlxG.camera.setBounds(0, 0, map.width, map.height,true);
			FlxG.camera.follow(camFollow);
			
			/*var norm:FlxPoint = new FlxPoint(1,0);
			var tn:FlxPoint = new FlxPoint();
			tn.x = norm.y;
			tn.y = -norm.x 
			trace(tn.x);
			trace(tn.y);*/
			
			for each (var a:Unit in enemies.members) {
				if (a is TheOmen) {
					omen = a;
					break;
				}
			}
			
			trace(firstPipe);
			
		}
		
		override public function update():void {
			super.update();
			mapLoader.update();
			calendar.update();
			camFollow.x = curSel.x+(FlxG.mouse.screenX-240)+8;
			camFollow.y = curSel.y+(FlxG.mouse.screenY-120)+16;
			
			var fdb:FlxBasic = bullets.getFirstDead();
			if (fdb)
				bullets.remove(fdb, true);
			var fdp:FlxBasic = player.getFirstDead();
			if (fdp)
				player.remove(fdp, true);
		
			FlxG.collide(collideMap, map);
			FlxG.overlap(bullets, bulletsHit, bulletHitEnemy);
			FlxG.overlap(enemyBullets, player, gooHitPlayer);
			//FlxG.collide(enemyBullets, map, gooHitMap);
			FlxG.overlap(enemies, player, enemyHitPlayer);
			collideBullets();
		}
		
		public function enemyHitPlayer(Ob1:FlxObject, Ob2:FlxObject):void {
			if (Ob2 is Hero) {
				Ob2.hurt(1);
			}else {
				Ob2.kill();
			}
			//Ob1.bite(Ob2);
		}
		
		public function gooHitPlayer(Ob1:FlxObject, Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var en:BasicObject = Ob2 as BasicObject;
			en.hurt(proj.damage);
			proj.kill();
		}
		
		public function gooHitMap(Ob1:FlxObject, Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var en:FlxSprite = Ob2 as BasicObject;
			
			proj.kill();
			
		}
		
		public function bulletHitEnemy(Ob1:FlxObject, Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var en:BasicObject = Ob2 as BasicObject;
			var hitLoc:FlxPoint;
			if(en){
			hitLoc = en.ray(proj.tail, proj.head, proj.normal);
			if (hitLoc) {
				proj.hits.push(en);
				proj.hitLocs.push(hitLoc);
			}
			}
		}
		
		public function setupPipes():void {
			for (var i:uint = 0; i < map.heightInTiles;++i) {
				pipeLookup[i] = new Array();
				for (var j:uint = 0; j < map.widthInTiles;++j ) {
					pipeLookup[i][j] = null;
				}
			}
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
							//mark(a.hitLocs[lowI].x,a.hitLocs[lowI].y);
							a.kill();
						}else if(a.hits[lowI] is BasicObject){
							a.kill();
							a.hits[lowI].hurt(a.damage);
							//mark(a.hitLocs[lowI].x,a.hitLocs[lowI].y);
						}
					}
				}
			}
		}
		
		public function mark(X:Number, Y:Number):void {
			marks.add(new FlxSprite(X,Y,ImgMark));
		}
		
	}
}

