/*
	File: Script/cam.nut
	Author: DG
*/

/*!
	@short	GameCam
	@author	DG
*/

usePad <- 1

gCam_shake	 <- 0
gShake_count <- 0

class	GameCam
{
	SpeedCam 	= 0.1
 	acc			=	0
	euler		=	0
	cam			= 	0
	cam_shake	=	0
	cam_shake_amp	=	0.1
	cPos		= 0
	Abutton		= 82
	StartButton = 93
	LB			= 95
	RB			= 98
	Up			= 19
	Down		= 20
	Left		= 21
	Right		= 22
	rotationFactor = 3
	target		= 0
 
	function	CameraShake(amp)
	{
//		cam_shake = 1
		cam_shake_amp	=	amp
	}


	function	OnUpdate(item)
	{
		local	keyboard 	= GetKeyboardDevice(),
				mouse 		= GetMouseDevice(),
				pad 		= GetInputDevice("xinput0"),
				pads 		= DeviceInputValue(pad, DeviceAxisS),
				padt 		= DeviceInputValue(pad, DeviceAxisT),
				padx 		= DeviceInputValue(pad, DeviceAxisX),
				pady 		= DeviceInputValue(pad, DeviceAxisY),
				padlt 		= DeviceInputValue(pad, DeviceAxisLT),
				padrt 		= DeviceInputValue(pad, DeviceAxisRT)

		local item_matrix = ItemGetMatrix(item)
//		print(item_matrix.GetFront().x + "::" + item_matrix.GetFront().y + "::" + item_matrix.GetFront().z)

		cPos = ItemGetWorldPosition(item)
		local	tPos = ItemGetWorldPosition(target)
//		ItemSetTarget(item, Vector(cPos.x,cPos.y,cPos.z))

//		ItemSetPosition(item, Vector(cPos.x+10, cPos.y+7, cPos.z-50))
//		ItemSetPosition(item, Vector(cPos.x, cPos.y, cPos.z-50))
		
//		local m = ItemGetMatrix(target).GetRow(0)

		cPos = cPos.Lerp(0.96, Vector(tPos.x, tPos.y, cPos.z))
/*		local x =  Clamp(cPos.x,-100,100)
		local y =  Clamp(cPos.y,-100,100)
		ItemSetPosition(item, Vector(x,y,cPos.z))*/

		ItemSetPosition(item, cPos)

		if (gCam_shake == 0)
			{
			}
		else
			{
/*				gShake_count++

				ItemSetPosition(item,ItemGetPosition(item) + Vector().Randomize(-0.5,0.5).Scale(g_dt_frame * 60.0))
				if (gShake_count == 10)
					{
						ItemSetPosition(item,cPos)
						gShake_count = 0
						gCam_shake = 0
					}
*/			}

/*		if (!("usePad" in getroottable()))
			local usePad = 1
*/

//		if  (usePad&&(padx < 0.0 ))


//		ItemSetPosition(item, Vector(position.x+padx, position.y+pady, position.z))

//		if  (usePad&&(pady < 0.0 ))
	//				ItemSetPosition(item, Vector(position.x, position.y-0.1, position.z))


/*
		if	(DeviceIsKeyDown(keyboard, KeyX))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(rotationFactor)).Scale(g_dt_frame * 60.0))
		if	(DeviceIsKeyDown(keyboard, KeyLeftArrow))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(rotationFactor/10)).Scale(g_dt_frame * 60.0))
		if  (usePad&&(pads < 0.0 ))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-pads*rotationFactor)).Scale(g_dt_frame * 60.0))
//////
//		if  (usePad&&(padt < 0.0 ))
//					ItemSetPosition(item, Vector(cPos.x, cPos.y/2, cPos.z))
//////
		if	(DeviceIsKeyDown(keyboard, KeyV))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-rotationFactor)).Scale(g_dt_frame * 60.0))
		if	(DeviceIsKeyDown(keyboard, KeyRightArrow))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-rotationFactor/10)).Scale(g_dt_frame * 60.0))

		if  (usePad&&(pads > 0.0 ))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-pads*rotationFactor)).Scale(g_dt_frame * 60.0))

//		if  (usePad&&(padt > 0.0 ))
//					ItemSetPosition(item, Vector(cPos.x, cPos.y/2, cPos.z))

*/

		// Stabilize background

		local currentCamBarrel = ItemGetRotation(item).z
//		if (!pause)			
//			ItemSetRotation(item,Vector(0,0,currentCamBarrel-currentCamBarrel/200)) 


		local cRot = ItemGetRotationMatrix(item)
		local tRot = ItemGetRotationMatrix(target)
		local sRot = cRot.SlerpTo(0.1, tRot)
//		cRot = cRot.Lerp(0.9, Vector(tRot.x, tRot.y, cRot.z))

//		local cRot = ItemGetRotation(item).Lerp(0.1, ItemGetRotation(target))
		local m4 = ItemGetMatrix(item)
		m4.RotationFromMatrix3(sRot)
		ItemSetMatrix(item, m4)
//		ItemSetRotation(item, sRot)
	}


	function OnSetup(item)
	{
		target = SceneFindItem(g_scene, "Player/Spacecraft")

//		origPos = ItemGetWorldPosition(target)
//		ItemSetTarget(item, origPos)
	}
}
