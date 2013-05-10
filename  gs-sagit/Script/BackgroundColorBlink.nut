/*
	File: Script/BackgroundColorBlink.nut
	Author: DG
*/

/*!
	@short	bgblink
	@author	DG
*/
class	bgblink
{

/*<
	<Script =
		<Name = "Blink Scene Background">
		<Author = "David Ghodsi">
		<Description = "Blinks the scene background. Configurable color and speed">
		<Category = "Scene">
		<Compatibility = <Scene>>
	>
	<Parameter =
		<active = <Name = "Active"> <Type = "Bool"> <Default = 0>>
		<red = <Name = "TargetRed [0,1]"> <Type = "Float"> <Default = 0.5>>
		<green = <Name = "TargetGreen [0,1]"> <Type = "Float"> <Default = 0.5>>
		<blue = <Name = "TargetBlue [0,1]"> <Type = "Float"> <Default = 0.5>>
		<step = <Name = "Step"> <Type = "Float"> <Default = 0.1>>
	>
>*/

	active		= false
	step		= 0.1
	red			= 0.5
	green		= 0.5
	blue		= 0.5
	n			= 0

	//	========================================================================================================
	function	OnUpdate(scene)
	//	========================================================================================================
	{

		if (active)
		{
			n += step
			if (n >= 90) n = 0
			local r = sin(Deg(n*(red)))
			local g = sin(Deg(n*(green)))
			local b = sin(Deg(n*(blue)))
			SceneSetBackgroundColor(scene, Vector(r, g, b))
		}
		else
			SceneSetBackgroundColor(scene, Vector(1, 1, 1))
	}
}
