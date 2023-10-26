extends CanvasLayer

export var number_0 = 0
export var number_1 = 0
export var number_2 = 0
export var number_3 = 0

onready var num0 = $Control/ColorRect/SpinBox
onready var num1 = $Control/ColorRect/SpinBox2
onready var num2 = $Control/ColorRect/SpinBox3
onready var num3 = $Control/ColorRect/SpinBox4

var check
var thing3 = 0
var thing4 = 0
#this is not very efficient
#but i cant be bothered to make it cleaner

func _process(delta):
	if visible == true:
		get_tree().call_group("pause","pause",true,false)
	
	#not gonna do this, too dirty
#	if check == false:
#		for c in get_children():
#			if c is SpinBox:
#				if c.editable == false:
#					thing3 += 1
#				else:
#					thing4 += 1
#
#
#
		

var thing2 = 0
var thing = 0
var finsihed = false
func _on_Button_button_up():
	
	if num0.value == number_0:
		num0.editable = false
		num0.value = number_0
	if num1.value == number_1:
		num1.editable = false
		num1.value = number_1
	if num2.value == number_2:
		num2.editable = false
		num2.value = number_2
	if num3.value == number_3:
		num3.editable = false
		num3.value = number_3
	
	
	for c in $Control/ColorRect.get_children():
		if c is SpinBox:
			if c.editable == false:
				thing += 1
				#print("AAA")
			else:
				thing2 += 1
				#print("ERROR!!!")
				
	
	if thing >= 4:
		finsihed = true
		get_parent().get_node("CSGBox2/Area").move_to(get_parent().get_parent().get_parent().get_node("Player"))
		queue_free()
	#else:
		#print("hello???? "+str(thing))
	
	if thing2 >= 1:
		finsihed = true
		thing = 0
		#print("a")
	
	if finsihed == true:
		if thing >= 4:
			queue_free()
			get_tree().call_group("pause","pause",false)
			#print("test???")
		else:
			visible = false
			thing = 0
			thing2 = 0
			num0.value = 0
			num1.value = 0
			num2.value = 0
			num3.value = 0
			
			num0.editable = 1
			num1.editable = 1
			num2.editable = 1
			num3.editable = 1
			get_tree().call_group("pause","pause",false)
