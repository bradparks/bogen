package bogen.types;

import kha.FastFloat;
import kha.math.FastVector2;

// Constant Vector
@:forward(get_x, get_y, get_length, add, sub, mult, div, dot)
abstract ConstVec(FastVector2) from Vec
{
	
public inline function new(x: FastFloat, y: FastFloat)
	this = new FastVector2(x, y);

public var x(get, never): FastFloat;
public var y(get, never): FastFloat;
public var length(get, never): FastFloat;

public inline function get_x() return this.x;
public inline function get_y() return this.y;
public inline function get_length() return (cast (this, Vec)).length;

public inline function addScalar(x: FastFloat, y: FastFloat)
	return new ConstVec(this.x + x, this.y + y);

}
