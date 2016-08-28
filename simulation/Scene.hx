package bogen.simulation;

import bogen.input.Input;
import bogen.render.Canvas;
import kha.Key;

class Scene extends Simulation
{
	
#if debug

// Pauses the scene
private var pause: Bool;

// Constructor
public function new()
{
	super();
	pause = false;
}

// Input
override public function onInput(input: Input) 
{
	if (input.keyType == Key.ENTER) pause = !pause;
	super.onInput(input);
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	if (pause) timeStep = new TimeStep(0, 0);
	super.onUpdate(timeStep);
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	if (pause) timeStep = new TimeStep(0, 0);
	super.onDraw(canvas, timeStep);
}

#end
	
}
