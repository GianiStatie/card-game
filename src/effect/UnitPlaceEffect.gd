extends Line2D

@onready var arrow_head = $Sprite2D

func update(start_position, end_position):
	points[0] = start_position
	points[1] = end_position
	points[2] = end_position
	
	arrow_head.global_position = end_position
	
	var direction = Vector2.ZERO
	direction.x = end_position.x - start_position.x
	direction.y = start_position.y - end_position.y
	var arrow_head_angle = direction.normalized().angle_to(Vector2.DOWN)
	
	arrow_head.rotation = arrow_head_angle
