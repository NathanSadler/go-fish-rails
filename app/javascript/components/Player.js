import Card from './Card';

class Player {
  constructor(name, cards, score, userId) {
    this.name = name;
    // debugger;
    this.cards = cards.map((card_json) => {
      return new Card(card_json.rank, card_json.suit);
    });
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
