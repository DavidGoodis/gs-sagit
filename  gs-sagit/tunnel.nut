/*
	File: tunnel.nut
	Author: DG
*/

/*!
	@short	Tunnel
	@author	DG
*/
class	Tunnel
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/

	step = -0.8

	function	OnUpdate(item)
	{
//		local pos = ItemGetPosition(item)
//		ItemSetPosition(item, Vector(pos.x, pos.y, pos.z + step*(1+SceneGetScriptInstance(g_scene).boost)))
	}


	function	OnPhysicStep(item, dt)
	{
//		local pos = ItemGetPosition(item)
//		ItemApplyLinearImpulse(item, Vector(0,0,-0.8 * (1+SceneGetScriptInstance(g_scene).boost)))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		ItemPhysicSetLinearFactor(item, Vector(0,0,1))
		ItemPhysicSetAngularFactor(item, Vector(0,0,0))
	}
}
