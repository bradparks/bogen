package bogen.render;

import bogen.simulation.BaseSimulation;
import bogen.types.Rect;
import kha.Color;
import kha.FastFloat;

class DebugSprite extends BaseSimulation
{

// Box and color
public var box: Rect;
public var color: Color;

// Constructor
public function new
	(x: FastFloat, y: FastFloat, w: FastFloat, h: FastFloat, color: Color) 
{
	box = new Rect(x, y, w, h);
	this.color = color;
}

// Draw
override public function onDraw(canvas: Canvas, _)
{
	canvas.drawDebugRectangle(box.x, box.y, box.width, box.height, 1, color);
}

// Creates a sprite from a rectangle
public static function fromRect(rect: Rect, color: Color = 0xffffffff)
	return new DebugSprite(rect.x, rect.y, rect.width, rect.height, color);

}
