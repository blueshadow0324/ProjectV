#Persistent
SetTimer, CheckHealth, 100  ; Check health every 100ms
SetTimer, CheckPickaxe, 100  ; Check pickaxe durability every 100ms
SetTimer, AutoEat, 180000  ; Auto-eat every 3 minutes (180000ms)
F1::  ; Press F1 to start/stop mining

Mining := !Mining
BlocksMined := 0
TurnDirection := 1  ; 1 = Left, -1 = Right

while Mining
{
    ; ======= CHECK HEALTH =======
    PixelGetColor, color, 500, 40  ; Change (500, 40) to first heart's position

    if (color != 0xFF0000)  ; If heart isn't red, leave game
    {
        Send, {ESC}  ; Open pause menu
        Sleep, 500
        Send, {Down}{Down}{Enter}  ; Select "Save and Quit"
        ExitApp  ; Stop script
    }

    ; ======= CHECK PICKAXE DURABILITY =======
    PixelGetColor, pickColor, 800, 900  ; Change (800, 900) to pickaxe durability bar position

    if (pickColor = 0xAAAAAA)  ; Gray durability bar (near broken)
    {
        Send, {ESC}  ; Open pause menu
        Sleep, 500
        Send, {Down}{Down}{Enter}  ; Select "Save and Quit"
        ExitApp  ; Stop script
    }

    ; ======= STRIP MINING =======
    
    ; Mine block at head level
    Send, {LButton Down}
    Sleep, 500
    Send, {LButton Up}
    
    ; Mine block at foot level
    MouseMove, 0, 20, 0, R  ; Move mouse down
    Send, {LButton Down}
    Sleep, 500
    Send, {LButton Up}
    MouseMove, 0, -20, 0, R  ; Move mouse back up

    ; Move forward
    Send, {W Down}
    Sleep, 400
    Send, {W Up}

    ; Increase block counter
    BlocksMined += 1

    ; ======= TURN EVERY 2000 BLOCKS =======
    if (BlocksMined >= 2000)
    {
        BlocksMined := 0  ; Reset counter

        if (TurnDirection == 1)
        {
            Send, {A Down}  ; Turn left
            Sleep, 300
            Send, {A Up}
        }
        else
        {
            Send, {D Down}  ; Turn right
            Sleep, 300
            Send, {D Up}
        }

        ; Move forward to start next tunnel
        Send, {W Down}
        Sleep, 400
        Send, {W Up}

        ; Reverse turn direction
        TurnDirection := -TurnDirection
    }

    ; Stop mining if F1 is pressed again
    if !GetKeyState("F1", "P")
        break
}
return

; ======= AUTO EAT FUNCTION =======
AutoEat:
    Send, {2}  ; Switch to slot 2 (Food)
    Sleep, 300
    Send, {RButton Down}  ; Hold right-click to eat
    Sleep, 2500  ; Eating time (adjust if needed)
    Send, {RButton Up}
    Sleep, 300
    Send, {1}  ; Switch back to pickaxe (Slot 1)
return