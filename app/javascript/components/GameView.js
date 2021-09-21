import React from 'react';
import PropTypes from 'prop-types';
import Opponent from './Opponent';
import TakeTurnForm from './TakeTurnForm';
import Player from './Player';

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
        <div>{this.state.player.getName()}</div>
        <div>{this.takeTurnForm()}</div>
        {/* <div>{this.props.authenticityToken}</div> */}
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
    return this.state.opponents.map((opponent) => (
      <li key={opponent}>
        <Opponent gamePlayerPath={`/game_user/${opponent.gameuser_id}`} />
      </li>
    ));
  }

  takeTurnForm() {
    if (this.state.isTurnPlayer) {
      return (
        <TakeTurnForm
          player={this.state.player}
          gameId={this.state.game_id}
          opponents={this.state.opponents}
          // pass in onSubmit prop
        />
      );
    }

    return;
  }

  handleServerUpdate(json) {
    const foo = new Player(
      json['player_name'],
      json['held_cards'],
      json['player_score'],
      json['user_id']
    );

    this.setState({
      cards_in_deck: json['cards_in_deck'],
      opponents: json['opponents'],
      // put into actual JavaScript models
      // player: json['user_player'],
      player: foo,
      game_id: json['game_id'],
      isTurnPlayer: json['is_turn_player']
    });
  }
}

GameView.propTypes = {
  path: PropTypes.string.isRequired
  // authenticityToken: PropTypes.string
};

export default GameView;
