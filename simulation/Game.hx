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
	
// Max time between each render event
private static inline var RENDER_MAX_ELAPSED = 15 / 60;

// Last render time
private static var lastRenderTime: FastFloat;

// Amount of times to update each render event
public static var updatesPerRender: Int;

// Current scene
@:allow(bogen.input.InputManager)
private static var scene: Scene;

// Canvas
public static var canvas: Canvas;

// Time passed between each render
private static var timeStep: TimeStep;

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
	timeStep = new TimeStep(0, 1);
	
	Game.updatesPerRender = updatesPerRender;
	
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
			
			// Updates the last render time and resets the schedule
			function updateLastRenderTime()
			{
				Scheduler.resetTime();
				lastRenderTime = getCurrentTime();
			}
			
			System.notifyOnApplicationState
			(
				updateLastRenderTime, updateLastRenderTime,
				null, null, null
			);
			
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
			
			// Update the last render time as late as possible
			lastRenderTime = getCurrentTime();
			
		});
	}
	
	// Initialize Kha
	System.init
		({ title: title, width: screenWidth, height: screenHeight }, onInit);
}

// Called by Kha to draw
public static function onRender(framebuffer: Framebuffer)
{
	var time = getCurrentTime();
	
	// Time between calls
	var renderElapsed = time - lastRenderTime;
	if (renderElapsed > RENDER_MAX_ELAPSED) renderElapsed = RENDER_MAX_ELAPSED;
	lastRenderTime = time;
	
	// Update scene
	timeStep.set(renderElapsed  / updatesPerRender, 1);
	for (_ in 0...updatesPerRender) scene.onUpdate(timeStep);
	
	// Initialize buffer
	canvas.beginBuffer(framebuffer);
	
	// Draw scene
	timeStep.set(renderElapsed, 1);
	scene.onDraw(canvas, timeStep);
	
	// Draw debug information
	InputManager.drawPointer(canvas);
	
	// Update screen and finishes buffer
	canvas.endBuffer();
}

// Current time
private static inline function getCurrentTime()
{
	var time = Scheduler.time();
	if (time > 15) return time;
	return Scheduler.realTime();
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
