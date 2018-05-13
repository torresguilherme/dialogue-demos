extends Node2D

func _ready():
	var player = $player
	var interactables = get_tree().get_nodes_in_group(global.INTERACTABLE_GROUP)
	for i in interactables:
		var currNode = get_node(i.get_path())
		var areaNode = currNode.get_node("area")
		var args = [currNode]
		areaNode.connect("body_entered", areaNode, "bodyEnter", args)
		areaNode.connect("body_exited", areaNode, "bodyExit", args)
