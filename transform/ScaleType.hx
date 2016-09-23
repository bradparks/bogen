package bogen.transform;

// Pivot types
abstract ScaleType(Float) from Float to Float
{

public static inline var INVISIBLE: ScaleType = .0;
public static inline var NORMAL: ScaleType = 1.;

}
