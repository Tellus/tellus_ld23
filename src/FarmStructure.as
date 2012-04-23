package  
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class FarmStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/farm/farm_1.png")] public static const FARM_IMAGE_1:Class;
		[Embed(source = "../img/structs/farm/farm_2.png")] public static const FARM_IMAGE_2:Class;
		[Embed(source = "../img/structs/farm/farm_3.png")] public static const FARM_IMAGE_3:Class;
		[Embed(source = "../img/structs/farm/farm_4.png")] public static const FARM_IMAGE_4:Class;
		[Embed(source = "../img/structs/farm/farm_5.png")] public static const FARM_IMAGE_5:Class;
		[Embed(source = "../img/structs/farm/farm_6.png")] public static const FARM_IMAGE_6:Class;
		[Embed(source = "../img/structs/farm/farm_7.png")] public static const FARM_IMAGE_7:Class;
		[Embed(source = "../img/structs/farm/farm_8.png")] public static const FARM_IMAGE_8:Class;
		
		
		/**
		 * List of techs, in increasing cost/complexity, for farms.
		 */
		public var farmTech:Array = new Array(
			"Hunting",
			"Husbandry",
			"Housing",
			"Culling",
			"Breeding",
			"Foraging",
			"Cloning",
			"Synthetic");
		
		public function FarmStructure(parent:GameWorld) 
		{
			super(parent);
		}
		
		override protected function _createImgData():void 
		{
			structImageData.push(FARM_IMAGE_1, FARM_IMAGE_2, FARM_IMAGE_3, FARM_IMAGE_4, FARM_IMAGE_5, FARM_IMAGE_6, FARM_IMAGE_7, FARM_IMAGE_8);
		}
		
		override public function getName():String
		{
			return "Farm";
		}
		
		override public function getDescription():String
		{
			return "Ever since man learned to master\n the beast, he has strived to\n nurture them in an effort to\n improve his own life.";
		}
		
		override public function getBasePowIncome(t:int):Number 
		{
			return (t + 1) * 4;
		}
		
		override public function getBaseWisIncome(t:int):Number 
		{
			return wisdomFunction(t, 50);
		}
		
		override public function getTechType():String 
		{
			return "FARM";
		}
		
		override public function getEffectText():String 
		{
			switch(activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					return "A well-behaved and ornery litter\nof livestock has made life easer.";
				case WorldStructure.EFF_DEBUFF:
					return "The animals are uneasy as disease\nravages the livestock.";
				case WorldStructure.EFF_BLESS:
					return "You saw fit to bless the pigs with\nmany piglets. We will not suffer\nfor hunger.";
				case WorldStructure.EFF_PUNISH:
					return "Death was sent to be your hand.\nThere remains nothing of the livestock.";
				default:
					return "";
			}
		}
	}

}