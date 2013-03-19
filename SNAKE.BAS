DECLARE FUNCTION intersects! (x1%, y1%, w1%, h1%, x2%, y2%)
DECLARE FUNCTION FOOD! ()
DECLARE FUNCTION Rand! (Bottom!, Top!)
DECLARE SUB delay (ticks%)
DECLARE SUB RECT (x%, y%, W%, h%, c%)
SCREEN 1
CLS

LOCATE 2, 5
PRINT "Copytight (c) 2013 Tim Baxendale"
LOCATE 12, 11
PRINT "SNAKE [Version 1.0]"
LOCATE 24, 8
PRINT "Press any key to start..."
DO
LOOP WHILE INKEY$ = ""

CLS

xmove% = 10
ymove% = 0
DIM bodyX%(255)
DIM bodyY%(255)
size% = 30
FOR i% = 0 TO size%
  bodyX%(i%) = 140
  bodyY%(i%) = 80
NEXT

foodOut% = 0
DIM foodPos%(1)
t# = TIMER
PALETTE 1, 2
PALETTE 2, 15
PALETTE 3, 1

WHILE 1
  'Get the pressed key
  key$ = INKEY$
  SELECT CASE key$
    CASE CHR$(27)
      END
    CASE CHR$(0) + "H"
      IF ymove% <> 10 THEN
        ymove% = -10
        xmove% = 0
      END IF
    CASE CHR$(0) + "P"
      IF ymove% <> -10 THEN
        ymove% = 10
        xmove% = 0
      END IF
    CASE CHR$(0) + "K"
      IF xmove% <> 10 THEN
        ymove% = 0
        xmove% = -10
      END IF
    CASE CHR$(0) + "M"
      IF xmove% <> -10 THEN
        ymove% = 0
        xmove% = 10
      END IF
  END SELECT

  'Time for food?
  IF TIMER - t# > 5 AND foodOut% = 0 THEN
    t# = TIMER
    foodOut% = 1
    foodPos%(0) = Rand(0, 200)
    foodPos%(1) = Rand(10, 180)
  END IF

  'Is the food out?
  IF foodOut% = 1 THEN
    CIRCLE (foodPos%(0), foodPos%(1)), 5, 1
    'RECT foodPos%(0), foodPos%(1), 10, 10, 3
    PAINT (foodPos%(0), foodPos%(1)), 1, 1
  END IF
  
  'Did ya get it?
  IF foodOut% = 1 AND (intersects(bodyX%(size%), bodyY%(size%), 10, 10, foodPos%(0) - 5, foodPos%(1) - 5) OR intersects(bodyX%(size%), bodyY%(size%), 10, 10, foodPos%(0) + 5, foodPos%(1) + 5)) THEN
    PAINT (foodPos%(0), foodPos%(1)), 0, 0
    size% = size% + 1
    bodyX%(size%) = bodyX%(size% - 1)
    bodyY%(size%) = bodyY%(size% - 1)
    foodOut% = 0
    SOUND 300, 1
  END IF

  'Erase the tail
  RECT bodyX%(0), bodyY%(0), 10, 10, 0

  'Sort the body arrays
  FOR i% = 0 TO size%
    bodyX%(i%) = bodyX%(i% + 1)
    bodyY%(i%) = bodyY%(i% + 1)
  NEXT

  'Move the body
  bodyX%(size%) = bodyX%(size% - 1) + xmove%
  bodyY%(size%) = bodyY%(size% - 1) + ymove%
 
  'Wrap around Y
  SELECT CASE bodyY%(size%)
    CASE 200
      bodyY%(size%) = 10
    CASE 0
      bodyY%(size%) = 190
  END SELECT
  'Wrap around X
  SELECT CASE bodyX%(size%)
    CASE -10
      bodyX%(size%) = 310
    CASE 320
      bodyX%(size%) = 0
  END SELECT

  'Paint the damn thing and don't eat me!
  FOR i% = size% TO 0 STEP -1
    RECT bodyX%(i%), bodyY%(i%), 10, 10, 2
    IF i% <> size% AND bodyX%(i%) = bodyX%(size%) AND bodyY%(i%) = bodyY%(size%) THEN
      PALETTE 2, 4
      PALETTE 3, 15
      RECT bodyX%(0), bodyY%(0), 10, 10, 2
      LOCATE 12, 16
      PRINT "You Died!"
      SOUND 37, 18
      LOCATE 23, 9
      PRINT "Press any key to exit..."
      DO
      LOOP WHILE INKEY$ = ""
      END
    END IF
  NEXT
  delay (3)

  'Show me da score!
  LOCATE 1, 1
  PRINT "Score: ", (size% - 30) * 5
  LINE (0, 9)-(320, 9), 3
WEND

SUB delay (ticks%)
  FOR i% = 1 TO ticks%
    st# = TIMER
    WHILE TIMER = st#: WEND
  NEXT i%
END SUB

FUNCTION FOOD
        
  x% = Rand(0, 200)
  y% = Rand(0, 180)
  RECT x%, y%, 20, 20, 3
  
END FUNCTION

FUNCTION intersects (x1%, y1%, w1%, h1%, x2%, y2%)
  IF x2% <= x1% + w1% AND x2% >= x1% AND y2% <= y1% + h1% AND y2% >= y1% THEN
    intersects = INT(1)
  ELSE
    intersects = INT(0)
  END IF
END FUNCTION

FUNCTION Rand (Bottom, Top)
  RANDOMIZE TIMER
  RANDOMIZE RND
  Rand = INT((Top - Bottom + 1) * RND + Bottom)
END FUNCTION

SUB RECT (x%, y%, W%, h%, c%)
  LINE (x%, y%)-(x% + W%, y%), c%
  LINE (x%, y%)-(x%, y% + h%), c%
  LINE (x% + W%, y%)-(x% + W%, y% + h%), c%
  LINE (x%, y% + h%)-(x% + W%, y% + h%), c%
END SUB

