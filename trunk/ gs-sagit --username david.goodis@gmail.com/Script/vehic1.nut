class	Vehic1
{
	amplitude		=	40
	speed 			=	5
	n				=	0
	r_torque		= 	0
	v_impulse		=	0

	function 	OnCollision(item,with_item)
	{
	}

	function	OnPhysicStep(item,dt)
	{
		n += speed
		r_torque = cos(Deg(n))*amplitude
		v_impulse=cos(Deg(n))*0.01*amplitude
		if (ItemGetLinearVelocity(item) != 0)
			ItemApplyLinearImpulse(item,Vector(0,v_impulse,0).Scale(ItemGetMass(item)))
//		if (ItemGetAngularVelocity(item) != 0)
//			ItemApplyTorque(item,Vector(r_torque,0,0).Scale(ItemGetMass(item)))
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
        ItemSetPhysicMode(item, PhysicModeDynamic)
		ItemPhysicSetAngularFactor(item, Vector(0,0,0))
		ItemPhysicSetLinearFactor(item, Vector(0,1,1))

        local        _shape		= ItemAddCollisionShape(item)
        local        _size		= Vector(0,0,0),
                     _pos		= Vector(0,0,0),
                     _scale		= Vector(0,0,0)
        local        _mm 		= ItemGetMinMax(item)
               
		ItemSetScale(item,Vector(1,1,1))
        _scale = ItemGetScale(item)
               
        if ((_scale.x != 1.0) ||  (_scale.x != 1.0) || (_scale.x != 1.0))
	        print("BuiltinItemPhysicbox::OnSetup() : Warning, item '" + ItemGetName(item) + "' has a scale factor != 1.0. Physic result might be wrong.")

    	_size.x = _mm.max.x - _mm.min.x
        _size.y = _mm.max.y - _mm.min.y
        _size.z = _mm.max.z - _mm.min.z

        _pos = (_mm.max).Lerp(0.5, _mm.min)

		ShapeSetBox(_shape, _size)
   	    ShapeSetPosition(_shape, _pos)

		ItemSetSelfMask(item, 3)
		ItemSetCollisionMask(item, 4)

    	ShapeSetMass(_shape, 1)
		ItemSetOpacity(item,1)
		ItemWake(item)
	}
}