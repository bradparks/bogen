package bogen.types;

import kha.FastFloat;
import kha.math.FastVector2;

// Alias for FastVector2 with a few extra operations
@:forward(x, y, length, add, sub, mult, div, dot, normalize)
abstract Vec(FastVector2) from FastVector2 to FastVector2
{
	
public inline function new(x: FastFloat, y: FastFloat)
{
	this = new FastVector2(x, y);
}

public inline function set(x: FastFloat, y: FastFloat)
{
	this.x = x;
	this.y = y;
}

public inline function copy(other: ConstVec)
{
	this.x = other.x;
	this.y = other.y;
}

public inline function addScalar(x: FastFloat, y: FastFloat)
{
	this.x += x;
	this.y += y;
}

public inline function addInPlace(other: ConstVec)
{
	this.x += other.x;
	this.y += other.y;
}

public inline function addInPlaceScaled(other: ConstVec, scale: FastFloat)
{
	this.x += other.x * scale;
	this.y += other.y * scale;
}

public static inline function empty()
{
	return new Vec(0, 0);
}

public inline function toString()
{
	return 'Vec(${ this.x }, ${ this.y })';
}

}
