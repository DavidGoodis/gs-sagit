/*
	File: cube.nut
	Author: DG
*/

/*!
	@short	Cube
	@author	DG
*/

class	Cube2
{

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function 	OnCollision(item,with_item)
	{
		local buuu  = ResourceFactoryLoadSound(g_factory,snd_fx_wall)
		MixerSoundStart(g_mixer, buuu)
	}

	function	OnPhysicStep(item, dt)
	{
		ItemApplyLinearImpulse(item, Vector(0,0,-1))
	}

	function	OnUpdate(item)
	{

	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{

	}
}
