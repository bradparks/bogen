package bogen.render;

import bogen.math.Angle;
import bogen.types.Vec;
import bogen.utils.Device;
import kha.Color;
import kha.FastFloat;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.graphics2.ImageScaleQuality;
import kha.math.FastMatrix3;

class Canvas
{

// Background color
private var backgroundColor: Color;

// Scale transformation
private var scaleTransformation: FastMatrix3;

// Canvas' offset from window
public var centerOffset: Vec;

// Banner's height
public var bannerHeight(default, null): FastFloat;

// Shortcut to g2
public var graphic(default, null): Graphics;

// Scale of the window/canvas
public var scale(default, null): FastFloat;

// Target canvas' size
public var targetCanvasWidth(default, null): FastFloat;
public var targetCanvasHeight(default, null): FastFloat;

// Canvas' size
public var canvasWidth(default, null): FastFloat;
public var canvasHeight(default, null): FastFloat;

// Constructor
public inline function new
(
	screenWidth: Int, screenHeight: Int,
	targetCanvasWidth: FastFloat, targetCanvasHeight: FastFloat,
	backgroundColor: Color
)
{
	this.backgroundColor = backgroundColor;
	
	this.targetCanvasWidth = targetCanvasWidth;
	this.targetCanvasHeight = targetCanvasHeight;
	
	createTransformations(screenWidth, screenHeight);
	
	// Banner's height
	#if (sys_android && !bogen_no_ads)
		bannerHeight = Device.dipToPixels(50) / scale;
	#else
		bannerHeight = 0;
	#end
}

// Setup scale and center based on window size
private inline function createTransformations
	(screenWidth: Int, screenHeight: Int)
{
	var xratio = screenWidth / targetCanvasWidth;
	var yratio = screenHeight / targetCanvasHeight;
	
	var dx = .0;
	var dy = .0;
	
	if (xratio < yratio)
	{
		scale = xratio;
		dy = (screenHeight - scale * targetCanvasHeight) / 2 / scale;
	}
	else
	{
		scale = yratio;
		dx = (screenWidth - scale * targetCanvasWidth) / 2 / scale;
	}
	
	// Canvas' size
	canvasWidth = screenWidth / scale;
	canvasHeight = screenHeight / scale;
	
	// Scale transformation
	scaleTransformation = FastMatrix3.scale(scale, scale);
	centerOffset = new Vec(dx, dy);
}

// Initialize canvas to draw
@:allow(bogen.simulation.Game)
private inline function beginBuffer(framebuffer: Framebuffer)
{
	graphic = framebuffer.g2;
	
	graphic.imageScaleQuality = ImageScaleQuality.High;
	
	graphic.pushTransformation(scaleTransformation);
	
	graphic.begin(true, backgroundColor);
}

// End canvas
@:allow(bogen.simulation.Game)
private inline function endBuffer()
{
	#if debug
		graphic.pushTransformation(FastMatrix3.scale(scale, scale));
		var banner = 100;
		drawFill
		(
			0, canvasHeight - banner,
			canvasWidth, banner,
			0xff947f7c
		);
		graphic.popTransformation();
	#end
	
	graphic.popTransformation();
	graphic.end();
}

// Positions related to the screen
public inline function screenLeft() return 0;
public inline function screenRight(width: FastFloat) return canvasWidth - width;
public inline function screenTop() return 0;
public inline function screenBottom(height: FastFloat)
	return canvasHeight - bannerHeight - height;
public inline function screenHCenter(width: FastFloat)
	return (canvasWidth - width) / 2;
public inline function screenVCenter(height: FastFloat)
	return (canvasHeight - bannerHeight - height) / 2;
	
// Positions related to the canvas
public inline function canvasLeft() return centerOffset.x;
public inline function canvasTop() return centerOffset.y;

// Draw a frame with the specified size
public inline function drawResized
(
	frame: Frame,
	x: FastFloat, y: FastFloat,
	width: FastFloat, height: FastFloat
)
{
	graphic.drawScaledSubImage
	(
		frame.sheet,
		frame.x, frame.y, frame.width, frame.height,
		x, y, width, height
	);
}

// Draw a frame with the specified size in low quality to avoid blurriness
public inline function drawResizedLowQuality
(
	frame: Frame,
	x: FastFloat, y: FastFloat,
	width: FastFloat, height: FastFloat
)
{
	graphic.imageScaleQuality = ImageScaleQuality.Low;
	drawResized(frame, x, y, width, height);
	graphic.imageScaleQuality = ImageScaleQuality.High;
}

// Draw a frame
public inline function draw(frame: Frame, x: FastFloat, y: FastFloat)
{
	graphic.drawSubImage
		(frame.sheet, x, y, frame.x, frame.y, frame.width, frame.height);
}

// Add a rotation matrix
public inline function addRotationMatrix
	(centerX: FastFloat, centerY: FastFloat, angle: FastFloat)
{
	graphic.pushTransformation
	(
		graphic.transformation
		.multmat(FastMatrix3.translation(centerX, centerY))
		.multmat(FastMatrix3.rotation(Angle.rad(angle)))
		.multmat(FastMatrix3.translation(-centerX, -centerY))
	);
}

// Draw a frame rotate around a point with its pivot
public function drawRotatedAtPoint
(
	frame: Frame,
	pointX: FastFloat, pointY: FastFloat,
	width: FastFloat, height: FastFloat,
	pivotX: FastFloat, pivotY: FastFloat,
	angle: FastFloat
)
{
	addRotationMatrix(pointX, pointY, angle);
	drawResized(frame, pointX - pivotX, pointY - pivotY, width, height);
	graphic.popTransformation();
}

// Desenha a frame rotate at its center
public inline function drawRotatedAtCenter
	(frame: Frame, centerX: FastFloat, centerY: FastFloat, angle: FastFloat)
{
	drawRotatedAtPoint
	(
		frame,
		centerX, centerY,
		frame.width, frame.height,
		frame.width / 2, frame.height / 2,
		angle
	);
}

// Draw text
public inline function drawString
(
	text: Array<String>, fontSize: Int, color: Color,
	x: FastFloat, y: FastFloat
)
{
	graphic.fontSize = fontSize;
	
	var oldColor = graphic.color;
	graphic.color = color;
	
	var fontHeight = graphic.font.height(fontSize);
	
	for (line in text)
	{
		graphic.drawString(line, x, y);
		y += fontHeight;
	}
	
	graphic.color = oldColor;
}

// Draws a rectangle with fixed border thickness
public inline function drawFixedRectangle
(
	x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat,
	strength: Int = 1, color = 0xffffffff
)
{
	var oldColor = graphic.color;
	graphic.color = color;
	graphic.drawRect(x, y, width, height, strength / scale);
	graphic.color = oldColor;
}

// Draw a debug rectangle
public inline function drawDebugRectangle
(
	x: FastFloat, y: FastFloat, width: FastFloat, height: FastFloat,
	strength: Int = 1, color = 0xffffffff
)
{
	#if (debug && bogen_debug_rect)
	drawFixedRectangle(x, y, width, height, strength, color);
	#end
}

// Draw a filled rectangle
public inline function drawFill
(
	x: FastFloat, y: FastFloat,
	width: FastFloat, height: FastFloat,
	color: Color
)
{
	var oldColor = graphic.color;
	graphic.color = color;
	
	graphic.fillRect(x, y, width, height);
	
	graphic.color = oldColor;
}

}
