extends Node

func calucluate_attack_damage(actor_stats: CharacterStats, target_stats: CharacterStats) -> int:
	return actor_stats.attack - target_stats.defense
