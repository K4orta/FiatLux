package
{

	import org.flixel.*;
	import org.lemonparty.K4G;

	public class MenuState extends FlxState
	{
		
		private var playButton:FlxButton;
		private var devButton:FlxButton;
		[Embed(source = "mapData/Level1_tiles.txt", mimeType = "application/octet-stream") ] private var LvlOneData:Class;
		[Embed(source = "mapData/Level1_pipes.txt", mimeType = "application/octet-stream") ] private var LvlOnePipes:Class;
		[Embed(source = "mapData/Level1_Sprites.txt", mimeType = "application/octet-stream") ] private var LvlOneSprites:Class;
		override public function create():void
		{
			FlxG.bgColor = 0xff000000;
			
			
			devButton = new FlxButton(FlxG.width/2-40,FlxG.height / 3 + 60, "My Site", onSite, onOver);
			devButton.color = 0xffD4D943;
			devButton.label.color = 0xffD8EBA2;
			//add(devButton);
			
			playButton = new FlxButton(FlxG.width/2-40,FlxG.height / 3 + 100, "Click To Play", onPlay, onOver);
			playButton.color = devButton.color;
			playButton.label.color = devButton.label.color;
			add(playButton);
			
			FlxG.mouse.show();
			
			K4G.levelTiles.push(LvlOneData);
			K4G.levelPipes.push(LvlOnePipes);
			K4G.levelSprites.push(LvlOneSprites);
		}
		
		override public function update():void
		{
			super.update();	
		}
		
		protected function onSite():void
		{
			
			FlxU.openURL("http://devianix.com/");
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

