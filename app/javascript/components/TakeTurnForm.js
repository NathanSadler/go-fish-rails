import React from 'react';
import PropTypes from 'prop-types';
// import Card from './Card.js';
// import Opponent from './Opponent.js';

class TakeTurnForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedCard: this.props.heldCards[0],
      selectedOpponentId: this.props.opponents[0]
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
          <input type='submit' value='Take Your Turn'></input>
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
          {this.props.opponents.map((opponent) => (
            <option key={opponent.user_id} value={opponent.user_id}>
              {opponent.name}
            </option>
          ))}
        </select>
      </div>
    );
  }
}

TakeTurnForm.propTypes = {
  heldCards: PropTypes.array,
  opponents: PropTypes.array
};
export default TakeTurnForm;
