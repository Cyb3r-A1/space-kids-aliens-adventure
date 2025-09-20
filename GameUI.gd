extends Control
class_name GameUI

# UI References
@onready var health_bar: ProgressBar = $HUD/HealthBar
@onready var energy_bar: ProgressBar = $HUD/EnergyBar
@onready var experience_bar: ProgressBar = $HUD/ExperienceBar
@onready var level_label: Label = $HUD/LevelLabel
@onready var name_label: Label = $HUD/NameLabel

# Inventory UI
@onready var inventory_panel: Panel = $InventoryPanel
@onready var inventory_grid: GridContainer = $InventoryPanel/ScrollContainer/GridContainer
@onready var inventory_close_btn: Button = $InventoryPanel/CloseButton

# Building UI
@onready var building_panel: Panel = $BuildingPanel
@onready var building_grid: GridContainer = $BuildingPanel/ScrollContainer/GridContainer
@onready var building_close_btn: Button = $BuildingPanel/CloseButton

# Animal Companion UI
@onready var companion_panel: Panel = $CompanionPanel
@onready var companion_list: VBoxContainer = $CompanionPanel/ScrollContainer/VBoxContainer
@onready var companion_close_btn: Button = $CompanionPanel/CloseButton

# Upgrade UI
@onready var upgrade_panel: Panel = $UpgradePanel
@onready var upgrade_close_btn: Button = $UpgradePanel/CloseButton

# Transformation UI
@onready var transformation_panel: Panel = $TransformationPanel
@onready var transformation_close_btn: Button = $TransformationPanel/CloseButton

# Game state
var kid_character: KidCharacter = null
var is_inventory_open: bool = false
var is_building_open: bool = false
var is_companion_open: bool = false
var is_upgrade_open: bool = false
var is_transformation_open: bool = false

func _ready():
	# Hide all panels initially
	inventory_panel.visible = false
	building_panel.visible = false
	companion_panel.visible = false
	upgrade_panel.visible = false
	transformation_panel.visible = false
	
	# Connect button signals
	inventory_close_btn.pressed.connect(_on_inventory_close)
	building_close_btn.pressed.connect(_on_building_close)
	companion_close_btn.pressed.connect(_on_companion_close)
	upgrade_close_btn.pressed.connect(_on_upgrade_close)
	transformation_close_btn.pressed.connect(_on_transformation_close)
	
	print("🎮 Game UI initialized!")

func _input(event):
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()
	elif event.is_action_pressed("toggle_building"):
		toggle_building_menu()
	elif event.is_action_pressed("toggle_companions"):
		toggle_companion_menu()
	elif event.is_action_pressed("toggle_upgrades"):
		toggle_upgrade_menu()
	elif event.is_action_pressed("toggle_transformation"):
		toggle_transformation_menu()

func set_kid_character(kid: KidCharacter):
	kid_character = kid
	
	# Connect signals
	kid.health_changed.connect(_on_health_changed)
	kid.energy_changed.connect(_on_energy_changed)
	kid.level_up.connect(_on_level_up)
	kid.inventory_changed.connect(_on_inventory_changed)
	kid.companion_added.connect(_on_companion_added)
	
	# Update initial UI
	update_hud()
	update_inventory_display()

func update_hud():
	if not kid_character:
		return
	
	health_bar.value = (kid_character.current_health / float(kid_character.max_health)) * 100
	energy_bar.value = (kid_character.energy / float(kid_character.max_energy)) * 100
	experience_bar.value = (kid_character.experience / float(kid_character.level * 100)) * 100
	level_label.text = "Level " + str(kid_character.level)
	name_label.text = kid_character.kid_name

# Inventory Management
func toggle_inventory():
	is_inventory_open = !is_inventory_open
	inventory_panel.visible = is_inventory_open
	
	if is_inventory_open:
		update_inventory_display()

func _on_inventory_close():
	is_inventory_open = false
	inventory_panel.visible = false

func update_inventory_display():
	if not kid_character:
		return
	
	# Clear existing items
	for child in inventory_grid.get_children():
		child.queue_free()
	
	# Add inventory items
	for item_name in kid_character.inventory:
		var quantity = kid_character.inventory[item_name]
		create_inventory_item(item_name, quantity)
	
	# Add building materials
	for material_name in kid_character.building_materials:
		var quantity = kid_character.building_materials[material_name]
		if quantity > 0:
			create_inventory_item(material_name, quantity, true)

func create_inventory_item(item_name: String, quantity: int, is_material: bool = false):
	var item_container = HBoxContainer.new()
	
	var item_label = Label.new()
	item_label.text = item_name.capitalize() + ": " + str(quantity)
	item_label.custom_minimum_size.x = 150
	
	var item_button = Button.new()
	item_button.text = "Use" if not is_material else "Info"
	item_button.custom_minimum_size.x = 60
	
	if not is_material:
		item_button.pressed.connect(_on_use_item.bind(item_name))
	else:
		item_button.pressed.connect(_on_material_info.bind(item_name))
	
	item_container.add_child(item_label)
	item_container.add_child(item_button)
	inventory_grid.add_child(item_container)

func _on_use_item(item_name: String):
	print("🔧 Using item: ", item_name)
	# Implement item usage logic

func _on_material_info(material_name: String):
	print("ℹ️ Material info: ", material_name)

# Building Menu
func toggle_building_menu():
	is_building_open = !is_building_open
	building_panel.visible = is_building_open
	
	if is_building_open:
		update_building_menu()

func _on_building_close():
	is_building_open = false
	building_panel.visible = false

func update_building_menu():
	if not kid_character:
		return
	
	# Clear existing items
	for child in building_grid.get_children():
		child.queue_free()
	
	# Add available buildings
	for recipe in kid_character.known_recipes:
		create_building_option(recipe)

func create_building_option(recipe_name: String):
	var building_container = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = recipe_name.replace("_", " ").capitalize()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	var build_button = Button.new()
	build_button.text = "Build"
	build_button.pressed.connect(_on_build_structure.bind(recipe_name))
	
	building_container.add_child(name_label)
	building_container.add_child(build_button)
	building_grid.add_child(building_container)

func _on_build_structure(recipe_name: String):
	print("🏗️ Building: ", recipe_name)
	# Implement building logic

# Companion Menu
func toggle_companion_menu():
	is_companion_open = !is_companion_open
	companion_panel.visible = is_companion_open
	
	if is_companion_open:
		update_companion_menu()

func _on_companion_close():
	is_companion_open = false
	companion_panel.visible = false

func update_companion_menu():
	if not kid_character:
		return
	
	# Clear existing items
	for child in companion_list.get_children():
		child.queue_free()
	
	# Add companions
	for companion in kid_character.animal_companions:
		create_companion_display(companion)

func create_companion_display(companion: AnimalCompanion):
	var companion_container = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = companion.animal_name + " (" + companion.get_animal_type_name() + ")"
	name_label.add_theme_font_size_override("font_size", 16)
	
	var stats_label = Label.new()
	stats_label.text = "Level: " + str(companion.level) + " | Health: " + str(companion.current_health) + "/" + str(companion.max_health)
	
	var happiness_label = Label.new()
	happiness_label.text = "Happiness: " + companion.get_happiness_status()
	
	var loyalty_label = Label.new()
	loyalty_label.text = "Loyalty: " + companion.get_loyalty_status()
	
	var ability_button = Button.new()
	ability_button.text = "Use " + companion.special_ability.replace("_", " ").capitalize()
	ability_button.pressed.connect(_on_use_companion_ability.bind(companion))
	
	companion_container.add_child(name_label)
	companion_container.add_child(stats_label)
	companion_container.add_child(happiness_label)
	companion_container.add_child(loyalty_label)
	companion_container.add_child(ability_button)
	companion_list.add_child(companion_container)

func _on_use_companion_ability(companion: AnimalCompanion):
	print("✨ Using ", companion.animal_name, "'s ability: ", companion.special_ability)
	companion.use_special_ability()

# Upgrade Menu
func toggle_upgrade_menu():
	is_upgrade_open = !is_upgrade_open
	upgrade_panel.visible = is_upgrade_open
	
	if is_upgrade_open:
		update_upgrade_menu()

func _on_upgrade_close():
	is_upgrade_open = false
	upgrade_panel.visible = false

func update_upgrade_menu():
	if not kid_character:
		return
	
	print("⚡ Upgrade menu opened!")
	# Implement upgrade menu logic

# Transformation Menu
func toggle_transformation_menu():
	is_transformation_open = !is_transformation_open
	transformation_panel.visible = is_transformation_open
	
	if is_transformation_open:
		update_transformation_menu()

func _on_transformation_close():
	is_transformation_open = false
	transformation_panel.visible = false

func update_transformation_menu():
	if not kid_character:
		return
	
	print("🔄 Transformation menu opened!")
	# Implement transformation menu logic

# Signal handlers
func _on_health_changed(new_health: int):
	update_hud()

func _on_energy_changed(new_energy: int):
	update_hud()

func _on_level_up(new_level: int):
	update_hud()
	print("🎉 Level up! Now level ", new_level)

func _on_inventory_changed():
	if is_inventory_open:
		update_inventory_display()

func _on_companion_added(companion: AnimalCompanion):
	if is_companion_open:
		update_companion_menu()
