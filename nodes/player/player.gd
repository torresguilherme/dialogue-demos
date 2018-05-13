extends KinematicBody2D

var speed = 400
var up
var down
var left
var right
var target

# interaction
var canMove = true
var canInteract = false
var inDialogue = false

func _ready():
	add_to_group(global.PLAYER_GROUP)

func _process(delta):
	if Input.is_action_pressed("walkUp") && canMove:
		up = 1
	else:
		up = 0
	if Input.is_action_pressed("walkDown") && canMove:
		down = 1
	else:
		down = 0
	if Input.is_action_pressed("walkLeft") && canMove:
		left = 1
	else:
		left = 0
	if Input.is_action_pressed("walkRight") && canMove:
		right = 1
	else:
		right = 0
	
	if canInteract && Input.is_action_just_pressed("ui_accept"):
		if inDialogue == false:
			canMove = false
			inDialogue = true
			$"../dialogueParser".initDialogue(target)
		else:
			$"../dialogueParser".forwardDialogue()
	
	move_and_collide(Vector2(0.0, down-up) * speed * delta)
	move_and_collide(Vector2(right-left, 0.0) * speed * delta)