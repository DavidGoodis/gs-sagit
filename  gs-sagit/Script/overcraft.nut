class	spacecraft
{
/*<
	<Script =
		<Name = "Overcraft oscillation">
		<Author = "David Ghodsi">
		<Description = "Simulates an overcraft default oscillation.">
		<Category = "Transformation">
		<Compatibility = <Item>>
	>
	<Parameter =
		<amplitude = <Name = "Amplitude"> <Type = "Float"> <Default = 5>>
		<step = <Name = "Step"> <Type = "Float"> <Default = 2>>
	>
>*/
	amplitude	=	5
	step 		=	2
	n			=	0
	v_impulse		= 	0

	function	OnPhysicStep(item,dt)
	{
		n += step
		v_impulse=cos(Deg(n))*0.01*amplitude
		if (ItemGetLinearVelocity(item) != 0)
			ItemApplyLinearImpulse(item,Vector(0,v_impulse,0))//.Scale(ItemGetMass(item)))
	}
}
