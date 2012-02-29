/*
	File: Script/Preload.nut
	Author: DG
*/

/*!
	@short	Scenes_Preload
	@author	DG
*/
class	Preload
{

	state = "preloading"

//=== preloaded objects ===
	nmgToPreload = [
	"Cube.nmg",
	"ForceField.nmg",
	"Spacecraft.nmg",
	"Vehic1.nmg",
	"reactor1.nmg",
	"TunnelElement.nmg",
/*	"icosphere.nmg",
	"None_asterock.nmm",
	"Material_002_FF.nmm",
	"Material_001.nmm",
	"terrain/terrain_uid462244.nmm"*/
	]

	TexToPreload = [
	"FF7.png"
	]

	/*!
		@short	OnUpdate
		Called each frame.
	*/
	function	OnUpdate(scene)
	{
//		for(local i=0;i<100;i++)
//			{	}

		state = "preloaded"
		print(state)

	}

	/*!
		@short	OnSetup
		Called when the scene is about to be setup.
	*/
	function	OnSetup(scene)
	{
		print(state)
		local ui = SceneGetUI(scene)
		UILoadFont("ui/Square.ttf")

		local LoaderLbl  = CreateLabel(ui, "Loading geometry...", 500, 450, 50, 500, 96,0,0,0,255,"Square",TextAlignLeft)

//		ItemSetCommandList(SceneFindItem(scene,"Vehic1"), "toalpha 0,0.5; loop; torotation 30,0,1080,0+toalpha 30,1; torotation 30,0,-1080,0+toalpha 3,0.5; next;")

		foreach(id, item in nmgToPreload)
			EngineLoadGeometry(g_engine, "Mesh/" + item)

		TextSetText(LoaderLbl[1], "Loading textures...")

		foreach(id, item in TexToPreload)
			EngineLoadTexture(g_engine, "Tex/" + item)
	}
}
