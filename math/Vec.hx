package bogen.math;

import kha.math.FastVector2;

// Alias for FastVector2 with a few extra operations
@:notNull
@:forward(x, y, length, add, sub, mult, div, dot, normalize)
abstract Vec(FastVector2) from FastVector2 to FastVector2
{
	
public inline function new(x: Float, y: Float)
	this = new FastVector2(x, y);

public inline function set(x: Float, y: Float)
{
	this.x = x;
	this.y = y;
}

public inline function copy(other: FastVector2)
{
	this.x = other.x;
	this.y = other.y;
}

public inline function addInPlace(other: FastVector2)
{
	this.x += other.x;
	this.y += other.y;
}

public inline function addScalarInPlace(x: Float, y: Float)
{
	this.x += x;
	this.y += y;
}

public static inline function from(other: FastVector2)
	return new Vec(other.x, other.y);

public static inline function zero() return new Vec(0, 0);

public inline function toString()
	return 'Vec(${ this.x }, ${ this.y })';

}
