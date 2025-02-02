extends Node2D

const PickUp = preload("res://minventory/item/pick_up/pick_up.tscn")

@onready var player_1: CharacterBody2D = $player_1
@onready var inventory_interface: Control = $UI/InventoryInterface

func _ready() -> void:
	player_1.toggle_inventory.connect(toggle_inventory_interface)
	inventory_interface.set_player_inventory_data(player_1.inventory_data)
	
	for Node2D in get_tree().get_nodes_in_group("external_inventory"):
		Node2D.toggle_inventory.connect(toggle_inventory_interface)

func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()


func _on_inventory_interface_2_drop_slot_data(slot_data: SlotData) -> void:
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = Vector3.UP
	add_child(pick_up)
