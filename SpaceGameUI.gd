extends Control
class_name SpaceGameUI

# UI References
@onready var hud: Control = $HUD
@onready var health_bar: ProgressBar = $HUD/HealthBar
@onready var energy_bar: ProgressBar = $HUD/EnergyBar
@onready var experience_bar: ProgressBar = $HUD/ExperienceBar
@onready var level_label: Label = $HUD/LevelLabel
@onready var name_label: Label = $HUD/NameLabel

@onready var inventory_panel: Panel = $InventoryPanel
@onready var building_panel: Panel = $BuildingPanel
@onready var companion_panel: Panel = $CompanionPanel
@onready var upgrade_panel: Panel = $UpgradePanel
@onready var transformation_panel: Panel = $TransformationPanel

@onready var inventory_grid: GridContainer = $InventoryPanel/ScrollContainer/GridContainer
@onready var building_grid: GridContainer = $BuildingPanel/ScrollContainer/GridContainer
@onready var companion_vbox: VBoxContainer = $CompanionPanel/ScrollContainer/VBoxContainer

var space_kid: SpaceKid = null

func _ready():
	# Connect close buttons
	$InventoryPanel/CloseButton.pressed.connect(_on_close_inventory)
	$BuildingPanel/CloseButton.pressed.connect(_on_close_building)
	$CompanionPanel/CloseButton.pressed.connect(_on_close_companion)
	$UpgradePanel/CloseButton.pressed.connect(_on_close_upgrade)
	$TransformationPanel/CloseButton.pressed.connect(_on_close_transformation)
	
	# Connect input events
	pass  # Input events handled in _input() function
	
	# Hide all panels initially
	hide_all_panels()

func set_space_kid(kid: SpaceKid):
	space_kid = kid
	if space_kid:
		# Connect signals
		space_kid.health_changed.connect(_on_health_changed)
		space_kid.energy_changed.connect(_on_energy_changed)
		space_kid.level_up.connect(_on_level_up)
		space_kid.inventory_changed.connect(_on_inventory_changed)
		space_kid.companion_added.connect(_on_companion_added)
		
		# Update initial values
		update_hud()

func _input(event: InputEvent):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()
	elif event.is_action_pressed("toggle_building"):
		toggle_building()
	elif event.is_action_pressed("toggle_companions"):
		toggle_companion()
	elif event.is_action_pressed("toggle_upgrades"):
		toggle_upgrade()
	elif event.is_action_pressed("toggle_transformation"):
		toggle_transformation()

func hide_all_panels():
	inventory_panel.hide()
	building_panel.hide()
	companion_panel.hide()
	upgrade_panel.hide()
	transformation_panel.hide()

func toggle_inventory():
	if inventory_panel.visible:
		inventory_panel.hide()
	else:
		hide_all_panels()
		update_inventory()
		inventory_panel.show()

func toggle_building():
	if building_panel.visible:
		building_panel.hide()
	else:
		hide_all_panels()
		update_building_menu()
		building_panel.show()

func toggle_companion():
	if companion_panel.visible:
		companion_panel.hide()
	else:
		hide_all_panels()
		update_companion_menu()
		companion_panel.show()

func toggle_upgrade():
	if upgrade_panel.visible:
		upgrade_panel.hide()
	else:
		hide_all_panels()
		update_upgrade_menu()
		upgrade_panel.show()

func toggle_transformation():
	if transformation_panel.visible:
		transformation_panel.hide()
	else:
		hide_all_panels()
		update_transformation_menu()
		transformation_panel.show()

func update_hud():
	if not space_kid:
		return
	
	health_bar.value = (space_kid.current_health / float(space_kid.max_health)) * 100
	energy_bar.value = (space_kid.energy / float(space_kid.max_energy)) * 100
	experience_bar.value = (space_kid.experience / float(space_kid.level * 100)) * 100
	level_label.text = "Level " + str(space_kid.level)
	name_label.text = space_kid.kid_name

func update_inventory():
	inventory_grid.queue_free_children()
	
	if not space_kid:
		return
	
	for item_name in space_kid.inventory:
		var item_count = space_kid.inventory[item_name]
		if item_count > 0:
			var item_button = Button.new()
			item_button.text = item_name + " x" + str(item_count)
			item_button.pressed.connect(_on_use_item.bind(item_name))
			inventory_grid.add_child(item_button)

func update_building_menu():
	building_grid.queue_free_children()
	
	# Space building types
	var building_types = [
		"Space Station",
		"Research Lab", 
		"Defense Turret",
		"Resource Extractor",
		"Communication Array",
		"Warp Gate",
		"Shield Generator",
		"Energy Core"
	]
	
	for building_type in building_types:
		var build_button = Button.new()
		build_button.text = building_type
		build_button.pressed.connect(_on_build_structure.bind(building_type))
		building_grid.add_child(build_button)

func update_companion_menu():
	companion_vbox.queue_free_children()
	
	if not space_kid:
		return
	
	# Show alien companions
	var companion_label = Label.new()
	companion_label.text = "Alien Companions:"
	companion_vbox.add_child(companion_label)
	
	for companion in space_kid.alien_companions:
		var companion_button = Button.new()
		companion_button.text = companion.alien_name + " (Level " + str(companion.level) + ")"
		companion_button.pressed.connect(_on_select_companion.bind(companion))
		companion_vbox.add_child(companion_button)

func update_upgrade_menu():
	# Add upgrade options here
	pass

func update_transformation_menu():
	# Add transformation options here
	pass

func _on_health_changed(current_health: int, max_health: int):
	health_bar.value = (current_health / float(max_health)) * 100

func _on_energy_changed(current_energy: int, max_energy: int):
	energy_bar.value = (current_energy / float(max_energy)) * 100

func _on_experience_changed(current_exp: int, required_exp: int):
	experience_bar.value = (current_exp / float(required_exp)) * 100

func _on_level_up(new_level: int):
	level_label.text = "Level " + str(new_level)
	print("🎉 Level up! Now level ", new_level)

func _on_use_item(item_name: String):
	if space_kid:
		space_kid.use_item(item_name)

func _on_build_structure(building_type: String):
	if space_kid:
		space_kid.start_building()

func _on_inventory_changed():
	update_inventory()

func _on_companion_added(companion: AlienCompanion):
	update_companion_menu()

func _on_select_companion(companion: AlienCompanion):
	if space_kid:
		space_kid.select_companion(companion)

func _on_close_inventory():
	inventory_panel.hide()

func _on_close_building():
	building_panel.hide()

func _on_close_companion():
	companion_panel.hide()

func _on_close_upgrade():
	upgrade_panel.hide()

func _on_close_transformation():
	transformation_panel.hide()
