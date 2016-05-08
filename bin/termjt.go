package main

import (
	"flag"
	"fmt"
	gc "github.com/gbin/goncurses"
	"io/ioutil"
	"os"
	"regexp"
	"strings"
	"syscall"
	"unicode/utf8"
)

type state struct {
	matches  map[int]*section
	content  string
	selected string
	index    map[rune]*section
}

type section struct {
	begin int
	end   int
}

func main() {
	filename := flag.String("outputFilename", "output file", "File to output selected contents to")
	rf := flag.String("regexp", "(?m)\\S{10,}", "Regular expression to tokenize on")
	flag.Parse()

	stats, err := os.Stdin.Stat()
	if err != nil {
		fmt.Println("file.Stat()", err)
		return
	}

	if stats.Size() < 0 {
		fmt.Println("Nothing on STDIN")
		return
	}

	b, err := ioutil.ReadAll(os.Stdin)
	runes := ""
	bc := b
	for len(bc) > 0 {
		r, size := utf8.DecodeLastRune(bc)
		runes = string(r) + runes
		bc = bc[:len(bc)-size]
	}

	if err != nil {
		fmt.Println("STDIO error", err)
		return
	}

	f, err := os.Open("/dev/tty")
	if err != nil {
		fmt.Println("Error reopening /dev/tty", err)
		return
	}

	err = syscall.Dup2(int(f.Fd()), 0)
	if err != nil {
		fmt.Println("Error Dup2", err)
		return
	}

	stdscr, _ := gc.Init()
	defer gc.End()

	s := state{
		content:  string(runes),
		selected: "",
		matches:  map[int]*section{},
		index:    map[rune]*section{},
	}

	r := regexp.MustCompile(*rf)
	indexes := r.FindAllStringIndex(string(runes), -1)
	ascii := 'A'
	for index := range indexes {
		sc := section{begin: indexes[index][0], end: indexes[index][1]}
		s.matches[sc.begin] = &sc
		s.index[ascii] = &sc
		ascii++
	}

	UpdateScreen(&s, stdscr)

	for {
		ch := stdscr.GetChar()

		if ch == 27 {
			return
		}

		if ch == gc.KEY_RETURN {
			gc.End()
			b := ""
			for _, c := range s.selected {
				b += s.content[s.index[c].begin:s.index[c].end] + " "
			}
			fmt.Println(b)
			ioutil.WriteFile(*filename, []byte(b), 0644)
			return
		}

		if strings.Contains(s.selected, string(ch)) {
			// Remove
			s.selected = strings.Replace(s.selected, string(ch), "", -1)
		} else {
			// Add
			s.selected += string(ch)
		}
		UpdateScreen(&s, stdscr)
	}
}

func UpdateScreen(s *state, stdscr *gc.Window) {
	stdscr.Clear()
	var last_found *section
	var ascii rune
	for i := 0; i < len(s.content); i++ {
		found := s.matches[i]
		if found != nil {
			last_found = found
			// Print the associated key instead of the real letter
			stdscr.AttrOn(gc.A_BOLD)
			for k, v := range s.index {
				if found == v {
					ascii = k
					break
				}
			}
			stdscr.Print(string(ascii))
			stdscr.AttrOff(gc.A_BOLD)
		} else {
			// Print the real letter, in bold if selected
			if last_found != nil && i >= last_found.begin && i <= last_found.end && strings.Contains(s.selected, string(ascii)) {
				stdscr.AttrOn(gc.A_BOLD)
			}
			ch := string(s.content[i])
			stdscr.Print(ch)
			stdscr.AttrOff(gc.A_BOLD)
		}
	}

	stdscr.Refresh()
}
