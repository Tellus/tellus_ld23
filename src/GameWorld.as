package  
{
	import adobe.utils.CustomActions;
	import dk.homestead.utils.Calc;
	import flash.geom.Point;
	import flash.net.NetGroupSendMode;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
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
		
		public var topBar:TopBar = new TopBar();

		public var errorText:ErrorText = new ErrorText();
		
		/**
		 * How often income ticks happen (in seconds).
		 */
		public static const TICK_INTERVAL:Number = 3;
		
		/**
		 * Amount of wisdom earned required to win. Let's call this a conservative
		 * "all upgrades + 10%".
		 * */
		public static const WIN_TOTAL:Number = 61325;
		
		/**
		 * Amount of god power available to the player. This is used to create
		 * miracles or punishments. Using miracles strengthens peoples' beliefs,
		 * granting you a higher power income. It does, however, also reduce
		 * their belief in technology, and will stump their development.
		 */
		private var _power:Number = 0;
		
		public function get power():Number { return _power; }
		public function set power(v:Number):void 
		{
			if (v > 0)
			{
				var diff:Number = (_power - v);
				topBar.addFaith(0);
			}
			
			_power += v;
		}
		
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
		private var _wisdom:Number = 0;
		
		public function get wisdom():Number { return _wisdom; }
		public function set wisdom(v:Number):void
		{
			if (v > 0)
			{
				var diff:Number = Math.abs(_wisdom - v);
				totalWisdom += diff; // add the diff.
				topBar.addTech(diff);
			}
			
			_wisdom = v;
		}
		
		/**
		 * Total wisdom earned. This marks progress checkpoints.
		 */
		public var totalWisdom:Number = 0;
		
		/**
		 * All structures in play.
		 */
		public var buildings:Vector.<WorldStructure> = new Vector.<WorldStructure>();
		
		/**
		 * Occupied/open slots for buildings. Quick 'n dirty right before submission.
		 */
		public var slots:Vector.<Boolean> = new Vector.<Boolean>();
		
		/**
		 * The population count. Higher numbers result in stronger belief
		 * siding as well as number of structures.
		 */
		public var population:Number = 30;
		
		public function get wisIncome():Number
		{
			var wistmp:Number = 0;
			for each (var s:WorldStructure in buildings)
			{
				// trace("\t" + s.getWisIncome() + " from " + getQualifiedClassName(s));
				wistmp += s.getWisIncome();
			}
			return wistmp;
		}
		
		/**
		 * Always calculated when desired (... watch that).
		 */
		public function get powIncome():Number
		{
			var powtmp:Number = 0;
			for each (var s:WorldStructure in buildings)
			{
				// trace("\t" + s.getPowIncome() + " from " + getQualifiedClassName(s));
				powtmp += s.getPowIncome();
			}
			return powtmp;
		}
		 
		protected var tooltip:StructureTooltip = new StructureTooltip();
		
		public var castPointer:CastPointer;
		
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
			return Math.max(intellect - faith, intellect / 8) * 2;
		}
		
		/**
		 * Returns a ratio that determines faith-based factors.
		 * @return	Number between 0 and (typically) 2.
		 */
		public function calcGodPower():Number
		{
			// Currently, the lowest effectiveness is 25% and the highest
			// effectiveness is unbounded (which is a double-edged sword).
			return Math.max(faith - intellect, faith / 8) * 2;
		}
		
		public function GameWorld() 
		{
			FP.watch("totalWisdom");
			
			var bg:Image = new Image(BG_IMAGE_1)
			addGraphic(bg);
			
			addTween(new Alarm(TICK_INTERVAL, tickPower, Tween.LOOPING), true);
			addTween(new Alarm(TICK_INTERVAL, tickWisdom, Tween.LOOPING), true);
			
			_createSlots();
			_createHud();
			_createStructures();
			_createPointer();
			_createErrText();
			
			add(tooltip);
			add(topBar);
		}
		
		protected function _createErrText():void
		{
			errorText = new ErrorText();
			
			add(errorText);
			
			errorText.layer = layerNearest;
			
			errorText.visible = false;
		}
		
		override public function add(e:Entity):Entity 
		{
			return super.add(e);
			
			e.layer = layerFarthest;
		}
		
		protected function _createSlots():void
		{
			slots = new Vector.<Boolean>();
			
			var ws:int = ((FP.width - Main.leftMarg * 2) / Main.SQUARE_SIZE);
			var hs:int = Math.floor(((FP.height - Main.topMarg - Main.botMarg)) / Main.SQUARE_SIZE);
			
			var slotCount:int = ws * hs;
			
			for (var i:int = 0; i < slotCount; i++)
			{
				slots.push(false);
			}
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
			addBuilding(hs, 3, 2);
			
			var fs:FieldStructure = new FieldStructure(this);
			addBuilding(fs, 1, 0);
			
			var fs2:FarmStructure = new FarmStructure(this);
			addBuilding(fs2, 2, 0);
			
			var sh:SchoolStructure = new SchoolStructure(this);
			addBuilding(sh, 2, 3);
			
			var ps:PoliticStructure = new PoliticStructure(this);
			addBuilding(ps, 5, 3);
		}
		
		protected function _createPointer():void
		{
			castPointer = new CastPointer();
			castPointer.visible = false;
			
			//add(castPointer);
		}
		
		/**
		 * Places a building on the game grid.
		 * @param	b	Buliding to place.
		 * @param	x	Columnn (or x index) to place it.
		 * @param	y	Row (or y index) to place it.
		 */
		public function addBuilding(b:WorldStructure, x:int = -1, y:int = -1):void
		{
			// Exit if more than 3 buildings.
			
			var o:Array = new Array();
			
			getClass(Class(getDefinitionByName(getQualifiedClassName(b))), o);
			
			if (o.length >= 3)
			{
				trace("Too many buildings. Return!");
				return;
			}
			
			if (y >= 0 && x >= 0)
			{
				b.x = x * Main.SQUARE_SIZE + Main.leftMarg;
				b.y = y * Main.SQUARE_SIZE + Main.topMarg;
			}
			else 
			{
				x = Main.leftMarg;
				y = Main.topMarg;
				while (collideRect(WorldStructure.TYPE, x, y, Main.SQUARE_SIZE, Main.SQUARE_SIZE) != null && y)
				{
					trace("Collision upon placement.");
					x = Math.random() * (FP.width - Main.leftMarg) + Main.leftMarg - b.width;
					y = Math.random() * (FP.height - Main.botMarg) + Main.topMarg - b.height;
				}
				trace("Usccess" + new Point(x, y).toString());
				b.x = x;
				b.y = y;
			}
			add(b);
			buildings.push(b);
		}
		
		public function tickWisdom():void
		{
			// trace("Wisdom tick:");
			wisdom += wisIncome;
		}
		
		public function tickPower():void
		{
			// trace("Power tick:");
			power += powIncome;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (totalWisdom >= WIN_TOTAL) FP.world = new WinWorld();
			
			if (tooltip.visible)
			{
				if (collidePoint(WorldStructure.TYPE, Input.mouseX, Input.mouseY) == null &&
					collidePoint(tooltip.type, Input.mouseX, Input.mouseY) == null)
				{
					hideTooltip();
				}
			}
		}
		
		public function startCast(src:techButton):void
		{
			trace("Casting initiated.");
			add(castPointer);
			castPointer.show(src);
		}
		
		public function stopCast(reason:String):void
		{
			errorText.show(reason);
			trace("Cast stopped " + reason);
			remove(castPointer);
		}
		
		public function showTooltip(b:WorldStructure, bless:Function, punish:Function):void
		{
			// Supress tooltips if casting.
			if (getInstance("CASTPOINTER") != null)
			{
				trace("Player is casting. Tooltip supressed.");
				return;
			}
			
			tooltip.show(b);
			tooltip.setCallbacks(bless, punish);
		}
		
		public function hideTooltip():void
		{
			tooltip.hide();
		}
		
		public function globalUpgrade(source:WorldStructure):void
		{
			trace(source.getTechType() + " completed upgrade... seeding.");
			
			var o:Array = new Array();
			
			
			getClass(Class(getDefinitionByName(getQualifiedClassName(source))), o);
			
			for each (var w:WorldStructure in o)
			{
				w.forceUpgrade(source.tier);
			}
		}
		
		public function showError(s:String):void
		{
			errorText.show(s);
		}
		
		public function createNewBuilding(src:WorldStructure):void
		{
			var c:Class = Class(getDefinitionByName(getQualifiedClassName(src)));
			
			var w:WorldStructure = new c(this);
			
			addBuilding(w);
		}
	}
}