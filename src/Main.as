package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import GameWorld;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import Playtomic.Log;
	import TitleWorld;
	
	/**
	 * Main stuff!
	 * @author Johannes L. Borresen
	 */
	// [Frame(factoryClass="Preloader")]
	public class Main extends Engine 
	{
		public static const SQUARE_SIZE:Number = 32;
		
		public static var leftMarg:Number;
		public static var topMarg:Number;
		public static var botMarg:Number;
		
		public function Main():void 
		{
			super(400, 300, 60, false);
			FP.screen.scale = 2;
			
			leftMarg = (FP.width % SQUARE_SIZE) / 2;
			topMarg = 10;
		}
		
		/**
		 * Initializer code.
		 */
		override public function init():void 
		{
			super.init();
			
			// Load Playtomic.
			Log.View(7705, "c0d28bdfb72547fe", "d1592afcb53b4f76bf78de3be06fd2", root.loaderInfo.loaderURL);
			// Force empty packet?
			Log.ForceSend();
			
			// Enable the Flashpunk console.
			FP.console.toggleKey = Key.NUMPAD_MULTIPLY;
			_createBaseInputs();
			
			// Remove comment to activate splash screen. We dodge it for now.
			// FP.world = new FlashPunkWorld();
			
			// INSERT START WORLD HERE!
			FP.world = new TitleWorld();
			
			// Temp
			// FP.world = new GameWorld();
		}
		
		override public function update():void 
		{
			super.update();
			if (Input.pressed("CONSOLE")) FP.console.enable();
		}
		
		private function _createBaseInputs():void
		{
			trace("Base inputs created.");
			Input.define("LEFT", Key.A, Key.LEFT);
			Input.define("RIGHT", Key.D, Key.RIGHT);
			Input.define("UP", Key.W, Key.UP);
			Input.define("DOWN", Key.S, Key.DOWN);
			Input.define("CONSOLE", Key.C);
		}
	}
}