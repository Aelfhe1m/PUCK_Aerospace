runOncePath("0:/Lib/launchUtils.ks").

PreLaunch().
CountDown(3).
Launch().
CoastToApoapsis().
PRINT "Detatch core for recovery".
STAGE.
WaitForLanding().