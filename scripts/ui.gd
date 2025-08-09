extends Control

@onready var money_text : RichTextLabel = %MoneyLabel
@onready var satisfaction_text: RichTextLabel = %SatisfactionLabel
@onready var bus_button : Button = %BusButton
@onready var speed_label : RichTextLabel = %SpeedLabel
@onready var satisfaction_label : RichTextLabel = %SatisfactionLabel

func _ready() -> void:
	GameManager.money_updated.connect(_on_money_updated)
	GameManager.satisfaction_updated.connect(_on_satisfaction_updated)
	GameManager.game_over.connect(_on_game_over)
	bus_button.button_down.connect(_on_button_down)
	SignalBus.speed_increased.connect(_on_speed_increased)
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	SignalBus.selected.connect(_on_selected)
	
func render_station_info(station : Station):
	# TODO:
	pass
	
func render_bus_info(bus : Bus):
	print("%d / %d" % [bus.passengers.size(), bus.capacity])
	print("Speed: %s" % bus.speed)
	

func _on_selected(object : Node):
	if object is Station:
		render_station_info(object as Station)
	elif object is Bus:
		render_bus_info(object as Bus)
	
func _on_passenger_dropped_off(_money : int, satisfaction: int):
	print_debug("satisfaction: %d" % satisfaction)
	satisfaction_label.text = "Passenger satisfaction (last drop off): %d" % satisfaction

func _on_speed_increased(speed : int):
	speed_label.text = "Bus speed (mph): %d" % speed
	#print("ui: bus speed is now %d!" % speed)
	
func _on_button_down() -> void:
	GameManager.increase_speed()
 
# TODO: this needs to be called when a signal is emitted
func _on_money_updated(amount : int):
	print("ui: updated money with %d" % amount)
	money_text.text = "Money: [color=yellow]$%d[/color]" % amount

func _on_satisfaction_updated(amount: int):
	satisfaction_text.text = "Satisfaction level: %d" % amount
	
func _on_game_over():
	get_node("VBoxContainer").visible = false
	get_node("GameOver").visible = true
	
