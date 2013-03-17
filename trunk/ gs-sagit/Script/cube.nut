/*
	File: cube.nut
	Author: DG
*/

/*!
	@short	Cube
	@author	DG
*/

class	Cube
{
	r_step = Rand(-0.1,0.1) //rotation step
	p_step = Rand(5,150) //position step

	captured 	= 0
	cst_ship1 	= 0
	cst_ship2 	= 0
	cst_ship3 	= 0

	RT_released	= 0

	hit			= 0
	dead		= 0

	// 1 if in the trajectory of the spaceship
	willHit		= 0

	mat				= 0
	SavedMatDiffuse	= 0


	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function 	OnCollision(item,with_item)
	{
		if (ItemGetName(with_item) == "bullet" )
			{
				ItemSetCollisionMask(item, 0)
				ItemSetLinearVelocity(item, Vector(1,1,0))
//				ItemSetAngularVelocity(item, Vector(0,0,0))
				ItemApplyLinearImpulse(item, Vector(0,500,0))
//				ItemSetCommandList(item, "toscale 3,0,0,0;")
				hit = 1
			}

/*		if (ItemGetName(with_item) == "tunnelCol" )
			{
				dead = 1
			}
*/
	}

	function	OnPhysicStep(item, dt)
	{
		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0"),
				padrt 		= DeviceInputValue(pad, DeviceAxisRT)

		if (usePad&&(padrt == 0.0))
			RT_released = 1

/*
		local timer = TickToSec(g_clock-SyncTimer)
		if ((timer >= SyncWait) && (timer <5))
		{
			local speed = ItemGetLinearVelocity(item)
			ItemSetLinearVelocity(item,Vector(0,0,0))
//			ItemApplyLinearImpulse(item, Vector(0,0,-1000))

			SyncTimer = g_clock
		}
*/

		if (!captured)
		{
			local rot = ItemGetRotation(item)
//			ItemApplyTorque(item, Vector(rot.x+0.01, rot.y+0.01, rot.z+0.01))
		}
		else
		{
			if	(DeviceKeyPressed(keyboard, KeyC) || DeviceKeyPressed(pad, KeyButton0))
//			if	(DeviceKeyPressed(keyboard, KeyC) ||  (RT_released && (usePad&&(padrt > 0.0))))
			{
				RT_released = 0
				ItemSetName(item, "bullet")

				ItemGetScriptInstance(SceneFindItem(g_scene, "Spacecraft")).armed = 0

				local _shape = ItemGetShapeFromIndex(item, 0)
				ShapeSetMass(_shape, 1000)
				SceneSetupItem(g_scene, item)
				
				ConstraintEnable(cst_ship1, false)
				ConstraintEnable(cst_ship2, false)
				ConstraintEnable(cst_ship3, false)
				captured = 0
				
				local booost = SceneGetScriptInstanceFromClass(ItemGetScene(item), "Level1" ).boost

				ItemPhysicSetLinearFactor(item, Vector(0,0,1))
				ItemApplyLinearImpulse(item, Vector(0,0,200))
			}
		}
	}

	function	OnUpdate(item)
	{
			
/*
		if (ItemGetScriptInstanceFromClass(item, "Cube").willHit == 1)
		{
			MaterialSetDiffuse(mat, Vector(255,0,0,255))
		}
		else
		{
			MaterialSetDiffuse(mat, SavedMatDiffuse)
		}
*/

/*		if (ItemGetPosition(item).y > 50)
			{
				dead = 1
			}
*/
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		ItemPhysicSetAngularFactor(item, Vector(0,0,0))
//		ItemSetAngularDamping(item, 0.1)
		ItemPhysicSetLinearFactor(item, Vector(0,0,1))
//		ItemApplyTorque(item, Vector(Rand(0,360), Rand(0,360), Rand(0,360)))
		captured = 0
	//	mat = GeometryGetMaterial(ItemGetGeometry(item), "Mesh/Material_001__cubevelbake.nmm")
//		SavedMatDiffuse = MaterialGetDiffuse(mat)

	}
}
