class_name Values
extends Node


const TILE_SIZE := 16

static var seen_dialogue: Dictionary[NodePath, bool] = {}

static func set_seen(dialogue: Node) -> void:
	seen_dialogue[dialogue.get_path()] = true
	
static func has_seen(dialogue: Node) -> bool:
	return seen_dialogue.get(dialogue.get_path(), false)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		seen_dialogue = {}
		get_tree().change_scene_to_file("res://levels/world/intro.tscn")
