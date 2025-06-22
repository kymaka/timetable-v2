package consts

type RoomType string

type SubjectType string

const (
	RoomTypeSmall = RoomType("small")
	RoomTypeBig   = RoomType("big")

	SubjectTypeTheory    = SubjectType("theory")
	SubjectTypePractical = SubjectType("practical")
)
