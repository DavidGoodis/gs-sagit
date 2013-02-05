/*
	File: ss1_9_tr/ss1_9_tr.nut
	Author: DG
*/

/*!
	@short	ss1_9_tr_ss1_9_tr
	@author	DG
*/

Include("script/globals.nut")

class	Level0
{
	
	//number of ennemies generated in one wave
	max_ennemies	= 50
	base_item		= 0
	new_item		= 0
	item_tableau 	= 0
	my_object		= 0
	my_geo			= 0
	gShipCanBarrel	= 0
	spot			= 0
	ship			= 0
	
	/*!
		@short	OnUpdate
		Called each frame.
	*/

	function	OnUpdate(scene)
	{
			foreach(idx,enemy in item_tableau)
			{
				if (ItemGetPosition(enemy).z < -50)
				{
					item_tableau.remove(idx)
					SceneDeleteItem(scene,enemy)
				}
			}

			if (item_tableau.len() < max_ennemies)
			{
				new_item = SceneDuplicateItem(scene, base_item)

				local scale_factor, rotation_y

				scale_factor = Rand(0.5, 1.5)
				rotation_y = DegreeToRadian(Rand(0.0, 90.0))
				ItemSetRotation(new_item, Vector(0, rotation_y, 0))
				ItemSetScale(new_item, Vector(scale_factor,scale_factor,scale_factor))
				ItemSetupScript(new_item)
				ItemSetup(new_item)

				ItemPhysicResetTransformation(new_item,Vector(Mtr(Rand(-150,150)), 0, 100),Vector(0,0,0))
				ItemApplyLinearImpulse(new_item,Vector(0,0,Rand(0,-100)))

				//Add the new ennemy to the list
				item_tableau.append(new_item)
//				ItemActivate(new_item,true)
			}

//		RendererDrawLineColored(EngineGetRenderer(g_engine),Vector(-500,0,-50),Vector(2000,0,2000), Vector(12,50,63))
//		spot = SceneFindItem(scene,"ShipSpot")
		ship = SceneFindItem(scene,"Spacecraft")
//		ItemSetPosition(spot,Vector(ItemGetPosition(ship).x-1,ItemGetPosition(ship).y-1,ItemGetPosition(ship).z-1 ))
//		ItemSetPosition(spot,Vector(Mtr(-0.6),Mtr(-1),Mtr(-1.6)))
	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{
		my_object = SceneAddObject(scene, "NMY")
		my_geo = ResourceFactoryLoadGeometry(g_factory, "cube_Extrude/Cube.nmg")
		ObjectSetGeometry(my_object, my_geo)

		base_item = ObjectGetItem(my_object)
		ItemSetPosition(base_item, Vector(-5000,-5000,-5000))
//		ItemSetInvisible(base_item,true)			//Do not display the dummy
//		ItemActivate(base_item,false)
//		ItemSetScale(base_item, Vector(1,1,1))
		ItemSetScript(base_item,"Script/cube.nut" , "Cube")

		item_tableau = []

		//prevents objets from falling down, makes them fall forward instead
		SceneSetGravity(scene, Vector(0,0,0))
		SceneSetPhysicFrequency(scene, 60.0)
	}
}