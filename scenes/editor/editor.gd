extends Control

const USER_DATA_BASE_DIR := "user://tracks"
const CHART_FILE_NAME := "chart.json"

@onready var _chart_grid: ChartGrid = %ChartGrid
@onready var _scroll_container: ScrollContainer = %ScrollContainer

@onready var _line_edit_bpm: LineEdit = %LineEditBpm
@onready var _line_edit_offset: LineEdit = %LineEditOffset
@onready var _line_edit_beats: LineEdit = %LineEditBeats
@onready var _line_edit_steps: LineEdit = %LineEditSteps
@onready var _option_button_grid: OptionButton = %OptionButtonGrid
@onready var _button_save: Button = %ButtonSave
@onready var _button_play: Button = %ButtonPlay
@onready var _button_stop: Button = %ButtonStop


func _ready() -> void:
    print("[Editor] _ready()")
    _button_save.pressed.connect(_on_button_save_pressed)

    # ChartGrid のスクロールを一番下へ
    _scroll_container.set_deferred("scroll_vertical", _chart_grid.custom_minimum_size.y)

    # TODO: 設定
    _chart_grid.lane_types = [
        LaneType.Type.CYMBAL_CRASH_1,
        LaneType.Type.HIHAT,
        LaneType.Type.SNARE,
        LaneType.Type.KICK,
        LaneType.Type.TOM_HIGH,
        LaneType.Type.TOM_LOW,
        LaneType.Type.TOM_FLOOR,
        LaneType.Type.CYMBAL_RIDE,
        LaneType.Type.CYMBAL_CRASH_2,
    ]


func _on_button_save_pressed() -> void:
    if not DirAccess.dir_exists_absolute(USER_DATA_BASE_DIR):
        DirAccess.make_dir_absolute(USER_DATA_BASE_DIR)
    var track_name := "test" # TODO: 設定
    var dir_path := USER_DATA_BASE_DIR + "/" + track_name
    if not DirAccess.dir_exists_absolute(dir_path):
        DirAccess.make_dir_absolute(dir_path)

    var chart_path = dir_path + "/" + CHART_FILE_NAME
    var file := FileAccess.open(chart_path, FileAccess.WRITE)
    var notes_json := []
    for note in _chart_grid.notes:
        notes_json.append(note.serialize())
    var json_string := JSON.stringify({
        "notes": notes_json,
    })
    file.store_line(json_string)
