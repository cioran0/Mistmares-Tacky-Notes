local TN = {
	Event = {},
	Visible = {
	pad = true,
	UI = true,
	},
	note = {}, 
}

local x, y, i = 0, 0, true
TN.note.textword = ""

local function WelcomeMessage()
	print ("Welcome to Mistmare's Tacky Notes! Right-click the stack to begin")
	print ("Left-click moves the pad and notes!")
	print ("Right Click the pad to bring up a new note")
	print ("Right Click a note to delete it")
	print ("Type /TN help for more")
end

--FRAME CLICK/DRAG RCLICK--
--Parts Borrowed Liberally from elsewhere including dOxxx, SinRopa, must make more modular--
local function AddDragFrame(window)

  function window.Event:LeftDown()
    self.leftDown = true
    local mouse = Inspect.Mouse()
    self.originalXDiff = mouse.x - self:GetLeft()
    self.originalYDiff = mouse.y - self:GetTop()
    local left, top, right, bottom = window:GetBounds()
    window:ClearAll()
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", left, top)
    window:SetWidth(right-left)
    window:SetHeight(bottom-top)
  end

  function window.Event:LeftUp()
    self.leftDown = false
  end

  function window.Event:LeftUpoutside()
    self.leftDown = false
  end

  function window.Event:MouseMove(x, y)
    if not self.leftDown then
      return
    end
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x - self.originalXDiff, y - self.originalYDiff)
  end
 end
 
--RCLICKS--
local function RClickCreate(window)
   function window.Event:RightClick() 
	self.RightClick = true
	TN.note.TextInput()
	 end
end

local function RClickRemove(texture, text)
	function texture.Event.RightClick(texture)
		texture.RightClick = true
		text.RightClick = true
		texture.SetVisible(texture, false)
		text.SetVisible(text, false)
		x, y = x - 5, y - 5 --restores pre-offset placement--
	end
end

--Tacky Note Main Icon--
function TN.note.MainIcon()
	context = UI.CreateContext("context")
	TN.note.MainIcon = UI.CreateFrame("Texture", "Image", context)
	TN.note.MainIcon:SetTexture("TackyNotes", "tackybundle1.png")
	TN.note.MainIcon:ResizeToTexture()
	TN.note.MainIcon:SetPoint("TOPCENTER", UIParent, "TOPCENTER")
	AddDragFrame(TN.note.MainIcon)
	RClickCreate(TN.note.MainIcon)
end

---TEXT INPUT BOX--
function TN.note.TextInput()
	local text = {}
		local context = UI.CreateContext("context")
		text.frame = UI.CreateFrame("SimpleWindow", "", context)
		text.frame:SetVisible(true)
		text.frame:SetLayer(1)
		text.frame:SetCloseButtonVisible(true)
		text.frame:SetPoint("CENTER", UIParent, "CENTER")
		text.frame:SetWidth(400)
		text.frame:SetHeight(250)
		
		text.textArea = UI.CreateFrame("SimpleTextArea", "text.textArea", text.frame)
		text.textArea:SetLayer(10)
		text.textArea:SetPoint("CENTER", text.frame, "CENTER")
		text.textArea:SetWidth(300)
		text.textArea:SetHeight(100)
		text.textArea:SetBackgroundColor(0.0, 0.0, 0.0, 0.3)
		text.textArea:SetText("")
		
		text.OKBtn = UI.CreateFrame("RiftButton", "buttonOK", text.frame)
		text.OKBtn:SetLayer(10)
		text.OKBtn:SetPoint("BOTTOMCENTER", text.frame, "BOTTOMCENTER")
		text.OKBtn:SetText("OK")
			function text.OKBtn.Event:LeftClick()
			local text = text.textArea:GetText()
			TN.note.textword = text
			TN.note:cc()
			x, y = x + 5, y + 5 --creates an aesthetic diagonal offset, should probably do 1-3px corner rounding too--
		 	end		
end

----Note Creation Code----
function TN.note.cc()
local Context = UI.CreateContext("Context")
	TN.note.text = UI.CreateFrame("Text", "TextFrame", Context)
	TN.note.text:SetText(TN.note.textword)
	--Tacky Note Text Formatting--
	TN.note.text:SetFont("TackyNotes", "Swagger.ttf")
	TN.note.text:SetFontSize(18)
	TN.note.text:SetLayer(3)
	TN.note.text:SetFontColor(0,0,0,1)
	TN.note.text:SetWidth(100)
	TN.note.text:SetHeight(100)
	TN.note.text:SetWordwrap(true)
	--Tacky Note Textures--
	TN.note.texture = UI.CreateFrame("Texture", "Image", Context)
	TN.note.texture:SetTexture("TackyNotes", "tacky.png")
	TN.note.texture:SetWidth(100)
	TN.note.texture:SetHeight(100)
	TN.note.texture:SetLayer(2)
	--Align Texture to Text --
	TN.note.texture:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x, y)
	TN.note.text:SetPoint("CENTER", TN.note.texture, "CENTER")
	--Apply Functions--
	AddDragFrame(TN.note.texture)
	RClickRemove(TN.note.texture, TN.note.text)
end

function TN.Event.LoadEnd(identifier)
	if identifier == "TackyNotes" then	
		print("Tackynotes loaded. /TN")
		TN.Visible = true
			else
				print("Error number 42, please consult a physician")
					end	
end

local function HelpMessage()
print("Type '/TN padoff' to remove the pad")
		print("Type '/TN padon' to restore the pad")
		print("Type '/TN juggle' to enable juggling")
end

function TN.Event.SlashHandler(params) 
	if params == "help" then
		HelpMessage()
	elseif params == "padoff" then
					print("The pad has been removed")
					TN.note.MainIcon:SetVisible(false)
	elseif params == "padon" then
					print("The pad has been RESTORED! YEAH")
					TN.note.MainIcon:SetVisible(true)
	elseif params == "juggling" then
					print("I was kidding. I'm sorry")
					HelpMessage()
	else
		print("Error 76 - That is not a valid command")
		print("The recognized commands follow below")
		HelpMessage()
	end
end


--BEGIN FRAMES--
WelcomeMessage()
TN.note.MainIcon()

--BEGIN SLASH HANDLERS--
table.insert(Event.Addon.Load.End, 				{TN.Event.LoadEnd, 			"TackyNotes", "Init"})
table.insert(Command.Slash.Register("TN"), 		{TN.Event.SlashHandler, 	"TackyNotes", "Slasher"})
