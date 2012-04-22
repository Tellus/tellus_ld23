package  
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class HouseStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/house_6.png")] public static const HOUSE_IMAGE_6:Class;
		[Embed(source = "../img/structs/house_7.png")] public static const HOUSE_IMAGE_7:Class;
		
		/**
		 * List of techs, in increasing cost/complexity, for housing.
		 */
		public var houseTech:Array = new Array(
			"Caves",
			"Fireplace",
			"Huts",
			"Outhouse",
			"Warm Isolation",
			"Running Water",
			"Electricity",
			"Robo Butlers");
		
		public function HouseStructure(parent:GameWorld) 
		{
			super(parent);
		}
		
		override protected function _createImgData():void 
		{
			structImageData.push(HOUSE_IMAGE_6, HOUSE_IMAGE_7);
		}
		
		override public function getName():String
		{
			return "House";
		}
		
		override public function getDescription():String
		{
			return "People live here. They eat, sleep,\n love and die.";
		}
	}

}