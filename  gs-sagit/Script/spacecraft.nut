/*!
	@short	spacecraft
	@author	DG
*/

//gFFenergy <- 1000

class	spacecraft
{

	lt_step	 	= 10 //lateral translation step
	v_step		= 10 //vertical translation step
	r_step 		= 200 //rotation step
	max_barrel	= 40 //angle de tilt max
	gFFON		= 0
	armed		= 0
	gMaxEnergy  = 1000
	timer		= g_clock
	FFitem		= 0
	FFcolShape	= 0
	FFopacityStep = 0.04


//	========================================================================================================
	function	ItemSetCaptured(captured_item, by_item)
//	========================================================================================================
	{
//		ItemSetParent(captured_item, by_item)
		ItemSetCollisionMask(captured_item, 0)
		ItemGetScriptInstance(captured_item).captured = 1
//		local sPos = ItemGetPivot(by_item)
//		local cPos = ItemGetPivot(captured_item)
		ItemGetScriptInstance(captured_item).cst_ship1 = SceneAddPointConstraint(ItemGetScene(by_item), "shipcst1", by_item, captured_item, Vector(0,-10,5), Vector(0,10,10))
		ItemGetScriptInstance(captured_item).cst_ship2 = SceneAddPointConstraint(ItemGetScene(by_item), "shipcst2", by_item, captured_item, Vector(0,-15,10), Vector(0,15,20))
//		SceneAddPointConstraint(ItemGetScene(by_item), "shipcst", by_item, captured_item, Vector(0,5,0), Vector(0,-15,0))
//		ItemPhysicSetAngularFactor(captured_item, Vector(0,0,0))

//		ItemPhysicResetTransformation(captured_item, cPos, Vector(0,0,0))

		armed = 1
	}

//	========================================================================================================
	function	OnUpdate(item)
//	========================================================================================================
	{

		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0"),
				padrt 		= DeviceInputValue(pad, DeviceAxisRT)

		// Shield Activated
		if	((DeviceIsKeyDown(keyboard, KeyC)) ||  (usePad&&(padrt > 0.0)))
			{
				//sound feedback
				local shield  = EngineLoadSound(g_engine, snd_fx_shield)
				if ((!gFFON) && (!armed)) //if force field is off and ship is not armed
				{
					MixerSoundStart(g_mixer, shield)
//					ItemSetSelfMask(FFcolShape, 3)
					ItemSetCollisionMask(FFcolShape, 4)
//					SetShieldShape(item, "mesh")
					gFFON = 1
				}
				
				try{
					if (gFFenergy > 0)
						{
							gFFenergy -= 1 
							ItemSetOpacity(FFitem  , Clamp(ItemGetOpacity(FFitem) + FFopacityStep,0,1))
						}
					if (gFFenergy <= 0)
						{
							gFFenergy = 0
							local channel = MixerStreamStart(g_mixer,"data/noenergy.ogg")
							MixerChannelSetGain(g_mixer, channel, 0.8)
							MixerChannelSetLoopMode(g_mixer, channel, LoopNone )
							ItemSetOpacity(FFitem  , Clamp(ItemGetOpacity(FFitem) - FFopacityStep,0,1))
						}
					}catch(e){}
			}
		else
			{
				//let the shield active until it is totally invisible
				if (ItemGetOpacity(FFitem) <= 0 )
					if (gFFON)
					{
						gFFON = 0
//						ItemSetSelfMask(FFcolShape, 0)
						ItemSetCollisionMask(FFcolShape, 0)
//						SetShieldShape(item, "mesh")
					}

				if (TickToSec(g_clock-g_timer) >= 0.01)
				{
					g_timer = g_clock	
					try{
						if (gFFenergy < gMaxEnergy)
							gFFenergy++
						}
					catch(e){}

					ItemSetOpacity( FFitem  , Clamp(ItemGetOpacity(FFitem) - FFopacityStep,0,1))
				}
			}
	}

//	========================================================================================================
	function	SetShieldShape(item, shape)
//	========================================================================================================
	{
		local currentShape = ItemGetShapeFromIndex( item, 0)
        local size			= Vector(0,0,0)
		local minmax 		= ItemGetMinMax(item)
		size.x = minmax.max.x -  minmax.min.x
		size.y = minmax.max.y -  minmax.min.y
		size.z = minmax.max.z -  minmax.min.z

		if (shape == "sphere")
			ShapeSetSphere(currentShape,size.x)

		if (shape == "cube")
			ShapeSetBox(currentShape,size)

		if (shape == "mesh")
			ShapeSetMesh(currentShape, "Mesh/Spacecraft_LOPOLY.nmg")

//		ShapeSetPosition(currentShape, (minmax.max).Lerp(0.5, minmax.min))
		ItemSetup(item)
	}



//	========================================================================================================
	function	OnCollision(item, with_item)
//	========================================================================================================
	{
		local c_scene = ItemGetScene(item)

		// Collision feedback
		if (!gFFON)
		{
			try{
				gCam_shake = 1
			} catch(e){}
			local buuu  = EngineLoadSound(g_engine, snd_fx_wall)
			MixerSoundStart(g_mixer, buuu)
		}
		else
		{
			local o = ItemCastToObject(with_item)
			ObjectSetGeometry(o, EngineLoadGeometry(g_engine, "Mesh/beveled_cube_nmy.nmg"))
//			ItemApplyLinearImpulse(ObjectGetItem(o), Vector(0,0,1))
			
			local buuu  = EngineLoadSound(g_engine, snd_fx_otshield)
			MixerSoundStart(g_mixer, buuu)

			//grab the cube if FF is On and ship is not armed yet
/*			if (!armed)
				ItemSetCaptured(with_item, item)
*/
		}

		// Update Lifes
			try{
				if ((!gFFON) || (gFFenergy < 1))
					gLifes += -1
				if (gLifes == -1)
					gLifes = 0
			} catch(e){}

//		local inst = SceneGetScriptInstance(c_scene)
//		inst.UpdateLifes(gLifes)
//		Level1.UpdateLifes(gLifes)
//		print("glifes:"+gLifes)
	}

//	========================================================================================================
	function	OnPhysicStep(item,dt)
//	========================================================================================================
	{
		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0")

		local	old_mx = DeviceInputLastValue(mouse, DeviceAxisX),
		old_my = DeviceInputLastValue(mouse, DeviceAxisY)
		local	mx = DeviceInputValue(mouse, DeviceAxisX),
		my = DeviceInputValue(mouse, DeviceAxisY)

		local	padx = DeviceInputValue(pad, DeviceAxisX),
				pady = DeviceInputValue(pad, DeviceAxisY),
				pads = DeviceInputValue(pad, DeviceAxisS),
				padlt = DeviceInputValue(pad, DeviceAxisLT),
				padrt = DeviceInputValue(pad, DeviceAxisRT)

		local camera = SceneGetCurrentCamera(ItemGetScene(item))

		//Get the rotation matrix of the camera to compensate for the roll
		local camRot = ItemGetRotationMatrix(CameraGetItem(camera))

		if (useMouse == 1)
		{
			ItemPhysicResetTransformation(item,Vector((mx-0.5)*20,(-my+0.5)*15,0),ItemGetRotation(item))
		}

// Keeps the ship in the limits of the camera range
		local ShipScreenPosition = CameraWorldToScreen(camera, ItemGetPosition(item))

		if (ShipScreenPosition.x < 0)
			ItemPhysicResetTransformation(item, CameraScreenToWorldPlane(camera, 0, ShipScreenPosition.y, 30), ItemGetRotation(item))
		if (ShipScreenPosition.x > 1)
			ItemPhysicResetTransformation(item, CameraScreenToWorldPlane(camera, 1, ShipScreenPosition.y, 30), ItemGetRotation(item))
		if (ShipScreenPosition.y < 0)
			ItemPhysicResetTransformation(item, CameraScreenToWorldPlane(camera, ShipScreenPosition.x,0, 30), ItemGetRotation(item))
		if (ShipScreenPosition.y > 1)
			ItemPhysicResetTransformation(item, CameraScreenToWorldPlane(camera, ShipScreenPosition.x,1, 30), ItemGetRotation(item))

		if	((DeviceIsKeyDown(keyboard, KeyUpArrow)) || (usePad&&(pady > 0.0 )) || (DeviceIsKeyDown(pad, Up)))
				if (ShipScreenPosition.y > 0.0 )
					{
						if (!pady) pady = 1
//						ItemApplyLinearImpulse(item,Vector(0,v_step*0.8,0).Scale(ItemGetMass(item)))
	//					ItemApplyLinearImpulse(item,Vector(0,v_step*0.8,0).Scale(ItemGetMass(item)*low_dt_compensation))
//						ItemApplyLinearImpulse(item,Vector(-zRot*0.8,v_step*0.8,0)/*.Scale(low_dt_compensation)*/)
						ItemApplyLinearImpulse(item,(Vector(0,v_step*pady,0).ApplyMatrix(camRot))/*.Scale(low_dt_compensation)*/)
					}

		if	((DeviceIsKeyDown(keyboard, KeyDownArrow)) || (usePad&&(pady < 0.0 )) || (DeviceIsKeyDown(pad, Down)))
				if (ShipScreenPosition.y < 1.0 )
					{
						if (!pady) pady = -1
//						ItemApplyLinearImpulse(item,Vector(0,v_step*-0.8,0).Scale(ItemGetMass(item)))
//						ItemApplyLinearImpulse(item,Vector(zRot*0.8,v_step*-0.8,0)/*.Scale(low_dt_compensation)*/)
						ItemApplyLinearImpulse(item,(Vector(0,v_step*pady,0).ApplyMatrix(camRot))/*.Scale(low_dt_compensation)*/)
					}

		if	((DeviceIsKeyDown(keyboard, KeyLeftArrow)) || (usePad&&(padx < 0.0 )) || (DeviceIsKeyDown(pad, Left)))
				if (ShipScreenPosition.x > 0.0 )
					{
						if (!padx) padx = -1
//						ItemApplyTorque(item, Vector(0,0,r_step/5).Scale(ItemGetMass(item)))
//						ItemApplyLinearImpulse(item,Vector(lt_step*-0.5,0,0).Scale(ItemGetMass(item)))
//						ItemApplyTorque(item, Vector(0,0,r_step/5)/*.Scale(low_dt_compensation)*/)
						ItemApplyTorque(item, Vector(0,0,-2*ItemGetLinearVelocity(item).x)/*.Scale(low_dt_compensation)*/)
//						ItemApplyLinearImpulse(item,Vector(lt_step*-0.5,-zRot,0)/*.Scale(low_dt_compensation)*/)
						ItemApplyLinearImpulse(item,(Vector(lt_step*padx,0,0).ApplyMatrix(camRot))/*.Scale(low_dt_compensation)*/)

					ItemApplyTorque(item, Vector(0,0,r_step/10).Scale(ItemGetMass(item)))
					}

		if	((DeviceIsKeyDown(keyboard, KeyRightArrow)) || (usePad&&(padx > 0.0 )) || (DeviceIsKeyDown(pad, Right)))
				if (ShipScreenPosition.x < 1.0 )
					{
						if (!padx) padx = 1
//						print ("ShipScreenPosition.x < 1.0 !!! "+ShipScreenPosition.x)
//						ItemApplyTorque(item, Vector(0,0,-r_step/5).Scale(ItemGetMass(item)))
//						ItemApplyLinearImpulse(item,Vector(lt_step*0.5,0,0).Scale(ItemGetMass(item)))
						ItemApplyTorque(item, Vector(0,0,-2*ItemGetLinearVelocity(item).x)/*.Scale(low_dt_compensation)*/)
//						ItemApplyLinearImpulse(item,Vector(lt_step*0.5,zRot,0)/*.Scale(low_dt_compensation)*/)
	 					ItemApplyLinearImpulse(item,(Vector(lt_step*padx,0,0).ApplyMatrix(camRot))/*.Scale(low_dt_compensation)*/)

					ItemApplyTorque(item, Vector(0,0,-r_step/10).Scale(ItemGetMass(item)))
					}


		if	(DeviceIsKeyDown(keyboard, KeyA ))
					{
	 					ItemApplyLinearImpulse(item,Vector(0,0,50)/*.Scale(low_dt_compensation)*/)
					}


//Next 4 blocks are for the ship roll
		if	(DeviceIsKeyDown(keyboard, KeyX))
					ItemApplyTorque(item, Vector(0,0,r_step).Scale(ItemGetMass(item)))

		if	(usePad&&(pads < 0.0 ))
					ItemApplyTorque(item, Vector(0,0,r_step*-pads).Scale(ItemGetMass(item)))

		if	(DeviceIsKeyDown(keyboard, KeyV))
					ItemApplyTorque(item, Vector(0,0,-r_step).Scale(ItemGetMass(item)))

		if	(usePad&&(pads > 0.0 ))
					ItemApplyTorque(item, Vector(0,0,-r_step*pads).Scale(ItemGetMass(item)))

		//counters any barrel
		local currentRoll = ItemGetRotation(item).z
		ItemApplyTorque(item, Vector(0,0,-currentRoll*r_step).Scale(ItemGetMass(item)))

	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
//	========================================================================================================
	function	OnSetup(item)
//	========================================================================================================
	{
//      ItemSetPhysicMode(item, PhysicModeDynamic)
		ItemPhysicSetAngularFactor(item, Vector(0,0,gShipCanRoll))
		ItemPhysicSetLinearFactor(item, Vector(1,1,0))
//		ItemPhysicSetLinearFactor(item, Vector(1,1,1))
		ItemSetLinearDamping(item,0.01)
		ItemSetAngularDamping(item,0.01)

		FFitem		= SceneFindItem(ItemGetScene(item),"ForceField")
		FFcolShape 	= SceneFindItem(ItemGetScene(item),"ForceFieldCol")

		ItemSetCollisionMask(FFcolShape, 0)
	}
}
