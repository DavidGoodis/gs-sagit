/*
	File: Script/Rock.nut
	Author: DG
*/

/*!
	@short	Rock
	@author	DG
*/
class	Rock
{
	function	OnCollision(item, with_item)
	{
		print(ItemGetName(with_item))
	}

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{
		local rot = ItemGetRotation(item)
		ItemApplyTorque(item, Vector(rot.x+10,rot.y+10,rot.z+10))
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
               
    	_size.x = _mm.max.x -  _mm.min.x
        _size.y = _mm.max.y -  _mm.min.y
        _size.z = _mm.max.z -  _mm.min.z

        _pos = (_mm.max).Lerp(0.5, _mm.min)

		ShapeSetBox(_shape, _size)
//		ShapeSetMesh(_shape, "Mesh/None__asterock.nmm")
 	    ShapeSetPosition(_shape, _pos)

		_shape = ItemGetShapeFromIndex(item, 0)
	   	ShapeSetMass(_shape, 0.05)
		ItemSetOpacity(item,1)
		ItemSetScale(item,Vector(30,30,30))
		ItemSetSelfMask(item, 3)
		ItemSetCollisionMask(item, 4)

		ItemWake(item)

	}
}
