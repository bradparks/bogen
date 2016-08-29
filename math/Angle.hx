package bogen.math;

import kha.FastFloat;

// Angle helpers
class Angle
{

// Wraps an angle between [-180, 180[
public static inline function wrap(angle: FastFloat)
{
	var result = (angle + 180) % 360;
	return result < 0? result + 180: result - 180;
}

// Convert an angle to radians
public static inline function rad(angle: FastFloat)
	return angle * Math.PI / 180;

// Convert an angle to degrees
public static inline function deg(angle: FastFloat)
	return angle * 180 / Math.PI;

// Angle's sine in degrees
public static inline function degSin(angle: FastFloat)
	return Math.sin(rad(angle));

// Angle's cosine in degrees
public static inline function degCos(angle: FastFloat)
	return Math.cos(rad(angle));

}
