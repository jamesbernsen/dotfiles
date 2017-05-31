# Vim Quick Reference #

## Common Commands ##

_ProVim:_
> Most of what we do within Vim is the result of executing a command. Commands take many forms, such as single-line, mapped, and editing commands. 

| Command / Key         | Description
| --------------------- | ---
| :h *command*          | Get help on a Vim command
| `<C-i>` or `<C-]>`    | "Jump *In*" - Follow a "tag" (hyperlink; indicated by a plus sign)
| `<C-o>` or `<C-t>`    | "Jump *Out*" - Return to previous location after following a tag.
| gx                    | Open the URL under the cursor in a web browser
| | |
| :new *[filename]*     | Open a new buffer (optionally providing a *filename*) in a new horizontal split
| :enew *[filename]*    | Open a new buffer (optionally providing a *filename*) in the current viewport
| :vnew *[filename]*    | Open a new buffer (optionally providing a *filename*) in a new vertical split
| :tabnew *[filename]*  | Open a new buffer (optionally providing a *filename*) in a new tab
| :Scratch              | Open a scratch buffer (requires __scratch.vim__ plugin)
| | |
| :e *path*             | Edit a file in a new buffer
| :read *path*          | Read the contents of a file (at *path*) into our current buffer
| :read !*cmd*          | Read the output of a shell command (*cmd*) into our current buffer
| | |
| :pwd                  | List Vim's working directory
| :cd *path*            | Change Vim's working directory to *path*
| :set fileformat=*fmt* | Change the format of a file to *fmt*, which can be `dos`, `unix`, or `mac`
| | |
| :w                    | Write the current buffer to a file
| :wq                   | Write the current buffer to a file and close the buffer
| :q                    | Close the current buffer
| :q!                   | Close the current buffer, ignoring any warning about loss of data
| :qa                   | Close all buffers
| :wqa                  | Write all buffers and close them all


### Cursor, Page, and Window Motion ###

| Keystroke            | Mode Name
| -------------------- | ---
| h                    | Moves the cursor left
| j                    | Moves the cursor down
| k                    | Moves the cursor up
| l                    | Moves the cursor right
| | |
| `<C-u>`              | Move half page up
| `<C-d>`              | Move half page down
| `<C-b>`              | Move one page up
| `<C-f>`              | Move one page down
| | |
| zt                   | Shift page so current line sits at the top of the viewport
| zz                   | Shift page so current line sits at the middle of the viewport
| zb                   | Shift page so current line sits at the bottom of the viewport
| | |
| H                    | Move cursor to the top of the viewport
| M                    | Move cursor to the middle of the viewport
| L                    | Move cursor to the bottom of the viewport
| | |
| `<C-w>` w            | Cycle cursor through windows
| `<C-w>` *direction*  | Move cursor to a window above, below, to the left, or to the right (as indicated by *direction* key) of the current window
| `<C-w>` p            | Move cursor to the previous (last accessed) window
| `<C-w>` r            | Rotate window positions
| `<C-w>` +            | Increase the height of the current window
| `<C-w>` -            | Decrease the height of the current window
| `<C-w>` =            | Equalize the heights of all windows (within constraints)
| `<C-w>` &lt;         | Decrease the width of the current window
| `<C-w>` &gt;         | Increase the width of the current window


### Modes ###

_ProVim:_
> Vim starts up in NORMAL mode, and to switch between modes, you must first press the `<Esc>` key, followed by the relevant keystroke that triggers the mode you want to enter into.

| Keystroke              | Mode Name
| ---------------------- | ---
| `<Esc>`                | NORMAL
| i &#124; a             | INSERT (*before* or *after* the cursor position, respectively)
| I &#124; A             | INSERT (*beginning* or *end* of the current line, respectively)
| v &#124; V             | VISUAL (*character mode* or *line mode*, respectively)
| R                      | REPLACE
| :                      | COMMAND-LINE
| `<C-v>` &#124; `<C-q>` | VISUAL-BLOCK
| `<C-c>`                | Drop from VISUAL-BLOCK to NORMAL mode, **without** applying changes
| | |
| q:                     | *Command-Line-Window*\*

\*While not a mode in its own right, the *command-line-window* can be used to view all of the recently-entered commands, select them, edit them, and re-execute them.


### Editing Commands ###
_ProVim:_
> Commands for editing content are used primarily within NORMAL mode. These commands are made up of counts, operators, and motions:
>
> `[count] {operator} {[count] motion|text object}`
> 
> - An editing command can be considered a "container" of counts, operators, and motions or text objects.
> - In the preceding command structure, we can see that a command can start with a "count" (which is an optional numerical value) and is used to indicate how many times the following operator is executed.
> - Either a "motion" or a "text object" can follow the operator, and if it is a motion, it can also accept a preceding optional count, which informs Vim how many times the motion should be applied.

#### Operators ####

| Operator          | Description
| ----------------- | ---
| yy                | Yank (copy) the entire line
| y {*motion*}      | Yank (copy) the selected text
| x                 | Cut a character (or selection)
| dd                | Cut an entire line
| d {*motion*}      | Cut the selected text
| D                 | Cut from the cursor to the end of the line (same as d$)
| P &#124; p        | Paste content (*before* or *after* the current cursor position, respectively)
| | |
| f &#124; F *char* | Find a character *char* (*forward* or *backward* from the cursor, respectively), placing the cursor at that position
| t &#124; T *char* | Find a character *char* (*forward* or *backward* from the cursor, respectively), placing the cursor beside it (to the *left* or *right* of it, respectively)
| | |
| O &#124; o        | Create a new line (*before* or *after* the current cursor position, respectively) and change to INSERT mode
| c {*motion*}      | Change the character (or selection) and change to INSERT mode
| S &#124; s        | Substitute the entire line (or *character/selection*, respectively) and change to INSERT mode
| | |
| u &#124; U        | Undo the last edit (*multi-undo* or *single-undo/redo*, respectively)
| `<C-r>`           | Redo the last edit (*multi-redo*)
| | |
| gu {*motion*}     | Change a character (or selection) to lowercase
| gU {*motion*}     | Change a character (or selection) to uppercase
| ~                 | Change the case of a letter
| | |
| .                 | Repeats the last INSERT edit


#### Motions ####

| Motion        | Description
| ------------- | ---
| 0             | Moves cursor to the start of the line
| $             | Moves cursor to the end of the line (inclusive of newline)
| g\_           | Moves cursor to the end of the line (exclusive of newline)
| b             | Moves cursor backward through each word
| e             | Moves cursor to the end of the word
| w             | Moves cursor to the start of the next word
| [*count*] gg  | Moves cursor to a specific line indicated by *count* or (if *count* is empty) to the start of the buffer
| [*count*] G   | Moves cursor to a specific line indicated by *count* or (if *count* is empty) to the end of the buffer
| %             | Moves cursor to the next bracket (or parenthesis)
| (             | Moves cursor to the previous sentence
| )             | Moves cursor to the next sentence
| {             | Moves cursor to the start of a paragraph
| }             | Moves cursor to the end of a paragraph
| [(            | Moves cursor to previous available parenthesis
| ])            | Moves cursor to next available parenthesis
| [{            | Moves cursor to previous available bracket
| ]}            | Moves cursor to next available bracket


#### Text Objects ####

> The syntax structure of a text object looks like the following:
> 
> `{special motion} {object}`
>
> Text objects are commands that require you to first specify one of two special motions (only available to text objects), followed by the object itself. The motions are "inside" (i) and "around" (a), followed by the object itself. 

| Type           | Name       | Key                          | Description
| -------------- | ---------- | ---------------------------- | ---
| special motion | Inside     | `i`                          | Selects inside the object (excludes whitespace)
| special motion | Outside    | `o`                          | Selects around the object (includes whitespace)
| | | |
| object         | Word       | `w`                          | Selects a single word
| object         | Sentence   | `s`                          | Selects a single sentence
| object         | Paragraph  | `p`                          | Selects a single paragraph
| object         | Tag        | `t`                          | Selects a single XML/HTML markup tag
| object         | Quote      | `"` or `'` or `` ` ``        | Selects content inside/around quotation marks 
| object         | Block      | `{}` or `[]` or `<>` or `()` | Selects content inside/around a block (excludes whitespace)


## Searching ##

| Command               | Description
| --------------------- | ---
| / &#124; ? *regex*    | Search for text using the [Vim regular expression](http://vimregex.com) pattern *regex* (*forward* or *backward* from the cursor, respectively)
| n &#124; N            | Find the next match (*forward* or *backward* from the cursor, respectively)
| \* &#124; #           | Search for the word on which the cursor currently rests (*forward* or *backward*, respectively)
| :noh                  | Clear match highlighting for the current search
| [*range*]`s/`*pattern*`/`*replacement*`/`[*flags*] | Within *range*, search for text matching *pattern* and replace it with *replacement*. The range `%` would indicate the entire buffer.


## Buffers, Windows, and Tabs ##

_ProVim:_
> When you open a file in Vim and start editing it, you are, in fact, only editing a "copy" of the file. The file has actually been opened into a "buffer," and that buffer is just a chunk of memory allocated to holding a copy of the file you wanted to edit.
>
> Buffers have multiple states: active, hidden, and inactive. If the buffer is currently visible inside the viewport, it is considered to be active. If the buffer is not visible, it's considered hidden. If you have an empty buffer (i.e., it has no file read in), and it's not visible, the buffer is considered inactive.

| Command           | Description
| ----------------- | ---
| :bn               | Move to the next buffer
| :bp               | Move to the previous buffer
| :b*n*             | Move to the *n*th buffer
| :ls               | List all of the available buffers
| :b#               | Switch to the alternate (last) buffer
| :bd #             | Delete buffer with number # (using numbers from :ls command)
| :bufdo *cmd*      | Perform a command (*cmd*) on all buffers
| | |
| :sb *#*           | Create a split with an existing buffer (identified by *#*)
| :sp [*file*]      | Horizontally split the current buffer (or load *file* into a split)
| :vs [*file*]      | Vertically split the current buffer (or load *file* into a split)
| | |
| :tabnew           | Open a new tab
| :tabe *file*      | Edit a file in a new tab
| gt &#124; :tabn   | Move to the next tab
| gT &#124; :tabp   | Move to the previous tab
| :tabc             | Close a tab
| :tabmove *#*      | Move the current tab to the position indicated by *#*
| :tabonly          | Close all tabs except the current one
| | |
| `<C-w>` T         | Move the current window to its own tab


## File Modifiers ##
In place of most command arguments that take a *path*, it's possible to substitute a command modifier.

| Modifier  | Description
| --------- | ---
| %         | Filename of the current buffer
| %:p       | Full path and filename of the current buffer
| %:p:h     | Full path (minus "head", or filename) of the current buffer


## Registers ##
Used for temporary data storage (and other neat tricks)

| Register | Description
| -------- | ---
| "        | Default register (eg. where cut or yanked text is stored)
| 0-9, a-z | Named registers for users to store data temporarily
| A-Z      | Not true registers, storing data in these registers *appends* this data to the corresponding named register
| .        | Read-only register containing the last inserted text
| :        | Read-only register containing the last-executed command
| %        | Read-only register containing the current file path
| #        | Read-only register containing the *alternate* file
| =        | Expression register (used for evaluating expressions)
| /        | Search register containing the last-searched text
| -        | The "small-delete" register

Commands frequently used when working with registers:

| Command          | Description
| ---------------- | ---
| :reg             | Display the contents of Vim's registers
| " {*reg-id*} p   | Paste the content of the register identified by *reg-id*. (eg. `"4p` pastes the content of register 4)
| " {*reg-id*} y   | Yank text into the register identified by *reg-id*. (eg. `"xy` yanks selected text, placing it into register x). If *reg-id* is an uppercase letter, the text will be **appended** into the named register.
| :put {*reg-id*}  | Write the contents of register *reg-id* to the buffer
| `<C-r>` *reg-id* | **From the expression register or INSERT mode**: paste the content of the register identified by *reg-id*
| `<C-r> =`        | **From INSERT mode**: enter the expression register


## Macros ##

| Command                  | Description
| -------------------------| ---
| q {*reg*} {*commands*} q | Record into register *reg* a macro consisting of *commands*
| [*n*] @ {*reg*}          | Execute the macro stored in register *reg*, *n* times
| [*n*] @@                 | Execute a macro from the last-executed register, *n* times, *n* times

Note: You can append to an existing stored macro by recording with the uppercase version of its named register. It's also possible to edit a macro by writing it to the buffer (:put *reg-id*), editing it, and yanking it back into a register.


## Configuration ##

| Command          | Description
| ---------------- | ---
| :scriptnames     | List all configuration files sourced by vim in the order in which they were sourced.
| :echo *variable* | Displays an environment variable
| | |
| :nmap            | List keybindings for NORMAL mode
| :vmap            | List keybindings for VISUAL mode
| :imap            | List keybindings for INSERT mode
| :map             | List keybindings for all modes
| :h index         | List default keybindings (in the help)


## .vimrc ##

| Syntax                  | Description
| ----------------------- | ---
| set runtimepath+=*path* | Add another configuration directory to runtimepath
| runtime *filename*      | Sources the specified file *filename*
| runtime *fileglob*      | Sources the files matching *fileglob* in alphabetical order


