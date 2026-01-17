class_name Measure
extends Control

## Lane ホバー開始時
signal hover_entered(lane: Lane)
## Lane ホバー終了時
signal hover_exited(lane: Lane)
## Lane クリック時
signal pressed(lane: Lane, pos: Vector2)

@export var _lane_scene: PackedScene

var lane_types: Array[LaneType.Type] = [LaneType.Type.NONE]
var index := 0

@onready var _lanes_parent: HBoxContainer = $HBoxContainer
@onready var _label_index: Label = $LabelIndex


func _ready() -> void:
    for lane_type in lane_types:
        var lane: Lane = _lane_scene.instantiate()
        lane.lane_type = lane_type
        lane.hover_entered.connect(func() -> void: hover_entered.emit(lane))
        lane.hover_exited.connect(func() -> void: hover_exited.emit(lane))
        lane.pressed.connect(func(pos: Vector2) -> void: pressed.emit(lane, pos))
        _lanes_parent.add_child(lane)

    _label_index.text = str(index)
