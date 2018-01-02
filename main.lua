function love.load()
  state = {
    started = false,
    dead = false,
  }

  scale = 4
  width = 160
  height = 144

  snake = {}
  load_snake()

  colours = {
    dark = {15,56,15,255},
    mid_dark = {48,98,48,255},
    mid_light = {139,172,15,255},
    light = {155,188,15,255},
  }

  timer = 0
end

function love.draw()
  love.graphics.scale(scale,scale)
  love.graphics.setBackgroundColor(colours.light)
  draw_borders()

  if state.started then
    draw_snake()
  else
    if state.dead ~= true then
      -- draw_win()
      draw_title()
    else
      draw_loss()
    end
  end
end

function love.keypressed(key)
  if key == "g" then
    grow()
  end

  if key == "r" then
    shrink()
  end

  if key == "space" then
    state.started = true
  end

  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  tick(dt)

  if is_left() and timer >= snake.speed then
    timer = 0
    move(-scale,0)
  end

  if is_right() and timer >= snake.speed then
    timer = 0
    move(scale,0)
  end

  if is_up() and timer >= snake.speed then
    timer = 0
    move(0,-scale)
  end

  if is_down() and timer >= snake.speed then
    timer = 0
    move(0,scale)
  end
end

function is_left()
  return (love.keyboard.isDown("left") or love.keyboard.isDown("a"))
end

function is_right()
  return (love.keyboard.isDown("right") or love.keyboard.isDown("d"))
end

function is_down()
  return (love.keyboard.isDown("down") or love.keyboard.isDown("s"))
end

function is_up()
  return (love.keyboard.isDown("up") or love.keyboard.isDown("w"))
end

function move(delta_x,delta_y)
  new_x = snake.segments[1].x + delta_x
  new_y = snake.segments[1].y + delta_y
  length = table.getn(snake.segments)

  if new_x == snake.segments[length].x and new_y == snake.segments[length].y then
    state.started = false
    state.dead = false
    load_snake()
    return
  end

  -- Don't let the snake move backwards over itself
  if snake.last_move.x == -delta_x and snake.last_move.y == -delta_y then
    return
  end

  -- Don't let the snake move past walls
  if new_x < scale or new_y < scale or new_x > width - scale*2 or new_y > height - scale*2 then
    return
  end

  temp = {{x = new_x, y = new_y}}

  for i=1, length - 1 do
    if new_x == snake.segments[i].x and new_y == snake.segments[i].y then
      state.started = false
      state.dead = true
      load_snake()
      return
    end

    temp[i+1] = snake.segments[i]
  end

  snake.last_move = {
    x = delta_x,
    y = delta_y
  }

  snake.segments = temp
end

function shrink()
  if table.getn(snake.segments) > 3 then
    table.remove(snake.segments)
  end
end

function grow()
  l = table.getn(snake.segments)
  snake.segments[l+1] = {
    x = snake.segments[l].x - snake.last_move.x,
    y = snake.segments[l].y - snake.last_move.y,
  }
end

function draw_borders()
  love.graphics.setColor(colours.dark)
  love.graphics.rectangle("fill", 0, 0, scale, 144)
  love.graphics.rectangle("fill", 0, 0, 160, scale)
  love.graphics.rectangle("fill", 156, 0, scale, 144)
  love.graphics.rectangle("fill", 0, 140, 160, scale)
end

function draw_snake()
  love.graphics.setColor(colours.mid_dark)
  love.graphics.rectangle("fill", snake.segments[1].x, snake.segments[1].y, scale, scale)
  love.graphics.setColor(colours.mid_light)
  love.graphics.rectangle("fill", snake.segments[2].x, snake.segments[2].y, scale, scale)

  love.graphics.setColor(colours.mid_dark)
  for i=3, table.getn(snake.segments) do
    love.graphics.rectangle("fill", snake.segments[i].x, snake.segments[i].y, scale, scale)
  end
end

function draw_loss()
  love.graphics.setColor(colours.dark)
  -- Center
  love.graphics.rectangle("fill", 76, 68, 4, 4)

  -- Top left
  love.graphics.rectangle("fill", 72, 64, 4, 4)
  love.graphics.rectangle("fill", 68, 60, 4, 4)

  -- Bottom left
  love.graphics.rectangle("fill", 72, 72, 4, 4)
  love.graphics.rectangle("fill", 68, 76, 4, 4)

  -- Top right
  love.graphics.rectangle("fill", 80, 64, 4, 4)
  love.graphics.rectangle("fill", 84, 60, 4, 4)

  -- Bottom right
  love.graphics.rectangle("fill", 80, 72, 4, 4)
  love.graphics.rectangle("fill", 84, 76, 4, 4)
end

function draw_win()
  love.graphics.setColor(colours.dark)
  -- Top
  love.graphics.rectangle("fill", 68, 60, 20, 4)

  -- Bottom
  love.graphics.rectangle("fill", 68, 76, 20, 4)

  -- Left
  love.graphics.rectangle("fill", 68, 60, 4, 20)

  -- Right
  love.graphics.rectangle("fill", 84, 60, 4, 20)
end

function draw_title()
  love.graphics.setColor(colours.dark)

  -- O
  love.graphics.rectangle("fill", 44, 60, 20, 4) -- Top
  love.graphics.rectangle("fill", 44, 76, 20, 4) -- Bottom
  love.graphics.rectangle("fill", 44, 60, 4, 20) -- Left
  love.graphics.rectangle("fill", 60, 60, 4, 20) -- Right

  -- R
  love.graphics.rectangle("fill", 68, 60, 20, 4) -- Top
  love.graphics.rectangle("fill", 68, 60, 4, 20) -- Left
  love.graphics.rectangle("fill", 68, 68, 20, 4) -- Bottom
  love.graphics.rectangle("fill", 84, 60, 4, 12) -- Right
  love.graphics.rectangle("fill", 80, 72, 4, 4) -- Stem
  love.graphics.rectangle("fill", 84, 76, 4, 4) -- Stem

  -- O
  love.graphics.rectangle("fill", 92, 60, 20, 4) -- Top
  love.graphics.rectangle("fill", 92, 76, 20, 4) -- Bottom
  love.graphics.rectangle("fill", 92, 60, 4, 20) -- Left
  love.graphics.rectangle("fill", 108, 60, 4, 20) -- Right
end

function tick(dt)
  if timer < snake.speed then
    timer = timer + dt
  end
end

function load_snake()
  snake = {
    segments = {
      {
        x = 76,
        y = 68,
      },
      {
        x = 72,
        y = 68,
      },
      {
        x = 68,
        y = 68,
      },
      {
        x = 64,
        y = 68,
      },
      {
        x = 64,
        y = 64,
      },
    },
    speed = 0.07,
    last_move = {x = scale, y = 0},
  }
end
