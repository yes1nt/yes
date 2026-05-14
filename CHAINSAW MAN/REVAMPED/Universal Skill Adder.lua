Players = game:GetService("Players")
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Backpack = LocalPlayer:WaitForChild("Backpack")
RunService = game:GetService("RunService")

loadstring(game:HttpGet("https://raw.githubusercontent.com/yes1nt/yes/refs/heads/main/CameraFix"))()

function PlayAnimation(ID, Speed, Starttime, Stoptime)
    PlayedAnimation = true
    local Speed = Speed or 1
    local Starttime = Starttime or 0
    local Stoptime = Stoptime or false
    local animation = Instance.new("Animation")
    animation.AnimationId = ID
    local track = Character.Humanoid.Animator:LoadAnimation(animation)
    track:Play()
    track.TimePosition = Starttime
    track:AdjustSpeed(Speed)
    if Stoptime then
        task.spawn(function()
            task.wait(Stoptime)
            track:Stop()
        end)
    end
    PlayedAnimation = false
    return track
end

function StopAnimation(ID)
    for _, track in pairs(Character.Humanoid:FindFirstChildOfClass("Animator"):GetPlayingAnimationTracks()) do
        if track.Animation.AnimationId == ID then
            track:Stop()
        end
    end
end

function StopAllAnimation(Exemption)
    for _, animationTrack in pairs(Character.Humanoid:GetPlayingAnimationTracks()) do
        if animationTrack.Animation.AnimationId ~= Exemption then
            animationTrack:Stop()
        end
    end
end

function PlaySound(ID, Speed, Volume, Position, Start)
    local sound = Instance.new("Sound")
    sound.SoundId = ID
    sound.PlaybackSpeed = Speed or 1
    sound.Volume = Volume or 1
    local pos = Instance.new("Part")
    pos.Anchored = true
    pos.CanCollide = false
    pos.Transparency = 1
    local Parent = workspace
    if Position then
        pos.CFrame = Position
        pos.Parent = workspace
        Parent = pos
    end
    sound.TimePosition = Start or 0
    sound.Parent = Parent
    sound:Play()
    Character.Humanoid.Died:Once(function()
        sound:Stop()
    end)
    sound.Ended:Connect(function()
        sound:Destroy()
        pos:Destroy()
    end)
    return sound
end

function GetClosestPlayer()
    local MinimumDistance = math.huge
    local Target = nil
    for _, v in next, game.Workspace.Live:GetChildren() do
        if v.Name ~= LocalPlayer.Name then
            if v:FindFirstChild("HumanoidRootPart") ~= nil then
                if v:FindFirstChild("Humanoid") ~= nil and v:FindFirstChild("Humanoid").Health > 0 then
                    local Distance = (v.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if Distance < MinimumDistance then
                        MinimumDistance = Distance
                        Target = v
                    end
                end
            end
        end
    end
    return Target
end

function Skill(SkillName, callback, Cooldown, ToggleCooldown)
    local Skill = Instance.new("Tool")
    Skill.Name = SkillName
    Skill.RequiresHandle = false
    Skill.Parent = Backpack
    Skill:SetAttribute("Cooldown", Cooldown)
    local SkillHotbar
    local State
    Cooldown = Cooldown or 0
    local CooldownGui = LocalPlayer.PlayerGui.Hotbar.Backpack.LocalScript.Cooldown:Clone()
    if Backpack:GetAttribute("CustomSkills") == nil then
        Backpack:SetAttribute("CustomSkills", -1)
    end
    Backpack:SetAttribute("CustomSkills", Backpack:GetAttribute("CustomSkills") + 1)
    for HotbarNum = 1, 13 do
        local HotbarToolName = LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(HotbarNum)].Base.ToolName.Text
        if HotbarToolName == Skill.Name then
            SkillHotbar = LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(HotbarNum)].Base
            Skill.Name = Skill.Name.."ID:"..tostring(Backpack:GetAttribute("CustomSkills"))
            LocalPlayer.PlayerGui.Hotbar.Backpack.Hotbar[tostring(HotbarNum)].Base.ToolName.Text = HotbarToolName
        end
    end
    CooldownGui.Parent = SkillHotbar.Parent
    CooldownGui.Size = UDim2.new(1, 0, 0, 0)
    if Backpack:GetAttribute("CustomSkills") == nil then
        Backpack:SetAttribute("CustomSkills", -1)
    end
    Backpack:SetAttribute("CustomSkills", Backpack:GetAttribute("CustomSkills") + 1)
    local SkillFunction = SkillHotbar.Activated:Connect(function()
        if not IPlacedThisForSpacing then
            SkillHotbar.Overlay.Visible = false
            if Cooldown ~= 1234 and CooldownGui.Size == UDim2.new(1, 0, 0, 0) then
                CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                local CooldownAnim = game:GetService("TweenService"):Create(CooldownGui, TweenInfo.new(Cooldown, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0),
                }):Play()
                callback()
            elseif Cooldown == 1234 then
                if not State and CooldownGui.Size == UDim2.new(1, 0, 0, 0) then
                    State = true
                    CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                    callback()
                elseif State and CooldownGui.Size == UDim2.new(1, 0, -1, 0) then
                    State = false
                    ToggleCooldown = ToggleCooldown or 0.2
                    CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                    local CooldownAnim = game:GetService("TweenService"):Create(CooldownGui, TweenInfo.new(ToggleCooldown, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    }):Play()
                    callback()
                end
            end
        end
    end)
    local function IntToKey(int)
        local keys = {Enum.KeyCode.Zero, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine}
        return keys[int + 1]
    end
    local SkillFunction2 = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == IntToKey(tostring(SkillHotbar.Parent))then
            SkillHotbar.Overlay.Visible = false
            if Cooldown ~= 1234 and CooldownGui.Size == UDim2.new(1, 0, 0, 0) then
                CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                local CooldownAnim = game:GetService("TweenService"):Create(CooldownGui, TweenInfo.new(Cooldown, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0),
                }):Play()
                callback()
            elseif Cooldown == 1234 then
                if not State and CooldownGui.Size == UDim2.new(1, 0, 0, 0) then
                    State = true
                    CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                    callback()
                elseif State and CooldownGui.Size == UDim2.new(1, 0, -1, 0) then
                    State = false
                    ToggleCooldown = ToggleCooldown or 0.2
                    CooldownGui.Size = UDim2.new(1, 0, -1, 0)
                    local CooldownAnim = game:GetService("TweenService"):Create(CooldownGui, TweenInfo.new(ToggleCooldown, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0),
                    }):Play()
                    callback()
                end
            end
        end
    end)
    local SkillDelete = Skill.AncestryChanged:Connect(function(child, parent)
        if parent == nil then
            SkillFunction:Disconnect()
            SkillFunction2:Disconnect()
            PlayerDied:Disconnect()
        elseif parent == workspace.Live:FindFirstChild(LocalPlayer.Name) then
            task.wait()
            Skill.Parent = Backpack
        end
    end)
    local PlayerDied = Character.Humanoid.Died:Once(function()
        SkillFunction:Disconnect()
        SkillFunction2:Disconnect()
        SkillDelete:Disconnect()
    end)
    return Skill
end

function UnfreezeCam()
    while FixingCamera do
        task.wait()
    end
    game.Workspace.CurrentCamera.CameraSubject = Character.Humanoid
end

function FreezeCam(cFrame)
    while FixingCamera do
        task.wait()
    end
    local TempObj = Instance.new("Part")
    TempObj.Parent = workspace
    TempObj.CFrame = cFrame or Character.Head.CFrame
    game.Workspace.CurrentCamera.CameraSubject = TempObj
    TempObj:Destroy()
end
        
function CubicleParticle(cframe, color, size, transparency, brightness, typeIndex, lifespan)
    local types = {"Spin", "Orbital", "Float", "Fall", "Freeze"}
    local particleType = types[typeIndex]
    local cubicle = Instance.new("Part")
    cubicle.Anchored = true
    cubicle.Material = Enum.Material.Neon
    cubicle.CanCollide = false
    cubicle.CFrame = cframe * CFrame.Angles(math.random(0, 100), math.random(0, 100), math.random(0, 100))
    cubicle.Color = color
    cubicle.Size = Vector3.new(size, size, size)
    cubicle.Transparency = transparency
    cubicle.Parent = workspace
    local light = Instance.new("PointLight")
    light.Brightness = brightness
    light.Color = color
    light.Range = size * 5
    light.Parent = cubicle
    local spinning = true
    task.spawn(function()
        local randoma, randomb, randomc = size/100, size/100, size/100
        local spinloop = 0
        task.spawn(function()
            pcall(function()
                while spinning do
                    for i = 1, 20 do
                        cubicle.CFrame = cubicle.CFrame * CFrame.Angles(randoma, randomb, randomc)
                        task.wait()
                    end
                    randoma = (math.random(1, 2) == 1 and size / 100 or -1 * size / 50)
                    randomb = (math.random(1, 2) == 1 and size / 100 or -1 * size / 50)
                    randomc = (math.random(1, 2) == 1 and size / 100 or -1 * size / 50)
                end
            end)
        end)
        if particleType == "Spin" then
            -- Nothing
        elseif particleType == "Orbital" then
            task.spawn(function()
                pcall(function()
                    local angle = 0
                    while task.wait() do
                        angle = angle + math.rad(5)
                        local x = size * 3 * math.cos(angle)
                        local z = size * 3 * math.sin(angle)
                        cubicle.Position = cframe.Position + Vector3.new(x, 0, z)
                    end
                end)
            end)
        elseif particleType == "Float" then
            task.spawn(function()
                pcall(function()
                    while task.wait() do
                        cubicle.Position = cubicle.Position + Vector3.new(0, size/20, 0)
                    end
                end)
            end)
        elseif particleType == "Fall" then
            task.spawn(function()
                pcall(function()
                    while task.wait() do
                        cubicle.Position = cubicle.Position - Vector3.new(0, size/20, 0)
                    end
                end)
            end)
        elseif particleType == "Freeze" then
            spinning = false
            cubicle.CFrame = cframe
        end
    end)
    if lifespan > 0.2 then
        task.spawn(function()
            task.wait(lifespan - 0.2)
            cubicle.Size = Vector3.new(size, size, size); game:GetService("TweenService"):Create(cubicle, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
        end)
    else
        cubicle.Size = Vector3.new(size, size, size); game:GetService("TweenService"):Create(cubicle, TweenInfo.new(lifespan, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {Size = Vector3.new(0.1, 0.1, 0.1)}):Play()
    end
    task.spawn(function()
        task.wait(lifespan)
        cubicle:Destroy()
        cubicle = nil
        light:Destroy()
        light = nil
    end)
    return cubicle
end

function ChangePos(Part, Position)
    Part.CFrame = Part.CFrame - Part.CFrame.Position + Vector3.new(Position.X, Position.Y, Position.Z)
end
























































function MakePhantomBlinkSkill()
    PhantomBlinkSkill = Skill("Phantom Blink", function()
        if not Character:FindFirstChild("Trash Can") then
        PlaySound("rbxassetid://5066021887")
        PlayAnimation("rbxassetid://15957361339", 1, 0, 1)
        if Character.Humanoid.MoveDirection.Magnitude == 0 then
            if not BackTP then
                local BlinkTarget = Character.HumanoidRootPart
                if GetClosestPlayer() then
                    BlinkTarget = GetClosestPlayer().HumanoidRootPart
                end
                local BlinkTimer = os.clock()
                while (os.clock() - BlinkTimer) < 0.3 do
                    local TransmissionTween = game:GetService("TweenService"):Create(Character.HumanoidRootPart, TweenInfo.new(0.3 - (os.clock() - BlinkTimer)), {CFrame = CFrame.new(0,0,0) + BlinkTarget.Position + BlinkTarget.Parent.Humanoid.MoveDirection * 5})
                    TransmissionTween:Play()
                    task.wait()
                    TransmissionTween:Cancel()
                end
                Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            else
                StopAnimation("rbxassetid://15957361339")
                local BlinkTarget = Character.HumanoidRootPart.CFrame - Character.HumanoidRootPart.CFrame.LookVector * 25
                game:GetService("TweenService"):Create(Character.HumanoidRootPart, TweenInfo.new(0.3), {CFrame = BlinkTarget}):Play()
                task.wait(0.3)
                Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        else
            local BlinkTarget = Character.HumanoidRootPart.CFrame + Character.Humanoid.MoveDirection * 50
            game:GetService("TweenService"):Create(Character.HumanoidRootPart, TweenInfo.new(0.3), {CFrame = BlinkTarget}):Play()
            task.wait(0.3)
            Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        end
    end, 0.1)
end

function MakeVibralShiftSkill()
    local HeadOffset = Character.Head.Position - Character.HumanoidRootPart.Position
    Invisible = false
    VibralShiftSkill = Skill("Vibral Shift", function()
        if Invisible then
            Invisible = false
        else
            Invisible = true
        end
        local function LoopAnim()
            if Invisible then
                StopAllAnimation()
                -- local Anim = PlayAnimation("rbxassetid://105616370132258", 0, 6)
                local Anim = PlayAnimation("rbxassetid://119169968232874", 0, 0, 5)
                Anim.Stopped:Once(function()
                    if Invisible then
                        task.wait()
                        LoopAnim()
                    end
                end)
            end
        end
        if Invisible then
            LoopAnim()
            local AnimStopper = Character.Humanoid.Animator.AnimationPlayed:Connect(function(AnimationTrack)
                local AnimationID = AnimationTrack.Animation.AnimationId
                -- if AnimationID ~= "rbxassetid://105616370132258" and Invisible then
                if AnimationID ~= "rbxassetid://119169968232874" and Invisible then
                    StopAnimation(AnimationID)
                end
            end)
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    -- v.Massless = true
                    if v.Name ~= "Trash Can" then
                        v:SetAttribute("OldTransparency", v.Transparency)
                        v.Transparency = 1
                    end
                end
            end
            local MassModifier = Character.DescendantAdded:Connect(function(v)
                if v:IsA("BasePart") then
                    -- v.Massless = true
                    if v.Name ~= "Trash Can" then
                        v:SetAttribute("OldTransparency", v.Transparency)
                        v.Transparency = 1
                    end
                end
            end)
            while task.wait() and Invisible do
                local CameraLookVector = workspace.CurrentCamera.CFrame.LookVector
                local Front = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit * 100
                if not UsingTrashcanSkill then
                    FreezeCam(Character.HumanoidRootPart.CFrame + HeadOffset)
                end
                Character.HumanoidRootPart.CFrame = CFrame.lookAt(Character.HumanoidRootPart.Position, Character.HumanoidRootPart.Position + Front) + Character.Humanoid.MoveDirection * 3
                CubicleParticle(Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-20, 20)/5, math.random(-20, 40)/5, math.random(-20, 20)/5), Color3.fromRGB(50, 0, math.random(100, 130)), math.random(100, 200)/120, 0.7, 1, 1, 1)
            end
            AnimStopper:Disconnect()
            -- StopAnimation("rbxassetid://105616370132258")
            StopAnimation("rbxassetid://119169968232874")
            task.spawn(function()
                for i = 1, 50 do
                    local CameraLookVector = workspace.CurrentCamera.CFrame.LookVector
                    local Front = Vector3.new(CameraLookVector.X, 0, CameraLookVector.Z).Unit * 100
                    if not UsingTrashcanSkill then
                        FreezeCam(Character.HumanoidRootPart.CFrame + HeadOffset)
                    end
                    Character.HumanoidRootPart.CFrame = CFrame.lookAt(Character.HumanoidRootPart.Position, Character.HumanoidRootPart.Position + Front)
                    if Invisible then
                        break
                    end
                    task.wait()
                end
                UnfreezeCam()
            end)
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Transparency = v:GetAttribute("OldTransparency") or v.Transparency
                    v:SetAttribute("OldTransparency", nil)
                end
            end
            local start = tick()
            repeat task.wait(0.5) until tick() - start < 10 or Invisible
            if not Invisible then
                MassModifier:Disconnect()
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        -- v.Massless = false
                    end
                end
            end
        end
    end, 1234)
end

function MakeDimensionDrift()
    local Overworld = CFrame.new(131.97, 440.76, 24.43)
    local Heaven = CFrame.new(1074, 410, 22985)
    local Box = CFrame.new(-77.87, 60, 20354.31)
    local Sphere = CFrame.new(1058.87, 135, 23009.31)
    local Options = {Overworld, Heaven, Box, Sphere}
    local Option = 1
    DimensionDriftSkill = Skill("Dimension Drift", function()
        Option = Option + 1
        if Option > 4 then
            Option =  1
        end
        PlaySound("rbxassetid://5066021887")
        PlayAnimation("rbxassetid://15957361339", 0.5, 0, 0.5)
        ChangePos(Character.HumanoidRootPart, Options[Option])
    end, 0.1)
end

MakePhantomBlinkSkill()
MakeVibralShiftSkill()
MakeDimensionDrift()
