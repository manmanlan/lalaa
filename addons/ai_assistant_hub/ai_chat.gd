@tool
class_name AIChat
extends Control

enum Caller {
	You,
	Bot,
	System
}

const CHAT_HISTORY_EDITOR = preload("res://addons/ai_assistant_hub/chat_history_editor.tscn")

@onready var http_request: HTTPRequest = %HTTPRequest
@onready var output_window: RichTextLabel = %OutputWindow
@onready var prompt_txt: TextEdit = %PromptTxt
@onready var bot_portrait: BotPortrait = %BotPortrait
@onready var quick_prompts_panel: Container = %QuickPromptsPanel
@onready var reply_sound: AudioStreamPlayer = %ReplySound
@onready var error_sound: AudioStreamPlayer = %ErrorSound
@onready var model_options_btn: OptionButton = %ModelOptionsBtn
@onready var temperature_slider: HSlider = %TemperatureSlider
@onready var temperature_override_checkbox: CheckBox = %TemperatureOverrideCheckbox
@onready var temperature_slider_container: HBoxContainer = %TemperatureSliderContainer


var _plugin:EditorPlugin
var _bot_name: String
var _assistant_settings: AIAssistantResource
var _last_quick_prompt: AIQuickPromptResource
var _code_selector: AssistantToolSelection
var _bot_answer_handler: AIAnswerHandler
var _llm: LLMInterface
var _conversation: AIConversation


func initialize(plugin:EditorPlugin, assistant_settings: AIAssistantResource, bot_name:String) -> void:
	_plugin = plugin
	_assistant_settings = assistant_settings
	_bot_name = bot_name
	_code_selector = AssistantToolSelection.new(plugin)
	_bot_answer_handler = AIAnswerHandler.new(plugin, _code_selector)
	_bot_answer_handler.bot_message_produced.connect(func(message): _add_to_chat(message, Caller.Bot) )
	_bot_answer_handler.error_message_produced.connect(func(message): _add_to_chat(message, Caller.System) )
	_conversation = AIConversation.new()
		
	if _assistant_settings: # We need to check this, otherwise this is called when editing the plugin
		load_api()
		_conversation.set_system_message(_assistant_settings.ai_description)
		
		await ready
		temperature_slider.value = assistant_settings.custom_temperature
		temperature_override_checkbox.button_pressed = assistant_settings.use_custom_temperature
		_on_temperature_override_checkbox_toggled(temperature_override_checkbox.button_pressed)
	
		bot_portrait.set_random()
		reply_sound.pitch_scale = randf_range(0.7, 1.2)
	
		for qp in _assistant_settings.quick_prompts:
			var qp_button:= Button.new()
			qp_button.text = qp.action_name
			qp_button.icon = qp.icon
			qp_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			qp_button.pressed.connect(func(): _on_qp_button_pressed(qp))
			quick_prompts_panel.add_child(qp_button)


func load_api() -> void:
	_llm = _plugin.new_llm_provider()
	_llm.model = _assistant_settings.ai_model
	_llm.override_temperature = _assistant_settings.use_custom_temperature
	_llm.temperature = _assistant_settings.custom_temperature


func greet() -> void:
	if _assistant_settings.quick_prompts.size() == 0:
		_add_to_chat("This assistant type doesn't have Quick Prompts defined. Add them to the assistant's resource configuration to unlock some additional capabilities, like writing in the code editor.", Caller.System)
	
	var greet_prompt := "Give a short greeting including just your name (which is \"%s\") and how can you help in a concise sentence." % _bot_name
	_submit_prompt(greet_prompt)


func refresh_models(models: Array[String]) -> void:
	model_options_btn.clear()
	var selected_found := false
	for model in models:
		model_options_btn.add_item(model)
		if model.contains(_assistant_settings.ai_model):
			model_options_btn.select(model_options_btn.item_count - 1)
			selected_found = true
	if not selected_found:
		model_options_btn.add_item(_assistant_settings.ai_model)
		model_options_btn.select(model_options_btn.item_count - 1)


func _input(event: InputEvent) -> void:
	if prompt_txt.has_focus() and event.is_pressed() and event is InputEventKey:
		var e:InputEventKey = event
		var is_enter_key := e.keycode == KEY_ENTER or e.keycode == KEY_KP_ENTER
		var shift_pressed := Input.is_physical_key_pressed(KEY_SHIFT)
		if shift_pressed and is_enter_key:
			prompt_txt.insert_text_at_caret("\n")
		else:
			var ctrl_pressed = Input.is_physical_key_pressed(KEY_CTRL)
			if not ctrl_pressed:
				if not prompt_txt.text.is_empty() and is_enter_key:
					if bot_portrait.is_thinking:
						_abandon_request()
					get_viewport().set_input_as_handled()
					var prompt = _engineer_prompt(prompt_txt.text)
					prompt_txt.text = ""
					_add_to_chat(prompt, Caller.You)
					_submit_prompt(prompt)


func _on_qp_button_pressed(qp: AIQuickPromptResource) -> void:
	_last_quick_prompt = qp
	var prompt = qp.action_prompt.replace("{CODE}", _code_selector.get_selection())
	if prompt.contains("{CHAT}"):
		prompt = prompt.replace("{CHAT}", prompt_txt.text)
		prompt_txt.text = ""
	_add_to_chat(prompt, Caller.You)
	_submit_prompt(prompt, qp)


func _find_code_editor() -> TextEdit:
	var script_editor := _plugin.get_editor_interface().get_script_editor().get_current_editor()
	return script_editor.get_base_editor()


func _engineer_prompt(original:String) -> String:
	if original.contains("{CODE}"):
		var curr_code:String = _find_code_editor().get_selected_text()
		var prompt:String = original.replace("{CODE}", curr_code)
		return prompt
	else:
		return original


func _submit_prompt(prompt:String, quick_prompt:AIQuickPromptResource = null) -> void:
	if bot_portrait.is_thinking:
		_abandon_request()
	_last_quick_prompt = quick_prompt
	bot_portrait.is_thinking = true
	_conversation.add_user_prompt(prompt)
	var success := _llm.send_chat_request(http_request, _conversation.build())
	if not success:
		_add_to_chat("Something went wrong. Review the details in Godot's Output tab.", Caller.System)


func _abandon_request() -> void:
	error_sound.play()
	http_request.cancel_request()
	bot_portrait.is_thinking = false
	_add_to_chat("Abandoned previous request.", Caller.System)
	_conversation.forget_last_prompt()


func _on_http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	#print("HTTP response: Result: %d, Response Code: %d, Headers: %s, Body: %s" % [result, response_code, headers, body])
	bot_portrait.is_thinking = false
	if result == 0:
		var text_answer = _llm.read_response(body)
		if text_answer == LLMInterface.INVALID_RESPONSE:
			error_sound.play()
			push_error("Response: %s" % _llm.get_full_response(body))
			_add_to_chat("An error occurred while processing your last request. Review the details in Godot's Output tab.", Caller.System)
		else:
			reply_sound.play()
			_conversation.add_assistant_response(text_answer)
			_bot_answer_handler.handle(text_answer, _last_quick_prompt)
	else:
		error_sound.play()
		push_error("HTTP response: Result: %s, Response Code: %d, Headers: %s, Body: %s" % [result, response_code, headers, body])
		_add_to_chat("An error occurred while communicating with the assistant. Review the details in Godot's Output tab.", Caller.System)


func _add_to_chat(text:String, caller:Caller) -> void:
	var prefix:String
	var suffix:String
	match caller:
		Caller.You:
			prefix = "\n[color=FFFF00]> "
			suffix = "[/color]\n"
		Caller.Bot:
			prefix = "\n[right][color=777777][b]%s[/b][/color]:\n" % _bot_name
			var code_found := false
			if text.contains("```gdscript"):
				code_found = true
				text = text.replace("```gdscript","[left][color=33AAFF]")
			if text.contains("```glsl"):
				code_found = true
				text = text.replace("```glsl","[left][color=33AAFF]")
			if code_found:
				text = text.replace("```","[/color][/left]")
			suffix = "[/right]\n"
		Caller.System:
			prefix = "\n[center][color=FF7700][ "
			suffix = " ][/color][/center]\n"
	output_window.text += "%s%s%s" % [prefix, text, suffix]


func _on_edit_history_pressed() -> void:
	var history_editor:ChatHistoryEditor = CHAT_HISTORY_EDITOR.instantiate()
	history_editor.initialize(_conversation)
	add_child(history_editor)
	history_editor.popup()


func _on_temperature_override_checkbox_toggled(toggled_on: bool) -> void:
	temperature_slider_container.visible = toggled_on
	_llm.override_temperature = toggled_on


func _on_model_options_btn_item_selected(index: int) -> void:
	_llm.model = model_options_btn.text


func _on_temperature_slider_value_changed(value: float) -> void:
	_llm.temperature = snappedf(temperature_slider.value, 0.001)
