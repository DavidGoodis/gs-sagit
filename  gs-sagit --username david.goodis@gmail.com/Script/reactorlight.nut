/*
	File: script/reactorlight.nut
	Author: DG
*/

/*!
	@short	ReactorLight
	@author	DG
*/
class	ReactorLight
{
	max_intensity 	= 4
	intensity		= 0
	light			= 0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		intensity +=0.05
		LightSetDiffuseIntensity(light, 5+max_intensity*Abs(cos(intensity)))
		LightSetSpecularIntensity(light, 5+max_intensity*Abs(cos(intensity)))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		light = ItemCastToLight(item)
	}
}
