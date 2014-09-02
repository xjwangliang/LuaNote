require 'tempobj'

local function _new()

  local t=tempobj.new(scene.createMovTar())

  t.setOverBounce(1.6)

  local fPower=1; 
  local getPower  = function()  return fPower; end 
  local setPower = function(power) fPower=power; end


  local _frameMove = t.frameMove 
  local frameMove  = function(timed)
    local ret=_frameMove(timed)
    return ret
  end


  local _deleteThis = t.deleteThis 
  local deleteThis = function()
    scene.deleteMovTar(t) 
    return _deleteThis()
  end


  t.getPower=getPower 
  t.setPower=setPower
  t.frameMove=frameMove 
  t.deleteThis=deleteThis

  return t
end

-- export
bullet  = {
  new = _new
}
