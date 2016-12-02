function love.load()
  scale = 4

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
        x = 68,
        y = 64,
      },
    },
    speed = 0.07,
    last_move = {x = scale, y = 0},
  }

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
  draw_snake()
end

function love.keypressed(key)
  if key == "g" then
    grow()
  end

  if key == "r" then
    shrink()
  end

  if key == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  tick(dt)

  if love.keyboard.isDown("left") and timer >= snake.speed then
    timer = 0
    move(-scale,0)
  end

  if love.keyboard.isDown("right") and timer >= snake.speed then
    timer = 0
    move(scale,0)
  end

  if love.keyboard.isDown("up") and timer >= snake.speed then
    timer = 0
    move(0,-scale)
  end

  if love.keyboard.isDown("down") and timer >= snake.speed then
    timer = 0
    move(0,scale)
  end
end

function move(delta_x,delta_y)
  temp = {{x = snake.segments[1].x + delta_x, y = snake.segments[1].y + delta_y}}

  for i=1, table.getn(snake.segments) - 1 do
    temp[i+1] = snake.segments[i]
  end

  snake.last_move = {
    x = delta_x,
    y = delta_y
  }

  snake.segments = temp
end

function shrink()
  if table.getn(snake.segments) > 1 then
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
  love.graphics.setColor(colours.mid_dark)
  love.graphics.rectangle("fill", 0, 0, scale, 144)
  love.graphics.rectangle("fill", 0, 0, 160, scale)
  love.graphics.rectangle("fill", 156, 0, scale, 144)
  love.graphics.rectangle("fill", 0, 140, 160, scale)
end

function draw_snake()
  love.graphics.setColor(colours.mid_dark)
  for i=1, table.getn(snake.segments) do
    love.graphics.rectangle("fill", snake.segments[i].x, snake.segments[i].y, scale, scale)
  end
end

function tick(dt)
  if timer < snake.speed then
    timer = timer + dt
  end
end
