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


