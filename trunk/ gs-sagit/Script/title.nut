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

		local blip  = ResourceFactoryLoadSound(g_factory, "data/select.wav")
		local buuu  = ResourceFactoryLoadSound(g_factory, "data/dame.wav")
		local toing = ResourceFactoryLoadSound(g_factory, "data/toing.wav")

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
				WindowSetPosition(selectorSprite,20,375)
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
				WindowSetPosition(selectorSprite,240,375)
				break
			case 2:
				if ((DeviceKeyPressed(keyb, KeyEnter)) || (DeviceKeyPressed(pad, Abutton)) )
					if (!usePad)
						{ usePad = 1; useMouse = 0; MixerSoundStart(g_mixer, toing)}
					else
						usePad = 0
				else
					WindowSetSize(selectorSprite,WindowGetSize(usePadLbl[0]).x,WindowGetSize(selectorSprite).y)
					WindowSetPosition(selectorSprite,420,375)
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
		ProjectLoadUIFont(g_project, "ui/saturnv.ttf")
		ProjectLoadUIFont(g_project, "ui/ONRAMP.ttf")
		ProjectLoadUIFont(g_project, "ui/blanch_caps.ttf")


//		UILoadFont("ui/DIMIS.TTF")
//		UILoadFont("ui/blanch_caps.ttf")

//		cursor = UICreateCursor(0)

		local VSTex	= ResourceFactoryLoadTexture(g_factory, "Tex/VirtualScreen.png")
//		local VS 	= UIAddSprite(ui, g_ui_IDs++, VSTex, 0, 0, TextureGetWidth(VSTex)+1, TextureGetHeight(VSTex))
//		WindowSetOpacity(VS, 1)

//		local BGTex	= ResourceFactoryLoadTexture(g_factory, "Tex/TitleBG.png")
//		local BGsprite =UIAddNamedSprite(ui, "BGTex", NullTexture, 0, 200, TextureGetWidth(BGTex), TextureGetHeight(BGTex))
//		local BGsprite = UIAddSprite(ui, -1, NullTexture, 0, 0, 300, 247)
//		SpriteRenderSetup(BGsprite, g_factory)
//		SpriteSetTexture(BGsprite, BGTex)

		local BGsprite = CreateSprite(ui,"Tex/TitleBG.png",0,280,32)

		Title = CreateLabel(ui, "Sagittarius_A*", 20, 60, 340, 1920, 240,0,0,0,255,"ONRAMP",TextAlignCenter)
//		WindowSetScale(Title[0],1,2)
		CreateLabel(ui, "Keyboard : Up, Down, Left, Right, X/V (Roll), C (Shield), R (Restart), F1 (Help)", 20, 255, 40, 1280, 96,255,255,255,255,"blanch_caps",TextAlignLeft)
		CreateLabel(ui, "Xbox Pad : Left stick (Direction), right stick/LB/RB (Roll), A (Shield), Start (Restart), X (Help)", 20, 285, 40, 1280, 96,255,255,255,255,"blanch_caps",TextAlignLeft)
		useKeybLbl  = CreateLabel(ui, "[Use Keyboard]", 20, 315, 40, 175, 96,50,195,255,255,"blanch_caps",TextAlignLeft)
		useMouseLbl = CreateLabel(ui, "[Use Mouse]", 240, 315, 40, 140, 96,255,255,255,128,"blanch_caps",TextAlignLeft)
		usePadLbl   = CreateLabel(ui, "[Use Pad]", 420, 315, 40, 115, 96,255,255,255,128,"blanch_caps",TextAlignLeft)
		local selectorTex	= ResourceFactoryLoadTexture(g_factory, "ui/selector.png")

//		selectorSprite		= UIAddNamedSprite(ui, "selectorSpr", selectorTex, 10, 10, TextureGetWidth(selectorTex), TextureGetHeight(selectorTex))
		selectorSprite		= CreateSprite(ui,"ui/selector.png",0,0,1)

		WindowSetCommandList(selectorSprite , "loop; toalpha 0.5,0.3; toalpha 0.5,1.0; next;")
 		local startLbl = CreateLabel(ui, "Press Space/Start now !", 20, 375, 40, 1280, 96,255,255,255,255,"blanch_caps",TextAlignLeft)
		WindowSetCommandList(startLbl[0] , "loop; toalpha 0.1,0.3; toalpha 0.1,1.0; next;")
//		ItemSetCommandList(SceneFindItem(scene,"Ship"), "toalpha 0,0.7; loop; torotation 10,0,720,0+toalpha 10,1; torotation 10,0,-720,0+toalpha 10,0.5; next;")

		// Use mouse or not
/*		local cusrsorTex	= EngineLoadTexture(g_engine, "ui/cursor.png")
		cursorSprite	= UIAddSprite(ui, g_ui_IDs++, cusrsorTex, 640, 480, TextureGetWidth(cusrsorTex), TextureGetHeight(cusrsorTex))
*/
		SceneSetGravity(scene, Vector(0,0,0))
//		UIRenderSetup(ui, g_factory)    // will render setup all UI items
	}
}
