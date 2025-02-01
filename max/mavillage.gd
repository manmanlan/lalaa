extends Node2D

@onready var player_1: CharacterBody2D = $player_1
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready() -> void:
	player_1.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player_1.inventory_data)

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
