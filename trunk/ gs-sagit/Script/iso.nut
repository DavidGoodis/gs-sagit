class	iso
{
	function 	OnCollision(item,with_item)
	{
	}

	function	OnUpdate(item)
	{
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
               
		ItemSetScale(item,Vector(1,1,1))
        _scale = ItemGetScale(item)
               
        if ((_scale.x != 1.0) ||  (_scale.x != 1.0) || (_scale.x != 1.0))
	        print("BuiltinItemPhysicbox::OnSetup() : Warning, item '" + ItemGetName(item) + "' has a scale factor != 1.0. Physic result might be wrong.")

    	_size.x = _mm.max.x -  _mm.min.x
        _size.y = _mm.max.y -  _mm.min.y
        _size.z = _mm.max.z -  _mm.min.z

        _pos = (_mm.max).Lerp(0.5, _mm.min)

		ShapeSetBox(_shape, _size)
   	    ShapeSetPosition(_shape, _pos)

    	ShapeSetMass(_shape, 0.05)
		ItemSetOpacity(item,1)
		ItemWake(item)
	}
}
