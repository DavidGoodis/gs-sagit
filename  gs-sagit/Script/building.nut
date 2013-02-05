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
	function	OnUpdate(item)
	{
		local booost = SceneGetScriptInstanceFromClass(g_scene, "Level1" ).boost
		local pos = ItemGetPosition(item)
		local v = ItemGetLinearVelocity(item)

		if (!pause)
			ItemSetPosition(item, Vector(pos.x,pos.y,pos.z-5-booost))
		ItemSetOpacity(item, Clamp(100/pos.z,0,0.7))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{}
}
