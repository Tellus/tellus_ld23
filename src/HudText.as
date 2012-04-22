package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	
	/**
	 * HUD Text display. Easy to update, static and non-responsive if not to
	 * tooltips.
	 * @author Johannes L. Borresen
	 */
	public class HudText extends Entity 
	{
		public var baseCaption:String;
		
		protected var _text:Text;
		
		public function get text():String { return _text.text; }
		public function set text(t:String):void { _text.text = t; }
		
		public var parent:GameWorld;
		
		public function HudText(parent:GameWorld, bc:String) 
		{
			super();
			
			this.parent = parent;
			baseCaption = bc;
			
			_text = new Text(bc);
			
			addGraphic(_text);
			
			// addTween(new Alarm(1, updateDisplay, Tween.LOOPING), true);
			
			updateDisplay();
			
			setHitbox(_text.scaledWidth, _text.scaledHeight);
		}
		
		override public function update():void 
		{
			super.update();
			updateDisplay();
		}
		
		public function updateDisplay():void
		{
			// Override to properly update the text property.
		}
		
	}

}