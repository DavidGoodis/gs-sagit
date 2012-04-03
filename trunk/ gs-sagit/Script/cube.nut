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

	captured = 0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function 	OnCollision(item,with_item)
	{
	}

	function	OnPhysicStep(item, dt)
	{
		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0"),
				padrt 		= DeviceInputValue(pad, DeviceAxisRT)

		if (!captured)
		{
			local rot = ItemGetRotation(item)
			ItemApplyTorque(item, Vector(rot.x+0.01, rot.y+0.01, rot.z+0.01))
		}
		else
		{
			if	((DeviceKeyPressed(keyboard, KeyC)) ||  (usePad&&(padrt > 0.0)))
			{
				ItemGetScriptInstance(ItemGetParent(item)).armed = 0
				ItemSetParent(item, NullItem)
				ItemSetSelfMask(item, 12)
				ItemSetCollisionMask(item, 16)
				captured = 0
	
				local booost = SceneGetScriptInstanceFromClass(ItemGetScene(item), "Level1" ).boost
				ItemApplyTorque(item, Vector(0,0,0))
				ItemPhysicSetLinearFactor(item, Vector(0,0,1))
				ItemApplyLinearImpulse(item, Vector(0,0,100))
			}
		}
	}

	function	OnUpdate(item)
	{
//		ItemSetOpacity(item, Clamp(Abs(1-ItemGetPosition(item).z/1000),0,1))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
        ItemSetPhysicMode(item, PhysicModeDynamic)
		ItemPhysicSetAngularFactor(item, Vector(1,1,1))
		ItemPhysicSetLinearFactor(item, Vector(1,0.1,1))

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

		ItemSetSelfMask(item, 3)
		ItemSetCollisionMask(item, 4)

		ItemWake(item)
	}
}
