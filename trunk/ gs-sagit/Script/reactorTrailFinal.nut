/*
	File: ReactorTrailFinal.nut
	Author: DG
*/

/*!
	@short	ReactorTrailFinal
	@author	DG
*/
class	ReactorTrailFinal
{
	camItem			= 0
	vCam			= 0
	vItem			= 0
//	color_a 		= Vector(0.3, 0.3, 0.2, 0.2)
//	color_a 		= Vector(0.8, 0.1, 0.1, 0.5)
//	color_a 		= Vector(1, 1, 1, 1)
//	color_b 		= Vector(1, 1, 1, 0)
	color_b 		= Vector(1, 1, 1, 0.1)
//	color_a 		= Vector(1, 0.3, 0.3, 1)
	color_a 		= Vector(1, 0.7, 0.7, 1)

	function RendererDrawQuad(renderer, v0, v1, v2, v3, c0, c1, c2, c3, MatBlendMode, MatRendMode)
	{
		RendererDrawTriangle(renderer,v0, v1, v3, c0, c1, c3, MatBlendMode, MatRendMode)
		RendererDrawTriangle(renderer,v1, v2, v3, c1, c2, c3, MatBlendMode, MatRendMode)
	}


	function OnRenderUser(item)
	{
		local b0 = Vector(vItem.x-0.1,vItem.y-0.1,vItem.z)
		local b1 = Vector(vItem.x-0.1,vItem.y+0.1,vItem.z)
		local b2 = Vector(vItem.x+0.1,vItem.y+0.1,vItem.z)
		local b3 = Vector(vItem.x+0.1,vItem.y-0.1,vItem.z)

		local f0 = Vector(vCam.x-0.1,vCam.y-0.1,vCam.z-10)
		local f1 = Vector(vCam.x-0.1,vCam.y+0.1,vCam.z-10)
		local f2 = Vector(vCam.x+0.1,vCam.y+0.1,vCam.z-10)
		local f3 = Vector(vCam.x+0.1,vCam.y-0.1,vCam.z-10)

		RendererApplyCamera(g_render)
//		RendererSetIdentityWorldMatrix(g_render)

		RendererDrawQuad(g_render, b0, f0, f1, b1, color_a, color_b, color_b, color_a, MaterialBlendAlpha, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, f1, b1, b2, f2, color_b, color_a, color_a, color_b, MaterialBlendAlpha, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, b2, f2, f3, b3, color_a, color_b, color_b, color_a, MaterialBlendAlpha, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, f3, b3, b0, f0, color_b, color_a, color_a, color_b, MaterialBlendAlpha, MaterialRenderDoubleSided)
//		RendererDrawTriangle(g_render,Vector(vItem.x-0.1,vItem.y,vItem.z), Vector(vItem.x+0.1,vItem.y,vItem.z), Vector(vCam.x,vCam.y-0.01,vCam.z-155), color_a, color_a, color_a, MaterialBlendAdd, MaterialRenderDoubleSided)
	}


	function	OnUpdate(item)
	{
		vItem = ItemGetWorldPosition(item)
		vCam = ItemGetWorldPosition(camItem)

//		print(vItem.x + ":" + vItem.y + ":" + vItem.z)
//		print(vCam.x + ":" + vCam.y + ":" + vCam.z)

	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
//		camItem =   SceneFindItem(g_scene,"GameCam")
		camItem = CameraGetItem(SceneGetCurrentCamera(g_scene))
	}
}
