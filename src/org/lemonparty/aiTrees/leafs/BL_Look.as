package org.lemonparty.aiTrees.leafs 
{
	import org.lemonparty.BasicObject;
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BL_Look extends Node 
	{
		
		public function BL_Look(Parent:Unit = null) 
		{
			super(Parent);
			
		}
		
		override public function run():uint {
			var tar:BasicObject = parent.lineOfSight(parent.hostileGroup);
			if (tar&&tar.alive){
				parent.attTar = tar;
				return FAILURE;
			}else {
				return MORE_TIME;
			}
		}
		
	}

}