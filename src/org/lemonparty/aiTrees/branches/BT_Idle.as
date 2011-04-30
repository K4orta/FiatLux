package org.lemonparty.aiTrees.branches 
{
	import org.lemonparty.btree.Sequence;
	import org.lemonparty.Unit;
	import org.lemonparty.aiTrees.leafs.BL_Look;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class BT_Idle extends Sequence 
	{
		
		public function BT_Idle(Parent:Unit = null){
			super(Parent);
			addChild(new BL_Look());
		}
		
	}

}