package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * Short and sweet red-coloured error text to pop up on screen.
	 * @author Johannes L. Borresen
	 */
	public class ErrorText extends Entity 
	{
		private var _text:Text;
		
		private var fadeTween:VarTween = new VarTween(null, Tween.PERSIST);
		private var timeoutTween:Alarm = new Alarm(3, onShown, Tween.PERSIST);
		
		public function ErrorText() 
		{
			super();
			
			addTween(fadeTween, false);
			addTween(timeoutTween, false);
			
			_text = new Text("ERROR!");
			visible = false;
		}
		
		public function show(s:String):void
		{
			_text.alpha = 0;
			
			_text = new Text(s);
			_text.color = 0x7F0000;
			x = FP.halfWidth - _text.textWidth / 2;
			y = FP.halfHeight;
			
			graphic = _text;
			
			visible = true;
			
			fadeTween.complete = onVisible;
			fadeTween.tween(this._text, "alpha", 1, 0.3);
		}
		
		public function onVisible():void
		{
			_text.alpha = 1;
			timeoutTween.reset(3);
		}
		
		public function onGone():void
		{
			visible = false;
		}
		
		public function onShown():void
		{
			fadeTween.complete = onGone;
			fadeTween.tween(this._text, "alpha", 0, 0.3);
		}
	}

}