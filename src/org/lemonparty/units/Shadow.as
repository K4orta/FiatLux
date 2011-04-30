package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Shadow extends Unit {
		[Embed(source = "../data/spectre.png")] private var ImgShadow:Class;
		public function Shadow(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			health = 5;
			loadGraphic(ImgShadow, false, true, 32, 32);
			acceleration.y =0;
			facing = LEFT;
		}
		
		override public function update():void {
			super.update();
			
		}
		
	}

}