package  
{
	import dk.homestead.flashpunk.groups.CellEntityGroup;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import tech.FarmTech;
	import tech.FieldTech;
	import tech.HouseTech;
	import tech.PoliticTech;
	import tech.SchoolTech;
	
	/**
	 * The top bar displays faith versus tech in your populace.
	 * @author Johannes L. Borresen
	 */
	public class TopBar extends Entity 
	{
		[Embed(source = "../img/topbar.png")] public static const BG_IMAGE:Class;
		[Embed(source = "../img/marker.png")] public static const MARKER:Class;
		
		public var bg:Image = new Image(BG_IMAGE);
		public var faithMarker:Entity = new Entity(0, 0, new Image(MARKER));
		public var techMarker:Entity = new Entity(0, 0, new Image(MARKER));
		
		private var entities:Vector.<Entity> = new Vector.<Entity>();
		
		public var icons:Vector.<Entity> = new Vector.<Entity>();
		
		public var house:HouseTech = new HouseTech();
		public var school:SchoolTech = new SchoolTech();
		public var politic:PoliticTech = new PoliticTech();
		public var farm:FarmTech = new FarmTech();
		public var field:FieldTech = new FieldTech();
		
		public function TopBar() 
		{
			super();
			
			addGraphic(bg);
			
			setHitbox(bg.width, bg.height);
			
			faithMarker.x = techMarker.x = halfWidth;
			faithMarker.y = techMarker.y = -1;
			
			entities.push(faithMarker, techMarker, house, school, politic, farm, field);
			icons.push(house, school, politic, farm, field);
			
			house.y = school.y = politic.y = farm.y = field.y = 15;
			for (var i:int = 0; i < 5; i++)
			{
				icons[i].x = 10 + i * 40;
			}
		}
		
		override public function added():void 
		{
			super.added();
			
			for each (var e:Entity in entities)
			{
				world.add(e);
			}
		}
		
		override public function removed():void 
		{
			world.removeList(entities);
			
			super.removed();
		}
		
		public function addTech(v:Number):void
		{
			v /= 60000;
			techMarker.x -= v;
		}
		
		public function addFaith(v:Number):void
		{
			v /= 60000;
			faithMarker.x += v;
		}
	}

}