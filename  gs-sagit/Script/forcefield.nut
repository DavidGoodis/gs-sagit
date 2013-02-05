/*
	File: forcefield.nut
	Author: DG
*/

Include("Script/ace_deleter.nut")

/*!
	@short	ForceField
	@author	DG
*/
class	ForceField
{
	timer 		= g_clock

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
//	========================================================================================================
	function	OnPhysicStep(item,dt)
//	========================================================================================================
	{
	}

//	========================================================================================================
	function	OnUpdate(item)
//	========================================================================================================
	{
		local ace_deleter = AceDeleter()
		ace_deleter.Update()

/*		if (ItemGetScriptInstance(SceneFindItem(ItemGetScene(item), "Spacecraft")).gFFON)
			if (TickToSec(g_clock - timer) > 1 )
			{
				local flash = SceneDuplicateItem(ItemGetScene(item), item)
				ItemSetCommandList(flash, "toscale 0.5,20,20,20+toalpha 0.3,0.0;")
				ace_deleter.RegisterItem(flash)
				timer = g_clock
			}		

		ItemSetRotation(item, Vector(Rand(0, 90),Rand(0, 90), Rand(0,90)))
*/

	}


	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
//	========================================================================================================
	function	OnSetup(item)
//	========================================================================================================
	{
	}
}
