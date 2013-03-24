 /*
	File: Script/Level1.nut
	Author: DG
*/

Include("Script/gui.nut")
Include("Script/globals.nut")

usePad <- 1

/*!
	@short	ss1_9_tr_ss1_9_tr
	@author	DG
*/

gLifes 			<- 10
gLifesMax		<- 10
gLifesWindow	<- 0
gScore			<- 0
g_ui_IDs		<- 0
gShipCanBarrel	<- 1
game_over		<- 0
//gFFON			<- 0
gFFenergy		<- 100
lifeBar			<- 0
low_dt_compensation <-0
targetList		<- 0
pause			<- 0

//Engine 
g_timer		  <- 0.0
g_clock_scale <- 0.0

class	Level1
{
	
//=== number of ennemies generated in one wave
	max_ennemies	= 20
	base_item		= 0
	new_item		= 0
	gShipCanBarrel	= 1
	channel_music	= 0
	helpLabel		= 0
	helpLabel2		= 0
	helpCounter		= 0
	opa				= 1
//=== ui ===//
	ui				= 0
	scoreWindow     = 0
	boostWindow		= 0
	oneupWindow		= 0
	lblEnergy		= 0
	lblGameOver		= 0
	lblRetry		= 0
	lblGetReady		= 0
	lblPause		= 0
	energyBar		= 0
	lblDestr		= 0
//=== debug ===//
	lblDbgEnemies	= 0
	lblDbgTargetList = 0
	lblDbgBiru		= 0
	lblDbgSlice		= 0
	debugFont		= 0
//===  ===//
	Xbutton			= 84
	phase			= 0
	timer			= g_clock
	seqTimer		= g_clock
	boost			= 0
	boostON			= 0
	rockON			= false
//=== score ===
	scorTimer		= 0
	oneupScore		= 5000
	scoreCounter	= 1
//=== city ===
	c_terrain_height= -100
	wait			= 0
	citigenCount	= 0
	biruArray		= []
//=== tunnel ===
	arrTunnel		= []
	maxTunnelSlice	= 10
	tunnelSliceCol 	= 0
	tunnelSliceMesh = 0
	tunnelScale		= 0
//=== cubes ===
	beveled_cube	= 0
	destroyed		= 0
//=== walls ===
	wallTimer		= 0
	wallFreq		= 0
	wallPieces		= 0

//=== grid ====
//	gridArLoc		= [] //Array of locations. size = gridDendity*gridDensity
	gridArPat1		= []
	objVelocity		= 350
	spawnZ			= 1000

	patfs			= []
	patlocs			= []
	patobjs			= []

//	pattern1		= [1,1,1,1,1,0,0,1,1,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1]

	enemiesT1		= []


	patTimer		= 0
//	patWait			= 1.8
	patWait			= 4
	seq				= 1


//	========================================================================================================
	function	ComputeLowDeltaFrameCompensation()
//	========================================================================================================
	{
		//	low_dt_compensation is a factor (btw 0.0 and 1.0)
		//	that you might need when apply forces, impulses & torques.
		low_dt_compensation = Clamp(1.0 / (60.0 * g_dt_frame), 0.0, 1.0)

	}

//	========================================================================================================
	function	UpdateLifes(lifes)
//	========================================================================================================
	{
//		TextSetText(gLifesWindow[1], lifes.tostring())
		WindowSetSize(lifeBar,gLifes*25,20)
	}

//	========================================================================================================
	function	Pause(scene)
//	========================================================================================================
	{
		if (!pause)
		{
			g_clock_scale = SceneGetClockScale(scene)
			SceneSetClockScale(scene, 0.0)
//			EngineSetClockScale(g_engine, 0.0)
			pause = true
			WindowSetOpacity(lblPause[0], 0.8)

			local s  = ResourceFactoryLoadSound(g_factory, "data/pause.wav")
			MixerSoundStart(g_mixer, s)
		}
		else
		{
			SceneSetClockScale(scene, g_clock_scale)
//			EngineSetClockScale(g_engine, g_clock_scale)
			pause = false
			SpriteSetOpacity(lblPause[0],0)
			local s  = ResourceFactoryLoadSound(g_factory, "data/resume.wav")
			MixerSoundStart(g_mixer, s)
		}
	}

//	========================================================================================================
	function	SpawnItem(scene, item, spawn_loc,spawn_scale, spawn_rot, spawn_dir, spawn_tor)
//	========================================================================================================
	{
		local spawned = SceneDuplicateItem(scene, item)

		ItemSetupScript(spawned)
//		ItemSetup(spawned)
		ItemRenderSetup(spawned, g_factory)
		SceneSetupItem(scene, spawned)
		ItemPhysicResetTransformation(spawned, spawn_loc, spawn_rot)
		ItemSetScale(spawned, spawn_scale)
		ItemApplyLinearImpulse(spawned, spawn_dir)
//		ItemApplyTorque(spawned, spawn_tor)
//		ItemSetLinearVelocity(spawned, Vector(0,0,-1))
		ItemSetAngularVelocity(spawned,Vector(1,0,0))

		return(spawned)
	}


//	========================================================================================================
	function	GotAchievement(scene, achievement)
//	========================================================================================================
	{

		if (achieved.find(achievement) == null)
		{
			local tex 		= ResourceFactoryLoadTexture(g_factory, "Tex/achievement_" + achievement + ".png")
			local achiSprit = UIAddNamedSprite(SceneGetUI(scene), "spr", tex, 500, -200, TextureGetWidth(tex), TextureGetHeight(tex))
			WindowSetCommandList(achiSprit, "toposition 2,500,50; toposition 5,500,50; toposition 2,500,-200;")
			achieved.append(achievement)
		} else return
	}


//	========================================================================================================
	function	GenerateCity(scene, xmin, xmax, ymin, ymax, xcount, ycount, opacity)
//	========================================================================================================
	{
		local new_biru
		local street_width_ratio = 2 //street will be 1/street_width_ratio of a building's side

		//computes the sides of a building
		local x = street_width_ratio*(xmax-xmin)/(5*xcount-1)
		local y = street_width_ratio*(ymax-ymin)/(5*ycount-1)

		for(local i=ymin;i<ymax;i+=5*y/street_width_ratio)
			for(local j=xmin;j<xmax;j+=5*x/street_width_ratio)
				if ((j < -100) || (j > 100))
			{
				if (Rand(1,10).tointeger() == 5)
//						MaterialSetDiffuse(GeometryGetMaterialFromIndex(ItemGetGeometry(new_biru), 0), Vector(255,0,0,255))
					new_biru = SceneDuplicateItem(scene, SceneFindItem(scene,"Building-red"))
				else
					new_biru = SceneDuplicateItem(scene, SceneFindItem(scene,"Building"))

				ItemSetupScript(new_biru)
				ItemRenderSetup(new_biru, g_factory)

				local scalex = x/(ItemGetMinMax(new_biru).max.x - ItemGetMinMax(new_biru).min.x)
				local scaley = y/(ItemGetMinMax(new_biru).max.y - ItemGetMinMax(new_biru).min.y)
				local scalez = Rand(10,200)
				ItemSetScale(new_biru, Vector(scalex,scaley,scalez))
				ItemSetPosition(new_biru, Vector(Mtr(j), Mtr(c_terrain_height+scalez), Mtr(i)))
				ItemSetOpacity(new_biru, opacity)
//				ItemSetCommandList(new_biru, "loop; toscale 1," + scalex + "," + scaley + "," + scalez*1.5 + "; toscale 1," + scalex + "," + scaley + "," + scalez + "; next;")
				biruArray.append(new_biru)
			} 

		return(y)
	}

//	========================================================================================================
	function	CleanCity(scene)
//	========================================================================================================
	{
		foreach(id, biru in biruArray)
			if (ItemGetPosition(biru).z < -100)
			{
				SceneDeleteItem(scene, biru)
				biruArray.remove(id)
			}
	}

//	========================================================================================================
	function	GenerateTunnelSlice(scene, tunnelArray, scale)
//	========================================================================================================
	{
//		if (tunnelArray.len() < maxTunnelSlice)
		{
			local lastSlice 	= tunnelArray.top()
			local lastSlicePos 	= ItemGetPosition(lastSlice)
//			print("ItemGetPosition(lastSlice).z =" + lastSlicePos.z)

			local sliceCol = SceneDuplicateItem(scene, lastSlice)
//			local sliceCol = SceneDuplicateItem(scene, tunnelSliceCol)
			local sliceMesh = SceneDuplicateItem(scene,tunnelSliceMesh)
			ItemSetParent(sliceMesh, sliceCol)
			ItemSetScript(sliceCol, "Script/tunnelCol.nut", "tunnelCol")
			ItemSetupScript(sliceCol)
			ItemRenderSetup(sliceCol, g_factory)
			ItemRenderSetup(sliceMesh, g_factory)
			SceneSetupItem(scene, sliceCol)
			SceneSetupItem(scene, sliceMesh)

			ItemSetPosition(sliceMesh, Vector(0,0,500))

			local mm 			= ItemGetMinMax(sliceMesh)

			print("A.ItemGetPosition(sliceCol).z =" + ItemGetPosition(sliceCol).z + "mm.min=" + mm.min.z + "mm.max=" + mm.max.z)
			ItemPhysicResetTransformation(sliceCol, Vector(lastSlicePos.x, lastSlicePos.y, lastSlicePos.z + scale*(mm.max.z - mm.min.z)), Vector(0,0,0))
			print("B.ItemGetPosition(sliceCol).z =" + ItemGetPosition(sliceCol).z)

			foreach(id, slice in tunnelArray)
				print("Right before append->ID=" + id + "::" + ItemGetPosition(slice).z)
		
			tunnelArray.append(sliceCol)

//			foreach(id, slice in tunnelArray)
//				print("Right after append->ID=" + id + "::" + ItemGetPosition(slice).z)

		}

		return(tunnelArray)
	}


//	========================================================================================================
	function	CleanTunnel(scene, tunnelArray)
//	========================================================================================================
	{
		foreach(id, slice in tunnelArray)
		{
//			print("Before deletion->ID=" + id + "::" + ItemGetPosition(slice).z)
			if (ItemGetWorldPosition(slice).z < 0)
			{
				//delete mesh
				SceneDeleteItem(scene, ItemGetChild(slice,"TunnelDivisionSolid"))
				//delete colshapes
				SceneDeleteItem(scene, slice)
				tunnelArray.remove(id)
//				print("--->delete::" + id + "::" + ItemGetPosition(slice).z)
			}
		}
	}

//	========================================================================================================
	function	SpawnWall(refi, scene, nx, ny)
//	========================================================================================================
	{
		local refix = ItemGetMinMax(refi).max.x - ItemGetMinMax(refi).min.x
		local refiy = ItemGetMinMax(refi).max.y - ItemGetMinMax(refi).min.y
		local scale_ = ItemGetScale(refi)
		local startx = -(refix*nx*scale_.x)/2
		local starty = -(refiy*ny*scale_.y)/2

		for(local j=0;j<ny;j++)
			for(local i=0;i<nx;i++)
			{
				local cub_ = SceneDuplicateItem(scene, refi)
				ItemSetScript(cub_, "Script/cube2.nut" , "Cube2")
				ItemSetupScript(cub_)
				ItemRenderSetup(cub_, g_factory)
				SceneSetupItem(scene, cub_)

				wallPieces.append(cub_)

				ItemPhysicResetTransformation(cub_, Vector(startx+i*refix*scale_.x, starty+j*refiy*scale_.y, 4000.0), Vector(0,0,0))
			}
	}

//	========================================================================================================
	function	CleanWall(scene)
//	========================================================================================================
	{
		foreach(id, piece in wallPieces)
			if (ItemGetWorldPosition(piece).z < -100)
			{
				//delete item
				SceneDeleteItem(scene, piece)

				wallPieces.remove(id)
			}
	}




//	========================================================================================================
	function	PushPattern(scene, patternID, tableOfItems)
//	========================================================================================================
	{
		local pattern = []
		local obj = SceneAddObject(scene, "PatternGravityCenter" + patternID)
		ItemSetPosition(obj, Vector(0,0,spawnZ))

		foreach(id, loc in patlocs[patternID])
		{
			local dot = patfs[patternID][id]
   			if ( dot )
			{
				if ( dot == 1 )
					new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCube"))
				if ( dot == 2 )
					new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCubeRed"))

		 		ItemSetScript(new_item, "Script/cube.nut" , "Cube")
				ItemSetupScript(new_item)
				ItemRenderSetup(new_item, g_factory)
		 		SceneSetupItem(scene, new_item)
				ItemSetup(new_item)

				ItemSetPosition(new_item, loc)
//				ItemSetOpacity(new_item,0)
//				ItemPhysicResetTransformation(new_item, loc ,Vector(0,0,0))
//				ItemApplyLinearImpulse(new_item,Vector(0,0,-objVelocity))

				pattern.append(new_item)

				ItemSetParent(new_item, obj)
			}
		}

		//Add the parent object to the array of parents
		patobjs.append(obj)
		//Add the array of new items to the array of item arrays
		tableOfItems.append(pattern)

		return(tableOfItems)
	}


//	========================================================================================================
	function	PushAndRotatePattern(scene, patternID, tableOfItems, rotation)
//	========================================================================================================
	{
		local pattern = []
		local obj = SceneAddObject(scene, "PatternGravityCenter" + patternID)
		ItemSetPosition(obj, Vector(0,0,spawnZ))
		print("=== Z === " + ItemGetWorldPosition(obj).z)

		foreach(id, loc in patlocs[patternID])
		{
			local dot = patfs[patternID][id]
   			if ( dot )
			{
				if ( dot == 1 )
					new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCube"))
				if ( dot == 2 )
					new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCubeRed"))

		 		ItemSetScript(new_item, "Script/cube.nut" , "Cube")
				ItemSetupScript(new_item)
				ItemRenderSetup(new_item, g_factory)
		 		SceneSetupItem(scene, new_item)
				ItemSetup(new_item)

				ItemSetPosition(new_item, loc)

//				ItemPhysicResetTransformation(new_item, loc ,Vector(0,0,0))
//				ItemApplyLinearImpulse(new_item,Vector(0,0,-objVelocity))

				pattern.append(new_item)

				ItemSetParent(new_item, obj)
			}
		}

//		ItemSetPosition(ObjectGetItem(obj), Vector(0,0,1000))

		//Add the parent object to the array of parents
		patobjs.append(obj)
		//Add the array of new items to the array of item arrays
		tableOfItems.append(pattern)
/*
		//Create a geometry for the parent object
		local geo = GeometryTemplate()
		geo.pushMaterial("Mesh/red__SpaceshipUVMAP.nmm")
		geo.beginPolygon()
		geo.pushVertex(Vector(-10,10,-100))
		geo.pushVertex(Vector(10,10,-100))
		geo.pushVertex(Vector(10,-10,-100))
		geo.pushVertex(Vector(-10,-10,-100))
		geo.endPolygon(0)
//		instantiate(g_engine, "geoi")
		ObjectSetGeometry(obj, geo)
		ItemSetup(ObjectGetItem(obj))
*/		

		return(tableOfItems)
	}

//	========================================================================================================
	function	OnUpdate(scene)
//	========================================================================================================
	{
		ComputeLowDeltaFrameCompensation()

		local	keyboard 	= GetKeyboardDevice(),
				pad			= GetInputDevice("xinput0"),
				padlt 		= DeviceInputValue(pad, DeviceAxisLT)

		local posX = WindowGetPosition(lblGetReady[0]).x
		local posY = WindowGetPosition(lblGetReady[0]).y

		if (DeviceKeyPressed(pad, keyBack) || DeviceKeyPressed(keyboard, KeyEscape ))
			Pause(scene)

		CleanCity(scene)
		//Generate a slice of city

		if 	(!pause && (citigenCount >= (wait/(1+boost))))
		{
			local nb = Rand(4,12)
			wait = GenerateCity(scene, -1000, 1000, 900, 1000, nb, 1 0.07)
			citigenCount = 0
		} else
			citigenCount++

		//compute boost
		local usePad
		if (!("usePad" in getroottable()))
			usePad = 1
		if ( (padlt > 0.0) || (usePad&&DeviceIsKeyDown(keyboard, KeySpace)) )
			{
				boostON = 1
				GotAchievement(scene, "boost")
			}
		else
			boostON = 0

		//visual feedback of boost
		if (boostON)
			if (padlt > 0.0)
				{ boost = padlt*30; WindowSetOpacity(boostWindow[0],1); TextSetText(boostWindow[1], "BOOST X"+abs(padlt*10)) }
			else
				{ boost += 0.1; WindowSetOpacity(boostWindow[0],1) }
		else
			{ boost += -0.6; WindowSetOpacity(boostWindow[0],0) }
		boost = Clamp(boost,0,objVelocity)

		if (posX < 200)
			WindowSetPosition(lblGetReady[0],posX+50*g_dt_frame*60,posY)
		if ((posX >= 200) && (posX < 300))
				WindowSetPosition(lblGetReady[0],posX+2*g_dt_frame*60,posY)
		if ((posX >= 300) && (posX < 2000))
			{
				WindowSetPosition(lblGetReady[0],posX+100*g_dt_frame*60,posY)
				phase = 1
				// Stores Clock
				patTimer = g_clock
			}

		if (phase == 1)
		{
			//erases targets
			if (targetList.len() != 0)
				foreach(id,target in targetList)
				{
					UIDeleteWindow(SceneGetUI(scene), target)
					targetList.remove(id)
				}

			// Pattern generation
			if (TickToSec(g_clock-patTimer) >= patWait )
				switch(seq)
				{
					case 1: enemiesT1 = PushAndRotatePattern(scene, 0, enemiesT1, 0.005); seq = 2; patTimer = g_clock; break;
					case 2: enemiesT1 = PushAndRotatePattern(scene, 1, enemiesT1, -0.005); seq = 3; patTimer = g_clock; break;
					case 3: enemiesT1 = PushAndRotatePattern(scene, 2, enemiesT1, 0.005); seq = 4; patTimer = g_clock; break;
					case 4: enemiesT1 = PushAndRotatePattern(scene, 3, enemiesT1, -0.005); seq = 5; patTimer = g_clock; break;
					case 5: enemiesT1 = PushAndRotatePattern(scene, 4, enemiesT1, 0.0); seq = 6; patTimer = g_clock; break;
					case 6: enemiesT1 = PushPattern(scene, 5, enemiesT1); seq = 7; patTimer = g_clock; break;
					case 7: enemiesT1 = PushAndRotatePattern(scene, 6, enemiesT1, 0.005); seq = 8; patTimer = g_clock; break;
					case 8: enemiesT1 = PushAndRotatePattern(scene, 0, enemiesT1, -0.005); seq = 1; patTimer = g_clock; break;
				}


			//Rotate the pattents via the parent object
			foreach(idx,obj in patobjs)
			{
//				local oi = ObjectGetItem(obj)
				local r = ItemGetRotation(obj)
				local p = ItemGetWorldPosition(obj)

				print("IDX=" + idx + "::Z=" + ItemGetWorldPosition(obj).z)

				local cpos = ItemGetWorldPosition(SceneGetCurrentCamera(scene))

				local rot = 0.02
				switch(idx)
				{
					case 2: rot = -rot
					case 3: rot = rot*1.5
					case 4: rot = -rot
					case 6: rot = -rot
				}

				local timer = TickToSec(g_clock-SyncTimer)
				if ((timer >= SyncWait - 0.5) && (timer < (SyncWait)))
				{
					ItemSetRotation(obj, Vector(r.x,r.y,r.z-rot/2*g_dt_frame*60))
					ItemSetPosition(obj, Vector(p.x,p.y,p.z+1*g_dt_frame*60))
				}
				else
				{
					ItemSetRotation(obj, Vector(r.x,r.y,r.z+rot*g_dt_frame*60))
					ItemSetPosition(obj, Vector(p.x,p.y,p.z-8*g_dt_frame*60))
				}
				if (timer >= SyncWait+0.5)
					SyncTimer = g_clock


				//delete object and all his children if behind camera
				local r = ItemGetRotation(obj)
				local p = ItemGetWorldPosition(obj)

				if (p.z < -50)
//				if (p.z < ItemGetWorldPosition(SceneGetCurrentCamera(scene)).z)	
				{
					print("IDX=" + idx + "::Z=" + ItemGetWorldPosition(obj).z)

					local children = ItemGetChildList(obj)
					foreach(ic, child in children)
					{
						print("--->Child " + ic + "::Z=" + ItemGetWorldPosition(child).z)
						SceneDeleteItem(scene, child)
					}

					SceneDeleteObject(scene,obj)
					patobjs.remove(idx)

					local itemArray = enemiesT1[idx]
					itemArray.clear()
					enemiesT1.remove(idx)
				}


			}


			//Code for individual block and collision detection
			foreach(idx1,enemyGrp in enemiesT1)
				foreach(idx2,enemy in enemyGrp)
				{
/*					local position = ItemGetWorldPosition(enemy)
					print(position.x + "-" + position.y + "-" + position.z)
*/
/*				if ((ItemHasScript(enemy, "Cube") && ItemGetScriptInstance(enemy).captured))
					{
						ItemSetLinearVelocity(enemy, Vector(0,0,0))
						local scpos = ItemGetPosition(SceneFindItem(scene,"Spacecraft"))
						ItemPhysicResetTransformation(enemy, Vector(scpos.x, scpos.y-10, scpos.z), Vector(0,0,0))
					}
				else*/
/*				if (ItemHasScript(enemy, "Cube") && !ItemGetScriptInstance(enemy).captured)
					ItemSetLinearVelocity(enemy, Vector(v.x,v.y,v.z-boost))
				else // if the cube is a bullet, delete from the table
					enemiesT1.remove(idx)
*/

   					local wp = ItemGetWorldPosition(enemy)
   					local ri = ItemGetRotation(enemy)
					local r = ItemGetOpacity(enemy)
					local opa = Clamp(wp.z/spawnZ,0,1)+0.1
//					ItemSetOpacity(enemy, r+0.01)
		                                                                                                                                                                                                                                             			ItemSetOpacity(enemy, r+0.001)

/*					local timer = TickToSec(g_clock-SyncTimer)
					if ((timer >= SyncWait - 0.5) && (timer < (SyncWait)))
					{
//						ItemSetPosition(enemy, Vector(wp.x,wp.y,wp.z + g_dt_frame*60))
//						ItemSetRotation(enemy, Vector(ri.x,ri.y,ri.z+rp.z))
						local s = ItemGetScale(enemy)
//						ItemSetScale(enemy,s*0.99)
					}
					else
					{
//						ItemApplyLinearImpulse(enemy,Vector(0,0,-objVelocity))
//						ItemSetLinearVelocity(enemy,Vector(0,0,-objVelocity))

//						ItemSetPosition(enemy, Vector(wp.x,wp.y,wp.z - 10*g_dt_frame*60))
//						ItemSetRotation(enemy, Vector(ri.x,ri.y,ri.z+rp.z))
//						ItemSetScale(enemy,Vector(6,6,6))
					}

					if (timer >= SyncWait+0.5)
						SyncTimer = g_clock
*/

					//if enemy is dead
//					if (ItemGetLinearVelocity(enemy).z == 0 )
					if (ItemGetScriptInstance(enemy).hit)
					{
						local _snd  = ResourceFactoryLoadSound(g_factory, snd_fx_wall)
						MixerSoundStart(g_mixer, _snd)
						gScore += 50
						ItemGetScriptInstance(enemy).hit = 0
					}

					if (ItemGetScriptInstance(enemy).dead)
					{
						local _snd  = ResourceFactoryLoadSound(g_factory, snd_fx_dead)
						MixerSoundStart(g_mixer, _snd)

						enemyGrp.remove(idx)
						SceneDeleteItem(scene,enemy)
						destroyed++

						gScore += 100
					}

					local position = ItemGetWorldPosition(enemy)
/*
					if ( (position.z < -200) || (position.z > 5000 ) )	
					{
						enemyGrp.remove(idx2)
						SceneDeleteItem(scene,enemy)
					}

					if (enemyGrp.len()==0)
						enemiesT1.remove(idx1)
*/
					// raytrace collisions
//					local col =	SceneCollisionRaytrace(ItemGetScene(enemy),position,Vector(0,0,-1),-1,CollisionTraceAll,Mtr(700))
					local col =	SceneCollisionRaytrace(g_scene,position,Vector(0,0,-1),-1,CollisionTraceAll,Mtr(700))
//					if ((col.hit) && ((ItemGetName(col.item) == "Spacecraft") || (ItemGetName(col.item) == "ForceFieldCol")))
					if ((col.hit) && (ItemGetName(col.item) == "Spacecraft"))
					{
						//Set the item as being in the ship's trajectory
						ItemGetScriptInstanceFromClass(enemy, "Cube").willHit = 1
					
						// projects in a normalized screen space (0,1)
//						local pos2d = CameraWorldToScreen(SceneGetCurrentCamera(ItemGetScene(enemy)),position)
						local pos2d = CameraWorldToScreen(SceneGetCurrentCamera(g_scene), g_render, position)

/*						local warning_sprite = "Tex/Warning_" + ItemGetName(col.item) + ".png"
						local targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)
						if(col.d < Mtr(700.0))
							targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)
						if(col.d < Mtr(150.0))
								targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)		

						local targetSprite = CreateSprite(SceneGetUI(g_scene),warning_sprite,pos2d.x*UIWidth-TextureGetWidth(targetTex)/2,pos2d.y*UIHeight-TextureGetHeight(targetTex)/2,1)
						SpriteSetOpacity(targetSprite, 1)
						targetList.append(targetSprite)
*/
						//Play warning sound
/*						if (TickToSec(g_clock-timer) >= 1)
						{	
							local warning  = ResourceFactoryLoadSound(g_factory, "data/warning.wav")
							local chan     = MixerSoundStart(g_mixer, warning)
							timer = g_clock
						}
*/
					}
					else
						ItemGetScriptInstanceFromClass(enemy, "Cube").willHit = 0
				} //End foreach(idx,enemy in enemyGrp)
		}

		//game over
		if (gLifes == 0)
			{
				game_over = 1				
				SpriteSetOpacity(lblGameOver[0],1)
				SpriteSetOpacity(lblRetry[0],1)
			}
		else
			if (!pause)
				{
					//update score
					if (TickToSec(g_clock-scorTimer) >= 0.01)
					{
						gScore += 1+boost*2
						gScore = abs(gScore)
						TextSetText(scoreWindow[1], gScore.tostring())
						scorTimer = g_clock
					}
				}

		//Lifes : 1 up every scoreCounter points
		if (gScore >= oneupScore*scoreCounter)
			{
				scoreCounter++
				if (gLifes < gLifesMax)
					{
						gLifes++
						WindowSetPosition(oneupWindow[0], 200, 350)
						WindowSetOpacity(oneupWindow[0], 1)
						local newy = WindowGetPosition(oneupWindow[0]).y - 200
						WindowSetCommandList(oneupWindow[0] , "loop; toalpha 1,0.0+toposition 1," + WindowGetPosition(oneupWindow[0]).x.tostring() + "," + newy + "; next;")
						UpdateLifes(gLifes)
						local oneup  = ResourceFactoryLoadSound(g_factory, "data/oneup.wav")
						MixerSoundStart(g_mixer, oneup)
					}
			}


		//energy 
		WindowSetSize(energyBar,gFFenergy/4,20)
		if (gFFenergy <= 1)
			{
				local loene  = ResourceFactoryLoadSound(g_factory, "data/noenergy.wav")
				MixerSoundStart(g_mixer, loene)
			}
			
		//display help
		helpCounter++
		if ( DeviceIsKeyDown(keyboard, KeyF1) || DeviceIsKeyDown(pad, KeyButton2) )
			{
				if (opa > 0)
					opa+=-0.02
				else
					opa=1
				WindowSetOpacity(helpLabel[0], opa)
			}
		else
			SpriteSetOpacity(helpLabel[0],0)

		if ((helpCounter > 550) && (helpCounter < 1000))
			{
				if (opa > 0)
					opa+=-0.02
				else
					opa=1
				SpriteSetOpacity(helpLabel2[0], opa)
			}
		else
			SpriteSetOpacity(helpLabel2[0],0)



//Debug
		if (debug)
		{
//			TextSetText(lblDbgEnemies[1], "patterns : " + enemiesT1.len().tostring())
			TextSetText(lblDbgTargetList[1], "targets : " + targetList.len().tostring())
			TextSetText(lblDbgBiru[1], "buildings : " + biruArray.len().tostring())
			TextSetText(lblDbgSlice[1], "tunnel : " + arrTunnel.len().tostring())
			TextSetText(lblDestr[1], "destroyed : " + destroyed.tostring())
		}
	}



	function	OnRenderUser(scene)
	{
		// Reset all rendering matrices to identity (no transformation).
		RendererSetAllMatricesToIdentity(g_render)

		foreach(i, obj in patobjs)
		{
			local mm = ItemGetMinMax(obj)
//			print(mm.min.x)
		}


//		RendererSetIdentityWorldMatrix(g_render)
//		RendererSetIdentityProjectionMatrix(g_render)
//		RendererSetIdentityViewMatrix(g_render)

		if (debug)
		{
			RendererWrite(g_render, debugFont, "clock = " + g_clock, 1, 0, 0.5, true, WriterAlignRight, Vector(1, 1, 1, 1))
			RendererWrite(g_render, debugFont, "SyncTimer = " + TickToSec(g_clock-SyncTimer), 1, 0.04, 0.5, true, WriterAlignRight, Vector(1, 1, 1, 1))
			RendererWrite(g_render, debugFont, "FPS=" + 1/g_dt_frame , 1, 0.08, 0.5, true, WriterAlignRight, Vector(1, 1, 1, 1))
		}
//		RendererDrawLine(g_render,ItemGetPosition(SceneFindItem(scene,"BeveledCube")), Vector(0,0,0) )
	}


//	========================================================================================================
	function	OnSetup(scene)
//	========================================================================================================
	{
		//Unpause for the pad
		pause = false

		enemiesT1  = []
		targetList = []

		wallTimer		= [g_clock,g_clock]
		wallFreq		= [10,15]
		wallPieces		= []

		scorTimer		= g_clock
		scoreWindow		= 0

		//Generates the city
		wait = GenerateCity(scene,-1000,1000,0,1000,10,5,0.1)

		// Load UI fonts.
		ui = SceneGetUI(scene)
		UISetInternalResolution(ui, UIWidth, UIHeight)

		ProjectLoadUIFont(g_project, "ui/electr.ttf")
		ProjectLoadUIFont(g_project, "ui/ozdaacadital.ttf")
		ProjectLoadUIFont(g_project, "ui/atomic.ttf")

//		local BGsprite = CreateSprite(ui,"ui/overlay.png",0,0,1)

		helpLabel = CreateLabel(ui, "Up,Down,Left,Right,X/V(Roll),C(Shield),R(Restart),F1(Help)", 400, 700, 24, 900, 96,255,255,255,200,"electr",TextAlignCenter)
		helpLabel2 = CreateLabel(ui, "STAY ALIVE ! ", 500, 800, 40, 900, 96,255,255,255,255,"electr",TextAlignCenter)
		SpriteSetOpacity(helpLabel[0],0)
		SpriteSetOpacity(helpLabel2[0],0)

		CreateLabel(ui, "LIFE", 50, 40, 24, 120, 96,255,255,255,255,"electr",TextAlignRight)
		CreateLabel(ui, "ENERGY", 50, 80, 24, 120, 96,255,255,255,255,"electr",TextAlignRight)
		CreateLabel(ui, "SCORE", 50, 0, 24, 120, 96,255,255,255,255,"electr",TextAlignRight)

		scoreWindow 	= CreateLabel(ui, gScore.tostring(), 200, 40, 24, 120, 96,255,255,255,255,"electr",TextAlignLeft)
		boostWindow 	= CreateLabel(ui, "BOOST", 850, 120, 40, 300, 40,50,195,255,255,"ozdaacadital",TextAlignLeft)
		oneupWindow 	= CreateLabel(ui, "1 UP !!", 200, 350, 50, 300, 40,255,84,0,255,"ozdaacadital",TextAlignCenter)
		WindowSetOpacity(boostWindow[0],0)
		WindowSetOpacity(oneupWindow[0],0)

		local fullBarTex	= ResourceFactoryLoadTexture(g_factory, "Tex/nrgBarFull.png")
		local fillBarTex	= ResourceFactoryLoadTexture(g_factory, "Tex/nrgBarFill.png")

		local energyBarFull		= UIAddSprite(ui, g_ui_IDs++, fullBarTex, 200, 115, 250, 20)
			  energyBar			= UIAddSprite(ui, g_ui_IDs++, fillBarTex, 200, 115, 250, 20)
		local lifeBarFull		= UIAddSprite(ui, g_ui_IDs++, fullBarTex, 200, 75, 250, 20)
			  lifeBar			= UIAddSprite(ui, g_ui_IDs++, fillBarTex, 200, 75, 250, 20)

		lblGameOver = CreateLabel(ui, "GAME OVER !", 450, 250, 70, 900, 500,0,0,0,255,"electr",TextAlignCenter)
		lblRetry 	= CreateLabel(ui, "[R]etry or [Esc]ape", 450, 400, 50, 900, 500,255,148,0,255,"electr",TextAlignCenter)
		lblPause 	= CreateLabel(ui, "PAUSE", 450, 200, 70, 900, 500,0,0,0,255,"electr",TextAlignCenter)
		lblGetReady = CreateLabel(ui, "Get Ready !", -2000, 500, 150, 1500, 500,50,195,255,255,"electr",TextAlignCenter)

		//Debug
		if ("debug" in getroottable())
			if (debug)
			{
				lblDbgEnemies = CreateLabel(ui, "enemies : " + enemiesT1.len().tostring(), 150, 200, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgTargetList = CreateLabel(ui, "targets : " + targetList.len().tostring(), 150, 220, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgBiru = CreateLabel(ui, "buildings : " +  biruArray.len().tostring(), 150, 240, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgSlice = CreateLabel(ui, "Tunnel : " +  arrTunnel.len().tostring(), 150, 260, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)

				// Load raster font for debug
				debugFont = LoadRasterFont(g_factory, "@core/fonts/profiler_base.nml", "@core/fonts/profiler_base")
//				debugFont = LoadRasterFont(g_factory, "@core/fonts/under.nml", "@core/fonts/under")
//				debugFont = LoadRasterFont(g_factory, "@core/fonts/fps.nml", "@core/fonts/fps")

			}

		lblDestr	= CreateLabel(ui, "Destroyed : " +  destroyed.tostring(), 150, 280, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)

		SpriteSetOpacity(lblGameOver[0],0)
		SpriteSetOpacity(lblRetry[0],0)
		SpriteSetOpacity(lblPause[0],0)



/*		local tex		= EngineLoadTexture(g_engine, "Tex/rocket_leaving_earth.png")
		local story1	= UIAddNamedSprite(ui, "spr", tex, -5000, 650, TextureGetWidth(tex), TextureGetHeight(tex))
		WindowSetCommandList(story1, "toposition 2,-5000,650; toposition 2,0,650; toposition 3,0,650; toposition 1,-5000,5000;")
		local tex		= EngineLoadTexture(g_engine, "Tex/pilot.png")
		local story2	= UIAddNamedSprite(ui, "spr", tex, 3000, 0, TextureGetWidth(tex), TextureGetHeight(tex))
		WindowSetCommandList(story2, "toposition 5,3000,650; toposition 2,900,650; toposition 5,900,650; toposition 1,3000,650;")
		local tex		= EngineLoadTexture(g_engine, "Tex/pilots.png")
		local story1	= UIAddNamedSprite(ui, "spr", tex, -5000, 650, TextureGetWidth(tex), TextureGetHeight(tex))
		WindowSetCommandList(story1, "toposition 10,-5000,650; toposition 2,0,650; toposition 3,0,650; toposition 1,-5000,5000;")
		local tex		= EngineLoadTexture(g_engine, "Tex/ladycrew.png")
		local story2	= UIAddNamedSprite(ui, "spr", tex, 3000, 0, TextureGetWidth(tex), TextureGetHeight(tex))
		WindowSetCommandList(story2, "toposition 15,3000,650; toposition 2,900,650; toposition 5,900,650; toposition 1,3000,650;")
*/

		//prevents objets from falling down
		SceneSetGravity(scene, Vector(0,0,0))
		SceneSetPhysicFrequency(scene, 75.0)
/*		channel_music = MixerStreamStart(g_mixer,"data/emergency.ogg")
		MixerChannelSetGain(g_mixer, channel_music, 0.8)
		if (MixerChannelGetState(g_mixer, channel_music) != 2)
			{
			}
*/

		//Set camera
//		SceneSetCurrentCamera(scene, ItemCastToCamera(SceneFindItem(scene,"GameCam")))

		//Generate tunnel
/*		tunnelSliceCol = SceneFindItem(scene,"tunnelCol")
		tunnelSliceMesh = SceneFindItem(scene,"TunnelDivisionSolid")

		local sliceCol = SceneDuplicateItem(scene, tunnelSliceCol)
		local sliceMesh = SceneDuplicateItem(scene,tunnelSliceMesh)
		ItemSetParent(sliceMesh, sliceCol)
		ItemSetPosition(sliceCol, Vector(0,0,200))
		ItemSetScript(sliceCol, "Script/tunnelCol.nut", "tunnelCol")
		ItemSetupScript(sliceCol)
		ItemRenderSetup(sliceCol, g_factory)
		ItemRenderSetup(sliceMesh, g_factory)
		arrTunnel.append(sliceCol)
		tunnelScale = ItemGetScale(sliceMesh).x

		foreach(id, slice in arrTunnel)
			print("OnSetup->ID=" + id + "::" + ItemGetPosition(slice).z)

		for(local i=0;i<10;i++)
			arrTunnel = GenerateTunnelSlice(scene, arrTunnel, 30)

*/


		//Load pattern file
		local pattern1 = [], pattern2 = [], pattern3 = [],pattern4 = [],pattern5 = [],pattern6 = [],pattern7 = []
		patfs=[pattern1,pattern2,pattern3,pattern4,pattern5,pattern6,pattern7]
		local patfn=["pattern1","pattern2","pattern3","pattern4","pattern5","pattern6","pattern7"]
		foreach(i,patf in patfs)
		{
			local p = LoadPicture("Sav/" + patfn[i] + ".png")
			local w = PictureGetRect(p).GetWidth()
			local h = PictureGetRect(p).GetHeight()
			for(local i=0; i<w; i++)
				for(local j=0; j<h; j++)
				{
					local pixel = PictureGetPixel(p,i,j)
//					local test = pixel.IsEqual(Vector(0,0,0,1),0.0)
					if (pixel.x+pixel.y+pixel.z == 0)
						patf.append(0)
					if (pixel.x+pixel.y+pixel.z+pixel.w == 4)
						patf.append(1)
					if (pixel.x+pixel.y+pixel.z == 1)
						patf.append(2)
				}
		}

		// Init location grida
//		gridCellSize = ItemGetMinMax(SceneFindItem(scene, "BeveledCube")).max.x - ItemGetMinMax(SceneFindItem(scene, "BeveledCube")).min.x
		local gridCellSize = 12

		foreach(id,pattern in patfs)
		{
			local maxCells = pattern.len()
			local gridDensity = sqrt(maxCells)
			local gridHalfCellSize = gridCellSize/2
			local offset = (gridDensity*gridCellSize)/2 - gridCellSize/2

			local gridArLoc = [] //Initialize the location array of this pattern
			for(local i=maxCells-1;i>=0;i--)
//			for(local i=0;i<maxCells;i++)
			{
				local x = - floor(i/gridDensity)*gridCellSize + offset
				local y = Mod(i,gridDensity)*gridCellSize - offset
				gridArLoc.append(Vector(x,y,spawnZ))
	//			print(x + "," + y)
			}
			
			//Append this location array to the array of locations
			patlocs.append(gridArLoc)
/*
			local filt_arloc = gridArLoc
			foreach(idx, val in filt_arloc)
				if (patfs[id][idx] == 0)
					filt_arloc.remove(idx)

			local a,b,c,d
			a = filt_arloc[0].x
			b = filt_arloc[0].x
			c = filt_arloc[0].y
			d = filt_arloc[0].y
			foreach(idx, loc in filt_arloc)
			{
				if (idx>=1)
				{
					if (loc.x < a)	a = loc.x
					if (loc.x > b)	b = loc.x
					if (loc.y < c)	c = loc.y
					if (loc.y > d)	d = loc.y
				}
			}
	*/		
//			gridArLoc.sort(compare)
			
//			gridArLoc.filter(filter(i,val ))
			
			
//			print(a)
		}


	
		local mf = MetafileNew()
//		try(MetafileLoad(mf, "@app/patterns.txt")) catch(e) {throw(e)}
/*		SystemMountLocalPath("H:/wrk/GS/schmup1/schmup/Sav/", "@Sav/")
		print(SystemHasMountPoint("@Sav/"))
		if (MetafileLoad(mf, "@Sav/save.nml"))
		{
			local tag = MetafileGetTag(mf, "save;")

			if	(ObjectIsValid(tag))
				local tab = deserializeObjectFromMetatag(tag)
			print(tab)
		} 
*/
//		SceneSetFog(g_scene, true, Vector(0.5, 0.7, 0.9), Mtr(200), Mtr(1000))

	}
}