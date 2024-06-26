@lazyGlobal off.

runOncePath("0:/Lib/vesselUtils.ks").

// some sections of this script inspired by YouTube video by Mike Aben

// rewrite ascent to follow a better pitch program
// include parameters for vel. to start pitch, initial pitch, targetted deflection from prograde, 
// and end pitch target
// e.g for Yeti : 50m/s pitch down 10 deg., continue pitching down -2 deg until 45 deg. hold prograde

GLOBAL FUNCTION AlternativeAscent {
    PARAMETER targetHeading IS 90.
    PARAMETER startVel IS 50.
    PARAMETER initialPitch IS 10.
    PARAMETER targetDefl IS -2.
    PARAMETER endAngle IS 45.

    WAIT UNTIL SHIP:verticalspeed > startVel.
    LOCAL currentPitch IS 90 - initialPitch.
    // TODO: LOCAL targetVec IS 1.
    LOCK STEERING TO HEADING(targetHeading, currentPitch) + R(0,0,360-targetHeading).
    // TODO: LOCK targetVec TO HEADING(targetHeading, 45) + R(0,0,360-targetHeading).

    // TODO: wait until facing desired initial myPitch
    WAIT 5.
    // TODO: begin PID based pitch over

    UNLOCK STEERING.
}

GLOBAL FUNCTION PerformAscentBurn {
    PARAMETER desiredHeading IS 90.
    PARAMETER halfPitchedAlt IS 35_000.
    PARAMETER continuePitching IS false.

    SimplePitchManouevre(desiredHeading, halfPitchedAlt).
    gravityTurn(desiredHeading, halfPitchedAlt, continuePitching).
}

// SIMPLE PITCHING MANEUVER
GLOBAL FUNCTION SimplePitchManouevre {
    PARAMETER desiredHeading IS 90.
    PARAMETER halfPitchedAlt IS 35_000.
    PRINT " ". 
    PRINT "Starting pitching maneuver.".
    LOCAL initialHeading to myHeading(desiredHeading).
    LOCAL initialRoll to myRoll(desiredHeading).
    LOCK STEERING to HEADING(initialHeading, myPitch(halfPitchedAlt))+ R(0, 0, initialRoll).
    WAIT 2.
}

// ==== LOCAL FUNCTIONS ====

FUNCTION myRoll {
    PARAMETER desiredHeading.
    RETURN 360 - desiredHeading.
}

//Heading setting
FUNCTION myHeading {
    PARAMETER desiredHeading.
    RETURN desiredHeading.
}

// Pitch setting
FUNCTION myPitch { 
    PARAMETER halfPitchedAlt.
    RETURN 90*halfPitchedAlt / (ALTITUDE + halfPitchedAlt).
} 

FUNCTION gravityTurn {
    PARAMETER desiredHeading.
    PARAMETER lockingAlt IS 30_000.
    PARAMETER continuePitching is false.

    Local scriptMode to 1.

    UNTIL (VERTICALSPEED < 0 OR CurrentTWR() < 0.3) {
        IF (ALTITUDE > lockingAlt) AND scriptMode = 1 {
            lockToPrograde(desiredHeading, continuePitching).
            SET scriptMode To 2.
        }
        WAIT 0.1.
    }
}

FUNCTION lockToPrograde {
    PARAMETER desiredHeading.
    PARAMETER continuePitching is false.

    IF continuePitching = false {
        PRINT "Locking to prograde.".
        LOCK STEERING to SRFPROGRADE + R(0, 0, myRoll(desiredHeading)).
    }
}
