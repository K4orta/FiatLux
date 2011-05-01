package org.lemonparty 
{
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class TPipe extends Pipe {
		[Embed(source = "data/TPipe.png")] private var ImgPipe:Class;
		public function TPipe(X:Number = 0, Y:Number = 0) {
			super(X, Y);
			pipeDirs[directions[UP]] = true;
			pipeDirs[directions[LEFT]] = true;
			pipeDirs[directions[RIGHT]] = true;
			loadRotatedGraphic(ImgPipe, 4);
			width = 16;
			height = 16;
			offset.x = 40;
			offset.y = 40;
			x += 40;
			y += 40;
		}
		
	}

}