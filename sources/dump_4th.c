/*
+-------+-----------------+------+-----------------+-------+-----------------+
|Program| DUMP_4TH.C      |Header| 4TH.H           |Library| 4TH             |
+-------+-----------------+------+-----------------+-------+----------+------+
|HISTORY                                           |    Programmer    | Date |
+--------------------------------------------------+------------------+------+
| Turbo C V2.0 version                             | J.L. Bezemer     |181094|
| DPX/2 340 version                                | J.L. Bezemer     |181094|
| Coherent V4.2 version                            | J.L. Bezemer     |201094|
+--------------------------------------------------+------------------+------+
|MODIFICATION LOG                                  |    Programmer    | Date |
+--------------------------------------------------+------------------+------+
| Layout changed and error message added           | J.L. Bezemer     |191094|
| Added /MOD, * /, * /MOD, I', J, FAST, SLOW       | J.L. Bezemer     |191094|
| Added VARIABLE, .R, BASE@, USER@, STACK@, LIMIT@ | J.L. Bezemer     |201094|
| Added V0@, SP@, RP@, WIDTH@; added Output        | J.L. Bezemer     |201094|
| Added EXECUTE, ABORT, EXIT, C@, TICK, COMMA      | J.L. Bezemer     |241094|
| Added CREATE, VALUE commands                     | J.L. Bezemer     |241094|
| Added /. and /.R commands                        | J.L. Bezemer     |271094|
| Added TIME and RANDOM commands                   | J.L. Bezemer     |161194|
| Removed V0@ command; changed , into C,           | J.L. Bezemer     |180395|
| Removed CREATE, DEFINE and LABEL                 | J.L. Bezemer     |210395|
| Changed STACK@ to STACK, USER@ to USER           | J.L. Bezemer     |310395|
| Changed LIMIT@ to VARS; changed WIDTH@ to ,      | J.L. Bezemer     |310395|
| Prepared for 4tH V2.0 (new object format)        | J.L. Bezemer     |130495|
| Removed LITERAL, COMMENT, TICK, SLOW, FAST, PEND.| J.L. Bezemer     |130495|
| Removed PENDING, , and C,                        | J.L. Bezemer     |140495|
| Changed C@ to ,@                                 | J.L. Bezemer     |190495|
| Removed VARDECL; added check on LastWord4th      | J.L. Bezemer     |200495|
| Added new header-listing                         | J.L. Bezemer     |210495|
| Removed STACK & VALUE; changed ; to RETURN       | J.L. Bezemer     |240495|
| Added Program->Variables to header-listing       | J.L. Bezemer     |240495|
| Fixed NULL-pointer bug in Program-StringArea     | J.L. Bezemer     |280495|
| Made texts lowercase; added string words         | J.L. Bezemer     |280495|
| Added !IN                                        | J.L. Bezemer     |290495|
| Changed 'constant' to 'literal'                  | J.L. Bezemer     |300495|
| Added #, <#, #>, #S, HOLD and SIGN               | J.L. Bezemer     |010595|
| Added COPY                                       | J.L. Bezemer     |020595|
| Added 4tH Message and string contents of PRINT   | J.L. Bezemer     |030595|
| Added >tty, >file and -trail; changed string     | J.L. Bezemer     |060995|
| Removed left, right, !in; added shift            | J.L. Bezemer     |110995|
| Added EXPECT                                     | J.L. Bezemer     |140995|
| Added TTY> and FILE>                             | J.L. Bezemer     |150995|
| Added INFILE and OUTFILE                         | J.L. Bezemer     |180995|
| Removed pointers; added PRINTABLE                | J.L. Bezemer     |210995|
| Changed label "print" into "(.")"                | J.L. Bezemer     |210995|
| Removed most conditionals, added LOOP            | J.L. Bezemer     |080296|
| Removed RETURN                                   | J.L. Bezemer     |090296|
| Added 0<>                                        | J.L. Bezemer     |100296|
| Added support for Hcode                          | J.L. Bezemer     |120296|
| Added HI, changed header for allocation message  | J.L. Bezemer     |140296|
| Added TO and VALUE                               | J.L. Bezemer     |240296|
| Removed LINE; changed header, LAST and FIRST     | J.L. Bezemer     |050396|
| Changed header to check alignment                | J.L. Bezemer     |130396|
| Changed header for new HX-format                 | J.L. Bezemer     |100496|
| Changed header for new Hcode format              | J.L. Bezemer     |270996|
| Changed '@ to @'                                 | J.L. Bezemer     |100996|
| Changed headerlisting                            | J.L. Bezemer     |301096|
| Removed ABORT, added SP! and RP!                 | J.L. Bezemer     |201196|
| Added CLOSEIO                                    | J.L. Bezemer     |061296|
| Removed TTY>, >TTY, FILE>, >FILE, INFILE, OUTFILE| J.L. Bezemer     |280297|
| Added TTY, FILE, OPEN, CLOSE; removed CLOSEIO    | J.L. Bezemer     |280297|
| Added )                                          | J.L. Bezemer     |110497|
| Added THROW; removed SP!, RP!                    | J.L. Bezemer     |170497|
| Made name_4th.c a separate file                  | J.L. Bezemer     |190497|
| Added LOCAL_H support                            | J.L. Bezemer     |220597|
| Changed header                                   | J.L. Bezemer     |130997|
| Increased tokenname to nine characters           | J.L. Bezemer     |250997|
| Removed EasyC syntax                             | J.L. Bezemer     |150198|
| Added WriteList() so writing to device is checked| J.L. Bezemer     |311099|
| Fixed major bug; WriteError properly initialized | J.L. Bezemer     |111199|
| Added First and Last arguments                   | J.L. Bezemer     |161199|
| Added support for STRINGD                        | J.L. Bezemer     |060603|
| Added some space for DELETE-FILE                 | J.L. Bezemer     |281212|
| Added Francois Perrad LINT patches               | Francois Perrad  |180217|
| Added GetLabel(), SearchSymbol()                 | J.L. Bezemer     |291017|
| Added VECTOR to GetLabel()                       | J.L. Bezemer     |190419|
| Reintegrated VECTOR into GetLabel()              | J.L. Bezemer     |040819|
| Applied Turbo C patch to GetLabel()              | J.L. Bezemer     |110520|
+--------------------------------------------------+------------------+------+
|REMARKS                                           |    Programmer    | Date |
+--------------------------------------------------+------------------+------+
| None                                             |                  |      |
+--------------------------------------------------+------------------+------+

  Copyright (C) 1997,2020 J.L. Bezemer

  This file is part of 4tH

  4tH is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public License
  as published by the Free Software Foundation; either version 3
  of the License, or (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


4th disassembler to dump the H-code in a readable format. First the
wordnumber, then the compiled word and the value associated with the command
and if possible a string.

Prototype: int dump_4th (Hcode* Program, FILE *Output, int First, int Last)
Returns  : TRUE if an error occured, FALSE if successful
Memory   : None
Example  :


#include "4th.h"
#include <stdlib.h>

#ifndef ARCHAIC
  int main (int argc, char **argv)
#else
  int main (argc, argv) int argc; char **argv;
#endif

{
  Hcode *object;
  char *sources;

  if (argc == 2)
    {
      if ((sources = open_4th (argv [1])) == NULL)
         printf ("Loading; \'%s\' does not exist or too large\n", argv [1]);
      else
        {
          object = comp_4th (sources);
          printf ("Compile; word %u: %s\n", object->ErrLine,
                 errs_4th [object->ErrNo]);
          if (! dump_4th (object, stdout, 0, -1))
              return (EXIT_SUCCESS);
        }
    }
  return (EXIT_FAILURE);
}


Input    : None
Output   : depends on program
Related  : comp_4th(), exec_4th()
*/

#ifdef USRLIB4TH
#include <4th.h>
#include <sys/cmds_4th.h>
#else
#include "4th.h"
#include "cmds_4th.h"
#endif

#include <stdarg.h>

#define Header "\
4tH message: %s at word %d\n\
Object size: %u words\n\
String size: %u chars\n\
Variables  : %u cells\n\
Strings    : %u chars\n\
Symbols    : %u names\n\
Reliable   : %s\n\n"

static char WriteError;


/*
This function searches the symboltable for a certain opcode and operand and
returns the name if it is found. If no symbols have been defined, either
because there is no symboltable or no such entry, it returns NULL.
*/

#ifndef ARCHAIC
  char *SearchSymbol (Hcode* Object, unit Opcode, cell Operand)
#else
  char *SearchSymbol (Object, Opcode, Operand) Hcode* Object; unit Opcode;
                      cell Operand;
#endif

{
  int x;

  for (x = 0; x < Object->Symbols; x++)
      if ((Object->SymTable [x].Token == Opcode) &&
         (Object->SymTable [x].Value == Operand))
         return (Object->SymTable [x].Name);

  return (NULL);
}


/*
This function tries to resolve strings or labels from either the symboltable
or the string segment. It returns NULL if no label could be attached.
*/

#ifndef ARCHAIC
  char *GetLabel (Hcode* Object, int addr) 
#else
  char *GetLabel (Object, addr) Hcode* Object; int addr;
#endif

{
  cell  val =  Object->CodeSeg [addr].Value;
  char *Label;
                                       /* preload dictionary operands */
  switch (Object->CodeSeg [addr].Word)
    {                                  /* resolve word names */
      case BRANCH:   if ((Label = SearchSymbol (Object, CALL, addr)) != NULL)
                        return (Label);
      case CALL:     return (SearchSymbol (Object, CALL, val));
      case VECTOR:                     /* resolve this one for BRANCH too */
      case TO:
      case VALUE:                      /* resolve variable names */
      case VARIABLE: if ((Label = SearchSymbol (Object, TO, val)) != NULL)
                        return (Label);
                     if ((Label = SearchSymbol (Object, VALUE, val)) != NULL)
                        return (Label);
                     if ((Label = SearchSymbol (Object, VECTOR, val)) != NULL)
                        return (Label);
                     return (SearchSymbol (Object, VARIABLE, val));
      case OFFSET:   return (SearchSymbol (Object, OFFSET, val));
      case PRINT:
      case SQUOTE:                     /* string literals */
      case STRINGD:  return ((Object->StringSeg) ?
                        Object->StringSeg + (int) val : NULL);
      default:       return (NULL);    /* nothing works, NULL is returned */
    }
}


/*
This function does the actual writing of the listing to the device. If an
error occurs, it sets WriteError, which prevents further writing.
*/

#ifndef ARCHAIC
  static void WriteList (FILE *SourceFp, char *Format, ...)
#else
  static void WriteList (SourceFp, Format) FILE *SourceFp; char* Format;
#endif

{
  va_list  (args);
  va_start (args, Format);

  if (! WriteError)
     if (vfprintf (SourceFp, Format, args) == 0) WriteError = TRUE;

  va_end (args);
}


#ifndef ARCHAIC
  char dump_4th (Hcode* Program, FILE *Output, int First, int Last)
#else
  char dump_4th (Program, Output, First, Last) Hcode* Program; FILE* Output;
                 int First; int Last;
#endif

{
  int x, y;                            /* decompiling range */
  char *Label;                         /* pointer to optional label */

  if (! Program) return (TRUE);        /* check if there is an object */
  else WriteError = FALSE;             /* reset error flag */

  x = ((First < 0) ? 0 : First);       /* set boundaries */
  y = (((Last < x) || (Last > Program->CodeSiz)) ? Program->CodeSiz : Last);

  WriteList (Output, Header, errs_4th [Program->ErrNo], Program->ErrLine,
             Program->CodeSiz, Program->StringSiz, Program->Variables,
             Program->Strings, Program->Symbols,
             Program->Reliable ? "Yes" : "No"
  );

  if (x < y)                           /* show header only if opcodes */
     WriteList (Output, "%6s| %-24s %12s   %s\n\n", "Addr", "Opcode",
               "Operand", "Argument");

  while (x < y)                        /* show upcodes */
    {
      Label = GetLabel (Program, x);   /* try to obtain a label */
      WriteList (Output, "%6d| %-24s %12ld%s%s\n", x,
                 (Program->CodeSeg [x].Word > LastWord4th) ?
                 name_4th [NOOP] : name_4th [Program->CodeSeg [x].Word],
                 Program->CodeSeg [x].Value, (Label == NULL) ? "" : "   ",
                 (Label == NULL) ? "" : Label);
      x++;
    }

  return (WriteError);
}
