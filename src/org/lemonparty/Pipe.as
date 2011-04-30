package org.lemonparty 
{
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Pipe extends BasicObject 
	{
		public static const CW:uint = 1;
		public static const CCW:uint = 0;
		
		
		
		protected var _top:Boolean = false;
		protected var _left:Boolean = false;
		protected var _right:Boolean = false;
		protected var _bottom:Boolean = false;
		protected var _pipeDirs:Vector.<Boolean> = new Vector.<Boolean>();
		public function Pipe(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			// top, right, bottom, left
			_pipeDirs.push(false);
			_pipeDirs.push(false);
			_pipeDirs.push(false);
			_pipeDirs.push(false);
		}
		
		public function rotate(Dir:uint) {
			var tDir:Boolean = false;
			var i:uint = 0;
			if (Dir == CCW) {
				i = 0;
			}else {
				i = _pipeDirs.length;
			}
			while (i>=0&&i<_pipeDirs.length) {
				tDir = _pipeDirs[i];
			}
			
			 
		}
		
		
	}

}