# ibustablelayouteditor

**ibustablelayouteditor** is a rather simple editor for [ibus-table](https://en.wikipedia.org/wiki/Intelligent_Input_Bus#ibus-table) keyboard layouts.

It helps you write a plain text description file that can be used by ibus to install a new keyboard layout.

It is written in [Lazarus](https://www.lazarus-ide.org/) using only standard components.

The program: 

![ibustablelayouteditor screenshot](https://oderalon.net/wiki/images/a/a4/ibustablelayouteditor_screenshot.png)

The resulting plain text file:

<pre>
### File header must not be modified
### This file must be encoded in UTF-8.
###
###
SCIM_Generic_Table_Phrase_Library_TEXT
VERSION_1_0
BEGIN_DEFINITION
UUID = E4FEB5D2-CEFF-4F9A-8CAA-7A78752E91EF
SERIAL_NUMBER = 20210321120446683
ICON = /home/keyboards/coptic.png
SYMBOL = Ⲁ
STATUS_PROMPT = Ⲁ
NAME = ⲧⲙⲛ̄ⲧⲣⲙ̄ⲛ̄ⲕⲏⲙⲉ (Coptic)
LANGUAGES = cop
VALID_INPUT_CHARS =='"1!¹2@²3#³4$£5%¢6¨¬7&8*9(0)-_=+§qQwWeE€rRtTyYuUiIoOpP`[{ªaAsSdDfFgGhHjJkKlLçÇ~^]}º\|zZxXcCvVbBnNmM,<.>;:/?°
DESCRIPTION = Basic Coptic Keyboard
AUTHOR = QVASIMODO <sld@oderalon.net>
COMMIT_KEYS = space,Return
PAGE_DOWN_KEYS = Page_Down
PAGE_UP_KEYS = Page_Up
SELECT_KEYS = F1,F2,F3,F4,F5,F6,F7,F8,F9
LICENSE = LGPL
MAX_KEY_LENGTH = 6
AUTO_COMMIT = TRUE
AUTO_SELECT = FALSE
DEF_FULL_WIDTH_PUNCT = FALSE
DEF_FULL_WIDTH_LETTER = FALSE
USER_CAN_DEFINE_PHRASE = FALSE
PINYIN_MODE = FALSE
DYNAMIC_ADJUST = FALSE
ORIENTATION = FALSE
LAYOUT = br_nodeadkeys
AUTO_WILDCARD = TRUE
AUTO_SPLIT = TRUE
ALWAYS_SHOW_LOOKUP = TRUE
AUTO_FILL = FALSE
USE_FULL_WIDTH_PUNCT = FALSE
USE_FULL_WIDTH_LETTER = FALSE
END_DEFINITION

BEGIN_TABLE
a	ⲁ	0
b	ⲃ	0
c	ⲭ	0
d	ⲇ	0
e	ⲉ	0
f	ϥ	0
g	ⲅ	0
h	ϩ	0
i	ⲓ	0
j	ϫ	0
k	ⲕ	0
l	ⲗ	0
m	ⲙ	0
n	ⲛ	0
o	ⲟ	0
p	ⲡ	0
q	ⲑ	0
r	ⲣ	0
s	ⲥ	0
t	ⲧ	0
u	ⲩ	0
v	ⲫ	0
w	ⲱ	0
x	ϣ	0
y	ⲏ	0
z	ⲍ	0
END_TABLE
</pre>
