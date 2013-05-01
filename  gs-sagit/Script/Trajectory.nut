/*
	File: Script/Trajectory.nut
	Author: DG
*/

//displays the item which will hit

class	Trajectory
{
	minX	= 0
	minY	= 0
	maxX	= 0
	maxY	= 0

//	cQuad		= Vector(1,0,1, 0.2) //pink
	cQuad		= Vector(0,0,0, 0.2) //black
	cLine		= Vector(0, 0.7, 0.9, 0.9)
	cYellow		= Vector(1, 0.90, 0.49, 0.0) // yellow
	cPink		= Vector(1,0,1, 1) //pink
	cWhite		= Vector(1,1,1, 1) //white
	cRed 		= Vector(1,0,0, 1) //white
	cCurrent	= 0
	ship		= 0

	distance 	= 0

	// 1 if in the trajectory of the spaceship
	willHit		= 0


	function RendererDrawQuad(renderer, v0, v1, v2, v3, c0, c1, c2, c3, MatBlendMode, MatRendMode)
	{
		RendererDrawTriangle(renderer,v0, v1, v3, c0, c1, c3, MatBlendMode, MatRendMode)
		RendererDrawTriangle(renderer,v1, v2, v3, c1, c2, c3, MatBlendMode, MatRendMode)
	}

	function	OnUpdate(item)
	{
		if (willHit == 1)
//		if (ItemGetScriptInstanceFromClass(item, "Cube").willHit == 1)
		{
		 	local minmax =	ItemGetMinMax(item)
			minX	= minmax.min.x
			minY	= minmax.min.y
			maxX	= minmax.max.x
			maxY	= minmax.max.y

/*			local geo = ItemGetGeometry(item)
			local mat = GeometryGetMaterialFromIndex(geo, 0)
			MaterialSetSelf(mat, cYellow)
*/
		}
	}


	function OnRenderUser(item)
	{

		ship = SceneFindItem(ItemGetScene(item), "Spacecraft")
		local itemV = ItemGetWorldPosition(ship)

		if (willHit == 1)
//		if (ItemGetScriptInstanceFromClass(item, "Cube").willHit == 1)
		{
/*			local f0 = Vector(minX,minY,-200)
			local f1 = Vector(minX,maxY,-200)
			local f2 = Vector(maxX,maxY,-200)
			local f3 = Vector(maxX,minY,-200)
*/
			local f0 = itemV
			local f1 = itemV
			local f2 = itemV
			local f3 = itemV

			local iZ	= ItemGetPosition(item).z
			local iPos	= ItemGetWorldPosition(item)
			local iRot	= ItemGetRotationMatrix(ItemGetParent(item))

			local b0 = iPos + Vector(minX,minY,iZ-7)*iRot
			local b1 = iPos + Vector(minX,maxY,iZ-7)*iRot
			local b2 = iPos + Vector(maxX,maxY,iZ-7)*iRot
			local b3 = iPos + Vector(maxX,minY,iZ-7)*iRot

			RendererApplyCamera(g_render)
			RendererSetIdentityWorldMatrix(g_render)

/*
			RendererDrawLineColoredEx(g_render, f0, b0, cWhite, cWhite, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, f1, b1, cWhite, cWhite, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, f2, b2, cWhite, cWhite, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, f3, b3, cWhite, cWhite, MaterialBlendAlpha, MaterialRenderDoubleSided)
*/

			cCurrent.w = 1-distance/g_spawnZ //alpha
			cCurrent.x = 1//cCurrent.w
			cCurrent.y = 0.90-(1-distance*3/g_spawnZ)
			cCurrent.z = 0.49-(1-distance*3/g_spawnZ)

			
			RendererDrawQuad(g_render, f0, b0, b1, f1, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawQuad(g_render, f1, b1, b2, f2, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawQuad(g_render, f2, b2, b3, f3, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)
			RendererDrawQuad(g_render, f3, b3, b0, f0, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)


/*			for(local i=0.1; i<=1; i+=0.1)
				RendererDrawQuad(g_render, (b0+f0)*i, (b1+f1)*i, (b2+f2)*i, (b3+f3)*i, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)
*/

			RendererDrawQuad(g_render, b0, b1, b2, b3, cCurrent, cCurrent, cCurrent, cCurrent, MaterialBlendAlpha, MaterialRenderDoubleSided)

/*
			RendererDrawLineColoredEx(g_render, b0, b1, cQuad, cQuad, MaterialBlendNone, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, b1, b2, cQuad, cQuad, MaterialBlendNone, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, b2, b3, cQuad, cQuad, MaterialBlendNone, MaterialRenderDoubleSided)
			RendererDrawLineColoredEx(g_render, b3, b0, cQuad, cQuad, MaterialBlendNone, MaterialRenderDoubleSided)
*/

			//Display label
			local m = RendererGetViewMatrix(g_render)
			m.SetRow(3, ItemGetWorldPosition(ship))
			RendererSetWorldMatrix(g_render, m)
			distance = RoundFloatValue(distance, 1)
			RendererWrite(g_render, debugFont, "[   " + distance.tostring() + "m    ]", 0.5, 1.2, 7, false, WriterAlignMiddle, cYellow)
//			RendererWrite(g_render, debugFont, "WARNING", 0.5, -1, 2000/distance, false, WriterAlignMiddle, cRed)

//			ItemGetScriptInstanceFromClass(item, "Cube").willHit = 0
			willHit = 0
		}
	}


	function	OnSetup(item)
	{
		local s = ItemGetScene(item)
		ship = SceneFindItem(s, "Spacecraft")
		cCurrent = Vector(0,0,0,0)
	}
}
