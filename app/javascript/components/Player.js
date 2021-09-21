class Player {
  constructor(name, cards, score, userId) {
    this.name = name;
    this.cards = cards;
    this.score = score;
    this.userId = userId;
  }

  getCards() {
    return this.cards;
  }

  getName() {
    return this.name;
  }

  getScore() {
    return this.score;
  }

  userId() {
    return this.userId;
  }
}

export default Player;
