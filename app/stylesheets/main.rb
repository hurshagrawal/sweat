Teacup::Stylesheet.new :main do
  style :activity_table_view,
    rowHeight: 60

  style :input,
    font: UIFont.systemFontOfSize(18)

  style :new_activity_input, extends: :input,
    placeholder: "Add exercise...",
    top: 0, left: 10,
    width: 200, height: 30

  style :exercise_name,
    font: UIFont.systemFontOfSize(16)

  style :activity_exercise_name, extends: :exercise_name,
    text: "Exercise name",
    top: 0, left: 10,
    width: 200, height: 30

  style :new_activity_exercise_name, extends: :exercise_name,
    text: "Exercise name",
    top: 0, left: 10,
    width: 200, height: 30

  style :set_info,
    font: UIFont.systemFontOfSize(12),
    text: "65x5 95x5 115x5x3",
    top: 30, left: 10,
    width: 200, height: 30

end