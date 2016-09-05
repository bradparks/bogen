package bogen.simulation;

import kha.FastFloat;

// Time passed between events
class TimeStep
{

// Time passed
public var elapsed(default, null): FastFloat;

// Time passed without scale
public var realElapsed(default, null): FastFloat;

// Constructor
public function new(realElapsed: FastFloat, scale: FastFloat)
	set(realElapsed, scale);

// Change the elapsed time
@:allow(bogen.simulation.Game)
private inline function set(realElapsed: FastFloat, scale: FastFloat)
{
	this.realElapsed = realElapsed;
	elapsed = realElapsed * scale;
}

// Creates a new TimeStep with a different scale
public function changeScale(scale: FastFloat)
	return new TimeStep(realElapsed, scale);
	
// Pauses time
public function pause() return changeScale(0);

// Creates a new TimeStep using the real time
public function asRealTimeStep() return new TimeStep(realElapsed, 1);

// Representation
public function toString() return 'Timestep: $elapsed'; 

}
