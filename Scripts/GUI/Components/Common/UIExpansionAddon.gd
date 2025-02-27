extends Control

class_name UIExpansionAddon

@export var name_label: Label
@export var cost_label: Label

func init(addon: ExpansionAddon, expansion: Set):
	name_label.text = addon.name
	cost_label.text = "%.0f" % addon.get_cost(expansion)


