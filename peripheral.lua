function groupPeripherals()
  local names = peripheral.getNames()
  local peripherals = {}
  for x, name in ipairs(names) do
    local type= peripheral.getType(name)
    local bt = peripherals[type]
    if not bt then
      bt = {}
      peripherals[type] = bt
    end
    table.insert(bt,name)
  end
  return peripherals;
end
