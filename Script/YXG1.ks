// Launch the Yeti IV XG-1 early orbital rocket
// gives control of ascent to MechJeb PVG - you should pre-configure the PVG settings in
// test before enabling this script

runOncePath("0:/Lib/launchUtils.ks").

CountDown(5).

SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 1.
WAIT 0.3.
// enable MechJeb PVG using action group 
// (MUST BE PRECONFIGURED IN A TEST FLIGHT OF A ROCKET WITH THE SAME NAME)
AG2 ON.
WAIT 2. // slight delay to let it initialise
// STAGE. // start main engine - mechjeb handles most of the rest from here
        // with a little help from a Smart Part

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Close Terminal").