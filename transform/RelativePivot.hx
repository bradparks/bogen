package bogen.transform;
import bogen.render.Camera;

// Pivot relative to another. Used to create child transforms
class RelativePivot
{

// Defaults
public static var TOP_LEFT = new RelativePivot(0, 0, 0, 0);
public static var TOP_CENTER = new RelativePivot(.5, 0, .5, 0);
public static var TOP_RIGHT = new RelativePivot(1, 0, 1, 0);

public static var CENTER_LEFT = new RelativePivot(0, .5, 0, .5);
public static var CENTER = new RelativePivot(.5, .5, .5, .5);
public static var CENTER_RIGHT = new RelativePivot(1, .5, 1, .5);

public static var BOTTOM_LEFT = new RelativePivot(0, 1, 0, 1);
public static var BOTTOM_CENTER = new RelativePivot(.5, 1, .5, 1);
public static var BOTTOM_RIGHT = new RelativePivot(1, 1, 1, 1);

public static var START = TOP_LEFT;
public static var START_CENTER = new RelativePivot(0, 0, .5, .5);
public static var START_END = new RelativePivot(0, 0, 1, 1);

public static var CENTER_START = new RelativePivot(.5, .5, 0, 0);
public static var CENTER_END = new RelativePivot(.5, .5, 1, 1);

public static var END_START = new RelativePivot(1, 1, 0, 0);
public static var END_CENTER = new RelativePivot(1, 1, .5, .5);
public static var END = BOTTOM_RIGHT;

// Parent pivot
public var parentPivotX: PivotType;
public var parentPivotY: PivotType;

// Pivot
public var pivotX: PivotType;
public var pivotY: PivotType;
	
// Constructor
public inline function new
(
	parentPivotX: PivotType, parentPivotY: PivotType,
	pivotX: PivotType, pivotY: PivotType
)
{
	this.parentPivotX = parentPivotX;
	this.parentPivotY = parentPivotY;
	
	this.pivotX = pivotX;
	this.pivotY = pivotY;
}

// Representation
public function toString()
{
	function pivotName(pivot: Float)
	{
		return switch (pivot)
		{
			case 0: "start";
			case .5: "center";
			case 1: "end";
			default: '$pivot';
		}
	}
	
	return "RelativePivot("
		+ '${ pivotName(parentPivotX) }, ${ pivotName(parentPivotY) }, '
		+ '${ pivotName(pivotX) }, ${ pivotName(pivotY) }'
		+ ")";
}

}
