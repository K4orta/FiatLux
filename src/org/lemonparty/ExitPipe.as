package org.lemonparty 
{
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class ExitPipe extends Pipe {
		[Embed(source = "data/LPipe.png")] private var ImgPipe:Class;
		public function ExitPipe(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			// god, this is ugly.
			pipeDirs[directions[LEFT]] = true;
			loadRotatedGraphic(ImgPipe, 4);
			width = 16;
			height = 16;
			offset.x = 40;
			offset.y = 40;
			x += 40;
			y += 40;
		}
		
		override public function hurt(Damage:Number):void {
		}
	}

}