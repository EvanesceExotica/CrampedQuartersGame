extends Node2D

enum direction {
    north,
    northEast,
    east,
    southEast,
    south,
    southWest,
    west
    
}
export (direction) var ourDirection;

func _ready():
    if ourDirection == direction.north:
        self.rotation_degrees = 0
        pass
    elif ourDirection == direction.northEast:
        self.rotation_degrees = 45
        pass
    elif ourDirection == direction.east:
        self.rotation_degrees = 90
        pass
    elif ourDirection == direction.southEast:
        self.rotation_degrees = 135
        pass
    elif ourDirection == direction.south:
        self.rotation_degrees = 180
        pass
    elif ourDirection == direction.southWest:
        self.rotation_degrees = 225
        pass
    elif ourDirection == direction.west:
        self.rotation_degrees = 270
