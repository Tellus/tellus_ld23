package  
{
	import flash.geom.Rectangle;
	import flash.globalization.NumberParseResult;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	
	/**
	 * Custom tooltip for this game.
	 * @author Johannes L. Borresen
	 */
	public class StructureTooltip extends Entity 
	{
		[Embed(source = "../img/bless_button.png")] public static const BLESS_IMAGE:Class;
		[Embed(source="../img/punish_button.png")] public static const PUNISH_IMAGE:Class
		
		public var blessButton:godButton = new godButton(BLESS_IMAGE);
		public var punishButton:godButton = new godButton(PUNISH_IMAGE);
		
		public function get title():String { return _title.text; }
		public function set title(s:String):void
		{
			_title.richText = s;
		}
		
		public function get text():String { return _text.text; }
		public function set text(s:String):void
		{
			_text.richText = s;
		}
		
		public function get buff():String { return _text.text; }
		public function set buff(s:String):void
		{
			_buffText.richText = s;
		}
		
		/**
		 * Proxied alpha value. Passed to all members of graphic.
		 */
		private var _alpha:Number = 0;
		
		public function get alpha():Number { return _alpha; }
		public function set alpha(v:Number):void
		{
			_alpha = punishButton.alpha = blessButton.alpha = v;
			for each (var o:Object in (graphic as Graphiclist).children)
			{
				o["alpha"] = v;
			}
		}
		
		private var _title:Text;
		private var _text:Text;
		private var _buffText:Text;
		private var _bg:Canvas;
		
		protected static var BUFF_FORMAT:TextFormat = new TextFormat(null, null, 0x55FF55);
		protected static var DEBUFF_FORMAT:TextFormat = new TextFormat(null, null, 0xFF5555);
		protected static var BLESS_FORMAT:TextFormat = new TextFormat(null, null, 0x5691FF);
		protected static var PUNISH_FORMAT:TextFormat = new TextFormat(null, null, 0xFF7032);
		
		private var fadeTween:VarTween = new VarTween(null, Tween.PERSIST);
		
		public function StructureTooltip() 
		{
			_bg = new Canvas(FP.height, FP.height);
			_bg.fill(new Rectangle(0, 0, _bg.width, _bg.height), 0x000000, 0.5);
			setHitbox(_bg.width, _bg.height);
			
			_title = new Text("TITLE");
			_text = new Text("DESCRIPTION");
			_buffText = new Text("BUFF");
			
			_title.scale = _text.scale = _buffText.scale = 0.5;
			
			// Set all single-pass styling an placement here. The rest in
			
			_buffText.setStyle("buff", BUFF_FORMAT);
			_buffText.setStyle("debuff", DEBUFF_FORMAT);
			_buffText.setStyle("bless", BLESS_FORMAT);
			_buffText.setStyle("punish", PUNISH_FORMAT);

			addGraphic(_bg);
			addGraphic(_title);
			addGraphic(_text);
			addGraphic(_buffText);
			
			placeAssets()
			
			blessButton.visible = punishButton.visible = false;
			
			addTween(fadeTween, false);
			
			alpha = 0;
			visible = false;
			type = "TOOLTIP";
		}
		
		/**
		 * Relocates assets during display so they don't clutter.
		 */
		public function placeAssets():void
		{
			setHitbox(_text.scaledWidth + 10,
					  _text.scaledHeight + _title.scaledHeight + punishButton.height + _buffText.scaledHeight + 20);
			
			_bg.fill(new Rectangle(0, 0, FP.width, FP.height), 0xFFFFFF, 0);
			_bg.fill(new Rectangle(0, 0, width, height), 0, 0.5);

			// _bg.fill(new Rectangle(0, 0, width, height), 0, 0.3);
			// (graphic as Graphiclist).
					  
			// We assume new text strings have been supplied.
			_title.x = _title.y = _text.x = _buffText.x = 5;
			
			_text.y = _title.scaledHeight + _title.y ;
			
			_buffText.y = _text.y + _text.scaledHeight + 5;
			
			blessButton.x = x + halfWidth - (blessButton.halfWidth);
			blessButton.y = y + height - blessButton.height - 5;
			punishButton.x = x + halfWidth - (punishButton.halfWidth);
			punishButton.y = y + height - punishButton.height - 5;
		}
		
		public function show(s:WorldStructure):void
		{
			title = s.getName();
			text = s.getDescription();
			
			trace("Effect: " + s.activeEffect);
			
			var effdeff:String = s.getEffectText();
			
			switch (s.activeEffect)
			{
				case WorldStructure.EFF_BUFF:
					buff = "<buff>" + effdeff + "</buff>";
					enablePunishButton();
					break;
				case WorldStructure.EFF_DEBUFF:
					buff = "<debuff>" + effdeff + "</debuff>";
					enableBlessButton();
					break;
				case WorldStructure.EFF_BLESS:
					buff = "<bless>" + effdeff + "</bless>";
					disableButtons();
					break;
				case WorldStructure.EFF_PUNISH:
					buff = "<punish>" + effdeff + "</punish>";
					disableButtons();
					break;
				default:
					buff = effdeff;
					disableButtons();
			}
			
			x = (Input.mouseX + width > FP.width ? FP.width - width : Input.mouseX);
			y = (Input.mouseY + height > FP.height ? FP.height - height : Input.mouseY);
			
			placeAssets();
			
			/**
			 * TODO: Fix consecutive shows.
			 */
			// trace("Starting tween");
			
			// fadeTween.tween(this, "alpha", 1, 0.5);
			alpha = 1;
			
			visible = true;
			active = true;
		}
		
		public function hide():void
		{
			// fadeTween.tween(this, "alpha", 0, 0.2);
			alpha = 0;
			
			visible = false;
			active = false;
		}
		
		override public function added():void 
		{
			super.added();
			
			world.add(punishButton);
			world.add(blessButton);
		}
		
		protected function enablePunishButton():void
		{
			blessButton.active = blessButton.visible = false;
			punishButton.active = punishButton.visible = true;
		}
		
		protected function enableBlessButton():void
		{
			blessButton.active = blessButton.visible = true;
			punishButton.active = punishButton.visible = false;
		}
		
		protected function disableButtons():void
		{
			blessButton.visible = punishButton.visible = blessButton.active = punishButton.active = false;
		}
		
		override public function removed():void 
		{
			world.removeList(punishButton, blessButton);
			
			super.removed();
		}
		
		public function setCallbacks(bless:Function, punish:Function):void
		{
			punishButton.clickCallback = punish;
			blessButton.clickCallback = bless;
		}
	}

}