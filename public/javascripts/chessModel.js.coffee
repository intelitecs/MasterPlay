COLS   = 8
ROWS   = 8
TOP    = 1
BOTTOM = -1
LEFT   = -1
RIGHT  = -1


class Position
  constructor: (@x,@y,@grid) ->

  setPlayer: (player) ->
    @player = player

  getPlayer: ->
    @player

  removePlayer: ->
    @player = null

  hasPlayer: ->
    @player?

  straight: (ascending) ->
    @grid.getPosition(@x + (1 * ascending), @y)

  sideWays: (right) ->
    @grid.getPosition(@x, @y+ (1 * right))

  across: (top, right) ->
    @grid.getPosition(@x+(1 * top), @y +(1 * right))

  canReach: (targetPosition) ->
    targetPosition in @player.potentialMoves()



straightFn = (direction) -> (position) -> position?.straight(direction)
sideWayFn  = (direction) -> (position) -> position?.sideWays(direction)
acrossFn   = (top,right) -> (position) -> position?.across(top,right)


iterateFn = (start, startFn) ->
  startCache = start
  moves      = []
  while true
    start = startFn(start)
    if start
      if !start.hasPlayer()
        moves.push(start)
      else if start.hasPlayer() and start.getPlayer().getCode() !=  startCache.getPlayer().getColor()
        moves.push(start)
        break
      else
        break
    else
      break

  return moves


class Grid
  constructor:  ->
    @grid = []

    for row in [0..7]
      @grid[row] = []
      for col in [0..7]
        @grid[row].push(new Postion(row,col,@))

  initialize: ->
    colors = ['white','black']
    rows   = [0,1,6,7]
    for row, index in rows
      for col in [1..8]
        color    = colors[if index < 2 then  0 else 1]
        position = @grid[row][col]
        player   = null
        switch row
          when 1,6
            player = new Pawn(if index < 2 then  TOP else BOTTOM)
          when 0,7
            switch col
              when 0,7
                player = new Rook()
              when 1,6
                player = new Knight()
              when 2,5
                player = new Bishop()
              when 3
                player = new Queen()
              when 4
                player = new King()

        player.setColor(color)
        player.setPosition(position)
        position.setPlayer(player)

    getPosition: (x,y) ->
      @grid[x]?[y]


class Player
  setPosition: (@position) ->

  potentialMoves: ->
    throw new Error("Not Implemented yet")

  delete: ->
    @deleted = true

  setColor: (color) ->

  getColor: ->
    @color

  getLabel: ->
    throw new Error("Unimplemented getLabel()")




class Pawn extends Player
  constructor: (@ascending) ->

  getLabel: ->
    if @color is 'white'
      '\u2659'
    else
      '\u265F'

  potentialMoves: ->
    result = []
    straight = @position.straight(@ascending)
    result.push(straight) if straight and !straight.hasPlayer()
    acrossMoveFn = (position) ->
      position and position.getPlayer() and position.getPlayer().getCode() != @color


    killMoveRight = @position.across(@ascending,RIGHT)
    result.push killMoveRight if acrossMoveFn(killMoveRight)
    killMoveLeft = @position.across(@ascending,LEFT)
    result.push killMoveLeft if acrossMoveFn(killMoveLeft)
    return result







class Rook extends Player
  getLabel:  ->
    if @color is 'white'
      '\u2656'
    else
      '\u265c'

  potentialMoves: ->
    result = []

    for fn in [straightFn(TOP), straightFn(BOTTOM), straightFn(RIGHT),sideWayFn(BOTTOM)]
      result.push(move for move in iterateFn(@position,fn))
    return result




class Bishop extends Player
  getLabel: ->
    if @color is 'white'
      '\u2657'
    else
      '\u265D'

  potentialMoves: ->
    result = []

    for fn in [acrossFn(TOP,RIGHT), acrossFn(TOP,LEFT), acrossFn(BOTTOM,LEFT),acrossFn(BOTTOM,RIGHT)]
      result.push(move for move in iterateFn(@position,fn))
    return result




class Knight extends Player
  getLabel: ->
    if @color is 'white'
      '\u2658'
    else
      '\u265E'

  potentialMoves: ->
    result = []

    horseMoveFn = (move2, move1) -> (position) ->
      startCache = position
      position   = move2(position)
      position   = move2(position)
      position   = move1(position)
      if position
        if !position.getPlayer()
          return position
        else if position.getPlayer().getColor() != startCache.getPlayer().getColor()
          return position

    horseMoveFns = [
      horseMoveFn(straightFn(TOP), sideWayFn(RIGHT))
      horseMoveFn(straightFn(TOP), sideWayFn(LEFT))
      horseMoveFn(straightFn(BOTTOM), sideWayFn(RIGHT))
      horseMoveFn(straightFn(BOTTOM), sideWayFn(LEFT))
      horseMoveFn(straightFn(RIGHT), sideWayFn(TOP))
      horseMoveFn(straightFn(RIGHT), sideWayFn(BOTTOM))
      horseMoveFn(straightFn(LEFT), sideWayFn(TOP))
      horseMoveFn(straightFn(LEFT), sideWayFn(BOTTOM))
    ]


    for horseMoveFn in horseMoveFns
      potentialPosition = horseMoveFn(@position)
      result.push(potentialPosition if potentialPosition)
    return result



class Queen extends Player
  getLabel: ->
    if @color is 'white'
      '\u2655'
    else
      '\u265B'

  potentialMoves: ->
    result = []

    for fn in [acrossFn(TOP,RIGHT), acrossFn(TOP,LEFT), acrossFn(BOTTOM,LEFT),acrossFn(BOTTOM,RIGHT)]
      result.push(move for move in iterateFn(@position,fn))

    for fn in [straightFn(TOP), straightFn(BOTTOM), sideWayFn(RIGHT), sideWayFn(BOTTOM)]
      result.push(move for move in iterateFn(@position,fn))

    return result







class King extends Player
  getLabel: () ->
    if @color == 'white'
      '\u2654'
    else
      '\u265A'

  potentialMoves: () ->
    result = []

    for fn in [
      acrossFn(TOP, RIGHT),
      acrossFn(TOP, LEFT),
      acrossFn(BOTTOM, LEFT),
      acrossFn(BOTTOM, RIGHT),
      straightFn(TOP),
      straightFn(BOTTOM),
      sideWayFn(RIGHT),
      sideWayFn(BOTTOM)
    ]
      result.push fn(@position) if (fn(@position) and (!fn(@position).getPlayer()? or fn(@position).getPlayer().getColor() != @color))

    return result