class Card {
  constructor(rank, suit) {
    this._rank = rank;
    this._suit = suit;
  }

  key() {
    return `${this.getRank()}_${this.getSuit()}`
  }

  describe() {
    return `${this.getRank()} of ${this.getSuit()}`
  }

  getPath() {
    return `./${this.key()}.png`;
  }

  getRank() {
    return this._rank;
  }

  getSuit() {
    return this._suit;
  }
}

export default Card;
