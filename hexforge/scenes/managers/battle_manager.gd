class_name BattleManager extends Node

@export var hex_grid: HexGrid
@export var turn_manager: TurnManager

var selected_unit: BaseUnit
var selected_ability: Ability
var highlighted_tiles: Array[Vector2i] = []

signal unit_selected(unit: BaseUnit)
signal ability_selected(ability: Ability)
signal battle_ended(winning_team: int)


func _ready() -> void:
	turn_manager.start_turn()


func select_unit(unit: BaseUnit) -> void:
	if unit.team != turn_manager.current_team:
		return
	selected_unit = unit
	unit_selected.emit(unit)
	_clear_highlights()


func select_ability(ability: Ability) -> void:
	if not selected_unit or not ability.can_use():
		return
	selected_ability = ability
	ability_selected.emit(ability)
	var targets = ability.get_valid_targets(selected_unit.hex_coord, hex_grid)
	_highlight_tiles(targets)


func execute_on_tile(coord: Vector2i) -> void:
	if not selected_unit or not selected_ability:
		return
	if coord in highlighted_tiles:
		selected_ability.use(selected_unit, coord, hex_grid)
		selected_unit.has_acted = true
		_clear_highlights()
		selected_ability = null
		_check_auto_advance()


func _highlight_tiles(tiles: Array[Vector2i]) -> void:
	highlighted_tiles = tiles


func _clear_highlights() -> void:
	highlighted_tiles.clear()


func _check_auto_advance() -> void:
	var victory = turn_manager.check_victory()
	if victory >= 0:
		battle_ended.emit(victory)
		return
	var all_done = true
	for unit in turn_manager.teams[turn_manager.current_team]:
		if unit.can_act() or unit.can_move():
			all_done = false
			break
	if all_done:
		turn_manager.end_turn()
