class_name TurnManager extends Node

signal turn_started(team: int)
signal turn_ended(team: int)
signal phase_changed(phase: Phase)

enum Phase { SELECT, MOVE, ACTION, RESOLVE }

var current_team: int = 0
var current_phase: Phase = Phase.SELECT
var teams: Array[Array] = [[], []]
var turn_count: int = 0


func start_turn() -> void:
	for unit in teams[current_team]:
		unit.reset_actions()
	current_phase = Phase.SELECT
	turn_started.emit(current_team)
	phase_changed.emit(current_phase)


func end_turn() -> void:
	turn_ended.emit(current_team)
	current_team = (current_team + 1) % teams.size()
	turn_count += 1
	start_turn()


func advance_phase() -> void:
	current_phase = (current_phase + 1) as Phase
	if current_phase > Phase.RESOLVE:
		end_turn()
	else:
		phase_changed.emit(current_phase)


func register_unit(unit: BaseUnit, team: int) -> void:
	unit.team = team
	teams[team].append(unit)


func remove_unit(unit: BaseUnit) -> void:
	for team in teams:
		team.erase(unit)


func check_victory() -> int:
	for i in range(teams.size()):
		if teams[i].size() == 0:
			return (i + 1) % teams.size()
	return -1
