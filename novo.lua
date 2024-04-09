------------------------
-- A credit for Reffachs
------------------------

-- Variables

local PLAYER = game.Players.LocalPlayer
local MOUSE  = PLAYER:GetMouse()

-- Services

local INPUT     = game:GetService("UserInputService")
local RUN       = game:GetService("RunService")
local TWEEN     = game:GetService("TweenService")
local TWEENINFO = TweenInfo.new

-- Functions

function DraggingEnabled(frame, parent)
	
	parent = parent or frame
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

	INPUT.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			TWEEN:Create(parent, TWEENINFO(.3), {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}):Play()
		end
	end)

end

function setDeselected(content_tabs,parent,marker)

	for i,v in pairs(content_tabs:GetChildren()) do
		if v:IsA("Frame") then
			for x,c in pairs(v:GetChildren()) do
				if c.Parent == parent then
				else
					if c:IsA("TextButton") then
						TWEEN:Create(c, TWEENINFO(.1), {TextSize = 20}):Play()
						c.TextColor3 = Color3.fromRGB(165, 165, 165)
					end
					if c:IsA("ImageLabel") then
						TWEEN:Create(c, TWEENINFO(.5), {ImageTransparency = 0, Size = UDim2.new(0, 0, 0 , marker.Size.Y.Offset)}):Play()
					end
				end
			end
		end
	end

end

function setSelected(content_tabs,parent,marker)

	setDeselected(content_tabs,parent,marker)
	for i,v in pairs(content_tabs:GetChildren()) do
		if v:IsA("Frame") then
			for x,c in pairs(v:GetChildren()) do
				if c.Parent == parent then
					if c:IsA("TextButton") then
						c.TextColor3 = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	end

end

function Show(tab,obj)
	for _,v in pairs(tab) do
		if v == obj then
			v.Visible = true
		end
		if v ~= obj then
			v.Visible = false
		end
	end
end

-- A Instance UI Elements Manager

local InstanceManager = {}
local UIManager       = {}

UIManager.__index = UIManager

function InstanceManager:Create(instance,properties,children)

	local object = Instance.new(instance)
	for i, v in pairs(properties or {}) do
		object[i] = v
	end
	for i, module in pairs(children or {}) do
		module.Parent = object
	end
	return object

end

-- Starting the UI

function UIManager.new()
	
	local self = setmetatable({}, UIManager)
	self.Tabs = {}
	self.SelectedTab = nil
	self.MainFrame = nil
	
	local container = InstanceManager:Create("ScreenGui", {
		Name   = "uimanager",
		Parent = game:GetService("CoreGui")
	},{
		InstanceManager:Create("ImageLabel", {
			Position = UDim2.new(0.21574704349040985, 0, 0.14392060041427612, 0),
			Size = UDim2.new(0, 732, 0, 612),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Color3.fromRGB(5, 5, 255),
			BorderColor3 = Color3.fromRGB(229, 228, 228),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Image = "rbxassetid://16751676676",
			Name = "main"
		}, {
			InstanceManager:Create("TextLabel", {
				
				Position = UDim2.new(0.7404889464378357, 0, 0.013071895577013493, 0),
				Size = UDim2.new(0, 200, 0, 50),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				FontFace = Font.new("rbxasset://fonts/families/PressStart2P.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 25,
				Text = "REFFAHCS"
				
			}),
			InstanceManager:Create("Frame", {

				Name   = "container_tabs",
				Position = UDim2.new(0.045442841947078705, 0, 0.02450980432331562, 0),
				Size = UDim2.new(0, 551, 0, 70),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1

			}, {
				
				InstanceManager:Create("UIListLayout", {

					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder

				})
				
			})
			
		})
	})
	
	DraggingEnabled(container.main)
	
	self.MainFrame = container.main
	self.MainGui = container

	return self
	
end

function UIManager:addTab(tabData)

	local tab = {
		text = tabData.text,
		tabs = {}  -- This will store tabs for this page
	}
	--table.insert(self.Tabs, tab)
	
	local currentTab = InstanceManager:Create("Frame", {
		Name = tab.text,
		Parent = self.MainFrame.container_tabs,
		Size = UDim2.new(0, 100, 0, 70),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}, {
		
		InstanceManager:Create("TextButton", {

			Position = UDim2.new(0, 0, 0.12857143580913544, 0),
			Size = UDim2.new(0, 92, 0, 34),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Font = Enum.Font.Sarpanch,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 20,
			Text = tab.text
			

		}),
		InstanceManager:Create("ImageLabel", {

			Name = "marker",
			Position = UDim2.new(0.08899963647127151, 0, 0.5268571972846985, 0),
			Size = UDim2.new(0, 0, 0, 13),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			ImageColor3 = Color3.fromRGB(53, 193, 236),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Image = "rbxassetid://16751613112",
			ImageTransparency = 1,
			ScaleType = Enum.ScaleType.Fit

		})
	})
	
	--table.insert(self.Tabs,currentTab.TextButton)
	print(self.Tabs)
	
	local currentTabContainer = InstanceManager:Create("ScrollingFrame", {
		Name = tab.text,
		Parent = self.MainFrame,
		Position = UDim2.new(0.1395684778690338, 0, 0.1062091514468193, 0),
		Size = UDim2.new(0, 639, 0, 533),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		Active = true,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 0,
		Visible = false,
		BackgroundTransparency = 1,
		ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
		ScrollBarImageTransparency = 1

	}, {
		
		InstanceManager:Create("UIListLayout", {

			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder

		})
		
	})
	
	table.insert(self.Tabs,currentTabContainer)
	print(self.Tabs)
	
	currentTab.TextButton.MouseButton1Click:Connect(function()
		Show(self.Tabs,currentTabContainer)
		--currentTabContainer.Visible = true
		--currentTab.TextButton.FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
		--TWEEN:Create(currentTab.TextButton, TWEENINFO(.1), {TextSize = 22}):Play()
		--TWEEN:Create(currentTab.marker, TWEENINFO(.5), {ImageTransparency = 0, Size = UDim2.new(0,40, 0 , currentTab.marker.Size.Y.Offset)}):Play()
		--setSelected(self.MainFrame.container_tabs, currentTab, currentTab.marker)
	end)
	
	function tab:addSection(sectionData)
		
		local section = {
			text = sectionData.text,
		}
		table.insert(self.tabs, section)

		local sectionLabel = InstanceManager:Create("Frame", {
			Name = "section_" .. sectionData.text,
			Parent = currentTabContainer,
			Position = UDim2.new(0.1671842634677887, 0, 0.42359769344329834, 0),
			Size = UDim2.new(0, 643, 0, 286),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Visible = true
		}, {
		
			InstanceManager:Create("Frame", {
				
				Name = "tab_content",
				Position = UDim2.new(0.0777604952454567, 0, 0.28571435809135437, 0),
				Size = UDim2.new(0, 564, 0, 206),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
			
			}, {
				
				InstanceManager:Create("UIListLayout", {

					SortOrder = Enum.SortOrder.LayoutOrder

				})
				
			}),
			InstanceManager:Create("TextLabel", {

				FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				Position = UDim2.new(0.015927189961075783, 0, 0.0476190485060215, 0),
				Size = UDim2.new(0, 200, 0, 50),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 30,
				Text = sectionData.text,
				TextXAlignment = Enum.TextXAlignment.Left,

			})
			
		})
		
		-- Sections Objects
		
		function section:addToggle(sectionData)
			
			local toggle = {
				text = sectionData.text,
				info = sectionData.info,
				icon = sectionData.icon,
				value = sectionData.value or false,
				callback = sectionData.callback
			}
			
			local toggle_object = InstanceManager:Create("Frame", {
				Name = sectionData.text,
				Parent = sectionLabel.tab_content,
				Size = UDim2.new(0, 564, 0, 61),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {
				
				InstanceManager:Create("ImageLabel", {

					Position = UDim2.new(0.060283686965703964, 0, 0.21311475336551666, 0),
					Size = UDim2.new(0, 35, 0, 35),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = sectionData.icon
					--"rbxassetid://16662568821"

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.1147540956735611, 0),
					Size = UDim2.new(0, 200, 0, 27),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					Text = sectionData.text,
					TextXAlignment = Enum.TextXAlignment.Left,

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.32786884903907776, 0),
					Size = UDim2.new(0, 200, 0, 34),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(124, 124, 124),
					TextSize = 15,
					Text = sectionData.info,
					TextXAlignment = Enum.TextXAlignment.Left

				}),
				InstanceManager:Create("TextButton", {

					Name = "teste",
					Position = UDim2.new(0.45921987295150757, 0, 0.31147539615631104, 0),
					Size = UDim2.new(0, 24, 0, 23),
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.800000011920929,
					Font = Enum.Font.SourceSans,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					Text = ""

				})
				
			})
			
			toggle_object.teste.MouseButton1Click:Connect(function()
				return toggle.callback()
			end)
			
			return toggle
			
		end
		
		function section:addSlider(sectionData)

			local slider = {
				text = sectionData.text,
				info = sectionData.info,
				icon = sectionData.icon,
				min = sectionData.min,
				max = sectionData.max,
				value = sectionData.value or 0,
				--callback = sectionData.callback
			}

			local slider_object = InstanceManager:Create("Frame", {
				Name = sectionData.text,
				Parent = sectionLabel.tab_content,
				Size = UDim2.new(0, 564, 0, 61),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {

				InstanceManager:Create("ImageLabel", {

					Position = UDim2.new(0.060283686965703964, 0, 0.21311475336551666, 0),
					Size = UDim2.new(0, 35, 0, 35),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = sectionData.icon
					--"rbxassetid://16662568821"

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.1147540956735611, 0),
					Size = UDim2.new(0, 200, 0, 27),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					Text = sectionData.text,
					TextXAlignment = Enum.TextXAlignment.Left,

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.32786884903907776, 0),
					Size = UDim2.new(0, 200, 0, 34),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(124, 124, 124),
					TextSize = 15,
					Text = sectionData.info,
					TextXAlignment = Enum.TextXAlignment.Left

				}),
				InstanceManager:Create("Frame", {

					Name = "bar",
					Position = UDim2.new(0.45899999141693115, 0, 0.27900001406669617, 0),
					Size = UDim2.new(0, 162, 0, 25),
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.800000011920929

				}, {
					
					InstanceManager:Create("TextLabel", {
						
						Name = "value",
						Size = UDim2.new(0, 162, 0, 25),
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 0.9599999785423279,
						Font = Enum.Font.Sarpanch,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						Text = "0"

					}),
					InstanceManager:Create("TextButton", {

						Name = "Trigger",
						Size = UDim2.new(0, 162, 0, 25),
						BackgroundColor3 = Color3.fromRGB(207, 207, 207),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						Font = Enum.Font.SourceSans,
						TextColor3 = Color3.fromRGB(0, 0, 0),
						TextSize = 14,
						Text = ""

					}),
					InstanceManager:Create("Frame", {

						Name = "Fill",
						Size = UDim2.new(0, 0, 0, 25),
						BackgroundColor3 = Color3.fromRGB(207, 207, 207),
						BorderColor3 = Color3.fromRGB(0, 0, 0),
						BorderSizePixel = 0,
						BackgroundTransparency = 0.800000011920929

					})
					
				})

			})
			
				local player = game.Players.LocalPlayer
				local mouse = player:GetMouse()
				local slider = slider_object.bar
				local fill = slider_object.bar.Fill
				local trigger = slider_object.bar.Trigger
				local valueText = slider_object.bar.value
				local tween = game:GetService("TweenService")
				local tweeninfo = TweenInfo.new

				local minValue = sectionData.min -- Minimum value of the slider
				local maxValue = sectionData.max -- Maximum value of the slider
				local currentValue = sectionData.value -- Initial value of the slider

				local sliderStatus = false

				local function UpdateSlider()
					if sliderStatus then
						local mousePos = trigger.AbsolutePosition.X + math.clamp(mouse.X - trigger.AbsolutePosition.X, 0, trigger.AbsoluteSize.X)
						local out = math.clamp((mousePos - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
						tween:Create(fill, tweeninfo(.2), {Size = UDim2.new(out, 0, 1, 0)}):Play()
						local currentValue = minValue + (maxValue - minValue) * out

						-- Update the value text
						valueText.Text = tostring(math.floor(currentValue))
					end
				end

				local function ActivateSlider()
					sliderStatus = true
					while sliderStatus do
						UpdateSlider()
						task.wait()
					end
					print("Slider activated")
				end

				local function DeactivateSlider()
					sliderStatus = false
					print("Slider deactivated")
				end

				trigger.MouseButton1Down:Connect(function()
					ActivateSlider()
				end)

				game:GetService("UserInputService").InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and sliderStatus == true then
						DeactivateSlider()
					end
				end)

			return slider

		end
		
		function section:addButton(sectionData)

			local button = {
				text = sectionData.text,
				info = sectionData.info,
				icon = sectionData.icon,
				callback = sectionData.callback
			}

			local button_object = InstanceManager:Create("Frame", {
				Name = sectionData.text,
				Parent = sectionLabel.tab_content,
				Size = UDim2.new(0, 564, 0, 61),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {

				InstanceManager:Create("ImageLabel", {

					Position = UDim2.new(0.060283686965703964, 0, 0.21311475336551666, 0),
					Size = UDim2.new(0, 35, 0, 35),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = sectionData.icon
					--"rbxassetid://16662568821"

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.1147540956735611, 0),
					Size = UDim2.new(0, 200, 0, 27),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					Text = sectionData.text,
					TextXAlignment = Enum.TextXAlignment.Left,

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.32786884903907776, 0),
					Size = UDim2.new(0, 200, 0, 34),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(124, 124, 124),
					TextSize = 15,
					Text = sectionData.info,
					TextXAlignment = Enum.TextXAlignment.Left

				}),
				InstanceManager:Create("TextButton", {

					Position = UDim2.new(0.45921987295150757, 0, 0.2950819730758667, 0),
					Size = UDim2.new(0, 162, 0, 25),
					BackgroundColor3 = Color3.fromRGB(207, 207, 207),
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.800000011920929,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					Text = "Click Me"

				})

			})

			return button

		end
		
		function section:addText(sectionData)

			local text = {
				text = sectionData.text,
				info = sectionData.info,
			}

			local text_object = InstanceManager:Create("Frame", {
				Name = sectionData.text,
				Parent = sectionLabel.tab_content,
				Size = UDim2.new(0, 564, 0, 61),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {

				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.07801418751478195, 0, 0.2950819730758667, 0),
					Size = UDim2.new(0, 200, 0, 34),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					BackgroundTransparency = 1,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(124, 124, 124),
					TextSize = 15,
					Text = sectionData.info,
					TextXAlignment = Enum.TextXAlignment.Left,

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.07801418751478195, 0, 0.08196721225976944, 0),
					Size = UDim2.new(0, 200, 0, 27),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					ZIndex = 2,
					BackgroundTransparency = 1,
					FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					Text = sectionData.text,
					TextXAlignment = Enum.TextXAlignment.Left

				}),
				InstanceManager:Create("Frame", {

					Position = UDim2.new(0.060283686965703964, 0, 0.06557376682758331, 0),
					Size = UDim2.new(0, 387, 0, 50),
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.699999988079071

				})

			})

			return text

		end
		
		function section:addDropdown(sectionData)

			local dropdown = {
				text = sectionData.text,
				info = sectionData.info,
				icon = sectionData.icon,
				value = sectionData.value or "",
				list = sectionData.list or {}
			}
			
			local dropdown_object = InstanceManager:Create("Frame", {
				Name = sectionData.text,
				Parent = sectionLabel.tab_content,
				Size = UDim2.new(0, 564, 0, 61),
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			}, {

				InstanceManager:Create("ImageLabel", {

					Position = UDim2.new(0.060283686965703964, 0, 0.21311475336551666, 0),
					Size = UDim2.new(0, 35, 0, 35),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Image = sectionData.icon
					--"rbxassetid://16662568821"

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.1147540956735611, 0),
					Size = UDim2.new(0, 200, 0, 27),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					FontFace = Font.new("rbxasset://fonts/families/Sarpanch.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 20,
					Text = sectionData.text,
					TextXAlignment = Enum.TextXAlignment.Left,

				}),
				InstanceManager:Create("TextLabel", {

					Position = UDim2.new(0.152482271194458, 0, 0.32786884903907776, 0),
					Size = UDim2.new(0, 200, 0, 34),
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderColor3 = Color3.fromRGB(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(124, 124, 124),
					TextSize = 15,
					Text = sectionData.info,
					TextXAlignment = Enum.TextXAlignment.Left

				}),
				InstanceManager:Create("TextButton", {

					Position = UDim2.new(0.45921987295150757, 0, 0.2950819730758667, 0),
					Size = UDim2.new(0, 162, 0, 25),
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.800000011920929,
					Font = Enum.Font.Sarpanch,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					TextSize = 14,
					Text = sectionData.value

				}),
				InstanceManager:Create("ScrollingFrame", {

					Name = "list_frame",
					Position = UDim2.new(0.45921987295150757, 0, 0.4846394956111908, 0),
					Size = UDim2.new(0, 162, 0, 0),
					BackgroundColor3 = Color3.fromRGB(23, 23, 23),
					Active = true,
					BorderColor3 = Color3.fromRGB(255, 255, 255),
					Visible = false,
					BackgroundTransparency = 0.800000011920929,
					ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)

				})

			})
			
			local function CreateList()
				for i,v in pairs(dropdown.list) do
					InstanceManager:Create("TextButton", {
						Parent = dropdown_object.list_frame,
						Position = UDim2.new(0.45921987295150757, 0, 0.2950819730758667, 0),
						Size = UDim2.new(0, 162, 0, 25),
						BackgroundColor3 = Color3.fromRGB(23, 23, 23),
						BorderColor3 = Color3.fromRGB(255, 255, 255),
						BackgroundTransparency = 0.800000011920929,
						Font = Enum.Font.Sarpanch,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						TextSize = 14,
						Text = v
					})
				end
			end
			
			local list_content = dropdown_object.Parent.Parent
			print(list_content)
			
			CreateList()
			
			return dropdown

		end

		return section
		
	end
	
	return tab

end

return UIManager