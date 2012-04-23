package  
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import splash.Splash;
	import TitleWorld;
	
	/**
	 * FlashPunk logo splash.
	 * @author Johannes L. Borresen
	 */
	public class FlashPunkWorld extends World
	{
		public function FlashPunkWorld() 
		{
			var s:Splash = new Splash();
			add(s);
			s.start(OnSplashed);
		}
		
		public function OnSplashed():void
		{
			FP.world = new TitleWorld();
		}
	}
}