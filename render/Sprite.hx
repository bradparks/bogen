package bogen.render;

import bogen.component.Component;
import bogen.transform.PivotType;
import bogen.transform.Transform;

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
	parentPivotX = PivotType.START, parentPivotY = PivotType.START,
	pivotX = PivotType.START, pivotY = PivotType.START
)
{
	if (parentTransform == null) parentTransform = Camera.main.transform;
	
	return new Sprite
	(
		frame, 
		parentTransform.child
		(
			x, y, frame.width, frame.height,
			parentPivotX, parentPivotY, 0,
			pivotX, pivotY
		)
	);
}

}
