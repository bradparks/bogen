package bogen;

import bogen.input.Input;
import bogen.render.Camera;
import bogen.simulation.Simulation;
import bogen.simulation.TimeStep;
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
	var keyType = input.keyType.orNull();
	
	if (keyType != null)
	{
		if (keyType == Key.ENTER) pause = !pause;
		else if (keyType == Key.CTRL)
		{
			updateStep = renderStep = true;
			pause = true;
		}
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
override public function onDraw(camera: Camera, timeStep: TimeStep)
{
	if (pause && !renderStep) timeStep = new TimeStep(0, 0);
	renderStep = false;
	super.onDraw(camera, timeStep);
}

#end
	
}
