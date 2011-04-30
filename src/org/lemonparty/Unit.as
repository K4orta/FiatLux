package org.lemonparty 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPath;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.lemonparty.btree.Node;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Unit extends GameObject implements IEventDispatcher{
		protected var _maxRunSpeed:Number;
		protected var _jumpPower:Number;
		protected var _inField:Boolean;
		public var attTar:BasicObject;
		public var susOb:BasicObject;
		public var cortex:Node;
		public var sightRange:Number = 300;
		public var hostileGroup:FlxGroup;
		public var homeGroup:FlxGroup;
		protected var evd:EventDispatcher = new EventDispatcher(this as IEventDispatcher);
		public var ptf:FlxPath;
		public var canAttack:Boolean = true;
		public var _coolDown:Number= 0;
		public var _coolTime:Number = 1.5;
		
		public var carrying:GameObject;
		public static const HEALTH_CHANGED:String = "healthChanged";
		public static const GRABBED_ITEM:String = "grabItem";
		public static const GOT_ITEM:String = "gotItem";
		public static const DROPPED_ITEM:String = "dropItem";
		
		public function Unit(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null){
			super(X, Y, SimpleGraphic);
			acceleration.y = 420;
			_maxRunSpeed = 100;
			drag.x = _maxRunSpeed * 10;
		}
		
		override public function update():void {
			super.update();
		}
		// Hooks for AI
		public function enterCombat():void {
			
		}
		
		public function exitCombat():void {
			
		}
		
		public function alertFriends():void {
			
		}
		
		public function moveToward(Target:FlxObject):void {
			var emp:FlxPoint = Target.getMidpoint();
			var slope:FlxPoint = new FlxPoint(emp.x - x - origin.x, emp.y - y - origin.y);
			var len:Number = sqrt(slope.x * slope.x + slope.y *slope.y);
			var norm:FlxPoint = new FlxPoint(slope.x / len, slope.y / len);
			
			velocity.x = _maxRunSpeed * norm.x;
			velocity.y = _maxRunSpeed * norm.y;
		}
		
		override public function hurt(Damage:Number):void {
			flicker(1);
			super.hurt(Damage);
		}
		
		public function grabItem(Ob1:FlxObject, Ob2:FlxObject):GameObject{
			var ti:GameObject=Ob2 as GameObject
			//carrying = ;
			if (ti.canPickup&&!carrying) {
				carrying = ti;
				carrying.solid = false;
				carrying.acceleration.y = 0;
				carrying.owner = this;
				carrying.onPickup();
				//addToInv(ti,true);
				dispatchEvent(new Event(GRABBED_ITEM));
			}else if (!ti.canPickup && ti.canUse) {
				ti.onUse();
			}
			
			return ti;
		}
		
		public function dropItem(Thrown:Boolean=false):GameObject {
			carrying.onDrop();
			carrying.solid = true;
			carrying.acceleration.y = K4G.gravity;
			
			if (Thrown) {
				carrying.velocity.x = velocity.x+(facing?150:-150);
			}else {
				carrying.velocity.y += velocity.y;
				carrying.velocity.x += velocity.x;
			}
			dispatchEvent(new Event(DROPPED_ITEM));
			var tc:GameObject = carrying;
			carrying.owner = null;
			carrying = null;
			return tc;
		}
		
		public function combatSight(a:BasicObject):BasicObject {
			//check against attTar;
			var rayPnt:FlxPoint = new FlxPoint();
			if(_map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
				return a;
			}
			return null;
		}
		
		public function lineOfSight(Group:FlxGroup):BasicObject {
			var rayPnt:FlxPoint = new FlxPoint();
			var rp2:FlxPoint = new FlxPoint();
			for each(var a:BasicObject in Group.members) {
				if (a && a.alive) {
					if ((facing == LEFT && a.x > x) || (facing == RIGHT && a.x < x))
						continue;
					if (abs(a.getDist(this)) < sightRange) {
						if(_map.ray(new FlxPoint(x+origin.x, y),new FlxPoint(a.x+a.origin.x, a.y+a.origin.y),rayPnt)){
							
							// put a check here to look at miscItems and make sure they don't block 
							/*for each(var b:GameObject in _logic.miscObjects.members) {
								if (b.solid||b.blocksSight) {
									rayPnt.x = x + origin.x;
									rayPnt.y = y+3;
									rp2.x = a.x + a.origin.x;
									rp2.y = a.y + a.origin.y;
									if (K4G.rayAABB(rayPnt, rp2, b)) {
										return null;
									}
								}
							}*/
							return a;
						}
					}
				}
			}
			return null;
		}
		
		// __________________________________________ GETTER/SETTERS
		public function get inv():Inventory {
			return null;
		}
		//___________________________________________ EVENT INTERFACE
		
		public function addEventListener(Type:String, Listener:Function, UseCapture:Boolean = false, Priority:int = 0, UseWeak:Boolean=false):void{
			evd.addEventListener(Type, Listener, UseCapture, Priority);
		}
           
		public function dispatchEvent(Evt:Event):Boolean{
			return evd.dispatchEvent(Evt);
		}
    
		public function hasEventListener(Type:String):Boolean{
			return evd.hasEventListener(Type);
		}
    
		public function removeEventListener(Type:String, Listener:Function, UseCapture:Boolean = false):void{
			evd.removeEventListener(Type, Listener, UseCapture);
		}
                   
		public function willTrigger(Type:String):Boolean {
			return evd.willTrigger(Type);
		}	
		
	}

}