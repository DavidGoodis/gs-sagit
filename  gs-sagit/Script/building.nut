/*
	File: Script/building.nut
	Author: DG
*/

/*!
	@short	Building
	@author	DG
*/
class	Building
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	scaleFactor = 0
	
	function	OnUpdate(item)
	{
		local booost = SceneGetScriptInstanceFromClass(g_scene, "Level1" ).boost
		local pos = ItemGetPosition(item)
		local v = ItemGetLinearVelocity(item)

		if (!pause)
			ItemSetPosition(item, Vector(pos.x,pos.y,pos.z-5-booost))

		ItemSetOpacity(item, Clamp(100/pos.z,0,0.7))

		local timer = TickToSec(g_clock-SyncTimer)
		if ((timer >= SyncWait*2) && (timer < (SyncWait*2 + 0.1)))
		{
//			ItemSetPosition(item, Vector(pos.x,pos.y,pos.z-20-booost))
			ItemSetScale(item, ItemGetScale(item)*Rand(0.9,1.1))
		}

		if (timer >= SyncWait*2 + 0.1)
			SyncTimer = g_clock


	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
//		scaleFactor = Rand(0.9,1.1)
	}
}
