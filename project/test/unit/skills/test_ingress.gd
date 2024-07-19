extends GutTest

var TestIngress := load("res://skills/blueprints/new_ingress.gd")
var TestIngressUtil := load("res://skills/ingress_util.gd")
var skill: Ingress
var util: IngressUtil


func before_each() -> void:
	skill = autofree(TestIngress.new(true))
	util = autofree(TestIngressUtil.new(true))

func test_can_create_ingress() -> void:
	assert_not_null(skill)

func test_can_create_each_element() -> void:
	skill = util.load_ingress([Ingress.Id.INCURSION, Element.Type.ETH])
	assert_not_null(skill)
	skill = util.load_ingress([Ingress.Id.INCURSION, Element.Type.ENH])
	assert_not_null(skill)
	skill = util.load_ingress([Ingress.Id.INCURSION, Element.Type.SHOR])
	assert_not_null(skill)
	skill = util.load_ingress([Ingress.Id.INCURSION, Element.Type.SCOR])
	assert_not_null(skill)