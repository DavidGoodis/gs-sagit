/*
	File: ReactorTrailFinal.nut
	Author: DG
*/

/*!
	@short	ReactorTrailFinal
	@author	DG
*/
class	ReactorTrailPoly2
{
	vItem			= 0
	color_a 		= Vector(1, 0.2, 0.2, 1)

	sections		= []
	step			= 0.2

	function RendererDrawQuad(renderer, v0, v1, v2, v3, c0, c1, c2, c3, MatBlendMode, MatRendMode)
	{
		RendererDrawTriangle(renderer,v0, v1, v3, c0, c1, c3, MatBlendMode, MatRendMode)
		RendererDrawTriangle(renderer,v1, v2, v3, c1, c2, c3, MatBlendMode, MatRendMode)
	}


	function OnRenderUser(item)
	{

		RendererSetIdentityWorldMatrix(g_render)

		for(local n=0; n<(sections.len()-4); n+=4)
		{
				local alpha = RangeAdjustClamped(color_a.w*n*1.5,0,sections.len(),0,1)
				local color = Vector(color_a.x, color_a.y,color_a.z, alpha)
				RendererDrawQuad(g_render, sections[n], sections[n+4], sections[n+1], sections[n+5], color, color, color, color, MaterialBlendAdd, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n+1], sections[n+5], sections[n+2], sections[n+6], color, color, color, color, MaterialBlendAdd, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n+2], sections[n+6], sections[n+7], sections[n+3], color, color, color, color, MaterialBlendAdd, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n+7], sections[n+3], sections[n], sections[n+4], color, color, color, color, MaterialBlendAdd, MaterialRenderDoubleSided)
		}

	}


	function	OnUpdate(item)
	{
		vItem = ItemGetWorldPosition(item)

		//Adds a new section
		//Vertexes along the origin plane
		local v0 = Vector(vItem.x-0.1,vItem.y-0.1,vItem.z)
		local v1 = Vector(vItem.x-0.1,vItem.y+0.1,vItem.z)
		local v2 = Vector(vItem.x+0.1,vItem.y+0.1,vItem.z)
		local v3 = Vector(vItem.x+0.1,vItem.y-0.1,vItem.z)

		sections.append(Vector(vItem.x-0.1,vItem.y-0.1,vItem.z))
		sections.append(Vector(vItem.x-0.1,vItem.y+0.1,vItem.z))
		sections.append(Vector(vItem.x+0.1,vItem.y+0.1,vItem.z))
		sections.append(Vector(vItem.x+0.1,vItem.y-0.1,vItem.z))

		//Updates section's z
		foreach(i,s in sections)
		{
			sections[i] = Vector(s.x, s.y, s.z-step)
			if (s.z-step < -10)
				sections.remove(i)
		}

	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{
		vItem = ItemGetWorldPosition(item)

		//Initial section
		sections.append(Vector(vItem.x-0.1,vItem.y-0.1,vItem.z))
		sections.append(Vector(vItem.x-0.1,vItem.y+0.1,vItem.z))
		sections.append(Vector(vItem.x+0.1,vItem.y+0.1,vItem.z))
		sections.append(Vector(vItem.x+0.1,vItem.y-0.1,vItem.z))
	}
}
