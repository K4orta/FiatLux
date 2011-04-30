package org.lemonparty.aiTrees.leafs 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BL_HasTarget extends Node {
		public function BL_HasTarget(Parent:Unit = null) {
			super(Parent);
		}
		override public function run():uint {
			if (parent.attTar&&parent.attTar.alive) {
				return SUCCESS;
			}else {
				return FAILURE;
			}
		}
		
	}

}