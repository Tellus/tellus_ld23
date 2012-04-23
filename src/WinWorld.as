package  
{
	import dk.homestead.flashpunk.groups.EntityGroup;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	
	/**
	 * Go here if you win!
	 * @author Johannes L. Borresen
	 */
	public class WinWorld extends World 
	{
		public var text:Entity;
		
		public function WinWorld() 
		{
			super();
			trace("Congratulations!");
		}
		
		override public function begin():void 
		{
			super.begin();
			
			text = new Entity(0, 0, new Text("Congratulations!\n\nYou brought your village to the feudal stage!\n(and completed the game)"));
			
			add(text);
			text.x = FP.halfWidth - ((text.graphic as Text).textWidth / 2);
			text.y = FP.halfHeight - ((text.graphic as Text).textHeight / 2);
		}
	}

}