class_name Note
extends RefCounted

var lane_type := LaneType.Type.NONE
var ticks := 0


func _init(lane_type_: LaneType.Type, ticks_: int) -> void:
    lane_type = lane_type_
    ticks = ticks_
