
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- https://github.com/Ulydev/push
push = require 'push' -- This is how we call modules in LUA

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest') -- if we delete this line the letter will si blured

    -- gettiing the font 
    -- love.graphics.newFont(fontFile, size)
    retroFont = love.graphics.newFont('font.ttf', 8)

    -- Setting the font 
    love.graphics.setFont(retroFont)

    -- This fucntion help us to set a screen size
    -- love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
    --  fullscreen = false,
    --  resizable = false,
    --    vsync = true
    -- })

    -- We replaced the behind funtion with this to create a vintage game screen
    -- push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen, resizable, canvas, pixelperfect})
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()

    push:start()

    -- set a background or clear the screen with a color
    -- love.graphics.clear(r, g, b, a)
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.printf(
        "Hello World", -- What do you want tu put on screen
        0, -- x position 
        20, -- y position
        VIRTUAL_WIDTH, -- Create lines horizontal depending on the number
        'center') -- aligment mode

    -- render a vertical rectangle
    -- love.graphics.rectangle(mode, x ,y, width, height)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- render the ball
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4, 4)

    -- render the right paddle
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    push:finish()
    
end