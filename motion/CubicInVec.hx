package bogen.motion;

import kha.FastFloat;

class CubicInVec extends MotionVec
{

// Tween function
override public function tween(t: FastFloat) return t * t * t;

}
