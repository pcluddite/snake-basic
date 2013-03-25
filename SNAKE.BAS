DECLARE FUNCTION RandomName$ ()
DECLARE SUB HIGHSCORE (Score%)
DECLARE SUB QuickSort (LOW%, HIGH%)
DECLARE FUNCTION RandInt% (lower%, Upper%)
DECLARE FUNCTION intersects! (x1%, y1%, w1%, h1%, x2%, y2%)
DECLARE FUNCTION FOOD! ()
DECLARE FUNCTION Rand! (Bottom!, Top!)
DECLARE SUB delay (ticks%)
DECLARE SUB RECT (x%, y%, W%, H%, C%)
SCREEN 1
CLS

TYPE Player
  Score AS INTEGER
  Nomen AS STRING * 10
END TYPE

DIM SHARED SortArray(10) AS Player

LOCATE 2, 5
PRINT "Copytight (c) 2013 Tim Baxendale"
LOCATE 12, 11
PRINT "SNAKE [Version 2.0]"
LOCATE 24, 8
PRINT "Press any key to start..."
DO
LOOP WHILE INKEY$ = ""

CLS

xmove% = 20
ymove% = 0
DIM bodyX%(255)
DIM bodyY%(255)
size% = 7
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
      IF ymove% <> 20 THEN
        ymove% = -20
        xmove% = 0
      END IF
    CASE CHR$(0) + "P"
      IF ymove% <> -20 THEN
        ymove% = 20
        xmove% = 0
      END IF
    CASE CHR$(0) + "K"
      IF xmove% <> 20 THEN
        ymove% = 0
        xmove% = -20
      END IF
    CASE CHR$(0) + "M"
      IF xmove% <> -20 THEN
        ymove% = 0
        xmove% = 20
      END IF
    CASE " "
      LOCATE 1, 1
      PRINT "Game Paused"
      DO
      LOOP WHILE INKEY$ <> " "
  END SELECT

  'Time for food?
  IF TIMER - t# > 5 AND foodOut% = 0 THEN
    t# = TIMER
    foodOut% = 1
    foodPos%(0) = Rand(0, 20) * 10
    foodPos%(1) = Rand(1, 18) * 10
  END IF

  'Is the food out?
  IF foodOut% = 1 THEN
    'CIRCLE (foodPos%(0), foodPos%(1)), 10, 1
    RECT foodPos%(0), foodPos%(1), 10, 10, 1
    PAINT (foodPos%(0) + 1, foodPos%(1) + 1), 1, 1
  END IF
  
  'Did ya get it?
  IF foodOut% = 1 AND (intersects(bodyX%(size%), bodyY%(size%), 20, 20, foodPos%(0) - 10, foodPos%(1) - 10) OR intersects(bodyX%(size%), bodyY%(size%), 20, 20, foodPos%(0) + 10, foodPos%(1) + 10)) THEN
    PAINT (foodPos%(0), foodPos%(1)), 0, 0
    size% = size% + 1
    bodyX%(size%) = bodyX%(size% - 1)
    bodyY%(size%) = bodyY%(size% - 1)
    foodOut% = 0
    SOUND 300, 1
  END IF

  'Erase the tail
  RECT bodyX%(0), bodyY%(0), 20, 20, 0

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
      bodyY%(size%) = 20
    CASE 0
      bodyY%(size%) = 180
  END SELECT
  'Wrap around X
  SELECT CASE bodyX%(size%)
    CASE -20
      bodyX%(size%) = 300
    CASE 320
      bodyX%(size%) = 0
  END SELECT

  'Paint the damn thing and don't eat me!
  FOR i% = size% TO 0 STEP -1
    RECT bodyX%(i%), bodyY%(i%), 20, 20, 2
    IF i% <> size% AND bodyX%(i%) = bodyX%(size%) AND bodyY%(i%) = bodyY%(size%) THEN
      PALETTE 2, 4
      PALETTE 3, 15
      RECT bodyX%(0), bodyY%(0), 20, 20, 2
      LOCATE 12, 16
      PRINT "You Died!"
      SOUND 37, 18
      LOCATE 23, 7
      PRINT "Press any key to continue..."
      DO
      LOOP WHILE INKEY$ = ""
      HIGHSCORE ((size% - 7) * 5)
    END IF
  NEXT
  delay (3)

  'Show me da score!
  LOCATE 1, 1
  PRINT "Score: ", (size% - 7) * 5
  LINE (0, 15)-(320, 15), 3
WEND

SUB delay (ticks%)
  FOR i% = 1 TO ticks%
    st# = TIMER
    WHILE TIMER = st#: WEND
  NEXT i%
END SUB

FUNCTION FOOD ()
        
  x% = Rand(0, 200)
  y% = Rand(0, 180)
  RECT x%, y%, 20, 20, 3
  
END FUNCTION

SUB HIGHSCORE (Score%)
DIM p AS Player
OPEN "SCORE.DAT" FOR RANDOM AS #1
IF LOF(1) <= 0 THEN
  FOR i = 1 TO 10
    p.Nomen = RandomName$
    p.Score = Rand(1, 20) * 5
    PUT #1, i, p
  NEXT
END IF

CLS

ISHIGHSCORE = 0

FOR i = 1 TO 10
  GET #1, i, p
  SortArray(i) = p
  IF p.Score < Score% THEN
    ISHIGHSCORE = 1
  END IF
NEXT

IF ISHIGHSCORE = 1 THEN
  DIM newPlayer AS Player
  PRINT "You got a high score!"
  DO
  INPUT "Please enter your name: ", Nomen$
  LOOP WHILE LEN(Nomen$) = 0 OR LEN(Nomen$) > 10
  newPlayer.Nomen = Nomen$
  newPlayer.Score = Score%
  SortArray(0) = newPlayer
END IF

QuickSort 0, 10

place = 1
cnt = 1
CLS
PRINT "", "High Scores"
PRINT ""

FOR i = 10 TO 1 STEP -1
  IF SortArray(i).Score = last% THEN
    place = place - 1
  END IF
  LOCATE (cnt * 2) + 2, 9
  PRINT place; ">"
  LOCATE (cnt * 2) + 2, 15
  PRINT SortArray(i).Nomen
  LOCATE (cnt * 2) + 2, 27
  PRINT SortArray(i).Score,
  PRINT ""
  PUT #1, i, SortArray(i)
  last% = SortArray(i).Score
  place = place + 1
  cnt = cnt + 1
NEXT
CLOSE #1
DO
LOOP WHILE INKEY$ = ""
END
END SUB

FUNCTION intersects (x1%, y1%, w1%, h1%, x2%, y2%)
  IF x2% <= x1% + w1% AND x2% >= x1% AND y2% <= y1% + h1% AND y2% >= y1% THEN
    intersects = INT(1)
  ELSE
    intersects = INT(0)
  END IF
END FUNCTION

DEFINT A-Z
' ============================== QuickSort ===================================
'   QuickSort works by picking a random "pivot" element in SortArray, then
'   moving every element that is bigger to one side of the pivot, and every
'   element that is smaller to the other side.  QuickSort is then called
'   recursively with the two subdivisions created by the pivot.  Once the
'   number of elements in a subdivision reaches two, the recursive calls end
'   and the array is sorted.
' ============================================================================
'
SUB QuickSort (LOW, HIGH)
   IF LOW < HIGH THEN

      ' Only two elements in this subdivision; swap them if they are out of
      ' order, then end recursive calls:
      IF HIGH - LOW = 1 THEN
         IF SortArray(LOW).Score > SortArray(HIGH).Score THEN
            SWAP SortArray(LOW), SortArray(HIGH)
            'SwapBars Low, High
         END IF
      ELSE

         ' Pick a pivot element at random, then move it to the end:
         RandIndex = RandInt%(LOW, HIGH)
         SWAP SortArray(HIGH), SortArray(RandIndex)
         'SwapBars High, RandIndex
         Partition = SortArray(HIGH).Score
         DO

            ' Move in from both sides towards the pivot element:
            i = LOW: J = HIGH
            DO WHILE (i < J) AND (SortArray(i).Score <= Partition)
               i = i + 1
            LOOP
            DO WHILE (J > i) AND (SortArray(J).Score >= Partition)
               J = J - 1
            LOOP

            ' If we haven't reached the pivot element, it means that two
            ' elements on either side are out of order, so swap them:
            IF i < J THEN
               SWAP SortArray(i), SortArray(J)
               'SwapBars i, J
            END IF
         LOOP WHILE i < J

         ' Move the pivot element back to its proper place in the array:
         SWAP SortArray(i), SortArray(HIGH)
         'SwapBars i, High

         ' Recursively call the QuickSort procedure (pass the smaller
         ' subdivision first to use less stack space):
         IF (i - LOW) < (HIGH - i) THEN
            QuickSort LOW, i - 1
            QuickSort i + 1, HIGH
         ELSE
            QuickSort i + 1, HIGH
            QuickSort LOW, i - 1
         END IF
      END IF
   END IF
END SUB

DEFSNG A-Z
FUNCTION Rand (Bottom, Top)
  RANDOMIZE TIMER
  RANDOMIZE RND
  Rand = INT((Top - Bottom + 1) * RND + Bottom)
END FUNCTION

DEFINT A-Z
' =============================== RandInt% ===================================
'   Returns a random integer greater than or equal to the Lower parameter
'   and less than or equal to the Upper parameter.
' ============================================================================
'
STATIC FUNCTION RandInt% (lower, Upper)
   RandInt% = INT(RND * (Upper - lower + 1)) + lower
END FUNCTION

DEFSNG A-Z
FUNCTION RandomName$ ()
  SELECT CASE Rand(0, 22)
    CASE 0
      RandomName$ = "Dan"
    CASE 1
      RandomName$ = "Matt"
    CASE 2
      RandomName$ = "Annie"
    CASE 3
      RandomName$ = "Mary C"
    CASE 4
      RandomName$ = "Jake"
    CASE 5
      RandomName$ = "Michael G"
    CASE 6
      RandomName$ = "Timothy P"
    CASE 7
      RandomName$ = "Stephen F"
    CASE 8
      RandomName$ = "Joseph P"
    CASE 9
      RandomName$ = "Kate"
    CASE 10
      RandomName$ = "Peter A"
    CASE 11
      RandomName$ = "John C"
    CASE 12
      RandomName$ = "Gracie"
    CASE 13
      RandomName$ = "Claire"
    CASE 14
      RandomName$ = "Frank"
    CASE 15
      RandomName$ = "Meaghan"
    CASE 16
      RandomName$ = "Maddie"
    CASE 17
      RandomName$ = "Andrew"
    CASE 18
      RandomName$ = "Jason"
    CASE 19
      RandomName$ = "Paul"
    CASE 20
      RandomName$ = "David"
    CASE 21
      RandomName$ = "Jon Jon"
    CASE 22
      RandomName$ = "Emilie"
  END SELECT
END FUNCTION

SUB RECT (x%, y%, W%, H%, C%)
  LINE (x%, y%)-(x% + W%, y%), C%
  LINE (x%, y%)-(x%, y% + H%), C%
  LINE (x% + W%, y%)-(x% + W%, y% + H%), C%
  LINE (x%, y% + H%)-(x% + W%, y% + H%), C%
END SUB

