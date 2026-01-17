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


var _lane_width = 0.0 # TODO: 再計算
var _step_height = 0.0 # TODO: 再計算

var _hover_lane_index := 0
var _hover_step_index := 0


func _ready() -> void:
    print("[ChartGrid] _ready()")
    # 高さを初期化する
    custom_minimum_size = Vector2(0, bar_height * bar_count)


func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var event_mouse_button := event as InputEventMouseButton
        if event_mouse_button.pressed:
            if event_mouse_button.button_index == MOUSE_BUTTON_LEFT:
                pass
            elif event_mouse_button.button_index == MOUSE_BUTTON_RIGHT:
                pass
    elif event is InputEventMouseMotion:
        #var event_mouse_motion := event as InputEventMouseMotion
        _hover_lane_index = int(event.position.x / _lane_width)
        _hover_step_index = int(event.position.y / _step_height)
        queue_redraw()


func _draw() -> void:
    # TODO: ここに入れないと初期化うまくいかないがここでしたくない
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
    # TODO: 描画最適化
    # -- notes --
    # TODO: 描画最適化
    var ghost_pos := Vector2(_hover_lane_index * _lane_width, _hover_step_index * _step_height)
    var ghost_color := Color(LaneType.COLORS[lane_types[_hover_lane_index]], 0.4)
    draw_rect(Rect2(ghost_pos, Vector2(_lane_width, _step_height)), ghost_color)
