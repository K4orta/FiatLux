package org.lemonparty.units 
{
	import org.lemonparty.btree.Node;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class Lumen extends Unit{
		
		public var bTree:Node;
		
		public function Lumen(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null) {
			super(X, Y, SimpleGraphic);
			hostileGroup = _logic.enemies;
		}
		
	}

}