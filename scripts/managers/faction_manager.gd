extends Node

enum Faction { PLAYER, ENEMY, NEUTRAL }

const RELATIONSHIPS = {
	Faction.PLAYER: {
		"predators": [Faction.ENEMY],
		"prey": [Faction.ENEMY, Faction.NEUTRAL]
	},
	Faction.ENEMY: {
		"predators": [Faction.PLAYER],
		"prey": [Faction.PLAYER]
	},
	Faction.NEUTRAL: {
		"predators": [Faction.PLAYER],
		"prey": []
	}
}

func is_predator(caller_faction: Faction, target_faction: Faction) -> bool:
	return target_faction in RELATIONSHIPS[caller_faction]["predators"]
	
func is_prey(caller_faction: Faction, target_faction: Faction) -> bool:
	return target_faction in RELATIONSHIPS[caller_faction]["prey"]
