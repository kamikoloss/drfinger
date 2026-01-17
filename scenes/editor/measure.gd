class_name Measure
extends Control

@export var _lane_scene: PackedScene

var lane_types: Array[LaneType.Type] = [LaneType.Type.NONE]
var index := 0

@onready var _lanes_parent: HBoxContainer = $HBoxContainer
@onready var _label_index: Label = $LabelIndex


func _ready() -> void:
    for lane_type in lane_types:
        var lane: Lane = _lane_scene.instantiate()
        lane.lane_type = lane_type
        _lanes_parent.add_child(lane)
    _label_index.text = str(index)
