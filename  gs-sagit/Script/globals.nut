//globals.nut

g_ui_IDs		<- 0
gShipCanBarrel	<- 1

//sound effects
snd_fx_wall			<-	"data/fx_3.wav"
snd_fx_shield		<-	"data/shield.wav"
snd_fx_otshield		<-	"data/Object_through_shield.wav"

//music
//snd_mu_title		<-	"data/Title_Romain.ogg"
snd_mu_title		<-	"data/cute.ogg"
//snd_mu_game			<-	"data/01-EXTRA.ogg"
//snd_mu_game			<-	"data/davidoldschool.ogg"
//snd_mu_game			<-	"data/souleye - embrace.ogg"
snd_mu_game			<-	"data/electrocircus.ogg"

	//--------------------------------------------
	function	ComputeLowDeltaFrameCompensation()
	//--------------------------------------------
	{
		//	low_dt_compensation is a factor (btw 0.0 and 1.0)
		//	that you might need when apply forces, impulses & torques.
		low_dt_compensation = Clamp(1.0 / (60.0 * g_dt_frame), 0.0, 1.0)
	}