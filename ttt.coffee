class TicTacToe

  constructor: (@players...) ->
    @board = [
      0, 0, 0
      0, 0, 0
      0, 0, 0
    ]
    @play()

  # game loop
  play: ->
    game_over = false
    open_spaces = @board.length
    player = 0
    label = ['X', 'O']

    until game_over
      # prompt the player for input
      input = prompt """
        #{ @render(@board) }

        Playing as #{ label[player] }
        Choose a move #{ @players[player] } (or type quit to end game)
      """

      # no input was given
      unless input?
        alert 'I need a command (or type quit to end game)'
        continue

      # exit the game if instructed to
      if input.match(/exit|x|quit|q/gi)?
        game_over = true
        continue

      # get the position from string
      position = @get_position_from_string input
      unless position?
        alert 'Invalid move, please try again'
        continue

      [col, row] = position
      index = row*3 + col
      if @board[index] isnt 0
        alert 'Oops, that spot is already taken, try a different one'
        continue

      # it's a valid move, play it
      @board[index] = label[player]
      # there is one less open space
      open_spaces--

      # check for win
      if @game_winner(@board, label[player], col, row)
        alert "#{ @players[player] } wins!"
        game_over = true
        continue

      # check for tie
      if open_spaces is 0
        alert "oh no! it's a tie :("
        game_over = true
        continue

      # next player's turn
      player = (player + 1) % @players.length

    alert "thanks for playing #{ @players[0] } and #{ @players[1] }"

  render: (board) ->
    # draw_row is 0-base
    draw_row = (row = 0) ->
      i1 = row * 3
      i2 = i1 + 2
      board[i1..i2].join(' ').replace(/0/g, '_')

    """
       A B C
    1 #{ draw_row 0 }
    2 #{ draw_row 1 }
    3 #{ draw_row 2 }
    """

  get_position_from_string: (str) ->
    column =
      A: 0
      B: 1
      C: 2

    matches = str.match(/([1-3]+)\s*([A-C]+)/i)
    # try it the other way around if there is not a match
    unless matches?
      matches = str.match(/([A-C]+)\s*([1-3]+)/i)
      # return null if there is not a match
      unless matches?
        return null
      else
        # the first match is the full string, we don't need that
        [col, row] = matches[1..]
    else
      # the first match is the full string, we don't need that
      [row, col] = matches[1..]

    # find the col in the columns, otherwise return null for no match
    col = column[ col.toUpperCase() ]
    return null unless col?

    # turn column to 0-base and varify range otherwise return null
    row = parseInt(row, 10) - 1
    return null unless 0 <= row <= 2

    # return the valid [col, row] pair
    [col, row]

  game_winner: (board, player, col, row) ->
    # check col
    for _row in [0..2]
      index = _row*3 + col
      break if board[index] isnt player
      return true if _row is 2

    # check row
    for _col in [0..2]
      index = row*3 + _col
      break if board[index] isnt player
      return true if _col is 2

    # check \ diagonal
    for i in [0..2]
      _col = _row = i
      index = _row*3 + _col
      break if board[index] isnt player
      return true if i is 2

    # check / diagonal
    for i in [0..2]
      _col = i
      _row = 2-i
      index = _row*3 + _col
      break if board[index] isnt player
      return true if i is 2

    false

ttt = new TicTacToe "John", "Jane"
