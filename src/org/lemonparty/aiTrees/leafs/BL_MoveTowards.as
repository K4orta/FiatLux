package org.lemonparty.aiTrees.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BL_MoveTowards extends Node 
	{
		
		public function BL_MoveTowards(Parent:Unit = null) {
			super(Parent);
			
		}
		
		override public function run():uint {
			parent.moveToward(parent.attTar);
			return SUCCESS;
		}
	}

}