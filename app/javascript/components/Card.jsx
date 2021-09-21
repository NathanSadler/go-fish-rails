class Card {
  constructor(rank, suit) {
    this._rank = rank;
    this._suit = suit;
  }

  key() {
    return `${this.getRank()}_${this.getSuit()}`
  }

  describe() {
    const nonNumericalRanks = {'A': 'Ace', 'J': 'Jack', 'Q': 'Queen', 'K': 'King'}
    const suitNames = {'C': 'Clubs', 'D': 'Diamonds', 'H': 'Hearts', 'S': 'Spades'}
    const rankDescription = !nonNumericalRanks.hasOwnProperty(this.getRank()) ? this.getRank() : nonNumericalRanks[this.getRank()]
    return `${rankDescription} of ${suitNames[this.getSuit()]}`
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
