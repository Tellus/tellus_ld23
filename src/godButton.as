package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Input;
	
	/**
	 * Punish/Bless button entities. Makes click registering easier.
	 * @author Johannes L. Borresen
	 */
	public class godButton extends Entity 
	{
		/**
		 * Called when the button is clicked.
		 */
		public var clickCallback:Function = null;
		
		private var _image:Image;
		
		public function get alpha():Number { return _image.alpha; }
		public function set alpha(v:Number):void { _image.alpha = v; }
		
		public function godButton(src:Class) 
		{
			super();
			_image = new Image(src);
			addGraphic(_image);
			setHitbox(_image.width, _image.height);
		}
		
		override public function update():void 
		{
			super.update();
			
			if (clickCallback == null) return; // We don't care if you can't click it.
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				if (Input.mousePressed)
				{
					clickCallback.call();
					(world as GameWorld).hideTooltip();
				}
			}
		}
	}
}