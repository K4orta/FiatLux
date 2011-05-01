package org.lemonparty.projectiles 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.Projectile;
	import org.flixel.FlxSprite;
	import org.lemonparty.K4G;
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class gooShot extends Projectile 
	{
		[Embed(source = "../data/gooShot.png")] private var ImgShot:Class;
		public function gooShot(Ori:FlxPoint, Normal:FlxPoint, Damage:Number=2){
			super(Ori, Normal, 350);
			hitType = HITBOX;
			
			tracerGfx = ImgShot;
			damage = Damage;
		}
		
		override public function addTracer(Tracer:Class):FlxSprite {
			_tracer = new FlxSprite(x, y);
			_tracer.loadGraphic(ImgShot, true, false, 16, 16);
			_tracer.addAnimation("rot", [0, 1, 2, 3], 8);
			_tracer.play("rot");
			_tracer.origin.x = 0;//_tracer.width;
			_tracer.y = tail.y;
			_tracer.x = tail.x;
			K4G.logic.marks.add(_tracer);
			return _tracer;
		}
		
		override public function update():void {
			if (isTouching(UP)||isTouching(DOWN)||isTouching(LEFT)||isTouching(RIGHT)) {
				kill();
			}
			
			super.update();
			
		}
		
	}

}