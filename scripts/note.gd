class_name Note
extends RefCounted

var lane_type := LaneType.Type.NONE
var tick := 0
# TODO: Velocity


func _init(lane_type_: String, tick_: int) -> void:
    lane_type = lane_type_
    tick = tick_


func serialize() -> Dictionary:
    return {
        "l": lane_type,
        "t": tick,
    }


static func deserialize(dict: Dictionary) -> Note:
    return new(dict["l"], dict["t"])
