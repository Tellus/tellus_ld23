package  
{
	import flash.events.DRMAuthenticationCompleteEvent;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	
	/**
	 * Simple progress bar. Display only, no business stuff.
	 * @author Johannes L. Borresen
	 */
	public class ProgressBar extends Entity 
	{
		private var _progress:Number = 0;
		
		public var bar:Canvas;
		
		public function get progress():Number { return _progress; }
		public function set progress(v:Number):void
		{
			_progress = v;
			// trace("new progress: " + v);
			bar.fill(new Rectangle(1, 1, bar.width * v, bar.height - 2), 0x00FF00);
		}
		
		public function ProgressBar(w:Number, h:Number) 
		{
			super();
			
			bar = new Canvas(w, h);
			bar.drawRect(new Rectangle(0, 0, w, h), 0);
			bar.fill(new Rectangle(1, 1, w - 2, h - 2), 0xFF0000);
			
			addGraphic(bar);
		}
		
	}

}