package hud 
{
	/**
	 * For displaying Wisdom.
	 * @author Johannes L. Borresen
	 */
	public class PowerHud extends HudText 
	{
		
		public function PowerHud(parent:GameWorld) 
		{
			super(parent, "Power ({%POWINC%}/{%TICK_COUNTER%}s): {%POWER%}");
		}
		
		override public function updateDisplay():void 
		{
			super.updateDisplay();
			
			text = baseCaption.replace("{%POWINC%}", parent.powIncome).replace("{%POWER%}", Math.floor(parent.power)).replace("{%TICK_COUNTER%}", GameWorld.TICK_INTERVAL);
		}
	}

}