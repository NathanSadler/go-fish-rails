import React from 'react';
import PropTypes from 'prop-types';
import Opponent from './Opponent';
import TakeTurnForm from './TakeTurnForm';
import Player from './Player';
import Card from './Card';
import Rails from '@rails/ujs';

class GameView extends React.Component {
  constructor(props) {
    super(props);

    this.state = null;
    // this.playTurn = this.playTurn.bind(this);
  }

  render() {
    return this.state ? (
      <div>
        <Card rank='4' suit='C'></Card>
        <br />
        {this.state.cards_in_deck} <ul>{this.listOpponents()}</ul>
        <div>{this.state.player.getName()}</div>
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
    return this.state.opponents.map((opponent) => (
      <li key={opponent}>
        <Opponent gamePlayerPath={`/game_user/${opponent.gameuser_id}`} />
      </li>
    ));
  }

  // requestedPlayer not defined
  async playTurn(requestedPlayer, requestedRank) {
    const response = await fetch(`${this.props.path}`, {
      method: 'PATCH',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
      },

      body: JSON.stringify({
        game: { requested_player: requestedPlayer, requested_rank: requestedRank }
      })
    });

    const json = await response.json();

    this.handleServerUpdate(json);
  }

  takeTurnForm() {
    if (this.state.isTurnPlayer) {
      return (
        <TakeTurnForm
          player={this.state.player}
          gameId={this.state.game_id}
          opponents={this.state.opponents}
          // pass in onSubmit prop
          onSubmit={this.playTurn.bind(this)}
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
