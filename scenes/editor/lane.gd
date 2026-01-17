class_name Lane
extends Control

## ホバー開始時
signal hover_entered()
## ホバー終了時
signal hover_exited()
## クリック時
signal pressed(pos: Vector2)

const LINE_COLOR_1 := Color(0.8, 0.8, 0.8)
const LINE_COLOR_2 := Color(0.6, 0.6, 0.6)
const LINE_COLOR_3 := Color(0.4, 0.4, 0.4)
const LINE_COLOR_4 := Color(0.2, 0.2, 0.2)
const LINE_COLOR_5 := Color(0.1, 0.1, 0.1)

var lane_type := LaneType.Type.NONE

## 現在ホバーしているかどうか
var _hovered := false:
    set(v):
        #print("[Lane] hovered. (%s)" % [v])
        _hovered = v
        queue_redraw()
        if _hovered:
            hover_entered.emit()
        else:
            hover_exited.emit()


func _ready() -> void:
    gui_input.connect(_on_gui_input)
    mouse_entered.connect(func() -> void: _hovered = true)
    mouse_exited.connect(func() -> void: _hovered = false)


func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        var event_mouse_button := event as InputEventMouseButton
        if event_mouse_button.button_index == MOUSE_BUTTON_LEFT and event_mouse_button.pressed:
            pressed.emit(event.position)


func _draw():
    # 背景
    draw_rect(Rect2(Vector2.ZERO, size), Color.BLACK)
    draw_rect(Rect2(Vector2.ZERO, size), Color(LaneType.COLORS[lane_type], 0.1))
    # 横線
    var line_count := 16 # TODO
    var line_main_per := 4 # TODO
    for i in line_count:
        var y := size.y * i / line_count
        var from := Vector2(0, y)
        var to := Vector2(size.x, y)
        var color := LINE_COLOR_5
        if i == 0:
            color = LINE_COLOR_3
        elif i % line_main_per == 0:
            color = LINE_COLOR_4
        draw_line(from, to, color)
    # 縦線 (左右の枠)
    draw_line(Vector2(0, 0), Vector2(0, size.y), LINE_COLOR_3)
    draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), LINE_COLOR_3)
    # 前景
    if _hovered:
        draw_rect(Rect2(Vector2.ZERO, size), Color(Color.WHITE, 0.1))
