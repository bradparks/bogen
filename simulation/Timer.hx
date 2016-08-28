package bogen.simulation;

import kha.FastFloat;

// Timer simulation, dispatch an event when finished
class Timer extends BaseSimulation
{

// Remaining time
private var remaining: FastFloat;

// Called on finish
public var onFinish: Void->Void;

// Constructor
public function new(remaining: FastFloat, onFinish: Void->Void)
{
	this.remaining = remaining;
	this.onFinish = onFinish;
}

// Update
override public function onUpdate(timeStep: TimeStep) 
{
	remaining -= timeStep.elapsed;
	if (remaining <= 0 && onFinish != null)
	{
		remaining = 0;
		onFinish();
		onFinish = null;
	}
}

}
