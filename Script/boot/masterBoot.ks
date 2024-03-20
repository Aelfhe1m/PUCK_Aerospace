IF (STATUS = "PRELAUNCH") {
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
    SWITCH TO 0.
}

CLEARSCREEN.
SET Terminal:CHARHEIGHT to 18.
RunPath(core:tag).
