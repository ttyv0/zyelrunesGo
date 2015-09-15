package main

import (
	"database/sql"

	_ "github.com/mattn/go-sqlite3"

	"gopkg.in/qml.v1"
)

func main() {
	if err := qml.Run(run); err != nil {
		panic(err)
	}
}

func run() error {
	engine := qml.NewEngine()
	runesModel := &RuneNames{}
	runewordModel := &RunewordModel{}
	context := engine.Context()
	context.SetVar("runesModel", runesModel)
	context.SetVar("runewordModel", runewordModel)
	component, err := engine.LoadFile("main.qml")
	if err != nil {
		return err
	}

	dbname := "zyelrune.sqlite"
	db, err := sql.Open("sqlite3", dbname)
	if err != nil {
		return err
	}

	rows, err := db.Query("select rune from runes")
	if err != nil {
		return err
	}
	tempRuneNames := make([]string, 0)
	for rows.Next() {
		var runeName string
		rows.Scan(&runeName)
		tempRuneNames = append(tempRuneNames, runeName)
	}
	rows.Close()
	runesModel.create(tempRuneNames)
	runewordModel.db = db
	runewordModel.Query("select * from zyel")

	window := component.CreateWindow(nil)
	window.Show()
	window.Wait()
	return nil
}

type RuneNames struct {
	list []string
	Len  int
}

func (r *RuneNames) create(l []string) {
	r.list = l
	r.Len = len(l)
	qml.Changed(r, &r.Len)
}
func (r *RuneNames) Name(index int) string {
	return r.list[index]
}

type RunewordModelRow struct {
	name, items, runes, character string
	level, number                 int
}

type RunewordModel struct {
	//items, level, runes
	list []RunewordModelRow
	Len  int
	db   *sql.DB
}

func (rwm *RunewordModel) Query(query string) error {
	rows, err := rwm.db.Query(query)
	if err != nil {
		return err
	}
	tempRunewords := make([]RunewordModelRow, 0)
	for rows.Next() {
		var name, items, runes, character, warning string
		var id, level, number int
		rows.Scan(&id, &name, &items, &level, &runes, &character, &warning, &number)
		tempRunewords = append(tempRunewords,
			RunewordModelRow{name, items, runes, character, level, number})
	}
	rows.Close()
	rwm.list = tempRunewords
	rwm.Len = len(rwm.list)
	qml.Changed(rwm, &rwm.Len)
	return nil
}

func (rwm *RunewordModel) Items(index int) string {
	return rwm.list[index].items
}
func (rwm *RunewordModel) Level(index int) int {
	return rwm.list[index].level
}
func (rwm *RunewordModel) Runes(index int) string {
	return rwm.list[index].runes
}
