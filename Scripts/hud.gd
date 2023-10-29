class_name HUD
extends Node2D

@export_category("Internal Items")
@export var speed_label: Label
@export var speed_slider: HSlider
@export var radar: Radar
@export var player: Player

var speed: float
var speed_control: float

func _ready():
	speed = 0
	radar.player = player
	_update_visual()

func _process(_delta):
	_update_visual()

func _update_visual():
	speed_label.text = "%.2f m/s" % speed
	speed_slider.set_value_no_signal(speed_control)
