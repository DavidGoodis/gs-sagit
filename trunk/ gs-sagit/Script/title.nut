/*
	File: scenes/title.nut
	Author: DG
*/

/*!
	@short	Scenes_Title
	@author	DG
*/
Include("Script/gui.nut")
Include("Script/globals.nut")

useKeyb 		<- 1

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
	selectionWindows  = []
	selecColor =	Vector(255,82,225,255)

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
		local blip  = ResourceFactoryLoadSound(g_factory, "data/select.wav")
		local buuu  = ResourceFactoryLoadSound(g_factory, "data/dame.wav")
		local toing = ResourceFactoryLoadSound(g_factory, "data/toing.wav")

		if (useKeyb)
		{
			WindowSetBackgroundColor(selectionWindows[0][0], RGBAToHex(selecColor))
			TextSetColor(selectionWindows[0][1],0, 0, 0, 255)
		}
		else
		{
			WindowSetBackgroundColor(selectionWindows[0][0], RGBAToHex(Vector(255,0,0,0)))
			TextSetColor(selectionWindows[0][1],255, 225, 82, 255)
		}

		if (useMouse)
		{
			WindowSetBackgroundColor(selectionWindows[1][0], RGBAToHex(selecColor))
			TextSetColor(selectionWindows[1][1],0, 0, 0, 255)
		}
		else
		{
			WindowSetBackgroundColor(selectionWindows[1][0], RGBAToHex(Vector(255,0,0,0)))
			TextSetColor(selectionWindows[1][1],255, 225, 82, 255)
		}
		if (usePad)
		{
			WindowSetBackgroundColor(selectionWindows[2][0], RGBAToHex(selecColor))
			TextSetColor(selectionWindows[2][1],0, 0, 0, 255)
		}
		else
		{
			WindowSetBackgroundColor(selectionWindows[2][0], RGBAToHex(Vector(255,0,0,0)))
			TextSetColor(selectionWindows[2][1],255, 225, 82, 255)
		}

		//Reset selection highlight animation
		foreach(id, w in selectionWindows)
			if (id != keybSelec)
				if (WindowIsCommandListDone(w[0]))
					WindowResetCommandList(w[0])

		//Hightlight selection
		WindowSetBackgroundColor(selectionWindows[keybSelec][0], RGBAToHex(selecColor))
		TextSetColor(selectionWindows[keybSelec][1],0, 0, 0, 255)

		//Set selection highlight animation
		if (WindowIsCommandListDone(selectionWindows[keybSelec][0]))
		{
				WindowSetCommandList(selectionWindows[keybSelec][0] , "toalpha 0.5,0.5; toalpha 0.5,1.0;")
//				WindowSetCommandList(selectionWindows[keybSelec][0] , "toscale 0.2,1.0,0.0; toscale 0.2,1.0,1.0;")
//				WindowSetCommandList(selectionWindows[keybSelec][0] , "toscale 0.2,1.0,0.0+toalpha 0.5,0.5; toscale 0.2,1.0,1.0+toalpha 0.5,1.0;")
		}

		if ((DeviceKeyPressed(keyb,KeyRightArrow)) || (DeviceKeyPressed(pad, KeyRightArrow)) )
			if (keybSelec < 2)
				{ keybSelec++; MixerSoundStart(g_mixer, blip) }
		if ((DeviceKeyPressed(keyb,KeyLeftArrow)) || (DeviceKeyPressed(pad, KeyLeftArrow)) )
			if (keybSelec > 0)
				{ keybSelec--; MixerSoundStart(g_mixer, blip) }

		if ((DeviceKeyPressed(keyb, KeyEnter)) || (DeviceKeyPressed(pad, KeyButton0)) )
			switch(keybSelec)
			{
				case 0:
//					MixerSoundStart(g_mixer, buuu)
					if (!useKeyb)
						{ useKeyb = 1; MixerSoundStart(g_mixer, toing)}
					else
						useKeyb = 0
					break
				case 1:

					if (!useMouse)
						{ useMouse = 1; usePad = 0; MixerSoundStart(g_mixer, toing)}
					else
						useMouse = 0
					break
				case 2:

					if (!usePad)
						{ usePad = 1; useMouse = 0; MixerSoundStart(g_mixer, toing)}
					else
						usePad = 0
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

		UISetInternalResolution(ui, 1920, 1080)

		ProjectLoadUIFont(g_project, "ui/DIMIS.TTF")
		ProjectLoadUIFont(g_project, "ui/ONRAMP.ttf")
		ProjectLoadUIFont(g_project, "ui/blanch_caps.ttf")
		ProjectLoadUIFont(g_project, "ui/Aldrich.ttf")	


//		UILoadFont("ui/DIMIS.TTF")
//		UILoadFont("ui/blanch_caps.ttf")

//		cursor = UICreateCursor(0)

//		local BGTex	= ResourceFactoryLoadTexture(g_factory, "Tex/TitleBG.png")
//		local BGsprite =UIAddNamedSprite(ui, "BGTex", NullTexture, 0, 200, TextureGetWidth(BGTex), TextureGetHeight(BGTex))
//		local BGsprite = UIAddSprite(ui, -1, NullTexture, 0, 0, 300, 247)
//		SpriteRenderSetup(BGsprite, g_factory)
//		SpriteSetTexture(BGsprite, BGTex)

//		local BGsprite = CreateSprite(ui,"Tex/TitleBG.png",0,280,32)

		//Text backgorund block


		local bgWindow = UIAddNamedWindow(ui, "bg", 0, 280, UIWidth,200)
		WindowSetBackgroundColor(bgWindow, RGBAToHex(Vector(255,0,0,0)))
		WindowRenderSetup(bgWindow, g_factory)

		local selLblW = (UIWidth-60)/3
		selectionWindows.append(CreateLabelWithBgColor(ui, "KEYBOARD", 10, 380, 24, selLblW, 40, 255, 225, 82, 255, "Aldrich",TextAlignCenter,0, 0, 0, 255))
		selectionWindows.append(CreateLabelWithBgColor(ui, "MOUSE", 20+selLblW, 380, 24, selLblW, 40, 255, 225, 82, 255, "Aldrich",TextAlignCenter,0, 0, 0, 255))
		selectionWindows.append(CreateLabelWithBgColor(ui, "PAD", 30+selLblW*2, 380, 24, selLblW, 40, 255, 225, 82, 255, "Aldrich",TextAlignCenter,0, 0, 0, 255))

		
		Title = CreateLabel(ui, "NEW GAME", 20, 60, 120, 1920, 240,0,0,0,255,"Aldrich",TextAlignCenter)
//		WindowSetScale(Title[0],1,2)
		CreateLabel(ui, "Keyboard : Up, Down, Left, Right, X/V (Roll), C (Shield), R (Restart), F1 (Help)", 20, 260, 24, 1280, 96,255,255,255,255,"Aldrich",TextAlignLeft)
		CreateLabel(ui, "Xbox Pad : Left stick (Direction), right stick/LB/RB (Roll), A (Shield), Start (Restart), X (Help)", 20, 300, 24, 1280, 96,255,255,255,255,"Aldrich",TextAlignLeft)

//		selectorSprite		= UIAddNamedSprite(ui, "selectorSpr", selectorTex, 10, 10, TextureGetWidth(selectorTex), TextureGetHeight(selectorTex))

 		local startLbl = CreateLabel(ui, "Hit Space(keyb)/Start(controller)", 10, 400, 24, UIWidth, 96,255,255,255,255,"Aldrich",TextAlignCenter)
		WindowSetCommandList(startLbl[0] , "loop; toalpha 1,0.1; toalpha 0.5,1.0; next;")
//		ItemSetCommandList(SceneFindItem(scene,"Ship"), "toalpha 0,0.7; loop; torotation 10,0,720,0+toalpha 10,1; torotation 10,0,-720,0+toalpha 10,0.5; next;")

		// Use mouse or not
/*		local cusrsorTex	= EngineLoadTexture(g_engine, "ui/cursor.png")
		cursorSprite	= UIAddSprite(ui, g_ui_IDs++, cusrsorTex, 640, 480, TextureGetWidth(cusrsorTex), TextureGetHeight(cusrsorTex))
*/
		SceneSetGravity(scene, Vector(0,0,0))
//		UIRenderSetup(ui, g_factory)    // will render setup all UI items
	}
}
