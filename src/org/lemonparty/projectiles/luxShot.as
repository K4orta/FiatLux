package org.lemonparty.projectiles 
{
	import org.flixel.FlxPoint;
	import org.lemonparty.Projectile;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class luxShot extends Projectile 
	{
		[Embed(source = "../data/luxShot.png")] private var ImgShot:Class;
		public function luxShot(Ori:FlxPoint, Normal:FlxPoint){
			super(Ori, Normal);
			hitType = ANGLE;
			tracerGfx = ImgShot;
		}
		
	}

}