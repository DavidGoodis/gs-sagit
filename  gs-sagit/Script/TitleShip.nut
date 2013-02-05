/*
	File: Script/TitleShip.nut
	Author: DG
*/


/*!
	@short	Ship
	@author	DG
*/
class	Ship
{

	timer 		= g_clock
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
//	========================================================================================================
	function	OnUpdate(item)
//	========================================================================================================
	{
		//clean up all duplicated items
/*		local ace_deleter = AceDeleter()
		ace_deleter.Update()

		if(TickToSec(g_clock - timer) > 1.9  )
		{
			local flash = SceneDuplicateItem(ItemGetScene(item), item)
			ItemSetCommandList(flash, "toalpha 0,0.5; toscale 1,1.5,1.5,1.5+toalpha 1,0.0;")
			ace_deleter.RegisterItem(flash)
			timer = g_clock
		}
*/
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
	}
}
