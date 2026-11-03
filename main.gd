extends Control

const BG := Color("0e1c20")
const PANEL := Color("193238")
const PANEL_LIGHT := Color("24454a")
const ACCENT := Color("e5a94f")
const TEXT := Color("f4f0df")
const MUTED := Color("b8c9c3")

var day := 1
var water := 8
var food := 8
var wood := 5
var stone := 3
var message := "O mar trouxe vocês até aqui. Agora precisam sobreviver."
var survivors: Array[Dictionary] = [
	{"name": "Lucas", "role": "Explorador", "task": "Descansando", "hunger": 20, "thirst": 20, "energy": 80},
	{"name": "Marina", "role": "Socorrista", "task": "Descansando", "hunger": 15, "thirst": 15, "energy": 90},
	{"name": "Antônio", "role": "Pescador", "task": "Descansando", "hunger": 25, "thirst": 25, "energy": 75}
]
var root_box: VBoxContainer
var content: VBoxContainer

func _ready() -> void:
	_show_title()

func _clear() -> void:
	for child in get_children():
		child.queue_free()

func _make_base(title_text: String) -> void:
	_clear()
	var bg := ColorRect.new()
	bg.color = BG
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var margin := MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 28)
	margin.add_theme_constant_override("margin_right", 28)
	margin.add_theme_constant_override("margin_top", 22)
	margin.add_theme_constant_override("margin_bottom", 22)
	add_child(margin)
	root_box = VBoxContainer.new()
	root_box.add_theme_constant_override("separation", 14)
	margin.add_child(root_box)
	var heading := Label.new()
	heading.text = title_text
	heading.add_theme_font_size_override("font_size", 30)
	heading.add_theme_color_override("font_color", ACCENT)
	root_box.add_child(heading)
	content = VBoxContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	root_box.add_child(content)

func _show_title() -> void:
	_make_base("ILHA DOS DESESPERADOS")
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(spacer)
	var subtitle := Label.new()
	subtitle.text = "Um naufrágio. Uma ilha desconhecida. Três sobreviventes."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 21)
	subtitle.add_theme_color_override("font_color", TEXT)
	content.add_child(subtitle)
	var desc := Label.new()
	desc.text = "Explore, reúna recursos e tome decisões para manter seu grupo vivo."
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.add_theme_color_override("font_color", MUTED)
	content.add_child(desc)
	var start := _button("COMEÇAR A SOBREVIVER", ACCENT)
	start.custom_minimum_size = Vector2(0, 54)
	start.pressed.connect(_show_camp)
	content.add_child(start)
	var note := Label.new()
	note.text = "Protótipo inicial • versão 0.1"
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.add_theme_color_override("font_color", MUTED)
	content.add_child(note)
	var bottom := Control.new()
	bottom.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(bottom)

func _button(caption: String, color: Color = PANEL_LIGHT) -> Button:
	var b := Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(0, 42)
	b.add_theme_font_size_override("font_size", 16)
	b.add_theme_color_override("font_color", TEXT)
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	normal.corner_radius_top_left = 9
	normal.corner_radius_top_right = 9
	normal.corner_radius_bottom_left = 9
	normal.corner_radius_bottom_right = 9
	b.add_theme_stylebox_override("normal", normal)
	var hover := normal.duplicate()
	hover.bg_color = color.lightened(0.12)
	b.add_theme_stylebox_override("hover", hover)
	return b

func _panel() -> PanelContainer:
	var p := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = PANEL
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	p.add_theme_stylebox_override("panel", style)
	return p

func _label(value: String, size: int = 16, color: Color = TEXT) -> Label:
	var l := Label.new()
	l.text = value
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return l

func _show_camp() -> void:
	_make_base("ACAMPAMENTO  •  DIA %d" % day)
	var resources := _panel()
	content.add_child(resources)
	var res_row := HBoxContainer.new()
	res_row.add_theme_constant_override("separation", 24)
	resources.add_child(res_row)
	for item in ["Água: %d" % water, "Comida: %d" % food, "Madeira: %d" % wood, "Pedra: %d" % stone]:
		var l := _label(item, 16, ACCENT)
		l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		res_row.add_child(l)
	var status := _panel()
	content.add_child(status)
	var status_col := VBoxContainer.new()
	status_col.add_theme_constant_override("separation", 7)
	status.add_child(status_col)
	status_col.add_child(_label("SOBREVIVENTES", 18, ACCENT))
	for i in range(survivors.size()):
		var s: Dictionary = survivors[i]
		var line := HBoxContainer.new()
		line.add_theme_constant_override("separation", 10)
		status_col.add_child(line)
		var info := _label("%s — %s\nTarefa: %s  |  Fome: %d%%  Sede: %d%%  Energia: %d%%" % [s.name, s.role, s.task, s.hunger, s.thirst, s.energy], 14)
		info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		line.add_child(info)
		var options := OptionButton.new()
		options.add_item("Descansar")
		options.add_item("Buscar madeira")
		options.add_item("Coletar água")
		options.add_item("Procurar comida")
		options.add_item("Explorar")
		options.selected = _task_index(str(s.task))
		options.item_selected.connect(_on_task_selected.bind(i))
		line.add_child(options)
	var msg := _panel()
	content.add_child(msg)
	msg.add_child(_label(message, 14, MUTED))
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	content.add_child(actions)
	var explore := _button("EXPEDIÇÃO", PANEL_LIGHT)
	explore.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	explore.pressed.connect(_expedition)
	actions.add_child(explore)
	var next := _button("ENCERRAR DIA", ACCENT)
	next.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	next.add_theme_color_override("font_color", BG)
	next.pressed.connect(_next_day)
	actions.add_child(next)
	var menu := _button("MENU INICIAL", PANEL)
	menu.pressed.connect(_show_title)
	content.add_child(menu)

func _task_index(task: String) -> int:
	var tasks := ["Descansando", "Buscando madeira", "Coletando água", "Procurando comida", "Explorando"]
	var idx := tasks.find(task)
	return max(idx, 0)

func _on_task_selected(index: int, survivor_index: int) -> void:
	var tasks := ["Descansando", "Buscando madeira", "Coletando água", "Procurando comida", "Explorando"]
	survivors[survivor_index].task = tasks[index]
	message = "%s agora está: %s." % [survivors[survivor_index].name, tasks[index].to_lower()]
	_show_camp()

func _expedition() -> void:
	var roll := randi_range(0, 2)
	if roll == 0:
		wood += 2
		message = "A expedição encontrou madeira seca entre os destroços. +2 madeira."
	elif roll == 1:
		food += 2
		message = "Vocês encontraram cocos e frutas na mata. +2 comida."
	else:
		stone += 2
		message = "Perto de um riacho, encontraram pedras úteis. +2 pedra."
	_show_camp()

func _next_day() -> void:
	day += 1
	for s in survivors:
		s.hunger = min(100, s.hunger + 18)
		s.thirst = min(100, s.thirst + 23)
		if s.task == "Buscando madeira" and s.energy >= 15:
			wood += 2
			s.energy -= 15
		elif s.task == "Coletando água" and s.energy >= 15:
			water += 2
			s.energy -= 15
		elif s.task == "Procurando comida" and s.energy >= 15:
			food += 2
			s.energy -= 15
		elif s.task == "Explorando" and s.energy >= 20:
			stone += 1
			s.energy -= 20
		elif s.task == "Descansando":
			s.energy = min(100, s.energy + 25)
	if food > 0:
		food -= 1
		for s in survivors:
			s.hunger = max(0, s.hunger - 12)
	if water > 0:
		water -= 1
		for s in survivors:
			s.thirst = max(0, s.thirst - 15)
	message = _daily_event()
	_show_camp()

func _daily_event() -> String:
	var events := [
		"A noite foi tranquila. O grupo conseguiu descansar.",
		"Uma chuva rápida encheu alguns recipientes. +1 água.",
		"Pegadas estranhas apareceram perto do acampamento.",
		"O vento forte espalhou folhas e galhos pelo acampamento."
	]
	var choice := randi_range(0, events.size() - 1)
	if choice == 1:
		water += 1
	return events[choice]
