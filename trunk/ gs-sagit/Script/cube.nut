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
				ItemSetAngularVelocity(item, Vector(0,0,0))
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

		if (!captured)
		{
			local rot = ItemGetRotation(item)
			ItemApplyTorque(item, Vector(rot.x+0.01, rot.y+0.01, rot.z+0.01))
		}
		else
		{
			if	(DeviceKeyPressed(keyboard, KeyC) || DeviceKeyPressed(pad, Abutton))
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
		if (ItemGetPosition(item).y > 50)
			{
//				dead = 1
			}
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
/*
        ItemSetPhysicMode(item, PhysicModeDynamic)

        local        _shape		= ItemAddCollisionShape(item)
        local        _size		= Vector(0,0,0),
                     _pos		= Vector(0,0,0),
                     _scale		= Vector(0,0,0)

        local        _mm = ItemGetMinMax(item)
               
		ItemSetScale(item,Vector(5,5,5))
        _scale = ItemGetScale(item)
               
    	_size.x = _mm.max.x -  _mm.min.x
        _size.y = _mm.max.y -  _mm.min.y
        _size.z = _mm.max.z -  _mm.min.z

        _pos = (_mm.max).Lerp(0.5, _mm.min)

		ShapeSetBox(_shape, _size)
   	    ShapeSetPosition(_shape, _pos)

    	ShapeSetMass(_shape, 0.05)
		ItemSetOpacity(item,1)

		ItemSetSelfMask(item, 15)
		ItemSetCollisionMask(item, 4)

		ItemWake(item)
*/
		ItemPhysicSetAngularFactor(item, Vector(1,1,1))
		ItemSetAngularDamping(item, 0.1)
		ItemPhysicSetLinearFactor(item, Vector(1,0.1,1))

		captured = 0
	}
}
