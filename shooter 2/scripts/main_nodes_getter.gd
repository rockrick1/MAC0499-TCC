extends Node


var character
var stage
var stats

var char_ship


func get_character():
	return character


func set_character(node):
	character = node


func get_ship():
	return char_ship


func set_ship(ship):
	char_ship = ship


func get_stage():
	return stage


func set_stage(node):
	stage = node


func get_stats():
	return stats


func set_stats(node):
	stats = node
