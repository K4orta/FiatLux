package{
	import org.flixel.*;
	import org.flixel.plugin.DebugPathDisplay;
	import org.lemonparty.ColorTilemap;
	import org.lemonparty.*;
	import org.lemonparty.units.Hero;
	import org.lemonparty.units.Shadow;
	import org.lemonparty.units.TheOmen;
	
	public class PlayState extends FlxState{
		
		public var player:FlxGroup = new FlxGroup();
		public var enemies:FlxGroup = new FlxGroup();
		public var lights:FlxGroup = new FlxGroup();
		public var bullets:FlxGroup = new FlxGroup();
		public var lightPipes:FlxGroup = new FlxGroup();
		public var marks:FlxGroup = new FlxGroup();
		public var enemyBullets:FlxGroup = new FlxGroup();
		public var particles:FlxGroup = new FlxGroup();
		public var calendar:TimeKeeper;
		public var miscObjects:FlxGroup = new FlxGroup();
		public var collideMap:FlxGroup = new FlxGroup();
		public var bulletsHit:FlxGroup = new FlxGroup();
		public var text:FlxGroup = new FlxGroup();
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
		public var spawnPoint:FlxPoint;
		public var pipeLookup:Array = new Array();
		public var redrawOnGoo:Vector.<Pipe>=new Vector.<Pipe>();
		public var pathDebug:DebugPathDisplay;
		
		public var victory:Boolean = false;
		
		public var sparks:FlxEmitter = new FlxEmitter(0,0,100);
		public var bloodPart:FlxEmitter = new FlxEmitter(0,0,100);
		[Embed(source = "org/lemonparty/data/sparkParts.png")] private var ImgSparks:Class;
		[Embed(source = "org/lemonparty/data/gooParts.png")] private var ImgBlood:Class;
		[Embed(source = "org/lemonparty/data/crosshair.png")] private var ImgCrosshair:Class;
		[Embed(source = "org/lemonparty/data/tiles.png")] private var ImgTileset:Class;
		[Embed(source = "org/lemonparty/data/backBeam.png")] private var ImgLightSet:Class;
		[Embed(source = "org/lemonparty/data/mark.png")] private var ImgMark:Class;
		override public function create():void{
			//FlxG.mouse.hide();
			FlxG.mouse.load(ImgCrosshair,2,-11,-11);
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
			add(text);
			add(enemyBullets);
			add(particles)
			
			player.add(curSel);
			spawnPoint= new FlxPoint(curSel.x, curSel.y);
			enemies.add(omen);
			// meta groups
			collideMap.add(player);
			collideMap.add(enemies);
			collideMap.add(particles);
			collideMap.add(enemyBullets);
			bulletsHit.add(enemies);
			bulletsHit.add(lightPipes);
			
			FlxG.camera.setBounds(0, 0, map.width, map.height,true);
			FlxG.camera.follow(camFollow);
			
			bloodPart.setXSpeed(-100,100);
			bloodPart.setYSpeed( -100, 100);
			bloodPart.bounce = .1;
			bloodPart.makeParticles(ImgBlood, 100, 16, true);
			particles.add(bloodPart);
			
			sparks.setXSpeed(-300,300);
			sparks.setYSpeed( -300, 300);
			sparks.bounce = .3;
			sparks.makeParticles(ImgSparks, 100, 16, true);
			particles.add(sparks);
			FlxG.flash(0xffffffff, 2);
			/*var norm:FlxPoint = new FlxPoint(1,0);
			var tn:FlxPoint = new FlxPoint();
			tn.x = norm.y;
			tn.y = -norm.x 
			trace(tn.x);
			trace(tn.y);*/
			/*
			for each (var a:Unit in enemies.members) {
				if (a is TheOmen) {
					omen = a;
					break;
				}
			}
			
			trace(firstPipe);
			*/
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
		
		public function scoreScreen():void {
			++K4G.curLevel;
			if(K4G.curLevel<2){
				FlxG.switchState(new PlayState());
			}else {
				FlxG.switchState(new VictoryState());
			}
		
		}
		
		public function enemyHitPlayer(Ob1:FlxObject, Ob2:FlxObject):void {
			var en:Unit = Ob1 as Unit;
			var pl:BasicObject = Ob2 as BasicObject;
			en.bite(pl);
		}
		
		public function gooHitPlayer(Ob1:FlxObject, Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var en:BasicObject = Ob2 as BasicObject;
			var gmp:FlxPoint = proj.getMidpoint();
			if(en is Hero){
				en.hurt(proj.damage);
			}else {
				en.hurt(proj.damage*2);
			}
			blood(gmp.x,gmp.y);
			proj.kill();
		}
		
		public function gooHitMap(Ob1:FlxObject, Ob2:FlxObject):void {
			var proj:Projectile = Ob1 as Projectile;
			var en:FlxSprite = Ob2 as BasicObject;
			var gmp:FlxPoint = proj.getMidpoint();
			blood(gmp.x,gmp.y);
			proj.kill();
			
		}
		
		public function redrawOnGooChange():void {
			var trp:Vector.<Pipe> = redrawOnGoo;
			redrawOnGoo = new Vector.<Pipe>();
			for each(var a:Pipe in trp) {
				if(a){
					a.redrawLight();
				}
			}
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
							
							spark( a.hitLocs[lowI].x, a.hitLocs[lowI].y);
							
							a.kill();
						}else if(a.hits[lowI] is BasicObject){
							a.kill();
							if((a as Projectile).shooter&&a.hits[lowI] is Unit)
								(a.hits[lowI]as Unit).shotBy((a as Projectile).shooter);
							a.hits[lowI].hurt(a.damage);
							spark( a.hitLocs[lowI].x, a.hitLocs[lowI].y);
							
							//mark(a.hitLocs[lowI].x,a.hitLocs[lowI].y);
						}
					}
				}
			}
		}
		
		public function spark(X:Number, Y:Number):void {
			sparks.x = X;
			sparks.y = Y
			sparks.start(true, .5, 0.1, 8);
		}
		
		public function blood(X:Number, Y:Number):void {
			bloodPart.x = X;
			bloodPart.y = Y;
			bloodPart.start(true, .7, 0.1, 16);
		}
		
		public function mark(X:Number, Y:Number):void {
			marks.add(new FlxSprite(X,Y,ImgMark));
		}
		
	}
}

