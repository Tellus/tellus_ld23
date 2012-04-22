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
		[Embed(source="../img/structs/farm_1.png")] public static const FARM_IMAGE_1:Class;
		
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
			structImageData.push(FARM_IMAGE_1);
		}
		
		override public function getName():String
		{
			return "Farm";
		}
		
		override public function getDescription():String
		{
			return "Ever since man learned to master\n the beast, he has strived to\n nurture them in an effort to\n improve his own life.";
		}
	}

}