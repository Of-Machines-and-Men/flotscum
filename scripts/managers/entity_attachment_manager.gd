extends Node

class AbsorptionRequest:
	var absorber: Entity
	var target: Entity
	
	func _init(a: Entity, t: Entity) -> void:
		absorber = a
		target = t
		
var _queue: Array[AbsorptionRequest] = []

func _is_duplicate(request: AbsorptionRequest, queue_entry: AbsorptionRequest):
	if (request.target == queue_entry.target or request.target == queue_entry.absorber) and (request.absorber == queue_entry.target or request.absorber == queue_entry.absorber):
		return true
	return false

func _add_queue_entry(absorber: Entity, target: Entity) -> void:
	var request = AbsorptionRequest.new(absorber, target)
	for entry in _queue:
		if _is_duplicate(request, entry):
			return
	_queue.append(request)

func _get_cluster_root(entity: Entity) -> Node:
	var current: Node = entity
	while current.get_parent() is Entity:
		current = current.get_parent()
	return current

func request_absorb(absorber: Entity, target: Entity) -> void:
	var absorber_root = _get_cluster_root(absorber)
	var target_root = _get_cluster_root(target)
	
	if absorber_root == target_root or not (absorber_root.can_be_absorbed or target_root.can_be_absorbed):
		return
	
	if absorber.absorber_priority >= target.absorber_priority:
		_add_queue_entry(absorber, target)
	else:
		_add_queue_entry(target, absorber)

func _process(_delta: float) -> void:
	if _queue.is_empty():
		return
	for request in _queue:
		var absorber_root = _get_cluster_root(request.absorber)
		var target_root = _get_cluster_root(request.target)
		
		if absorber_root == target_root or not (absorber_root.can_be_absorbed or target_root.can_be_absorbed):
			return
		request.target.on_impact(request.absorber)
	_queue.clear()
	
