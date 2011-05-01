package org.lemonparty.aiTrees.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BL_Shoot extends Node 
	{
		
		public function BL_Shoot(Parent:Unit = null){
			super(Parent);
			
		}
		
		override public function run():uint {
			if (parent._coolDown<=0) {
				
			}else {
				parent._coolDown -= FlxG.elapsed;
			}
		}
	}

}