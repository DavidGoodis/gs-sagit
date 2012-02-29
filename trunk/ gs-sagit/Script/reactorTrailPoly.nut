/*
	File: script/reactor1.nut
	Author: DG
*/

/*!
	@short	reactor1
	@author	DG
*/
class	reactor1
{

/*<
	<Script =
		<Name = "red trail">
		<Author = "David Ghodsi">
		<Description = "Creates a trail fading towards the camera">
		<Category = "Vehicules">
		<Compatibility = <Item>>
	>
	<Parameter =
		<size = <Name = "Size"> <Type = "Float"> <Default = 0.5>>
		<step = <Name = "Step"> <Type = "Float"> <Default = 0.5>>
	>
>*/

	tabParticules 	= []
	prevPos			= 0
	geo		 		= 0
	step			= 0.5 //depth of 1 trail step
	size			= 0.5
	camItem			= 0

	/*!
		@short	OnUpdate
		Called during the scene update, each frame.
	*/

	function 	pushPoly(geo, vO, vD, n)
	{
		//front face
/*		geo.beginPolygon()
		geo.pushVertex(Vector(0,0,0))
		geo.pushVertex(Vector(0,y,0))
		geo.pushVertex(Vector(x,y,0))
		geo.pushVertex(Vector(x,0,0))
		geo.endPolygon(0)
*/
		//back face
/*		geo.beginPolygon()
		geo.pushVertex(Vector(0,0,z))
		geo.pushVertex(Vector(0,y,z))
		geo.pushVertex(Vector(x,y,z))
		geo.pushVertex(Vector(x,0,z))
		geo.endPolygon(0)
*/
		vD.x = vD.x-0.4
		vD.y = vD.y-0.4

		//left face
		geo.beginPolygon()
		geo.pushVertex(vO)
		geo.pushVertex(vD)
		geo.pushVertex(Vector(vD.x,vD.y+n,vD.z))
		geo.pushVertex(Vector(vO.x,vO.y+n,vO.z))
		geo.endPolygon(0)
		//right face
		geo.beginPolygon()
		geo.pushVertex(Vector(vO.x+n,vO.y,vO.z))
		geo.pushVertex(Vector(vD.x+n,vD.y,vD.z))
		geo.pushVertex(Vector(vD.x+n,vD.y+n,vD.z))
		geo.pushVertex(Vector(vO.x+n,vO.y+n,vO.z))
		geo.endPolygon(0)
		//bottom face
		geo.beginPolygon()
		geo.pushVertex(vO)
		geo.pushVertex(vD)
		geo.pushVertex(Vector(vD.x+n,vD.y,vD.z))
		geo.pushVertex(Vector(vO.x+n,vO.y,vO.z))
		geo.endPolygon(0)
		//top face
		geo.beginPolygon()
		geo.pushVertex(Vector(vO.x,vO.y+n,vO.z))
		geo.pushVertex(Vector(vD.x,vD.y+n,vD.z))
		geo.pushVertex(Vector(vD.x+n,vD.y+n,vD.z))
		geo.pushVertex(Vector(vO.x+n,vO.y+n,vO.z))
		geo.pushUV(0, UV(vO.x, vO.y+n))
		geo.pushUV(0, UV(vD.x, vD.y+n))
		geo.pushUV(0, UV(vD.x+n, vD.y+n))
		geo.pushUV(0, UV(vO.x+n, vO.y+n))
		geo.endPolygon(0)

		return(geo)
	}

	function	OnUpdate(item)
	{

		geo = GeometryTemplate()
//		geo = EngineLoadGeometry(g_engine, "Mesh/planet1x1.nmg")
//		local partMat = EngineLoadMaterial(g_engine, "Mesh/reactorPart.nmm")
//		MaterialSetup(partMat)
//		geo.pushMaterial(partMat)
		geo.pushMaterial(GeometryGetMaterialFromIndex(ObjectGetGeometry(ItemCastToObject(SceneFindItem(g_scene, "Spacecraft"))), 3))

		local pos 	= ItemGetWorldPosition(item)

//		prevPos.z = ItemGetPosition(CameraGetItem(SceneGetCurrentCamera(g_scene))).z

		prevPos.z -= step
		geo 	= pushPoly(geo,prevPos,pos,size)
		prevPos	= pos

		// create the mesh with the name "geoi"
		local geoi = geo.instantiate(g_engine, "geoi")

		local mat 	= GeometryGetMaterialFromIndex(geoi, 0)
		MaterialFlagSet(mat, MaterialRenderDoubleSided, true)
		MaterialSetDiffuse(mat, Vector(255,0,0,200))

/*		local tex	= EngineLoadTexture(g_engine, "Tex/particle1.png")
		MaterialChannelSetTexture(mat, tex, ChannelDiffuse)
		MaterialChannelSetTexture(mat, tex, ChannelOpacity)
		MaterialChannelSetTexture(mat, tex, ChannelSelfIllum)
*/

		// create the object in the scene call "ObjectPlane"
		local temp_mesh = SceneAddObject(g_scene, "ObjectPlane")
		local temp_item = ObjectGetItem(temp_mesh)

//		ItemSetPosition(temp_item, pos)
 		ItemSetOpacity(temp_item, 1)
//		print(pos.x + "::" + pos.y + "::" + pos.z)
 
		// add the geometry to the new object
		ObjectSetGeometry(temp_mesh, geoi)
 
		// setup the object
		ItemSetup(temp_item)
		tabParticules.append(temp_item)

		local camZ = ItemGetPosition(camItem).z

		foreach(id,part in tabParticules)
		{
//			ItemSetOpacity(part, ItemGetOpacity(part)-0.01)
			local p = ItemGetPosition(part)
			ItemSetPosition(part, Vector(p.x,p.y,p.z-step))
			ItemSetOpacity(part, Abs(1/(5*p.z)))
//			local rot =	ItemGetRotation(part)
//			ItemSetRotation(part,Vector(rot.x+0.1,rot.y+0.1,rot.z+0.1))

//			if (ItemGetOpacity(part) <= 0.0)
			if (p.z < camZ)
			{
				SceneDeleteItem(g_scene,part)
				tabParticules.remove(id)
			}
		}
	}

	/*!
		@short	OnSetup
		Called when the item is about to be setup.
	*/
	function	OnSetup(item)
	{

//		geo.pushMaterial(EngineNewMaterial(g_engine))
		prevPos = ItemGetWorldPosition(item)
		camItem = CameraGetItem(SceneGetCurrentCamera(g_scene))
	}
}
