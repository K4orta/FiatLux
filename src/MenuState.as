package
{

	import org.flixel.*;
	import org.lemonparty.K4G;

	public class MenuState extends FlxState
	{
		
		private var playButton:FlxButton;
		private var devButton:FlxButton;
		[Embed(source = "mapData/Level0_tiles.txt", mimeType = "application/octet-stream") ] private var LvlOneData:Class;
		[Embed(source = "mapData/Level0_pipes.txt", mimeType = "application/octet-stream") ] private var LvlOnePipes:Class;
		[Embed(source = "mapData/Level0_Sprites.txt", mimeType = "application/octet-stream") ] private var LvlOneSprites:Class;
		
		[Embed(source = "mapData/Level2_tiles.txt", mimeType = "application/octet-stream") ] private var Lvl2Data:Class;
		[Embed(source = "mapData/Level2_pipes.txt", mimeType = "application/octet-stream") ] private var Lvl2Pipes:Class;
		[Embed(source = "mapData/Level2_Sprites.txt", mimeType = "application/octet-stream") ] private var Lvl2Sprites:Class;
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
			//add(playButton);
			
			FlxG.mouse.show();
			
			K4G.levelTiles.push(LvlOneData);
			K4G.levelPipes.push(LvlOnePipes);
			K4G.levelSprites.push(LvlOneSprites);
			K4G.levelTiles.push(Lvl2Data);
			K4G.levelPipes.push(Lvl2Pipes);
			K4G.levelSprites.push(Lvl2Sprites);
			
			FlxG.switchState(new PlayState());
		}
		
		override public function update():void{
			super.update();	
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

