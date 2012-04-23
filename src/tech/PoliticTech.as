package tech 
{
	/**
	 * For politics.
	 * @author Johannes L. Borresen
	 */
	public class PoliticTech extends techButton 
	{
		[Embed(source = "../../img/politic_icon.png")] public static const POLITIC_ICON:Class;
		
		public function PoliticTech() 
		{
			super(POLITIC_ICON);
		}

		override public function getTechType():String 
		{
			return "POLITIC";
		}
	}

}