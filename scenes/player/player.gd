class_name Player
extends Node2D


@export var _lane_lamp_kick1: ColorRect
@export var _lane_lamp_kick2: ColorRect
@export var _lane_lamp_snare1: ColorRect
@export var _lane_lamp_snare2: ColorRect
@export var _lane_lamp_hat1: ColorRect
@export var _lane_lamp_hat2: ColorRect


# TODO: KeyConfig
var _keys_lane_lamp = {}


func _ready() -> void:
	_keys_lane_lamp = {
		KEY_S: _lane_lamp_hat1,
		KEY_D: _lane_lamp_snare1,
		KEY_F: _lane_lamp_kick1,
		KEY_J: _lane_lamp_kick2,
		KEY_K: _lane_lamp_snare2,
		KEY_L: _lane_lamp_hat2,
	}
	for key in _keys_lane_lamp.keys():
		#print(_keys_lane_lamp[key])
		_keys_lane_lamp[key].self_modulate = Color.TRANSPARENT


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode in _keys_lane_lamp.keys():
			_keys_lane_lamp[event.keycode].self_modulate = Color.WHITE if event.pressed else Color.TRANSPARENT
