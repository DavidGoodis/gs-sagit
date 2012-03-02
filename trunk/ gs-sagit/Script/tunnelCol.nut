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
	function	OnUpdate(item)
	{
		local pos = ItemGetPosition(item)
//		ItemSetPosition(item, Vector(pos.x, pos.y, pos.z - 2))
//		ItemApplyLinearImpulse(item, Vector(0,0,0.8*SceneGetScriptInstance(g_scene).boost))
		ItemApplyLinearImpulse(item, Vector(0,0,0.8*(1+SceneGetScriptInstance(g_scene).boost)))

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
		ItemPhysicSetLinearFactor(item, Vector(0, 0, -1))
		ItemPhysicSetAngularFactor(item, Vector(0,0,0))
	}
}
