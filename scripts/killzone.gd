extends Area2D

signal player_hit

func _on_body_entered(body):
	player_hit.emit()
