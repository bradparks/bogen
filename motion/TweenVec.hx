package bogen.motion;

import bogen.component.Component;
import bogen.math.Vec;
import bogen.simulation.Simulation;
import bogen.simulation.TimeStep;

class TweenVec extends Component
{

// Vector to animate
public var vec: Vec;

// Initial and final vectors
private var initial: Vec;
private var final: Vec;

// Difference betweem final and inital
private var difference: Vec;

// Total animation time
private var animationTime: Float;

// Start delay
private var delay: Float;

// When zero, starts animating. When > animationTime, finishes.
private var time: Float;

// Parent simulation, if provided will remove itself when finished
private var parent: Simulation;

// Called when the tween finishes
private var onFinish: Void->Void;

// Tween function
public var tween: Float->Float;

// Constructor
public function new
(
	vec: Vec, finalX: Float, finalY: Float, tween: Float->Float,
	animationTime: Float, delay: Float,
	parent: Simulation, ?onFinish: Void->Void
)
{
	this.vec = vec;

	initial = Vec.from(vec);
	final = new Vec(finalX, finalY);
	difference = final.sub(initial);
	
	this.delay = delay;
	this.animationTime = animationTime;
	
	this.parent = parent;
	this.onFinish = onFinish;
	
	time = -delay;
	this.tween = tween;
	
	#if (debug && bogen_no_animation)
		time = animationTime;
	#end
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
		
		if (onFinish != null)
		{
			vec.set(final.x, final.y);
			onFinish();
			onFinish = null;
		}
		
		return;
	}
	
	var deltaValue = tween(time / animationTime);
	
	vec.x = initial.x + (difference.x * deltaValue);
	vec.y = initial.y + (difference.y * deltaValue);
}

}
