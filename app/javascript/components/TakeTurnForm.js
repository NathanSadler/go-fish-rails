import React from 'react';
import PropTypes from 'prop-types';
// import Card from './Card.js';
// import Opponent from './Opponent.js';

class TakeTurnForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedCard: this.props.heldCards[0],
      selectedOpponentId: this.props.opponentGameuserIds[0]
    };

    this.handleChange = this.handleChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }

  onSubmit(event) {
    event.preventDefault();
    this.logState();
  }

  render() {
    return (
      <React.Fragment>
        <form onSubmit={this.onSubmit}>
          {this.cardRankBoxes()}
          {this.playerBoxes()}
          <input type='submit' value='submit'></input>
        </form>
      </React.Fragment>
    );
  }

  cardRankBoxes() {
    return (
      <select value={this.state.selectedCard} onChange={this.handleChange} name='selectedCard'>
        {this.props.heldCards.map((card) => (
          <option key={`${card.rank}-${card.suit}`} value={`${card.rank}-${card.suit}`}>
            {card.rank} of {card.suit}
          </option>
        ))}
      </select>
    );
  }

  handleChange(event) {
    const name = event.target.name;
    const value = event.target.value;
    this.setState({ [name]: value });
  }

  logState() {
    console.log(this.state.selectedCard);
  }

  playerBoxes() {
    return (
      <div>
        <select onChange={this.handleChange} value={this.state.selectedOpponentId}>
          {this.props.opponentGameuserIds.map((id, index) => (
            <option key={id} value={id}>
              Opponent #{index + 1}
            </option>
          ))}
        </select>
      </div>
    );
  }
}

TakeTurnForm.propTypes = {
  heldCards: PropTypes.array,
  opponentGameuserIds: PropTypes.array
};
export default TakeTurnForm;
