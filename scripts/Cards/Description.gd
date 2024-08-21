extends Node

var keywords = {
	"target" : "[color=red][b]target[/b][/color]",
	"Target" : "[color=red][b]Target[/b][/color]",
	"attacks" : "[img]res://graphics/icons/attack.aseprite[/img]",
	"Attacks" : "[img]res://graphics/icons/attack.aseprite[/img]",
	"health" : "[img]res://graphics/icons/health.aseprite[/img]",
	"Health" : "[img]res://graphics/icons/health.aseprite[/img]",
	"lives" : "[img]res://graphics/icons/health.aseprite[/img]",
	"randpos" : "[img]res://graphics/icons/randpos.aseprite[/img]"
}

func enrich(text: String):
	for keyword in keywords.keys():
		text = text.replacen(keyword, keywords[keyword])
	return text
