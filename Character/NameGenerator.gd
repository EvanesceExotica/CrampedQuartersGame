extends Node2D

var firstNames = ["Jere","Luann","Sonia","Junior","Brian","William","Madeleine","Santo","Josef","Jacques","Kieth","Bryce","Ola","Patty","Myles","Mario","Jasper","Deanna","Kathryn","Nola","Marjorie","Sherrie","Wendy","Mickey","Isiah","Jessica","Randy","Francisco","Cara","Lucinda","Wilburn","Nathanial","Evangeline","Blake","Colleen","Phillip","Vincenzo","Antoine","Lenore","Roslyn","Derrick","Elroy","Dolores","Ollie","Lynn","Marlon","Joesph","Foster","Phyllis","Rudolph"]    
var lastNames = ["Michael","Holt","Herring","Jackson","Ramirez","Blackwell","Morton","Parrish","Neal","Hobbs","Orr","Humphrey","Cooper","Hansen","Hardy","Cochran","Schmitt","Tucker","Sanders","Pena","Love","Rose","Fischer","Daniel","Macdonald","Gentry","Lowe","Huber","Hale","White","Allison","Phillips","Donaldson","Serrano","Rasmussen","Ali","Gray","Oconnor","Soto","Odonnell","Miranda","Keller","Wyatt","Espinoza","Townsend","Jordan","Mccarthy","Mccann","Levine","Oneill"] 

func generateName():
    var randomFirstNameNumber = randi()%firstNames.size()
    var randomLastNameNumber = randi()%lastNames.size()
    var name = firstNames[randomFirstNameNumber] + " " + lastNames[randomLastNameNumber]
    return name

func _ready():
    randomize()