/*
	File: tunneldivisionsolid.nut
	Author: DG
*/

/*!
	@short	tunnelDivisionSolid
	@author	DG
*/
class	tunnelDivisionSolid
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		local pos = ItemGetPosition(item)
//		ItemSetPosition(item, Vector(pos.x, pos.y, pos.z - 2))
//		ItemApplyLinearImpulse(item, Vector(0,0,0.8*Level1.boost))
		ItemApplyLinearImpulse(item, Vector(0,0,0.5))
	}


	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		ItemPhysicSetLinearFactor(item, Vector(0, 0, -1))
	}
}
