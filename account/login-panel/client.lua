--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local panel = {
		login = {},
		register = {},
		sounds = {
			{ 'login-panel/music/blur.mp3', 0.3 },
			{ 'login-panel/music/myway.mp3', 0.3 },
			{ 'login-panel/music/confetti.mp3', 0.3 },
			{ 'login-panel/music/greenday.mp3', 0.3 },
			{ 'login-panel/music/pluto.mp3', 0.3 },
			{ 'login-panel/music/waydownwego.mp3', 0.3 },
			{ 'login-panel/music/gonnagofarkid.mp3', 0.3 },
		}
	}
local sw, sh = guiGetScreenSize()
local fade = { }
local logoScale = 0.5
local logoSize = { sw*logoScale, sw*455/1920*logoScale }
local uFont
local time = 2000

function startLoginSound()
	local sound = math.random( 1, 7 )
	local bgMusic = playSound ( panel.sounds[ sound ][ 1 ], true )
	if bgMusic then
		setSoundVolume( bgMusic, panel.sounds[ sound ][ 2 ] )
	end
	setElementData(localPlayer, "bgMusic", bgMusic , false)
end

function open_log_reg_pannel()
	if not isElement ( mainWindow ) then
		-- blur screen.
		triggerEvent( 'hud:blur', resourceRoot, 'off', true )
		setTimer( triggerEvent, time, 1, 'hud:blur', resourceRoot, 6, true, 0.1, nil )

		-- sound effects.
		--triggerEvent("account:showMusicLabel", localPlayer)
		startLoginSound()
		
		-- prepare.
		showChat(false)
		showCursor(true)
		guiSetInputEnabled(true)
		local Width,Height = 350,350
		local X = (sw/2) - (Width/2)
		local Y = (sh/2) - (Height/2)
		ufont = ufont or guiCreateFont( ':interior_system/intNameFont.ttf', 11 )

		mainWindow = guiCreateWindow( X, Y, 350, 350, "Přihlašovací panel", false )
		guiWindowSetMovable(mainWindow, false)
		guiWindowSetSizable(mainWindow, false)
		guiSetVisible(mainWindow, false)

		--panel.login.logo = guiCreateStaticImage( (sw-logoSize[1])/2, logoSize[2]/2, logoSize[1], logoSize[2], "/login-panel/OwlLogo7.png", false )
		panel.login.logo = guiCreateStaticImage( (sw-logoSize[1])/2, (sh-logoSize[2])/2 , logoSize[1], logoSize[2], "/login-panel/OwlLogo7.png", false )
		local x, y = guiGetPosition( panel.login.logo, false )
		--guiSetPosition( panel.login.logo, x, -logoSize[2], false )


		--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		loginButton = guiCreateButton( 10, 232, 328, 49, "Přihlásit se", false, mainWindow)
		addEventHandler("onClientGUIClick", loginButton, onClickBtnLogin, false )

		loginUsernameLabel = guiCreateLabel(10, 30, 328, 18, "Přihlašovací jméno:", false, mainWindow)
		loginUsernameEdit = guiCreateEdit(10, 48, 328, 49,"",false, mainWindow)
		guiSetFont( loginUsernameEdit, "clear-normal" )
		guiEditSetMaxLength ( loginUsernameEdit,25)

		addEventHandler("onClientGUIChanged", loginUsernameEdit, resetLogButtons)
		addEventHandler( "onClientGUIAccepted", loginUsernameEdit, startLoggingIn)

		loginPasswordLabel = guiCreateLabel(10, 99, 163, 18, "Přihlašovací heslo:", false, mainWindow)
		loginPasswordShowCheck = guiCreateCheckBox(234, 99, 104, 18, "Zobrazit heslo?", false, false, mainWindow)
		loginPasswordEdit = guiCreateEdit(10, 117, 328, 49,"",false, mainWindow)
		guiSetFont( loginUsernameEdit, "clear-normal" )
		guiEditSetMasked ( loginPasswordEdit, true )
		guiSetProperty( loginPasswordEdit, 'MaskCodepoint', '8226' )

		addEventHandler("onClientGUIClick", loginPasswordShowCheck, function()
			if guiCheckBoxGetSelected(loginPasswordShowCheck) then
				guiEditSetMasked ( loginPasswordEdit, false )
			else
				guiEditSetMasked ( loginPasswordEdit, true )
			end
		end, false)

		addEventHandler("onClientGUIChanged", loginPasswordEdit, resetLogButtons)
		addEventHandler( "onClientGUIAccepted", loginPasswordEdit, startLoggingIn)
		--[[
		lbl_about_legth = guiCreateLabel(142,42,184,18,"",false)
		guiLabelSetColor(lbl_about_legth,253,255,68)
		guiLabelSetVerticalAlign(lbl_about_legth,"center")
		guiLabelSetHorizontalAlign(lbl_about_legth,"center",false)
		]]
		loginRememberCheck = guiCreateCheckBox(10, 166, 166, 15, "Pamatovat si mě na příště?", false, false, mainWindow) 

		panel.login.error = guiCreateLabel(X,Y - 25,364,31,"Error_login_tab",false)
		guiLabelSetColor(panel.login.error,255,0,0)
		guiLabelSetVerticalAlign(panel.login.error,"center")
		guiLabelSetHorizontalAlign(panel.login.error,"center",false)
		guiSetFont(panel.login.error,"default-bold-small")

		panel.login.authen = guiCreateLabel(X,Y - 25,364,31,"Authen_login_tab",false)
		guiLabelSetColor(panel.login.authen,0,255,0)
		guiLabelSetVerticalAlign(panel.login.authen,"center")
		guiLabelSetHorizontalAlign(panel.login.authen,"center",false)
		guiSetFont(panel.login.authen,"default-bold-small")


		--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		loginRegisterButton = guiCreateButton(10, 291, 328, 49, "Registrovat se", false, mainWindow) -- A gomb
		addEventHandler("onClientGUIClick",loginRegisterButton,OnBtnRegister, false )

		panel.login.toplabel = guiCreateLabel(X,Y - 25,364,31,"",false)
		guiLabelSetColor(panel.login.toplabel,255,234,55)
		guiLabelSetVerticalAlign(panel.login.toplabel,"center")
		guiLabelSetHorizontalAlign(panel.login.toplabel,"center",false)
		guiSetFont(panel.login.toplabel,"default-bold-small")
		guiSetVisible(panel.login.toplabel,false)

		registerUsernameEdit = guiCreateEdit(10, 48, 328, 49,"",false, mainWindow)
		guiEditSetMaxLength ( registerUsernameEdit,25)
		guiSetVisible(registerUsernameEdit,false)
		guiSetFont( registerUsernameEdit, "default" )
		addEventHandler("onClientGUIChanged", registerUsernameEdit, resetRegButtons)

		registerPasswordEdit = guiCreateEdit(10, 117, 328, 49,"",false, mainWindow)
		guiEditSetMaxLength ( registerPasswordEdit,25)
		guiEditSetMasked ( registerPasswordEdit, true )
		guiSetProperty(registerPasswordEdit, 'MaskCodepoint', '8226')
		guiSetVisible(registerPasswordEdit,false)
		guiSetFont( registerUsernameEdit, "default" )
		addEventHandler("onClientGUIChanged", registerPasswordEdit, resetRegButtons)

		
		addEventHandler("onClientGUIClick", loginPasswordShowCheck, function()
			if guiCheckBoxGetSelected(loginPasswordShowCheck) then
				guiEditSetMasked ( registerPasswordEdit, false )
			else
				guiEditSetMasked ( registerPasswordEdit, true )
			end
		end, false)


		registerPasswordLabel2 = guiCreateLabel(10, 169, 328, 18, "Přihlašovací heslo ještě jednou:", false, mainWindow)
		guiSetVisible(registerPasswordLabel2,false)
		guiSetEnabled (registerPasswordLabel2, true)

		registerPasswordEdit2 = guiCreateEdit(10, 186, 328, 49,"",false, mainWindow)
		guiEditSetMaxLength ( registerPasswordEdit2,25)
		guiEditSetMasked ( registerPasswordEdit2, true )
		guiSetProperty(registerPasswordEdit2, 'MaskCodepoint', '8226')
		guiSetVisible(registerPasswordEdit2,false)
		guiSetEnabled (registerPasswordEdit2, true)
		guiSetFont( registerPasswordEdit2, "default" )
		addEventHandler("onClientGUIChanged", registerPasswordEdit2, resetRegButtons)


		registerEmailLabel = guiCreateLabel(10, 238, 328, 18, "Přihlašovací e-mail:", false, mainWindow)
		guiSetVisible(registerEmailLabel,false)
		guiSetEnabled (registerEmailLabel, true)

		registerEmailEdit = guiCreateEdit(10, 255, 328, 49,"",false, mainWindow)
		guiEditSetMaxLength ( registerEmailEdit,100)
		--guiEditSetMasked ( registerEmailEdit, true )
		guiSetVisible(registerEmailEdit,false)
		guiSetFont( registerEmailEdit, "default" )
		guiSetEnabled (registerEmailEdit, true)
		addEventHandler("onClientGUIChanged", registerEmailEdit, resetRegButtons)

		--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		registerButton = guiCreateButton( 10, 310, 150, 49, "Registrovat se", false, mainWindow)
		addEventHandler("onClientGUIClick",registerButton,onClickBtnRegister, false )
		guiSetVisible(registerButton,false)

		registerButtonCancel = guiCreateButton( 176, 310, 340, 49, "Zpět na přihlášení", false, mainWindow) -- A gomb
		addEventHandler("onClientGUIClick",registerButtonCancel,onClickCancel, false )
		guiSetVisible(registerButtonCancel,false)

		showCursor(true)

		guiSetText(panel.login.error, "")
		guiSetText(panel.login.authen, "")

		local username, password = loadLoginFromXML()
		if username ~= "" then
			guiCheckBoxSetSelected ( loginRememberCheck, true )
			guiSetText ( loginUsernameEdit, tostring(username))
			guiSetText ( loginPasswordEdit, tostring(password))
		else
			guiCheckBoxSetSelected ( loginRememberCheck, false )
			guiSetText ( loginUsernameEdit, tostring(username))
			guiSetText ( loginPasswordEdit, tostring(password))
		end

		guisSetEnabled( 'login', false )
		guisSetPosition( 'login', (sw+Width)/2 )

		-- fade the login tab in.
		setTimer( fade.login, time, 1 , (sw+Width)/2 )

		-- dynamic screen effect.
		addEventHandler( 'onClientRender', root, slideScreen )

		-- make sure screen isn't black.
		fadeCamera ( true )
	end
end

function guisSetEnabled( part, state )
	for index, gui in pairs( panel[ part ] ) do
		if index ~= 'main' then
			guiSetEnabled( gui , state )
		end
	end
end

function guisSetPosition( part, x_, y_ )
	for index, gui in pairs( panel[ part ] ) do
		if index ~= 'logo' then
			local x, y = guiGetPosition( gui, false )
			if x_ then
				x = x + x_
			end
			if y_ then
				y = y + y_
			end
			guiSetPosition( gui, x, y, false )
		end
	end
end

function fade.render( )
	fade.cur = fade.cur + fade.dir
	fade.logo_start = fade.logo_start + fade.logo_dir
	if math.abs(fade.cur) <= fade.max then
		guisSetPosition( 'login', fade.dir )
		guiSetPosition( panel.login.logo, fade.logo_x, fade.logo_start, false )
	else
		guisSetEnabled( 'login', true )
		removeEventHandler( 'onClientRender', root, fade.render )
	end
end

function fade.login( max )
	fade.cur = 0
	fade.max = max
	fade.dir = -fade.max/50
	fade.logo_start = (sh-logoSize[2])/2
	fade.logo_end = sh - logoSize[2]*3/2
	fade.logo_dir = -(fade.logo_end-fade.logo_start)/50
	fade.logo_x = (sw-logoSize[1])/2
	setTimer(function ()
		guiSetVisible(mainWindow, true)
		guiSetVisible(loginButton, true)		
	end, time - 1200, 1)
	addEventHandler( 'onClientRender', root, fade.render )
end

local speed = 0.01
local moved = 0

function slideScreen()
	local matrix = { getCameraMatrix ( localPlayer ) }
	matrix[1] = matrix[1] + speed
	moved = moved + speed
	if moved > 50 then
		local scr = shuffleScreen()
		moved = 0
		setCameraMatrix ( scr[1], scr[2], scr[3], scr[4], scr[5], scr[6], 0, exports.global:getPlayerFov())
	else
		setCameraMatrix ( unpack(matrix) )
	end
end

--[[
function start_cl_resource()
	open_log_reg_pannel()
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),start_cl_resource)
]]

function loadLoginFromXML()
	local xml_save_log_File = xmlLoadFile ("@rememberme.xml")
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile("@rememberme.xml", "login")
    end
    local usernameNode = xmlFindChild (xml_save_log_File, "username", 0)
    local passwordNode = xmlFindChild (xml_save_log_File, "password", 0)
    local username, password = usernameNode and exports.global:decryptString(xmlNodeGetValue(usernameNode), localPlayer) or "", passwordNode and exports.global:decryptString(xmlNodeGetValue(passwordNode), localPlayer) or ""
    xmlUnloadFile ( xml_save_log_File )
    return username, password
end

function saveLoginToXML(username, password)
    local xml_save_log_File = xmlLoadFile ("@rememberme.xml")
    if not xml_save_log_File then
        xml_save_log_File = xmlCreateFile("@rememberme.xml", "login")
    end
	if (username ~= "") then
		local usernameNode = xmlFindChild (xml_save_log_File, "username", 0)
		local passwordNode = xmlFindChild (xml_save_log_File, "password", 0)
		if not usernameNode then
			usernameNode = xmlCreateChild(xml_save_log_File, "username")
		end
		if not passwordNode then
			passwordNode = xmlCreateChild(xml_save_log_File, "password")
		end
		xmlNodeSetValue (usernameNode, exports.global:encryptString(username, localPlayer))
		xmlNodeSetValue (passwordNode, exports.global:encryptString(password, localPlayer))
	end
    xmlSaveFile(xml_save_log_File)
    xmlUnloadFile (xml_save_log_File)
end
addEvent("saveLoginToXML", true)
addEventHandler("saveLoginToXML", getRootElement(), saveLoginToXML)

function saveMusicSetting(state)
	if not state then return false end
	local xmlFile = xmlLoadFile("@rememberme.xml")
	if not xmlFile then 
		xmlFile = xmlCreateFile("@rememberme.xml", "login")
	end

	local settingNode = xmlFindChild(xmlFile, "loginMusic", 0)
	if not settingNode then 
		settingNode = xmlCreateChild(xmlFile, "loginMusic")
	end

	xmlNodeSetValue(settingNode, state)
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)

	updateSoundLabel(state)
end

function loadMusicSetting()
	local xmlFile = xmlLoadFile ("@rememberme.xml")
	if not xmlFile then 
		return saveMusicSetting(0)
	end
	
	local settingNode = xmlFindChild(xmlFile, "loginMusic", 0)
	local setting = xmlNodeGetValue(settingNode)
	xmlUnloadFile(xmlFile)
	return tonumber(setting)
end

function resetSaveXML()
	local xml_save_log_File = xmlLoadFile ("@rememberme.xml")
    if xml_save_log_File then
		local username, password = xmlFindChild(xml_save_log_File, "username", 0), xmlFindChild (xml_save_log_File, "password", 0)
		if username and password then 
			xmlDestroyNode(username)
			xmlDestroyNode(password)
			xmlSaveFile(xml_save_log_File)
			xmlUnloadFile(xml_save_log_File)
		end
	end
end
addEvent("resetSaveXML", true)
addEventHandler("resetSaveXML", getRootElement(), resetSaveXML)

function onClickBtnLogin(button,state)
	if(button == "left" and state == "up") then
		if (source == loginButton) then
			startLoggingIn()
		end
	end
end

local loginClickTimer = nil
function startLoggingIn()
	if not getElementData(localPlayer, "clickedLogin") then
		setElementData(localPlayer, "clickedLogin", true, false)
		if isTimer(loginClickTimer) then
			killTimer(loginClickTimer)
		end
		loginClickTimer = setTimer(setElementData, 1000, 1, localPlayer, "clickedLogin", nil, false)

		username = guiGetText(loginUsernameEdit)
		password = guiGetText(loginPasswordEdit)
			if guiCheckBoxGetSelected ( loginRememberCheck ) == true then
				checksave = true
			else
				checksave = false
			end
		playSoundFrontEnd ( 6 )
		guiSetEnabled(loginButton, false)
		guiSetAlpha(loginButton, 0.3)
		triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, checksave)
		authen_msg("Login", "Zasílám požadavek přihlášení..")
	else
		Error_msg("Login", "Pomaleji..")
	end
end

function hideLoginPanel(keepBG)
	showCursor(true)
	if keepBG then
		for name, gui in pairs( panel.login ) do
			if name ~= 'logo' then
				--guiSetVisible( mainWindow, false)
				guiSetVisible(gui, false)
			end
		end

		guiSetVisible( mainWindow, false)
	
	else
		for name, gui in pairs( panel.login ) do
			if gui and isElement( gui ) then
				destroyElement(gui)
				gui = nil
			end
		end

		destroyElement(mainWindow)
		triggerEvent( 'hud:blur', resourceRoot, 'off', true )
		removeEventHandler( 'onClientRender', root, slideScreen )
	end
end
addEvent("hideLoginPanel", true)
addEventHandler("hideLoginPanel", getRootElement(), hideLoginPanel)


function OnBtnRegister ()
	switchToRegisterPanel() -- Disabled registration
	playSoundFrontEnd ( 2 )
	--guiSetText(panel.login.error, "Please register on Owlgaming.net/register.php")
end

function onClickCancel()
	switchToLoginPanel()
	playSoundFrontEnd ( 2 )
end

function switchToLoginPanel()
	guiSetText(panel.login.error, "")
	guiSetText(panel.login.authen, "")
	guiSetText(panel.login.toplabel, "")

	guiSetSize(mainWindow, 350,350, false)
	guiSetVisible(registerButton, false)
	guiSetVisible(registerButtonCancel,false)
	guiSetVisible(panel.login.toplabel,false)
	guiSetVisible(registerPasswordEdit2,false)
	guiSetEnabled (registerPasswordEdit2, false)
	guiSetVisible(registerEmailEdit,false)
	guiSetEnabled (registerEmailEdit, false)
	guiSetVisible(registerPasswordEdit,false)
	guiSetVisible(registerUsernameEdit,false)
	guiSetVisible(registerEmailLabel,false)
	guiSetEnabled (registerEmailLabel, false)
	guiSetVisible(registerPasswordLabel2,false)
	guiSetEnabled (registerPasswordLabel2, false)

	guiSetVisible(loginRegisterButton, true)
	guiSetVisible(loginButton, true)
	guiSetVisible(loginPasswordEdit, true)
	guiSetVisible(loginUsernameEdit, true)
	guiSetVisible(loginRememberCheck, true)
	showCursor(true)
end

function switchToRegisterPanel()
	guiSetText(panel.login.error, "")
	guiSetText(panel.login.authen, "")
	guiSetText(panel.login.toplabel, "")

	guiSetSize(mainWindow, 350,350, false)
	guiSetVisible(registerButton, true)
	guiSetVisible(registerButtonCancel,true)
	guiSetVisible(panel.login.toplabel,true)
	guiSetVisible(registerPasswordLabel2,true)
	guiSetEnabled (registerPasswordLabel2, true)
	guiSetVisible(registerPasswordEdit2,true)
	guiSetEnabled (registerPasswordEdit2, true)
	guiSetVisible(registerPasswordEdit,true)
	guiSetVisible(registerUsernameEdit,true)
	guiSetVisible(registerEmailLabel,true)
	guiSetEnabled (registerEmailLabel, true)
	guiSetVisible(registerEmailEdit,true)
	guiSetEnabled (registerEmailEdit, true)

	guiSetVisible(loginRegisterButton, false)
	guiSetVisible(loginButton, false)
	guiSetVisible(loginPasswordEdit, false)
	guiSetVisible(loginUsernameEdit, false)
	guiSetVisible(loginRememberCheck, false)
	showCursor(true)
	setElementData(localPlayer, "switched", true, false)
end

function onClickBtnRegister(button,state)
	username = guiGetText(registerUsernameEdit)
	password = guiGetText(registerPasswordEdit)
	passwordConfirm = guiGetText(registerPasswordEdit2)
	email = guiGetText(registerEmailEdit)
	registerValidation(username, password, passwordConfirm,email)

	--playSoundFrontEnd ( 6 )
	guiSetEnabled(loginRegisterButton, false)
	guiSetAlpha(loginRegisterButton, 0.3)
end

function registerValidation(username, password, passwordConfirm, email)
	if not username or username == "" or not password or password == "" or not passwordConfirm or passwordConfirm == "" or not email or email == ""  then
		guiSetText(panel.login.toplabel, "Prosím, vypiš všechny políčka")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.len(username) < 3 then
		guiSetText(panel.login.toplabel, "Jméno musí mít obsahovat více písmen (min. 3).")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.len(username) >= 19 then
		guiSetText(panel.login.toplabel, "Jméno musí být menší (max. 20 znaků).")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.find(username, ' ') then
		guiSetText(panel.login.toplabel, "Nesprávné jméno.")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.find(password, "'") or string.find(password, '"') then
		guiSetText(panel.login.toplabel, "Heslo nesmí obsahovat ' nebo "..'"')
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.len(password) < 8 then
		guiSetText(panel.login.toplabel, "Heslo musí být delší (min. 8 znaků).")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.len(password) > 25 then
		guiSetText(panel.login.toplabel, "Heslo musí být menší (max. 25 znaků).")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif password ~= passwordConfirm then
		guiSetText(panel.login.toplabel, "Hesla se neshodují.")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	elseif string.match(username,"%W") then
		guiSetText(panel.login.toplabel, "Znaky \"!@#$\"%'^&*()\" nejsou povoleny ve jménu.")
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
		playSoundFrontEnd ( 4 )
	else
		local validEmail, reason = exports.global:isEmail(email)
		if not validEmail then
			guiSetText(panel.login.toplabel, reason)
			guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
			playSoundFrontEnd ( 4 )
		else
			triggerServerEvent("accounts:register:attempt",getLocalPlayer(),username,password,passwordConfirm, email)
			authen_msg("Register", "Zasílám požadavek registrace...")
		end
	end
end

function registerComplete(username, pw, email)
	guiSetText(loginUsernameEdit, username)
	guiSetText(loginPasswordEdit, pw)
	playSoundFrontEnd(13)
	displayRegisterConpleteText(username, email)
end
addEvent("accounts:register:complete",true)
addEventHandler("accounts:register:complete",getRootElement(),registerComplete)

function displayRegisterConpleteText(username)
	local GUIEditor = {
	    button = {},
	    window = {},
	    label = {}
	}

	local extend = 100
	local yoffset = 150

	GUIEditor.window[1] = guiCreateWindow(667, 381, 357, 189+extend, "Congratulations! Account has been successfully created!", false)
	exports.global:centerWindow(GUIEditor.window[1])
	--local x, y = guiGetPosition(GUIEditor.window[1], false)
	--guiSetPosition(GUIEditor.window[1], x, y+yoffset, false)
	guiSetAlpha(GUIEditor.window[1], 1)
    guiWindowSetMovable(GUIEditor.window[1], false)
    guiWindowSetSizable(GUIEditor.window[1], false)
    guiSetProperty(GUIEditor.window[1], "AlwaysOnTop", "True")
    local temp = "An email contains instructions to activate your account has been dispatched, please check your email's inbox.\n\nIf for some reasons you don't receive the email, please check your junk box or try to dispatch another activation email at https://owlgaming.net/account/"
    GUIEditor.label[1] = guiCreateLabel(8, 50, 339, 121+extend, "Your OwlGaming MTA account for '"..username.."' is almost ready for action!\n\n"..temp.."\n\nSincerely, \nOwlGaming Community OwlGaming Development Team\"", false, GUIEditor.window[1])
    guiLabelSetHorizontalAlign(GUIEditor.label[1], "left", true)

    GUIEditor.button[1] = guiCreateButton(10, 153+extend, 337, 26, "Copy Activation Link", false, GUIEditor.window[1])
    addEventHandler("onClientGUIClick", GUIEditor.button[1], function()
    	if source == GUIEditor.button[1] then
    		if isElement(GUIEditor.window[1]) then
    			destroyElement(GUIEditor.window[1])
    			GUIEditor = nil
    			switchToLoginPanel()
    			setClipboard("https://owlgaming.net/account/")
    		end
    	else
    		cancelEvent()
    	end
    end, false )
end

function Error_msg(Tab, Text)
showCursor(true)
	if Tab == "Login" then
		playSoundFrontEnd ( 4)
		guiSetVisible(loginRegisterButton, true)
		guiSetVisible(loginButton, true)
		guiSetVisible(loginPasswordEdit, true)
		guiSetVisible(loginUsernameEdit, true)
		guiSetVisible(loginRememberCheck, true)
		guiSetVisible(mainWindow, true)

		guiSetText(panel.login.authen, "")
		guiSetText(panel.login.error, tostring(Text))
		--setTimer(function() guiSetText(panel.login.error, "") end,3000,1)
	else
		playSoundFrontEnd ( 4)
		guiSetText(panel.login.toplabel, tostring(Text))
		guiLabelSetColor ( panel.login.toplabel, 255, 0, 0 )
	end
end
addEvent("set_warning_text",true)
addEventHandler("set_warning_text",getRootElement(),Error_msg)

function authen_msg(Tab, Text)
showCursor(true)
	if Tab == "Login" then
		if panel.login.authen and isElement(panel.login.authen) and guiGetVisible(panel.login.authen) then
			--playSoundFrontEnd ( 12)
			guiSetVisible(loginRegisterButton, true)
			guiSetVisible(loginButton, true)
			guiSetVisible(loginPasswordEdit, true)
			guiSetVisible(loginUsernameEdit, true)
			guiSetVisible(loginRememberCheck, true)
			guiSetVisible(mainWindow, true)

			guiSetText(panel.login.error, "")
			guiSetText(panel.login.authen, tostring(Text))
			--setTimer(function() guiSetText(panel.login.authen, "") end,3000,1)
		end
	else
		--playSoundFrontEnd ( 12 )
		guiSetText(panel.login.toplabel, tostring(Text))
		guiLabelSetColor ( panel.login.toplabel, 255, 255, 255 )
	end
end
addEvent("set_authen_text",true)
addEventHandler("set_authen_text",getRootElement(),authen_msg)


function hideLoginWindow()
	showCursor(false)
	hideLoginPanel()
end
addEvent("hideLoginWindow", true)
addEventHandler("hideLoginWindow", getRootElement(), hideLoginWindow)

function CursorError ()
showCursor(false)
end
addCommandHandler("showc", CursorError)

function resetRegButtons ()
	guiSetEnabled(registerButton, true)
	guiSetAlpha(registerButton, 1)
end

function resetLogButtons()
	guiSetEnabled(loginButton, true)
	guiSetAlpha(loginButton, 1)
end


local screenStandByCurrent = 0
local screenStandByComplete = 2
local screenStandByShowing = false
function screenStandBy(action, value) -- Maxime / 2015.3.25
	if action == "add" then
		screenStandByCurrent = screenStandByCurrent + 1
		if screenStandByShowing then
			authen_msg("Login", "Loading prerequisite resources.."..screenStandBy("getPercentage").."%")
		end
		return screenStandByCurrent
	elseif action == "getCurrent" then
		return screenStandByCurrent
	elseif action == "getState" then
		return screenStandByShowing
	elseif action == "setState" then
		screenStandByShowing = value
		if screenStandByShowing then
			authen_msg("Login", "Loading prerequisite resources.."..screenStandBy("getPercentage").."%")
		end
		screenStandByCurrent = 0
		return true
	elseif action == "getPercentage" then
		local percentage = math.floor(screenStandByCurrent/screenStandByComplete*100)
		if screenStandByShowing then
			authen_msg("Login", "Loading prerequisite resources.."..percentage.."%")
		end
		return percentage
	end
end
addEvent("screenStandBy",true)
addEventHandler("screenStandBy",root,screenStandBy)

addEventHandler ( "onClientElementDataChange", localPlayer,
function ( dataName )
	if getElementType ( localPlayer ) == "player" and dataName == "loggedin" then
		showChat(getElementData(localPlayer, "loggedin") == 1)
	end
end )

--

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- migrate the public file :account/login-panel/rememberme.xml to private resource @account/rememberme.xml
	if fileExists("/login-panel/rememberme.xml") then
		if not fileExists("@rememberme.xml") then
			fileCopy("/login-panel/rememberme.xml", "@rememberme.xml")
		end
		fileDelete("/login-panel/rememberme.xml")
	end
end)
