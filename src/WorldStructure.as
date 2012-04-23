package  
{
	import adobe.utils.CustomActions;
	import dk.homestead.flashpunk.text.GenericTooltip;
	import dk.homestead.utils.Calc;
	import flash.utils.getQualifiedClassName;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	
	/**
	 * A building/structure in the game world. Is inherited to fit with the
	 * events and powers that may affect them.
	 * @author Johannes L. Borresen
	 */
	public class WorldStructure extends Entity 
	{
		/**
		 * Parent world for this structure. Strictly speaking unnecessary, but
		 * I have trust issues with Flashpunk :P
		 */
		public var parent:GameWorld;
		
		/**
		 * Countdown timer to ensure that events (buffs/debuffs) don't happen
		 * right after one another.
		 */
		public var eventTimer:Alarm;
		
		/**
		 * Duration timer for effects. By default, they last about 15 seconds,
		 * but depending on tech level this could be reduced.
		 */
		public var effectTimer:Alarm;
		
		/**
		 * Minimum time, in seconds, between events for a single structure.
		 */
		public static const MIN_EVENT_CD:Number = 1;
		
		/**
		 * Maximum time, in seconds, between events for a single structure.
		 */
		public static const MAX_EVENT_CD:Number = 3;
		
		public static const TYPE:String = "BUILDING";
		
		/**
		 * The ground image. Since we're working with a reference, we can
		 * safely replace this image without affecting any sprite effects
		 * on higher layers. We use a Graphic base to avoid null errors. Replace
		 * as needed.
		 */
		public var _baseImage:Graphic = new Graphic();
		
		public function get baseImage():Graphic { return _baseImage; }
		public function set baseImage(g:Graphic):void
		{
			var gl:Graphiclist = graphic as Graphiclist;
			gl.remove(baseImage);
			_baseImage = g;
			gl.add(_baseImage);
		}
		
		/**
		 * Contains references to the various tier image data.
		 */
		public var structImageData:Vector.<Class> = new Vector.<Class>();
		
		/**
		 * "DEBUFF" or "BUFF" when no intervention was there.
		 * "BLESS" or "PUNISH when the player has overridden.
		 */
		public var activeEffect:int = EFF_NONE;
		
		public static const EFF_BLESS:int = 0;
		public static const EFF_PUNISH:int = 1;
		public static const EFF_BUFF:int = 2;
		public static const EFF_DEBUFF:int = 3;
		public static const EFF_NONE:int = -1;
		
		/**
		 * Current tier.
		 */
		public var tier:Number = 0;
		
		/**
		 * How far a tech upgrade is coming along.
		 */
		public var upgradeProgress:Number = 0;
		
		public var upgrading:Boolean = false;
		
		protected var progressBar:ProgressBar;
		
		/**
		 * Contains a list of building types that are already being upgraded.
		 * This is initiated by a wisdom upgrade. Once it completes, all underlings
		 * are forced to upgrade themselves.
		 */
		protected static var upgradesInProgress:Vector.<String> = new Vector.<String>();
		
		/**
		 * Contains counts for the different structure classes and how many are
		 * upgrading. Use this for global upgrades after one is finished.
		 */
		protected static var globalUpgradeCount:Array = new Array();
		
		public function WorldStructure(parent:GameWorld) 
		{
			// All buildings are 2x2 blocks in size. They have space to grow.
			setHitbox(Main.SQUARE_SIZE, Main.SQUARE_SIZE);
			this.type = TYPE;
			this.parent = parent;
			graphic = new Graphiclist();
			
			_createImgData();
			_createUpgradeTimer();
			_createEffectTimer();
			
			// Set this once and forget it until upgrades.
			if (globalUpgradeCount[getTechType()] == null)
				globalUpgradeCount[getTechType()] = 0;
			
			setTier(0);
			
			eventTimer = new Alarm((Math.random() * (MAX_EVENT_CD - MIN_EVENT_CD) + MIN_EVENT_CD), onEventTimer, Tween.PERSIST);
			addTween(eventTimer, true);
		}
		
		/**
		 * Called by the base constructor when the image data vector is ready.
		 * Override and push your tier data in sequencially.
		 */
		protected function _createImgData():void
		{}
		
		private function _createUpgradeTimer():void
		{
			upgradeTimer = new Alarm(1, upgradeTick, Tween.LOOPING);
			addTween(upgradeTimer, false);
		}
		
		/**
		 * Override
		 */
		public function getName():String
		{ return "";  }
		
		/**
		 * Override
		 */
		public function getDescription():String
		{ return "";  }
		
		override public function added():void 
		{
			super.added();
			
			// Store in a cast var.
			parent = world as GameWorld;
		}
		
		/**
		 * Resets the random event timer.
		 */
		public function resetEventTimer():void
		{
			eventTimer.reset((Math.random() * (MAX_EVENT_CD - MIN_EVENT_CD)) + MIN_EVENT_CD);
		}
		
		/**
		 * Randomly creates either a buff or debuff on the structre for the
		 * player to react to.
		 */
		public function onEventTimer():void
		{
			if (activeEffect != EFF_NONE) return;
			
			if (Calc.coinFlip())
				buff();
			else
				debuff();
			resetEventTimer();
		}
		
		/**
		 * Should be overridden to create the graphic for the structure matching
		 * a specific tier of tech.
		 * @param	tier	Tier of tech. We're working with 1 to 8.
		 * @return	A graphic, ready to overwrite the current (if any).
		 */
		protected function _createGraphic(tier:int):Graphic
		{
			return new Image(this.structImageData[tier]);
		}
		
		protected function _createEffectTimer():void
		{
			effectTimer = new Alarm(1, null, Tween.PERSIST);
			addTween(effectTimer, false);
		}
		
		/**
		 * Called randomly by the update function to create a bit of fun
		 * entropy in the game :P
		 */
		public function debuff():void
		{
			activeEffect = EFF_DEBUFF;
			
			startEffectTimer(onDebuffEnd);
		}
		
		public function startEffectTimer(cb:Function):void
		{
			effectTimer.reset(getEffectDuration());
			effectTimer.complete = cb;
			effectTimer.start();
		}
		
		/** Override these end functions (and super them!) to implement custom behaviour for ended effects. **/
		
		public function onDebuffEnd():void { endEffect(); }
		
		public function onBuffEnd():void { endEffect(); }
		
		public function onBlessEnd():void { endEffect(); }
		
		public function onPunishEnd():void { endEffect(); }
		
		public function endEffect():void { activeEffect = EFF_NONE; }
		
		/**
		 * Gets a somewhat random effect duration, from 5 to 30 seconds,
		 * to use for various temporary effects.
		 * @return
		 */
		public static function getEffectDuration():Number
		{
			return 5 + Math.random() * 25;
		}
		
		/**
		 * Calling bless will eliminate any active debuff, increase 
		 * powIncome and reduce wisIncome.
		 */
		public function bless():void
		{
			activeEffect = EFF_BLESS;
			
			startEffectTimer(onBlessEnd);
		}
		
		/**
		 * Called randomly by the update function to create a bit of fun
		 * entropy in the game :P
		 */
		public function buff():void
		{
			activeEffect = EFF_BUFF;
			
			startEffectTimer(onBuffEnd);
		}
		
		/**
		 * Calling curse will eliminate any active buff, and either increase
		 * powIncome considerably OR wisIncome moderately.
		 */
		public function punish():void
		{
			activeEffect = EFF_PUNISH;
			
			startEffectTimer(onPunishEnd);
		}
		
		public function setTier(t:int):void
		{
			tier = t;
			baseImage = _createGraphic(t);
			
			var growTween:Alarm = new Alarm(10*(t+1), onFullGrowth, Tween.ONESHOT);
			
			addTween(growTween, true);
		}
		
		/**
		 * Alert the world so it can createa a new building.
		 */
		public function onFullGrowth():void
		{
			parent.createNewBuilding(this);
		}
		
		/**
		 * Should return the *base* income for this structure.
		 * @param	t
		 * @return
		 */
		public function getBasePowIncome(t:int):Number
		{
			// Override with tier calculation data.
			return 0;
		}
		
		/**
		 * Should return the *base* income for this structure.
		 * @param	t
		 * @return
		 */
		public function getBaseWisIncome(t:int):Number
		{
			// Override with tier calculation data.
			return 0;
		}
		
		public final function getPowIncome():Number
		{
			// TODO: You might have a ratio problem since the entire populace or even the building is actually considered beyond a buff.
			return getBasePowIncome(tier) * getPowRatio();
		}
		
		public final function getWisIncome():Number
		{
			// TODO: You might have a ratio problem since the entire populace or even the building is actually considered beyond a buff.
			return getBaseWisIncome(tier) * getWisRatio();
		}
		
		public function getPowRatio():Number
		{
			/**
			 * You always get great amount of power if you've intervened in any
			 * way.
			 */
			switch (activeEffect)
			{
				case EFF_BUFF:
					return 1.25;
				case EFF_DEBUFF:
					return 0.75;
				case EFF_BLESS:
				case EFF_PUNISH:
					return 1.5;
				default:
					return 1;
			}
		}
		
		public function getWisRatio():Number
		{
			/**
			 * You always get reduced wisdom if you've intervened.
			 */
			switch (activeEffect)
			{
				case EFF_BUFF:
					return 1.25;
				case EFF_DEBUFF:
					return 0.75;
				case EFF_BLESS:
				case EFF_PUNISH:
					return 0.25;
				default:
					return 1;
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				// trace("Showing tooltip.");
				if (collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					parent.showTooltip(this, onBlessClick, onPunishClick);
				}	
			}
		}
		
		/**
		 * 
		 * @return
		 */
		public function getEffectText():String
		{
			throw new Error("Unimplemented in " + getQualifiedClassName(this) + ".");
			// return activeEffect.toLowerCase();
		}
		
		/** Override click handlers (remember super!) to implement custom behaviour when blessings are just initiated. **/
		
		public function onBlessClick():void { bless(); }
		
		public function onPunishClick():void { punish(); }
		
		protected var upgradeTimer:Alarm;
		
		/**
		 * Starts a tech-based upgrade. This is different from regular
		 * development.
		 * @param	t	The tier matching the upgrade.
		 */
		public function techUpgrade(t:int):Boolean
		{
			trace("techUpgrade called");
			
			if (getTechType() in WorldStructure.upgradesInProgress) return false;
			
			_doUpgrade(t);
			
			WorldStructure.upgradesInProgress.push(getTechType());
			
			return true;
		}
		
		/**
		 * Should only be called by GameWorld when one instance finishes its
		 * upgrade, to make all others start theirs.
		 * @param	t
		 */
		public function forceUpgrade(t:int):void
		{
			_doUpgrade(t);
			
			// Block any user upgrades.
			if (getTechType() in WorldStructure.upgradesInProgress) return;
			else WorldStructure.upgradesInProgress.push(getTechType());
		}
		
		protected function _doUpgrade(t:int):void
		{
			if (t == tier)
			{
				trace("Ignored upgrade");
				return; // Ignore this.
			}
			
			WorldStructure.globalUpgradeCount[getTechType()]++;
			
			progressBar = new ProgressBar(width-4, 4);
			progressBar.x = x+2;
			progressBar.y = y + 2;
			progressBar.progress = 0;
			world.add(progressBar);
			progressBar.layer = world.layerNearest - 1; // UNder errors.
			upgradeTimer.reset(1)
		}
		
		/**
		 * Called by the upgrade timer every time an upgrade is nudged. 
		 */
		protected function upgradeTick():void
		{
			// Minimum progress is 1/1s right now.
			progressBar.progress += (Math.max(getWisIncome() - getPowIncome(), 1)) / 100;
			if (progressBar.progress >= 1)
			{
				world.remove(progressBar);
				setTier(tier + 1);
				upgradeTimer.active = false;
				// Remove our counter.
				globalUpgradeCount[getTechType()]--;
				
				if (globalUpgradeCount[getTechType()] == 0)
				{
					upgradesInProgress = upgradesInProgress.splice(upgradesInProgress.indexOf(getTechType()), 1);
					(world as GameWorld).globalUpgrade(this);
				}
			}
		}
		
		public function getTechType():String 
		{
			throw new Error("Not implemented.");
			return "INVALID";
		}
		
		/**
		 * Since we have generalised the function, we can use a single function
		 * for all subclasses.
		 * @param	tier	The tier to calculate with (0 is okay).
		 * @param	base	The base modifier (50-90).
		 * @return	The result.
		 */
		public static function wisdomFunction(tier:int, base:int):Number
		{
			var v:Number = (base * (tier) * (tier)) + base/10;
			// trace("Wisdom is " + v);
			return v;
		}
		
		/**
		 * Similarly to wisdom, we have a weaker function for power.
		 * The natural logarithm should grow sufficiently slower than the
		 * exponential to make wisdom a bad life choice :P
		 * @param	tier	The tier (0 is okay).
		 * @param	base	The base modifier (50-90).
		 * @return	The result.
		 */
		public static function powerFunction(tier:int, base:int):Number
		{
			return (base * (tier) * Math.log(50 * (tier))) + base/10;
		}
	}
}