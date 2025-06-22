package types

import "github.com/kymaka/timetable-v2/internal/pkg/consts"

type Constraint struct {
	Rooms    []Room
	Weekdays []Weekday
	Periods  []Period
	Groups   []Group
	Subjects []Subject
	Teachers []Teacher
}

type Room struct {
	Number string
	Type   consts.RoomType
}

type Weekday struct {
	Name string
}

type Period struct {
	Name string
}

type Group struct {
	Name     string
	Subjects []Subject
}

type Subject struct {
	Name         string
	Type         consts.SubjectType
	WeeklyRepeat int
}

type Teacher struct {
	Name    string
	Subject Subject
}
