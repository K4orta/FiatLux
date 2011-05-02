package org.lemonparty 
{
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class IPipe extends Pipe 
	{
		[Embed(source = "data/IPipe.png")] private var ImgPipe:Class;
		public function IPipe(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			pipeDirs[directions[UP]] = true;
			pipeDirs[directions[DOWN]] = true;
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