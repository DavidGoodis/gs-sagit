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
/*<
	<Script =
		<Name = "3d Smoke Trail">
		<Author = "David Ghodsi">
		<Description = "Creates a trail fading towards the camera">
		<Category = "Vehicules">
		<Compatibility = <Item>>
	>
	<Parameter =
		<width = <Name = "Width of the trail (m)"> <Type = "Float"> <Default = 0.16>>
		<length = <Name = "Length of the trail (number of sections)"> <Type = "Float"> <Default = 60>>
		<step = <Name = "Step (length of a section in m)"> <Type = "Float"> <Default = 0.4>>
	>
>*/

	width			= 0.16
	length			= 60
	step			= 0.4

	vItem			= 0
	color_a 		= Vector(1, 0.90, 0.49, 1)
//	color_a 		= Vector(0.95, 0.92, 0.9, 1)
//	color_a 		= Vector(0.0, 0.00, 0.00, 0.7)

	sections		= []

	function RendererDrawQuad(renderer, v0, v1, v2, v3, c0, c1, c2, c3, MatBlendMode, MatRendMode)
	{
		RendererDrawTriangle(renderer,v0, v1, v2, c0, c1, c2, MatBlendMode, MatRendMode)
		RendererDrawTriangle(renderer,v0, v2, v3, c0, c2, c3, MatBlendMode, MatRendMode)
	}


	function OnRenderUser(item)
	{
		//Restore the view and projection matrices
		RendererApplyCamera(g_render)
		//Set world matrix to identity matrix
		RendererSetIdentityWorldMatrix(g_render)

		for(local n=0; n<(sections.len()-4); n+=4)
		{
				local alpha = RangeAdjustClamped(color_a.w*n*0.7,0,sections.len(),0,1)
				local color = Vector(color_a.x, color_a.y,color_a.z, alpha)

				local offset = -0.01

				sections[n].x -=offset
				sections[n].y -=offset
				sections[n+1].x -=offset
				sections[n+1].y +=offset
				sections[n+2].x +=offset
				sections[n+2].y +=offset
				sections[n+3].x +=offset
				sections[n+3].y -=offset

				//Draw sides (connect sections)
				RendererDrawQuad(g_render, sections[n], sections[n+1], sections[n+5], sections[n+4], color, color, color, color, MaterialBlendAlpha, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n+1], sections[n+2], sections[n+6], sections[n+5], color, color, color, color, MaterialBlendAlpha, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n+2], sections[n+3], sections[n+7], sections[n+6], color, color, color, color, MaterialBlendAlpha, MaterialRenderDoubleSided )
				RendererDrawQuad(g_render, sections[n], sections[n+3], sections[n+7], sections[n+4], color, color, color, color, MaterialBlendAlpha, MaterialRenderDoubleSided)

				//Draw sections
				RendererDrawQuad(g_render, sections[n], sections[n+1], sections[n+2], sections[n+3], color, color, color, color, MaterialBlendAlpha, MaterialRenderDoubleSided)
		}
	}


	function	OnUpdate(item)
	{
		vItem = ItemGetWorldPosition(item)

		//Add a new section
		//Vertexes along the origin plane
//		local width2 = width*g_dt_frame*60
		local width2 = width
		sections.append(Vector(vItem.x-width2,vItem.y-width2,vItem.z))
		sections.append(Vector(vItem.x-width2,vItem.y+width2,vItem.z))
		sections.append(Vector(vItem.x+width2,vItem.y+width2,vItem.z))
		sections.append(Vector(vItem.x+width2,vItem.y-width2,vItem.z))

		//Update section's z
		foreach(i,s in sections)
		{
			sections[i] = Vector(s.x, s.y, s.z-step)
			if(sections.len() > length*4)
//			if (vItem.z - s.z-step > length)
				sections.remove(i)
		}
	}

	function	OnSetup(item)
	{
		vItem = ItemGetWorldPosition(item)

		//Initial section
		sections.append(Vector(vItem.x-width,vItem.y-width,vItem.z))
		sections.append(Vector(vItem.x-width,vItem.y+width,vItem.z))
		sections.append(Vector(vItem.x+width,vItem.y+width,vItem.z))
		sections.append(Vector(vItem.x+width,vItem.y-width,vItem.z))

	}
}
