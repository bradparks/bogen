package bogen;

import bogen.input.InputManager;
import bogen.render.Camera;
import bogen.simulation.TimeStep;
import kha.Assets;
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
public static var updatePeriod: Float;

// Last render time
private static var lastRenderTime: Float;

// Time passed between events
private static var renderStep: TimeStep;
private static var updateStep: TimeStep;

// Initialize
public static function init
(
	title: String,
	screenWidth: Int, screenHeight: Int,
	cameraWidth: Int, cameraHeight: Int,
	onReady: Void->Void
)
{
	scene = new Scene();
	
	renderStep = new TimeStep(1 / 60, 1);
	updateStep = new TimeStep(renderStep.elapsed, 1);
	
	// Called by Kha when the game is ready
	function onInit()
	{
		Assets.loadEverything(function()
		{
			// Camera
			var camera = new Camera
			(
				System.windowWidth(), System.windowHeight(),
				cameraWidth, cameraHeight
			);
			
			InputManager.init(camera.transform);
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
	var camera = Camera.main;
	
	// Initialize buffer
	camera.beginBuffer(framebuffer);
	
	// Update render elapsed
	renderStep.set(Scheduler.time() - lastRenderTime, 1);
	lastRenderTime = Scheduler.time();
	
	// Draw scene
	scene.onDraw(camera, renderStep);
	
	// Draw debug information
	InputManager.drawPointer(camera);
	
	// Update screen and finishes buffer
	camera.endBuffer();
}

// Set the current scene
public static inline function setScene(scene: Scene) Game.scene = scene;

}
