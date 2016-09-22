package bogen.render;

import kha.Image;

// Frame on a spritesheet
class Frame
{
	
// Image to draw from
public var sheet: Image;

// Position and size on the sheet
public var x: Int;
public var y: Int;
public var width: Int;
public var height: Int;

// Constructor
public inline function new
	(sheet: Image, x: Int, y: Int, width: Int, height: Int)
{
	this.sheet = sheet;
	
	this.x = x;
	this.y = y;
	
	this.width = width;
	this.height = height;
}

}
