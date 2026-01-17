class_name Lane
extends Control
## 1レーンの1小節

const LINE_COLOR_1 := Color(0.8, 0.8, 0.8)
const LINE_COLOR_2 := Color(0.6, 0.6, 0.6)
const LINE_COLOR_3 := Color(0.4, 0.4, 0.4)
const LINE_COLOR_4 := Color(0.2, 0.2, 0.2)


func _draw():
    # 横線
    var line_count := 16 # TODO
    var line_main_per := 4 # TODO
    for i in line_count:
        var y := size.y * (line_count - i) / line_count
        var from := Vector2(0, y)
        var to := Vector2(size.x, y)
        var color := LINE_COLOR_4
        if (line_count - i) % line_main_per == 0:
            color = LINE_COLOR_3
        draw_line(from, to, color)
    # 縦線 (左右の枠)
    draw_line(Vector2(0, 0), Vector2(0, size.y), LINE_COLOR_2)
    draw_line(Vector2(size.x, 0), Vector2(size.x, size.y), LINE_COLOR_2)
