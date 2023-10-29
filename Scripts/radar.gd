class_name Radar
extends Node2D

@export var front_visual: Sprite2D
@export var back_visual: Sprite2D

var player: Player

var _positions: Array[Vector3]
var _colors: Array[Color]

func _process(_delta):
	var scans := get_tree().get_nodes_in_group("Radar Scan")
	_positions.clear()
	_colors.clear()
	for item in scans:
		if !item is RadarScan: break
		var i := item as RadarScan
		
		_colors.append(i.radar_color)
		var z := player.to_global(Vector3.FORWARD) - player.global_position
		var x := player.to_global(Vector3.RIGHT) - player.global_position
		var y := player.to_global(Vector3.DOWN) - player.global_position
		
		var target: Vector3 = i.global_position
		var t := (target - player.global_position).normalized()
		var z_d = z.dot(t)
		var x_d = x.dot(t)
		var y_d = y.dot(t)
		
		_positions.append(Vector3(x_d, y_d, z_d))
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		print(_positions)
	queue_redraw()

const size: float = 194/2.0

func _draw():
	for index in _positions.size():
		var p := Vector2(_positions[index].x * size, _positions[index].y * size)
		p += front_visual.position if _positions[index].z >= 0 else back_visual.position
		draw_circle(p, 2.5, _colors[index])
