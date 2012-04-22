package  
{
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
		 * How much power this structure generates per tick.
		 */
		protected var _powIncome:Number = 0;

		public function get powIncome():Number { return _powIncome; }
		public function set powIncome(v:Number):void
		{
			// Remove prior income.
			parent.powIncome -= _powIncome;
			// Set new value.
			_powIncome = v;
			// Add back to parent.
			parent.powIncome += v;
		}
		
		/**
		 * How much wisdom this structure generates per tick.
		 */
		protected var _wisIncome:Number = 0;
		
		public function get wisIncome():Number { return _wisIncome; }
		public function set wisIncome(v:Number):void
		{
			// Remove prior income.
			// trace("Changing " + parent.wisdom + " to " + v);
			parent.wisIncome -= _wisIncome;
			// Set new value.
			_wisIncome = v;
			// Add back to parent.
			parent.wisIncome += v;
		}
		
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
		 * Minimum time, in seconds, between events for a single structure.
		 */
		public static const MIN_EVENT_CD:Number = 1;
		
		/**
		 * Maximum time, in seconds, between events for a single structure.
		 */
		public static const MAX_EVENT_CD:Number = 3;
		
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
		 * "DEBUFF" of "BUFF".
		 */
		public var activeEffect:String = "NONE";
		
		/**
		 * How far a tech upgrade is coming along.
		 */
		public var upgradeProgress:Number = 0;
		
		/**
		 * How many percent, per second, that this building is researching
		 * tech.
		 */
		public var upgradeSpeed:Number = 1;
		
		public function WorldStructure(parent:GameWorld) 
		{
			// All buildings are 2x2 blocks in size. They have space to grow.
			setHitbox(Main.SQUARE_SIZE * 2, Main.SQUARE_SIZE * 2);
			this.type = "STRUCTURE";
			this.parent = parent;
			graphic = new Graphiclist();
			
			_createImgData();
			
			setTier(0);
			
			eventTimer = new Alarm((Math.random() * (MAX_EVENT_CD - MIN_EVENT_CD) + MIN_EVENT_CD), onEventTimer, Tween.PERSIST);
			addTween(eventTimer, true);
		}
		
		/**
		 * Called by the base constructor when the image data vector is ready.
		 * Override and push your tier data in sequencially.
		 */
		protected function _createImgData():void
		{
			
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
			
			// Put in current income values.
			parent.powIncome = powIncome;
			parent.wisIncome = wisIncome;
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
			if (activeEffect != "NONE") return;
			
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
		
		/**
		 * Called randomly by the update function to create a bit of fun
		 * entropy in the game :P
		 */
		public function debuff():void
		{
			trace("Debuffing " + name);
			activeEffect = "DEBUFF";
		}
		
		/**
		 * Calling bless will eliminate any active debuff, increase 
		 * powIncome and reduce wisIncome.
		 */
		public function bless():void
		{
			activeEffect = "NONE";
		}
		
		/**
		 * Called randomly by the update function to create a bit of fun
		 * entropy in the game :P
		 */
		public function buff():void
		{
			trace("Buffing " + name);
			activeEffect = "BUFF";
		}
		
		/**
		 * Calling curse will eliminate any active buff, and either increase
		 * powIncome considerably OR wisIncome moderately.
		 */
		public function curse():void
		{
			activeEffect = "NONE";
		}
		
		public function setTier(t:int):void
		{
			baseImage = _createGraphic(t);
			powIncome = _getPowIncome(t);
			wisIncome = _getWisIncome(t);
		}
		
		public function _getPowIncome(t:int):Number
		{
			// Override with tier calculation data.
			return 0;
		}
		
		public function _getWisIncome(t:int):Number
		{
			// Override with tier calculation data.
			return 0;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				if (collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					parent.tooltip.show(this);
					parent.tooltip.setCallbacks(onBlessClick, onPunishClick);
				}	
			}
		}
		
		/**
		 * 
		 * @return
		 */
		public function getEffectText():String
		{
			return activeEffect.toLowerCase();
		}
		
		public function onBlessClick():void
		{
			throw new Error("Not implemented by " + getQualifiedClassName(this));
		}
		
		public function onPunishClick():void
		{
			throw new Error("Not implemented by " + getQualifiedClassName(this));
		}
	}
}