
return function()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    local gui = Instance.new("ScreenGui")
    gui.Name = "EclipseUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Example frame placeholder (custom UI elements go here)
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 200, 0, 100)
    frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    gui.Parent = Player:WaitForChild("PlayerGui")
end
