@LAZYGLOBAL OFF.

GLOBAL fLog IS LIST().

GLOBAL FUNCTION Message {
    PARAMETER m.
    PARAMETER persist IS FALSE.

    PRINT m.
    IF persist { fLog:add(m). }
}

GLOBAL FUNCTION flReport {
    FOR m IN fLog {
        PRINT m.
    }
}