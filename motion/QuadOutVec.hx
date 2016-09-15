package bogen.motion;

import kha.FastFloat;

class QuadOutVec extends MotionVec
{

// Tween function
override public function tween(t: FastFloat) return -t * (t - 2);

}
