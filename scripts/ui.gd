extends Control

@onready var money_text : RichTextLabel = %MoneyLabel
@onready var bus_button : Button = %BusButton
@onready var speed_label : RichTextLabel = %SpeedLabel

func _ready() -> void:
	GameManager.money_updated.connect(_on_money_updated)
	bus_button.button_down.connect(_on_button_down)
	SignalBus.speed_increased.connect(_on_speed_increased)

func _on_speed_increased(speed : int):
	speed_label.text = "bus speed: %d" % speed
	print("ui: bus speed is now %d!" % speed)
	
func _on_button_down() -> void:
	GameManager.increase_speed()
 
# TODO: this needs to be called when a signal is emitted
func _on_money_updated(amount : int):
	print("ui: updated money with %d" % amount)
	money_text.text = "money: %d" % amount
