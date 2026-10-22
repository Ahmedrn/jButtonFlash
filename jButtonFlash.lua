-- locals and speed
local AddonName, Addon = ...

local _G = _G
local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc


local TEXTURE_OFFSET = 3

-- main
function Addon:Load()
  self.frame = CreateFrame('Frame', nil)

  -- set OnEvent handler
  self.frame:SetScript('OnEvent', function(_, ...)
      self:OnEvent(...)
    end)

  self.frame:RegisterEvent('PLAYER_LOGIN')
end

-- frame events
function Addon:OnEvent(event, ...)
  local action = self[event]

  if (action) then
    action(self, ...)
  end
end

function Addon:PLAYER_LOGIN()
  self:HookBartender()
  self:SetupButtonFlash()
  self:HookActionEvents()

  self.frame:UnregisterEvent('PLAYER_LOGIN')
  self.frame:RegisterEvent('PLAYER_ENTERING_WORLD')
end

-- Bartender4 creates the buttons of a bar when it is enabled or a profile is loaded, which can be long after login
function Addon:HookBartender()
  local bt4 = _G.Bartender4
  if (self.bt4Hooked or not bt4 or not bt4.Button or not bt4.Button.Create) then return end
  self.bt4Hooked = true
  hooksecurefunc(bt4.Button, 'Create', function()
    self:HookActionEvents()
  end)
end

function Addon:PLAYER_ENTERING_WORLD()
  self:HookBartender()
  -- action bar addons (Bartender4) may create buttons after login
  self:HookActionEvents()
end

function Addon:SetupButtonFlash()
  local frame = CreateFrame('Frame', nil)
  frame:SetFrameStrata('TOOLTIP')

  local texture = frame:CreateTexture()
  texture:SetTexture([[Interface\Cooldown\star4]])
  texture:SetAlpha(0)
  texture:SetAllPoints(frame)
  texture:SetBlendMode('ADD')
  texture:SetDrawLayer('OVERLAY', 7)

  local animation = texture:CreateAnimationGroup()

  local alpha = animation:CreateAnimation('Alpha')
  alpha:SetChange(1)
  alpha:SetDuration(0)
  alpha:SetOrder(1)

  local scale1 = animation:CreateAnimation('Scale')
  scale1:SetScale(1.5, 1.5)
  scale1:SetDuration(0)
  scale1:SetOrder(1)

  local scale2 = animation:CreateAnimation('Scale')
  scale2:SetScale(.01, .01)
  scale2:SetDuration(.3)
  scale2:SetOrder(2)

  local rotation = animation:CreateAnimation('Rotation')
  rotation:SetDegrees(90)
  rotation:SetDuration(.3)
  rotation:SetOrder(2)

  self.overlay = frame
  self.animation = animation
end

-- hooks
do
  local hooked = {}

  local function Button_PreClick(button)
    Addon:AnimateButton(button)
  end

  function Addon:HookButton(button)
    if (button and not hooked[button] and button.HookScript) then
      hooked[button] = true
      button:HookScript('PreClick', Button_PreClick)
    end
  end

  function Addon:HookActionEvents()
    local prefixes = {
      'ActionButton', 'MultiBarBottomLeftButton', 'MultiBarBottomRightButton',
      'MultiBarRightButton', 'MultiBarLeftButton', 'BonusActionButton', 'BT4Button',
      'BT4PetButton', 'BT4StanceButton',
    }
    -- Bartender4 only creates the buttons of the bars that are enabled, so there can be gaps
    -- (bar 2 off: BT4Button13-24 do not exist, BT4Button25 does): never stop at the first missing one.
    for _, prefix in ipairs(prefixes) do
      for i = 1, 120 do
        local button = _G[prefix..i]
        if (button) then
          self:HookButton(button)
        end
      end
    end
  end
end

function Addon:AnimateButton(button)
  if (not button:IsVisible()) then return end

  self.overlay:ClearAllPoints()
  self.overlay:SetPoint('TOPLEFT', button, 'TOPLEFT', -TEXTURE_OFFSET, TEXTURE_OFFSET)
  self.overlay:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', TEXTURE_OFFSET, -TEXTURE_OFFSET)

  self.animation:Stop()
  self.animation:Play()
end

-- begin
Addon:Load()
