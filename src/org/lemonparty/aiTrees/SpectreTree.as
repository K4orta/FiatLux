package org.lemonparty.aiTrees 
{
	import org.lemonparty.btree.Selector;
	import org.lemonparty.Unit;
	import org.lemonparty.aiTrees.branches.*;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class SpectreTree extends Selector {
		
		public function SpectreTree(Parent:Unit) {
			super(Parent);
			addChild(new Combat(Parent));
		}
		
	}

}