extends Area2D

func _ready():
	pass

func bodyEnter(body, obj):
	if body.is_in_group(global.PLAYER_GROUP):
		body.canInteract = true
		body.target = obj

func bodyExit(body, obj):
	if body.is_in_group(global.PLAYER_GROUP):
		body.canInteract = false
		body.target = null