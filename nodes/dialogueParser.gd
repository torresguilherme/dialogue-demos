extends Node

# TO DO: allow choices
var FILE_PATH = "res://json/dialogue.json"
var EVENTS_PATH = "res://json/events.json"

# control variables for dialogue
var counter
var inEventCounter
var isEnd = true
var inEvent = false
var inChoice = false

# references to nodes
onready var player = $"../player"
var targetPath
var textReference
var containerReference

# auxiliary dictionaries
var activeEvents
var lines 

func _ready():
	var eventsFile = File.new()
	# confere se o arquivo de eventos existe
	if !eventsFile.file_exists(EVENTS_PATH):
		print("error: couldn't find the events.json file: " + EVENTS_PATH)
		return
	# abre o arquivo
	eventsFile.open(EVENTS_PATH, File.READ)
	activeEvents = JSON.parse(eventsFile.get_as_text())
	# confere se deu erro
	if activeEvents.error != OK:
		print("error: could not parse .json. " + activeEvents.error_string + ". line: " + activeEvents.error_line)
		return

func initDialogue(target):
	isEnd = false
	# verifica se o arquivo exsite
	var dialogueFile = File.new()
	if !dialogueFile.file_exists(FILE_PATH):
		print("ERROR: dialogue file not found: " + FILE_PATH)
		return
	dialogueFile.open(FILE_PATH, File.READ)
	# pega o conteudo na forma de texto
	lines = JSON.parse(dialogueFile.get_as_text())
	# faz o display das linhas de dialogo
	if lines.error != OK:
		print("error: could not parse .json. " + lines.error_string + ". line: " + str(lines.error_line))
		return
	targetPath = str(target.get_path())
	counter = 0
	textReference = target.get_node("CL/Container/text")
	containerReference = target.get_node("CL/Container")
	forwardDialogue()
	# fecha o arquivo
	dialogueFile.close()

func forwardDialogue():
	if isEnd:
		endDialogue()
	else:
		counter += 1
		containerReference.visible = true
		var path = "default"
		if activeEvents:
			for event in activeEvents.result.keys():
				if activeEvents.result[event] == true && lines.result[targetPath].has(event):
					path = event
					if inEvent == false:
						counter = 1
						inEvent = true
		
		# set text
		textReference.text = lines.result[targetPath][path][str(counter)]["line"]
		
		#finishes dialogue if end
		if lines.result[targetPath][path][str(counter)].has("isEnd"):
			isEnd = lines.result[targetPath][path][str(counter)]["isEnd"]
		
		# sets custom counter
		if lines.result[targetPath][path][str(counter)].has("counter"):
			counter = lines.result[targetPath][path][str(counter)]["counter"]
		
		# choices
		if lines.result[targetPath][path][str(counter)].has("choices"):
			containerReference.get_node("choice-rect").visible = true
			inChoice = true
			for c in lines.result[targetPath][path][str(counter)]["choices"]:
				var newButton = Button.new()
				newButton.text = lines.result[targetPath][path][str(counter)]["choices"][c]["line"]
				containerReference.get_node("choice-rect/VBC").add_child(newButton)
		else:
			containerReference.get_node("choice-rect").visible = false
			inChoice = false
		
		if activeEvents:
			for event in activeEvents.result.keys():
				if lines.result[targetPath][path][str(counter)].has(event):
					activeEvents.result[event] = lines.result[targetPath][path][str(counter)][event]

func endDialogue():
	containerReference.visible = false
	counter = 0
	player.canMove = true
	player.inDialogue = false