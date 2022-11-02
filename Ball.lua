
--[[
    Remember that all of this Class is added 
    thx to a metaprogramming code made it 
    width lua in class.lua

    This allow us to use POO more easier than
    the lua POO methodology
]]

Ball = Class{}

-- Constructor method 
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)
end

--[[
    This is created based of an algorithm call AABB Collision detection
    you could find a little example of how works here:
    https://tutorialedge.net/gamedev/aabb-collision-detection-tutorial/
]]
function Ball:collides(paddle)

    --[[
        if you want know more about this lines of code check the following
        image https://user-images.githubusercontent.com/60331479/199513816-b6f37f62-ea39-47b4-98ba-80e9527e6a3a.png
    ]]

    --[[
        First, check to see if the left edge of either is farther to the right
        than the right edge of the other
    ]]
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    --[[
        Then check to see if the bottom edge of either is higher than the top
        edge of the other
    ]]
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end

    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 -2
    self.dx = math.random(2) == 1 and 100 or -100
    self.dy = math.random(-50, 50)
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end