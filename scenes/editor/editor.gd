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

@onready var _scroll_container: ScrollContainer = %ScrollContainer
@onready var _measures_parent: Control = %MeasuresParent
# UI
@onready var _line_edit_bpm: LineEdit = %LineEditBpm
@onready var _option_button_grid: OptionButton = %OptionButtonGrid


func _ready() -> void:
    # Measure 配置
    var measure_count := 64
    for i in (measure_count + 1):
        var measure: Measure = _measure_scene.instantiate()
        measure.index = measure_count - i
        measure.lane_types = LANE_TYPES
        _measures_parent.add_child(measure)

    # スクロールを一番下へ
    #_scroll_container.set_deferred("scroll_vertical", _scroll_container.get_v_scroll_bar().max_value) # 動かん
    _scroll_container.set_deferred("scroll_vertical", 99999999)

    # Grid
    for grid_type in GRID_LABELS:
        _option_button_grid.add_item(GRID_LABELS[grid_type], grid_type)
    _option_button_grid.selected = GridType.GRID_16 # TODO
