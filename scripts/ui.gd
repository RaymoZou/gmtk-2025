# all inclusive script for managing ui - may break down into individual components later
extends Control

@onready var money_text : RichTextLabel = %MoneyLabel
@onready var satisfaction_text: RichTextLabel = %SatisfactionLabel
@onready var selectable_display : VBoxContainer = %SelectableDisplay # vbox
@onready var satisfaction_label : RichTextLabel = %SatisfactionLabel

@export var curr_selected : Node = null

func _ready() -> void:
	GameManager.money_updated.connect(_on_money_updated)
	GameManager.satisfaction_updated.connect(_on_satisfaction_updated)
	GameManager.game_over.connect(_on_game_over)
	SignalBus.passenger_dropped_off.connect(_on_passenger_dropped_off)
	SignalBus.selected.connect(_on_selected)
	SignalBus.speed_increased.connect(render_bus_info) # Update bus info when speed is increased
	SignalBus.capacity_increased.connect(render_bus_info) # Update bus info when capacity is increased
	SignalBus.station_capacity_increased.connect(render_station_info) # Update station info when capacity is increased

# creates a button to display in the UI
func create_ui_button(text: String, tooltip: String, pressed_func: Callable) -> Button:
	var button = Button.new()
	button.text = text
	button.tooltip_text = tooltip
	button.pressed.connect(pressed_func)
	return button

func clear_selectable_display():
	for child in selectable_display.get_children():
		child.queue_free()

func render_station_info(station: Station):
	clear_selectable_display()
	var capacity_button = create_ui_button("capacity: %s" % station.capacity, "Current capacity is %d. Cost to increase capacity: $%d." % [station.capacity, Station.CAPACITY_COST], station.increase_capacity)
	capacity_button.disabled = GameManager.money < Station.CAPACITY_COST
	selectable_display.add_child(capacity_button)

func render_bus_info(bus : Bus):
	clear_selectable_display()
	
	# speed button
	var speed_button = create_ui_button("speed: %s" % bus.speed, "Current speed is %d. Cost to increase speed: $%d." % [bus.speed, Bus.SPEED_COST], bus.increase_speed)
	speed_button.disabled = GameManager.money < Bus.SPEED_COST
	selectable_display.add_child(speed_button)

	# capacity button
	var capacity_button = create_ui_button("capacity: %s" % bus.capacity, "Current capacity is %d. Cost to increase capacity: $%d." % [bus.capacity, Bus.CAPACITY_COST], bus.increase_capacity)
	capacity_button.disabled = GameManager.money < Bus.CAPACITY_COST
	selectable_display.add_child(capacity_button)

func render_selected():
	if curr_selected is Station:
		render_station_info(curr_selected as Station)
	elif curr_selected is Bus:
		render_bus_info(curr_selected as Bus)
	else:
		clear_selectable_display()

func _on_selected(object : Node):
	curr_selected = object
	print(curr_selected)
	render_selected()

func _on_passenger_dropped_off(_money : int, satisfaction: int):
	# print_debug("satisfaction: %d" % satisfaction)
	satisfaction_label.text = "Passenger satisfaction (last drop off): %d" % satisfaction
 
# TODO: this needs to be called when a signal is emitted
func _on_money_updated(amount : int):
	print("ui: updated money with %d" % amount)
	money_text.text = "Money: [color=yellow]$%d[/color]" % amount
	render_selected()

func _on_satisfaction_updated(amount: int):
	satisfaction_text.text = "Satisfaction level: %d" % amount
	
func _on_game_over():
	get_node("VBoxContainer").visible = false
	get_node("GameOver").visible = true
	
