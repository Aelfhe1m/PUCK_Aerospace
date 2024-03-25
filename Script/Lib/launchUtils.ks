@LAZYGLOBAL OFF.

runOncePath("0:/Lib/helpers.ks").
runOncePath("0:/Lib/flightLog.ks").
runOncePath("0:/Lib/vesselUtils.ks").
//runOncePath("0:/Lib/timeUtils.ks").

GLOBAL loc IS SHIP:geoposition.
// GLOBAL lt IS time.

GLOBAL Function CountdownWithSpoolup {
    PARAMETER s IS 3.
    PARAMETER twr IS 1.3.

    CountDown(s).

    PRINT "Spooling up".
    WAIT UNTIL CurrentTWR() > twr.
    STAGE.
    Launch().
        
//    SET lt TO time.
}

GLOBAL v0 TO getVoice(0).
GLOBAL n0 TO NOTE(480, 0.1).
GLOBAL n1 TO NOTE(720, 0.5).

GLOBAL FUNCTION PreLaunch {
    CLEARSCREEN.
    PRINT " ".
    PRINT " ".
    PRINT SHIP:name + " ready to launch.".
    WAIT 2.
}

GLOBAL FUNCTION CountDown {
    PARAMETER s IS 3.

    SAS OFF.
    LOCK STEERING TO UP + R(0, 0, 180).
    LOCK THROTTLE TO 1.

    FROM {LOCAL i is s.} UNTIL i = 0 STEP {SET i to i - 1.} DO {
        PRINT "T: -" + i AT (30,0).
        v0:PLAY(n0).
        WAIT 1.
    }

    PRINT "Ignition.".
    STAGE.
    WAIT 0.1.
    PRINT "      " AT (30,0). // clear message
}

GLOBAL FUNCTION Launch {
    PRINT "Liftoff!".
    v0:PLAY(n1).
}

GLOBAL FUNCTION DeployFairings {
    PRINT "Jettisoning fairings".
    DoFairingSep().
}

GLOBAL FUNCTION CoastToApoapsis {
    PARAMETER doTimeWarp IS TRUE.
    IF doTimeWarp {
        SET KUNIVERSE:TIMEWARP:MODE TO "PHYSICS".
        SET KUNIVERSE:TIMEWARP:WARP to 4.
    }
    WAIT UNTIL SHIP:verticalspeed < 0. // wait until apogee
    Message("Max altitude :  " + FormatKm(SHIP:altitude), true).
}

GLOBAL FUNCTION WaitForLanding {
    WAIT UNTIL SHIP:Status = "LANDED" OR SHIP:status = "SPLASHED".
    Message("Downrange    :  " + FormatKm(loc:distance), true).
}

GLOBAL FUNCTION EndExpendableFlight {
    // drop below 20km to allow science transmit.
    WAIT UNTIL SHIP:altitude < 20_000. 
    WAIT 2. // add 2 seconds final delay

    AfterFlightReport().
    PRINT " ".
    PRINT "About to abort".
    KUNIVERSE:PAUSE. // wait for user to unpause game after reading messages

    // trigger range safety to destroy vessel.
    ABORT ON.
}

GLOBAL FUNCTION AfterFlightReport {
    KUNIVERSE:TIMEWARP:CANCELWARP().
    CLEARSCREEN.

    PRINT "Flight complete".
    PRINT " ".
    flReport().
    PRINT "MET         :  T+ " + TIME(MISSIONTIME):CLOCK.
}
