// simple vertical launch script for Mendel: 1st Advanced Biological milestone

runOncePath("0:/Lib/launchUtils.ks").

LOCAL phase IS 0.

CountdownWithSpoolup(5).
LOCK STEERING TO UP.
LOCK THROTTLE TO 1.

// check for engine failure during ascent and abort to attempt to recover payload
WHEN phase = 0 AND verticalspeed < 0 THEN { 
    PRINT "Launch failure detected, detaching payload for recovery".
    ABORT ON. 
} 

// allow rocket to spin stabalise before unlocking steering
WAIT UNTIL verticalspeed > 400. 
UNLOCK STEERING.
PRINT "Spin stabalised. Unlocking steering control.".

WAIT UNTIL verticalSpeed > 2500 AND apoapsis > 450_000. // these should ensure 2200 m/s at 140 km
PRINT "Target velocity and apoapsis achieved".
SET phase to 1. // no longer need to monitor for abort
LOCK throttle TO 0.
SET WARPMODE TO "PHYSICS".
SET WARP TO 4.

WAIT UNTIL altitude > 140_000 AND verticalSpeed < 0. // wait until apoapsis
PRINT "Detaching payload for recovery".
// decouple ascent stage and arm parachutes
STAGE.
PRINT "Guidance program complete - shuting down".
SHUTDOWN.
