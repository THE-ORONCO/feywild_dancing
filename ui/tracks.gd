class_name Tracks
extends Control

@export_range(1, 100) var segments := 10
var instruments := 3

const BEAT_BOX = preload("uid://cjvt3mcjpkrdc")

@onready var square: VBoxContainer = %Square
@onready var circle: VBoxContainer = %Circle
@onready var triangle: VBoxContainer = %Triangle

const CIRCLE_SOUND = preload("uid://1qqvv4bys23h")
const TIMELINE_ICON_CIRCLE_EMPTY = preload("uid://dhrop4am2idq5")
const TIMELINE_ICON_CIRCLE_FULL = preload("uid://dv2yuyv2xofd")

const SQUARE_SOUND = preload("uid://dmdfhemij0u7d")
const TIMELINE_ICON_SQUARE_EMPTY = preload("uid://dk5iur5q7efwa")
const TIMELINE_ICON_SQUARE_FULL = preload("uid://cxgm072xlw3j2")

const TRI_SOUND = preload("uid://cn4t0bfycbj36")
const TIMELINE_ICON_TRI_EMPTY = preload("uid://wxwrbc62cxnq")
const TIMELINE_ICON_TRI_FULL = preload("uid://45kdtvib7r40")

var _beat_boxes: Array[BeatBox] = []

func _ready() -> void:
	
	var i := 0
	
	for s in range(segments):
		i+= 1
		var circ: BeatBox = BEAT_BOX.instantiate()
		circ.unchecked_icon = TIMELINE_ICON_CIRCLE_EMPTY
		circ.checked_icon = TIMELINE_ICON_CIRCLE_FULL
		circ.sound = CIRCLE_SOUND
		circ.track = Timeline.Track.CIRCLE
		circle.add_child(circ)
		_beat_boxes.append(circ)
		
		#if i %2 == 0:
		var tri: BeatBox = BEAT_BOX.instantiate()
		tri.unchecked_icon = TIMELINE_ICON_TRI_EMPTY
		tri.checked_icon = TIMELINE_ICON_TRI_FULL
		tri.sound = TRI_SOUND
		tri.track = Timeline.Track.TRIANG
		triangle.add_child(tri)
		_beat_boxes.append(tri)
		
		#if i % 3 == 0:
		var squa: BeatBox = BEAT_BOX.instantiate()
		squa.unchecked_icon = TIMELINE_ICON_SQUARE_EMPTY
		squa.checked_icon = TIMELINE_ICON_SQUARE_FULL
		squa.sound = SQUARE_SOUND
		squa.track = Timeline.Track.SQUARE
		square.add_child(squa)
		_beat_boxes.append(squa)

func hit_range(from: float, to: float) -> void:
	var own_height := self.size.y
	for beat_box in _beat_boxes:
		var along_ratio := beat_box.center.y / own_height
		if from <= along_ratio and along_ratio <= to:
			beat_box.hit() 
