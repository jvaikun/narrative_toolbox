class_name Timeline
extends Resource

@export var events : Array[Event]


func compile() -> void:
	build_tree(events)


func build_tree(trunk : Array[Event]) -> void:
	# Create key-value list of tag_id and array indices
	var tl_length : int = trunk.size()
	var this_event : Event = null
	var not_at_end : bool = true
	for i in tl_length:
		this_event = trunk[i]
		not_at_end = (i != tl_length-1)
		if i != 0:
			this_event.prev_events.append(trunk[i-1])
		if this_event is EventChoice:
			for j in this_event.choices.size():
				var branch = this_event.choices[j].events
				if branch.is_empty():
					if not_at_end:
						this_event.next_events.append(trunk[i+1])
				else:
					this_event.next_events.append(branch[0])
					build_tree(branch)
					if not_at_end:
						branch[-1].next_events.append(trunk[i+1])
		elif not_at_end:
			this_event.next_events.append(trunk[i+1])
