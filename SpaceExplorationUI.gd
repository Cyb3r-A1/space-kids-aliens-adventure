extends Control
class_name SpaceExplorationUI

# UI References
@onready var galaxy_map_panel: Panel = $GalaxyMapPanel
@onready var planet_info_panel: Panel = $PlanetInfoPanel
@onready var terraforming_panel: Panel = $TerraformingPanel
@onready var travel_panel: Panel = $TravelPanel

# Galaxy Map UI
@onready var galaxy_list: VBoxContainer = $GalaxyMapPanel/ScrollContainer/VBoxContainer
@onready var galaxy_close_btn: Button = $GalaxyMapPanel/CloseButton

# Planet Info UI
@onready var planet_name_label: Label = $PlanetInfoPanel/PlanetNameLabel
@onready var planet_type_label: Label = $PlanetInfoPanel/PlanetTypeLabel
@onready var planet_status_label: Label = $PlanetInfoPanel/PlanetStatusLabel
@onready var planet_resources_list: VBoxContainer = $PlanetInfoPanel/ScrollContainer/VBoxContainer
@onready var planet_close_btn: Button = $PlanetInfoPanel/CloseButton

# Terraforming UI
@onready var terraforming_progress: ProgressBar = $TerraformingPanel/TerraformingProgress
@onready var terraforming_requirements_list: VBoxContainer = $TerraformingPanel/ScrollContainer/VBoxContainer
@onready var terraform_button: Button = $TerraformingPanel/TerraformButton
@onready var terraforming_close_btn: Button = $TerraformingPanel/CloseButton

# Travel UI
@onready var travel_status_label: Label = $TravelPanel/TravelStatusLabel
@onready var fuel_bar: ProgressBar = $TravelPanel/FuelBar
@onready var destination_list: VBoxContainer = $TravelPanel/ScrollContainer/VBoxContainer
@onready var travel_button: Button = $TravelPanel/TravelButton
@onready var travel_close_btn: Button = $TravelPanel/CloseButton

# Game state
var space_kid: SpaceKid = null
var space_travel_system: SpaceTravelSystem = null
var current_planet: Planet = null
var is_galaxy_map_open: bool = false
var is_planet_info_open: bool = false
var is_terraforming_open: bool = false
var is_travel_open: bool = false

func _ready():
	setup_ui()
	print("🗺️ Space Exploration UI initialized!")

func setup_ui():
	# Hide all panels initially
	galaxy_map_panel.visible = false
	planet_info_panel.visible = false
	terraforming_panel.visible = false
	travel_panel.visible = false
	
	# Connect button signals
	galaxy_close_btn.pressed.connect(_on_galaxy_map_close)
	planet_close_btn.pressed.connect(_on_planet_info_close)
	terraforming_close_btn.pressed.connect(_on_terraforming_close)
	travel_close_btn.pressed.connect(_on_travel_close)
	terraform_button.pressed.connect(_on_terraform_planet)
	travel_button.pressed.connect(_on_travel_to_destination)

func set_space_kid(kid: SpaceKid):
	space_kid = kid

func set_space_travel_system(travel_system: SpaceTravelSystem):
	space_travel_system = travel_system

func _input(event):
	if event.is_action_pressed("toggle_galaxy_map"):
		toggle_galaxy_map()
	elif event.is_action_pressed("toggle_planet_info"):
		toggle_planet_info()
	elif event.is_action_pressed("toggle_terraforming"):
		toggle_terraforming()
	elif event.is_action_pressed("toggle_travel"):
		toggle_travel()

# Galaxy Map Functions
func toggle_galaxy_map():
	is_galaxy_map_open = !is_galaxy_map_open
	galaxy_map_panel.visible = is_galaxy_map_open
	
	if is_galaxy_map_open:
		update_galaxy_map()

func _on_galaxy_map_close():
	is_galaxy_map_open = false
	galaxy_map_panel.visible = false

func update_galaxy_map():
	# Clear existing galaxies
	for child in galaxy_list.get_children():
		child.queue_free()
	
	# Add galaxies
	if space_travel_system:
		var destinations = space_travel_system.get_available_destinations()
		for galaxy_data in destinations["galaxies"]:
			create_galaxy_entry(galaxy_data)

func create_galaxy_entry(galaxy_data: Dictionary):
	var galaxy_container = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = galaxy_data["name"]
	name_label.add_theme_font_size_override("font_size", 16)
	
	var type_label = Label.new()
	type_label.text = "Type: " + galaxy_data["type"]
	
	var status_label = Label.new()
	status_label.text = "Status: " + galaxy_data["status"]
	
	var travel_button = Button.new()
	travel_button.text = "Travel to Galaxy"
	travel_button.pressed.connect(_on_travel_to_galaxy.bind(galaxy_data["name"]))
	
	galaxy_container.add_child(name_label)
	galaxy_container.add_child(type_label)
	galaxy_container.add_child(status_label)
	galaxy_container.add_child(travel_button)
	galaxy_list.add_child(galaxy_container)

func _on_travel_to_galaxy(galaxy_name: String):
	print("🚀 Traveling to galaxy: ", galaxy_name)
	# Implement galaxy travel logic

# Planet Info Functions
func toggle_planet_info():
	is_planet_info_open = !is_planet_info_open
	planet_info_panel.visible = is_planet_info_open
	
	if is_planet_info_open and current_planet:
		update_planet_info()

func _on_planet_info_close():
	is_planet_info_open = false
	planet_info_panel.visible = false

func update_planet_info():
	if not current_planet:
		return
	
	planet_name_label.text = current_planet.planet_name
	planet_type_label.text = "Type: " + current_planet.get_planet_type_name()
	planet_status_label.text = "Status: " + current_planet.get_planet_status()
	
	# Update resources
	update_planet_resources()

func update_planet_resources():
	# Clear existing resources
	for child in planet_resources_list.get_children():
		child.queue_free()
	
	# Add resources
	if current_planet:
		for resource in current_planet.planet_resources:
			var amount = current_planet.planet_resources[resource]
			var max_amount = current_planet.max_resources[resource]
			
			var resource_container = HBoxContainer.new()
			
			var resource_label = Label.new()
			resource_label.text = resource.replace("_", " ").capitalize() + ": " + str(amount) + "/" + str(max_amount)
			resource_label.custom_minimum_size.x = 200
			
			var extract_button = Button.new()
			extract_button.text = "Extract"
			extract_button.custom_minimum_size.x = 80
			extract_button.pressed.connect(_on_extract_resource.bind(resource))
			
			resource_container.add_child(resource_label)
			resource_container.add_child(extract_button)
			planet_resources_list.add_child(resource_container)

func _on_extract_resource(resource_type: String):
	if current_planet and space_kid:
		var extracted = current_planet.extract_resources(resource_type, 10)
		if extracted > 0:
			space_kid.add_material(resource_type, extracted)
			print("📦 Extracted ", extracted, " ", resource_type, " from ", current_planet.planet_name)
			update_planet_resources()

# Terraforming Functions
func toggle_terraforming():
	is_terraforming_open = !is_terraforming_open
	terraforming_panel.visible = is_terraforming_open
	
	if is_terraforming_open and current_planet:
		update_terraforming_info()

func _on_terraforming_close():
	is_terraforming_open = false
	terraforming_panel.visible = false

func update_terraforming_info():
	if not current_planet:
		return
	
	# Update progress
	terraforming_progress.value = current_planet.terraforming_progress * 100
	
	# Update requirements
	update_terraforming_requirements()

func update_terraforming_requirements():
	# Clear existing requirements
	for child in terraforming_requirements_list.get_children():
		child.queue_free()
	
	# Add requirements
	if current_planet:
		for material in current_planet.terraforming_requirements:
			var required = current_planet.terraforming_requirements[material]
			var has_amount = space_kid.inventory.get(material, 0) if space_kid else 0
			
			var requirement_container = HBoxContainer.new()
			
			var material_label = Label.new()
			material_label.text = material.replace("_", " ").capitalize() + ": " + str(has_amount) + "/" + str(required)
			material_label.custom_minimum_size.x = 200
			
			var status_label = Label.new()
			if has_amount >= required:
				status_label.text = "✓ Ready"
				status_label.modulate = Color.GREEN
			else:
				status_label.text = "✗ Missing"
				status_label.modulate = Color.RED
			
			requirement_container.add_child(material_label)
			requirement_container.add_child(status_label)
			terraforming_requirements_list.add_child(requirement_container)

func _on_terraform_planet():
	if current_planet and space_kid:
		current_planet.start_terraforming(space_kid)
		print("🌱 Started terraforming ", current_planet.planet_name)

# Travel Functions
func toggle_travel():
	is_travel_open = !is_travel_open
	travel_panel.visible = is_travel_open
	
	if is_travel_open:
		update_travel_info()

func _on_travel_close():
	is_travel_open = false
	travel_panel.visible = false

func update_travel_info():
	if not space_travel_system:
		return
	
	# Update travel status
	travel_status_label.text = space_travel_system.get_travel_status()
	
	# Update fuel bar
	fuel_bar.value = (space_travel_system.current_fuel / float(space_travel_system.fuel_capacity)) * 100
	
	# Update destinations
	update_destinations()

func update_destinations():
	# Clear existing destinations
	for child in destination_list.get_children():
		child.queue_free()
	
	# Add destinations
	if space_travel_system:
		var destinations = space_travel_system.get_available_destinations()
		
		# Add planets
		for planet_data in destinations["planets"]:
			create_destination_entry("Planet", planet_data)
		
		# Add systems
		for system_data in destinations["systems"]:
			create_destination_entry("System", system_data)
		
		# Add galaxies
		for galaxy_data in destinations["galaxies"]:
			create_destination_entry("Galaxy", galaxy_data)

func create_destination_entry(type: String, data: Dictionary):
	var destination_container = VBoxContainer.new()
	
	var name_label = Label.new()
	name_label.text = type + ": " + data["name"]
	name_label.add_theme_font_size_override("font_size", 14)
	
	var info_label = Label.new()
	if type == "Planet":
		info_label.text = "Type: " + data["type"] + " | Status: " + data["status"]
	elif type == "System":
		info_label.text = "Planets: " + str(data["planet_count"]) + " | Status: " + data["status"]
	elif type == "Galaxy":
		info_label.text = "Type: " + data["type"] + " | Status: " + data["status"]
	
	var travel_button = Button.new()
	travel_button.text = "Travel"
	travel_button.custom_minimum_size.x = 80
	travel_button.pressed.connect(_on_travel_to_destination.bind(type, data["name"]))
	
	destination_container.add_child(name_label)
	destination_container.add_child(info_label)
	destination_container.add_child(travel_button)
	destination_list.add_child(destination_container)

func _on_travel_to_destination(type: String, name: String):
	print("🚀 Traveling to ", type, ": ", name)
	# Implement travel logic based on type

# Public functions for external use
func set_current_planet(planet: Planet):
	current_planet = planet
	if is_planet_info_open:
		update_planet_info()
	if is_terraforming_open:
		update_terraforming_info()

func update_all_panels():
	if is_galaxy_map_open:
		update_galaxy_map()
	if is_planet_info_open:
		update_planet_info()
	if is_terraforming_open:
		update_terraforming_info()
	if is_travel_open:
		update_travel_info()
