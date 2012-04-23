package  
{
	import dk.homestead.utils.Calc;
	import dk.homestead.utils.Data;
	import flash.events.IMEEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * Tech buttons are used to bestow gifts of knowledge upon the world. In the
	 * beginning this is necessary, but if you nurture the world properly, they
	 * will learn to innovate themselves.
	 * @author Johannes L. Borresen
	 */
	public class techButton extends Entity 
	{
		[Embed(source = "../img/icon_background.png")] public static var BG_IMAGE:Class;
		
		public var bg:Spritemap = new Spritemap(BG_IMAGE, 32, 32);
		
		public var image:Image;
		
		private var _costText:Text;
		
		/**
		 * Cost, in wisdom, of the current tech level. This vector contains
		 * all the tiers and their corresponding costs (costs are shared across
		 * techs).
		 */
		public var wisdomCost:Vector.<Number> = new Vector.<Number>();
		
		private var _currentCost:Number;
		
		public function get currentCost():Number { return _currentCost; }
		public function set currentCost(v:Number):void
		{
			_currentCost = v;
			_costText.text = String(v);
		}
		
		public var currentTier:Number;
		
		public function techButton(src:Class) 
		{
			super();
			
			image = new Image(src);
			_costText = new Text("CCC");
			
			addGraphic(bg);
			addGraphic(image);
			addGraphic(_costText);
			
			// Always scale before relative operations.
			image.scale = bg.scale = _costText.scale = 0.5;
			
			setHitbox(bg.scaledWidth, bg.scaledHeight);
			
			image.x = (halfHeight) - (image.scaledWidth / 2);
			image.y = (halfWidth) - (image.scaledHeight / 2);
			_costText.x = (halfWidth) - (_costText.scaledWidth / 2);
			_costText.y = height + 5;
			
			_setCosts();
			
			setTier(0);
		}
		
		/**
		 * Sets the costs of the various tiers.
		 */
		protected function _setCosts():void
		{
			wisdomCost = new Vector.<Number>();
			wisdomCost.push(50, 150, 350, 600, 1000, 1500, 2500, 5000);
		}
		
		public function getCost(t:int):Number
		{
			return wisdomCost[t];
		}
		
		public function setTier(t:int):void
		{
			currentTier = t;
			currentCost = getCost(t);
			_costText.text = String(currentCost);
		}
		
		override public function update():void 
		{
			super.update();
			
			var over:Boolean = false;
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				over = true;
				bg.frame = 1;
			}
			else
			{
				over = false;
				bg.frame = 0;
			}
			
			if (over && Input.mousePressed)
			{
				// Check cost.
				var gw:GameWorld = world as GameWorld;
				
				if (gw.wisdom < currentCost)
				{
					var w:GameWorld = world as GameWorld
					w.showError("Insufficient wisdom (" + currentCost + "/" + w.wisdom + ")");
					trace("Insufficient wisdom.");
				}
				else
				{
					(world as GameWorld).startCast(this);
				}
			}
		}
		
		public function getTechType():String
		{
			return "INVALID";
			throw new Error("Not implemented.");
		}
	}
}