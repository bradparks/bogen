package bogen.simulation;

import bogen.input.InputManager;
import bogen.render.Canvas;
import kha.Assets;
import kha.Color;
import kha.FastFloat;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;

// Topmost simulation. Has a single child scene
@:access(kha.System, kha.Scheduler)
class Game
{

// Current scene
@:allow(bogen.input.InputManager)
private static var scene: Scene;

// Update period
public static var updatePeriod: FastFloat;

// Canvas
public static var canvas: Canvas;

// Last render time
private static var lastRenderTime: FastFloat;

// Time passed between events
private static var renderStep: TimeStep;
private static var updateStep: TimeStep;

// Initialize
public static function init
(
	title: String,
	screenWidth: Int, screenHeight: Int,
	canvasWidth: FastFloat, canvasHeight: FastFloat,
	updatesPerRender: Int,
	backgroundColor: Color,
	onReady: Void->Void
)
{
	scene = new Scene();
	
	renderStep = new TimeStep(1 / 60, 1);
	updateStep = new TimeStep(renderStep.elapsed / updatesPerRender, 1);
	
	// Clears the screen
	System.notifyOnRender(function(framebuffer)
	{
		framebuffer.g2.begin(true, backgroundColor);
		framebuffer.g2.end();
	});
	
	// Called by Kha when the game is ready
	function onInit()
	{
		Assets.loadEverything(function()
		{
			// Removes the previous render notifier
			System.renderListeners.pop();
			
			// Canvas
			canvas = new Canvas
			(
				System.windowWidth(), System.windowHeight(),
				canvasWidth, canvasHeight,
				backgroundColor
			);
			
			InputManager.init(canvas.scale);
			System.notifyOnRender(onRender);
			
			// Callback
			if (onReady != null) onReady();
			
			// Updates the game
			Scheduler.resetTime();
			Scheduler.addTimeTask(onGameUpdate, 0, updateStep.elapsed);
			
			lastRenderTime = Scheduler.time();
		});
	}
	
	// Initialize Kha
	System.init
		({ title: title, width: screenWidth, height: screenHeight }, onInit);
}

// Called by Kha to update the game
public static function onGameUpdate() scene.onUpdate(updateStep);

// Called by Kha to draw
public static function onRender(framebuffer: Framebuffer)
{	
	// Initialize buffer
	canvas.beginBuffer(framebuffer);
	
	// Update render elapsed
	renderStep.set(Scheduler.time() - lastRenderTime, 1);
	lastRenderTime = Scheduler.time();
	
	// Draw scene
	scene.onDraw(canvas, renderStep);
	
	// Draw debug information
	InputManager.drawPointer(canvas);
	
	// Update screen and finishes buffer
	canvas.endBuffer();
}

// Count the objects in a simulation
public static function objectCount(simulation: BaseSimulation)
{
	var result = 1;
	
	var children: Array<BaseSimulation> = Reflect.field
		(simulation, "children");
	if (children == null) return result;
	
	for (child in children) result += objectCount(child);
	return result;
}

// Set the current scene
public static inline function setScene(scene: Scene) Game.scene = scene;

}
