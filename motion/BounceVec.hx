package bogen.motion;

import bogen.simulation.Simulation;
import bogen.types.Vec;
import kha.FastFloat;

class BounceVec extends MotionVec
{

// Tween function
override public function tween(t: FastFloat)
{
	if (t < (1 / 2.75)) return (7.5625 * t * t);
	if (t < (2 / 2.75)) return (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
	if (t < (2.5 / 2.75)) return (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
	return (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
}

// Simple bounce animation
public static inline function simple
(
	point: Vec, finalX: FastFloat, finalY: FastFloat,
	time: FastFloat, delay: FastFloat = 0, ?simulation: Simulation
)
{
	return new BounceVec
	(
		point, point.x, point.y,
		finalX, finalY,
		time, delay, simulation
	);
}

}
