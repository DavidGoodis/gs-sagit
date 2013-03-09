/*
	File: schmup.nut
	Author: DG
*/

/*!
	@short	schmup
	@author	DG
*/

Include("Script/gui.nut")
Include("Script/globals.nut")
Include("Script/ace_deleter.nut")


//Controls 
useMouse	<- 0
usePad		<- 1

//Engine 
g_timer		  <- 0.0
g_clock_scale <- 0.0

//game state
pause		<- 0
current_scene <- 0

//=== achievements ===
achieved	<- []


class	schmup
{
	/*!
		@short	OnUpdate
		Called each frame.
	*/

	scene 		= 0
	channel_music = 0
	ready 		= 0
	Abutton		= 82
	StartButton = 93
	LB			= 95
	RB			= 98
	Up			= 19
	Down		= 20
	Left		= 21
	Right		= 22

//	========================================================================================================
	function	OnUpdate(project)
//	========================================================================================================
	{
		local	keyboard 	= GetKeyboardDevice(),
				pad 		= GetInputDevice("xinput0")

		if	((!ready) && ((DeviceKeyPressed(keyboard, KeySpace)) || (DeviceKeyPressed(pad, KeyStart ))))
		{	
			ready = 1
			ProjectUnloadScene(project, scene)
			scene = ProjectInstantiateScene(project, "Scenes/Preload.nms")
			ProjectAddLayer(project, scene, 1)
			ready = 3
		}

		if (ready == 3) 
//			if (ProjectSceneGetScriptInstanceFromClass(scene, "Preload").state == "preloaded")
		{
			ProjectUnloadScene(project, scene)
			scene = ProjectInstantiateScene(project, "Scenes/Level1.nms")
			ProjectAddLayer(project, scene, 1)
			MixerChannelStop(g_mixer,channel_music)
			channel_music = MixerStreamStart(g_mixer,snd_mu_game)
			MixerChannelSetGain(g_mixer, channel_music, 0.8)
			MixerChannelSetLoopMode(g_mixer, channel_music, LoopRepeat)
			ready = 4
		}



		if	((ready) && (DeviceKeyPressed(keyboard, KeyR)) || (DeviceKeyPressed(pad, KeyButton1 )))
		{
			ProjectUnloadScene(project, scene)
			scene = ProjectInstantiateScene(project, "Scenes/Level1.nms")
			g_timer = g_clock
			ProjectAddLayer(project, scene, 1)
		}
			
	}

	/*!
		@short	OnRenderScene
		Called before rendering a scene layer.
	*/
	function	OnRenderScene(project, scene, layer)
	{}

	/*!
		@short	OnSetup
		Called when the project is about to be setup.
	*/
//	========================================================================================================
	function	OnSetup(project)
//	========================================================================================================
	{
//		g_clock_scale = EngineGetClockScale(g_engine)
//		EngineSetFixedDeltaFrame(g_engine,60)

		channel_music = MixerStreamStart(g_mixer,snd_mu_title)

		MixerChannelSetGain(g_mixer, channel_music, 0.8)
		MixerChannelSetLoopMode(g_mixer, channel_music, LoopRepeat)

		scene = ProjectInstantiateScene(project, "Scenes/Title.nms")
		ProjectAddLayer(project, scene, 1)
	}
}
