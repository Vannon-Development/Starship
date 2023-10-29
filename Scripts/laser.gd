class_name Laser
extends Node3D

@export var speed: float
@export var forward_point: Marker3D

var _velocity: Vector3

var _die_time: int

func _ready():
	_velocity = speed * (forward_point.global_position - global_position).normalized()
	_die_time = Time.get_ticks_msec() + 3000

func _physics_process(delta: float):
	var motion: Vector3 = _velocity * delta
	global_position += motion
	if _test_hit(motion): queue_free()
	if Time.get_ticks_msec() > _die_time: queue_free()

func _test_hit(motion: Vector3) -> bool:
	var collision_mask: int = 1
	var query := PhysicsRayQueryParameters3D.create(global_position, global_position + motion, collision_mask)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result: 
		@warning_ignore("unsafe_method_access")
		result.collider.laser_hit()
		return true
	
	return false
