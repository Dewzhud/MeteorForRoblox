local UILib = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourUsername/YourRepo/main/UILIB.lua"))()

-- สร้างหน้าต่างหลัก
local window = UILib:CreateWindow()

-- เพิ่มปุ่ม
UILib:AddButton("Click Me", function()
    print("Button clicked!")
end)

-- เพิ่ม Toggle
UILib:AddToggle("Enable Feature", function(isToggled)
    if isToggled then
        print("Feature enabled")
    else
        print("Feature disabled")
    end
end)
