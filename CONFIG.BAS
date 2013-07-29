DECLARE FUNCTION GetMaxPV% (incr%, init%, wrap%)
DECLARE SUB ChangePval (pval%)
DECLARE SUB CreateFancyBox ()
DECLARE SUB ChangeDela (delay%)
DECLARE SUB ChangeTime (time%)
DECLARE SUB ChangeIncr (incr%)
DECLARE SUB ChangeInit (init%)
DECLARE SUB ChangeWrap (wrap%)

OPEN "CONFIG.DAT" FOR RANDOM AS #1
IF LOF(1) <= 0 THEN
  CLOSE #1
  SHELL "DEL CONFIG.DAT"
  PRINT "The configuration file is not found."
  PRINT "Please run the main program to create a new configuration file."
  END
END IF

CLS
CreateFancyBox
LOCATE 7, 25
PRINT "*"
LOCATE 7, 28
PRINT "DO WRAP AROUND:"
LOCATE 7, 45
PRINT CHR$(17)
LOCATE 8, 28
PRINT "INITIAL LENGTH:"
LOCATE 8, 45
PRINT CHR$(17)
LOCATE 9, 28
PRINT "INCREASE BY   :"
LOCATE 9, 45
PRINT CHR$(17)
LOCATE 10, 28
PRINT "FOOD WAIT TIME:"
LOCATE 10, 45
PRINT CHR$(17)
LOCATE 11, 28
PRINT "PROGRAM DELAY :"
LOCATE 11, 45
PRINT CHR$(17)

LOCATE 12, 28
PRINT "POINT VALUE   :"
LOCATE 12, 45
PRINT CHR$(17)

LOCATE 13, 28
PRINT "SAVE AND EXIT"
LOCATE 14, 28
PRINT "EXIT WITHOUT SAVING"

GET #1, 1, wrap%
GET #1, 2, init%
GET #1, 3, incr%
GET #1, 4, time%
GET #1, 5, dela%
GET #1, 6, pval%

ChangeWrap wrap%
ChangeInit init%
ChangeIncr incr%
ChangeTime time%
ChangeDela dela%
ChangePval pval%

LOCATE 7, 51
PRINT CHR$(16)
LOCATE 8, 51
PRINT CHR$(16)
LOCATE 9, 51
PRINT CHR$(16)
LOCATE 10, 51
PRINT CHR$(16)
LOCATE 11, 51
PRINT CHR$(16)
LOCATE 12, 51
PRINT CHR$(16)
selected = 0

WHILE 1
  c$ = INKEY$
  SELECT CASE c$

  CASE CHR$(27)
    CLOSE #1
    END

  CASE CHR$(0) + "K", CHR$(0) + "M", CHR$(13)
    GOTO CheckSelection

  CASE CHR$(0) + "P"
    LOCATE 7 + selected, 25
    PRINT " "
    selected = selected + 1
    IF selected > 7 THEN
      selected = 0
    END IF
    LOCATE 7 + selected, 25
    PRINT "*"
  CASE CHR$(0) + "H"
    LOCATE 7 + selected, 25
    PRINT " "
    selected = selected - 1
    IF selected < 0 THEN
      selected = 7
    END IF
    LOCATE 7 + selected, 25
    PRINT "*"
  END SELECT
ToLoop:
WEND

CheckSelection:

SELECT CASE selected
  CASE 0
    wrap% = (wrap% + 1) MOD 2
    ChangeWrap wrap%
    IF pval% > GetMaxPV(incr%, init%, wrap%) THEN
      pval% = GetMaxPV(incr%, init%, wrap%)
      ChangePval pval%
    END IF
  CASE 1
    IF c$ = CHR$(0) + "K" THEN
      init% = init% - 1
      IF init% < 4 THEN
        init% = 9
      END IF
    ELSE
      init% = init% + 1
      IF init% > 9 THEN
        init% = 4
      END IF
    END IF
    IF pval% > GetMaxPV(incr%, init%, wrap%) THEN
      pval% = GetMaxPV(incr%, init%, wrap%)
      ChangePval pval%
    END IF
    ChangeInit init%
  CASE 2
    IF c$ = CHR$(0) + "K" THEN
      incr% = incr% - 1
      IF incr% < 1 THEN
        incr% = 10
      END IF
    ELSE
      incr% = incr% + 1
      IF incr% > 10 THEN
        incr% = 1
      END IF
    END IF
    IF pval% > GetMaxPV(incr%, init%, wrap%) THEN
      pval% = GetMaxPV(incr%, init%, wrap%)
      ChangePval pval%
    END IF
    ChangeIncr incr%
  CASE 3
    IF c$ = CHR$(0) + "K" THEN
      time% = time% - 1
      IF time% < 1 THEN
        time% = 9
      END IF
    ELSE
      time% = time% + 1
      IF time% > 9 THEN
        time% = 1
      END IF
    END IF
    ChangeTime time%
  CASE 4
    IF c$ = CHR$(0) + "K" THEN
      dela% = dela% - 1
      IF dela% < 0 THEN
        dela% = 9
      END IF
    ELSE
      dela% = dela% + 1
      IF dela% > 9 THEN
        dela% = 0
      END IF
    END IF
    ChangeDela dela%
  CASE 5
    IF c$ = CHR$(0) + "K" THEN
      pval% = pval% - 1
      IF pval% < 1 THEN
        pval% = GetMaxPV(incr%, init%, wrap%)
      END IF
    ELSE
      pval% = pval% + 1
      IF pval% > GetMaxPV(incr%, init%, wrap%) THEN
        pval% = 1
      END IF
    END IF
    ChangePval pval%
                  
  CASE 6
    PUT #1, 1, wrap%
    PUT #1, 2, init%
    PUT #1, 3, incr%
    PUT #1, 4, time%
    PUT #1, 5, dela%
    PUT #1, 6, pval%
    CLOSE #1
    END
  CASE 7
    CLOSE #1
    END
END SELECT

GOTO ToLoop

SUB ChangeDela (delay%)
LOCATE 11, 47
PRINT "  "
LOCATE 11, 47
PRINT delay%
END SUB

SUB ChangeIncr (incr%)
LOCATE 9, 47
PRINT "  "
LOCATE 9, 47
PRINT incr%
END SUB

SUB ChangeInit (init%)
LOCATE 8, 47
PRINT "  "
LOCATE 8, 47
PRINT init% + 1
END SUB

SUB ChangePval (pval%)
LOCATE 12, 47
PRINT "  "
LOCATE 12, 47
PRINT pval%
END SUB

SUB ChangeTime (time%)
LOCATE 10, 47
PRINT "  "
LOCATE 10, 47
PRINT time%
LOCATE 10, 49
PRINT "s"
END SUB

SUB ChangeWrap (wrap%)

LOCATE 7, 47
IF wrap% = 0 THEN
  PRINT "NO "
ELSE
  PRINT "YES"
END IF

END SUB

SUB CreateFancyBox ()
LOCATE 6, 22
PRINT CHR$(201)
LOCATE 6, 54
PRINT CHR$(183)
LOCATE 15, 22
PRINT CHR$(200)
LOCATE 15, 55
PRINT CHR$(188)

FOR i% = 0 TO 31
LOCATE 6, 23 + i%
PRINT CHR$(205)
LOCATE 15, 23 + i%
PRINT CHR$(205)
NEXT

LOCATE 6, 55
PRINT CHR$(187)

FOR i% = 0 TO 7
LOCATE 7 + i%, 22
PRINT CHR$(186)
LOCATE 7 + i%, 55
PRINT CHR$(186)
NEXT

END SUB

FUNCTION GetMaxPV% (incr%, init%, wrap%)
  ret% = incr% + (2 * (incr% - 1)) + (init% - 6)
  IF wrap% <> 0 THEN ret% = ret% - 5
  IF ret% < 1 THEN ret% = 1
  GetMaxPV% = ret%
END FUNCTION

