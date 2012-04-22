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
		[Embed(source = "../img/structs/politics_1.png")] public static const POLITICAL_IMAGE_1:Class;
		
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
			structImageData.push(POLITICAL_IMAGE_1);
		}
		
		override public function _getPowIncome(t:int):Number
		{
			return (t+1) * 2; // "In deities we trust."
		}
		
		override public function _getWisIncome(t:int):Number
		{
			return (t+1) * 2;
		}
	}

}