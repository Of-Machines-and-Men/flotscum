class_name Entity
extends RigidBody2D

@export var entity_sprite: Sprite2D
@export var collider: CollisionShape2D
@export var spawn_sound: AudioStream
@export var impact_zone: Area2D
@export var perception_zone: Area2D
@export var base_min_range: float = 0.0
@export var base_max_range: float = 0.0

@export var faction: FactionManager.Faction = FactionManager.Faction.NEUTRAL
@export var movement_abilities: Array[Ability] = []
@export var default_stance: Enums.Stance = Enums.Stance.PASSIVE
@export var default_behaviour: Ability

@export var motor_force: float = 100.0
@export var motor_torque: float = 100.0
@export var torque_damping: float = 1.0

@export var base_health: int = 10
@export var absorber_priority: int = 0
@export var can_be_attached: bool = true
@export var can_be_reattached: bool = false
@export var sink_duration: float = 2.0
@export var reattachment_delay: float = 1.0
@export var invulnerability_delay: float = 0.5

@export var decision_interval: float = 1.0

@onready var _spawn_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

var _perceived_predators: Array[Entity] = []
var _perceived_prey: Array[Entity] = []

var _current_stance: Enums.Stance = default_stance

var _decision_timer: float = decision_interval
var _current_behaviour: Ability

var _invulnerability_timer: float = invulnerability_delay

var current_health: int = 10
var is_attached: bool = false
var ready_for_cleanup = false

#region attribute getters and setters

func _set_behaviour(behaviour: Ability) -> void:
	if not behaviour:
		_current_behaviour.on_deactivated(self)
		_current_behaviour = default_behaviour
	if behaviour and not behaviour == _current_behaviour:
		if _current_behaviour:
			_current_behaviour.on_deactivated(self)
		behaviour.on_activated(self)
		_current_behaviour = behaviour

func get_min_range() -> float:
	return base_min_range

func get_max_range() -> float:
	return base_max_range

#endregion

#region basic node behaviour

func _ready() -> void:
	add_to_group("entities")
	gravity_scale = 0.0
	#Add audio player dynamically
	if spawn_sound:
		_spawn_player.stream = spawn_sound
		_spawn_player.play()
	if impact_zone:
		impact_zone.body_entered.connect(_on_absorption_zone_overlap)
	if perception_zone:
		perception_zone.body_entered.connect(_on_perception_zone_entered)
		perception_zone.body_exited.connect(_on_perception_zone_exited)
	
func _physics_process(delta: float) -> void:
	if is_attached:
		return
	_invulnerability_timer -= delta
	_decision_timer -= delta
	if _decision_timer <= 0.0:
		trigger_decision("decision time reached")
	act(delta)

#endregion

#region movement

func engage_engine(force: float) -> void:
	var forward = Vector2.RIGHT.rotated(rotation)
	apply_central_force(forward * force)

func is_facing(target_direction: Vector2, threshold: float) -> float:
	var target_angle = target_direction.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	return angle_diff <= threshold
	
func turn_towards(target_direction: Vector2) -> void:
	var target_angle = target_direction.angle()
	var angle_diff = wrapf(target_angle - rotation, -PI, PI)
	apply_torque(angle_diff * motor_torque * mass)
	angular_velocity *= (1.0 - torque_damping * get_physics_process_delta_time())

#endregion

#region ai handles

func _reset_decision_timer() -> void:
	_decision_timer = decision_interval

func trigger_decision(_reason: String) -> void:
	perceive()
	think()
	_reset_decision_timer()

func perceive() -> void:
	# primarily handled by the zone overlaps, but can be overridden
	pass

func think() -> void:
	if (_current_stance == Enums.Stance.AGGRESSIVE) && _perceived_prey.size() > 0:
		_set_behaviour(_get_most_aggressive_ability())
	elif _perceived_predators.size() > 0:
		_set_behaviour(_get_least_aggressive_ability())
	else:
		_set_behaviour(default_behaviour)

func get_priority_predator() -> Entity:
	var target: Entity = null
	var current_target_distance: float = INF
	if _perceived_predators.is_empty():
		return null
	for predator in _perceived_predators:
		var target_distance = global_position.distance_to(predator.global_position)
		if not target or target_distance < current_target_distance:
			current_target_distance = target_distance
			target = predator
	return target

func get_priority_prey() -> Entity:
	var target: Entity = null
	var current_target_distance: float = INF
	if _perceived_prey.is_empty():
		return null
	for prey in _perceived_prey:
		var target_distance = global_position.distance_to(prey.global_position)
		if not target or target_distance < current_target_distance:
			current_target_distance = target_distance
			target = prey
	return target

func _get_most_aggressive_ability():
	var best_match: Ability = null
	for ability in movement_abilities:
		if not best_match or ability.aggression > best_match.aggression:
			best_match = ability
	return best_match if best_match else default_behaviour

func _get_least_aggressive_ability():
	var best_match: Ability = null
	for ability in movement_abilities:
		if not best_match or ability.aggression > best_match.aggression:
			best_match = ability
	return best_match if best_match else default_behaviour

func act(delta: float) -> void:
	if _current_behaviour:
		_current_behaviour.act(self, delta)

#endregion

#region perception

func _on_perception_zone_entered(perceived: Node) -> void:
	if not perceived is Entity:
		return
	if FactionManager.is_predator(faction, perceived.faction):
		_perceived_predators.append(perceived)
	if FactionManager.is_prey(faction, perceived.faction):
		_perceived_prey.append(perceived)
	trigger_decision("perception_completed")
	
func _on_perception_zone_exited(unperceived: Node) -> void:
	_perceived_predators.erase(unperceived)
	_perceived_prey.erase(unperceived)

#endregion

#region collision handling

func _on_absorption_zone_overlap(overlapped: Node) -> void:
	if not impact_zone or overlapped == self:
		return
	if overlapped is Entity and overlapped.can_be_attached:
		EntityAttachmentManager.request_attach(self, overlapped)

func on_impact(impacted_entity: Entity) -> void:
	if not is_attached:
		_on_attach(impacted_entity)

#endregion

#region health and lifecycle

func on_apply_damage(damage: int, target: Node):
	if target is Entity:
		target.on_receive_damage(damage)

func on_receive_damage(damage: int, _damage_dealer: Node):
	if _invulnerability_timer <= 0.0:
		_invulnerability_timer = invulnerability_delay
		current_health -= damage
		trigger_decision("received damage")
		if current_health <= 0:
			_on_death()

func _on_death():
	movement_abilities.clear()
	default_behaviour = DriftAbility.new()
	if perception_zone:
		perception_zone.monitoring = false
	if is_attached:
		_on_detach()
	await get_tree().create_timer(sink_duration).timeout
	if is_instance_valid(self) and not is_attached:
		queue_free()

func _on_attach(absorber: Node) -> void:
	is_attached = true
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	
	# To prevent physics glitches, don't collide with entities we've already collided with
	add_collision_exception_with(absorber)
	absorber.add_collision_exception_with(self)
	
	call_deferred("reparent", absorber, true)

func _on_detach() -> void:
	if not is_attached:
		return
	var world = get_tree().get_first_node_in_group("world")
	reparent(world, true)
	is_attached = false
	freeze = false
	if can_be_reattached:
		await get_tree().create_timer(reattachment_delay).timeout
		can_be_attached = true
		current_health = base_health

#endregion
