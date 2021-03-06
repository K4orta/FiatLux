package org.lemonparty 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class Projectile extends FlxObject{
		public static const ANGLE:uint = 1;
		public static const HITBOX:uint = 0;
		
		public var ori:FlxPoint = new FlxPoint();
		public var slope:FlxPoint = new FlxPoint();
		public var normal:FlxPoint = new FlxPoint();
		public var tail:FlxPoint = new FlxPoint();
		public var head:FlxPoint = new FlxPoint();
		public var speed:Number;
		public var life:uint = 0;
		
		public var hits:Vector.<FlxObject>=new Vector.<FlxObject>();
		public var hitLocs:Vector.<FlxPoint>=new Vector.<FlxPoint>();
		protected var _tracer:FlxSprite;
		public var hitType:uint=0;
		public var tracerGfx:Class;
		public var damage:Number = 1;
		public var shooter:Unit;
		
		public function Projectile(Ori:FlxPoint, Normal:FlxPoint, SSpeed:Number=2000, Shooter:Unit=null) {
			super();
			ori=Ori;
			speed = SSpeed;
			normal = Normal;
			slope.make(Normal.x * speed * FlxG.elapsed, Normal.y * speed * FlxG.elapsed);
			shooter = Shooter;
			tail.make(ori.x, ori.y);
			head.make(ori.x+slope.x, ori.y+slope.y);
			
			x=FlxU.min(ori.x, ori.x+slope.x);
			y = FlxU.min(ori.y, ori.y + slope.y);
			
			velocity.x = normal.x * speed;
			velocity.y = normal.y * speed;
			
			width = FlxU.max(FlxU.abs(x - FlxU.max(ori.x, ori.x+slope.x)),2);
			height = FlxU.max(FlxU.abs(y - FlxU.max(ori.y, ori.y + slope.y)), 2);
			moves = false;
			
		}
		
		override public function update(): void {
			if(life>0){
				moves = true;
				tail.make(head.x, head.y);
				head.x += velocity.x*FlxG.elapsed;
				head.y += velocity.y * FlxG.elapsed;
			}
			
			if (_tracer) {
				_tracer.x = tail.x;
				_tracer.y = tail.y;
			}else{
				if (life>0&&tracerGfx) {
					addTracer(tracerGfx);
				}
			}
			++life;
			super.update();
		}
		
		public function addTracer(Tracer:Class):FlxSprite {
			_tracer = new FlxSprite(x, y, Tracer);
			_tracer.origin.x = 0;//_tracer.width;
			//_tracer.moves = false;
			var ang:Number = Math.atan2(slope.y, slope.x);
			_tracer.angle = ang*180/ Math.PI;
			_tracer.y = tail.y;
			_tracer.x = tail.x;
			K4G.logic.marks.add(_tracer);
			return _tracer;
		}
		
		override public function kill():void {
			if (_tracer) {
				_tracer.kill();
			}
			super.kill();
		}
		
	}
}