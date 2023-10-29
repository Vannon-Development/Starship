class_name Player
extends CharacterBody3D

@export_category("Rotation Sensitivity")
@export var mouse_x_sensitivity: float
@export var mouse_y_sensitivity: float
@export var roll_sensitivity: float
@export_category("Movement Control")
@export var accel: float
@export var max_vel: float
@export var speed_sensitivity: float
@export_category("Firing Control")
@export var laser_origin: Array[Marker3D]
@export_category("Internal Links")
@export var forward_point: Marker3D
@export var up_point: Marker3D
@export var hud: HUD
@export_category("Scene Links")
@export var laser: PackedScene

var _mouse_delta: Vector2
var _roll_change: float
var _vel: float
var _speed_control: float
var _fire_index: int

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hud.player = self

func _process(delta: float):
	_speed_control = clampf(_speed_control + Input.get_axis("Accel Down", "Accel Up") * delta * speed_sensitivity, 0, 1)
	_roll_change = Input.get_axis("Roll C", "Roll CC") * delta
	if Input.is_action_just_pressed("Fire Laser"): _fire_laser()
	
	_calculate_velocity(delta)
	_update_hud_values()

func _physics_process(_delta: float):
	_set_rotation()
	
	var dir: Vector3 = (forward_point.global_position - global_position).normalized()
	velocity = dir * _vel
	var _col = move_and_slide()

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		_mouse_delta += (event as InputEventMouseMotion).relative

func _set_rotation():
	var yaw := _mouse_delta.x * mouse_x_sensitivity
	var pitch := _mouse_delta.y * mouse_y_sensitivity
	var roll := _roll_change * roll_sensitivity
	rotate_object_local(Vector3.DOWN, yaw)
	rotate_object_local(Vector3.RIGHT, pitch)
	rotate_object_local(Vector3.FORWARD, roll)
	_mouse_delta = Vector2.ZERO

func _calculate_velocity(delta: float):
	var target := max_vel * _speed_control
	var accel_max := accel * delta
	if absf(target - _vel) < accel_max: _vel = target
	else: _vel += accel_max * signf(target - _vel)

func _update_hud_values():
	hud.speed = _vel
	hud.speed_control = _speed_control

func _fire_laser():
	var shot := laser.instantiate() as Laser
	var origin := laser_origin[_fire_index]
	_fire_index = _fire_index + 1 if _fire_index < laser_origin.size() - 1 else 0
	shot.position = origin.global_position
	shot.rotation = origin.global_rotation
	add_sibling(shot)
