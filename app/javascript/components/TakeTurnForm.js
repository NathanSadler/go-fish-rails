import React from 'react';
import PropTypes from 'prop-types';
import Player from './Player';
// import Card from './Card.js';
// import Opponent from './Opponent.js';

class TakeTurnForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedCard: 'A',
      selectedOpponentId: this.props.opponents[0]
    };

    this.handleChange = this.handleChange.bind(this);
    this.onSubmit = this.onSubmit.bind(this);
  }

  onSubmit(event) {
    event.preventDefault();
  }

  render() {
    const crsf = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    return (
      <React.Fragment>
        <form onSubmit={this.onSubmit}>
          {this.cardRankBoxes()}
          {this.playerBoxes()}
          <input type='submit' value='Take Your Turn'></input>
        </form>

        {/* <form action={`/games/${this.props.gameId}`} method='post'>
          <input type='hidden' name='_method' value='patch' />
          <input type='hidden' name='authenticity_token' value={crsf} />
          {this.cardRankBoxes()}
          {this.playerBoxes()}
          <input type='submit' value='Take Your Turn'></input>
        </form> */}
      </React.Fragment>
    );
  }

  cardRankBoxes() {
    return (
      <select value={this.state.selectedCard} onChange={this.handleChange} name='selectedCard'>
        {this.props.player.getCards().map((card) => (
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
  player: PropTypes.instanceOf(Player),
  opponents: PropTypes.array,
  gameId: PropTypes.number
};

export default TakeTurnForm;
