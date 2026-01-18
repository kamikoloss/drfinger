extends Control

const USER_DATA_BASE_DIR := "user://tracks"
const CHART_FILE_NAME := "chart.json"

var _last_saved_at := 0

@onready var _chart_grid: ChartGrid = %ChartGrid
@onready var _scroll_container: ScrollContainer = %ScrollContainer

@onready var _line_dir: LineEdit = %LineEditDir
@onready var _line_audio: LineEdit = %LineEditAudio
@onready var _line_movie: LineEdit = %LineEditMovie
#@onready var _line_edit_bpm: LineEdit = %LineEditBpm
#@onready var _line_edit_offset: LineEdit = %LineEditOffset
#@onready var _line_edit_beats: LineEdit = %LineEditBeats
#@onready var _line_edit_steps: LineEdit = %LineEditSteps
@onready var _label_last_saved_at: Label = %LabelLastSavedAt
@onready var _button_open: Button = %ButtonOpen
@onready var _button_save: Button = %ButtonSave

@onready var _button_play: Button = %ButtonPlay
@onready var _button_stop: Button = %ButtonStop

@onready var _file_dialog: FileDialog = %FileDialog


func _ready() -> void:
    print("[Editor] _ready()")
    _button_open.pressed.connect(_on_button_open_pressed)
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


func _on_button_open_pressed() -> void:
    # ディレクトリチェック
    if not DirAccess.dir_exists_absolute(USER_DATA_BASE_DIR):
        print("[Editor] USER_DATA_BASE_DIR (%s) does not exist." % [USER_DATA_BASE_DIR])
        return
    var track_name := _line_dir.text
    var dir_path := USER_DATA_BASE_DIR + "/" + track_name
    if not DirAccess.dir_exists_absolute(dir_path):
        print("[Editor] dir_path (%s) does not exist." % [dir_path])
        return

    # ファイルチェック
    var chart_path = dir_path + "/" + CHART_FILE_NAME
    if not FileAccess.file_exists(chart_path):
        print("[Editor] chart_path (%s) does not exist." % [chart_path])
        return

    # 読み込み
    var file := FileAccess.open(chart_path, FileAccess.READ)
    var data = JSON.parse_string(file.get_line())
    # ns
    var loaded_notes: Array[Note] = []
    for note_dict in data["ns"]:
        loaded_notes.append(Note.deserialize(note_dict))
    _chart_grid.notes = loaded_notes
    # sv
    _last_saved_at = data["sv"]
    _label_last_saved_at.text = Time.get_datetime_string_from_unix_time(_last_saved_at)


func _on_button_save_pressed() -> void:
    _last_saved_at = int(Time.get_unix_time_from_system())

    # ディレクトリチェック
    if not DirAccess.dir_exists_absolute(USER_DATA_BASE_DIR):
        DirAccess.make_dir_absolute(USER_DATA_BASE_DIR)
    var track_name := _line_dir.text
    var dir_path := USER_DATA_BASE_DIR + "/" + track_name
    if not DirAccess.dir_exists_absolute(dir_path):
        DirAccess.make_dir_absolute(dir_path)

    # 書き込み
    var chart_path = dir_path + "/" + CHART_FILE_NAME
    var file := FileAccess.open(chart_path, FileAccess.WRITE)
    var notes_json := []
    for note in _chart_grid.notes:
        notes_json.append(note.serialize())
    var json_string := JSON.stringify({
        "ns": notes_json,
        "sv": _last_saved_at,
    })
    file.store_line(json_string)

    _label_last_saved_at.text = Time.get_datetime_string_from_system(true)
