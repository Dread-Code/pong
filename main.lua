
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()
    -- This fucntion help us to set a screen size
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end


function love.draw()
    love.graphics.printf(
        "Hello World", -- What do you want tu put on screen
        0, -- x position 
        WINDOW_HEIGHT / 2, -- y position
        WINDOW_WIDTH, -- Create lines horizontal depending on the number
        'center') -- aligment mode
end