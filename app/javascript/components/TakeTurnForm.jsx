import React from 'react';
import PropTypes from 'prop-types';
import Player from './Player';
// import Card from './Card.js';
// import Opponent from './Opponent.js';

class TakeTurnForm extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      selectedCard: this.props.player.getCards()[0],
      selectedOpponentId: this.props.opponents[0]
    };
  }

  onSubmit(event) {
    event.preventDefault();
    this.props.onSubmit(this.state.selectedOpponentId, this.state.selectedCard);
  }

  render() {
    // const crsf = document.querySelector("meta[name='csrf-token']").getAttribute('content');
    return (
      <React.Fragment>
        <form onSubmit={this.onSubmit.bind(this)}>
          {this.cardRankBoxes()}
          {this.playerBoxes()}
          <input type='submit' value='Take Your Turn'></input>
        </form>
      </React.Fragment>
    );
  }

  cardRankBoxes() {
    return (
      <select
        id='cardRankBoxes'
        value={this.state.selectedCard}
        onChange={this.handleChange.bind(this)}
        name='selectedCard'
      >
        {this.props.player.getCards().map((card) => (
          <option key={`${card.key()}`} value={`${card.getRank()}`}>
            {card.describe()}
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
        <select id='PlayerBoxes' onChange={this.handleChange.bind(this)} value={this.state.selectedOpponentId}>
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
  gameId: PropTypes.number,
  path: PropTypes.string,
  onSubmit: PropTypes.func
};

export default TakeTurnForm;
