import XMonad hiding (Tall)
import System.Exit
import XMonad.Layout.Circle
import XMonad.Layout.HintedTile
import XMonad.Layout.MagicFocus
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Actions.CopyWindow
import XMonad.Actions.DynamicWorkspaces
import XMonad.Actions.GridSelect
import XMonad.Actions.NoBorders
import XMonad.Actions.SpawnOn
import XMonad.Actions.Warp(warpToScreen)
import XMonad.Actions.WindowBringer
import XMonad.Prompt
import XMonad.Util.EZConfig
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.SetWMName
import Control.Monad (when)
import Data.Monoid
import Data.List
import Data.Maybe

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

mLayout = Mirror tiled ||| tiled ||| smartBorders Full ||| Circle ||| magnifier Circle
  where
     -- default tiling algorithm partitions the screen into two panes
     --tiled   = Tall nmaster delta ratio
     tiled   = ResizableTall nmaster delta ratio []
     --hintedTile = HintedTile nmaster delta ratio TopLeft
     --tiled      = hintedTile Tall

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     --ratio   = 1/2
     ratio   = toRational (2/(1+sqrt(5)::Double)) -- golden

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
 
myWorkspaces = ["u","i","o"]
myKeys = [
 
    -- other additional keys
 
    ] ++ -- (++) is needed here because the following list comprehension
         -- is a list, not a single key binding. Simply adding it to the
         -- list of key bindings would result in something like [ b1, b2,
         -- [ b3, b4, b5 ] ] resulting in a type error. (Lists must
         -- contain items all of the same type.)
 
    [ (otherModMasks ++ "M-" ++ [key], action tag)
      | (tag, key)  <- zip myWorkspaces "uio"
      , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
                                      , ("S-", windows . W.shift)]
    ]

main = xmonad $ defaultConfig
         { modMask = mod4Mask,
           layoutHook = mLayout,
           terminal = "st",
           workspaces = myWorkspaces
         } `additionalKeysP` myKeys


