package bogen.transform;

import bogen.math.Size;
import bogen.math.Vec;
import bogen.render.Camera;
import bogen.render.RectSprite;
import bogen.simulation.Simulation;
import kha.Color;

// Transform
class Transform
{
	
// Position
public var position: Vec;

// Size
public var size: Size;

// Rotation angle in radians
public var angle: Float;

// Pivot for rotation and scaling in percent of size
public var pivot: Vec;

// Scale in percent of size
public var scale: Vec;

// Color to tint
public var color: Color;

/*
 * Constructor.
 * Generally you should use the `child` method of Camera.main.transform or other
 * transform to create one. */
private function new
(
	x: Float, y: Float, width: Float, height: Float,
	angle: Float = 0,
	pivotX: Float = PivotType.START, pivotY: Float = PivotType.START,
	scaleX: Float = ScaleType.NORMAL, scaleY: Float = ScaleType.NORMAL,
	color: Color = 0xffffffff
)
{
	position = new Vec(x, y);
	size = new Size(width, height);
	this.angle = angle;
	pivot = new Vec(pivotX, pivotY);
	scale = new Vec(scaleX, scaleY);
	this.color = color;
}
	
// Sizes. Won't take rotation into account
public inline function width() return size.width * scale.x;
public inline function height() return size.height * scale.y;

// Positions. Won't take rotation into account
public inline function left()
	return position.x - scale.x * pivot.x * size.width;
public inline function top()
	return position.y - scale.y * pivot.y * size.height;
	
public inline function horizontal(pivot: Float)
	return left() + pivot * width();
public inline function vertical(pivot: Float)
	return top() + pivot * height();
	
public inline function right() return horizontal(PivotType.END);
public inline function bottom() return vertical(PivotType.END);

public inline function horizontalCenter() return horizontal(PivotType.CENTER);
public inline function verticalCenter() return vertical(PivotType.CENTER);

// Check if a point collide with the transform. Won't take rotation into account
public function collidePoint(x: Float, y: Float)
	return x >= left() && x <= right() && y >= top() && y <= bottom();
	
// Copy
public function copy()
{
	return new Transform
	(
		position.x, position.y, size.width, size.height,
		angle, pivot.x, pivot.y, scale.x, scale.y, color
	);
}

// Draw a debug rectangle
public inline function drawDebug(camera: Camera)
{
	#if (debug && bogen_debug_rect)
		camera.drawRectFixedStrength(this, 1);
	#end
}

// Create a debug rectangle and add it to the provided simulation
public inline function createDebugRect(parent: Simulation)
{
	#if (debug && bogen_debug_rect)
		parent.add(new RectSprite(this, 1 / Camera.main.transform.cameraScale));
	#end
}

// Create a child transform positioned at the parent's pivot
@SuppressWarnings("checkstyle:ParameterNumber")
public inline function child
(
	x: Float, y: Float, width: Float, height: Float,
	parentPivotX: Float = PivotType.START,
	parentPivotY: Float = PivotType.START,
	angle: Float = 0,
	pivotX: Float = PivotType.START, pivotY: Float = PivotType.START,
	scaleX: Float = ScaleType.NORMAL, scaleY: Float = ScaleType.NORMAL,
	color: Color = 0xffffffff
)
{
	return new Transform
	(
		horizontal(parentPivotX) + x, vertical(parentPivotY) + y,
		width, height,
		angle, pivotX, pivotY, scaleX, scaleY, color
	);
}

}
