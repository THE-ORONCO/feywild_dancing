class_name Tracks
extends Control

@export_range(1, 100) var segments := 10
var instruments := 3

@export_group("tracks")
@export_subgroup("circle")
@export var circle_track := true
@export var circle_full: Texture
@export var circle_empty: Texture
@export var circle_sound: AudioStream

@export_subgroup("square")
@export var square_track := true
@export var square_full: Texture
@export var square_empty: Texture
@export var square_sound: AudioStream

@export_subgroup("triangle")
@export var triangle_track := true
@export var triangle_full: Texture
@export var triangle_empty: Texture
@export var triangle_sound: AudioStream

@export_subgroup("diamond")
@export var diamond_track := true
@export var diamond_full: Texture
@export var diamond_empty: Texture
@export var diamond_sound: AudioStream

const BEAT_BOX = preload("uid://cjvt3mcjpkrdc")

@onready var square: VBoxContainer = %Square
@onready var circle: VBoxContainer = %Circle
@onready var triangle: VBoxContainer = %Triangle
@onready var diamond: VBoxContainer = %Diamond

const CIRCLE_SOUND = preload("uid://1qqvv4bys23h")

var _beat_boxes: Array[BeatBox] = []

func _ready() -> void:
	if diamond_track: diamond.show()
	if triangle_track: triangle.show()
	if square_track: square.show()
	if circle_track: circle.show()

func hit_range(from: float, to: float) -> void:
	var own_height := self.size.y
	for beat_box in _beat_boxes:
		var along_ratio := beat_box.center.y / own_height
		if from <= along_ratio and along_ratio <= to:
			beat_box.hit() 

func add_square(number:=1) -> BeatBox:
	square.show()

	var squa: BeatBox = BEAT_BOX.instantiate()
	squa.unchecked_icon = square_empty
	squa.checked_icon = square_full
	squa.sound = square_sound
	squa.track = Timeline.Track.SQUARE
	square.add_child(squa)
	_beat_boxes.append(squa)
	
	return squa

func add_triangle(number:=1) -> BeatBox:
	triangle.show()

	var tri: BeatBox = BEAT_BOX.instantiate()
	tri.unchecked_icon = triangle_empty
	tri.checked_icon = triangle_full
	tri.sound = triangle_sound
	tri.track = Timeline.Track.TRIANG
	triangle.add_child(tri)
	_beat_boxes.append(tri)
	
	return tri

func add_circle(number:=1) -> BeatBox:
	circle.show()

	var circ: BeatBox = BEAT_BOX.instantiate()
	circ.unchecked_icon = circle_empty
	circ.checked_icon = circle_full
	circ.sound = circle_sound
	circ.track = Timeline.Track.CIRCLE
	circle.add_child(circ)
	_beat_boxes.append(circ)
	return circ

func add_diamond(number:=1) -> BeatBox:
	diamond.show()

	var dia: BeatBox = BEAT_BOX.instantiate()
	dia.unchecked_icon = diamond_empty
	dia.checked_icon = diamond_full
	dia.sound = diamond_sound
	dia.track = Timeline.Track.DIAMON
	diamond.add_child(dia)
	_beat_boxes.append(dia)

	return dia
