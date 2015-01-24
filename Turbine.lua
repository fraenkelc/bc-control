Turbine = {}
Turbine.__index = Turbine

setmetatable(Turbine, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function Turbine.new(name)
  local self = setmetatable({}, Turbine)
  self.name = name
  self.port = peripheral.wrap(self.name)
  self.min = 1750
  self.max = 1805
  return self
end

function Turbine:mainLoop()
  print("Turbine Worker set up for ", self.name)
  while self.port.getConnected() do

    local interval = 5

    -- switch the turbine on if necessary
    if not self.port.getActive() then self.port.setActive(true) end

    local speed = self.port.getRotorSpeed()

    local shouldEngage = self.port.getInductorEngaged();
    if speed < self.min  then
      shouldEngage = false
    elseif
      speed >= self.max then shouldEngage= true
    end

    -- only do a call if necessary
    if  (self.port.getInductorEngaged() ~= shouldEngage) then
      self.port.setInductorEngaged(shouldEngage)
      print ("Setting Inductor to ", shouldEngage and "ENGAGED" or "NOT ENGAGED")
    end

    -- while the coil is not engaged we need to check regularly
    if not shouldEngage then
      interval = 1
    end

    local schedId = os.startTimer(interval)
    repeat
      local event, timerId = os.pullEvent("timer")
    until timerId == schedId
  end
  print("Lost connection to turbine ", self.name)
end

function Turbine:main()
  return function () self:mainLoop() end
end
