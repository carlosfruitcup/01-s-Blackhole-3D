extends Node

var items = {
	"test": -1,
	"Long Dagger": 0,
	"Scafe's Light Protection": 1,
	"Scafe's Ice-Coffee": 2,
	"Purification": 3
}

var useable = {
	"test": -1,
	"Long Dagger": 0,
	"Scafe's Light Protection": 1,
	"Scafe's Ice-Coffee": 2,
	"Purification": 3
}

var weapon = {
	"Long Dagger": 0,
	"Purification": 3
}

var armor = {
	"Null": -1,
	"Scafe's Light Protection":1
}

var weapon_phys = [
	preload("res://Player/Weapons/Long Dagger/LongDagger.tscn"),
	preload("res://Player/Weapons/Bat/Bat.tscn")
]

var items_desc = {
	"Long Dagger": "A long dagger that belonged to Salvage.\n\n[color=green]Normal: -15 or 25 DMG (Depending on the attack)\nSpecial: Can be thrown anywhere\n-35 DMG[/color]\n[color=red]Takes 15 Stamina on Special[/color]",
	
	"Scafe's Light Protection": "Some light armor, still better than nothing.\n\n[color=green]-1.20 Defense[/color]",
	
	"Scafe's Ice-Coffee": "Has some flavour. \n\n[color=green]-Adds 25 HP when consumed[/color]",
	
	"Purification": "This is giving me an off feeling. \n\n[color=green]Normal: -35 DMG\nSpecial: -Attacks 2x [/color]\n[color=red]Takes 30 Stamina on Special[/color]"
}

func _ready():
	print(items.get(-1,"err"))
	items_desc.get(0,0)
	
