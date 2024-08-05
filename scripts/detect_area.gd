extends Area2D

signal player_detected(body: Node2D)

func _on_body_entered(body):
	player_detected.emit(body)

func _on_body_exited(body):
	player_detected.emit(null)
