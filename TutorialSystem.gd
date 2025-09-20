extends Control
class_name TutorialSystem

# Tutorial system for guiding new players
var tutorial_steps: Array[Dictionary] = []
var current_step: int = 0
var is_tutorial_active: bool = false

# UI References
@onready var tutorial_panel: Panel = $TutorialPanel
@onready var tutorial_text: Label = $TutorialPanel/TutorialText
@onready var next_button: Button = $TutorialPanel/NextButton
@onready var skip_button: Button = $TutorialPanel/SkipButton

func _ready():
	setup_tutorial_steps()
	setup_ui()
	print("📚 Tutorial system initialized!")

func setup_tutorial_steps():
	tutorial_steps = [
		{
			"title": "Welcome to Adventure Kids & Animals!",
			"text": "Welcome! You're about to embark on an amazing adventure where you can build, explore, and befriend magical animals. Let's learn the basics!",
			"action": "none"
		},
		{
			"title": "Movement Controls",
			"text": "Use the arrow keys to move around. Press SPACE to jump. Try moving around to get familiar with the controls!",
			"action": "movement"
		},
		{
			"title": "Collecting Resources",
			"text": "Walk around the world to find colored blocks - these are resources! Press E when near them to collect wood, stone, metal, crystal, and magic dust.",
			"action": "collect"
		},
		{
			"title": "Building Your First House",
			"text": "Press B to open the building menu. Select 'Basic House' and place it somewhere. You'll need wood and stone to build it!",
			"action": "build"
		},
		{
			"title": "Meeting Animals",
			"text": "Look for animals roaming around! Press E near them to interact. Some animals can be caught and become your companions!",
			"action": "animals"
		},
		{
			"title": "Managing Your Companions",
			"text": "Press C to open your companion menu. Here you can see your animals' stats, happiness, and loyalty. Keep them happy!",
			"action": "companions"
		},
		{
			"title": "Using Special Abilities",
			"text": "Each animal has special abilities! Press S to use your current animal's ability. Try different animals to see their unique powers!",
			"action": "abilities"
		},
		{
			"title": "Upgrading and Transforming",
			"text": "Press U for upgrades and T for transformations. Build upgrade stations and transformation shrines to improve your kid and animals!",
			"action": "upgrades"
		},
		{
			"title": "Inventory Management",
			"text": "Press I to open your inventory. Here you can see all your items and materials. Use items to help your animals!",
			"action": "inventory"
		},
		{
			"title": "You're Ready!",
			"text": "You now know the basics! Explore, build, collect animals, and create your own adventure world. Have fun!",
			"action": "complete"
		}
	]

func setup_ui():
	tutorial_panel.visible = false
	next_button.pressed.connect(_on_next_button_pressed)
	skip_button.pressed.connect(_on_skip_button_pressed)

func start_tutorial():
	is_tutorial_active = true
	current_step = 0
	show_current_step()

func show_current_step():
	if current_step >= tutorial_steps.size():
		complete_tutorial()
		return
	
	var step = tutorial_steps[current_step]
	tutorial_text.text = step["title"] + "\n\n" + step["text"]
	tutorial_panel.visible = true
	
	# Highlight relevant UI elements based on action
	highlight_action(step["action"])

func highlight_action(action: String):
	match action:
		"movement":
			# Could add visual indicators for movement keys
			pass
		"collect":
			# Could highlight resource blocks
			pass
		"build":
			# Could highlight building menu
			pass
		"animals":
			# Could highlight animal companions
			pass
		"companions":
			# Could highlight companion menu
			pass
		"abilities":
			# Could highlight ability button
			pass
		"upgrades":
			# Could highlight upgrade/transformation menus
			pass
		"inventory":
			# Could highlight inventory button
			pass

func _on_next_button_pressed():
	current_step += 1
	show_current_step()

func _on_skip_button_pressed():
	complete_tutorial()

func complete_tutorial():
	is_tutorial_active = false
	tutorial_panel.visible = false
	print("🎉 Tutorial completed! Enjoy your adventure!")

func check_tutorial_progress():
	# Check if player has completed certain actions to advance tutorial
	if not is_tutorial_active:
		return
	
	var step = tutorial_steps[current_step]
	match step["action"]:
		"movement":
			# Check if player has moved around
			if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				advance_tutorial()
		"collect":
			# Check if player has collected resources
			# This would be checked by the game manager
			pass
		"build":
			# Check if player has built something
			# This would be checked by the game manager
			pass
		"animals":
			# Check if player has interacted with animals
			# This would be checked by the game manager
			pass

func advance_tutorial():
	current_step += 1
	show_current_step()

func _input(event):
	if is_tutorial_active:
		check_tutorial_progress()

# Called by game manager to advance tutorial based on player actions
func on_action_completed(action: String):
	if not is_tutorial_active:
		return
	
	var step = tutorial_steps[current_step]
	if step["action"] == action:
		advance_tutorial()
