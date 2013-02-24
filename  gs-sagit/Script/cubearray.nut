/*
	File: Script/cubearray.nut
	Author: DG
*/

/*!
	@short	Scenes_CubeArray
	@author	DG
*/
class	Scenes_CubeArray
{
	/*!
		@short	OnUpdate
		Called each frame.
	*/
	wallTimer		= g_clock
	refi			= 0

	function	OnUpdate(scene)
	{}

	function	SpawnWall(scene, nx, ny)
	{
		local refix = ItemGetMinMax(refi).max.x - ItemGetMinMax(refi).min.x
		local refiy = ItemGetMinMax(refi).max.y - ItemGetMinMax(refi).min.y
		local scale_ = ItemGetScale(refi)

		for(local j=0;j<ny;j++)
			for(local i=0;i<ny;i++)
			{
				local cub_ = SceneDuplicateItem(scene, refi)
				ItemSetScript(cub_, "Script/cube2.nut" , "Cube2")
				ItemSetupScript(cub_)

				SceneSetupItem(scene,cub_)
				ItemPhysicResetTransformation(cub_, Vector(i*refix*scale_.x, j*refiy*scale_.y, 0.0), Vector(0,0,0))
//				ItemSetPosition(cub_, Vector(Mtr(i*refix*scale_.x), Mtr(j*refiy*scale_.y), 0.0))
			}
	}

	function	OnPhysicStep(scene, taken)
	{
		if (TickToSec(g_clock-wallTimer) >= 3)
			{
				SpawnWall(scene, 10,10)
				wallTimer = g_clock
			}
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{
		refi = SceneFindItem(scene, "Cube")

		SceneSetGravity(scene, Vector(0,0,1))
	}
}
