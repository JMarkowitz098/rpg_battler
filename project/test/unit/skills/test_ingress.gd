# extends GutTest

# var TestIngress := load("res://skills/ingress.gd")
# var skill: Ingress


# func before_each() -> void:
# 	skill = autofree(TestIngress.new(true))

# func test_can_create_ingress() -> void:
# 	assert_not_null(skill)

# func test_can_create_each_element() -> void:
# 	skill = TestIngress.load_ingress([Ingress.Id.INCURSION, Element.Type.ETH])
# 	assert_not_null(skill)
# 	skill = TestIngress.load_ingress([Ingress.Id.INCURSION, Element.Type.ENH])
# 	assert_not_null(skill)
# 	skill = TestIngress.load_ingress([Ingress.Id.INCURSION, Element.Type.SHOR])
# 	assert_not_null(skill)
# 	skill = TestIngress.load_ingress([Ingress.Id.INCURSION, Element.Type.SCOR])
# 	assert_not_null(skill)