local reffahcs = {}

-- variables
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- services

local input = game:GetService("UserInputService")
local run = game:GetService("RunService")
local tween = game:GetService("TweenService")
local tweeninfo = TweenInfo.new

-- others
local util = {}

--
function util:DraggingEnabled(frame, parent)
    parent = parent or frame
		-- stolen from wally or kiriot, kek
		local dragging = false
		local dragInput, mousePos, framePos

		frame.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				mousePos = input.Position
				framePos = parent.Position

				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		frame.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		input.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - mousePos
				parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
			end
		end)
end

function reffahcs:Start()

    local uiElements = {
        ["MAIN"] = Instance.new("ScreenGui"),
        ["MAINFRAME"] = Instance.new("ImageLabel"),
        ["MAINTAB"] = Instance.new("ImageLabel")
    }
    
    uiElements["MAIN"].Parent = game:GetService("CoreGui")
    
    uiElements["MAINFRAME"].Parent = uiElements["MAIN"]
    uiElements["MAINFRAME"].Position = UDim2.new(0.30421313643455505, 0, 0.16625310480594635, 0)
    uiElements["MAINFRAME"].Size = UDim2.new(0, 611, 0, 540)
    uiElements["MAINFRAME"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uiElements["MAINFRAME"].BorderColor3 = Color3.fromRGB(0, 0, 0)
    uiElements["MAINFRAME"].BorderSizePixel = 0
    uiElements["MAINFRAME"].BackgroundTransparency = 1
    uiElements["MAINFRAME"].Image = "rbxassetid://16655696042"
    
    uiElements["MAINTAB"].Parent = uiElements["MAINFRAME"]
    uiElements["MAINTAB"].Position = UDim2.new(-0.012106637470424175, 0, -0.00041356970905326307, 0)
    uiElements["MAINTAB"].Size = UDim2.new(0, 167, 0, 548)
    uiElements["MAINTAB"].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    uiElements["MAINTAB"].BorderColor3 = Color3.fromRGB(0, 0, 0)
    uiElements["MAINTAB"].BackgroundTransparency = 1
    uiElements["MAINTAB"].Image = "rbxassetid://16655705318"

    util.DraggingEnabled(uiElements.MAINFRAME)

    return uiElements.MAIN

end

return reffahcs