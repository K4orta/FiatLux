package org.lemonparty 
{
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class LPipe extends Pipe {
		[Embed(source = "data/LPipe.png")] private var ImgPipe:Class;
		public function LPipe(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			// god, this is ugly.
			pipeDirs[directions[UP]] = true;
			pipeDirs[directions[LEFT]] = true;
			loadRotatedGraphic(ImgPipe, 16);
			width = 16;
			height = 16;
			offset.x = 40;
			offset.y = 40;
			x += 40;
			y += 40;
		}
		
	}

}