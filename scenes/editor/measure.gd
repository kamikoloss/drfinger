class_name Measure
extends Control

var index := 0

@onready var _label_index: Label = %LabelIndex


func _ready() -> void:
    _label_index.text = str(index)
