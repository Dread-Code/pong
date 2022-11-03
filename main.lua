
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

    love.window.setTitle('Pong')
    
    -- math.randomseed -> help to set a random seed
    -- os.time --> every second the number returned change
    math.randomseed(os.time())

    -- gettiing the font 
    -- love.graphics.newFont(fontFile, size)
    retroFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)

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
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

--[[
    Something you have to keep in mind, this function is called in every frame
]]
function love.update(dt)
    if  gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == 'play' then
        --[[
            When the ball detects that te paddle touch it we turn 
            the velocity and increasing slightly, then we shift x position 
            from left to right.
        ]]
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            --[[
                Here I try to keeping the velocity in the same direction
                but randomize it
            ]]
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        --[[
            detect upper and lower screen boundary collision and reverse if collided
        ]]
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end

        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end
    end

    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1
        ball:reset()
        gameState = 'serve' 
    end

    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1Score = player1Score + 1
        ball:reset()
        gameState = 'serve' 
    end

    -- player movement
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
    displayScore()
    if gameState == 'start' then
        love.graphics.setFont(retroFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(retroFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", 
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- no UI messages to display in play
    end

    -- render a vertical rectangle
    -- love.graphics.rectangle(mode, x ,y, width, height)
    player1:render()

    -- render the ball
    ball:render()

    -- render the right paddle
    player2:render()

    displayFPS()

    push:finish() 
    
end

function displayFPS()
    love.graphics.setFont(retroFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

--[[
    Simply draws the score to the screen.
]]
function displayScore()
    -- draw score on the left and right center of the screen
    -- need to switch font to draw before actually printing
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end