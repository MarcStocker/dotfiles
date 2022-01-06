"===========  'Set' Commands  ===========
syntax enable
colorscheme desert
set background=dark
set backspace=indent,eol,start  " Backspace behaves like Word
set backspace=2   " does something to help backspace work better
set mouse=a       " use mouse to place cursor - Gives ability to click where you want to type.
set nocompatible  " dont try to be vi compatible -- vim has lots to offer
set number        " Turn on line numbers
set autoindent    " turn on automatic indentation
set tabstop=2     " set tabs to be 2 characters wide
set shiftwidth=2  " similar to tabstop(most likely for autoindent)
set expandtab     " Replace tabs with spaces (2 spaces since tabstop = 2)
set showmode      " puts insert message at bottom on screen when inserting
set ruler         " show the cursor position all the time

"================  Assign new Comands  ================  
" The following imaps are hotkeys to Esc to reenter 
"  Command mode without having to move your fingers
imap jk <esc>
imap kk <esc>
imap jj <esc>
imap kj <esc>
imap hh <esc>
imap ZZ <esc>ZZ
" ^ Maps ZZ while in insert mode to <esc> ZZ for quick save and quit
" ZZ is a command shortcut for 'Save and Quit' or :wq
" ZQ is 'Quit without Saving' or :q

" Insert all content needed for colorful shell script output
imap //colors 
	\# Terminal output control (http://www.termsys.demon.co.uk/vtansi.htm) <CR>
  \# Taken from https://gist.github.com/bcap/5682077#file-terminal-control-sh <CR>
	\TC='\e[' <CR>
  \<CR>
	\CLR_LINE_START="${TC}1K" <CR>
	\CLR_LINE_END="${TC}K" <CR>
	\CLR_LINE="${TC}2K" <CR>
	\<CR>
	\# Hope no terminal is greater than 1k columns <CR>
	\RESET_LINE="${CLR_LINE}${TC}1000D" <CR>
	\<CR>
	\# Colors and styles (based on https://github.com/demure/dotfiles/blob/master/subbash/prompt) <CR>
	\<CR>
	\Bold="${TC}1m"    # Bold text only, keep colors <CR>
	\Undr="${TC}4m"    # Underline text only, keep colors <CR>
	\Inv="${TC}7m"     # Inverse: swap background and foreground colors <CR>
	\Reg="${TC}22;24m" # Regular text only, keep colors <CR>
	\RegF="${TC}39m"   # Regular foreground coloring <CR>
	\RegB="${TC}49m"   # Regular background coloring <CR>
	\Rst="${TC}0m"     # Reset all coloring and style <CR>
	\<CR>
	\# Basic            High Intensity      Background           High Intensity Background 	<CR>
	\Black="${TC}30m";  IBlack="${TC}90m";  OnBlack="${TC}40m";  OnIBlack="${TC}100m"; 			<CR>
	\Red="${TC}31m";    IRed="${TC}91m";    OnRed="${TC}41m";    OnIRed="${TC}101m"; 				<CR>
	\Green="${TC}32m";  IGreen="${TC}92m";  OnGreen="${TC}42m";  OnIGreen="${TC}102m"; 			<CR>
	\Yellow="${TC}33m"; IYellow="${TC}93m"; OnYellow="${TC}43m"; OnIYellow="${TC}103m";			<CR>
	\Blue="${TC}34m";   IBlue="${TC}94m";   OnBlue="${TC}44m";   OnIBlue="${TC}104m"; 			<CR>
	\Purple="${TC}35m"; IPurple="${TC}95m"; OnPurple="${TC}45m"; OnIPurple="${TC}105m"; 		<CR>
	\Cyan="${TC}36m";   ICyan="${TC}96m";   OnCyan="${TC}46m";   OnICyan="${TC}106m"; 			<CR>
	\White="${TC}37m";  IWhite="${TC}97m";  OnWhite="${TC}47m";  OnIWhite="${TC}107m"; 			<CR>
	\<CR>
	\#examples <CR>
	\echo "${Bold}${Red}bold red on ${OnBlue}blue background,${RegB} now back to regular background, ${RegF}regular foreground and ${Reg}regular text" <CR>
	\echo "${Bold}${Undr}${Green}You can reset this whole style in one${Rst} command" <CR>
" echo -n "${Bold}${Blue}${OnWhite}bold blue text on white background${Rst}"; sleep 3; echo "${RESET_LINE}${Red}${OnYellow}becomes red text on yellow background${Rst}" <CR>

cnoremap ,, <esc>:wa<CR>
nnoremap ,, <esc>:wa<CR>
cnoremap ,/ <esc>:make<CR>
nnoremap ,/ <esc>:make<CR>
cnoremap ., <esc>:make clean<CR>
nnoremap ., <esc>:make clean<CR>
cnoremap // <esc>:sh<CR>
nnoremap // <esc>:sh<CR>

"set ai       " turn on automatic indentation
"set ts=2     " set tabs to be 2 characters wide
"set et       " replace tabs with spaces (2 spaces since ts=2)

" redefine ^J ^H ^K ^L to move between windows (used w/split screens)


" ============================================================== Don't know what thats here, ill figure it out later
" Switch syntax highlighting on, when the terminal has colors
"if &t_Co > 2 || has("gui_running")
"  syntax on
"endif

" turn on syntax highligting for .gpl files (CSCI 515 project)
au BufRead,BufNewFile *.gpl set filetype=gpl
"colorscheme elflord
" ================================================================Must be for another class from my professor





"==============================  Auto Fill Specific Files ==============================  
" Define F2 to autofill .cpp files
"                                      this is a new command, so while in command mode, this will excute this string of keypresses
map #2 Giint main()<CR>{<CR><CR><CR><CR>return 0;<Esc>kkkA
" jump to first line where coding begins in .h files
map #3 /private<esc>jA
" Define F3 to autofill .h files
" map #3 G{<CR>private:<CR><CR><CR>public:<CR><tab><CR><esc>GA;<CR><CR>#endif<esc>kkkkkkkA<tab><tab>

"{ <enter> auto fills into :
"  { <enter> 
"    <tab> <<curser lands here>> 
"  }
inoremap {<CR> {<CR>}<Esc>ko<space><space>

autocmd FileType make set noexpandtab|set autoindent " Make files get actual tabs and not spaces


"  The following are automatic headers for .cpp and .h files
" =============================================================================
"   /* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
"   * File Name : This.cpp
"   * Purpose : To excute commands and take input
"   * Creation Data : MM/DD/YYYY
"   * Last Modified : Day of Week, MM DD, YYYY XX:XX:XX AM/PM "  
"   * Created By : Marc Stocker 
"   _._._._._._._._._._._._._._._._._._._._._.*/
" =============================================================================
" The following is found at this address
" http://www.thegeekstuff.com/2008/12/vi-and-vim-autocommand-3-steps-to-add-custom-header-to-your-file/

" add a header to all *.cpp files, and update last modified 
autocmd bufnewfile *.cpp so /home/Marc/Files_for_Vimrc/.cpp_header.txt
autocmd bufnewfile *.cpp exe "1," . 8 . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.cpp exe "1," . 8 . "g/Creation Date :.*/s//Creation Date : " .strftime("%m-%d-%Y")
autocmd Bufwritepre,filewritepre *.cpp execute "normal ma"
autocmd Bufwritepre,filewritepre *.cpp exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.cpp execute "normal `a"

" add a header to all *.h files
autocmd bufnewfile *.h so /home/Marc/Files_for_Vimrc/.h_header.txt
autocmd bufnewfile *.h exe "2," . 11 . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.h exe "3," . 11 . "g/Creation Date :.*/s//Creation Date : " .strftime("%m-%d-%Y")
autocmd bufnewfile *.h exe "1," . 17 . "g/class.*/s//class " .expand("%:t:r")
autocmd bufnewfile *.h exe "1," . 11 . "g/#ifndef.*/s//#ifndef " .toupper(expand("%:t:r:")) ."_H"
autocmd bufnewfile *.h exe "1," . 11 . "g/#define.*/s//#define " .toupper(expand("%:t:r:")) ."_H"
autocmd Bufwritepre,filewritepre *.h exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.h execute "normal `a"

"   ____________________________________   The Above commands (for .cpp) are explained below    ______________________________________
"
"  The '.' that come before and after expand() and strftime() seem to act like cout's arrows << to separate different commands
" 
" Line 1 defines the template file. This indicates that for *.c file, /home/jsmith/c_header.txt template file should be used.
" Line 2 will search for the pattern from the 1st line to 8th line. If found, it will write the current filename in that line.
" Line 3 will update the Creation Date field.
" Line 5 will update the Last Modified field with the current date and time when you save the file.
" Line 4 & 6: While saving the file, the cursor will move to the (because of last write operation). If you want the cursor back to the previous position then, you need to add Line 4 and 6 to the .vimrc file.
" Line 4 will mark the current cursor position before updating.
" Line 6 will restore the cursor position back to its previous position.
"
" Each line is basically a find and replace vim command-line command
"   g/    jumps to any line in the file with a matching string
"   .*    is same as until end of line
"   s//   Replace entire line with following string 
"
" The following command would jump to any line (between 124,130) containing 'hello world! You're the best!' 
" and replace 'best!' with 'worst! }:9'

"   126,130g/hello.*/s/best!/worst! }:9


" hello world! You're the best!      Go ahead, test the above command. Only the word best should change in the string


