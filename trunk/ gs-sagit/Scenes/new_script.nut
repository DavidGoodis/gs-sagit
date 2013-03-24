/*
	File: Scenes/new_script.nut
	Author: DG
*/

/*!
	@short	new_script
	@author	DG
*/
class	new_script
{

	function	OnUpdate(item)
	{
		local r =ItemGetRotation(item)
//		ItemSetRotation(item,Vector(0,0,r.z+1))
	}

	function	OnSetup(item)
	{
		ItemSetParent(item, obj)
	}
}
