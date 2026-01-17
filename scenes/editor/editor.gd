extends Control

@onready var _chart_grid: ChartGrid = %ChartGrid
@onready var _scroll_container: ScrollContainer = %ScrollContainer
# UI
@onready var _line_edit_bpm: LineEdit = %LineEditBpm
@onready var _line_edit_offset: LineEdit = %LineEditOffset
@onready var _line_edit_beats: LineEdit = %LineEditBeats
@onready var _line_edit_steps: LineEdit = %LineEditSteps
@onready var _option_button_grid: OptionButton = %OptionButtonGrid


func _ready() -> void:
    print("[Editor] _ready()")

    # ChartGrid のスクロールを一番下へ
    #_scroll_container.set_deferred("scroll_vertical", _scroll_container.get_v_scroll_bar().max_value) # 動かん
    _scroll_container.set_deferred("scroll_vertical", _chart_grid.custom_minimum_size.y)
