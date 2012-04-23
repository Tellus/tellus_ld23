package  
{
	/**
	 * Structure for learning institutions.
	 * @author Johannes L. Borresen
	 */
	public class SchoolStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/school/school_1.png")] public static const SCHOOL_IMAGE_1:Class;
		[Embed(source = "../img/structs/school/school_2.png")] public static const SCHOOL_IMAGE_2:Class;
		[Embed(source = "../img/structs/school/school_3.png")] public static const SCHOOL_IMAGE_3:Class;
		[Embed(source = "../img/structs/school/school_4.png")] public static const SCHOOL_IMAGE_4:Class;
		[Embed(source = "../img/structs/school/school_5.png")] public static const SCHOOL_IMAGE_5:Class;
		[Embed(source = "../img/structs/school/school_6.png")] public static const SCHOOL_IMAGE_6:Class;
		[Embed(source = "../img/structs/school/school_7.png")] public static const SCHOOL_IMAGE_7:Class;
		[Embed(source = "../img/structs/school/school_8.png")] public static const SCHOOL_IMAGE_8:Class;
		
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
			structImageData.push(SCHOOL_IMAGE_1, SCHOOL_IMAGE_2, SCHOOL_IMAGE_3, SCHOOL_IMAGE_4, SCHOOL_IMAGE_5, SCHOOL_IMAGE_6, SCHOOL_IMAGE_7, SCHOOL_IMAGE_8);
		}
		
		/**
		 * Schools are the primary source of wisdom.
		 * @param	t
		 */
		override public function getBaseWisIncome(t:int):Number
		{
			return wisdomFunction(t, 90);
		}
		
		/**
		 * You don't get much belief from the school system.
		 * @param	t
		 */
		override public function getBasePowIncome(t:int):Number
		{
			return (t+1) * 5;
		}
		
		override public function getName():String
		{
			return "Academy";
		}
		
		override public function getDescription():String
		{
			return "To avert disaster, we must learn\nfrom our mistakes. Thus, the academy\nhas it's ground.";
		}
		
		override public function getTechType():String 
		{
			return "SCHOOL";
		}
		
		override public function getEffectText():String 
		{
			switch(activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					return "Healthy discussions are improving\n the quality of studies.";
				case WorldStructure.EFF_DEBUFF:
					return "Dissidents and urchins have desecrated \n the school. They are rebuilding.";
				case WorldStructure.EFF_BLESS:
					return "You dropped an apple on the head of a \n sleeping philosopher.";
				case WorldStructure.EFF_PUNISH:
					return "Through your works, the intricate\n doctrines on mathematics\n had disappeared overnight.";
				default:
					return "";
			}
		}
	}

}