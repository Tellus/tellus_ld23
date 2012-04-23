package tech 
{
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class FieldTech extends techButton 
	{
		[Embed(source = "../../img/wheat_icon.png")] public static const FIELD_ICON:Class;
		
		public function FieldTech() 
		{
			super(FIELD_ICON);
		}

		override public function getTechType():String 
		{
			return "FIELD";
		}
	}

}