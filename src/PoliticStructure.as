package  
{
	import adobe.utils.CustomActions;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * The politic structure is seats of government.
	 * @author Johannes L. Borresen
	 */
	public class PoliticStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/politic/politics_1.png")] public static const POLITICAL_IMAGE_1:Class;
		[Embed(source = "../img/structs/politic/politics_2.png")] public static const POLITICAL_IMAGE_2:Class;
		[Embed(source = "../img/structs/politic/politics_3.png")] public static const POLITICAL_IMAGE_3:Class;
		[Embed(source = "../img/structs/politic/politics_4.png")] public static const POLITICAL_IMAGE_4:Class;
		[Embed(source = "../img/structs/politic/politics_5.png")] public static const POLITICAL_IMAGE_5:Class;
		[Embed(source = "../img/structs/politic/politics_6.png")] public static const POLITICAL_IMAGE_6:Class;
		[Embed(source = "../img/structs/politic/politics_7.png")] public static const POLITICAL_IMAGE_7:Class;
		[Embed(source = "../img/structs/politic/politics_8.png")] public static const POLITICAL_IMAGE_8:Class;
		
		/**
		 * List of techs, in increasing cost/complexity, for housing.
		 */
		public var politicTech:Array = new Array(
			"Shamanism",
			"Chiefs",
			"Monarchy",
			"Oligarchy",
			"Democracy",
			"Bureaucracy",
			"Technocracy",
			"Omnicracy");
		
		public function PoliticStructure(parent:GameWorld) 
		{
			super(parent);
		}
		
		override protected function _createImgData():void 
		{
			structImageData.push(POLITICAL_IMAGE_1, POLITICAL_IMAGE_2, POLITICAL_IMAGE_3, POLITICAL_IMAGE_4, POLITICAL_IMAGE_5, POLITICAL_IMAGE_6, POLITICAL_IMAGE_7, POLITICAL_IMAGE_8);
		}
		
		override public function getName():String
		{
			return "Castle";
		}
		
		override public function getDescription():String
		{
			return "There has always been leaders.\nMost of them we didn't like.\nOthers, we merely tolerated.\nThey gather here.";
		}
		
		override public function getBasePowIncome(t:int):Number 
		{
			return (t + 1) * 2;
		}
		
		override public function getBaseWisIncome(t:int):Number 
		{
			return wisdomFunction(t, 80);
		}
		
		override public function getTechType():String 
		{
			return "POLITIC";
		}
		
		override public function getEffectText():String 
		{
			switch(activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					return "All is at peace. For once, all\n politicians agree.";
				case WorldStructure.EFF_DEBUFF:
					return "A dictatorial head of state reigns.";
				case WorldStructure.EFF_BLESS:
					return "A subtle change of sunlight, a\n moderate shift of contintents,\n and people can agree more\n easily.";
				case WorldStructure.EFF_PUNISH:
					return "A senator was found dead this\n morning. You know what caused this...";
				default:
					return "";
			}
		}
	}

}