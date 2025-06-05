class_name ActionCounterManager

extends Node

var actions_available: int = 0
var actions_remaining: int = 0

signal action_counter_updated(available: int, remaining: int)

func _ready():
  # Connect to the GameState signal to update actions when they change
  GameState.connect("load_action_counter", Callable(self, "_on_action_counter_loaded"))

func _on_action_counter_loaded(available: int, remaining: int) -> void:
  print("ActionCounterManager: Loaded action counter with available:", available, "remaining:", remaining)
  actions_available = available
  actions_remaining = remaining

  # Update the UI or any other components that depend on the action counter
  emit_signal("action_counter_updated", actions_available, actions_remaining)

func update(remaining_actions: int) -> void:
  actions_remaining = remaining_actions
  print("Action used. Actions remaining:", actions_remaining)
  emit_signal("action_counter_updated", actions_available, actions_remaining)
