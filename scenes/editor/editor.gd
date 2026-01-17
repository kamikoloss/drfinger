extends Control

@export var _measure_scene: PackedScene

@onready var _scroll_container: ScrollContainer = %ScrollContainer
@onready var _measures_parent: Control = %MeasuresParent


func _ready() -> void:
    # Measure 配置
    var measure_count := 64
    for i in (measure_count + 1):
        var measure: Measure = _measure_scene.instantiate()
        measure.index = measure_count - i
        _measures_parent.add_child(measure)

    # スクロールを一番下へ
    #_scroll_container.set_deferred("scroll_vertical", _scroll_container.get_v_scroll_bar().max_value) # 動かん
    _scroll_container.set_deferred("scroll_vertical", 99999999)
