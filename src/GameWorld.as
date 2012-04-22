package  
{
	import adobe.utils.CustomActions;
	import hud.*;
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.*;
	import net.flashpunk.utils.*;
	
	/**
	 * Base version of the game world. It's inherited into the Local, Feudal
	 * and Global (and Universal - Existential?) worlds for separate entities.
	 * @author Johannes L. Borresen
	 */
	public class GameWorld extends World 
	{
		[Embed(source = "../img/ground.png")] public static const BG_IMAGE_1:Class;
		
		/**
		 * How often income ticks happen (in seconds).
		 */
		public static const TICK_INTERVAL:Number = 3;
		
		/**
		 * Amount of god power available to the player. This is used to create
		 * miracles or punishments. Using miracles strengthens peoples' beliefs,
		 * granting you a higher power income. It does, however, also reduce
		 * their belief in technology, and will stump their development.
		 */
		public var power:Number = 0;
		
		/**
		 * Wisdom available to the player. Consider this XP that can be granted
		 * to mortals. It is granted progressively from all areas, but is most
		 * effective from Schools and Governments.
		 * 5. School
		 * 4. Government
		 * 3. Houses
		 * 2. Fields
		 * 1. Farms
		 * Numbers denote base income.
		 */
		public var wisdom:Number = 0;
		
		/**
		 * All structures in play.
		 */
		public var buildings:Vector.<WorldStructure> = new Vector.<WorldStructure>();
		
		/**
		 * The population count. Higher numbers result in stronger belief
		 * siding as well as number of structures.
		 */
		public var population:Number = 30;
		
		/**
		 * Income per second of wisdom.
		 */
		private var _wisIncome:Number = 0;
		
		public function get wisIncome():Number { return _wisIncome; }
		public function set wisIncome(v:Number):void
		{
			_wisIncome = v;
		}
		
		/**
		 * Income per second of power.
		 */
		private var _powIncome:Number = 0;
		
		public function get powIncome():Number { return _powIncome; }
		public function set powIncome(v:Number):void
		{
			_powIncome = v;
		}
		 
		public var tooltip:StructureTooltip = new StructureTooltip();
		
		/**
		 * How far is civilization from its next leap forward?
		 * Either this ia a win condition or it's the level win condition."
		 */
		public var civilizationProgress:Number = 0;
		
		/**
		 * The overall faith of the people in the world. Higher faith gives
		 * stronger god powers, but also much slower tech progress.
		 */
		public var faith:Number = 0;
		
		/**
		 * The overall technological intellect of the populace. It stands as a
		 * contrast to faith but is not on the same axis (as they can both be
		 * non-negative). Higher intellect gives higher research speeds and
		 * wisdom gains.
		 */
		public var intellect:Number = 0;
		
		/**
		 * Returns a ratio that determines tech-based factors.
		 * @return	Number between 0 and (typically) 2.
		 */
		public function calcTechPower():Number
		{
			return Math.abs(intellect - faith) + (intellect / 4);
		}
		
		/**
		 * Returns a ratio that determines faith-based factors.
		 * @return	Number between 0 and (typically) 2.
		 */
		public function calcGodPower():Number
		{
			return Math.abs(faith - intellect) + (faith / 4);
		}
		
		public function GameWorld() 
		{
			var bg:Image = new Image(BG_IMAGE_1)
			addGraphic(bg);
			
			addTween(new Alarm(TICK_INTERVAL, tickPower, Tween.LOOPING), true);
			addTween(new Alarm(TICK_INTERVAL, tickWisdom, Tween.LOOPING), true);
			
			_createHud();
			_createStructures();
			
			add(tooltip);
		}
		
		protected function _createHud():void
		{
			var ht:WisdomHud = new WisdomHud(this);
			add(ht);
			ht.x = 10;
			ht.y = FP.height - ht.height;
			
			var pHud:PowerHud = new PowerHud(this);
			add(pHud);
			pHud.x = FP.halfWidth;
			pHud.y = ht.y;
		}
		
		protected function _createStructures():void
		{
			// The first set is always statically placed. Easier.
			var hs:HouseStructure = new HouseStructure(this);
			addBuilding(hs, 6, 4);
			
			var fs:FieldStructure = new FieldStructure(this);
			addBuilding(fs, 2, 0);
			
			var fs2:FarmStructure = new FarmStructure(this);
			addBuilding(fs2, 4, 0);
			
			var sh:SchoolStructure = new SchoolStructure(this);
			addBuilding(sh, 4, 6);
			
			var ps:PoliticStructure = new PoliticStructure(this);
			addBuilding(ps, 10, 6);
		}
		
		/**
		 * Places a building on the game grid.
		 * @param	b	Buliding to place.
		 * @param	x	Columnn (or x index) to place it.
		 * @param	y	Row (or y index) to place it.
		 */
		public function addBuilding(b:WorldStructure, x:int, y:int):void
		{
			b.x = x * Main.SQUARE_SIZE;
			b.y = y * Main.SQUARE_SIZE;
			add(b);
		}
		
		public function tickWisdom():void
		{
			wisdom += wisIncome;
		}
		
		public function tickPower():void
		{
			power += powIncome;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.pressed(Key.H))
			{
				var h:HouseStructure = new HouseStructure(this);
				h.x = Input.mouseX;
				h.y = Input.mouseY;
				add(h);
			}
			if (Input.pressed(Key.U))
			{
				var a:Array = new Array();
				getType("HouseStructure", a);
				trace("Upgrading " + a.length + " structs.");
				for each (var sss:HouseStructure in a)
				{
					sss.setTier(1);
				}
			}
		}
	}
}