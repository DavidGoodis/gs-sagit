g_ui_IDs	<- 0

function	CreateLabel(ui, name, x, y, size = 32, width = 200, height = 64, r = 255, g = 255, b = 255, a = 255, font = "electr", align = TextAlignLeft)
//function	CreateLabel(ui, name, x, y, size, w, h, r, g, b, a, font, align)
{
	// Create UI window.
	local	_id
	g_ui_IDs++
	_id = g_ui_IDs
//	local	window = UIAddWindow(ui, _id, x, y, w, h)
	local	window = UIAddNamedWindow(ui, name, x, y, width ,height)

	// Create UI text widget and set as window base widget.
	local textwidget = UIAddTextWidget(ui, -1, name, ProjectGetUIFont(g_project, font))
//	local	widget = UIAddStaticTextWidget(ui, -1, "txt-" + name, font)

	// Set text attributes.
	TextSetSize(textwidget, size)
	TextSetColor(textwidget, r, g, b, a)
	TextSetAlignment(textwidget, align)
	TextSetFormat(textwidget, TextFormatStandard)

 	WindowSetBaseWidget(window, textwidget)
	WindowRenderSetup(window, g_factory)

	return [ window, textwidget, name ]
}

function CreateSprite(ui, texture, x, y ,n)
{
	local tex	= ResourceFactoryLoadTexture(g_factory, texture)
	local sprite =UIAddNamedSprite(ui, "sprite", NullTexture, x, y, TextureGetWidth(tex)*n, TextureGetHeight(tex))
	SpriteRenderSetup(sprite, g_factory)
	SpriteSetTexture(sprite, tex)

	return sprite
}