/*
	File: Script/shiptrigger.nut
	Author: DG
*/

/*!
	@short	ShipTrigger
	@author	DG
*/
class	ShipTrigger
{
	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/
	function	OnUpdate(item)
	{}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{}

	function 	OnItemEnter(trigger_item, item)
	{
		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0"),
				padrt 		= DeviceInputValue(pad, DeviceAxisRT)

		if	((DeviceIsKeyDown(keyboard, KeyC)) ||  (usePad&&(padrt > 0.0)))
		{
			ItemSetCollisionMask(item, 0)
			ItemGetScriptInstance(item).captured = 1
			local sc = ItemGetScene(item)
			local ship = SceneFindItem(sc, "Spacecraft")
	//		local sPos = ItemGetPivot(by_item)
	//		local cPos = ItemGetPivot(captured_item)
			ItemGetScriptInstance(item).cst_ship1 = SceneAddPointConstraint(ItemGetScene(item), "shipcst1", ship, item, Vector(0,-10,5), Vector(0,10,10))
			ItemGetScriptInstance(item).cst_ship2 = SceneAddPointConstraint(ItemGetScene(item), "shipcst2", ship, item, Vector(0,-15,10), Vector(0,15,20))
		}
	}
}
