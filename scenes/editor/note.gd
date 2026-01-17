class_name Note
extends Node

enum Type {
    NONE,
    CLICK,
    CYMBAL_CRASH,
    CYMBAL_RIDE,
    HIHAT, # TODO: open, close, half
    KICK,
    SNARE,
    TOM_FLOOR,
    TOM_HIGH,
    TOM_LOW,
}

const NoteColors: Dictionary[Type, Color] = {
    Type.NONE:          Color("333333"),
    Type.CLICK:         Color("CCCCCC"),
    Type.CYMBAL_CRASH:  Color("0000FF"),
    Type.HIHAT:         Color("00FFFF"),
    Type.KICK:          Color("FF00FF"),
    Type.SNARE:         Color("FFFF00"),
    Type.TOM_FLOOR:     Color("FF0000"),
    Type.TOM_HIGH:      Color("00FF00"),
    Type.TOM_LOW:       Color("FF0000"),
}

var type := Type.NONE
