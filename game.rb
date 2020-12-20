require 'ruby2d'
# Set the window size
set width: 900, height: 600

@versus_computer = nil
# Create a new shape
@player_width = 50
@player_height = 160
@p1 = Rectangle.new(
  x: 25, y: 160,
  width: @player_width, height: @player_height,
  color: 'yellow',
  z: 20
)
@p2 = Rectangle.new(
  x: 875 - @player_width, y: 160,
  width: @player_width, height: @player_height,
  color: 'yellow',
  z: 20
)
# Give it some color
@ball = Circle.new(
  x: 450, y: 300,
  radius: 22,
  sectors: 32,
  color: 'aqua',
  z: 10
)
@p1point = 0
@p2point = 0
@horizontal_speed = 10
@vertical_speed = 3
@controller_move = 30
@key_move = 15

def collided?(ball, p1, p2)
  if ball.x >= p1.x && ball.x <= p1.x + p1.width && ball.y >= p1.y && ball.y <= p1.y + p1.height
    @horizontal_speed = @horizontal_speed * -1
    @horizontal_speed *= 1.1
  end
  if ball.x >= p2.x && ball.x <= p2.x + p2.width && ball.y >= p2.y && ball.y <= p2.y + p2.height
    @horizontal_speed = @horizontal_speed * -1
    @horizontal_speed *= 1.1
  end
end

def start_game
  player1score = Text.new(
    @p1point,
    x: 675, y: 20,
    size: 40,
    color: 'blue',
    rotate: 0,
    z: 10
  )
  player2score = Text.new(
    @p1point,
    x: 225, y: 20,
    size: 40,
    color: 'blue',
    rotate: 0,
    z: 10
  )

  if @p1point <= 28 && @p2point <= 28
    update do
      @ball.x += @horizontal_speed
      @ball.y += @vertical_speed
      if @ball.x > 900
        @p2point += 1
        @ball.x = 450
        @ball.y = 300
      end
      if @ball.x < 0
        @p1point += 1
        @ball.x = 450
        @ball.y = 300
      end
      if @ball.y > 600 || @ball.y < 0
        @vertical_speed = @vertical_speed * -1
      end
      collided?(@ball, @p1, @p2)
      player1score.text = @p1point
      player2score.text = @p2point
      if @versus_computer
        if @p2point >= 5
          if @ball.x <= rand(420..460) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move
            else
              @p1.y -= @key_move
            end
          end
          horizontal_speed = 13
          vertical_speed = 9
        end
        if @p2point == 4
          if @ball.x <= rand(390..430) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move / 2
            else
              @p1.y -= @key_move / 2
            end
          end
          horizontal_speed = 11
          vertical_speed = 8
        end
        if @p2point == 3
          if @ball.x <= rand(360..420) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move / 2
            else
              @p1.y -= @key_move / 2
            end
          end
          horizontal_speed = 9
          vertical_speed = 6
        end
        if @p2point == 2
          if @ball.x <= rand(350..390) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move / 3
            else
              @p1.y -= @key_move / 3
            end
          end
          horizontal_speed = 6
          vertical_speed = 5
        end
        if @p2point == 1
          if @ball.x <= rand(320..360) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move / 4
            else
              @p1.y -= @key_move / 4
            end
          end
          horizontal_speed = 5
          vertical_speed = 4
        end
        if @p2point == 0
          if @ball.x <= rand(300..320) && @horizontal_speed <= 0
            if @ball.y >= @p1.y + @player_height / 2
              @p1.y += @key_move / 4
            else
              @p1.y -= @key_move / 4
            end
          end
          horizontal_speed = 3
          vertical_speed = 2
        end
      end
    end
  elsif @p1point > 8
    Text.new(
    'You have lost',
    x: 120, y: 20,
    size: 120,
    color: 'blue',
    rotate: 0,
    z: 10
  )
  elsif @p2point > 8
    Text.new(
    'You have won',
    x: 225, y: 20,
    size: 120,
    color: 'blue',
    rotate: 0,
    z: 10
  )
  end
end

on :controller do |event|
  # A mouse event occurred
  if event.button == :b

    if p1.y >= 0
      p1.y = p1.y - @controller_move
    end
  end

  if event.button == :a
    if p1.y <= 600 - 160
      p1.y += @controller_move
    end
  end
end

# Show the window
menu_text = Text.new(
  'Player vs Player Press :UP',
  x: 220, y: 100,
  size: 40,
  color: 'green',
  rotate: 0,
  z: 10
)
second_text = Text.new(
  'Player vs Computer Press :DOWN',
  x: 200, y: 150,
  size: 40,
  color: 'green',
  rotate: 0,
  z: 10
)

on :key do |event|
  if @versus_computer == nil
    if event.key == "down"
      @versus_computer = true
      menu_text.text = ''
      second_text.text = ''
      start_game
    elsif event.key == "up"
      @versus_computer = false
      menu_text.text = ''
      second_text.text = ''
      start_game
    end
  end

  # A mouse event occurred
  if @versus_computer != nil && event.key == 'up'
    if @p2.y >= 0
      @p2.y = @p2.y - @key_move
    end
  end
  puts event

  if @versus_computer != nil && event.key == 'down'
    if @p2.y <= 600 - 160
      @p2.y += @key_move
    end
  end
end

show
