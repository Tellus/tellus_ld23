package  
{
	import adobe.utils.CustomActions;
	import dk.homestead.utils.Data;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	/**
	 * A field building.
	 * @author Johannes L. Borresen
	 */
	public class FieldStructure extends WorldStructure 
	{
		[Embed(source = "../img/structs/field/field_1.png")] public static const FIELD_IMAGE_1:Class;
		[Embed(source = "../img/structs/field/field_2.png")] public static const FIELD_IMAGE_2:Class;
		[Embed(source = "../img/structs/field/field_3.png")] public static const FIELD_IMAGE_3:Class;
		[Embed(source = "../img/structs/field/field_4.png")] public static const FIELD_IMAGE_4:Class;
		[Embed(source = "../img/structs/field/field_5.png")] public static const FIELD_IMAGE_5:Class;
		[Embed(source = "../img/structs/field/field_6.png")] public static const FIELD_IMAGE_6:Class;
		[Embed(source = "../img/structs/field/field_7.png")] public static const FIELD_IMAGE_7:Class;
		[Embed(source = "../img/structs/field/field_8.png")] public static const FIELD_IMAGE_8:Class;
		
		[Embed(source = "../img/structs/field/wheat_sprite.png")] public static const CROP_SPRITE:Class;
		[Embed(source = "../img/structs/field/debuff.png")] public static const DEBUFF_IMAGE:Class;
		
		public var swarm:Vector.<Image>;
		
		public var cropTimer:Alarm;
		
		/**
		 * List of techs, in increasing cost/complexity, for fields.
		 */
		public var fieldTech:Array = new Array(
			"Irrigation",
			"Crop Rotations",
			"Field Burning",
			"Crop Breeding",
			"Tree Walls",
			"Pesticides",
			"Genetics",
			"Synthetics");
		
		public function FieldStructure(parent:GameWorld) 
		{
			super(parent);
			
			cropTimer = new Alarm(2, addCrop, Tween.PERSIST);
			addTween(cropTimer, true);
		}
		
		override protected function _createImgData():void 
		{
			structImageData.push(FIELD_IMAGE_1, FIELD_IMAGE_2, FIELD_IMAGE_3, FIELD_IMAGE_4, FIELD_IMAGE_5, FIELD_IMAGE_6, FIELD_IMAGE_7, FIELD_IMAGE_8);
		}
		
		public function addCrop():void
		{
			var s:Spritemap = new Spritemap(CROP_SPRITE, 3, 5);
			s.callback = function():void { (graphic as Graphiclist).remove(s) };
			s.add("grow", Data.FillArray(7), Math.random() * 3, false);
			s.play("grow", true);
			s.x = Math.min((Math.random() * (width / 2) + 6),28);
			s.y = Math.random() * height / 2;
			
			addGraphic(s);
			
			cropTimer.reset(Math.random() * 7 + 3);
			trace("added a crop");
		}
		
		override public function buff():void
		{
			super.buff();
		}
		
		override public function debuff():void 
		{
			super.debuff();
			
			var g:Image;
			
			for each (g in swarm)
				(graphic as Graphiclist).remove(g);
			
			swarm = new Vector.<Image>();
			
			for (var i:int = (Math.random() * 3) + 3; i > 0; i--)
			{
				g = new Image(DEBUFF_IMAGE);
				swarm.push(g);
				addGraphic(g);
				g.x = Math.random() * width / 2;
				g.y = Math.random() * height / 2;
			}
		}
		
		override public function getName():String
		{
			return "Field";
		}
		
		override public function getDescription():String
		{
			return "The source of cultivated sustenance,\nfields litter the land, while\nfarmers, sweaty-browed, tend to\ntheir needs.";
		}
		
		override public function getEffectText():String 
		{
			switch(activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					return "The weather has been gracious to\n our crops!";
				case WorldStructure.EFF_DEBUFF:
					return "Locusts are devouring the crops!";
				case WorldStructure.EFF_BLESS:
					return "Through your power, the soil is\n more fertile, the food more\n nourishing and the weather fair.";
				case WorldStructure.EFF_PUNISH:
					return "Sickness spreads across the fields.\n The farmers are powerless in the\n face of your wrath.";
				default:
					return "";
			}
		}
		
		override public function getBasePowIncome(t:int):Number 
		{
			return (t + 1) * 5;
		}
		
		override public function getBaseWisIncome(t:int):Number 
		{
			return wisdomFunction(t, 60);
		}
		
		override public function getTechType():String 
		{
			return "FIELD";
		}
	}

}