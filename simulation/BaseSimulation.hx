package bogen.simulation;

import bogen.input.Input;
import bogen.render.Canvas;

// Simulation with basic handles
class BaseSimulation
{
	
// Called when the simulation should handle input
public function onInput(input: Input)
{
	// EMPTY
}

// Called when the simulation should update
public function onUpdate(timeStep: TimeStep): Void
{
	// EMPTY
}

// Called when the simulation should draw
public function onDraw(canvas: Canvas, timeStep: TimeStep): Void
{
	// EMPTY
}

}
