package hud 
{
	/**
	 * For displaying Wisdom.
	 * @author Johannes L. Borresen
	 */
	public class WisdomHud extends HudText 
	{
		
		public function WisdomHud(parent:GameWorld) 
		{
			super(parent, "Wisdom ({%WISINC%}/{%TICK_COUNTER%}): {%WISDOM%}");
		}
		
		override public function updateDisplay():void 
		{
			super.updateDisplay();
			
			text = baseCaption.replace("{%WISINC%}", parent.wisIncome).replace("{%WISDOM%}", Math.floor(parent.wisdom)).replace("{%TICK_COUNTER%}", GameWorld.TICK_INTERVAL);
		}
	}

}