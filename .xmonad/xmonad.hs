                               
--                                                               ,,  
--                                                              `7MM  
--                                                                MM  
--` 7M'   `MF'`7MMpMMMb.pMMMb.  ,pW"Wq.`7MMpMMMb.   ,6"Yb.   ,M""bMM  
--   `VA ,V'    MM    MM    MM 6W'   `Wb MM    MM  8)   MM ,AP    MM  
--     XMX      MM    MM    MM 8M     M8 MM    MM   ,pm9MM 8MI    MM  
--   ,V' VA.    MM    MM    MM YA.   ,A9 MM    MM  8M   MM `Mb    MM  
-- .AM.   .MA..JMML  JMML  JMML.`Ybmd9'.JMML  JMML.`Moo9^Yo.`Wbmd"MML.                                                       
                    
---------
--imports
---------

{-# LANGUAGE LambdaCase #-}
import qualified Data.Map as M
import Data.Default
import Data.List
import Data.Monoid
import Data.Ord
import Data.Ratio
import Control.Monad
import System.Directory
import System.Posix.Files
import System.Exit (exitSuccess)

import XMonad
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.Window

import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.GroupNavigation
import qualified XMonad.Actions.DynamicWorkspaceOrder as DO
import XMonad.Actions.OnScreen
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.WorkspaceNames

import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition -- set turn tile
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.PositionStoreHooks
import XMonad.Hooks.SetWMName (setWMName)
import XMonad.Hooks.WallpaperSetter

import XMonad.Layout.Accordion
import XMonad.Layout.BoringWindows --(boringWindows, focusUp, focusDown, focusMaster)
import XMonad.Layout.Combo
import XMonad.Layout.Decoration
import XMonad.Layout.DragPane
import XMonad.Layout.Drawer
import XMonad.Layout.Hidden
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.SubLayouts
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Spacing
import XMonad.Layout.StateFull
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.TwoPanePersistent
import XMonad.Layout.WindowNavigation

import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Run (spawnPipe) 
import XMonad.Util.WindowProperties

import qualified XMonad.StackSet as W --hiding (focusMaster, workspaces)

----------------
-- Color scheme
----------------

bgcolor = "#191919"
fgcolor = "#475359"
black = "#01060e"
red = "#ac3838"
green = "#4db69f"
yellow = "#c9bc0E"
blue = "#5681b3"
magenta = "#cf00ac"
cyan = "#02adc7"
white = "#cfd8dc"
grey = "#073642"

altblack = "#475359"
altred = "#ff4f4d"
altgreen = "#56d6ba"
altyellow = "#c9c30e"
altblue = "#c9c30e"
altmagenta = "#9c0082"
altcyan = "#02b7c7"
altwhite = "#a7b0b5"

--------------
--Gaps & Theme
--------------

-- gaps (for screen)
sGapsT = 6
sGapsB = 6
sGapsR = 6
sGapsL = 6

-- gaps (for window)
wGapsT = 8
wGapsB = 8
wGapsR = 8
wGapsL = 8

borderSize = 1

myWorkspaces = ["1:Browser", "2:Home", "3:Code", "4:Full", "5:System"]

myFont s = "xft:Iosevka:size=" ++ show s ++":antialias=true"

myTerminal = "alacritty"

myTabTheme = def 
           { activeColor = bgcolor
           , inactiveColor = bgcolor
           , urgentColor = altyellow
           , activeBorderColor = blue
           , inactiveBorderColor = black
           , urgentBorderColor = yellow
           , activeTextColor = blue
           , inactiveTextColor = altblue
           , urgentTextColor = altblue
           , fontName = myFont 10
           }

myShowWNameTheme = def
    { swn_font              = myFont 36
    , swn_fade              = 0.6
    , swn_bgcolor           = bgcolor
    , swn_color             = blue
    }

myXPConfig = def
            { font              = myFont 24
            , fgColor           = blue
            , bgColor           = bgcolor
            , borderColor       = red
            , height            = 80
            , promptBorderWidth = 0
            , autoComplete      = Just 500000
            , bgHLight          = bgcolor  
            , fgHLight          = altblue
            , position          = CenteredAt 0.3 0.5
            }

toggleFloat x w = windows (\s -> if M.member w (W.floating s) then W.sink w s
                                 else
                                     if x == R then (W.float w (W.RationalRect 0.5 0.015 0.5 1.0) s)
                                     else (W.float w (W.RationalRect 0.0 0.015 0.5 1.0) s))

isOnScreen :: ScreenId -> WindowSpace -> Bool
isOnScreen s ws = s == unmarshallS (W.tag ws)

currentScreen :: X ScreenId
currentScreen = gets (W.screen . W.current . windowset)

spacesOnCurrentScreen :: WSType
spacesOnCurrentScreen = WSIs (isOnScreen <$> currentScreen)

------
--Main
------

main :: IO ()
main = do 
    nScreens <- countScreens
--    replace
    xmonad $ ewmh def
        { borderWidth = borderSize
        , workspaces = withScreens nScreens myWorkspaces 
        , layoutHook = showWName' myShowWNameTheme myLayout
        , terminal = myTerminal
        , normalBorderColor = black
        , focusedBorderColor = blue
        , modMask = modm
        , logHook = myLogHook -- wsLogfile-- wsbar
        , startupHook = myStartupHook
        -- , mouseBindings = myMouseBindings
        , manageHook = insertPosition Above Newer <+> manageDocks <+> myManageHook 
        , handleEventHook = fullscreenEventHook <+> docksEventHook <+> ewmhDesktopsEventHook
        , focusFollowsMouse = True
        , clickJustFocuses = True
        }
        `removeKeys` removekeys'
        `additionalKeys` keys'
        `additionalKeysP` keysP'

---------
--Startup
---------

myStartupHook = do
    -- spawn "feh --bg-scale ~/Pictures/Wallpapers/wall.jpg"
    spawn "bash .config/polybar/launch.sh"
    spawn "nitrogen --restore"
    spawn "picom -b"
    spawn "nm-applet"

------
--Logs
------

myLogHook = do
    ewmhDesktopsLogHook
    --historyHook <+> fadeInactiveLogHook fadeAmount
   -- where fadeAmount = 0.55 
    -- io . appendFile h . (++ "\n") =<< getWsLog
    -- eventLogHook
    {-
    dynamicLogWithPP xmobarPP 
                        { ppOutput = hPutStrLn h
                        , ppSort = DO.getSortByOrder
                        }
    -}

-------
--Hooks
-------

myManageHook = composeAll 
    [
      className =? "plasma"                                     --> doCenterFloat      
    , className =? "Plasma"                                     --> doCenterFloat
    , className =? "plasma-desktop"                             --> doCenterFloat
    , className =? "Plasma-desktop"                             --> doCenterFloat 
    , className =? "plasmashell"                                --> doCenterFloat 
    , className =? "ksplashsimple"                              --> doCenterFloat
    , className =? "ksplashqml"                                 --> doCenterFloat
    , className =? "File Operation Progress"                    --> doCenterFloat 
    , className =? "krunner"                                    --> doCenterFloat 
    , className =? "Code"                                       --> doShift (marshall 0 "1:Code")
    , className =? "Gimp"                                       --> doShift (marshall 0 "4:Full")
    , className =? "Slack"                                      --> doShift (marshall 0 "5:System")
    , className =? "Spotify"                                    --> doShift (marshall 0 "5:System")
    , stringProperty "WM_NAME" =? "LINE"                        --> doCenterFloat
    , className =? "Light-locker-settings.py"                   --> doCenterFloat
    , className =? "Lxappearance"                               --> doCenterFloat
    , className =? "Font-manager"                               --> doCenterFloat
    , stringProperty "WM_WINDOW_ROLE" =? "GtkFileChooserDialog" --> doCenterFloat
    , stringProperty "WM_ICON_NAME" =? "Visual Studio Code"     --> doCenterFloat
    , stringProperty "WM_ICON_NAME" =? "Launch Application"     --> doCenterFloat
    ]

spaces = spacingRaw True (Border sGapsT sGapsB sGapsR sGapsL) True (Border wGapsT wGapsB wGapsR wGapsL) True

named w = renamed [(XMonad.Layout.Renamed.Replace w)]

wsLayout l = sideBar `onBottom` l

---------
--Layouts
---------

myLayout = windowNavigation
         $ avoidStruts
         $ lessBorders OnlyScreenFloat 
         $ onWorkspaces ["0_1:Browser", "1_1:Browser"] (wsLayout (tall ||| comboTall))
         $ onWorkspaces ["0_2:Home", "1_2:Home"] (wsLayout (tall ||| comboTall))
         $ onWorkspaces ["0_3:Code", "1_3:Code"] (wsLayout twoPane)
         $ onWorkspaces ["0_4:Full", "1_4:Full"] (wsLayout fullWindow ||| floatWindow)
         $ onWorkspaces ["0_5:System", "1_5:System"] (wsLayout threeCol)
         $ tall

base = addTabs shrinkText myTabTheme
     $ subLayout [] (Simplest)
     $ boringWindows
     $ ResizableTall 1 0.05 0.619 [1, 0.79]

comboTall = named "Media&Coding"
          $ mkToggle (single NBFULL)
          $ hiddenWindows
          $ spaces
          $ combineTwo (Simplest) (base) (tabbed shrinkText myTabTheme)

tall = named "Browsing"
     $ mkToggle (single NBFULL)
     $ hiddenWindows
     $ spaces
     $ base

twoPane = named "Code"
        $ mkToggle (single NBFULL)
        $ boringWindows
        $ hiddenWindows
        $ spaces
        $ reflectHoriz
        $ combineTwo (TwoPanePersistent Nothing 0.05 0.5) (tabbed shrinkText myTabTheme) (tabbed shrinkText myTabTheme)

fullWindow = named "Full"
           $ hiddenWindows
           $ noBorders StateFull
--data AllFloats = AllFloats deriving (Read, Show)

--instance SetsAmbiguous AllFloats
--    where
--        hiddens _ wset _ _ = M.keys $ W.floating wset

floatWindow = named "Float"
            $ hiddenWindows
            $ noBorders simpleFloat

threeCol = named "System"
         $ hiddenWindows
         $ spaces
         $ ThreeColMid 1 (0.05) (4/10)

sideBar = drawer 0.005 0.3 (ClassName "Blueman-manager" `Or` ClassName "Pavucontrol") $ Accordion

--------------
--Key Bindings
--------------

modm = mod4Mask
sModm = mod1Mask --sub mod mask

keys' = [ -- forcus keys
          ((modm,                  xK_Tab), windows W.focusUp)
        , ((modm .|. shiftMask,    xK_Tab), windows W.focusDown)
        , ((modm,                  xK_w), kill)
        , ((modm,                  xK_a), sendMessage ToggleStruts)
        , ((modm,                  xK_k), focusUp)
        , ((modm,                  xK_j), focusDown)
        , ((modm,                  xK_Return), focusMaster)
        , ((modm,                  xK_h), withFocused hideWindow)
        , ((modm .|. shiftMask,    xK_space), popNewestHiddenWindow) -- pop up latest hidden window
        , ((modm,                  xK_l), onGroup W.focusUp')

        -- swap keys
        , ((modm .|. shiftMask,    xK_k), windows W.swapUp)
        , ((modm .|. shiftMask,    xK_j), windows W.swapDown)
        , ((modm .|. controlMask,  xK_Return), windows W.swapMaster)
        -- tabbed keys
        , ((modm .|. controlMask,  xK_k), sendMessage $ pullGroup U)
        , ((modm .|. controlMask,  xK_j), sendMessage $ pullGroup D)

        , ((modm,                  xK_m), withFocused (sendMessage . MergeAll))
        , ((modm .|. shiftMask,    xK_m), withFocused (sendMessage . UnMergeAll))

        -- move keys (for combo mode)
        , ((modm,                  xK_u), sendMessage $ Move U)
        , ((modm,                  xK_i), sendMessage $ Move D)
        , ((modm,                  xK_y), sendMessage $ Move L)
        , ((modm,                  xK_o), sendMessage $ Move R)

        -- workspace keys
        , ((modm .|. controlMask,    xK_h), moveTo Prev spacesOnCurrentScreen)
        , ((modm .|. controlMask,    xK_l), moveTo Next spacesOnCurrentScreen)
        , ((modm .|. shiftMask,  xK_h), shiftTo Prev spacesOnCurrentScreen >> moveTo  Prev spacesOnCurrentScreen)
        , ((modm .|. shiftMask,  xK_l), shiftTo Next spacesOnCurrentScreen >> moveTo  Next spacesOnCurrentScreen)
        -- ((sModm .|. controlMask, xK_l), nextWS)
        -- apps
        , ((modm,                  xK_p), spawn "env LANG=en_US.UTF-8 rofi -modi combi -show combi -combi-modi window,drun -show-icons")
        , ((modm .|. shiftMask,    xK_p), spawn "rofi -show run")

        -- instead function + f1(f7)
        , ((modm,                  xK_F1), spawn $ "lock-touchpad")
        -- , ((modm,                  xK_F7), spawn $ )
        , ((modm,                  xK_f), sendMessage $ Toggle NBFULL)

        -- for float
        --, ((modm,                  xK_Up), withFocused (toggleFloat U))
        , ((modm,                  xK_Right), withFocused (toggleFloat R))
        , ((modm,                  xK_Left), withFocused (toggleFloat L))
        -- Launch openbox
        -- , ((sModm .|. shiftMask,   xK_o), restart "/home/sumi/bin/obtoxmd" True)
        -- dual monitor swicher
        , ((modm,                  xK_n), onNextNeighbour def W.view)
        , ((modm .|. shiftMask,    xK_n), onNextNeighbour def W.shift)
        , ((modm,                  xK_b), onPrevNeighbour def W.view)
        , ((modm .|. shiftMask,    xK_b), onPrevNeighbour def W.shift)

        , ((modm,                  xK_s), windowPrompt myXPConfig Goto wsWindows)
        , ((modm .|. shiftMask,    xK_s), windowPrompt myXPConfig Bring allWindows)

        , ((modm .|. controlMask,    xK_r), spawn "xmonad --recompile")
        , ((modm .|. shiftMask,    xK_r), spawn "xmonad --restart")
        , ((modm .|. shiftMask,    xK_q), io exitSuccess)
        -- , ((modm, xK_q), restart "xmonad" True)
        ]
        ++
        -- workspace swicher
        [ ((m .|. modm, k), windows $ onCurrentScreen f i)
              | (i, k) <- zip myWorkspaces [xK_1 .. xK_9]
              , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
        ]

-- Control PC
keysP' = [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
         , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
         , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
         , ("<XF86MonBrightnessUp>", spawn "light -A 5")
         , ("<XF86MonBrightnessDown>", spawn "light -U 5")
         ]

removekeys' = [(m .|. modm, n) | n <- [xK_1 .. xK_9], m <- [0, shiftMask]]
              ++
              [(m .|. modm, n) | n <- [xK_w, xK_e, xK_r], m <- [0, shiftMask]]
              ++
              [ (modm,             xK_slash)
              , (modm,             xK_question)
              , (modm,             xK_comma)
              , (modm,             xK_period)
              ]

{-
withScreen :: ScreenId -- ^ ID of the target screen.  If such doesn't exist, this operation is NOOP
              -> (WorkspaceId -> WindowSet -> WindowSet)
              -> X ()
withScreen n f = screenWorkspace n >>= flip whenJust (windows . f)
-}
