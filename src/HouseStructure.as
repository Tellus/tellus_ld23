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
		[Embed(source = "../img/structs/house/house_1.png")] public static const HOUSE_IMAGE_1:Class;
		[Embed(source = "../img/structs/house/house_2.png")] public static const HOUSE_IMAGE_2:Class;
		[Embed(source = "../img/structs/house/house_3.png")] public static const HOUSE_IMAGE_3:Class;
		[Embed(source = "../img/structs/house/house_4.png")] public static const HOUSE_IMAGE_4:Class;
		[Embed(source = "../img/structs/house/house_5.png")] public static const HOUSE_IMAGE_5:Class;
		[Embed(source = "../img/structs/house/house_6.png")] public static const HOUSE_IMAGE_6:Class;
		[Embed(source = "../img/structs/house/house_7.png")] public static const HOUSE_IMAGE_7:Class;
		[Embed(source = "../img/structs/house/house_8.png")] public static const HOUSE_IMAGE_8:Class;
		
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
			structImageData.push(HOUSE_IMAGE_1, HOUSE_IMAGE_2, HOUSE_IMAGE_3, HOUSE_IMAGE_4, HOUSE_IMAGE_5, HOUSE_IMAGE_6, HOUSE_IMAGE_7, HOUSE_IMAGE_8);
		}
		
		override public function getName():String
		{
			return "House";
		}
		
		override public function getDescription():String
		{
			return "People live here. They eat, sleep,\n love and die.";
		}
		
		override public function getBasePowIncome(t:int):Number 
		{
			return (t + 1) * 3;
		}
		
		override public function getBaseWisIncome(t:int):Number 
		{
			return wisdomFunction(t, 70);
		}
		
		override public function getTechType():String 
		{
			return "HOUSE";
		}
		
		override public function getEffectText():String 
		{
			switch(activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					return "The weather is kind to the houses.\nHomelife is bountiful.";
				case WorldStructure.EFF_DEBUFF:
					return "Storms rustle the roof as the families\nhuddle together in fear.";
				case WorldStructure.EFF_BLESS:
					return "For some reason, the house offering\nwas not eaten this night.\nIt was quadrupled.";
				case WorldStructure.EFF_PUNISH:
					return "Rats. Cockroaches. Filth and disease\nis everywhere in the house.";
				default:
					return "";
			}
		}
	}

}