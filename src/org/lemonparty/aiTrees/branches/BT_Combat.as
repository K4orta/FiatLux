package org.lemonparty.aiTrees.branches 
{
	import org.lemonparty.btree.Sequence;
	import org.lemonparty.Unit;
	import org.lemonparty.aiTrees.leafs.*;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BT_Combat extends Sequence {
		public function BT_Combat(Parent:Unit = null){
			super(Parent);
			addChild(new BL_HasTarget());
			addChild(new BL_MoveTowards());
		}
		
	}

}