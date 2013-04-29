/*
	File: Scenes/scene.nut
	Author: DG
*/

/*!
	@short	scene
	@author	DG
*/

obj 		<- 0
objexists   <- 0

class	scene
{
	function	OnUpdate(scene)
	{
		if (objexists)
		{
			print("=== Z === " + ItemGetWorldPosition(obj).z)

			local r = ItemGetRotation(obj)
			local p = ItemGetWorldPosition(obj)
			ItemSetRotation(obj, Vector(r.x,r.y,r.z+0.01))
			ItemSetPosition(obj, Vector(p.x,p.y,p.z-1))

			if (p.z < -200)
			{
				print(p.z)
				local children = ItemGetChildList(obj)
				foreach(ic, child in children)
				{
					print("--->Child " + ic + "::Z=" + ItemGetWorldPosition(child).z)
					SceneDeleteItem(scene, child)
				}

				SceneDeleteObject(scene,obj)
				objexists = 0
			}
		}
	}

	function	OnSetup(scene)
	{
		SceneSetGravity(scene, Vector(0,0,0))
		SceneSetPhysicFrequency(scene, 75.0)

		obj = SceneAddObject(scene, "obj")
		ItemSetPosition(obj, Vector(0,0,200))
		objexists = 1

		for(local i=0;i<10;i++)
		{
				local	new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCube"))

		 		ItemSetScript(new_item, "Script/cube.nut" , "Cube")
				ItemSetupScript(new_item)
				ItemRenderSetup(new_item, g_factory)
		 		SceneSetupItem(scene, new_item)
				ItemSetup(new_item)

				ItemSetPosition(new_item, Vector(0,i*12-60,0))
//				ItemSetPhysicMode(new_item, PhysicModeNone)
//				ItemPhysicResetTransformation(new_item, loc ,Vector(0,0,0))
//				ItemApplyLinearImpulse(new_item,Vector(0,0,-objVelocity))

				ItemSetParent(new_item, obj)
		}

		print("=== Z === " + ItemGetWorldPosition(obj).z)

//		SceneDeleteObject(scene, obj)
//		objexists = 0
	}

}
