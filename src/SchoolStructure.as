package  
{
	/**
	 * Structure for learning institutions.
	 * @author Johannes L. Borresen
	 */
	public class SchoolStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/school_1.png")] public static const SCHOOL_IMAGE_1:Class;
		
		/**
		 * List of techs, in increasing cost/complexity, for housing.
		 */
		public var schoolTech:Array = new Array(
			"Elders",
			"Debate",
			"Academics",
			"Scientific Method",
			"Basics of Theory",
			"Pedagogy",
			"Intanetz",
			"Automated proof systems");
		
		public function SchoolStructure(parent:GameWorld) 
		{
			super(parent);
		}
		
		override protected function _createImgData():void 
		{
			structImageData.push(SCHOOL_IMAGE_1);
		}
		
		/**
		 * Schools are the primary source of wisdom.
		 * @param	t
		 */
		override public function _getWisIncome(t:int):Number
		{
			return (t+1) * 5;
		}
		
		/**
		 * You don't get much belief from the school system.
		 * @param	t
		 */
		override public function _getPowIncome(t:int):Number
		{
			return t+1;
		}
	}

}