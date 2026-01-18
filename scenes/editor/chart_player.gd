class_name ChartPlayer
extends Control

var notes: Array[Note] = []

var _is_playing := false

var _loaded_audio: AudioStream = null
var _loaded_video: VideoStream = null
var _loaded_drum: Dictionary[String, VideoStream] = {}

@onready var _chart_grid: ChartGrid = %ChartGrid
@onready var _scroll_container: ScrollContainer = %ScrollContainer

@onready var _audio_stream_player_audio: AudioStreamPlayer = %AudioStreamPlayerAudio
@onready var _audio_stream_player_drum: AudioStreamPlayer = %AudioStreamPlayerDrum
@onready var _video_stream_player: VideoStreamPlayer = %VideoStreamPlayer


func _ready() -> void:
    print("[ChartPlayer] _ready()")
    visible = false

    for lane_type in _chart_grid.lane_types:
        _loaded_drum[lane_type] = load(LaneType.DEFAULT_AUDIO[lane_type])


func _process(delta: float) -> void:
    if _is_playing:
        _scroll_container.set_deferred("scroll_vertical", _scroll_container.scroll_vertical - delta * 240.0 * 2.0)


func play(audio_path: String, video_path: String) -> void:
    visible = true
    _is_playing = true
    _scroll_container.set_deferred("scroll_vertical", _chart_grid.custom_minimum_size.y)

    # TODO: 変わっていないときは読み込まない

    # ファイルチェック
    _loaded_audio = null
    if FileAccess.file_exists(audio_path):
        _loaded_audio = load(audio_path)
    if FileAccess.file_exists(video_path):
        _loaded_video = load(video_path)
    if _loaded_audio == null and _loaded_video == null:
        print("[ChartPlayer] audio_path (%s) and video_path (%s) does not exist." % [audio_path, video_path])
        return
    elif _loaded_audio != null and _loaded_video == null:
        _audio_stream_player_audio.stream = _loaded_audio
        _audio_stream_player_audio.play()
    elif _loaded_audio == null and _loaded_video != null:
        _video_stream_player.stream = _loaded_video
        _video_stream_player.play()


func stop() -> void:
    visible = false
    _is_playing = false

    _audio_stream_player_audio.stop()
    _video_stream_player.stop()
