 /*
	File: Script/Level1.nut
	Author: DG
*/

Include("Script/gui.nut")
Include("Script/globals.nut")

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
enemiesT1		<- 0
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
//=== sequence::torus ===
	torusInterval	= 0.1
	torusTimer		= g_clock
	torusArray		= []
	torusCounter	= 0
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

	torus 			= 0
//=== walls ===
	wallTimer		= 0
	wallFreq		= 0
	wallPieces		= 0

//=== grid ====
	gridDensity		= 4
	gridCellSize	= 0
	gridArLoc		= [] //Array of locations )size = gridDendity*gridDensity
	gridArPat1		= []
	objVelocity		= 100
	pattern1		= [1,1,0,1,1,1,1,1,1,1,1,1,1,0,1,1]

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
	function	OnPhysicStep(scene, taken)
//	========================================================================================================
	{
//		CleanWall(scene)
/*
		if (TickToSec(g_clock-wallTimer[0]) >= wallFreq[0])
			{
				SpawnWall(SceneFindItem(scene, "wallPiece1"), scene, 12,8)
				wallTimer[0] = g_clock
			}

		if (TickToSec(g_clock-wallTimer[1]) >= wallFreq[1])
			{
				SpawnWall(SceneFindItem(scene, "wallPiece2"), scene, 12,8)
				wallTimer[1] = g_clock
			}
*/
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
			local nb = Rand(4,10)
			wait = GenerateCity(scene, -1000, 1000, 900, 1000, nb, 1, 0.1)
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

		if (posX < 0)
			WindowSetPosition(lblGetReady[0],posX+50*g_dt_frame*60,posY)
		if ((posX >= 0) && (posX < 300))
				WindowSetPosition(lblGetReady[0],posX+1.5*g_dt_frame*60,posY)
		if ((posX >= 300) && (posX < 2000))
			{
				WindowSetPosition(lblGetReady[0],posX+100*g_dt_frame*60,posY)
				phase = 1
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

/* debug			foreach(id,torus in torusArray)
				print(ItemGetPosition(torus).x + "::" + ItemGetPosition(torus).y + "::" + ItemGetPosition(torus).z)
*/
			//clean up torus array
/*			foreach(id,torus in torusArray)
				if (ItemGetPosition(torus).z < 0)
					{
						SceneDeleteItem(scene, torus)
						torusArray.remove(id)
					}

			local xoffset = sin(torusCounter)*Rand(50,60)*Rand(-1,1)
			local yoffset = sin(torusCounter)*Rand(50,60)*Rand(-1,1)
*/
			//Extend tunnel
/*			if (arrTunnel.len() < maxTunnelSlice )
				arrTunnel = GenerateTunnelSlice(scene, arrTunnel, tunnelScale )*/
			//Clean up tunnel sections which are behind the player
/*			CleanTunnel(scene,arrTunnel)*/


/*
			//spawn torus
			if (TickToSec(g_clock-torusTimer) >= torusInterval )
			{
				torusInterval	= Rand(0.5,2)
				torusCounter++
//				local new_torus = SpawnItem(scene, base_item[4], Vector(Mtr(0+xoffset),Mtr(0+yoffset),Mtr(1000)), Vector(20,20,20),Vector(Deg(0),Deg(0),Deg(0)), Vector(0,0,-250-10*boost), Vector(0,0,0))
				local new_torus = SpawnItem(scene, torus, Vector(Mtr(0+xoffset),Mtr(0+yoffset),Mtr(1000)), Vector(20,20,20),Vector(Deg(0),Deg(0),Deg(0)), Vector(0,0,-250-10*boost), Vector(0,0,0))
				torusArray.append(new_torus)
				torusTimer = g_clock
			}
*/
			//spawn asteroid
			if ((TickToSec(g_clock-seqTimer) >= 1) && !rockON)
			{
				rockON = true
//				local new_rock = SpawnItem(scene, base_item[3], Vector(Mtr(0),Mtr(50),Mtr(1000)), Vector(3,3,3),Vector(Deg(-90),Deg(-90),Deg(180)), Vector(0,0,-300), Vector(Deg(Rand(0,2)),Deg(Rand(0,2)),Deg(Rand(0,2))))
			}

			//handles enemies
			foreach(idx,enemy in enemiesT1)
			{
				local v = ItemGetLinearVelocity(enemy)
/*				if ((ItemHasScript(enemy, "Cube") && ItemGetScriptInstance(enemy).captured))
					{
						ItemSetLinearVelocity(enemy, Vector(0,0,0))
						local scpos = ItemGetPosition(SceneFindItem(scene,"Spacecraft"))
						ItemPhysicResetTransformation(enemy, Vector(scpos.x, scpos.y-10, scpos.z), Vector(0,0,0))
					}
				else*/
				if (ItemHasScript(enemy, "Cube") && !ItemGetScriptInstance(enemy).captured)
					ItemSetLinearVelocity(enemy, Vector(v.x,v.y,v.z-boost))
				else // if the cube is a bullet, delete from the table
					enemiesT1.remove(idx)

				//if enemy is dead
//				if (ItemGetLinearVelocity(enemy).z == 0 )
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

						enemiesT1.remove(idx)
						SceneDeleteItem(scene,enemy)
						destroyed++

						gScore += 100
					}


//				if ( (ItemGetPosition(enemy).z < ItemGetPosition(CameraGetItem(SceneGetCurrentCamera(scene))).z-20) || (ItemGetPosition(enemy).z > 1300 ) )

				if ( (ItemGetPosition(enemy).z < -50) || (ItemGetPosition(enemy).z > 1300 ) )
				{
					enemiesT1.remove(idx)
					SceneDeleteItem(scene,enemy)
				}

				local position = ItemGetPosition(enemy)
				// raytrace collisions
//				local col =	SceneCollisionRaytrace(ItemGetScene(enemy),position,Vector(0,0,-1),-1,CollisionTraceAll,Mtr(700))
				local col =	SceneCollisionRaytrace(g_scene,position,Vector(0,0,-1),-1,CollisionTraceAll,Mtr(700))
				if ((col.hit) && ((ItemGetName(col.item) == "Spacecraft") || (ItemGetName(col.item) == "ForceFieldCol")))
					{
						local warning_sprite = "Tex/Warning_" + ItemGetName(col.item) + ".png"
						// projects in a normalized screen space (0,1)
//						local pos2d = CameraWorldToScreen(SceneGetCurrentCamera(ItemGetScene(enemy)),position)
						local pos2d = CameraWorldToScreen(SceneGetCurrentCamera(g_scene), g_render, position)
						local targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)
						if(col.d < Mtr(700.0))
							targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)
						if(col.d < Mtr(150.0))
								targetTex = ResourceFactoryLoadTexture(g_factory, warning_sprite)

//						local targetSprite = UIAddNamedSprite(SceneGetUI(g_scene), "spr", targetTex, pos2d.x*1280-TextureGetWidth(targetTex)/2, pos2d.y*960-TextureGetHeight(targetTex)/2, TextureGetWidth(targetTex), TextureGetHeight(targetTex))
						local targetSprite = CreateSprite(SceneGetUI(g_scene),warning_sprite,pos2d.x*UIWidth-TextureGetWidth(targetTex)/2,pos2d.y*UIHeight-TextureGetHeight(targetTex)/2,1)
						SpriteSetOpacity(targetSprite, 1)
						targetList.append(targetSprite)
						//Play warning sound
						if (TickToSec(g_clock-timer) >= 1)
						{	
							local warning  = ResourceFactoryLoadSound(g_factory, "data/warning.wav")
							local chan     = MixerSoundStart(g_mixer, warning)
							timer = g_clock
						}
					}
			}
	
			//Generation of enemies
			if (enemiesT1.len() < max_ennemies)
			{
//				local choice = Rand(0,3).tointeger()
//				new_item = SceneDuplicateItem(scene, base_item[choice])


				foreach(id, loc in gridArLoc)
				{
					if ( pattern1[id] == 1 )
					{
						new_item = SceneDuplicateItem(scene, SceneFindItem(scene, "BeveledCube"))
	 			 		ItemSetScript(new_item, "Script/cube.nut" , "Cube")
						ItemSetupScript(new_item)
						ItemRenderSetup(new_item, g_factory)
				 		SceneSetupItem(scene, new_item)
						ItemSetup(new_item)

//						print("(" + loc.x + "," + loc.y + ")")

						ItemPhysicResetTransformation(new_item, loc ,Vector(Deg(-90),Deg(-90),Deg(180)))
//						ItemApplyLinearImpulse(new_item,Vector(0,0,Rand(-minVelocity,-minVelocity*3)))
						ItemApplyLinearImpulse(new_item,Vector(0,0,-objVelocity))

						enemiesT1.append(new_item)
					}
				}

/*
				if(choice == 1)
				{
					ItemPhysicResetTransformation(new_item,Vector(Mtr(Rand(-50,50)), -25, Mtr(-40)),Vector(Deg(-90),Deg(-90),Deg(0)))
					ItemApplyLinearImpulse(new_item,Vector(0,0,Rand(minVelocity/10,minVelocity/3)))
				}
				else*/
				{
//					ItemPhysicResetTransformation(new_item,Vector(Mtr(Rand(xoffset-40,xoffset+40)), Mtr(Rand(yoffset-40,yoffset+40)), Mtr(500)),Vector(Deg(-90),Deg(-90),Deg(180)))
//					ItemPhysicResetTransformation(new_item,Vector(Mtr(Rand(-100,100)), Mtr(Rand(-100,100)), Mtr(500)),Vector(Deg(-90),Deg(-90),Deg(180)))

//					ItemApplyLinearImpulse(new_item,Vector(0,0,Rand(-minVelocity,-minVelocity*3)))
				}


				//Add the new ennemy to the list
//				enemiesT1.append(new_item)
//			print(enemiesT1.len())
			}

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
//						TextSetText(scoreWindow[1], gScore.tostring())
//						scorTimer = g_clock
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
			TextSetText(lblDbgEnemies[1], "enemies : " + enemiesT1.len().tostring())
			TextSetText(lblDbgTargetList[1], "targets : " + targetList.len().tostring())
			TextSetText(lblDbgBiru[1], "buildings : " + biruArray.len().tostring())
			TextSetText(lblDbgSlice[1], "tunnel : " + arrTunnel.len().tostring())
			TextSetText(lblDestr[1], "destroyed : " + destroyed.tostring())
		}
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

		local BGsprite = CreateSprite(ui,"ui/overlay.png",0,0,1)

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

		lblGameOver = CreateLabel(ui, "GAME OVER !", 250, 250, 300, 900, 500,0,0,0,255,"atomic",TextAlignCenter)
		lblRetry 	= CreateLabel(ui, "[R]etry or [Esc]ape", 250, 400, 150, 900, 500,255,148,0,255,"atomic",TextAlignCenter)
		lblPause 	= CreateLabel(ui, "PAUSE", 200, 200, 200, 900, 500,68,45,44,255,"ozdaacadital",TextAlignCenter)
		lblGetReady = CreateLabel(ui, "Get Ready !", -2000, 500, 150, 1500, 500,0,0,0,255,"ozdaacadital",TextAlignCenter)

		//Debug
		if ("debug" in getroottable())
			if (debug)
			{
				lblDbgEnemies = CreateLabel(ui, "enemies : " + enemiesT1.len().tostring(), 150, 200, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgTargetList = CreateLabel(ui, "targets : " + targetList.len().tostring(), 150, 220, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgBiru = CreateLabel(ui, "buildings : " +  biruArray.len().tostring(), 150, 240, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
				lblDbgSlice = CreateLabel(ui, "Tunnel : " +  arrTunnel.len().tostring(), 150, 260, 12, 120, 50,0,0,0,255,"electr",TextAlignLeft)
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

/*		local objNmy 	= SceneAddObject(scene, "NMY")
		local objVehic 	= SceneAddObject(scene, "Vehic1")
		local objIcos 	= SceneAddObject(scene, "Icosphere")
		local objRock 	= SceneAddObject(scene, "Rock")

		local objEne 	= SceneAddObject(scene, "Ene")
		local geoNmy 	= EngineLoadGeometry(g_engine, "cube_Extrude/Cube.nmg")
		local geoNmy 	= EngineLoadGeometry(g_engine, "Mesh/beveled_cube_nmy.nmg")
		local geoNmy 	= EngineLoadGeometry(g_engine, "Mesh/beveled_cube.nmg")

		local geoEne 	= EngineLoadGeometry(g_engine, "Mesh/beveled_cube.nmg")
		local geoVehic	= EngineLoadGeometry(g_engine, "Mesh/Vehic1.nmg")
		local geoIcos 	= EngineLoadGeometry(g_engine, "icosphere/Icosphere.nmg")
		local geoRock 	= EngineLoadGeometry(g_engine, "Mesh/Cube.nmg")

		ObjectSetGeometry(objNmy, geoNmy)
		ObjectSetGeometry(objVehic, geoVehic)
		ObjectSetGeometry(objIcos, geoIcos)
		ObjectSetGeometry(objRock, geoRock)
		ObjectSetGeometry(objEne, geoEne)
*/
//		base_item = []
//		base_item.append(SceneFindItem(scene, "BeveledCube"))
//		beveled_cube = SceneFindItem(scene, "BeveledCube")
//		ItemSetScript(beveled_cube, "Script/cube.nut" , "Cube")
//		torus		 = ObjectGetItem(objEne)
//		base_item.append(ObjectGetItem(objNmy))
//		base_item.append(ObjectGetItem(objVehic))
//		base_item.append(ObjectGetItem(objIcos))
//		base_item.append(ObjectGetItem(objRock))
//		base_item.append(SceneDuplicateItem(scene, SceneFindItem(scene,"TunnelElement")))
//		base_item.append(ObjectGetItem(objEne))

//		ItemSetPosition(base_item[0], Vector(-5000,-5000,-5000))
//		ItemSetScript(base_item[0],"Script/cube.nut" , "Cube")
/*
		ItemSetPosition(base_item[1], Vector(-5000,-5000,-5000))
		ItemSetScript(base_item[1],"Script/cube.nut" , "Vehic1")

		ItemSetPosition(base_item[2], Vector(-5000,-5000,-5000))
		ItemSetScript(base_item[2],"Script/cube.nut" , "iso")

		ItemSetPosition(base_item[3], Vector(-5000,-5000,-5000))
		ItemSetScript(base_item[3],"Script/cube.nut" , "Rock")
*/
//		ItemSetPosition(base_item[4], Vector(-5000,-5000,-5000))
//		ItemSetScale(base_item[4], Vector(5,5,5))

//		ItemSetScript(base_item[4],"Script/TunnelElement.nut" , "TunnelElement")

/*		ItemSetPosition(base_item[5], Vector(-5000,-5000,-5000))
		ItemSetScale(base_item[5], Vector(1,1,1))
		ItemSetScript(base_item[5],"Script/cube.nut" , "Cube")
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

// Init grid and patterns

//		gridCellSize = ItemGetMinMax(SceneFindItem(scene, "BeveledCube")).max.x - ItemGetMinMax(SceneFindItem(scene, "BeveledCube")).min.x
		gridCellSize = 12
		local maxCells = gridDensity*gridDensity - 1
		local gridHalfCellSize = gridCellSize/2
		local offset = (gridDensity*gridCellSize)/2 - gridCellSize/2

		for(local i=0;i<maxCells;i++)
		{
			local x = floor(i/gridDensity)*gridCellSize - offset
			local y = Mod(i,gridDensity)*gridCellSize - offset
			gridArLoc.append(Vector(x,y,300))
		}

	}
}