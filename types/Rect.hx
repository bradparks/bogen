package bogen.types;

import bogen.render.DebugSprite;
import bogen.simulation.Simulation;
import kha.FastFloat;

// Simple rectangle
class Rect
{

// Size and position
public var x: FastFloat;
public var y: FastFloat;
public var width: FastFloat;
public var height: FastFloat;

// Constructor
public inline function new
	(x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat)
{
	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
}

// Representation
public inline function toString() return 'Rect($x, $y, $width, $height)';

// Copy
public inline function copy() return new Rect(x, y, width, height);

// Check if the rect collides with a point
public inline function collidePoint(otherX: FastFloat, otherY: FastFloat): Bool
{
	return
		otherX >= x && otherX <= x + width
		&& otherY >= y && otherY <= y + height;
}

// Check if it collides with another rect
public function collide
(
	otherX: FastFloat, otherY: FastFloat,
	otherW: FastFloat, otherH: FastFloat
)
{
	var result: Bool;
	
	if (x < otherX) result = otherX < x + width;
	else result = x < otherX + otherW;
	
	if (!result) return false;
	
	if (y < otherY) return otherY < y + height;
	else return y < otherY + otherH;
}

// Adds a debug sprite into the simulation
public function addDebugSprite(simulation: Simulation)
{
	#if (debug && bogen_debug_rect)
	simulation.add(DebugSprite.fromRect(this));
	#end
}

}
