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
	fov			= 0
 
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

		cPos = ItemGetWorldPosition(item)
		fov = CameraGetFov(cam)

		local boost = SceneGetScriptInstanceFromClass(ItemGetScene(item), "Level1" ).boost
		if ( boost> 0)
		{
			cPos = cPos.Lerp(0.92,Vector(cPos.x,cPos.y,-120))
			fov = Lerp(0.1,fov,Deg(35))
//			ItemRegistrySetKey(item, "PostProcess:RadialBlur:Strength", boost/10)
		}
		else
		{
			local v = Vector(0,25,0).ApplyMatrix(ItemGetRotationMatrix(target))
//			cPos = Vector(cPos.x + v.x,cPos.y + v.y,-30)
			cPos = cPos.Lerp(0.70,Vector(cPos.x + v.x,cPos.y + v.y, -30))
//			cPos = cPos.Lerp(0.70,Vector(cPos.x,cPos.y+25,-30))
			fov = Lerp(0.1,fov,Deg(80))
//			ItemRegistrySetKey(item, "PostProcess:RadialBlur:Strength", 0.0)
		}

		CameraSetFov(cam, fov)

		local item_matrix = ItemGetMatrix(item)
//		print(item_matrix.GetFront().x + "::" + item_matrix.GetFront().y + "::" + item_matrix.GetFront().z)

		local	tPos = ItemGetWorldPosition(target)
//		ItemSetTarget(item, Vector(cPos.x,cPos.y,cPos.z))

//		ItemSetPosition(item, Vector(cPos.x+10, cPos.y+7, cPos.z-50))
//		ItemSetPosition(item, Vector(cPos.x, cPos.y, cPos.z-50))
		
//		local m = ItemGetMatrix(target).GetRow(0)

		cPos = cPos.Lerp(0.3, Vector(tPos.x, tPos.y, cPos.z))
/*		local x =  Clamp(cPos.x,-100,100)
		local y =  Clamp(cPos.y,-100,100)
		ItemSetPosition(item, Vector(x,y,cPos.z))
*/

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

		if (!("usePad" in getroottable()))
			local usePad = 1

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

		cam = ItemCastToCamera(item)
//		origPos = ItemGetWorldPosition(target)
//		ItemSetTarget(item, origPos)
	}
}
