package bogen.math;

// Angle helpers
class Angle
{

// Wraps an angle between [-180, 180[
public static inline function wrap(angle: Float)
{
	var result = (angle + 180) % 360;
	return result < 0? result + 180: result - 180;
}

// Convert an angle to radians
public static inline function rad(angle: Float)
	return angle * Math.PI / 180;

// Convert an angle to degrees
public static inline function deg(angle: Float)
	return angle * 180 / Math.PI;

// Angle's sine in degrees
public static inline function degSin(angle: Float)
	return Math.sin(rad(angle));

// Angle's cosine in degrees
public static inline function degCos(angle: Float)
	return Math.cos(rad(angle));

}
