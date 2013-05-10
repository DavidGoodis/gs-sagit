//globals.nut

g_ui_IDs		<- 0
gShipCanBarrel	<- 1

//sound effects
snd_fx_wall			<-	"data/fx_3.wav"
snd_fx_dead			<-	"data/fx_4.wav"
snd_fx_shield		<-	"data/shield.wav"
snd_fx_otshield		<-	"data/Object_through_shield.wav"

//music
//snd_mu_title		<-	"data/Title_Romain.ogg"
//snd_mu_title		<-	"data/cute.ogg"
snd_mu_title		<-	"data/Title_Romain.ogg"
//snd_mu_game		<-	"data/abstract_loop.ogg"
snd_mu_game			<-	"data/Begijo.ogg"
snd_p				<-  [ "data/soundbits/kick2.wav",
						"data/soundbits/SH101T.wav",
     					"data/soundbits/HatBasic.wav",
						"data/soundbits/CB_Snare.wav",
						"data/soundbits/SeeTwo2.wav",
						"data/soundbits/Arpegio5.wav",
						"data/soundbits/KickBasic.wav",
						"data/soundbits/clapBasic.wav",
						"data/soundbits/Harp.wav",
						"data/soundbits/404Reasons.wav"
						]
snd_stream_p		<-  [ "data/soundbits/kick2.ogg",
						"data/soundbits/SH101T.ogg",
     					"data/soundbits/HatBasic.ogg",
						"data/soundbits/CB_Snare.ogg",
						"data/soundbits/SeeTwo2.ogg",
						"data/soundbits/Arpegio5.ogg",
						"data/soundbits/KickBasic.ogg",
						"data/soundbits/clapBasic.ogg",
						"data/soundbits/Harp.ogg",
						"data/soundbits/Harp.ogg"
						]


snd_r				<- 	ResourceFactoryLoadSound(g_factory,"data/soundbits/Wub.wav")
snd_t				<- 	ResourceFactoryLoadSound(g_factory,"data/soundbits/404Beep.wav")

//Pad mapping
keyBack				<- 113
LB					<- 95
RB					<- 98
DeviceAxisLT 		<- 13
DeviceAxisRT 		<- 14
debug				<- 1
gVibrate			<- 1

gShipCanRoll		<- 1

UIWidth				<- 1920
UIHeight			<- 1080


//game play variables
g_spawnZ			<- 800
g_maxEntities		<- 1500

// Timer for Sync
SyncTimer			<- 0
SyncWait			<- 0.5
	
//Controls 
useMouse			<- 0
usePad				<- 1


//Gameplay
tileSize			<- 12
maxPatterns 		<- 11 // number of pattern png files to load

debugFont			<- LoadRasterFont(g_factory, "@core/fonts/profiler_base.nml", "@core/fonts/profiler_base")

	//--------------------------------------------
	function	ComputeLowDeltaFrameCompensation()
	//--------------------------------------------
	{
		//	low_dt_compensation is a factor (btw 0.0 and 1.0)
		//	that you might need when apply forces, impulses & torques.
		low_dt_compensation = Clamp(1.0 / (60.0 * g_dt_frame), 0.0, 1.0)
	}