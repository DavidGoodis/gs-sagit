/*
	File: Script/EndLessRotation.nut
	Author: DG
*/

/*!
	@short	EndLessRotation
	@author	DG
*/
class	EndLessRotation
{

/*<
    <Script =
        <Name = "Endless item rotation">
		<Author = "David Ghodsi">
        <Compatibility = <Item>>
    >
    <Parameter =
        <speed = <Name = "Rotation Speed"> <Type = "Float"> <Default = 32>>
    >
>*/
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/

	y = 0
	speed = 32

	function	OnUpdate(item)
	{

        ItemSetRotation(item, Vector(0.0, y, 0.0))    // update item rotation
        y += speed    // update Y rotation angle
	}


}
