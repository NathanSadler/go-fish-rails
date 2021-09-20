import React from 'react';
import PropTypes from 'prop-types';
import Opponent from './Opponent';
import TakeTurnForm from './TakeTurnForm';

class GameView extends React.Component {
  constructor(props) {
    super(props);

    this.state = null;
  }

  render() {
    return this.state ? (
      <div>
        <div>
          {this.state.cards_in_deck} <ul>{this.listOpponents()}</ul>
        </div>
        <div>{this.state.player}</div>
        <div>{this.takeTurnForm()}</div>
      </div>
    ) : (
      <div>Loading...</div>
    );
  }

  componentDidMount() {
    this.fetchGame(this.props.path);
  }

  async fetchGame(path) {
    // debugger
    const response = await fetch(path, {
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      }
    });

    const json = await response.json();
    this.handleServerUpdate(json);
  }

  listOpponents() {
    return this.state.opponent_gameuser_ids.map((id) => (
      <li key={id}>
        <Opponent gamePlayerPath={`/game_user/${id}`} />
      </li>
    ));
  }

  takeTurnForm() {
    return (
      <TakeTurnForm
        heldCards={this.state.held_cards}
        opponentGameuserIds={this.state.opponent_gameuser_ids}
      />
    );
  }

  handleServerUpdate(json) {
    this.setState({
      cards_in_deck: json['cards_in_deck'],
      opponent_gameuser_ids: json['opponent_gameuser_ids'],
      player: json['user_player'],
      held_cards: json['held_cards']
    });
  }
}

GameView.propTypes = {
  path: PropTypes.string.isRequired
};

export default GameView;
