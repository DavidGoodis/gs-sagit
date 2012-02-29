/*
	File: Earth.nut
	Author: DG
*/

/*!
	@short	Sphere
	@author	DG
*/
class	Sphere
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/

	function	OnUpdate(item)
	{
		ItemSetRotation(item,ItemGetRotation(item)+Vector(0,0.0002,0) )
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{}
}
