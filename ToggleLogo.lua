local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("ImageButton")
local Corner = Instance.new("UICorner")
local Border = Instance.new("UIStroke")
local TweenService = game:GetService("TweenService")

ScreenGui.Name = "TphatHubToggle"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleButton.Name = "LogoToggle"
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 1
ToggleButton.Position = UDim2.new(0.05, 0, 0.15, 0)
ToggleButton.Size = UDim2.new(0, 60, 0, 60)
ToggleButton.Image = getcustomasset("TphatHubLogo.png")
ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)

Corner.Name = "LogoCorner"
Corner.Parent = ToggleButton
Corner.CornerRadius = UDim.new(0, 30)

Border.Name = "LogoBorder"
Border.Parent = ToggleButton
Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
Border.Color = Color3.fromRGB(0, 255, 120)
Border.Thickness = 2
Border.Transparency = 0.5
Border.LineJoinMode = Enum.LineJoinMode.Round

local Toggled = false
local tweenInfoClick = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfoRelease = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function playClickAnimation()
	local shrink = TweenService:Create(ToggleButton, tweenInfoClick, {Size = UDim2.new(0, 50, 0, 50)})
	local expand = TweenService:Create(ToggleButton, tweenInfoRelease, {Size = UDim2.new(0, 60, 0, 60)})
	
	shrink:Play()
	shrink.Completed:Connect(function()
		expand:Play()
	end)
end

ToggleButton.MouseButton1Click:Connect(function()
	Toggled = not Toggled
	playClickAnimation()
	
	if Toggled then
		ToggleButton.ImageColor3 = Color3.fromRGB(0, 255, 120)
		Border.Color = Color3.fromRGB(255, 0, 120)
	else
		ToggleButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
		Border.Color = Color3.fromRGB(0, 255, 120)
	end
end)

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = ToggleButton.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
