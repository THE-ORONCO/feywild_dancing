extends Node2D

@onready var player: Player = %Player

var moving := false

const BALL_ROOM_DAY_1 = preload("uid://c1e5gx7yahf33")
@onready var dialogue: Dialogue = %Dialogue

func _ready() -> void:
	player.move_cmp.finished_move.connect(func(): moving = false)
	player.move_cmp.bumped_wall.connect(func(_i): moving = false)
	player.move_cmp.bumped_entity.connect(func(_i): moving = false)
	
	dialogue.show_dialog([
		"You have been lost in the forest for days now.",
		"Every tree seems to be the same and you swear you turned this corner before.",
		"This whole endevor was the idea of you troubadour band leader.",
		"Going through the forbidden forest to make it to the big festival in time.",
		"Maybe today will be different...",
	])

func _on_fary_circle_area_entered(area: Area2D) -> void:
	await dialogue.show_dialog([
		"As you enter the circle of flowers the world around you seems to shift and bend.",
		"Impossible angles give you headaches. Pungent smells pierce your nose and make your eyes water.",
		"You try to avert your gaze and close your eyes."
	])
	
	get_tree().change_scene_to_packed(BALL_ROOM_DAY_1)




func _input(event: InputEvent) -> void:
	#if event.is_action("ui_accept"):
		#if dialogue.dialogue_paused:
			#dialogue.continue_text()
	
	if moving || dialogue.in_dialogue: return
	
	
	var pos := player.position
	if event.is_action("up"):
		moving = true
		player.move_cmp.move(pos + Vector2.UP * Values.TILE_SIZE, .1)
	elif event.is_action("down"):	
		moving = true
		player.move_cmp.move(pos + Vector2.DOWN * Values.TILE_SIZE, .1)
	elif event.is_action("left"):	
		moving = true
		player.move_cmp.move(pos + Vector2.LEFT * Values.TILE_SIZE, .1)
	elif event.is_action("right"):	
		moving = true
		player.move_cmp.move(pos + Vector2.RIGHT * Values.TILE_SIZE, .1)
	else: return 
	
