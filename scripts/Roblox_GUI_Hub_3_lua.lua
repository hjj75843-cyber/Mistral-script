local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local BUILD_ID = "d888e1b0dfae"
local REQUESTED_GAME = "Roblox"
local REQUESTED_MODE = "GUI Hub"
local PRIMARY_MODE = "gui"
local state = {fly=false,speed=false,jump=false,noclip=false,laser=false,esp=false,parry=false}
local saved = {speed=16,jumpPower=50,jumpHeight=7.2}
local connections = {}
local objects = {}
local function character() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function humanoid() return character():FindFirstChildOfClass("Humanoid") end
local function root() local c=character() return c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") end
local function head() return character():FindFirstChild("Head") or root() end
local function destroy(x) if x then pcall(function() x:Destroy() end) end end
local function disconnect(name) if connections[name] then pcall(function() connections[name]:Disconnect() end) connections[name]=nil end end
local gui = Instance.new("ScreenGui")
gui.Name = "MistralScripts_" .. BUILD_ID
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
local ok = pcall(function() gui.Parent = CoreGui end)
if not ok or not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,318,0,392)
frame.Position = UDim2.new(0.5,-159,0.5,-196)
frame.BackgroundColor3 = Color3.fromRGB(14,8,28)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0,18) c.Parent = frame
local st = Instance.new("UIStroke") st.Color = Color3.fromRGB(185,78,255) st.Thickness = 2 st.Parent = frame
local grad = Instance.new("UIGradient") grad.Color = ColorSequence.new(Color3.fromRGB(31,11,58), Color3.fromRGB(82,25,118)) grad.Rotation = 35 grad.Parent = frame
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,16,0,12)
title.Size = UDim2.new(1,-58,0,30)
title.Text = "Mistral Scripts"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame
local sub = Instance.new("TextLabel")
sub.BackgroundTransparency = 1
sub.Position = UDim2.new(0,16,0,42)
sub.Size = UDim2.new(1,-32,0,42)
sub.Text = "@MistralScript • " .. REQUESTED_GAME .. " • " .. REQUESTED_MODE
sub.Font = Enum.Font.GothamMedium
sub.TextSize = 12
sub.TextWrapped = true
sub.TextXAlignment = Enum.TextXAlignment.Left
sub.TextColor3 = Color3.fromRGB(224,194,255)
sub.Parent = frame
local close = Instance.new("TextButton")
close.Size = UDim2.new(0,32,0,32)
close.Position = UDim2.new(1,-44,0,12)
close.BackgroundColor3 = Color3.fromRGB(86,28,123)
close.Text = "×"
close.Font = Enum.Font.GothamBlack
close.TextSize = 20
close.TextColor3 = Color3.fromRGB(255,255,255)
close.Parent = frame
local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0,10) cc.Parent = close
local status = Instance.new("TextLabel")
status.BackgroundTransparency = 1
status.Position = UDim2.new(0,16,1,-34)
status.Size = UDim2.new(1,-32,0,24)
status.Text = "Готов • " .. BUILD_ID
status.Font = Enum.Font.GothamMedium
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(225,204,255)
status.Parent = frame
local list = Instance.new("ScrollingFrame")
list.Position = UDim2.new(0,16,0,92)
list.Size = UDim2.new(1,-32,1,-136)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0,0,0,0)
list.Parent = frame
local layout = Instance.new("UIListLayout") layout.Padding = UDim.new(0,8) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Parent = list
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+12) end)
local function setStatus(v) status.Text = tostring(v):sub(1,120) end
local function addButton(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,44)
    b.BackgroundColor3 = Color3.fromRGB(45,18,78)
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Text = text
    b.Parent = list
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,13) bc.Parent = b
    local bs = Instance.new("UIStroke") bs.Color = Color3.fromRGB(166,85,255) bs.Transparency = 0.25 bs.Parent = b
    b.MouseButton1Click:Connect(function() local good,err = pcall(callback) if not good then setStatus("Ошибка: "..tostring(err):sub(1,85)) end end)
end
local dragging=false local dragStart=nil local startPos=nil
frame.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true dragStart=input.Position startPos=frame.Position end end)
frame.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
UserInputService.InputChanged:Connect(function(input) if dragging and dragStart and startPos and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then local d=input.Position-dragStart frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
local flyGyro=nil local flyVelocity=nil
local function stopFly() state.fly=false local h=humanoid() if h then h.PlatformStand=false end destroy(flyGyro) destroy(flyVelocity) flyGyro=nil flyVelocity=nil end
local function toggleFly() local r=root() local h=humanoid() if not r or not h then setStatus("Персонаж не найден") return end state.fly=not state.fly if state.fly then flyGyro=Instance.new("BodyGyro") flyGyro.P=90000 flyGyro.MaxTorque=Vector3.new(900000,900000,900000) flyGyro.CFrame=r.CFrame flyGyro.Parent=r flyVelocity=Instance.new("BodyVelocity") flyVelocity.MaxForce=Vector3.new(900000,900000,900000) flyVelocity.Parent=r h.PlatformStand=true setStatus("Fly включён") else stopFly() setStatus("Fly выключен") end end
RunService.RenderStepped:Connect(function() if state.fly and flyVelocity and flyGyro then local h=humanoid() if h and Camera then local y=0 if UserInputService:IsKeyDown(Enum.KeyCode.Space) then y=y+1 end if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then y=y-1 end flyGyro.CFrame=Camera.CFrame flyVelocity.Velocity=h.MoveDirection*72+Vector3.new(0,y*72,0) end end end)
local function toggleSpeed() state.speed=not state.speed local h=humanoid() if not h then setStatus("Humanoid не найден") return end if state.speed then saved.speed=h.WalkSpeed h.WalkSpeed=64 setStatus("Speed включён") else h.WalkSpeed=saved.speed or 16 setStatus("Speed выключен") end end
local function toggleJump() state.jump=not state.jump local h=humanoid() if not h then setStatus("Humanoid не найден") return end if state.jump then saved.jumpPower=h.JumpPower saved.jumpHeight=h.JumpHeight pcall(function() h.UseJumpPower=true end) h.JumpPower=92 h.JumpHeight=18 setStatus("Jump включён") else h.JumpPower=saved.jumpPower or 50 h.JumpHeight=saved.jumpHeight or 7.2 setStatus("Jump выключен") end end
local function toggleNoclip() state.noclip=not state.noclip setStatus(state.noclip and "Noclip включён" or "Noclip выключен") end
RunService.Stepped:Connect(function() if state.noclip then for _,p in ipairs(character():GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
local espFolder=nil
local function clearEsp() destroy(espFolder) espFolder=nil end
local function toggleEsp() state.esp=not state.esp clearEsp() if state.esp then espFolder=Instance.new("Folder") espFolder.Name="MistralESP_"..BUILD_ID espFolder.Parent=gui for _,plr in ipairs(Players:GetPlayers()) do if plr~=LocalPlayer and plr.Character then local hi=Instance.new("Highlight") hi.Adornee=plr.Character hi.FillColor=Color3.fromRGB(174,72,255) hi.OutlineColor=Color3.fromRGB(255,255,255) hi.FillTransparency=.56 hi.Parent=espFolder end end setStatus("ESP включён") else setStatus("ESP выключен") end end
local laserFolder=nil local laserObjects={}
local function clearLaser() disconnect("laser") for _,o in ipairs(laserObjects) do destroy(o) end laserObjects={} destroy(laserFolder) laserFolder=nil end
local function toggleLaser() state.laser=not state.laser clearLaser() if not state.laser then setStatus("Лазеры выключены") return end local hd=head() if not hd then state.laser=false setStatus("Голова не найдена") return end laserFolder=Instance.new("Folder") laserFolder.Name="MistralLaserEyes_"..BUILD_ID laserFolder.Parent=Workspace local left=Instance.new("Attachment") left.Position=Vector3.new(-.18,.12,-.55) left.Parent=hd local right=Instance.new("Attachment") right.Position=Vector3.new(.18,.12,-.55) right.Parent=hd local part=Instance.new("Part") part.Anchored=true part.CanCollide=false part.Transparency=1 part.Size=Vector3.new(.2,.2,.2) part.Parent=laserFolder local target=Instance.new("Attachment") target.Parent=part table.insert(laserObjects,left) table.insert(laserObjects,right) table.insert(laserObjects,part) local function beam(a) local b=Instance.new("Beam") b.Attachment0=a b.Attachment1=target b.Width0=.085 b.Width1=.025 b.LightEmission=1 b.LightInfluence=0 b.FaceCamera=true b.Color=ColorSequence.new(Color3.fromRGB(255,38,132),Color3.fromRGB(164,55,255)) b.Parent=laserFolder end beam(left) beam(right) connections.laser=RunService.RenderStepped:Connect(function() if not state.laser or not part or not Camera then return end local origin=Camera.CFrame.Position local direction=Camera.CFrame.LookVector*260 local params=RaycastParams.new() params.FilterDescendantsInstances={character(),laserFolder} params.FilterType=Enum.RaycastFilterType.Blacklist local hit=Workspace:Raycast(origin,direction,params) part.CFrame=CFrame.new(hit and hit.Position or (origin+direction)) end) setStatus("Лазеры из глаз включены") end
local lastParry=0
local function fireParry() for _,o in ipairs(game:GetDescendants()) do if o:IsA("RemoteEvent") then local n=o.Name:lower() if n:find("parry") or n:find("block") or n:find("deflect") or n:find("slash") then pcall(function() o:FireServer() end) end end end end
local function toggleParry() state.parry=not state.parry setStatus(state.parry and "Auto Parry включён" or "Auto Parry выключен") end
RunService.Heartbeat:Connect(function() if state.speed then local h=humanoid() if h and h.WalkSpeed<60 then h.WalkSpeed=64 end end if state.jump then local h=humanoid() if h and h.JumpPower<85 then h.JumpPower=92 end end if state.parry and tick()-lastParry>.36 then lastParry=tick() fireParry() end end)
local function disableAll() if state.fly then stopFly() end if state.laser then state.laser=false clearLaser() end if state.speed then toggleSpeed() end if state.jump then toggleJump() end if state.esp then toggleEsp() end state.noclip=false state.parry=false setStatus("Все функции выключены") end
local function runPrimary() if PRIMARY_MODE=="fly" then toggleFly() elseif PRIMARY_MODE=="laser_eyes" then toggleLaser() elseif PRIMARY_MODE=="speed" then toggleSpeed() elseif PRIMARY_MODE=="jump" then toggleJump() elseif PRIMARY_MODE=="noclip" then toggleNoclip() elseif PRIMARY_MODE=="esp" then toggleEsp() elseif PRIMARY_MODE=="auto_parry" then toggleParry() else setStatus("Выбери функцию ниже") end end
addButton("▶ Запустить: "..REQUESTED_MODE, runPrimary)
if PRIMARY_MODE=="fly" or PRIMARY_MODE=="gui" then addButton("🚀 Fly", toggleFly) end
if PRIMARY_MODE=="laser_eyes" or PRIMARY_MODE=="gui" then addButton("👁 Лазеры из глаз", toggleLaser) end
if PRIMARY_MODE=="speed" or PRIMARY_MODE=="gui" then addButton("⚡ Speed", toggleSpeed) end
if PRIMARY_MODE=="jump" or PRIMARY_MODE=="gui" then addButton("🦘 Jump", toggleJump) end
if PRIMARY_MODE=="noclip" or PRIMARY_MODE=="gui" then addButton("🧱 Noclip", toggleNoclip) end
if PRIMARY_MODE=="esp" or PRIMARY_MODE=="gui" then addButton("👀 ESP", toggleEsp) end
if PRIMARY_MODE=="auto_parry" or PRIMARY_MODE=="gui" then addButton("🛡 Auto Parry", toggleParry) end
addButton("🧹 Выключить всё", disableAll)
close.MouseButton1Click:Connect(function() disableAll() clearEsp() clearLaser() destroy(gui) end)
LocalPlayer.CharacterAdded:Connect(function() task.wait(1) setStatus("Персонаж обновлён • "..REQUESTED_MODE) end)
setStatus("Mistral Scripts готов • "..REQUESTED_MODE)
