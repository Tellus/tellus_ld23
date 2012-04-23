package tech 
{
	/**
	 * For farming.
	 * @author Johannes L. Borresen
	 */
	public class FarmTech extends techButton 
	{
		[Embed(source = "../../img/farm_icon.png")] public static const FARM_ICON:Class;
		
		public function FarmTech() 
		{
			super(FARM_ICON);
		}

		override public function getTechType():String 
		{
			return "FARM";
		}
	}

}