package bogen.math;

import kha.math.FastVector2;

// FastVector2 with alias for width and height
@:notNull
@:forward(
	x, y, length, add, sub, mult, div, dot, normalize,
	set, copy, addInPlace, addScalarInPlace
)
abstract Size(Vec) from Vec to Vec
{
	
public var width(get, set): Float;
public var height(get, set): Float;
	
public inline function new(width: Float, height: Float)
	this = new FastVector2(width, height);

public inline function get_width() return this.x;
public inline function set_width(value: Float) return this.x = value;

public inline function get_height() return this.y;
public inline function set_height(value: Float) return this.y = value;

public static inline function from(other: FastVector2)
	return new Size(other.x, other.y);

public static inline function zero() return new Size(0, 0);

public inline function toString()
	return 'Size(${ this.x }, ${ this.y })';

}
