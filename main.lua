function love.load()
  snake = {
    x = 256,
    y = 256,
  }

  colours = {
    dark = {15,56,15,255},
    mid_dark = {48,98,48,255},
    mid_light = {139,172,15,255},
    light = {155,188,15,255},
  }
end

function love.draw()
  love.graphics.scale(5,5)
  love.graphics.setColor(colours.light)
  love.graphics.rectangle("fill", 0, 0, 160, 144)
  love.graphics.setColor(colours.mid_dark)
  love.graphics.rectangle("fill", 0, 0, 5, 144)
  love.graphics.rectangle("fill", 0, 0, 160, 5)
  love.graphics.rectangle("fill", 155, 0, 5, 144)
  love.graphics.rectangle("fill", 0, 139, 160, 5)
end

function love.update(dt)

end
