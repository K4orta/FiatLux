package
{

	import org.flixel.*;
	import org.lemonparty.K4G;

	public class VictoryState extends FlxState
	{
		
		private var playButton:FlxButton;
		private var devButton:FlxButton;
		[Embed(source = "org/lemonparty/data/end.png")] private var GG:Class;
		override public function create():void
		{
			FlxG.flash(0xffffffff, 2);
			FlxG.bgColor = 0xff000000;
			K4G.curLevel = 0;
			add(new FlxSprite(0, 0, GG));
			FlxG.mouse.show();

		}
		
		override public function update():void {
			super.update();
			if (FlxG.mouse.justPressed()) {
				FlxG.switchState(new PlayState());
			}
		}
		
		
		protected function onSite():void
		{
			
		}
		
		protected function onPlay():void
		{
			playButton.exists = false;
			FlxG.switchState(new PlayState());
		}
		
		protected function onOver():void
		{
			//replace with button mouseOver soundeffect
		}
		
	}
}

