/*
	File: reactortrail.nut
	Author: DG
*/

/*!
	@short	ReactorTrail
	@author	DG
*/
class	ReactorTrail
{
	tabParticules 	= []
	prevPos			= 0
	newPart			= 0
	step			= 0.01 //depth of 1 trail step
	camItem			= 0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		//Get current position of the initial particule
		local pos 	= ItemGetWorldPosition(item)

		prevPos.z -= step
		newPart = SceneDuplicateItem(g_scene, item )
		ItemSetPosition(newPart, prevPos)
		prevPos	= pos

		tabParticules.append(newPart)
		local camZ = ItemGetPosition(camItem).z

		foreach(id,part in tabParticules)
		{
			local p = ItemGetWorldPosition(part)
			ItemSetPosition(part, Vector(p.x,p.y,p.z-step))
			ItemSetOpacity(part, Abs(1/(5*p.z)))

			if (p.z < camZ)
			{
				SceneDeleteItem(g_scene,part)
				tabParticules.remove(id)
			}
		}
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		prevPos = ItemGetWorldPosition(item)
		camItem = CameraGetItem(SceneGetCurrentCamera(g_scene))
	}
}
