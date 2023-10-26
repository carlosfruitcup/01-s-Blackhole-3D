extends CanvasLayer

export var item_1 = "Scafe's Light Protection"
export var item_2 = "Scafe's Ice-Coffee"
export(NodePath) var player_path

export var prices = [15,20]

onready var player = get_node(player_path)
onready var desc = get_node("Control/BG/desc")
onready var item_1_btn = get_node("Control/BG/item_1")
onready var item_2_btn = get_node("Control/BG/item_2")

var itm_1_amt = 0
var itm_2_amt = 0

func _ready():
	item_1_btn.text = "$"+str(prices[0])+" - "+item_1

func show(_visible = false):
	_visible = int(_visible)
	
	if _visible == 1:
		visible = true
		player.get_node("CanvasLayer/Control/Paused").paused = true
		$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		player.get_node("CanvasLayer/Control/Paused").paused = false
		visible = false
		$Control.mouse_filter = Control.MOUSE_FILTER_PASS

func update_buttons():
	if itm_1_amt == 1:
		item_1_btn.disabled = true
	
	if itm_2_amt == 4:
		item_2_btn.disabled = true
	
	item_1_btn.text = "$"+str(prices[0])+" - "+item_1

func _process(delta):
	update_buttons()

func _on_item_1_mouse_entered():
	desc.bbcode_text = ItemDictionary.items_desc.get(item_1,"null")

func _on_item_2_mouse_entered():
	desc.bbcode_text = ItemDictionary.items_desc.get(item_2,"null")

func _on_item_1_button_up():
	itm_1_amt = 0
	for i in Global.inventory:
		if i == item_1:
			itm_1_amt += 1
	
	if itm_1_amt < 1 and Global.Dinero >= prices[0]:
		Global.inventory.append(item_1)
		Global.Dinero -= prices[0]
		itm_1_amt += 1

func _on_item_2_button_up():
	itm_2_amt = 0
	for i in Global.inventory:
		if i == item_2:
			itm_2_amt += 1
	
	if itm_2_amt < 4 and Global.Dinero >= prices[1]:
		Global.inventory.append(item_2)
		Global.Dinero -= prices[1]
		itm_2_amt += 1

func _on_back_button_up():
	show()
