IF (STATUS = "PRELAUNCH") {
    CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
    SWITCH TO 0.
}
CLEARSCREEN.
SET Terminal:CHARHEIGHT to 18.
LOCAL mf IS core:tag.
IF mf:CONTAINS(",") {
    LOCAL mt IS mf:split(",").
    IF mt:length = 2 {runPath(mt[0], mt[1]:tonumber()).} else if mt:length = 3 {runPath(mt[0], mt[1]:tonumber(), mt[2]:tonumber()).}    
}
ELSE {RunPath(core:tag).}