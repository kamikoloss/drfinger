class_name LaneType
extends Object

const Type := {
    NONE = "_N",
    CLICK = "_C",
    CYMBAL_CRASH_1 = "C1",
    CYMBAL_CRASH_2 = "C2",
    CYMBAL_RIDE = "CR",
    HIHAT = "HH",
    KICK = "KC",
    SNARE = "SN",
    TOM_FLOOR = "T1",
    TOM_HIGH = "T2",
    TOM_LOW = "T3",
}

const COLORS: Dictionary[String, Color] = {
    Type.NONE:              Color("333333"),
    Type.CLICK:             Color("CCCCCC"),
    Type.CYMBAL_CRASH_1:    Color("0000FF"),
    Type.CYMBAL_CRASH_2:    Color("0000FF"),
    Type.CYMBAL_RIDE:       Color("6633FF"),
    Type.HIHAT:             Color("00FFFF"),
    Type.KICK:              Color("FF00FF"),
    Type.SNARE:             Color("FFFF00"),
    Type.TOM_FLOOR:         Color("FF6600"),
    Type.TOM_HIGH:          Color("00FF00"),
    Type.TOM_LOW:           Color("FF0000"),
}
