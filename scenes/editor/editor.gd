extends Control

@export var _measure_scene: PackedScene

@onready var _measures_parent: Control = %MeasuresParent


func _ready() -> void:
    # Measure 配置
    var measure_count := 64
    for i in (measure_count + 1):
        var measure: Measure = _measure_scene.instantiate()
        measure.index = measure_count - i
        _measures_parent.add_child(measure)
