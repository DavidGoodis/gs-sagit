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
		local booost = SceneGetScriptInstanceFromClass(ItemGetScene(item), "Level1" ).boost
		local pos = ItemGetPosition(item)
		ItemSetPosition(item, Vector(pos.x,pos.y,pos.z-1-booost))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{}
}
