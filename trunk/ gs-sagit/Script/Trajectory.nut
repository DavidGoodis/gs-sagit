/*
	File: Script/Trajectory.nut
	Author: DG
*/


class	Trajectory
{
	minX	= 0
	minY	= 0
	maxX	= 0
	maxY	= 0
	
	function RendererDrawQuad(renderer, v0, v1, v2, v3, c0, c1, c2, c3, MatBlendMode, MatRendMode)
	{
		RendererDrawTriangle(renderer,v0, v1, v3, c0, c1, c3, MatBlendMode, MatRendMode)
		RendererDrawTriangle(renderer,v1, v2, v3, c1, c2, c3, MatBlendMode, MatRendMode)
	}

	function OnRenderUser(item)
	{
		local f0 = Vector(minX,minY,-100)
		local f1 = Vector(minX,maxY,-100)
		local f2 = Vector(maxX,maxY,-100)
		local f3 = Vector(maxX,minY,-100)

		local itemZ = ItemGetPosition(item).z
		local b0 = Vector(minX,minY,itemZ)
		local b1 = Vector(minX,maxY,itemZ)
		local b2 = Vector(maxX,maxY,itemZ)
		local b3 = Vector(maxX,minY,itemZ)

		local cQuad		= Vector(0, 0.6, 0.9, 0.05)
		local cLine		= Vector(0, 0.7, 0.9, 0.5)

		RendererDrawLineColored(g_render, f0, b0, cLine)
		RendererDrawLineColored(g_render, f1, b1, cLine)
		RendererDrawLineColored(g_render, f2, b2, cLine)
		RendererDrawLineColored(g_render, f3, b3, cLine)

		RendererDrawQuad(g_render, f0, b0, b1, f1, cQuad, cQuad, cQuad, cQuad, MaterialBlendAdd, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, f1, b1, b2, f2, cQuad, cQuad, cQuad, cQuad, MaterialBlendAdd, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, f2, b2, b3, f3, cQuad, cQuad, cQuad, cQuad, MaterialBlendAdd, MaterialRenderDoubleSided)
		RendererDrawQuad(g_render, f3, b3, b0, f0, cQuad, cQuad, cQuad, cQuad, MaterialBlendAdd, MaterialRenderDoubleSided)

	}

	function	OnUpdate(item)
	{
	 	local minmax =	ItemGetWorldMinMax(item)

		minX	= minmax.min.x
		minY	= minmax.min.y
		maxX	= minmax.max.x
		maxY	= minmax.max.y
	}

	function	OnSetup(item)
	{}
}
