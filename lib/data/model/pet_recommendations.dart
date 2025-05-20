class PetRecommendations {
  String userId;
  String petId;

  PetRecommendations(this.userId , this.petId);
}

class Food extends PetRecommendations{
  Food(super.userId, super.petId);

}

class Vitamins extends PetRecommendations{
  Vitamins(super.userId, super.petId);

}

class Medicines extends PetRecommendations{
  Medicines(super.userId, super.petId);

}