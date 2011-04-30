package org.lemonparty.aiTrees.decorators 
{
	import org.lemonparty.btree.Decorator;
	import org.lemonparty.Unit;
	
	/**
	 * ...
	 * @author K4Orta (Erik Wong)
	 */
	public class LOSCheck extends Decorator 
	{
		
		public function LOSCheck(Parent:Unit = null){
			super(Parent);
			addChild();
		}
		
	}

}