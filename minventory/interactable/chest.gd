extends StaticBody2D

signal toggle_inventory()

@export var inventory_data: InventoryData

func player_interact() -> void:
	toggle_inventory.emit(self)
