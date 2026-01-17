class_name ChartGrid
extends Control

const BEAT_CLOCK := 480

const LINE_COLOR_1 := Color(0.4, 0.4, 0.4)
const LINE_COLOR_2 := Color(0.2, 0.2, 0.2)
const LINE_COLOR_3 := Color(0.1, 0.1, 0.1)

var notes: Array[Note] = []

# TODO: Drum, MPC
var lane_types: Array[LaneType.Type] = [
    LaneType.Type.CYMBAL_CRASH,
    LaneType.Type.HIHAT,
    LaneType.Type.SNARE,
    LaneType.Type.KICK,
    LaneType.Type.TOM_HIGH,
    LaneType.Type.TOM_LOW,
    LaneType.Type.TOM_FLOOR,
    LaneType.Type.CYMBAL_RIDE,
]
## 1小節あたりの拍子数
var beats_per_bar := 4
## 1拍あたりの分割数
var steps_per_beat := 4
## 小節数
var bar_count := 64
## 1小節の高さ (px)
var bar_height := 240.0

## レーンの幅
var _lane_width := 0.0
## 1ステップの高さ
var _step_height := 0.0


func _ready() -> void:
    print("[ChartGrid] _ready()")
    _lane_width = size.x / lane_types.size()
    _step_height = bar_height / (beats_per_bar * steps_per_beat)

    # 高さを初期化する
    custom_minimum_size = Vector2(0, bar_height * bar_count)


func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var event_mouse_button := event as InputEventMouseButton
        if event_mouse_button.pressed:
            if event_mouse_button.button_index == MOUSE_BUTTON_LEFT:
                var note := _get_note_from_pos(event.position)
            elif event_mouse_button.button_index == MOUSE_BUTTON_RIGHT:
                var note := _get_note_from_pos(event.position)


func _draw() -> void:
    _lane_width = size.x / lane_types.size()
    _step_height = bar_height / (beats_per_bar * steps_per_beat)
    # 背景色 (全体)
    draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK)
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


func _get_note_from_pos(pos: Vector2) -> Note:
    var lane_index := int(pos.x / _lane_width)
    var lane_type := lane_types[lane_index]
    var ticks := int((size.y - pos.y) * beats_per_bar * BEAT_CLOCK / _step_height)
    print("_get_note_from_pos(%s) lane_type: %s, ticks: %s" % [pos, LaneType.Type.keys()[lane_type], ticks])
    return Note.new(lane_type, ticks)
