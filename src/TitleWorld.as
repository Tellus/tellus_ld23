package  
{
	import flash.display.SimpleButton;
	import GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import Playtomic.Log;
	
	/**
	 * Just your basic boilerplate title world. Title, start button, and such.
	 * @author Johannes L. Borresen
	 */
	public class TitleWorld extends World 
	{
		[Embed(source="../img/start_button.png")] public static const TITLE_BUTTON_SPRITE:Class;
		
		public var TitleText:Entity;
		public var StartButton:Entity;
		
		public function TitleWorld() 
		{
			
		}
		
		override public function begin():void 
		{
			super.begin();
			
			TitleText = new Entity(FP.halfWidth, FP.halfHeight - (FP.halfHeight / 2), new Text("Tiny Theists"));
			add(TitleText);
			StartButton = new Entity(FP.halfWidth, FP.halfHeight + (FP.halfHeight / 2));
			StartButton.graphic = new Image(TITLE_BUTTON_SPRITE);
			add(StartButton);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				FP.world = new GameWorld();
				Log.CustomMetric("StartedGame", "Meta", true);
				Log.ForceSend();
			}
		}
	}

}