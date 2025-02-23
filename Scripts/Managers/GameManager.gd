extends Node  # A singleton is usually a Node, but it can be RefCounted too.

class_name GameManager  # Optional: Allows type hints for this class

@export var loadDebugCompany: bool
@export var initialDebugMoney: float = 4000

static var instance: GameManager

signal created_company(company: Company)

func CreateCompany(companyName: String, initialMoney: float):
	var currentCompany = Company.new(companyName, initialMoney)
	print('company '+currentCompany.name+' created')
	created_company.emit(currentCompany)

func _init():
	instance = self;

func _ready():
	if (loadDebugCompany):
		CreateCompany("Default Company", initialDebugMoney)
