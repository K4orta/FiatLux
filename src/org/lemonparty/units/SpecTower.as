package org.lemonparty.units 
{
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class SpecTower extends Unit {
		[Embed(source = "../data/specTower.png")] private var ImgTower:Class;
		public function SpecTower(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			loadGraphic(ImgTower, false, true, 83, 91);
			health = 22;
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}