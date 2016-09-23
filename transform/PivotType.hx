package bogen.transform;

// Pivot types
abstract PivotType(Float) from Float to Float
{

public static inline var START: PivotType = .0;
public static inline var CENTER: PivotType = .5;
public static inline var END: PivotType = 1.;

}
