package org.lemonparty 
{
	import org.flixel.FlxGroup;
	/**
	 * ...
	 * @author Erik Sy Wong
	 */
	public class K4G 
	{
		public static var map:K4Map;
		public static var logic:PlayState;
		public static var gravity:Number = 500;
		public static var calendar:TimeKeeper;
		public static var lights:FlxGroup;
		public static var gameMap:ColorTilemap;
		
		public static var levelTiles:Vector.<Class> = new Vector.<Class>();  
		public static var levelPipes:Vector.<Class> = new Vector.<Class>();  
		public static var levelSprites:Vector.<Class> = new Vector.<Class>();  
		
		public static var curLevel:uint = 0;
		
		public function K4G(){
			
		}
		
	}

}