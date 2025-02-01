extends Node

# Define the states using an enum for clarity
enum State { MAIN_MENU, GAME, PAUSE_MENU }

# Current state variable
var current_state = State.MAIN_MENU
