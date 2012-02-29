/*
	File: Script/cam.nut
	Author: DG
*/

/*!
	@short	GameCam
	@author	DG
*/

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
	origPos		= 0
 
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

		cPos = ItemGetPosition(target)
//		ItemSetTarget(item, Vector(cPos.x,cPos.y,cPos.z))

		ItemSetPosition(item, Vector(cPos.x/1.5, cPos.y/1.25, cPos.z-30))

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

		if	(DeviceIsKeyDown(keyboard, KeyX))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(rotationFactor)).Scale(g_dt_frame * 60.0))
		if  (usePad&&(pads < 0.0 ))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-pads*rotationFactor)).Scale(g_dt_frame * 60.0))
//////
		if  (usePad&&(padt < 0.0 ))
					ItemSetPosition(item, Vector(cPos.x, cPos.y/2, cPos.z))
//////
		if	(DeviceIsKeyDown(keyboard, KeyV))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-rotationFactor)).Scale(g_dt_frame * 60.0))
		if  (usePad&&(pads > 0.0 ))
					ItemSetRotation(item, ItemGetRotation(item) + Vector(0,0,Deg(-pads*rotationFactor)).Scale(g_dt_frame * 60.0))

		// Stabilize background
		local currentCamBarrel = ItemGetRotation(item).z
		if (!pause)			
			ItemSetRotation(item,Vector(0,0,currentCamBarrel-currentCamBarrel/15)) 

	}


	function OnSetup(item)
	{
		target = SceneFindItem(g_scene, "Player/Spacecraft")

		origPos = ItemGetPosition(target)
//		ItemSetPivot(item,ItemGetPivot(target))
	}
}
