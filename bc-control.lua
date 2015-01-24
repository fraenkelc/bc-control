dofile("bc-control/Turbine.lua")
dofile("bc-control/peripheral.lua")

while (true) do
  local devices = groupPeripherals()

  local turbines ={};
  for idx, tb in ipairs(devices["BigReactors-Turbine"] or {}) do
    table.insert(turbines, Turbine(tb))
  end

  local workers = {}

  -- turbine workers
  for idx, tb in ipairs(turbines) do
    table.insert(workers, tb:main())
  end

  parallel.waitForAny(unpack(workers))
  coroutine.yield()
end
