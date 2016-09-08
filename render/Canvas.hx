package bogen.render;

import bogen.math.Angle;
import bogen.utils.Device;
import kha.Assets;
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

// Scale and center transformations
private var scaleTransformation: FastMatrix3;
private var centerTransformation: FastMatrix3;

// Banner's height
private var bannerHeight: FastFloat;

// Shortcut to g2
public var graphic(default, null): Graphics;

// Scale of the window/canvas
public var scale(default, null): FastFloat;

// Canvas' size
public var canvasWidth(default, null): FastFloat;
public var canvasHeight(default, null): FastFloat;

// Constructor
public inline function new
(
	screenWidth: Int, screenHeight: Int,
	canvasWidth: FastFloat, canvasHeight: FastFloat,
	backgroundColor: Color
)
{
	this.backgroundColor = backgroundColor;
	
	createBackbufferTransformation
		(screenWidth, screenHeight, canvasWidth, canvasHeight);
	
	// Canvas' size
	this.canvasWidth = screenWidth / scale;
	this.canvasHeight = screenHeight / scale;
	
	// Banner's height
	#if (sys_android && !bogen_no_ads)
		bannerHeight = Device.dipToPixels(50) / scale;
	#else
		bannerHeight = 0;
	#end
}

// Setup scale and center based on window size
private inline function createBackbufferTransformation
(
	screenWidth: Int, screenHeight: Int,
	canvasWidth: FastFloat, canvasHeight: FastFloat
)
{
	var xratio = screenWidth / canvasWidth;
	var yratio = screenHeight / canvasHeight;
	
	var dx = .0;
	var dy = .0;
	
	if (xratio < yratio)
	{
		scale = xratio;
		dy = (screenHeight - scale * canvasHeight) / 2;
	}
	else
	{
		scale = yratio;
		dx = (screenWidth - scale * canvasWidth) / 2;
	}
	
	scaleTransformation = FastMatrix3.scale(scale, scale);
	centerTransformation = FastMatrix3.translation(dx / scale, dy / scale);
}

// Canvas' related position
public inline function left(dx: FastFloat) return dx;
public inline function top(dy: FastFloat) return dy;
public inline function right(dx: FastFloat, width: FastFloat)
	return canvasWidth - dx - width;
public inline function bottom(dy: FastFloat, height: FastFloat)
	return canvasHeight - bannerHeight - dy - height - bannerHeight;
public inline function hCenter(dx: FastFloat, width: FastFloat)
	return (canvasWidth - width) / 2 - dx;
public inline function vCenter(dy: FastFloat, height: FastFloat)
	return (canvasHeight - bannerHeight - height) / 2 - dy;

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
	graphic.popTransformation();
	graphic.end();
}

// Adds a centering matrix. Canvas will be drawn at the center of the screen
public inline function addCenterMatrix()
{
	graphic.pushTransformation
		(graphic.transformation.multmat(centerTransformation));
}

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
