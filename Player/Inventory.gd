extends Control

#Inventory
onready var list = get_node("List") #Actual Inv

#UI
onready var Tmer = get_node("DTimer") #Dialogue Timer
onready var Dialogue = get_node("Dialogue") #Dialogue
onready var UseTXT = get_node("Use")
onready var RemoveTXT = get_node("Remove")
onready var MoveTXT = get_node("Move")
onready var desc = get_node("desc")

onready var player = get_parent().get_parent().get_parent()
onready var weaponsys = get_parent().get_parent().get_parent().get_node("WeaponSys")

func _ready():
	LineEditRegEx.compile("^[0-9.]*$")
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if Global.equipped_item != null:
		create_physical_item(Global.equipped_item)

func _input(event):
	if event.is_action_pressed("Inventory"):
		visible = !visible
		Dialogue.text = ""
		if visible == true:
			get_parent().get_node("Paused").paused = true
			mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			get_parent().get_node("Paused").paused = false
			mouse_filter = Control.MOUSE_FILTER_PASS
		
		update_inventory()

var pressed = 0

func update_inventory():
	list.bbcode_text = array_join(Global.inventory, "\n")
	
	for item in Global.inventory:
		if !item in ItemDictionary.items:
			Global.inventory.erase(item)
			Global.inventory.append("test")
			failed("Error0")
			print("Error! Unrecgonized item!")
			update_inventory()
	

func array_join(arr : Array, glue : String = '') -> String:
	var string : String = ''
	for index in range(0, arr.size()):
		string += "[color=gray]" + str(index) + " - " + "[/color]"
		string += str(arr[index])
		if weaponsys.weapon != null:
			if weaponsys.weapon.name == str(arr[index]):
				string += " (Equipped)"
		if Global.equipped_item != null:
			if Global.equipped_armor == str(arr[index]):
				string += " (Equipped)"
		if index < arr.size() - 1:
			string += glue
	return string


func failed(reason):
	match reason:
		"unable":
			Dialogue.text = "Can't use this."
			Tmer.start(2)
		"noItems":
			Dialogue.text = "I don't have anything."
			Tmer.start(2)
		"notEnough":
			Dialogue.text = "I don't have enough."
			Tmer.start(2)
		"Used2Mch":
			Dialogue.text = "Don't need to use this right now."
			Tmer.start(2)
		"Error0":
			Dialogue.text = "What is this?"
			Tmer.start(2)

func _on_Timer_timeout():
	Dialogue.text = ""

onready var LineEditRegEx = RegEx.new()
var old_text = ""



func _on_Use_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		UseTXT.text = old_text
		UseTXT.set_cursor_position(UseTXT.text.length())
		
	if Global.inventory.size() >= 1:
		if UseTXT.text.length() >= 1:
			if int(UseTXT.text) <= Global.inventory.size() - 1:
				var can = ItemDictionary.useable.has(Global.inventory[int(UseTXT.text)])
				
				desc.bbcode_text = ItemDictionary.items_desc.get(Global.inventory[int(UseTXT.text)],"null")
		else:
			desc.bbcode_text = ""
	#print(UseTXT.text == " ")
		
		


func _on_Remove_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		RemoveTXT.text = old_text
		RemoveTXT.set_cursor_position(RemoveTXT.text.length())

func _process(delta):
	if get_parent().get_node("Paused").paused == false && visible == true:
		visible = false
	
	if Global.equipped_item != null and (get_tree().get_nodes_in_group("weapon").size()) <= 0:
		create_physical_item(Global.equipped_item)
	
	

func weapon_check(itm):
	if Global.equipped_item != itm:
		create_physical_item(itm)
		
		update_inventory()
	else:
		Global.equipped_item = null
		weaponsys.weapon = null
		if is_instance_valid(player.get_node("Head").get_node(itm)):
			player.get_node("Head").get_node(itm).queue_free()
			weaponsys.weapon = null
			update_inventory()
		else:
			print("Error:"+str(itm)+" does not exist.")

var arrau = []
#onready var timer = get_node("SleepDep")
func use(item):
	var itm = Global.inventory[int(item)]
	
	match itm:
		"test":
			Global.inventory.remove(item)
			update_inventory()
		
		"Purification":
			weapon_check(itm)
		
		"Long Dagger":
			weapon_check(itm)
			
		"Scafe's Light Protection":
			if Global.equipped_armor == null:
				Global.equipped_armor = "Scafe's Light Protection"
				
				update_inventory()
			else:
				Global.equipped_armor = null
			
				update_inventory()

func reload_UI():
	update_inventory()

func create_physical_item(item):
	match item:
		"Long Dagger":
			var weapon = ItemDictionary.weapon_phys[0].instance() 
			
			Global.equipped_item = "Long Dagger"
			
			player.get_node("Head").add_child(weapon)
			player.get_node("WeaponSys").check_weapons()
		
		"Purification":
			var weapon = ItemDictionary.weapon_phys[1].instance() 
			
			Global.equipped_item = "Purification"
			
			player.get_node("Head").add_child(weapon)
			player.get_node("WeaponSys").check_weapons()
		

func _on_Use_text_entered(new_text):
	var item = new_text
	#print(item)
	var itemNum = int(UseTXT.text)
	if Global.inventory.size() >= 1:
		if itemNum <= Global.inventory.size() - 1:
			var can = ItemDictionary.useable.has(Global.inventory[itemNum])
			
			
			if can == true:
				use(item)
			elif can == false:
				failed("unable")
				return
		else:
			failed("notEnough")
	else:
		failed("noItems")


func _on_Remove_text_entered(new_text):
	pressed += 1
	
	if pressed == 0:
		RemoveTXT.placeholder_text = "Write the number next to item to throw"
	elif pressed == 1:
		RemoveTXT.placeholder_text
	
	if pressed >= 2:
		if Global.inventory.size() >= 1:
			Global.inventory.remove(RemoveTXT.text)
			update_inventory()
			pressed = 0
		else:
			failed("noItems")


func _on_Equip_text_changed(new_text):
	pass # Replace with function body.


func _on_Equip_text_entered(new_text):
	var item = new_text
	#print(item)
	
	var itemNum = int(UseTXT.text)
	if Global.inventory.size() >= 1:
		if itemNum <= Global.inventory.size() - 1:
			var can = ItemDictionary.weapon.has(Global.inventory[itemNum])
			
			if can == true:
				use(item)
			elif can == false:
				failed("unable")
				return
		else:
			failed("notEnough")
	else:
		failed("noItems")
	
	update_inventory()


func _on_Move_text_changed(new_text):
	if LineEditRegEx.search(new_text):
		old_text = str(new_text)
	else:
		MoveTXT.text = old_text
		MoveTXT.set_cursor_position(MoveTXT.text.length())


func _on_Move_text_entered(new_text):
	var item = new_text
	#print(item)
	
	var itemNum = int(MoveTXT.text)
	item = Global.inventory[itemNum]
	if Global.inventory.size() >= 1:
		if itemNum <= Global.inventory.size() - 1:
			print(item)
			Global.inventory.erase(item)
			Global.inventory.push_front(item)
		else:
			failed("notEnough")
	else:
		failed("noItems")
	
	update_inventory()
