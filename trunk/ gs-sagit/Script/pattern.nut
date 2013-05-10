/*
	File: Script/pattern.nut
	Author: DG
*/

/*!
	@short	pattern
	@author	DG
*/
class	Pattern
{

	width 		= 0
	height 		= 0
	tileSize	= 0
	object		= 0
	items		= []
	minmax  	= {}

	constructor(o,i,w,h)
	{
		object = o
		items = i
		width = w
		height = h
		print("A pattern of " + width + "x" + height + " was constructed. It contains " + items.len() + " items.")
	}

	function	GetMinMax()
	{
		minmax.min <- Vector(ItemGetPosition(object).x - width*0.5, ItemGetPosition(object).y - height*0.5, ItemGetPosition(object).z)
		minmax.max <- Vector(ItemGetPosition(object).x + width*0.5, ItemGetPosition(object).y + height*0.5, ItemGetPosition(object).z)

		return(minmax)
	}
}
