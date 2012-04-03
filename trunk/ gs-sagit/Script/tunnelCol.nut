/*
	File: tunnelCol.nut
	Author: DG
*/

/*!
	@short	tunnelCol
	@author	DG
*/
class	tunnelCol
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnPhysicStep(item, dt)
	{
		local pos = ItemGetPosition(item)
//		ItemSetPosition(item, Vector(pos.x, pos.y, pos.z - 2))
//		ItemApplyLinearImpulse(item, Vector(0,0,-0.5))
		ItemApplyLinearImpulse(item, Vector(0,0,-0.9 * (1+SceneGetScriptInstance(g_scene).boost)))
//		ItemApplyForce(item, Vector(ItemGetPosition()), Vector())

/*		if(ItemGetWorldPosition(item).z < -100)
			{
				SceneDeleteItem(g_scene, item)
				SceneDeleteItem(g_scene, ItemGetChild(item, "TunnelDivisionSolid"))
			}
*/
	}


	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		ItemPhysicSetLinearFactor(item, Vector(0, 0, 1))
		ItemPhysicSetAngularFactor(item, Vector(0,0,0))
	}
}
