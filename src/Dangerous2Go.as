package{
	import org.flixel.*;
	[SWF(width="960", height="480", backgroundColor="#000000")]
	[Frame(factoryClass="Preloader")]

	public class Dangerous2Go extends FlxGame{

		public function Dangerous2Go(){
			super(480,240,MenuState,2, 60, 60);
			
		}

	}

}

