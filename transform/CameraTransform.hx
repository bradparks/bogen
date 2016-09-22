package bogen.transform;

// Camera's transform
@:allow(bogen.render.Camera)
class CameraTransform extends Transform
{

// Camera scale
public var cameraScale(default, null): Float;

// Constructor
private function new(width: Float, height: Float, cameraScale: Float)
{
	super(0, 0, width / cameraScale, height / cameraScale);
	this.cameraScale = cameraScale;
}

}
