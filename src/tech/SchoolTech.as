package tech 
{
	/**
	 * School's out!
	 * @author Johannes L. Borresen
	 */
	public class SchoolTech extends techButton 
	{
		[Embed(source = "../../img/school_icon.png")] public static const SCHOOL_ICON:Class;
		
		public function SchoolTech() 
		{
			super(SCHOOL_ICON);
		}
		
		override public function getTechType():String 
		{
			return "SCHOOL";
		}
	}

}