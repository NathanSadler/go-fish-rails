import React from 'react';
import PropTypes from 'prop-types';
class Opponent extends React.Component {
  constructor(props) {
    super(props);

    this.state = null;
  }

  render() {
    return this.state ? `${this.state.name}, ${this.state.score} book(s)` : null;
  }

  componentDidMount() {
    this.fetchUser(this.props.gamePlayerPath);
  }

  async fetchUser(path) {
    const response = await fetch(path, {
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json'
      }
    });

    const json = await response.json();
    this.handleServerUpdate(json);
  }

  handleServerUpdate(json) {
    this.setState({
      name: json.name,
      score: json.score
    });
  }
}

Opponent.propTypes = {
  gamePlayerPath: PropTypes.string
};

export default Opponent;
