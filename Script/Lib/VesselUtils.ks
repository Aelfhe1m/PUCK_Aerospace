@LAZYGLOBAL OFF.

GLOBAL FUNCTION CurrentThrust {
    LOCAL engList is 1.
    LIST ENGINES IN engList.
    LOCAL totalThrust IS 0.
    FOR eng IN engList {
        SET totalThrust To totalThrust + eng:THRUST.
    }
    return totalThrust.
}

GLOBAL FUNCTION CurrentTWR {
    return CurrentThrust() / ( 9.81 * SHIP:MASS).
}



