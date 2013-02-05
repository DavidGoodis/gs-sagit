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

			local sc = ItemGetScene(item)
			local ship_item = SceneFindItem(sc, "Spacecraft")

		if	((DeviceIsKeyDown(keyboard, KeyC)) ||  (usePad&&(padrt > 0.0)))
			if (!ItemGetScriptInstance(ship_item).armed)
			{
//				ItemSetSelfMask(item, 12)
//				ItemSetCollisionMask(item, 44)

				ItemSetSelfMask(item, 44)
				ItemSetCollisionMask(item, 16) //1 works also (same as the ship)

				ItemGetScriptInstance(item).captured = 1
				ItemGetScriptInstance(ship_item).armed = 1

				local o = ItemCastToObject(item)
//				ObjectSetGeometry(o, EngineLoadGeometry(g_engine, "Mesh/beveled_cube_nmy.nmg"))
				ObjectSetGeometry(o, EngineLoadGeometry(g_engine, "Mesh/Bullet.nmg"))

				ItemGetScriptInstance(item).cst_ship1 = SceneAddPointConstraint(ItemGetScene(item), "shipcst1", ship_item, item, Vector(0,-10,0), Vector(0,0,0))
				ItemGetScriptInstance(item).cst_ship2 = SceneAddPointConstraint(ItemGetScene(item), "shipcst2", ship_item, item, Vector(5,-5,0), Vector(-5,5,0))
				ItemGetScriptInstance(item).cst_ship3 = SceneAddPointConstraint(ItemGetScene(item), "shipcst3", ship_item, item, Vector(-5,-5,0), Vector(5,5,0))
			}
	}
}
