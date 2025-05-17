extends Node2D


@export var _debug_label: Label


var pad_ch := 9
var pad_id_pitch_assign := {
	1: 68, 2: 69, 3: 70, 4: 71,
	5: 72, 6: 73, 7: 74, 8: 75,
	9: 76, 10: 77, 11: 78, 12: 79,
	13: 80, 14: 81, 15: 82, 16: 83,
}
var knob_ch := 0
var knob_id_cnum_assign := {
	1: 22, 2: 23,
	3: 24, 4: 25,
	5: 26, 6: 27,
}


func _ready() -> void:
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())

	_init_pad()
	_init_knob()


func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		print(event)
		_update_pad(event)
		_update_knob(event)
		_update_label(event)


func _init_pad() -> void:
	for pad_id in pad_id_pitch_assign.keys():
		var pad_node = get_node_or_null("MarginContainer/GridContainer/ColorRect%s" % [pad_id])
		pad_node.self_modulate = Color(Color.WHITE, 0.2)


func _init_knob() -> void:
	for knob_id in knob_id_cnum_assign.keys():
		var knob_node = get_node_or_null("MarginContainer2/VBoxContainer/ProgressBar%s" % [knob_id])
		knob_node.value = 0


func _update_pad(event: InputEventMIDI) -> void:
	if event.channel != pad_ch:
		return

	var pitch := event.pitch
	var pad_id = pad_id_pitch_assign.find_key(pitch)
	if pad_id == null:
		return
	var pad_node = get_node_or_null("MarginContainer/GridContainer/ColorRect%s" % [pad_id])
	if pad_node == null:
		return

	match event.message:
		MIDI_MESSAGE_NOTE_OFF:
			pad_node.self_modulate = Color(Color.WHITE, 0.2)
		MIDI_MESSAGE_NOTE_ON:
			pad_node.self_modulate = Color.WHITE


func _update_knob(event: InputEventMIDI) -> void:
	if event.channel != knob_ch:
		return
	if event.message != MIDI_MESSAGE_CONTROL_CHANGE:
		return

	var cnum := event.controller_number
	var knob_id = knob_id_cnum_assign.find_key(cnum)
	if knob_id == null:
		return
	var knob_node = get_node_or_null("MarginContainer2/VBoxContainer/ProgressBar%s" % [knob_id])
	if knob_node == null:
		return

	var cval := event.controller_value
	if knob_node is ProgressBar:
		knob_node.value = cval


func _update_label(event: InputEventMIDI) -> void:
	if _debug_label:
		var text := ""
		text += "channel: %s\n" % [event.channel]
		text += "message: %s\n" % [event.message]
		text += "pitch: %s\n" % [event.pitch]
		text += "velocity: %s\n" % [event.velocity]
		text += "instrument: %s\n" % [event.instrument]
		text += "pressure: %s\n" % [event.pressure]
		text += "controller_number: %s\n" % [event.controller_number]
		text += "controller_value: %s\n" % [event.controller_value]
		_debug_label.text = text
