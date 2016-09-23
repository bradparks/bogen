package bogen.render;

import bogen.component.Component;
import bogen.transform.RelativePivot;
import bogen.transform.ScaleType;
import bogen.transform.Transform;
import kha.Color;

class Sprite extends Component
{

// Frame to draw
public var frame: Frame;

// Transform
public var transform: Transform;

// Constructor
public function new(frame: Frame, transform: Transform)
{
	this.frame = frame;
	this.transform = transform;
}

// Draw
override public function onDraw(camera: Camera, _)
	camera.draw(frame, transform);

// Create a new sprite as a child of a transform
public static function create
(
	frame: Frame, x: Float, y: Float,
	?parentTransform: Transform,
	?pivot: RelativePivot,
	angle: Float = 0,
	scaleX = ScaleType.NORMAL, scaleY = ScaleType.NORMAL,
	color: Color = Color.White
)
{
	if (parentTransform == null) parentTransform = Camera.main.transform;
	if (pivot == null) pivot = RelativePivot.TOP_LEFT;
	
	return new Sprite
	(
		frame, 
		parentTransform.child
		(
			x, y, frame.width, frame.height,
			pivot, 0, scaleX, scaleY, color
		)
	);
}

}
