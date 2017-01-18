import React from 'react';
import ReactDOM from 'react-dom';
import $ from 'jquery';
import 'jquery-ui/draggable';

class Title extends React.Component {
  constructor() {
    super();
    this.state = {
      value: 'Hello, world!'
    };
  }
  componentDidMount() {
    $(this.refs.el).draggable();
  }
  render() {
    return (
      <h1 ref="el">
        {this.state.value}
      </h1>
    );
  }
}

ReactDOM.render(
  <Title />,
  document.getElementById('example')
);
