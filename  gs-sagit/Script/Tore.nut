/*!
	@short	TunnelElement
	@author	DG
*/
class	TunnelElement
{
	angle = 0

	function	OnPhysicStep(item, dt)
	{
		local rot = ItemGetRotation(item)
//		ItemApplyTorque(item, Vector(rot.x+0.01, rot.y+0.01, rot.z+0.01))

		angle+=50
		if (angle > 360)
			angle = 0
/*
		if (angle <90)
			ItemApplyLinearImpulse(item, Vector(cos(Deg(angle)),sin(Deg(angle)),0))
		else if (angle <180)
			ItemApplyLinearImpulse(item, Vector(-cos(Deg(angle)),sin(Deg(angle)),0))
			else if (angle <270)
				ItemApplyLinearImpulse(item, Vector(-cos(Deg(angle)),-sin(Deg(angle)),0))
				else
					ItemApplyLinearImpulse(item, Vector(cos(Deg(angle)),-sin(Deg(angle)),0))
*/
//		ItemApplyTorque(item, Vector(Deg(10),Deg(10),Deg(10)))
	}

	function	OnUpdate(item)
	{
//		ItemSetOpacity(item, 1-ItemGetPosition(item).z/1000)
//		print(ItemGetPosition(item).z/1000)
	}

	function	OnSetup(item)
	{
	}
}