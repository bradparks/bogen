package bogen.simulation;

import bogen.input.Input;
import bogen.render.Canvas;
import kha.Key;

class Scene extends Simulation
{
	
#if debug

// Pauses the scene
private var pause: Bool;

// Should the game step a frame?
private var updateStep: Bool;
private var renderStep: Bool;

// Constructor
public function new()
{
	super();
	
	pause = false;
	
	updateStep = false;
	renderStep = false;
}

// Input
override public function onInput(input: Input) 
{
	if (input.keyType == Key.ENTER) pause = !pause;
	else if (input.keyType == Key.CTRL)
	{
		updateStep = renderStep = true;
		pause = true;
	}
	
	super.onInput(input);
}

// Update
override public function onUpdate(timeStep: TimeStep)
{
	if (pause && !updateStep) timeStep = new TimeStep(0, 0);
	updateStep = false;
	super.onUpdate(timeStep);
}

// Draw
override public function onDraw(canvas: Canvas, timeStep: TimeStep)
{
	if (pause && !renderStep) timeStep = new TimeStep(0, 0);
	renderStep = false;
	super.onDraw(canvas, timeStep);
}

#end
	
}
