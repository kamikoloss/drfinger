extends Control

const USER_DATA_BASE_DIR := "user://tracks"
const CHART_FILE_NAME := "chart.json"

const CHART_FILE_KEY_BPM = "bpm"
const CHART_FILE_KEY_NOTES = "note"
const CHART_FILE_KEY_OFFSET = "ofs"
const CHART_FILE_KEY_SAVED_AT = "svat"
const CHART_FILE_KEY_VERSION = "ver"

var _last_saved_at := 0

@onready var _chart_grid: ChartGrid = %ChartGrid
@onready var _scroll_container: ScrollContainer = %ScrollContainer

@onready var _line_edit_dir: LineEdit = %LineEditDir
@onready var _line_edit_audio: LineEdit = %LineEditAudio
@onready var _line_edit_video: LineEdit = %LineEditVideo
@onready var _line_edit_bpm: LineEdit = %LineEditBpm
@onready var _line_edit_offset: LineEdit = %LineEditOffset
#@onready var _line_edit_beats: LineEdit = %LineEditBeats
#@onready var _line_edit_steps: LineEdit = %LineEditSteps
@onready var _label_last_saved_at: Label = %LabelLastSavedAt
@onready var _button_load: Button = %ButtonLoad
@onready var _button_save: Button = %ButtonSave

@onready var _file_dialog: FileDialog = %FileDialog

# Player
@onready var _chart_player: ChartPlayer = %ChartPlayer
@onready var _button_play: Button = %ButtonPlay
@onready var _button_stop: Button = %ButtonStop


func _ready() -> void:
    print("[Editor] _ready()")
    _button_load.pressed.connect(_on_button_load_pressed)
    _button_save.pressed.connect(_on_button_save_pressed)
    _button_play.pressed.connect(func() -> void:
        var audio_path := USER_DATA_BASE_DIR + "/" + _line_edit_dir.text + "/" + _line_edit_audio.text
        var vudeo_path := USER_DATA_BASE_DIR + "/" + _line_edit_dir.text + "/" + _line_edit_video.text
        _chart_player.play(audio_path, vudeo_path)
    )
    _button_stop.pressed.connect(func() -> void:
        _scroll_container.set_deferred("scroll_vertical", _chart_grid.custom_minimum_size.y)
        _chart_player.stop()
    )

    _line_edit_bpm.text_changed.connect(func(new_text: String) -> void:
        _chart_grid.bpm = float(new_text)
    )
    _line_edit_offset.text_changed.connect(func(new_text: String) -> void:
        _chart_grid.offset_sec = float(new_text)
    )

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


func _on_button_load_pressed() -> void:
    # ディレクトリチェック
    if not DirAccess.dir_exists_absolute(USER_DATA_BASE_DIR):
        printerr("[Editor] USER_DATA_BASE_DIR (%s) does not exist." % [USER_DATA_BASE_DIR])
        return
    var track_name := _line_edit_dir.text
    var dir_path := USER_DATA_BASE_DIR + "/" + track_name
    if not DirAccess.dir_exists_absolute(dir_path):
        printerr("[Editor] dir_path (%s) does not exist." % [dir_path])
        return

    # ファイルチェック
    var chart_path = dir_path + "/" + CHART_FILE_NAME
    if not FileAccess.file_exists(chart_path):
        printerr("[Editor] chart_path (%s) does not exist." % [chart_path])
        return

    # 読み込み
    var file := FileAccess.open(chart_path, FileAccess.READ)
    var data = JSON.parse_string(file.get_line())
    # BPM
    if data.has(CHART_FILE_KEY_BPM):
        _chart_grid.bpm = float(data[CHART_FILE_KEY_BPM])
        _line_edit_bpm.text = data[CHART_FILE_KEY_BPM]
    else:
        printerr("[Editor] track data has not %s." % [CHART_FILE_KEY_BPM])
    # NOTES
    if data.has(CHART_FILE_KEY_NOTES):
        var loaded_notes: Array[Note] = []
        for note_dict in data[CHART_FILE_KEY_NOTES]:
            loaded_notes.append(Note.deserialize(note_dict))
        _chart_grid.notes = loaded_notes
    else:
        printerr("[Editor] track data has not %s." % [CHART_FILE_KEY_NOTES])
    # OFFSET
    if data.has(CHART_FILE_KEY_OFFSET):
        _chart_grid.offset_sec = float(data[CHART_FILE_KEY_OFFSET])
        _line_edit_offset.text = data[CHART_FILE_KEY_OFFSET]
    else:
        printerr("[Editor] track data has not %s." % [CHART_FILE_KEY_OFFSET])
    # SAVED_AT
    if data.has(CHART_FILE_KEY_SAVED_AT):
        _last_saved_at = data[CHART_FILE_KEY_SAVED_AT]
        _label_last_saved_at.text = Time.get_datetime_string_from_unix_time(_last_saved_at)
    else:
        printerr("[Editor] track data has not %s." % [CHART_FILE_KEY_SAVED_AT])


func _on_button_save_pressed() -> void:
    _last_saved_at = int(Time.get_unix_time_from_system())

    # ディレクトリチェック
    if not DirAccess.dir_exists_absolute(USER_DATA_BASE_DIR):
        DirAccess.make_dir_absolute(USER_DATA_BASE_DIR)
    var track_name := _line_edit_dir.text
    var dir_path := USER_DATA_BASE_DIR + "/" + track_name
    if not DirAccess.dir_exists_absolute(dir_path):
        DirAccess.make_dir_absolute(dir_path)

    # 書き込み
    var chart_path = dir_path + "/" + CHART_FILE_NAME
    var file := FileAccess.open(chart_path, FileAccess.WRITE)
    var json_string := JSON.stringify({
        CHART_FILE_KEY_BPM: "%0.3f" % [_chart_grid.bpm],
        CHART_FILE_KEY_NOTES: _chart_grid.notes.map(func(v: Note): return v.serialize()),
        CHART_FILE_KEY_OFFSET: "%0.3f" % [_chart_grid.offset_sec],
        CHART_FILE_KEY_SAVED_AT: _last_saved_at,
        CHART_FILE_KEY_VERSION: str(ProjectSettings.get_setting("application/config/version", "")),
    })
    file.store_line(json_string)

    _label_last_saved_at.text = Time.get_datetime_string_from_system(true)
