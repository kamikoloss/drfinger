class_name ChartGrid
extends Control

const TICKS_PER_STEPS := 960
const BAR_HEIGHT_BASE := 240.0 # (px)
const NOTE_HEIGHT := 4.0 # (px)

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
var _lane_width := 0.0
## 1小節の高さ (px)
var _bar_height := 0.0:
    set(v):
        _bar_height = v
        _step_height = _bar_height / (beats_per_bar * steps_per_beat)
## 1ステップの高さ (px)
var _step_height := 0.0

var _is_hovered := false
var _hover_position := Vector2.ZERO


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
            var lane_type := _get_lane_type_from_pos(_hover_position)
            var tick := _get_tick_from_pos(_hover_position)
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
        _hover_position = event.position
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

    # 配置済みの Note
    for note in notes:
        var color := LaneType.COLORS[note.lane_type]
        draw_rect(_get_note_rect(note.lane_type, note.tick), color, true)
        draw_rect(_get_note_rect(note.lane_type, note.tick), NOTE_OUTLINE_COLOR, false, 1.0)
    # 配置予定の Note
    if _is_hovered:
        var lane_type := _get_lane_type_from_pos(_hover_position)
        var tick := _get_tick_from_pos(_hover_position)
        var color := Color(LaneType.COLORS[lane_type], 0.4)
        draw_rect(_get_note_rect(lane_type, tick), color)


func _get_lane_type_from_pos(pos: Vector2) -> String:
    var lane_index := int(pos.x / _lane_width)
    return lane_types[lane_index]


func _get_tick_from_pos(pos: Vector2) -> int:
    var step_index := int(pos.y / _step_height)
    return  int(TICKS_PER_STEPS * step_index / float(steps_per_beat))


func _get_note_rect(lane_type: String, tick: int) -> Rect2:
    var lane_index := lane_types.find(lane_type)
    var step_index := int(tick * steps_per_beat / float(TICKS_PER_STEPS))
    var x := lane_index * _lane_width
    var y := step_index * _step_height
    return Rect2(x, y, _lane_width, _step_height)
