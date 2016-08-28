package bogen.motion;

import bogen.simulation.BaseSimulation;
import bogen.simulation.Simulation;
import bogen.types.ConstVec;
import bogen.types.Vec;
import bogen.simulation.TimeStep;
import kha.FastFloat;

class BounceVec extends BaseSimulation
{

// Vector to animate
public var vec: Vec;

// Initial and final vectors
private var initial: ConstVec;
private var final: ConstVec;

// Difference betweem final and inital
private var difference: ConstVec;

// Total animation time
private var animationTime: FastFloat;

// Start delay
private var delay: FastFloat;

// When zero, starts animating. When > animationTime, finishes.
private var time: FastFloat;

// Parent simulation, if provided will add and remove itself
private var parent: Simulation;

// Constructor
public function new
(
	point: Vec,
	initialX: FastFloat, initialY: FastFloat,
	finalX: FastFloat, finalY: FastFloat,
	animationTime: FastFloat, delay: FastFloat,
	?parent: Simulation
)
{
	this.vec = point;

	initial = new ConstVec(initialX, initialY);
	final = new ConstVec(finalX, finalY);
	difference = new ConstVec(finalX - initialX, finalY - initialY);
	
	this.delay = delay;
	this.animationTime = animationTime;
	
	time = -delay;
	point.copy(initial);
	
	this.parent = parent;
	if (parent != null) parent.add(this);
	
	#if (debug && bogen_no_animation)
		time = animationTime;
	#end
}

// Tween function
public static inline function tween(t: FastFloat)
{
	if (t < (1 / 2.75)) return (7.5625 * t * t);
	if (t < (2 / 2.75)) return (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
	if (t < (2.5 / 2.75)) return (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
	return (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	time += timeStep.elapsed;
	if (time < 0) return;
	else if (time > animationTime)
	{
		if (parent != null)
		{
			vec.set(final.x, final.y);
			parent.remove(this);
		}
		
		return;
	}
	
	var deltaValue = tween(time / animationTime);
	
	vec.x = initial.x + (difference.x * deltaValue);
	vec.y = initial.y + (difference.y * deltaValue);
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
