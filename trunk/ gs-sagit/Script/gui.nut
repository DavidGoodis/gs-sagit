g_ui_IDs	<- 0

function	CreateLabel(ui, name, x, y, size = 70, w = 300, h = 64, r = 255, g = 255, b = 255, a = 255, font = "electr", align = TextAlignCenter)
{
	// Create UI window.
	local	_id
	g_ui_IDs++
	_id = g_ui_IDs
	local	window = UIAddWindow(ui, _id, x, y, w, h)

	// Create UI text widget and set as window base widget.
	local	widget = UIAddStaticTextWidget(ui, -1, name, font)
 	WindowSetBaseWidget(window, widget)

	// Set text attributes.
	TextSetSize(widget, size)
	TextSetColor(widget, r, g, b, a)
	TextSetAlignment(widget, align)

	return [ window, widget, _id ]
}