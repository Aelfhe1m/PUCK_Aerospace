@lazyGlobal off.

runOncePath("0:/Lib/vesselUtils.ks").

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
