// Zombie sounding rocket; SRB booster; Expendable
runOncePath("0:/Lib/launchUtils.ks").

PARAMETER targetAp IS 80_000.

LOCAL phase IS 0.

// monitor for premature engine failure
WHEN (phase = 1 AND SHIP:apoapsis < targetAp) THEN {
    IF CurrentTWR() < 1 {
        PRINT "Flight failed - aborting".
        v0:play(n1).
        WAIT 1.
        ABORT ON.
        return false.
    }
    ELSE {
        return true.
    }
}

PreLaunch().
CountDown(3).
Launch().
SET phase TO 1.
CoastToApoapsis().
EndExpendableFlight().
