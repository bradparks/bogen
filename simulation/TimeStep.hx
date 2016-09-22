package bogen.simulation;

// Time passed between events
class TimeStep
{

// Time passed
public var elapsed(default, null): Float;

// Time passed without scale
public var realElapsed(default, null): Float;

// Constructor
public function new(realElapsed: Float, scale: Float)
	set(realElapsed, scale);

// Change the elapsed time
@:allow(bogen.Game)
private inline function set(realElapsed: Float, scale: Float)
{
	this.realElapsed = realElapsed;
	elapsed = realElapsed * scale;
}

// Creates a new TimeStep with a different scale
public function changeScale(scale: Float)
	return new TimeStep(realElapsed, scale);
	
// Pauses time
public function pause() return changeScale(0);

// Creates a new TimeStep using the real time
public function asRealTimeStep() return new TimeStep(realElapsed, 1);

// Representation
public function toString() return 'Timestep: $elapsed'; 

}
