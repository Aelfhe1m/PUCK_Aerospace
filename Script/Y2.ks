// downrange spin stabalised
// stage separation timing handled by smart parts

runOncePath("0:/Lib/launchUtils.ks").
runOncePath("0:/Lib/ascent.ks").

PARAMETER desiredHeading IS 90.

CountdownWithSpoolup(5, 1.5).
WAIT UNTIL SHIP:VELOCITY:SURFACE:MAG > 50.

// targetheading, startvel, initialpitch, targetdefl, emdangle
AlternativeAscent(desiredHeading, 50, 10, -2, 45).

PRINT "Beginning unguided gravity turn".

WAIT UNTIL SHIP:availablethrust() < 0.5.
PRINT "Coasting".

CoastToApoapsis().
DetatchReturnCapsule().
WaitForLanding().
AfterFlightReport().
WAIT 10. // add 10 seconds final delay

// ============================

FUNCTION DetatchReturnCapsule {
    LOCAL payload IS SHIP:partstagged("Payload")[0].
    payload:getmodule("ModuleDecouple"):doevent("Decouple").
    wait 10.
    STAGE. // arm chutes.
}

// long wait to stop script terminating
wait 6000.

