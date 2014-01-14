Teacup::Stylesheet.new :main do
  style :daily_exercise_table_view,
    rowHeight: 80

  style :input,
    font: UIFont.systemFontOfSize(18)

  style :new_exercise_type_input, extends: :input,
    placeholder: "Add exercise...",
    top: 0,
    left: 10,
    width: 200,
    height: 30,
    keyboardType: UIKeyboardTypeDefault,
    returnKeyType: UIReturnKeyNext


  style :exercise_name,
    font: UIFont.systemFontOfSize(16)

  style :set_info,
    font: UIFont.systemFontOfSize(12)

  style :exercise_type_name,
    font: UIFont.systemFontOfSize(16),
    top: 0,
    left: 10,
    width: 200,
    height: 30

end
