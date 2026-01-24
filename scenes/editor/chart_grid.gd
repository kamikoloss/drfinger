class_name ChartGrid
extends Control

const TICKS_PER_STEPS := 960
const BAR_HEIGHT_BASE := 240.0 # (px)

const LINE_COLOR_1 := Color(Color.WHITE, 0.4)
const LINE_COLOR_2 := Color(Color.WHITE, 0.2)
const LINE_COLOR_3 := Color(Color.WHITE, 0.1)
const NOTE_OUTLINE_COLOR := Color(Color.BLACK, 0.4)

var notes: Array[Note] = []:
    set(v):
        notes = v
        queue_redraw()

# TODO: Drum, MPC
var lane_types: Array[String] = []
## BPM
var bpm := 120.0
## 曲の開始タイミングのオフセット (sec)
var offset_sec := 0.0
## 1小節あたりの拍子数
var beats_per_bar := 4
## 1拍あたりの分割数
var steps_per_beat := 4
## 小節数
var bar_count := 64
## ズーム率
var zoom_rate := 1.0:
    set(v):
        _bar_height = BAR_HEIGHT_BASE * zoom_rate

## 1レーンの長さ (px)
var _lane_width = 0.0
## 1小節の高さ (px)
var _bar_height := 0.0:
    set(v):
        _bar_height = v
        _step_height = _bar_height / (beats_per_bar * steps_per_beat)
## 1ステップの高さ (px)
var _step_height = 0.0

var _is_hovered := false
var _hover_lane_index := 0
var _hover_step_index := 0


func _ready() -> void:
    print("[ChartGrid] _ready()")
    mouse_entered.connect(func() -> void: _is_hovered = true)
    mouse_exited.connect(func() -> void:
        _is_hovered = false
        queue_redraw()
    )

    # 高さを初期化する
    # TODO: 小節数が変わったら再計算する
    _bar_height = BAR_HEIGHT_BASE
    custom_minimum_size = Vector2(0, _bar_height * bar_count)
    # NOTE: resized を待たないと size　が取れない
    resized.connect(func() -> void:
        _lane_width = size.x / lane_types.size()
        queue_redraw()
    )


func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        event = event as InputEventMouseButton
        if event.pressed:
            var lane_type := lane_types[_hover_lane_index]
            var tick := int(TICKS_PER_STEPS * _hover_step_index / float(steps_per_beat))
            if event.button_index == MOUSE_BUTTON_LEFT:
                # 左クリック: Note を追加する
                # TODO: 押しっぱなしでまとめて追加
                # TODO: 被るところには置けないようにする
                var note := Note.new(lane_type, tick)
                notes.append(note)
            elif event.button_index == MOUSE_BUTTON_RIGHT:
                # 右クリック: Note を削除する
                # TODO: 押しっぱなしでまとめて削除
                notes = notes.filter(func(note: Note) -> bool:
                    return not(note.lane_type == lane_type and note.tick == tick)
                )
    elif event is InputEventMouseMotion:
        event = event as InputEventMouseMotion
        _hover_lane_index = int(event.position.x / _lane_width)
        _hover_step_index = int(event.position.y / _step_height)
        queue_redraw()


func _draw() -> void:
    # 背景色 (全体)
    draw_rect(Rect2(Vector2.ZERO, size), Color(Color.BLACK, 0.8))
    # 背景色 (レーンごと)
    for i in lane_types.size():
        var lane_type := lane_types[i]
        var lane_color = Color(LaneType.COLORS[lane_type], 0.1)
        draw_rect(Rect2(Vector2(_lane_width * i, 0), Vector2(_lane_width, size.y)), lane_color)
    # 横線
    var line_y := 0.0
    draw_line(Vector2(0, line_y), Vector2(size.x, line_y), LINE_COLOR_1) # TODO: 見えない？
    for bar_index in bar_count:
        for beat_index in beats_per_bar:
            for step_index in steps_per_beat:
                line_y += _step_height
                draw_line(Vector2(0, line_y), Vector2(size.x, line_y), LINE_COLOR_3)
            draw_line(Vector2(0, line_y), Vector2(size.x, line_y), LINE_COLOR_2)
        draw_line(Vector2(0, line_y), Vector2(size.x, line_y), LINE_COLOR_1)
    # 縦線
    var line_x := 0.0
    draw_line(Vector2(line_x, 0), Vector2(line_x, size.y), LINE_COLOR_1) # TODO: 見えない？
    for lane_index in lane_types.size():
        line_x += _lane_width
        draw_line(Vector2(line_x, 0), Vector2(line_x, size.y), LINE_COLOR_1)

    # Note
    # TODO: 描画最適化
    for note in notes:
        var lane_index := lane_types.find(note.lane_type)
        var step_index := int(note.tick * steps_per_beat / float(TICKS_PER_STEPS))
        var note_pos := Vector2(lane_index * _lane_width, step_index * _step_height)
        var note_color := LaneType.COLORS[note.lane_type]
        draw_rect(Rect2(note_pos, Vector2(_lane_width, _step_height)), note_color, true)
        draw_rect(Rect2(note_pos, Vector2(_lane_width, _step_height)), NOTE_OUTLINE_COLOR, false, 1.0)
    # Note (配置前のゴースト)
    # TODO: 描画最適化
    if _is_hovered:
        var ghost_pos := Vector2(_hover_lane_index * _lane_width, _hover_step_index * _step_height)
        var ghost_color := Color(LaneType.COLORS[lane_types[_hover_lane_index]], 0.4)
        draw_rect(Rect2(ghost_pos, Vector2(_lane_width, _step_height)), ghost_color)
