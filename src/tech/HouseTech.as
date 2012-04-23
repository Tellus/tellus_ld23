package tech 
{
	import net.flashpunk.graphics.Image;
	/**
	 * House tech button.
	 * @author Johannes L. Borresen
	 */
	public class HouseTech extends techButton 
	{
		[Embed(source = "../../img/house_icon.png")] public static const HOUSE_ICON:Class;
		
		public function HouseTech() 
		{
			super(HOUSE_ICON);
		}

		override public function getTechType():String 
		{
			return "HOUSE";
		}
	}

}