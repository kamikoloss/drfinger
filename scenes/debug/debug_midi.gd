extends Node2D


@export var _debug_label: Label


func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())


func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		_print_midi_info(event)


func _print_midi_info(midi_event):
	print(midi_event)
	if _debug_label:
		var text := ""
		text += "channel: %s\n" % [midi_event.channel]
		text += "message: %s\n" % [midi_event.message]
		text += "pitch: %s\n" % [midi_event.pitch]
		text += "velocity: %s\n" % [midi_event.velocity]
		text += "instrument: %s\n" % [midi_event.instrument]
		text += "pressure: %s\n" % [midi_event.pressure]
		text += "controller_number: %s\n" % [midi_event.controller_number]
		text += "controller_value: %s\n" % [midi_event.controller_value]
		_debug_label.text = text
