runOncePath("0:/Lib/launchUtils.ks").
runOncePath("0:/Lib/vesselUtils.ks").
runOncePath("0:/Lib/ascent.ks").

PARAMETER desiredHeading IS 0.
PARAMETER halfPitchedAlt IS 25_000. // Altitude at which pitch will be 45 degrees.

PreLaunch().

// auto eject fairing above 40km to expose camera.
// WHEN SHIP:altitude > 60_500 THEN {
//     DeployFairings().
// }

CountdownWithSpoolup(3).
PerformAscentBurn(desiredHeading, halfPitchedAlt).
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