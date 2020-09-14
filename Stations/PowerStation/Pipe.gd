extends Line2D

var pipeLengthMin
var pipeLengthMax
var numberOfBends = 5

func _ready():
	randomize()
	print("This is working")
	GenerateRandomPipeDirections()

func GenerateRandomPipeDirections():
	self.add_point(Vector2(0, 0));
	var leftValue = 0
	var rightValue = 0;
	for i in range(5):
		if i%2 == 0:
			leftValue+=100;
		else:
			rightValue +=100;
		self.add_point(Vector2(leftValue, rightValue));
		

