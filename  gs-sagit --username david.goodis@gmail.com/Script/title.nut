/*
	File: scenes/title.nut
	Author: DG
*/

/*!
	@short	Scenes_Title
	@author	DG
*/


class	Scenes_Title
{
	ui			= 0
	Title		= 0
	bar			= 0
	cursorSprite = 0
	mouseNO		= 0
	mouseYES	= 0
	cursor      = 0
	useKeybLbl	= 0
	useMouseLbl	= 0
	usePadLbl	= 0
	keybSelec	= 0
	selectorSprite = 0

/*
	function	ActivateMouseYes(event, table)
	{
		print("MouseEnter!")
		WindowSetOpacity(mouseYES[0],1)
	}
*/

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	OnUpdate(scene)
	{
		local	mouse	= GetMouseDevice(), keyb = GetKeyboardDevice(),	pad = GetInputDevice("xinput0")
		local	old_mx = DeviceInputLastValue(mouse, DeviceAxisX),
				old_my = DeviceInputLastValue(mouse, DeviceAxisY)
		local	mx = DeviceInputValue(mouse, DeviceAxisX),
				my = DeviceInputValue(mouse, DeviceAxisY)
	
		local vp = RendererGetViewport(g_render)

		if (useMouse)
			TextSetColor(useMouseLbl[1],50,195,255,255)
		else
			TextSetColor(useMouseLbl[1],255,255,255,128)
		if (usePad)
			TextSetColor(usePadLbl[1],50,195,255,255)
		else
			TextSetColor(usePadLbl[1],255,255,255,128)

		local blip  = EngineLoadSound(g_engine, "data/select.wav")
		local buuu  = EngineLoadSound(g_engine, "data/dame.wav")
		local toing = EngineLoadSound(g_engine, "data/toing.wav")

		if ((DeviceKeyPressed(keyb,KeyRightArrow)) || (DeviceKeyPressed(pad, Right)) )
			if (keybSelec < 2)
				{ keybSelec++; MixerSoundStart(g_mixer, blip) }
		if ((DeviceKeyPressed(keyb,KeyLeftArrow)) || (DeviceKeyPressed(pad, Left)) )
			if (keybSelec > 0)
				{ keybSelec--; MixerSoundStart(g_mixer, blip) }

		switch(keybSelec)
		{
			case 0:
				WindowSetSize(selectorSprite,WindowGetSize(useKeybLbl[0]).x,WindowGetSize(selectorSprite).y)
				WindowSetPosition(selectorSprite,0,375)
				if ((DeviceKeyPressed(keyb, KeyEnter)) || (DeviceKeyPressed(pad, Abutton)) )
					MixerSoundStart(g_mixer, buuu)
				break
			case 1:
				if ((DeviceKeyPressed(keyb, KeyEnter)) || (DeviceKeyPressed(pad, Abutton)) )
					if (!useMouse)
						{ useMouse = 1; usePad = 0; MixerSoundStart(g_mixer, toing)}
					else
						useMouse = 0
				WindowSetSize(selectorSprite,WindowGetSize(useMouseLbl[0]).x,WindowGetSize(selectorSprite).y)
				WindowSetPosition(selectorSprite,200,375)
				break
			case 2:
				if ((DeviceKeyPressed(keyb, KeyEnter)) || (DeviceKeyPressed(pad, Abutton)) )
					if (!usePad)
						{ usePad = 1; useMouse = 0; MixerSoundStart(g_mixer, toing)}
					else
						usePad = 0
				else
					WindowSetSize(selectorSprite,WindowGetSize(usePadLbl[0]).x,WindowGetSize(selectorSprite).y)
					WindowSetPosition(selectorSprite,350,375)
				break
		}

	}

	function	OnDelete(scene)
	{
/*		ui = SceneGetUI(scene)
		UISetCommandList(ui, "globalfade 1,0.0")
*/
	}

	function	OnSetup(scene)
	{
		// Load UI fonts.
		ui = SceneGetUI(scene)
		UILoadFont("ui/DIMIS.TTF")
		UILoadFont("ui/Square.ttf")

//		cursor = UICreateCursor(0)

		local VSTex	= EngineLoadTexture(g_engine, "Tex/VirtualScreen.png")
//		local VS 	= UIAddSprite(ui, g_ui_IDs++, VSTex, 0, 0, TextureGetWidth(VSTex)+1, TextureGetHeight(VSTex))
//		WindowSetOpacity(VS, 1)

		local BGTex	= EngineLoadTexture(g_engine, "Tex/TitleBG.png")
		local bgWin =UIAddSprite(ui, g_ui_IDs++, BGTex, -700, 280, TextureGetWidth(BGTex), TextureGetHeight(BGTex))
		WindowSetScale(bgWin,100,1)
//		WindowSetZOrder(bgWin,-100)

		Title = CreateLabel(ui, "Sagittarius_A*", 0, 40, 170, 1300, 200,0,0,0,255,"DIMIS",TextAlignCenter)
//		WindowSetScale(Title[0],1,2)
		CreateLabel(ui, "Keyboard : Up, Down, Left, Right, X/V (Roll), C (Shield), R (Restart), F1 (Help)", 0, 255, 25, 1280, 96,255,255,255,255,"Square",TextAlignLeft)
		CreateLabel(ui, "Xbox Pad : Left stick (Direction), right stick/LB/RB (Roll), A (Shield), Start (Restart), X (Help)", 0, 285, 25, 1280, 96,255,255,255,255,"Square",TextAlignLeft)
		useKeybLbl  = CreateLabel(ui, "[Use Keyboard]", 0, 315, 25, 175, 96,50,195,255,255,"Square",TextAlignLeft)
		useMouseLbl = CreateLabel(ui, "[Use Mouse]", 200, 315, 25, 133, 96,255,255,255,128,"Square",TextAlignLeft)
		usePadLbl   = CreateLabel(ui, "[Use Pad]", 350, 315, 25, 105, 96,255,255,255,128,"Square",TextAlignLeft)
		local selectorTex	= EngineLoadTexture(g_engine, "ui/selector.png")
		selectorSprite		= UIAddSprite(ui, g_ui_IDs++, selectorTex, -500, -500, TextureGetWidth(selectorTex), TextureGetHeight(selectorTex))
		WindowSetCommandList(selectorSprite , "loop; toalpha 0.5,0.3; toalpha 0.5,1.0; next;")
 		local startLbl = CreateLabel(ui, "Press Space/Start now !", 0, 375, 25, 1280, 96,255,255,255,255,"Square",TextAlignLeft)
		WindowSetCommandList(startLbl[0] , "loop; toalpha 0.1,0.3; toalpha 0.1,1.0; next;")
		ItemSetCommandList(SceneFindItem(scene,"Ship"), "toalpha 0,0.7; loop; torotation 30,0,1080,0+toalpha 30,1; torotation 30,0,-1080,0+toalpha 30,0.5; next;")

		// Use mouse or not
/*		local cusrsorTex	= EngineLoadTexture(g_engine, "ui/cursor.png")
		cursorSprite	= UIAddSprite(ui, g_ui_IDs++, cusrsorTex, 640, 480, TextureGetWidth(cusrsorTex), TextureGetHeight(cusrsorTex))
*/
		SceneSetGravity(scene, Vector(0,0,0))
	}
}
