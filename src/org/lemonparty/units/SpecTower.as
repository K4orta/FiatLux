package org.lemonparty.units 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.lemonparty.BasicObject;
	import org.lemonparty.Projectile;
	import org.lemonparty.Unit;
	import org.lemonparty.K4G;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class SpecTower extends Unit {
		[Embed(source = "../data/specTower.png")] private var ImgTower:Class;
		[Embed(source = "../data/bullseye.png")] private var ImgBullseye:Class;
		[Embed(source = "../data/Explosion.mp3")] private var SndDie:Class;
		public var corruptRange:uint = 6;
		public var tLoc:FlxPoint;
		public var targeter:FlxSprite;
	
		public function SpecTower(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			loadGraphic(ImgTower, true, true, 96, 96);
			addAnimation("Idle", [0]);
			addAnimation("Shoot", [2, 3, 0], 20, false);
			health = 30;
			hostileGroup = _logic.player;
			tLoc = new FlxPoint(int(getMidpoint().x / 96), int(getMidpoint().y / 96));
			corrupt();
			sightRange = 240;
			_coolTime = .6;
			targeter = new FlxSprite(x, y, ImgBullseye);
			_logic.marks.add(targeter);
		}
		
		override public function update():void {
			super.update();
			if (attTar&&attTar.alive&&attTar.getDist(this)<sightRange) {
				if(! targeter.visible){
					targeter.visible = true;
					_coolDown = _coolTime;
				}
				targeter.x = attTar.x;
				targeter.y = attTar.y;
					if (_coolDown <= 0) {
						shootTar(attTar);
						_coolDown = _coolTime;
						targeter.flicker(.6);
					}else {
						_coolDown -= FlxG.elapsed;
					}
				//_logic.mark(attTar.getMidpoint().x,attTar.getMidpoint().y);
			}else {
				attTar = lineOfSight(hostileGroup);
				targeter.visible = false;
				
				for each(var a:Projectile in _logic.bullets.members) {
					if(a&&a.alive){
						if (abs(sDist(a.head)) < sightRange*.7) {
							if(abs(sDist(a.ori)) > sightRange){
								a.kill();
								play("Shoot");
								_logic.spark(a.head.x, a.head.y);
								_logic.blood(a.head.x, a.head.y);
							}
						}
					}
				}
			}
		}
		
		public function sDist(Arg:FlxPoint):Number {
			var gmp:FlxPoint = getMidpoint();
			var dx:Number = Arg.x - gmp.x;
			var dy:Number = Arg.y - gmp.y;
			return sqrt(dx * dx + dy * dy);
		}
		
		public function shootTar(Tar:BasicObject):void {
			Tar.hurt(2);
			play("Shoot");
		}
		
		override public function kill():void {
			corrupt(6, 4);
			_logic.redrawOnGooChange();
			targeter.kill();
			FlxG.play(SndDie);
			super.kill();
		}
		
		override public function bite(Tar:BasicObject):void {
			
		}
		
		public function corrupt(From:uint=4, To:uint=6):void {
			var cr:int = corruptRange * 2 + 1;
			var sx:int = tLoc.x - corruptRange-1;
			var sy:int = tLoc.y - corruptRange-1;
			var gt:uint;
			var brush:FlxPoint = new FlxPoint();
			for (var i:uint = 0; i < cr;++i ) {
				for (var j:uint = 0; j < cr;++j) {
					brush.make(sx + j, sy + i);
					gt = K4G.logic.pipeMap.getTile(brush.x, brush.y);
					if (gt == From) {
						K4G.logic.pipeMap.setTile(brush.x, brush.y, To);
					}
				}
			}
		}
		
		override public function lineOfSight(Group:FlxGroup):BasicObject {
			var rayPnt:FlxPoint = new FlxPoint();
			var rp2:FlxPoint = new FlxPoint();
			var ret:BasicObject;
			for each(var a:BasicObject in Group.members) {
				if (a && a.alive) {
					if (abs(a.getDist(this)) < sightRange) {
						if(_map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
							if (a is Hero) {
								ret = a;
								continue;
							}
							return a;
						}
					}
				}
			}
			if (ret)
				return ret;
			return null;
		}
		
		
		
	}

}