
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- https://github.com/Ulydev/push
push = require 'push' -- This is how we call modules in LUA

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods
--
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

require 'Ball'
require 'Paddle'

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    -- use nearest-neighbor filtering on upscaling and downscaling to prevent blurring of text 
    -- and graphics; try removing this function to see the difference!
    love.graphics.setDefaultFilter('nearest', 'nearest') -- if we delete this line the letter will si blured
    
    -- math.randomseed -> help to set a random seed
    -- os.time --> every second the number returned change
    math.randomseed(os.time())

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

    -- initialize score variables, used for rendering on the screen and keeping
    -- track of the winner
    player1Score = 0
    player2Score = 0

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            
            ball:reset()
        end
    end
end

--[[
    Something you have to keep in mind, this function is called in every frame
]]
function love.update(dt)
    if love.keyboard.isDown('w') then
        -- math.max take the Maximum  nummber between the number given
        --[[
            math.max(2,3,4,7)
                -> 7
        ]]
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then 
        -- math.min take the Minimum nummber between the number given 
        --[[
            math.min(0,5, -3 , -10)
                -> -10
        ]]
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    if gameState == 'play' then
       ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
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
    player1:render()

    -- render the ball
    ball:render()

    -- render the right paddle
    player2:render()

    push:finish()
    
end