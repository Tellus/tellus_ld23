package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import dk.homestead.utils.*;
	
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class CastPointer extends Entity 
	{
		[Embed(source = "../img/wisdom_pointer.png")] public static var WISDOM_SPRITE:Class;
		
		public var castSource:techButton;
		
		public function CastPointer() 
		{
			super();
			
			var pg:Spritemap = new Spritemap(WISDOM_SPRITE, 32, 32);
			addGraphic(pg);
			pg.add("play", Data.FillArray(5), 5, true);
			pg.play("play", true);
			visible = false;
			setHitbox(pg.scaledWidth, pg.scaledHeight);
			
			name = "CASTPOINTER";
		}
		
		override public function update():void 
		{
			super.update();
			
			x = Input.mouseX - halfWidth;
			y = Input.mouseY - halfHeight;
			
			if (Input.mousePressed)
			{
				var o:Array = new Array();
				world.collidePointInto(WorldStructure.TYPE, Input.mouseX, Input.mouseY, o);
				
				if (o.length > 0)
				{
					for each (var e:WorldStructure in o)
					{
						if (e.getTechType() == castSource.getTechType())
						{
							
							e.techUpgrade(castSource.currentTier + 1);
							castSource.setTier(castSource.currentTier + 1);
							(world as GameWorld).stopCast("Upgrading " + e.getTechType());
							break;
						}
					}
					// Assume invalid building.
					(world as GameWorld).stopCast("Wrong building type clicked.");
				}
				else
				{
					(world as GameWorld).stopCast("No building clicked.");
					hide();
				}
			}
		}
		
		public function show(src:techButton):void
		{
			visible = true;
			castSource = src;
		}
		
		public function hide():void
		{
			visible = false;
		}
	}

}