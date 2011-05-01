package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class TheOmen extends Unit {
		[Embed(source = "../data/theFilth.png")] private var ImgShadow:Class;
		public function TheOmen(X:Number = 0, Y:Number = 0) {
			super(X, Y, ImgShadow);
			health = 10;
			acceleration.y = 0;
		}
		
	}

}