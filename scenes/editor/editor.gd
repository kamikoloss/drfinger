extends Control

enum GridType {
    GRID_16,
    GRID_24,
    GRID_32,
}

# TODO: Drum, MPC
const LANE_TYPES: Array[LaneType.Type] = [
    LaneType.Type.CYMBAL_CRASH,
    LaneType.Type.HIHAT,
    LaneType.Type.SNARE,
    LaneType.Type.KICK,
    LaneType.Type.TOM_HIGH,
    LaneType.Type.TOM_LOW,
    LaneType.Type.TOM_FLOOR,
    LaneType.Type.CYMBAL_RIDE,
]

const GRID_LABELS: Dictionary[GridType, String] = {
    GridType.GRID_16: "1/16",
    #GridType.GRID_24: "1/24",
    #GridType.GRID_32: "1/32",
}

@export var _measure_scene: PackedScene
@export var _note_scene: PackedScene

var _current_measure: Measure = null
var _current_lane: Measure = null

@onready var _scroll_container: ScrollContainer = %ScrollContainer
@onready var _measures_parent: Control = %MeasuresParent
# UI
@onready var _line_edit_bpm: LineEdit = %LineEditBpm
@onready var _option_button_grid: OptionButton = %OptionButtonGrid


func _ready() -> void:
    # Measure 初期化
    var measure_count := 64 # TODO
    for i in (measure_count + 1):
        var measure: Measure = _measure_scene.instantiate()
        measure.index = measure_count - i
        measure.lane_types = LANE_TYPES
        measure.hover_entered.connect(func(lane: Lane) -> void: _on_measure_hover_entered(measure, lane))
        measure.hover_exited.connect(func(lane: Lane) -> void: _on_measure_hover_exited(measure, lane))
        measure.pressed.connect(func(lane: Lane, pos: Vector2) -> void: _on_measure_pressed(measure, lane, pos))
        _measures_parent.add_child(measure)
    # スクロールを一番下へ
    #_scroll_container.set_deferred("scroll_vertical", _scroll_container.get_v_scroll_bar().max_value) # 動かん
    _scroll_container.set_deferred("scroll_vertical", 99999999)

    # UI - Grid
    for grid_type in GRID_LABELS:
        _option_button_grid.add_item(GRID_LABELS[grid_type], grid_type)
    _option_button_grid.selected = GridType.GRID_16 # TODO


func _input(event: InputEvent) -> void:
    pass


func _on_measure_pressed(measure: Measure, lane: Lane, pos: Vector2) -> void:
    print("[Editor] _on_measure_pressed() index: %s, lane_type: %s, pos: %s" % [measure.index, LaneType.Type.keys()[lane.lane_type], pos])


func _on_measure_hover_entered(measure: Measure, lane: Lane) -> void:
    print("[Editor] _on_measure_hover_entered()")


func _on_measure_hover_exited(measure: Measure, lane: Lane) -> void:
    print("[Editor] _on_measure_hover_exited()")
