// downrange spin stabalised
// stage separation timing handled by smart parts

runOncePath("0:/Lib/launchUtils.ks").
runOncePath("0:/Lib/ascent.ks").

PARAMETER desiredHeading IS 90.

CountdownWithSpoolup(5, 1.5).
WAIT UNTIL SHIP:VELOCITY:SURFACE:MAG > 50.

// targetheading, startvel, initialpitch, targetdefl, emdangle
AlternativeAscent(desiredHeading, 50, 10, -2, 45).

PRINT "Beginning unguided gravity turn and automated staging.".

CoastToApoapsis(false).
PRINT "How far will we get?".
WAIT UNTIL altitude < 140_000.

// monitor for part count decreasing because reentry heat is blowing parts up (core shouldn't be first)
LOCAL initialCount IS SHIP:PARTS:LENGTH.
WAIT UNTIL SHIP:PARTS:LENGTH < initialCount.
AfterFlightReport().

WAIT 100. // add 100 seconds final delay to let vessel finish blowing up after script resumes.

// ============================

FUNCTION DetatchReturnCapsule {
    LOCAL payload IS SHIP:partstagged("Payload")[0].
    payload:getmodule("ModuleDecouple"):doevent("Decouple").
    wait 10.
    STAGE. // arm chutes.
}

// long wait to stop script terminating
wait 6000.

