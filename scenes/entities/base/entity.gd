class_name Entity
extends RigidBody2D

@export var entity_sprite: Sprite2D
@export var collider: CollisionShape2D
@export var impact_zone: Area2D
@export var impact_collider: CollisionShape2D

@export var absorber_priority: int = 0
@export var can_be_absorbed: bool = true

var is_attached: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("entities")
	gravity_scale = 0.0
	if impact_zone:
		impact_zone.body_entered.connect(_on_absorption_zone_overlap)
	
func _physics_process(_delta: float) -> void:
	if is_attached:
		return
	_apply_current_force()

func _apply_current_force() -> void:
	var current_direction = _get_ocean_current_direction()
	var current_strength = _get_ocean_current_strength()
	var current_influence = 1.0 / mass
	apply_central_force(current_direction * current_strength * current_influence)
	
func _get_ocean_current_direction() -> Vector2:
	return OceanCurrentManager.get_current_direction_at_location(global_position)

func _get_ocean_current_strength() -> float:
	return OceanCurrentManager.get_current_strength_at_location(global_position)

func _on_absorption_zone_overlap(overlapped: Node) -> void:
	if not impact_zone or overlapped == self:
		return
	if overlapped is Entity and overlapped.can_be_absorbed:
		EntityAttachmentManager.request_absorb(self, overlapped)

func _on_absorbed(absorber: Node) -> void:
	is_attached = true
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	
	# To prevent physics glitches, don't collide with entities we've already collided with
	add_collision_exception_with(absorber)
	absorber.add_collision_exception_with(self)
	
	call_deferred("reparent", absorber, true)

func on_impact(impacted_entity: Entity) -> void:
	if not is_attached:
		_on_absorbed(impacted_entity)
