package bogen.render;

import bogen.transform.CameraTransform;
import bogen.transform.Transform;
import bogen.utils.Device;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.graphics2.ImageScaleQuality;
import kha.math.FastMatrix3;

// Camera. Performes all drawing operations
class Camera
{
	
// Main camera
public static var main(default, null): Camera = null;

// Camera's transform
public var transform(default, null): CameraTransform;

// Shortcut to g2
public var graphic(default, null): Graphics;

// Constructor
public function new
	(screenWidth: Int, screenHeight: Int, targetWidth: Int, targetHeight: Int)
{
	if (main == null) main = this;
	
	createTransformation(screenWidth, screenHeight, targetWidth, targetHeight);
	
	// Banner's height
	#if (sys_android && !bogen_no_ads)
		transform.size.height -= Device.dipToPixels(50);
	#end
}

// Setup scale based on window size
private inline function createTransformation
	(screenWidth: Int, screenHeight: Int, targetWidth: Int, targetHeight: Int)
{
	var xratio = screenWidth / targetWidth;
	var yratio = screenHeight / targetHeight;
	
	var dx = .0;
	var dy = .0;
	
	var scale;
	
	if (xratio < yratio)
	{
		scale = xratio;
		dy = (screenHeight - scale * targetHeight) / 2 / scale;
	}
	else
	{
		scale = yratio;
		dx = (screenWidth - scale * targetWidth) / 2 / scale;
	}
	
	// Game transformation
	transform = new CameraTransform(screenWidth, screenHeight, scale);
}

// Initialize camera bufffer
@:allow(bogen.Game)
private inline function beginBuffer(framebuffer: Framebuffer)
{
	graphic = framebuffer.g2;
	graphic.imageScaleQuality = ImageScaleQuality.High;
	
	var scale = transform.cameraScale;
	var position = transform.position;
	
	graphic.pushTransformation
	(
		FastMatrix3.scale(scale, scale)
		.multmat(FastMatrix3.translation(-position.x, -position.y))
	);
	graphic.begin(false);
}

// End camera bufffer
@:allow(bogen.Game)
private inline function endBuffer()
{	
	graphic.popTransformation();
	graphic.end();
}

// Setup a drawing
public inline function setupDraw(transform: Transform)
{
	// Color
	graphic.color = transform.color;
	
	// Rotation
	if (transform.angle != 0)
	{
		var position = transform.position;
		
		var matrix = graphic.transformation
			.multmat(FastMatrix3.translation(position.x, position.y))
			.multmat(FastMatrix3.rotation(transform.angle))
			.multmat(FastMatrix3.translation(-position.x, -position.y));
		
		graphic.pushTransformation(matrix);
	}
}

// Clean up after drawing
public inline function cleanupDraw(transform: Transform)
	if (transform.angle != 0) graphic.popTransformation();

// Draw a frame
public function draw(frame: Frame, transform: Transform)
{
	setupDraw(transform);
	
	graphic.drawScaledSubImage
	(
		frame.sheet,
		frame.x, frame.y, frame.width, frame.height,
		transform.left(), transform.top(),
		transform.width(), transform.height()
	);
	
	cleanupDraw(transform);
}

// Draw a rectangle
public function drawRect(transform: Transform, strength: Float)
{
	setupDraw(transform);
	
	graphic.drawRect
	(
		transform.left(), transform.top(),
		transform.width(), transform.height(), strength
	);
	
	cleanupDraw(transform);
}

// Draw a filled rectangle
public function drawFill(transform: Transform)
{
	setupDraw(transform);
	
	graphic.fillRect
	(
		transform.left(), transform.top(),
		transform.width(), transform.height()
	);
	
	cleanupDraw(transform);
}

// Draw a rect with fixed strength
public inline function drawRectFixedStrength
	(transform: Transform, strength: Float)
	drawRect(transform, strength / this.transform.cameraScale);

}
